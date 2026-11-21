local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local source = read("src/ReplicatedFirst/CriticalResourcePreloader.lua")

local function node(class, name, properties, children)
	local object = properties or {}
	object.Name, object.ClassName, object.children = name, class, children or {}
	function object:IsA(kind) return kind == self.ClassName end
	function object:FindFirstChild(childName, recursive)
		for _, child in ipairs(self.children) do
			if child.Name == childName then return child end
			if recursive then
				local found = child:FindFirstChild(childName, true)
				if found then return found end
			end
		end
	end
	function object:FindFirstChildOfClass(kind)
		for _, child in ipairs(self.children) do
			if child:IsA(kind) then return child end
		end
	end
	function object:GetDescendants()
		local result = {}
		for _, child in ipairs(self.children) do
			table.insert(result, child)
			for _, descendant in ipairs(child:GetDescendants()) do table.insert(result, descendant) end
		end
		return result
	end
	function object:WaitForChild(childName) return self:FindFirstChild(childName) end
	function object:GetFullName() return self.Name end
	function object:Destroy() self.destroyed = true end
	return object
end
local function folder(name, children) return node("Folder", name, {}, children) end
local function sound(name, id) return node("Sound", name, { SoundId = "rbxassetid://" .. id }) end
local function image(name, id) return node("ImageLabel", name, { Image = "rbxassetid://" .. id }) end
local function animation(name, id) return node("Animation", name, { AnimationId = "rbxassetid://" .. id }) end

