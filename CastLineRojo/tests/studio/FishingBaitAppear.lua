-- Studio Client：真实鱼饵、粒子、音效、挂点和立即抛竿衔接；不修改原始资源。
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Motion = require(storage.Modules.BaitElasticMotion)
local Audio = require(storage.Modules.FishingAudio)
local config = require(storage.Modules.FishingConfig)
local templates = storage.Models.FishBait
local effectTemplate = storage.VFX.Fishing.BaitAppear
local soundTemplate = storage.Sound.Fishing.FishingBaitShow
local owners = {}
local report = { samples = 0, interruptions = 0, emitters = 0 }

local function close(a, b, message)
	local difference = if typeof(a) == "Vector3" then (a - b).Magnitude else math.abs(a - b)
	assert(difference < 0.001, message .. ": " .. tostring(difference))
end

local function fixture(template, play)
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingBaitAppearValidation", workspace
	local visual = template:Clone()
	local bait = if visual:IsA("Model") then visual.PrimaryPart else visual
	local owner = setmetatable({
		folder = folder, bait = bait, baitBaseSize = bait.Size, baitVisualScale = Vector3.one,
		phase = "Preparing", meterStarted = 100, initialYaw = 0,
		options = { playBaitAppear = play },
		_castFeedback = function() end,
		_updateAction = function() end,
	}, Cast)
	table.insert(owners, owner)
	owner.fishAudio = Audio.new(function()
		return false
	end)
	if visual:IsA("Model") then
		owner.baitParts = {}
		for _, part in visual:GetDescendants() do
			if part:IsA("BasePart") and part ~= bait then
				owner.baitParts[part] = { size = part.Size, offset = bait.CFrame:ToObjectSpace(part.CFrame) }
			end
		end
		owner.baitTop = bait:FindFirstChild("Top")
		owner.baitTopOffset = owner.baitTop and owner.baitTop.Position
	end
	for _, part in visual:GetDescendants() do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide = true, false
		end
	end
	bait.Anchored, bait.CanCollide = true, false
	visual.Parent = folder
	local function anchor()
		local part = Instance.new("Part")
		part.Anchored, part.Transparency, part.Parent = true, 1, folder
		local attachment = Instance.new("Attachment")
		attachment.Parent = part
		return part, attachment
	end
	local rod
	rod, owner.tip = anchor()
	rod.Position = Vector3.new(10, 1000, 30)
	owner.lineEnd, owner.lineEndAttachment = anchor()
	owner.lineTop, owner.lineTopAttachment = anchor()
	owner.line = Instance.new("Beam")
	owner.line.Attachment0, owner.line.Attachment1, owner.line.Parent = owner.tip, owner.lineEndAttachment, folder
	owner.baitHighlight = Instance.new("Highlight")
	owner.baitHighlight.Adornee, owner.baitHighlight.Parent = visual, folder
	owner.baitHighlight.FillColor = Color3.fromRGB(unpack(config.Bite.BaitFillColor))
	owner.baitHighlight.FillTransparency = 1
	Motion.Apply(owner, CFrame.new(rod.Position - Vector3.new(0, 1.5, 0)), Vector3.one)
	return owner
end

