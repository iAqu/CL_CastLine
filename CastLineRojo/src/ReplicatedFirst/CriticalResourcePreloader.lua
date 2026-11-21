local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Preloader = {}
local WAIT_SECONDS = 5
local BACKGROUND_BATCH_SIZE = 24
local phase = "Idle"
local deadline = 0
local records = {}
local loaded, total = 0, 0
local missing = {}
local readModules = {}
local collectionFailed = false

local function contentId(value)
	if type(value) == "number" then
		value = tostring(value)
	end
	if type(value) ~= "string" then
		return nil
	end
	value = value:match("^%s*(.-)%s*$")
	local numeric = value:match("^rbxassetid://(%d+)$") or value:match("^(%d+)$")
	if numeric then
		return if tonumber(numeric) > 0 then "rbxassetid://" .. numeric else nil
	end
	return if value:match("^rbxasset://.+") or value:match("^rbxthumb://.+") or value:match("^https?://.+")
		then value else nil
end

local function find(root, ...)
	for _, name in ipairs({ ... }) do
		root = root and root:FindFirstChild(name)
	end
	return root
end

local function finish(result)
	if phase ~= "Loading" then
		return
	end
	phase = result
	if result ~= "Ready" then
		local failed = {}
		for id, record in pairs(records) do
			if not record.loaded then
				table.insert(failed, id)
			end
		end
		table.sort(failed)
		warn(("CriticalResourcePreloader: %s (%d/%d loaded); missing: %s; assets: %s")
			:format(result, loaded, total, table.concat(missing, ", "), table.concat(failed, ", ")))
	end
end

local function checkDeadline()
	if phase == "Loading" and os.clock() >= deadline then
		finish("TimedOut")
	end
end

local function preloadRecord(record)
	-- 单资源请求让回调直接对应资源，不依赖图片重定向后的 URL 与原 ID 相同。
	for _ = 1, 2 do
		checkDeadline()
		if phase ~= "Loading" then
			break
		end
		local callbacks, succeeded = 0, true
		local ok = pcall(function()
			ContentProvider:PreloadAsync({ record.asset }, function(_, status)
				callbacks += 1
				succeeded = succeeded and status == Enum.AssetFetchStatus.Success
			end)
		end)
		checkDeadline()
		if phase ~= "Loading" then
			break
		end
		if ok and callbacks > 0 and succeeded then
			record.loaded = true
			loaded += 1
			break
		end
	end
	if record.owned then
		record.asset:Destroy()
	end
	record.done = true
end

local function add(value, className, property, asset)
	local id = contentId(value)
	if not id or records[id] or phase ~= "Loading" then
		return
	end
	local owned = asset == nil
	if owned then
		asset = Instance.new(className)
		asset[property] = id
	end
	local record = { asset = asset, owned = owned, loaded = false, done = false }
	records[id] = record
	total += 1
	task.spawn(preloadRecord, record)
end

local function scan(root, background)
	if not root then
		return
	end
	local descendants = root:GetDescendants()
	table.insert(descendants, root)
	for _, asset in ipairs(descendants) do
		local value, className, property
		if asset:IsA("Sound") then
			value, className, property = asset.SoundId, "Sound", "SoundId"
		elseif asset:IsA("Animation") then
			value, className, property = asset.AnimationId, "Animation", "AnimationId"
		elseif asset:IsA("ImageLabel") or asset:IsA("ImageButton") then
			value, className, property = asset.Image, "ImageLabel", "Image"
		elseif asset:IsA("ParticleEmitter") or asset:IsA("Trail") or asset:IsA("Beam") then
			value, className, property = asset.Texture, "ImageLabel", "Image"
		end
		if value then
			local id = contentId(value)
			if background then
				if id and not records[id] then
					records[id] = { loaded = false }
					table.insert(background, asset)
				end
			else
				add(value, className, property, asset)
			end
		end
	end
end

local function readOnce(module, consume)
	if not module or not module:IsA("ModuleScript") then
		return false
	end
	if not readModules[module] then
		readModules[module] = true
		local ok, err = pcall(function()
			consume(require(module))
		end)
		if not ok then
			collectionFailed = true
			warn("CriticalResourcePreloader: cannot read " .. module:GetFullName() .. ": " .. tostring(err))
		end
	end
	return true
