-- Studio Client：使用真实特效验证朝向、发射时序、持续风效和生命周期清理。
local storage = game:GetService("ReplicatedStorage")
local VFX = require(storage.Modules.FishingCharacterVFX)
local settings = require(storage.Modules.FishingConfig).CharacterVFX
local Spot = require(storage.Modules.FishingSpotUtil)
local templates = storage.VFX.Fishing
local container = Instance.new("Folder")
container.Name, container.Parent = "FishingCharacterVFXValidation", workspace
local owners, temporary = {}, {}
local landName = settings.Land

local function fixture()
	local rig = Instance.new("Model")
	rig.Name = "ValidationRig"
	local root = Instance.new("Part")
	root.Name, root.Size, root.Anchored = "HumanoidRootPart", Vector3.new(2, 2, 1), true
	root.CFrame = CFrame.lookAt(Vector3.new(20, 30, 40), Vector3.new(21, 30, 40))
	root.Parent = rig
	local humanoid = Instance.new("Humanoid")
	humanoid.AutomaticScalingEnabled, humanoid.EvaluateStateMachine = false, false
	humanoid.HipHeight, humanoid.Parent = 2, rig
	rig.PrimaryPart, rig.Parent = root, container
	local owner = VFX.new(rig, container)
	table.insert(owners, owner)
	return owner, rig, root, humanoid
end

local function near(a, b)
	assert(math.abs(a - b) < 0.0001, tostring(a) .. " ~= " .. tostring(b))
end

