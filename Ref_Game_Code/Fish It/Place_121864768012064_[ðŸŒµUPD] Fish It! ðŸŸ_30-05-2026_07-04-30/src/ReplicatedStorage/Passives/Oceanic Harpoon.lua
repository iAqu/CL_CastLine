-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Shared.Passives.PassivesTypes)
local function f3(p1, p2) --[[ Line: 24 ]]
	local v1 = if p2 then 0 else 1
	if p1:IsA("BasePart") then
		p1.Transparency = v1
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Light") or (v:IsA("Trail") or (v:IsA("Beam") or v:IsA("ParticleEmitter"))) then
			v.Enabled = p2
		end
	end
end
if v1 then
	local ViewModelService = require(ServerScriptService.Game.Services.ViewModelService)
	require(ServerScriptService.Game.Modules.AssociatedModel)
	local function getPlayerFromReplicationPipeline(p1) --[[ getPlayerFromReplicationPipeline | Line: 43 ]]
		if typeof(p1.ReplicateTo) == "table" then
			local v1 = p1.ReplicateTo[1]
			if typeof(v1) == "Instance" and v1:IsA("Player") then
				return v1
			end
		elseif typeof(p1.ReplicateTo) == "Instance" and p1.ReplicateTo:IsA("Player") then
			return p1.ReplicateTo
		end
	end
	local function processEquips(p1, p2) --[[ processEquips | Line: 57 | Upvalues: PlayerStatsUtility (copy), ItemUtility (copy) ]]
		if not (string.len(p2) > 0) then
			return false
		end
		local v1 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1) --[[ Line: 59 | Upvalues: p2 (copy) ]]
			return p1.UUID == p2
		end)
		if not v1 then
			return false
		end
		local v2 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v1.Id)
		if v2 and v2.Data.Name == "Oceanic Harpoon" then
			return true
		else
			return false
		end
	end
	Replion.Server:OnReplionAdded(function(p1, p2) --[[ Line: 74 | Upvalues: getPlayerFromReplicationPipeline (copy), Trove (copy), processEquips (copy), f3 (copy), ViewModelService (ref) ]]
		if p1 ~= "Data" then
			return
		end
		local v1 = getPlayerFromReplicationPipeline(p2)
		if v1 then
			local v2 = Trove.new()
			local function processChange(p1) --[[ processChange | Line: 86 | Upvalues: v1 (copy), p2 (copy), processEquips (ref), f3 (ref), v2 (copy) ]]
				local Character = v1.Character
				if not Character then
					return
				end
				local Bait = p1:FindFirstChild("Bait")
				if not Bait then
					return
				end
				local v12 = Character:FindFirstChild("Left Arm")
				if not v12 then
					return
				end
				if string.len((p2:Get("EquippedId"))) == 0 then
					return
				end
				local v3 = processEquips(p2, (p2:Get("EquippedSkinUUID")))
				v1:SetAttribute("HarpoonEquipped", v3)
				if v3 then
					f3(Bait, false)
					if not Character:FindFirstChild("OceanicArrowModel") then
						local v4 = script.OceanicArrowModel:Clone()
						local Motor6D = v4.Motor6D
						Motor6D.Part0 = v4
						Motor6D.Part1 = v12
						v4.Parent = Character
						v2:Add(v4)
						v2:Add(Motor6D)
					end
				else
					v2:Clean()
				end
			end
			local v3 = ViewModelService.ViewModelDestroyed:Connect(function(p1) --[[ Line: 130 | Upvalues: v1 (copy), v2 (copy) ]]
				if p1 ~= v1 then
					return
				end
				v2:Clean()
			end)
			local v4 = ViewModelService.ViewModelAdded:Connect(function(p1, p2) --[[ Line: 136 | Upvalues: v1 (copy), processChange (copy) ]]
				if p1 ~= v1 then
					return
				end
				processChange(p2)
			end)
			p2:BeforeDestroy(function() --[[ Line: 142 | Upvalues: v4 (copy), v3 (copy) ]]
				v4:Disconnect()
				v3:Disconnect()
			end)
		end
	end)
else
	if not v2 then
		return {
			Validate = function(p1_2_2) --[[ Validate | Line: 192 ]]
				return false
			end,
			Callback = function(p1_2_2, p2_2_2) --[[ Callback | Line: 196 ]]
				return false
			end
		}
	end
	local MarkerListener = require(ReplicatedStorage.Controllers.AnimationController).MarkerListener
	if not MarkerListener then
		return {
			Validate = function(p1_2_2) --[[ Validate | Line: 192 ]]
				return false
			end,
			Callback = function(p1_2_2, p2_2_2) --[[ Callback | Line: 196 ]]
				return false
			end
		}
	end
	MarkerListener:Connect(function(p1) --[[ Line: 153 | Upvalues: f3 (copy) ]]
		local Character = game.Players.LocalPlayer.Character
		if not Character then
			return
		end
		local v1 = Character:FindFirstChild("!!!EQUIPPED_TOOL!!!")
		if not v1 then
			return
		end
		local Bait = v1:FindFirstChild("Bait")
		if not Bait then
			return
		end
		local OceanicArrowModel = Character:FindFirstChild("OceanicArrowModel")
		if not OceanicArrowModel then
			return
		end
		if p1 == "ADD_ARROW" then
			f3(Bait, false)
			f3(OceanicArrowModel, true)
			return
		end
		if p1 == "HIDE_ARROW" then
			f3(Bait, true)
			f3(OceanicArrowModel, false)
			return
		end
		if p1 ~= "HARP_THROW_LINE" then
			return
		end
		f3(Bait, false)
		f3(OceanicArrowModel, false)
	end)
end
return {
	Validate = function(p1_2_2) --[[ Validate | Line: 192 ]]
		return false
	end,
	Callback = function(p1_2_2, p2_2_2) --[[ Callback | Line: 196 ]]
		return false
	end
}