end

local function collectCritical()
	missing = {}
	local function required(root, label)
		if not root then
			table.insert(missing, label)
		end
		return root
	end
	scan(required(find(ReplicatedStorage, "Sound", "Fishing"), "Sound.Fishing"))
	scan(required(find(ReplicatedStorage, "Animation", "Fishing", "CastRod"), "CastRod"))
	local player = Players.LocalPlayer
	local gui = player and player:FindFirstChildOfClass("PlayerGui")
	for _, name in ipairs({ "BaitSelectGui", "CastMeterGui", "FishingSequenceGui", "FishingVignetteGui" }) do
		scan(required(find(gui, name), name))
	end
	required(find(gui, "FishingSequenceGui", "BitePromptTemplate", "Icon"), "BitePromptTemplate.Icon")
	scan(ReplicatedFirst:FindFirstChild("LoadingScreenMenu"))
	for _, name in ipairs({ "Whoosh", "Click" }) do
		scan(SoundService:FindFirstChild(name, true))
	end
	if not readOnce(find(ReplicatedStorage, "Modules", "FishingConfig"), function(config)
		for _, sound in pairs(config.Sounds) do
			add(sound.Id, "Sound", "SoundId")
		end
	end) then
		table.insert(missing, "FishingConfig")
	end
end

local function preloadBackground(assets, label)
	if #assets == 0 then
		return
	end
	local failures = 0
	for first = 1, #assets, BACKGROUND_BATCH_SIZE do
		local last = math.min(#assets, first + BACKGROUND_BATCH_SIZE - 1)
		local batch = table.move(assets, first, last, 1, {})
		local ok = pcall(function()
			ContentProvider:PreloadAsync(batch, function(_, status)
				if status ~= Enum.AssetFetchStatus.Success then
					failures += 1
				end
			end)
		end)
		if not ok then
			failures += 1
		end
		if last < #assets then
			task.wait()
		end
	end
	if failures > 0 then
		warn("CriticalResourcePreloader: " .. label .. " preload failures: " .. tostring(failures))
	end
end

local function runBackground()
	while phase == "Loading" do
		task.wait(0.05)
		checkDeadline()
	end
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	local animations = ReplicatedStorage:WaitForChild("Animation", 10)
	local sounds = ReplicatedStorage:WaitForChild("Sound", 10)
	local fishing = {}
	scan(find(animations, "Fishing"), fishing)
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	for _, name in ipairs({ "Fishing", "Fish", "WaterVFX" }) do
		scan(find(vfx, name), fishing)
	end
	preloadBackground(fishing, "fishing")
	local general = {}
	scan(animations, general)
	scan(sounds, general)
	local icons = {}
	readOnce(find(ReplicatedFirst, "Data", "BaitsData"), function(baits)
		for _, bait in pairs(baits) do
			local id = contentId(bait.Icon)
			if id and not records[id] then
				records[id] = { loaded = false }
				local icon = Instance.new("ImageLabel")
				icon.Image = id
				table.insert(icons, icon)
				table.insert(general, icon)
			end
		end
	end)
	preloadBackground(general, "general")
	for _, icon in icons do
		icon:Destroy()
	end
end

function Preloader.Start()
	if phase ~= "Idle" then
		return
	end
	phase = "Loading"
	deadline = os.clock() + WAIT_SECONDS
	-- 独立看门狗：实例复制、require、PreloadAsync 挂起都不能延长入场等待。
	task.delay(WAIT_SECONDS, function()
		finish("TimedOut")
	end)
	task.spawn(function()
		local ok, err = pcall(function()
			while phase == "Loading" do
				collectCritical()
				checkDeadline()
				local complete, success = #missing == 0 and game:IsLoaded(), not collectionFailed
				for _, record in pairs(records) do
					complete = complete and record.done
					success = success and record.loaded
				end
				if complete then
					finish(if success then "Ready" else "Failed")
				end
				if phase == "Loading" then
					task.wait(0.05)
				end
			end
		end)
		if not ok then
			warn("CriticalResourcePreloader: collection failed: " .. tostring(err))
			finish("Failed")
		end
	end)
	task.spawn(runBackground)
end

function Preloader.GetStatus()
	checkDeadline()
	return { phase = phase, loaded = loaded, total = total }
end

return Preloader
