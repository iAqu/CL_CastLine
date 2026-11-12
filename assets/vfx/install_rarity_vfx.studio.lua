-- 在 heixiaogu 工程的 Edit 模式执行；只安装 Studio 资源，不写入脚本。
local storage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")
local rarityConfig = require(storage.Modules.RarityConfig)
local target = storage.VFX.AnimalRoller
local backupName = "AnimalRoller_BeforeRarityVFX_20261111"
local backup = serverStorage:FindFirstChild(backupName)
if not backup then
	backup = target:Clone()
	backup.Name, backup.Parent = backupName, serverStorage
end

local textures = {
	Flash = "12156297119",
	Ring = "11817698226",
	Stars = "15268170416",
	Sparks = "8733414465",
	Crescent = "86398684443004",
	Glow = "77024587778878",
	Energy = "138192793162807",
	Rays = "3052949762",
}
local sources = {}
for name, id in pairs(textures) do
	for _, descendant in ipairs(backup:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") and string.find(descendant.Texture, id, 1, true) then
			sources[name] = descendant
			break
		end
	end
	assert(sources[name], "Missing Roll texture: " .. name)
end

local summaries = {}
for tier, rarity in ipairs(rarityConfig.List) do
	local model = Instance.new("Model")
	model.Name = rarity.Name
	model:SetAttribute("RarityVFXVersion", 1)
	model:SetAttribute("ReferenceDiameter", 12)
	model:SetAttribute("RarityIndex", tier)
	local root = Instance.new("Part")
	root.Name, root.Size = "Root", Vector3.one * 0.1
	root.Transparency, root.Anchored = 1, true
	root.CanCollide, root.CanTouch, root.CanQuery = false, false, false
	root.Parent, model.PrimaryPart = model, root
	local middle = Instance.new("Attachment")
	middle.Name, middle.Parent = "Middle", root
	local total, layers = 0, 0
	local power = 1 + (tier - 1) * 0.035
	local function layer(name, kind, count, delay, diameter, lifetime, light, color, rotation)
		local emitter = sources[kind]:Clone()
		emitter.Name = name
		emitter.Enabled, emitter.Rate = false, 0
		emitter:SetAttribute("EmitCount", count)
		emitter:SetAttribute("EmitDelay", delay)
		emitter:SetAttribute("EmitDuration", 0)
		emitter:SetAttribute("ExitEnabled", light == true)
		emitter.Color = color or rarity.Gradient
		emitter.LightEmission, emitter.LightInfluence = 0.7, 0
		emitter.Brightness = 1 + (tier - 1) * 0.04
		emitter.Lifetime = NumberRange.new(lifetime * 0.85, lifetime)
		emitter.Speed, emitter.Acceleration, emitter.Drag = NumberRange.new(0), Vector3.zero, 0
		emitter.VelocityInheritance, emitter.LockedToPart = 0, true
		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Orientation = Enum.ParticleOrientation.FacingCamera
		emitter.Rotation = if rotation then NumberRange.new(rotation) else NumberRange.new(0, 360)
		emitter.RotSpeed = NumberRange.new(-30, 30)
		if kind == "Stars" or kind == "Sparks" then
			emitter.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, diameter),
				NumberSequenceKeypoint.new(0.2, diameter * 0.8),
				NumberSequenceKeypoint.new(1, 0),
			})
			emitter.Speed = NumberRange.new(4 * power, 8 * power)
			emitter.Drag, emitter.LockedToPart = 1.5, false
			emitter.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.6, 0.25),
				NumberSequenceKeypoint.new(1, 1),
			})
		else
			emitter.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, diameter * 0.3),
				NumberSequenceKeypoint.new(0.45, diameter * 0.85),
				NumberSequenceKeypoint.new(1, diameter),
			})
			local soft = kind == "Glow" or kind == "Energy" or kind == "Rays"
			emitter.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, if soft then 0.8 else 0.25),
				NumberSequenceKeypoint.new(0.3, if soft then 0.9 else 0.4),
				NumberSequenceKeypoint.new(1, 1),
			})
		end
		emitter.Parent = middle
		total += count
		layers += 1
		return emitter
	end
	local function rays(name, delay, radius, size)
		for index = 1, 4 do
			local angle = (index - 1) * math.pi * 0.5 + math.pi * 0.25
			local attachment = Instance.new("Attachment")
			attachment.Name = name .. index
			attachment.Position = Vector3.new(math.cos(angle) * radius, math.sin(angle) * radius, 0)
			attachment.Parent = root
			local emitter = layer(name .. index, "Rays", 1, delay, size, 0.35, false, nil, math.deg(angle))
			emitter.Parent = attachment
		end
	end
	local stars, sparks = 8 + 4 * (tier - 1), 8 + 6 * (tier - 1)
	layer("Flash", "Flash", 1, 0, 5, 0.06, true)
	layer("Ring", "Ring", 1, 0, 12, 0.38, true)
	local cluster = if tier >= 9 then math.floor(stars * 0.25) else 0
	layer("Stars", "Stars", stars - cluster, 0, 0.22 * power, 0.8, true)
	if tier >= 2 then
		local second = if tier >= 7 then math.floor(sparks * 0.35) else 0
		layer("Sparks", "Sparks", sparks - second, 0.04, 0.12 * power, 0.85)
		if second > 0 then
			layer("SecondSparks", "Sparks", second, 0.22, 0.14 * power, 0.85)
		end
	end
	if tier >= 3 then
		layer("Crescent", "Crescent", 2, 0, 10, 0.55)
	end
	if tier >= 4 then
		layer("SecondCrescent", "Crescent", 2, 0.1, 11, 0.6, false, nil, 90)
		layer("Afterglow", "Glow", 1, 0.04, 8, 0.4)
	end
	if tier >= 5 then
		layer("SecondRing", "Ring", 1, 0.12, 13, 0.45)
	end
	if tier >= 6 then
		layer("Energy", "Energy", 1, 0.08, 10, 0.65)
	end
	if tier >= 7 then
		local silver = ColorSequence.new(Color3.fromRGB(225, 232, 250), rarity.Color)
		layer("SilverOuterRing", "Ring", 1, 0.18, 14, 0.5, false, silver)
	end
	if tier >= 8 then
		rays("StarRays", 0.1, 5.5, 3)
	end
	if tier >= 9 then
		layer("GradientRing", "Ring", 1, 0.24, 14.5, 0.55)
		layer("StarCluster", "Stars", cluster, 0.24, 0.24 * power, 0.85)
	end
	if tier >= 10 then
		layer("CrossArcA", "Crescent", 2, 0.18, 13, 0.6, false, nil, 45)
		layer("CrossArcB", "Crescent", 2, 0.28, 13, 0.6, false, nil, -45)
	end
	if tier >= 11 then
		layer("ThirdRing", "Ring", 1, 0.32, 15, 0.6)
	end
	if tier >= 12 then
		rays("FinalStarRays", 0.4, 6.5, 3.5)
	end
	assert(total <= 180, "Rarity particle budget exceeded")
	model:SetAttribute("BurstParticleCount", total)
	local previous = target:FindFirstChild(rarity.Name)
	if previous then
		previous:Destroy()
	end
	model.Parent = target
	table.insert(summaries, { name = rarity.Name, layers = layers, particles = total })
	task.wait()
end
return { backup = backup:GetFullName(), templates = summaries }
