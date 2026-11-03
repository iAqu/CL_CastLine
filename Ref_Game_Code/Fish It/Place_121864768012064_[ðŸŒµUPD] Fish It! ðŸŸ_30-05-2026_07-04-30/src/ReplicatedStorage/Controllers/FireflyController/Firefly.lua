-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function CreateContainer() --[[ CreateContainer | Line: 2 ]]
	local Fireflies = Instance.new("Folder")
	Fireflies.Name = "Fireflies"
	Fireflies.Parent = workspace.CurrentCamera
	return Fireflies
end
local function NewFirefly() --[[ NewFirefly | Line: 10 ]]
	local Part = Instance.new("Part")
	Part.Shape = Enum.PartType.Ball
	Part.Anchored = true
	Part.CanCollide = false
	Part.Color = Color3.fromRGB(230, 151, 114)
	Part.Material = Enum.Material.Neon
	Part.Position = Vector3.new(-399, 574, 1270)
	Part.Size = Vector3.new(0.3, 0.3, 0.3)
	local PointLight = Instance.new("PointLight")
	PointLight.Range = 8
	PointLight.Color = Color3.fromRGB(230, 151, 114)
	PointLight.Parent = Part
	local ParticleEmitter = Instance.new("ParticleEmitter")
	ParticleEmitter.Texture = "rbxassetid://10737490939"
	ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 219, 146)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 219, 146)) })
	ParticleEmitter.EmissionDirection = Enum.NormalId.Back
	ParticleEmitter.LightEmission = 1
	ParticleEmitter.Rate = 4
	ParticleEmitter.RotSpeed = NumberRange.new(3)
	ParticleEmitter.Rotation = NumberRange.new(20, 180)
	ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(1, 0.1) })
	ParticleEmitter.Speed = NumberRange.new(0.5)
	ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
	ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	ParticleEmitter.Parent = Part
	return Part
end
local t = {
	Velocity = 5,
	Count = 6,
	Offset = Vector3.new(200, 10, 200)
}
local Fireflies = Instance.new("Folder")
Fireflies.Name = "Fireflies"
Fireflies.Parent = workspace.CurrentCamera
t.Container = Fireflies
t.Firefly = NewFirefly()
return t