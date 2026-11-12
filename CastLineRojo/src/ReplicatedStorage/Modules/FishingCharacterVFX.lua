local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(script.Parent.FishingConfig).CharacterVFX
local FishingSpotUtil = require(script.Parent.FishingSpotUtil)

local FishingCharacterVFX = {}
FishingCharacterVFX.__index = FishingCharacterVFX
local warned = {}

function FishingCharacterVFX.new(rig: Model, parent: Instance)
	local self = setmetatable({
		rig = rig,
		root = assert(rig.PrimaryPart, "Fishing rig root is missing"),
		humanoid = assert(rig:FindFirstChildOfClass("Humanoid"), "Fishing rig humanoid is missing"),
		effects = {},
	}, FishingCharacterVFX)
	self.folder = Instance.new("Folder")
	self.folder.Name, self.folder.Parent = "FishingCharacterVFX", parent
	self.connection = rig.Destroying:Connect(function()
		self:Destroy()
	end)
	return self
end

function FishingCharacterVFX:_position(effect)
	local root = self.root
	local position = root.Position
	if effect.ground then
		position -= Vector3.yAxis * FishingSpotUtil.GetFootHeight(root, self.humanoid)
	end
	local forward = root.CFrame.LookVector * Vector3.new(1, 0, 1)
	local heading = if forward.Magnitude > 0.00001 then CFrame.lookAt(Vector3.zero, forward.Unit) else CFrame.identity
	effect.model:PivotTo(CFrame.new(position) * heading * effect.rotation)
end

function FishingCharacterVFX:_create(name, now, ground, continuous)
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local group = vfx and vfx:FindFirstChild("Fishing")
	local template = group and group:FindFirstChild(name)
	if not (template and (template:IsA("Model") or template:IsA("BasePart"))) then
		if not warned[name] then
			warned[name] = true
			warn("FishingCharacterVFX: VFX.Fishing." .. name .. " is missing")
		end
		return nil
	end
	local model = template:Clone()
	local effect = {
		model = model,
		rotation = template:GetPivot().Rotation,
		ground = ground,
		emissions = {},
		continuous = {},
		lifetime = 0,
		expiresAt = if continuous then math.huge else now,
	}
	-- 先登记所有克隆，异常退出时也能由 Destroy 回收。
	table.insert(self.effects, effect)
	local descendants = model:GetDescendants()
	table.insert(descendants, model)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("BaseScript") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored, descendant.CanCollide = true, false
			descendant.CanTouch, descendant.CanQuery = false, false
		elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
			local enabled = descendant.Enabled
			descendant.Enabled = false
			if continuous then
				table.insert(effect.continuous, { instance = descendant, enabled = enabled })
			end
			if descendant:IsA("ParticleEmitter") then
				effect.lifetime = math.max(effect.lifetime, descendant.Lifetime.Max)
				if not continuous then
					local at = now + (descendant:GetAttribute("EmitDelay") or 0)
					local endsAt = at + (descendant:GetAttribute("EmitDuration") or 0)
					effect.expiresAt = math.max(effect.expiresAt, endsAt + descendant.Lifetime.Max + Settings.CleanupPadding)
					table.insert(effect.emissions, {
						emitter = descendant,
						at = at,
						endsAt = endsAt,
						count = descendant:GetAttribute("EmitCount") or 1,
					})
				end
			end
		end
	end
	self:_position(effect)
	model.Parent = self.folder
	for _, active in ipairs(effect.continuous) do
		active.instance.Enabled = active.enabled
	end
	return effect
end

function FishingCharacterVFX:Start(now: number)
	if self.destroyed or self.started then
		return
	end
	self.started = true
	self:_create(Settings.Land, now, true, false)
	self.wind = self:_create(Settings.Wind, now, false, true)
	self:Update(now)
end

function FishingCharacterVFX:BeginSwing(now: number)
	if self.destroyed or not self.started or self.swung then
		return
	end
	self.swung = true
	if self.wind then
		for _, active in ipairs(self.wind.continuous) do
			active.instance.Enabled = false
		end
		self.wind.expiresAt = now + self.wind.lifetime + Settings.CleanupPadding
		self.wind = nil
	end
	self:_create(Settings.Impact, now, true, false)
	self:Update(now)
end

function FishingCharacterVFX:Update(now: number)
	if self.destroyed then
		return
	end
	if not self.rig.Parent or not self.root:IsDescendantOf(self.rig) or not self.folder.Parent then
		self:Destroy()
		return
	end
	for index = #self.effects, 1, -1 do
		local effect = self.effects[index]
		if not effect.model.Parent or now >= effect.expiresAt then
			effect.model:Destroy()
			table.remove(self.effects, index)
		else
			self:_position(effect)
			for burstIndex = #effect.emissions, 1, -1 do
				local burst = effect.emissions[burstIndex]
				if now >= burst.at then
					if not burst.emitted then
						burst.emitted = true
						if now < burst.endsAt + burst.emitter.Lifetime.Max then
							burst.emitter:Emit(burst.count)
						end
					end
					burst.emitter.Enabled = now < burst.endsAt
					if now >= burst.endsAt then
						table.remove(effect.emissions, burstIndex)
					end
				end
			end
		end
	end
end

function FishingCharacterVFX:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self.connection:Disconnect()
	for _, effect in ipairs(self.effects) do
		effect.model:Destroy()
	end
	self.effects, self.wind = {}, nil
	self.folder:Destroy()
end

return FishingCharacterVFX
