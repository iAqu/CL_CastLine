-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = {}
local function getEquippedAura(p1) --[[ getEquippedAura | Line: 14 | Upvalues: ReplicatedStorage (copy) ]]
	local v1 = p1:GetAttribute("FishingRodSkin")
	if typeof(v1) ~= "string" then
		return nil
	end
	if ReplicatedStorage.Assets.Auras:FindFirstChild(v1) then
		return v1
	else
		return nil
	end
end
function t.Start(p1) --[[ Start | Line: 27 | Upvalues: Client (copy), ReplicatedStorage (copy), CollectionService (copy), Observers (copy), Trove (copy), LocalPlayer (copy) ]]
	local v1 = Client:WaitReplion("Data")
	for v2, v3 in ReplicatedStorage.Assets.Auras:GetDescendants() do
		if v3:IsA("ParticleEmitter") or (v3:IsA("Beam") or v3:IsA("Trail")) then
			CollectionService:AddTag(v3, "RodAura")
		end
	end
	Observers.observeCharacter(function(p1, p2) --[[ Line: 36 | Upvalues: Trove (ref), ReplicatedStorage (ref), v1 (copy), LocalPlayer (ref) ]]
		local v12 = Trove.new()
		local v2 = v12:Extend()
		local v3 = false
		local v4 = 0
		local function playAura(p12) --[[ playAura | Line: 42 | Upvalues: ReplicatedStorage (ref), v3 (ref), v2 (copy), v1 (ref), p1 (copy), LocalPlayer (ref), p2 (copy) ]]
			local v12 = ReplicatedStorage.Assets.Auras:FindFirstChild(p12)
			if not v12 then
				return
			end
			if v3 then
				v2:Clean()
			end
			if p1 == LocalPlayer and not v1:Get({ "Settings", "Self Rod VFX" }) or p1 ~= LocalPlayer and not v1:Get({ "Settings", "Others Rod VFX" }) then
				return
			end
			v3 = true
			for v22, v32 in v12:GetChildren() do
				if v32.Name == "AttachTo" then
					local Torso = p2:FindFirstChild("Torso")
					if Torso then
						local v4 = v32:Clone()
						local Weld = Instance.new("Weld")
						Weld.Part0 = v4
						Weld.Part1 = Torso
						Weld.Parent = v4
						v4.Parent = p2
						v2:Add(v4)
					end
					continue
				end
				local v5 = p2:FindFirstChild(v32.Name)
				if v5 then
					for v6, v7 in v32:GetChildren() do
						local v8 = v7:Clone()
						v8.Parent = v5
						v2:Add(v8)
					end
				end
			end
		end
		local function endAura() --[[ endAura | Line: 92 | Upvalues: v2 (copy), v3 (ref) ]]
			v2:Clean()
			v3 = false
		end
		local function characterRemoved() --[[ characterRemoved | Line: 97 | Upvalues: v12 (copy) ]]
			v12:Destroy()
		end
		local Humanoid = p2:WaitForChild("Humanoid")
		if Humanoid then
			v12:Add(Humanoid.Died:Once(characterRemoved))
		end
		local function updateAura() --[[ updateAura | Line: 106 | Upvalues: v4 (ref), p1 (copy), ReplicatedStorage (ref), v2 (copy), v3 (ref), playAura (copy) ]]
			v4 = v4 + 1
			local v22 = p1:GetAttribute("FishingRodSkin")
			local v32 = if typeof(v22) == "string" then if ReplicatedStorage.Assets.Auras:FindFirstChild(v22) then v22 else nil else nil
			if not v32 then
				v2:Clean()
				v3 = false
				return
			end
			task.wait(0.5)
			if v4 ~= v4 then
				return
			end
			local v42 = p1:GetAttribute("FishingRodSkin")
			if (if typeof(v42) == "string" then if ReplicatedStorage.Assets.Auras:FindFirstChild(v42) then v42 else nil else nil) == v32 then
				playAura(v32)
			else
				v2:Clean()
				v3 = false
			end
		end
		local v5 = p1:GetAttributeChangedSignal("FishingRodSkin"):Connect(function() --[[ Line: 129 | Upvalues: updateAura (copy) ]]
			updateAura()
		end)
		v12:Add(function() --[[ Line: 133 | Upvalues: v5 (copy) ]]
			v5:Disconnect()
		end)
		updateAura()
		return characterRemoved
	end)
end
return t