local function harness(options)
	options = options or {}
	local h = { now = 0, tasks = {}, blocked = {}, calls = {}, attempts = {}, warnings = {}, owned = {} }
	local function schedule(thread, at)
		table.insert(h.tasks, { thread = thread, at = at })
	end
	function h.advance(target)
		local steps = 0
		while true do
			local index
			for i, task in ipairs(h.tasks) do
				if task.at <= target and (not index or task.at < h.tasks[index].at) then index = i end
			end
			if not index then break end
			local task = table.remove(h.tasks, index)
			h.now = task.at
			local ok, delay = coroutine.resume(task.thread)
			assert(ok, delay)
			if coroutine.status(task.thread) ~= "dead" and delay ~= "park" then
				schedule(task.thread, h.now + delay)
			end
			steps += 1
			assert(steps < 10000, "Scheduler did not yield")
		end
		h.now = target
	end
	function h.release()
		for _, thread in ipairs(h.blocked) do schedule(thread, h.now) end
		h.blocked = {}
	end
	local taskApi = {
		spawn = function(callback, ...)
			local args = { ... }
			schedule(coroutine.create(function() callback(table.unpack(args)) end), h.now)
		end,
		delay = function(seconds, callback) schedule(coroutine.create(callback), h.now + seconds) end,
		wait = function(seconds) return coroutine.yield(seconds or 0.01) end,
	}
	local config = node("ModuleScript", "FishingConfig", { data = { Sounds = {
		BiteDuplicate = { Id = "101" }, A = { Id = "rbxassetid://110" }, B = { Id = 110 },
		Empty = { Id = "" }, Nil = { Id = "nil" }, Zero = { Id = "rbxassetid://0" },
	} } })
	local baits = node("ModuleScript", "BaitsData", { data = {
		One = { Icon = 111 }, Two = { Icon = "rbxassetid://111" }, Empty = { Icon = "nil" },
	} })
	local icon = image("Icon", 105)
	local gui = node("PlayerGui", "PlayerGui", {}, {
		folder("BaitSelectGui", { image("Background", 106) }), folder("CastMeterGui"),
		folder("FishingSequenceGui", { folder("BitePromptTemplate", { icon }) }), folder("FishingVignetteGui"),
	})
	local fishingSounds = folder("Fishing", { sound("FishBite", 101), sound("FishSuccess", 102) })
	local storage = folder("ReplicatedStorage", {
		folder("Sound", { fishingSounds, folder("Gui", { sound("Gui_Fuse_Success", 103) }), sound("Other", 301) }),
		folder("Animation", { folder("Fishing", { animation("CastRod", 104), animation("SwimLoop", 201) }), animation("Other", 302) }),
		folder("Modules", if options.missingConfig then {} else { config }),
		folder("VFX", { folder("WaterVFX", {
			node("ParticleEmitter", "Water", { Texture = "rbxassetid://202" }),
			node("Trail", "Duplicate", { Texture = "rbxassetid://202" }),
		}) }),
	})
	local replicatedFirst = folder("ReplicatedFirst", { folder("Data", { baits }) })
	if not options.noMenu then table.insert(replicatedFirst.children, folder("LoadingScreenMenu", { image("Logo", 107) })) end
	local soundService = folder("SoundService", { sound("Whoosh", 108), sound("Click", 109) })
	local loaded = options.gameLoaded ~= false
	function h.setLoaded(value) loaded = value end
	h.storage, h.gui, h.config, h.icon = storage, gui, config, icon
	local services = {
		ReplicatedStorage = storage, ReplicatedFirst = replicatedFirst, SoundService = soundService,
		Players = { LocalPlayer = folder("Player", { gui }) },
		ContentProvider = { PreloadAsync = function(_, assets, callback)
			local call = { at = h.now, ids = {} }
			table.insert(h.calls, call)
			for _, asset in ipairs(assets) do
				local id = asset.SoundId or asset.AnimationId or asset.Image or asset.Texture
				table.insert(call.ids, id)
				h.attempts[id] = (h.attempts[id] or 0) + 1
				local result, delay = "Success", 0
				if options.fetch then result, delay = options.fetch(id, h.attempts[id]) end
				if delay and delay > 0 then coroutine.yield(delay) end
				if result == "hang" then
					table.insert(h.blocked, coroutine.running())
					coroutine.yield("park")
					result = "Success"
				end
				if result == "throw" then error("Network error") end
				if result ~= "silent" then
					-- 图片的回调 URL 可以不同于传入的 ID。
					callback("resolved:" .. id, result)
				end
			end
		end },
	}
	local environment = setmetatable({
		game = {
			GetService = function(_, name) return assert(services[name], name) end,
			IsLoaded = function() return loaded end,
			Loaded = { Wait = function() while not loaded do taskApi.wait(0.05) end end },
		},
		os = { clock = function() return h.now end }, task = taskApi,
		Enum = { AssetFetchStatus = { Success = "Success" } },
		Instance = { new = function(class)
			local asset = node(class, class)
			table.insert(h.owned, asset)
			return asset
		end },
		require = function(module)
			if module == config and options.hangRequire then
				table.insert(h.blocked, coroutine.running())
				coroutine.yield("park")
			end
			if options.failRequire then error("Bad module") end
			return module.data
		end,
		warn = function(message) table.insert(h.warnings, message) end,
	}, { __index = getfenv() })
	h.preloader = assert(load(source, "CriticalResourcePreloader", "t", environment))()
	return h
end

local h = harness({ gameLoaded = false })
assert(h.preloader.GetStatus().phase == "Idle")
h.preloader.Start()
h.preloader.Start()
h.advance(0.2)
assert(h.preloader.GetStatus().phase == "Loading")
assert(h.attempts["rbxassetid://105"] == 1 and h.attempts["rbxassetid://101"] == 1,
	"Bite icon and sound must preload before game.Loaded, deduplicated")