local ok, result = xpcall(function()
	for _, flag in ipairs({ false, "omitted" }) do
		local owner = fixture(templates["1"]["1"], if flag == "omitted" then nil else flag)
		owner:_startBaitAppear(100)
		assert(not owner.baitAppearPlayed and not owner.folder:FindFirstChild("BaitAppear"), "Default bait must stay unchanged")
		close(owner.bait.Size, owner.baitBaseSize, "Default bait was scaled")
	end
	local expired
	for _, template in ipairs({ templates["1"]["1"], templates["12"]["1"], templates.DefaultBait }) do
		local owner = fixture(template, true)
		local fillColor = owner.baitHighlight.FillColor
		owner:_startBaitAppear(100)
		local effect = assert(owner.folder:FindFirstChild("BaitAppear"), "Real appearance VFX missing")
		expired = effect
		local initialFrame = effect:GetPivot()
		close(initialFrame.Position, owner.bait.Position, "VFX must start at bait center")
		assert(initialFrame.LookVector:Dot(effectTemplate:GetPivot().LookVector) > 0.9999, "Authored rotation changed")
		close(owner.bait.Size, owner.baitBaseSize * 0.3, "Wrong initial scale")
		for _, part in effect:GetDescendants() do
			if part:IsA("BasePart") then
				assert(part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery, "Unsafe effect part")
			elseif part:IsA("ParticleEmitter") then
				assert(not part.Enabled and part:GetAttribute("EmitCount"), "Emit once using authored count")
				report.emitters += 1
			end
		end
		owner:_startBaitAppear(100.1)
		assert(owner.baitAppearStarted == 100, "Repeated start reset appearance")
		local effectCount = 0
		for _, child in owner.folder:GetChildren() do
			if child.Name == "BaitAppear" then
				effectCount += 1
			end
		end
		assert(effectCount == 1, "Duplicate appearance burst")
		for _, elapsed in ipairs({ 0, 0.08, 0.18, 0.25, 0.32, 0.5 }) do
			owner:_updateBait(100 + elapsed, 0)
			owner:_updateLine()
			local size = owner.bait.Size
			owner:_updateBait(100 + elapsed, 0)
			close(owner.bait.Size, size, "Repeated presentation accumulated scale")
			local _, elastic = Motion.Sample("Preparing", elapsed)
			local uniform = Motion.SampleAppear(elapsed)
			close(size, owner.baitBaseSize * elastic * uniform, "Wrong combined appearance and idle scale")
			close(owner.lineEndAttachment.WorldPosition, if owner.baitTop then owner.baitTop.WorldPosition else owner.bait.Position,
				"Fishing line detached")
			for part, original in pairs(owner.baitParts or {}) do
				close(part.Size, original.size * owner.baitVisualScale, "Attached part scale detached")
				close(part.Position, (owner.bait.CFrame * CFrame.new(original.offset.Position * owner.baitVisualScale)).Position,
					"Attached part position detached")
			end
			close(effect:GetPivot().Position, initialFrame.Position, "VFX must stay at appearance position")
			report.samples += 1
		end
		assert(not owner.baitAppearStarted and owner.baitHighlight.FillColor == fillColor, "Flash color did not restore")
		close(owner.baitHighlight.FillTransparency, 1, "Flash did not fade out")
	end
	for _, elapsed in ipairs({ 0, 0.08, 0.18, 0.31 }) do
		local owner = fixture(templates["1"]["1"], true)
		local now = os.clock()
		owner.meterStarted = now - elapsed
		owner:_startBaitAppear(now - elapsed)
		owner:_updateBait(now, 0)
		local size, position = owner.bait.Size, owner.bait.Position
		owner:Cast(0)
		owner:_updateBait(owner.castClickedAt, 0)
		close(owner.bait.Size, size, "Immediate cast snapped size")
		close(owner.bait.Position, position, "Immediate cast snapped position")
		assert(not owner.baitAppearStarted and owner.phase == "Casting", "Appearance blocked cast or left flash active")
		close(owner.baitHighlight.FillTransparency, 1, "Casting retained flash")
		owner:_updateBait(owner.castClickedAt + config.BaitElastic.BlendTime, 0)
		local _, expected = Motion.Sample("Casting", config.BaitElastic.BlendTime)
		close(owner.bait.Size, owner.baitBaseSize * expected, "Cast did not recover normal size")
		report.interruptions += 1
	end
	local audioOwner = fixture(templates["1"]["1"], true)
	audioOwner.fishAudio.isSoundEnabled = function()
		return true
	end
	audioOwner:_startBaitAppear(os.clock())
	local voice = next(audioOwner.fishAudio.sounds)
	assert(voice and voice.Name == "FishingBaitShow", "Specified audio did not play")
	close(voice.Volume, soundTemplate.Volume, "Authored volume changed")
	close(voice.PlaybackSpeed, soundTemplate.PlaybackSpeed, "Authored pitch changed")
	local earlyEffect = audioOwner.folder:FindFirstChild("BaitAppear")
	audioOwner:Destroy()
	audioOwner:Destroy()
	assert(not voice.Parent and not earlyEffect.Parent, "Exit leaked audio or particles")
	task.wait(config.BaitAppear.EffectLifetime + 0.2)
	assert(not expired.Parent, "VFX exceeded its 1.3 second cleanup")
	assert(not effectTemplate:FindFirstChildWhichIsA("ParticleEmitter", true).Enabled and not soundTemplate.IsPlaying,
		"Source templates were changed")
	return report
end, debug.traceback)
for _, owner in ipairs(owners) do
	owner:Destroy()
end
if not ok then
	error(result)
end
return result
