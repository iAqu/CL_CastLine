-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Client = require(ReplicatedStorage.Packages.Replion).Client
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local LocalPlayer = Players.LocalPlayer
local v1 = Net:RemoteEvent("RodEffect")
local t = {}
local function GetRodModel(p1) --[[ GetRodModel | Line: 22 ]]
	if not p1 then
		return nil
	end
	local v1 = p1:FindFirstChild("!!!EQUIPPED_TOOL!!!")
	if v1 then
		return v1
	else
		return nil
	end
end
local function SetParticleEmitters(p1, p2) --[[ SetParticleEmitters | Line: 37 ]]
	if not p1 then
		return
	end
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("ParticleEmitter") then
			if v2.Enabled and v2:GetAttribute("IsEnabled") == nil then
				v2:SetAttribute("IsEnabled", v2.Enabled)
			end
			v2.Enabled = p2 and v2:GetAttribute("IsEnabled") or false
		end
	end
end
t.Registry = {
	["Cupid\'s Harp"] = {
		RodThrow = function(p1, p2) --[[ RodThrow | Line: 62 | Upvalues: TweenService (copy), SetParticleEmitters (copy) ]]
			if not p1 then
				return
			end
			local v1 = p1:FindFirstChild("Mball.004")
			if not v1 then
				return
			end
			v1.Transparency = 1
			TweenService:Create(v1, TweenInfo.new(0.3), {
				Transparency = 0.45
			}):Play()
			SetParticleEmitters(v1, true)
		end,
		FishCaught = function(p1, p2) --[[ FishCaught | Line: 71 | Upvalues: TweenService (copy), SetParticleEmitters (copy) ]]
			if not p1 then
				return
			end
			local v1 = p1:FindFirstChild("Mball.004")
			if not v1 then
				return
			end
			v1.Transparency = 0.45
			TweenService:Create(v1, TweenInfo.new(1.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
			SetParticleEmitters(v1, false)
		end,
		EquipIdle = function(p1, p2) --[[ EquipIdle | Line: 81 | Upvalues: SetParticleEmitters (copy) ]]
			if p1 then
				task.spawn(function() --[[ Line: 83 | Upvalues: p1 (copy), SetParticleEmitters (ref) ]]
					local v1 = p1:WaitForChild("Mball.004", 2)
					if not v1 then
						return
					end
					v1.Transparency = 1
					task.delay(0.5, function() --[[ Line: 87 | Upvalues: SetParticleEmitters (ref), v1 (copy) ]]
						SetParticleEmitters(v1, false)
					end)
				end)
			end
		end
	}
}
function t.Fire(p1, p2) --[[ Fire | Line: 97 | Upvalues: Client (copy), PlayerStatsUtility (copy), ItemUtility (copy), t (copy) ]]
	local v1 = Client:GetReplion("Data")
	if not v1 then
		return
	end
	local v2 = v1:GetExpect("EquippedSkinUUID")
	local v3 = v1:GetExpect("EquippedItems")[1]
	local v4 = if string.len(v2) > 0 then v2 else v3
	local v5 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 108 | Upvalues: v4 (copy) ]]
		return p1.UUID == v4
	end, "Fishing Rods")
	if not v5 then
		return
	end
	local v6 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v5.Id)
	if not v6 then
		return
	end
	local v7 = v6.Data.Name
	local v8 = t.Registry[v7]
	if not v8 then
		return
	end
	local v9 = v8[p1]
	if not v9 then
		return v7
	end
	v9(p2)
	return v7
end
function t.FireAndReplicate(p1, p2) --[[ FireAndReplicate | Line: 128 | Upvalues: t (copy), v1 (copy) ]]
	local v12 = t.Fire(p1, p2)
	if not v12 then
		return
	end
	v1:FireServer(v12, p1)
end
v1.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 136 | Upvalues: LocalPlayer (copy), t (copy) ]]
	if p1 == LocalPlayer then
		return
	end
	local Character = p1.Character
	if not Character then
		return
	end
	local v1 = t.Registry[p2]
	if not v1 then
		return
	end
	local v2 = v1[p3]
	if not v2 then
		return
	end
	v2(Character)
end)
return t