assert(not h.attempts["rbxassetid://201"] and not h.attempts["rbxassetid://301"], "No competing background preload")
h.setLoaded(true)
h.advance(0.5)
local ready = h.preloader.GetStatus()
assert(ready.phase == "Ready" and ready.total == 9 and ready.loaded == 9)
assert(#h.warnings == 0)
for id = 101, 111 do
	assert(h.attempts["rbxassetid://" .. id] == 1, "Missing or duplicated resource " .. id)
end
for _, call in h.calls do
	if call.at < 0.2 then
		assert(not table.find(call.ids, "rbxassetid://103") and not table.find(call.ids, "rbxassetid://111"))
	end
end
assert(h.attempts["rbxassetid://201"] == 1 and h.attempts["rbxassetid://202"] == 1)
assert(h.attempts["rbxassetid://301"] == 1 and h.attempts["rbxassetid://302"] == 1)
local fishCall, otherCall
for i, call in ipairs(h.calls) do
	for _, id in ipairs(call.ids) do
		if id == "rbxassetid://201" then fishCall = i end
		if id == "rbxassetid://301" then otherCall = i end
	end
end
assert(fishCall < otherCall, "Fishing animations and effect textures must precede general resources")
for _, asset in ipairs(h.owned) do assert(asset.destroyed, "Temporary carriers must be released") end
h.preloader.Start()
h.advance(6)
assert(h.preloader.GetStatus().phase == "Ready" and #h.warnings == 0, "Completed preload cannot time out or restart")

h = harness({ fetch = function(id, attempt)
	return if id == "rbxassetid://105" and attempt == 1 then "Failure" else "Success"
end })
h.preloader.Start()
h.advance(1)
assert(h.preloader.GetStatus().phase == "Ready" and h.attempts["rbxassetid://105"] == 2)
assert(h.attempts["rbxassetid://101"] == 1 and #h.warnings == 0, "Retry only failed resources")

for _, failure in ipairs({ "Failure", "throw", "silent" }) do
	h = harness({ fetch = function(id) return if id == "rbxassetid://102" then failure else "Success" end })
	h.preloader.Start()
	h.advance(1)
	assert(h.preloader.GetStatus().phase == "Failed" and h.preloader.GetStatus().loaded == 8,
		"A normal return without successful callbacks must not count as ready")
	assert(h.attempts["rbxassetid://102"] == 2 and #h.warnings == 1, "Retry once, then warn and release")
end

h = harness({ fetch = function(id) return if id == "rbxassetid://105" or id == "rbxassetid://110" then "hang" else "Success" end })
h.preloader.Start()
h.advance(4.99)
assert(h.preloader.GetStatus().phase == "Loading" and not h.attempts["rbxassetid://201"])
h.advance(5)
local timedOut = h.preloader.GetStatus()
assert(timedOut.phase == "TimedOut" and #h.warnings == 1, "Never-returning requests must release at five seconds")
h.advance(5.1)
assert(h.attempts["rbxassetid://201"], "Background loading must proceed even when a critical request hangs")
h.release()
h.advance(5.2)
assert(h.preloader.GetStatus().phase == "TimedOut" and h.preloader.GetStatus().loaded == timedOut.loaded,
	"Late callbacks cannot change the terminal state or progress")
assert(h.attempts["rbxassetid://105"] == 1 and h.attempts["rbxassetid://110"] == 1)
for _, asset in ipairs(h.owned) do assert(asset.destroyed, "Release temporary assets after a late return") end

h = harness({ fetch = function(id)
	return if id == "rbxassetid://105" then "Failure" else "Success", if id == "rbxassetid://105" then 5.1 else 0
end })
h.preloader.Start()
h.advance(6)
assert(h.preloader.GetStatus().phase == "TimedOut" and h.attempts["rbxassetid://105"] == 1,
	"An attempt returning after the budget cannot start a retry")

h = harness({ missingConfig = true })
h.preloader.Start()
h.advance(1)
assert(h.preloader.GetStatus().phase == "Loading", "Missing replicated modules must consume the same budget")
table.insert(h.storage:FindFirstChild("Modules").children, h.config)
h.advance(1.2)
assert(h.preloader.GetStatus().phase == "Ready", "Collect modules arriving after startup")

h = harness({ hangRequire = true })
h.preloader.Start()
h.advance(5)
assert(h.preloader.GetStatus().phase == "TimedOut", "Module require must not block the watchdog")
h.release()
h.advance(5.2)
assert(h.preloader.GetStatus().phase == "TimedOut")

h = harness({ noMenu = true })
h.preloader.Start()
h.advance(1)
assert(h.preloader.GetStatus().phase == "Ready" and h.preloader.GetStatus().total == 8,
	"A missing loading presentation must not prevent fishing preloads")

h = harness({ failRequire = true })
h.preloader.Start()
h.advance(1)
assert(h.preloader.GetStatus().phase == "Failed", "A module exception must release with failure, never claim success")

h = harness({ missingConfig = true })
h.preloader.Start()
h.advance(5)
assert(h.preloader.GetStatus().phase == "TimedOut" and h.warnings[1]:find("FishingConfig", 1, true),
	"Missing instances must time out with a useful warning")

h = harness({ gameLoaded = false })
local prompt = h.gui:FindFirstChild("FishingSequenceGui"):FindFirstChild("BitePromptTemplate")
prompt.children = {}
h.preloader.Start()
h.advance(0.5)
assert(not h.attempts["rbxassetid://105"])
table.insert(prompt.children, h.icon)
h.setLoaded(true)
h.advance(0.7)
assert(h.preloader.GetStatus().phase == "Ready" and h.attempts["rbxassetid://105"] == 1,
	"A UI root arriving before its image descendants must not lose the bite icon")

h = harness({ fetch = function(id)
	return if id == "rbxassetid://201" then "Failure" else "Success"
end })
h.preloader.Start()
h.advance(1)
assert(h.preloader.GetStatus().phase == "Ready" and h.preloader.GetStatus().loaded == 9,
	"Background errors must not change critical readiness or progress")
assert(#h.warnings == 1 and h.attempts["rbxassetid://301"] == 1)

-- 执行真实加载界面的就绪分支，数据和 Controller 已就绪也不能跳过资源门控。
local screen = read("src/ReplicatedFirst/LoadingScreen.client.lua")
local targetFunction = assert(screen:match("(local function getLoadingTarget%(%)%s*:%s*%(number, string, boolean%).-)\nlocalPlayer:SetAttribute"))
local screenStatus, gameLoaded, dataReady, controllersReady = "Loading", true, true, true
local targetEnvironment = setmetatable({
	CriticalResourcePreloader = { GetStatus = function() return { phase = screenStatus, loaded = 3, total = 11 } end },
	game = { IsLoaded = function() return gameLoaded end },
	LoadingAttributes = { PLAYER_DATA_LOADED = "data", CLIENT_CONTROLLERS_READY = "controllers" },
	localPlayer = { GetAttribute = function(_, attribute) return if attribute == "data" then dataReady else controllersReady end },
}, { __index = getfenv() })
local getTarget = assert(load(targetFunction .. "\nreturn getLoadingTarget", "LoadingTarget", "t", targetEnvironment))()
local _, _, canEnter = getTarget()
assert(not canEnter, "Early controller readiness must not bypass resource loading")
for _, status in ipairs({ "Ready", "Failed", "TimedOut" }) do
	screenStatus = status
	_, _, canEnter = getTarget()
	assert(canEnter, "Terminal preloading states must release the loading screen")
end
gameLoaded = false
_, _, canEnter = getTarget()
assert(not canEnter, "Resource timeout must not bypass game.Loaded")
gameLoaded, dataReady = true, false
_, _, canEnter = getTarget()
assert(not canEnter)
dataReady, controllersReady = true, false
_, _, canEnter = getTarget()
assert(not canEnter)
local start = assert(screen:find("CriticalResourcePreloader.Start()", 1, true))
assert(start < assert(screen:find('ReplicatedFirst:WaitForChild("LoadingScreenMenu", 15)', 1, true)),
	"Start preloads before presentation lookup and its failure exits")