local function checkPose(effect, root, humanoid, template, ground)
	local target = root.Position
	if ground then
		target -= Vector3.yAxis * Spot.GetFootHeight(root, humanoid)
	end
	local actual = effect.model:GetPivot()
	assert((actual.Position - target).Magnitude < 0.001, "Wrong character VFX position")
	local heading = CFrame.lookAt(Vector3.zero, (root.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit)
	local expected = heading * template:GetPivot().Rotation
	assert(actual.LookVector:Dot(expected.LookVector) > 0.9999, "Authored VFX rotation was lost")
	assert(actual.UpVector:Dot(expected.UpVector) > 0.9999, "Authored VFX tilt was lost")
	for _, descendant in ipairs(effect.model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			assert(descendant.Anchored and not descendant.CanCollide and not descendant.CanTouch and not descendant.CanQuery, "Unsafe VFX part")
		end
	end
end

local ok, result = xpcall(function()
	local owner, rig, root, humanoid = fixture()
	assert(#owner.folder:GetChildren() == 0, "Preparing must not play character VFX")
	owner:Start(10)
	owner:Start(10)
	assert(#owner.effects == 2, "Land and Wind must start once")
	local land, wind = owner.effects[1], owner.wind
	checkPose(land, root, humanoid, templates[settings.Land], true)
	checkPose(wind, root, humanoid, templates[settings.Wind], false)
	assert(#land.emissions == 0 and not land.model:FindFirstChildWhichIsA("ParticleEmitter", true).Enabled, "Land must emit a single burst")
	local beams, emitters = 0, 0
	for _, active in ipairs(wind.continuous) do
		assert(active.instance.Enabled == active.enabled, "Keep Wind's authored enabled state")
		if active.instance:IsA("Beam") then
			beams += 1
			local beam = active.instance
			assert(beam.Attachment0:IsDescendantOf(wind.model) and beam.Attachment1:IsDescendantOf(wind.model), "Beam points to source attachments")
		else
			emitters += 1
		end
	end
	assert(beams == 1 and emitters == 4, "Missing real Wind emitters or Beam")
	root.CFrame = CFrame.lookAt(Vector3.new(50, 35, 20), Vector3.new(50, 35, 19))
	owner:Update(11)
	checkPose(land, root, humanoid, templates[settings.Land], true)
	checkPose(wind, root, humanoid, templates[settings.Wind], false)
	owner:BeginSwing(11.8)
	owner:BeginSwing(11.81)
	assert(#owner.effects == 3 and not owner.wind, "Trigger Impact once and stop Wind")
	for _, active in ipairs(wind.continuous) do
		assert(not active.instance.Enabled, "Wind must disable both Beam and particle emission")
	end
	assert(wind.model.Parent, "Keep existing Wind particles alive after stopping")
	local impact = owner.effects[3]
	checkPose(impact, root, humanoid, templates[settings.Impact], true)
	assert(#impact.emissions > 0, "Impact must respect delayed emission")
	for _, burst in ipairs(impact.emissions) do
		assert(not burst.emitted and not burst.emitter.Enabled and burst.at > 11.8, "Impact emitted before its delay")
		near(burst.count, burst.emitter:GetAttribute("EmitCount"))
	end
	owner:Update(11.92)
	assert(#impact.emissions == 0, "Delayed Impact emissions did not complete")
	owner:Update(12.4)
	assert(not wind.model.Parent and not land.model.Parent and impact.model.Parent, "Honor each effect's particle lifetime")
	owner:Update(14)
	assert(#owner.effects == 0 and #owner.folder:GetChildren() == 0, "Expired particles leaked during flight")
	owner:Destroy()
	owner:Destroy()
	assert(not owner.folder.Parent and not owner.connection.Connected, "Destroy must disconnect and clean up")

	-- 提前退出、角色销毁以及再次进入不会残留发射器。
	for _ = 1, 2 do
		local early = fixture()
		early:Start(20)
		early:Destroy()
		early:BeginSwing(22)
		early:Update(23)
		assert(#early.effects == 0 and not early.folder.Parent, "Early exit leaked character VFX")
	end
	local dying, dyingRig = fixture()
	dying:Start(30)
	dyingRig:Destroy()
	assert(dying.destroyed and not dying.folder.Parent, "Rig destruction must immediately clean up character VFX")
	local detached, _, detachedRoot = fixture()
	detached:Start(40)
	detachedRoot:Destroy()
	detached:Update(40.1)
	assert(detached.destroyed and not detached.folder.Parent, "A removed root must clean up character VFX")

	-- 临时克隆验证延迟及持续发射，原始资源始终不变。
	local timed = templates[landName]:Clone()
	table.insert(temporary, timed)
	timed.Name, timed.Parent = "FishingCharacterVFX_TimedValidation", templates
	settings.Land = timed.Name
	local sourceEmitter = timed:FindFirstChildWhichIsA("ParticleEmitter", true)
	sourceEmitter:SetAttribute("EmitDelay", 0.2)
	sourceEmitter:SetAttribute("EmitDuration", 0.3)
	local duration = fixture()
	duration:Start(50)
	local effect = duration.effects[1]
	local burst = effect.emissions[1]
	assert(not burst.emitted and not burst.emitter.Enabled, "Duration emitter started before its delay")
	duration:Update(50.21)
	assert(burst.emitted and burst.emitter.Enabled, "Enable duration emission after the authored delay")
	duration:Update(50.51)
	assert(not burst.emitter.Enabled and #effect.emissions == 0, "Stop duration emission at its authored end")
	duration:BeginSwing(51.8)
	duration:Update(55)
	assert(#duration.effects == 0, "Duration emitter cleanup leaked")
	settings.Land = landName
	assert(templates[landName]:FindFirstChildWhichIsA("ParticleEmitter", true):GetAttribute("EmitDelay") == nil, "Source Land was changed")
	assert(templates[settings.Wind]:FindFirstChildWhichIsA("Beam", true).Enabled, "Source Wind was changed")
	-- 同一缺失资源重复进入仅告警一次，其余特效照常播放。
	settings.Land = "FishingCharacterVFX_MissingValidation"
	for _ = 1, 2 do
		local missing = fixture()
		missing:Start(60)
		assert(#missing.effects == 1 and missing.wind, "Missing Land must not prevent Wind")
		missing:BeginSwing(61.8)
		assert(#missing.effects == 2, "Missing Land must not prevent Impact")
	end
	settings.Land = landName
	rig:Destroy()
	return { passed = true, windEmitters = emitters, windBeams = beams }
end, debug.traceback)

settings.Land = landName
for _, owner in ipairs(owners) do
	owner:Destroy()
end
for _, item in ipairs(temporary) do
	item:Destroy()
end
container:Destroy()
assert(ok, result)
return result
