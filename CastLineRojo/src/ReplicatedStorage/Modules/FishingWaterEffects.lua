local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.FishingConfig)
local Effects = {}

function Effects.UpdateRipple(ripple, now, waterY)
	local settings = Config.WaterRipple
	local alpha = math.clamp((now - ripple.started) / settings.Lifetime, 0, 1)
	ripple.gui.Enabled = now >= ripple.started
	local expansion = 1 - (1 - alpha) ^ settings.ExpansionPower
	local size = (settings.StartDiameter + (settings.EndDiameter - settings.StartDiameter) * expansion)
		* ripple.strength
	ripple.part.Size = Vector3.new(size, 0.02, size)
	ripple.part.CFrame = CFrame.new(ripple.position.X, waterY + 0.04, ripple.position.Z)
	ripple.stroke.Transparency = alpha ^ settings.FadePower
	return alpha == 1
end

function Effects.Update(effect, now)
	for index = #effect.emissions, 1, -1 do
		local burst = effect.emissions[index]
		if now >= burst.at then
			if not burst.emitted then
				burst.emitted = true
				if now < burst.endsAt + burst.emitter.Lifetime.Max then
					burst.emitter:Emit(burst.count)
				end
			end
			burst.emitter.Enabled = now < burst.endsAt
			if now >= burst.endsAt then
				table.remove(effect.emissions, index)
			end
		end
	end
end

function Effects.Ripple(self, startedAt, position, strength, now)
	if not Config.WaterRipple.Enabled then
		return
	end
	local part = Instance.new("Part")
	part.Name, part.Anchored, part.Transparency = "WaterRipple", true, 1
	part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
	local gui = Instance.new("SurfaceGui")
	gui.Face, gui.CanvasSize, gui.LightInfluence = Enum.NormalId.Top, Vector2.new(256, 256), 0
	gui:SetAttribute("FishingBillboardExempt", true)
	gui.Parent = part
	local ring = Instance.new("Frame")
	ring.Size, ring.Position, ring.BackgroundTransparency = UDim2.fromScale(0.9, 0.9), UDim2.fromScale(0.05, 0.05), 1
	ring.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius, corner.Parent = UDim.new(1, 0), ring
	local stroke = Instance.new("UIStroke")
	stroke.Thickness, stroke.Color, stroke.Parent = 3, Color3.fromRGB(220, 250, 255), ring
	local ripple =
		{ part = part, gui = gui, stroke = stroke, started = startedAt, position = position, strength = strength }
	local waterY = self:_waterTarget().Y
	Effects.UpdateRipple(ripple, now or startedAt, waterY)
	self.ripples = self.ripples or {}
	table.insert(self.ripples, ripple)
	part.Parent = self.folder
end

function Effects.NibbleRipple(self, now, position)
	self:_ripple(now, position, 0.25)
end

function Effects.Nibble(self, now, position)
	self:_sound("Splash", Config.Sounds.Splash.Volume * 0.25, 1.05)
	self:_playWaterVFX(now, Config.WaterVFX.Light, Vector3.new(position.X, self:_waterTarget().Y, position.Z))
end

function Effects.Play(owner, now, group, name, position, direction, scale, continuous)
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild(group)
	local template = folder and folder:FindFirstChild(name)
	if not (template and (template:IsA("Model") or template:IsA("BasePart"))) then
		local path = group .. "." .. name
		owner.warnedWaterVFX = owner.warnedWaterVFX or {}
		if not owner.warnedWaterVFX[path] then
			owner.warnedWaterVFX[path] = true
			warn("FishingCastSequence: VFX." .. path .. " is missing")
		end
		return
	end
	local model = template:Clone()
	local isWaterVFX = group == "WaterVFX"
	local isEntry = isWaterVFX and name == Config.WaterVFX.Entry
	if isEntry then
		scale = Config.WaterVFX.EntryScale
	end
	local originalParticles = {}
	if scale and (isEntry or (isWaterVFX and name == Config.WaterVFX.Exit)) then
		for _, instance in ipairs(model:GetDescendants()) do
			if instance:IsA("ParticleEmitter") then
				table.insert(originalParticles, { instance, instance.Size, instance.Speed, instance.Acceleration })
			end
		end
	end
	if scale and model:IsA("Model") then
		model:ScaleTo(template:GetScale() * scale)
	elseif scale and model:IsA("BasePart") then
		model.Size *= scale
		for _, instance in ipairs(model:GetDescendants()) do
			if instance:IsA("Attachment") then
				instance.Position *= scale
			end
		end
	end
	-- 从缩放前的数值覆盖，避免 ScaleTo 和粒子空间参数重复缩放。
	for _, original in ipairs(originalParticles) do
		local points = {}
		for _, key in ipairs(original[2].Keypoints) do
			table.insert(points, NumberSequenceKeypoint.new(key.Time, key.Value * scale, key.Envelope * scale))
		end
		original[1].Size = NumberSequence.new(points)
		original[1].Speed = NumberRange.new(original[3].Min * scale, original[3].Max * scale)
		original[1].Acceleration = original[4] * scale
	end
	local descendants = model:GetDescendants()
	table.insert(descendants, model)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("BasePart") then
			descendant.Anchored, descendant.CanCollide = true, false
			descendant.CanTouch, descendant.CanQuery = false, false
		elseif not continuous and descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
		end
	end
	local rotation = template:GetPivot().Rotation
	if direction then
		local horizontal = direction * Vector3.new(1, 0, 1)
		if horizontal.Magnitude > 0.00001 then
			rotation = CFrame.lookAt(Vector3.zero, horizontal.Unit) * rotation
		end
	end
	model:PivotTo(CFrame.new(position) * rotation)
	model.Parent = owner.folder
	if continuous then
		return { model = model, rotation = rotation }
	end
	local effect = { model = model, rotation = rotation, started = now, expiresAt = now, emissions = {} }
	owner.waterVFX = owner.waterVFX or {}
	table.insert(owner.waterVFX, effect)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("ParticleEmitter") then
			local at = now + (descendant:GetAttribute("EmitDelay") or 0)
			local endsAt = at + (descendant:GetAttribute("EmitDuration") or 0)
			effect.expiresAt = math.max(effect.expiresAt, endsAt + descendant.Lifetime.Max + 0.1)
			table.insert(effect.emissions, {
				emitter = descendant,
				count = descendant:GetAttribute("EmitCount") or 1,
				at = at,
				endsAt = endsAt,
			})
		end
	end
	Effects.Update(effect, now)
	return effect
end

function Effects.PlayStruggle(owner, now, position, direction, fishScale, fishDiameter)
	local settings = Config.WaterVFX
	local baseScale = settings.StruggleScale * math.max(1, fishScale or 1)
	local diameterScale = math.min(settings.StruggleDiameterScaleCap, (fishDiameter or 0) / settings.StruggleStudsPerScale)
	return Effects.Play(owner, now, "WaterVFX", settings.Struggle, position, direction, math.max(baseScale, diameterScale))
end

return Effects
