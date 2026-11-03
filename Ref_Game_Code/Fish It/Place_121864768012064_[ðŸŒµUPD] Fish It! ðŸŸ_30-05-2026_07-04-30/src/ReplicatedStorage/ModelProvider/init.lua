-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
RunService:IsServer()
RunService:IsClient()
require(ReplicatedStorage.Items)
require(ReplicatedStorage.Variants)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local ReclassGenericModel = require(script:WaitForChild("ReclassGenericModel"))
require(script:WaitForChild("ReclassFishProjectile"))
require(script:WaitForChild("ReclassTool"))
require(ReplicatedStorage.Types.Modifiers)
local t = {
	MainBody = 0,
	NoMutationMaterial = 0,
	Main = 2,
	FakeHandle = 0,
	Rod = 1
}
local function Recolor(p1, p2) --[[ Recolor | Line: 40 ]]
	for i, v in ipairs(p1) do
		if v:IsA("MeshPart") then
			v.TextureID = ""
		end
		if v.Name == "NoMutationMaterial" then
			v.Color = p2.Color
			continue
		end
		if v:HasTag("IgnoreTransparency") then
			v.Color = p2.Color
			v.Material = p2.Material
			v.MaterialVariant = p2.MaterialVariant
			continue
		end
		v.Color = p2.Color
		v.Material = p2.Material
		v.MaterialVariant = p2.MaterialVariant
		v.Transparency = p2.Transparency
	end
end
local function ScaleNumberSequence(p1, p2) --[[ ScaleNumberSequence | Line: 65 ]]
	local v1 = table.create(#p1.Keypoints)
	for i, v in ipairs(p1.Keypoints) do
		v1[i] = NumberSequenceKeypoint.new(v.Time, v.Value * p2, v.Envelope * p2)
	end
	return NumberSequence.new(v1)
end
local function GetLargestKeypointValue(p1) --[[ GetLargestKeypointValue | Line: 75 ]]
	local v1 = 0
	for i, v in ipairs(p1.Keypoints) do
		v1 = math.max(v1, v.Value + v.Envelope)
	end
	return v1
end
local function GetMutationParticleVisualSize(p1) --[[ GetMutationParticleVisualSize | Line: 85 ]]
	local v1 = 0
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Attachment") then
			v1 = math.max(v1, v.Position.Magnitude)
			continue
		end
		if v:IsA("ParticleEmitter") then
			local v3 = 0
			for i2, v2 in ipairs(v.Size.Keypoints) do
				v3 = math.max(v3, v2.Value + v2.Envelope)
			end
			v1 = math.max(v1, v3)
			continue
		end
		if v:IsA("Beam") then
			v1 = math.max(v1, v.Width0, v.Width1, math.abs(v.CurveSize0), (math.abs(v.CurveSize1)))
			continue
		end
		if v:IsA("Trail") then
			local v10 = 0
			for i2, v2 in ipairs(v.WidthScale.Keypoints) do
				v10 = math.max(v10, v2.Value + v2.Envelope)
			end
			v1 = math.max(v1, v10)
			continue
		end
		if v:IsA("PointLight") or (v:IsA("SpotLight") or v:IsA("SurfaceLight")) then
			v1 = math.max(v1, v.Range)
		end
	end
	return v1
end
local function GetMutationParticleScale(p1, p2, p3) --[[ GetMutationParticleScale | Line: 105 | Upvalues: GetMutationParticleVisualSize (copy) ]]
	local v1 = p2._moduleScript:GetAttribute("ParticleScale")
	if typeof(v1) == "number" then
		return v1
	end
	local v2 = p2._moduleScript:GetAttribute("ParticleReferenceSize")
	if typeof(v2) ~= "number" then
		v2 = 2
	end
	local v3 = p2._moduleScript:GetAttribute("MinimumParticleScale")
	if typeof(v3) ~= "number" then
		v3 = 0.45
	end
	local v4 = p2._moduleScript:GetAttribute("ParticleTargetCoverage")
	if typeof(v4) ~= "number" then
		v4 = 1.2
	end
	local v5 = p1:GetExtentsSize()
	local v8 = math.pow(math.max(v5.X * v5.Y * v5.Z, 0.001), 0.3333333333333333)
	local v9 = math.clamp(v8 / v2, v3, 1)
	local v10 = GetMutationParticleVisualSize(p3)
	if v10 <= 0 then
		return v9
	else
		return v9 * math.min(1, v8 * v4 / v10)
	end
end
local function v1(p1, p2) --[[ ScaleMutationParticleInstance | Line: 140 | Upvalues: ScaleNumberSequence (copy), v1 (copy) ]]
	if p2 == 1 then
		return
	end
	if p1:IsA("Attachment") then
		p1.Position = p1.Position * p2
	elseif p1:IsA("ParticleEmitter") then
		p1.Size = ScaleNumberSequence(p1.Size, p2)
		p1.Speed = NumberRange.new(p1.Speed.Min * p2, p1.Speed.Max * p2)
		p1.Acceleration = p1.Acceleration * p2
		p1.Drag = p1.Drag * p2
	elseif p1:IsA("Beam") then
		p1.Width0 = p1.Width0 * p2
		p1.Width1 = p1.Width1 * p2
		p1.CurveSize0 = p1.CurveSize0 * p2
		p1.CurveSize1 = p1.CurveSize1 * p2
	elseif p1:IsA("Trail") then
		p1.WidthScale = ScaleNumberSequence(p1.WidthScale, p2)
	elseif p1:IsA("PointLight") or (p1:IsA("SpotLight") or p1:IsA("SurfaceLight")) then
		p1.Range = p1.Range * p2
	end
	for i, v in ipairs(p1:GetDescendants()) do
		v1(v, p2)
	end
end
local t2 = {
	Festive = function(p1, p2) --[[ Line: 169 ]]
		for i, v in ipairs(p1) do
			if v:IsA("MeshPart") then
				v.TextureID = ""
			end
			local v1 = v.Name
			if v1 == "NoMutationMaterial" then
				v.Color = p2.Color
				continue
			end
			if v1 == "MainBody" then
				v.Color = Color3.fromRGB(112, 86, 63)
				v.Material = Enum.Material.Concrete
				continue
			end
			if v:HasTag("IgnoreTransparency") then
				v.Color = p2.Color
				v.Material = p2.Material
				v.MaterialVariant = p2.MaterialVariant
				continue
			end
			v.Color = p2.Color
			v.Material = p2.Material
			v.MaterialVariant = p2.MaterialVariant
			v.Transparency = p2.Transparency
		end
	end,
	["Color Burn"] = function(p1, p2) --[[ Line: 196 ]]
		for i, v in ipairs(p1) do
			if v:IsA("MeshPart") then
				v.TextureID = ""
			end
			local v1 = v.Name
			if v1 ~= "NoMutationMaterial" then
				if v1 == "NoMutationColor" then
					v.Material = p2.Material
					v.Reflectance = p2.Reflectance
					continue
				end
				v.Material = p2.Material
				v.Reflectance = p2.Reflectance
				v.Color = p2.Color
			end
		end
	end
}
local t3 = {
	_getMutationProfile = function(p1, p2, p3) --[[ _getMutationProfile | Line: 223 ]]
		local t = {}
		if not p3.Colors then
			return t
		end
		local Versions = p3._moduleScript:FindFirstChild("Versions")
		if not Versions then
			return t
		end
		local v1 = Versions:FindFirstChild((tostring(p2)))
		if v1 then
			local v2 = v1:GetChildren()
			for i = 1, p3.Colors do
				local v3 = v2[i]
				if v3:IsA("BasePart") then
					table.insert(t, {
						Color = v3.Color,
						Material = v3.Material,
						MaterialVariant = v3.MaterialVariant,
						Transparency = v3.Transparency,
						Reflectance = v3.Reflectance
					})
				end
			end
		end
		return t
	end,
	_groupModel = function(p1, p2, p3, p4) --[[ _groupModel | Line: 256 | Upvalues: t (copy) ]]
		local t2 = {
			Parts = {},
			Particles = {},
			Lights = {}
		}
		for i = 1, p3 do
			table.insert(t2.Parts, {})
		end
		local v1 = p2:GetDescendants()
		local t3 = {}
		for i, v in ipairs(v1) do
			if v:IsA("BasePart") then
				local v2 = v.Name
				local v3 = t[v2]
				if not v3 then
					v3 = tonumber(v2)
				end
				if v3 then
					local v5 = math.fmod(v3 + p4, p3) + 1
					if table.find(t3, v5) == nil then
						table.insert(t3, v5)
					end
				end
			end
		end
		for i, v in ipairs(v1) do
			if v:IsA("BasePart") and not (v.Transparency >= 1) then
				local v6 = v.Name
				local v7 = t[v6]
				if not v7 then
					v7 = tonumber(v6)
				end
				if v7 then
					local v9 = math.fmod(v7 + p4, p3) + 1
					local v10 = t2.Parts[v9]
					if not v10 then
						t2.Parts[v9] = {}
						v10 = t2.Parts[v9]
					end
					table.insert(v10, v)
				end
			end
		end
		for i, v in ipairs(v1) do
			if v:HasTag("MutationVFX") then
				if v:IsA("ParticleEmitter") or (v:IsA("Beam") or v:IsA("Trail")) then
					table.insert(t2.Particles, v)
					continue
				end
				if v:IsA("Light") then
					table.insert(t2.Lights, v)
				end
			end
		end
		return t2
	end
}
function t3.GetModel(p1, p2, p3, p4, p5) --[[ GetModel | Line: 338 | Upvalues: ItemUtility (copy), ModelDownloader (copy), ReclassGenericModel (copy), t3 (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p3, p4.Id)
	if not v1 then
		warn("No item data", p3, p4.Id)
		return
	end
	local v2 = ModelDownloader:GetModel(v1.Data.Type, v1.Data.Id, p5)
	if not v2 then
		warn("Unable to fetch downloaded copy of", p3, v1.Data.Name)
		return
	end
	local Metadata = p4.Metadata
	local v3 = if Metadata then Metadata.Weight else Metadata
	local v4 = if v1.Weight then v1.Weight else nil
	local v5 = if Metadata and Metadata.VariantId then ItemUtility:GetVariantData(Metadata.VariantId) else nil
	local v7 = if Metadata and Metadata.VariantSeed then Metadata.VariantSeed else nil
	local v8 = ReclassGenericModel(v2:Clone())
	local Handle = v8:WaitForChild("Handle", 3)
	if not Handle then
		v8:Destroy()
		return
	end
	if Handle and (Metadata and Metadata.Shiny) then
		t3:_addShiny(Handle)
		if not v5 then
			local v9 = t3:_groupModel(v8, 1, 1)
			if #v9.Particles > 0 then
				for i, v in ipairs(v9.Particles) do
					v.Enabled = true
				end
			end
		end
	end
	local sum = 1
	if v7 and v5 then
		t3:_updateMutation(v8, v7, v5)
		if v5.ModelScale then
			sum = sum + v5.ModelScale
		end
	end
	if v1.Data.Type == "Fish" and (v4 and v3) then
		sum = v3 / v4.Default.Min
	end
	if sum >= 1 then
		v8:ScaleTo(sum)
	end
	t3:_copyTags(v8, v2)
	for i, v in ipairs(v8:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = "Players"
		end
	end
	return v8, v1
end
function t3._copyTags(p1, p2, p3) --[[ _copyTags | Line: 453 ]]
	for v1, v2 in p3:GetAttributes() do
		if v1:sub(1, 3) ~= "RBX" then
			p2:SetAttribute(v1, v2)
		end
	end
	for i, v in ipairs((p3:GetTags())) do
		p2:AddTag(v)
	end
end
function t3._addShiny(p1, p2) --[[ _addShiny | Line: 469 ]]
	local Shiny = script.VFX:FindFirstChild("Shiny")
	if not Shiny then
		return
	end
	for i, v in ipairs(Shiny:GetChildren()) do
		local v1 = v:Clone()
		v1.Parent = p2
		if v1:IsA("Attachment") or v1:IsA("Bone") then
			v1.CFrame = CFrame.identity
			v1.WorldCFrame = CFrame.new(p2.Position)
		end
	end
end
function t3._updateMutation(p1, p2, p3, p4) --[[ _updateMutation | Line: 486 | Upvalues: t3 (copy), t2 (copy), Recolor (copy), GetMutationParticleScale (copy), v1 (copy) ]]
	local v2 = p4.Colors or 3
	local v3 = Random.new(p3)
	local v4 = t3:_getMutationProfile(v3:NextInteger(1, p4.Versions or 1), p4)
	if v4 then
		local v5 = t3:_groupModel(p2, v2, (v3:NextInteger(0, v2)))
		if #v5.Parts > 0 then
			local v6 = t2[p4.Data.Name] or Recolor
			for i, v in ipairs(v5.Parts) do
				local v7 = v4[i]
				if v7 then
					v6(v, v7)
				end
			end
		end
		if #v5.Particles > 0 then
			local v8 = ColorSequence.new(v4[1].Color)
			for i, v in ipairs(v5.Particles) do
				if v.Name == "HideWhenMutated" then
					v.Enabled = false
					continue
				end
				v.Color = v8
				v.Enabled = true
			end
		end
		if #v5.Lights > 0 then
			local Color = v4[1].Color
			for i, v in ipairs(v5.Lights) do
				v.Color = Color
				v.Enabled = true
			end
		end
	end
	local Particle = p4._moduleScript:FindFirstChild("Particle")
	if not Particle then
		return
	end
	local v9 = p2:FindFirstChild("MainBody") or p2:FindFirstChild("Handle")
	if not v9 then
		return
	end
	local v10 = GetMutationParticleScale(p2, p4, Particle)
	for i, v in ipairs(Particle:GetChildren()) do
		local v11 = v:Clone()
		v1(v11, v10)
		v11.Parent = v9
	end
end
return t3