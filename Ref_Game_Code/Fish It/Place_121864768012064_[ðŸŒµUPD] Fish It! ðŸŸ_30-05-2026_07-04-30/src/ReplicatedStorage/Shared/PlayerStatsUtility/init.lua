-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("HttpService")
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local Events = require(ReplicatedStorage.Events)
local Abilities = require(ReplicatedStorage.Abilities)
local Quests = require(ReplicatedStorage.Modules.Quests)
require(ReplicatedStorage.Shared.Settings)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local Variants = require(ReplicatedStorage.Variants)
require(ReplicatedStorage.Types.Modifiers)
local v1 = UserPriority:IsTradePlaza()
local v2 = GamePassUtility:GetGamePassIdFromName("VIP")
local v3 = GamePassUtility:GetGamePassIdFromName("Small Luck")
local v4 = GamePassUtility:GetGamePassIdFromName("Extra Luck")
local v5 = GamePassUtility:GetGamePassIdFromName("Advanced Luck")
local v6 = GamePassUtility:GetGamePassIdFromName("More Mutations")
local Combinations = require(script:WaitForChild("Combinations"))
local VisualStats = require(script:WaitForChild("VisualStats"))
local VisualColors = require(script:WaitForChild("VisualColors"))
local t = {
	BaseLuck = 1,
	FishingPityTier = 0,
	SpecialLuckMultiplier = 0,
	BigChanceMultiplier = 1,
	ShinyMultiplier = 1,
	MutationMultiplier = 1,
	ReelMultiplier = 1,
	SizeMultiplier = 1,
	XPMultiplier = 1,
	SharkMultiplier = 1,
	SECRETMultiplier = 1,
	FORGOTTENMultiplier = 1,
	ClassicLuck = 1,
	EasterLuck = 1,
	HeartLuck = 1,
	BlobMultiplier = 0,
	Frequency = {
		Golden = 0,
		Rainbow = 0
	}
}
for v7, v8 in Variants do
	if VisualColors[v7] == nil then
		VisualColors[v7] = v8.Data.TierColor.Keypoints[#v8.Data.TierColor.Keypoints].Value
	end
end
local t2 = {}
local function v9(p1) --[[ DeepCopy | Line: 90 | Upvalues: v9 (copy) ]]
	local t = {}
	for k, v in pairs(p1) do
		if typeof(v) == "table" then
			t[k] = v9(v)
			continue
		end
		t[k] = v
	end
	return t
end
local function v10(p1, p2) --[[ MergeStats | Line: 104 | Upvalues: v10 (copy), v9 (copy) ]]
	local t = {}
	for k, v in pairs(p1) do
		local v1
		local v2 = p2[k]
		v1 = if v2 and typeof(v2) == "table" then v10(v, v2) elseif typeof(v2) == "number" and typeof(v) == "number" then v + v2 else v
		t[k] = v1
	end
	for k, v in pairs(p2) do
		if t[k] == nil then
			t[k] = if typeof(v) == "table" then v9(v) else v
		end
	end
	return t
end
function t2._deepCopy(p1, p2) --[[ _deepCopy | Line: 134 | Upvalues: v9 (copy) ]]
	return v9(p2)
end
function t2._mergeStats(p1, p2, p3) --[[ _mergeStats | Line: 138 | Upvalues: v10 (copy) ]]
	return v10(p2, p3)
end
function t2.GetPetStatMultiplier(p1, p2) --[[ GetPetStatMultiplier | Line: 142 ]]
	local v1 = if p2 then p2.Metadata else p2
	local v2 = if v1 then v1.Attributes else v1
	local v3 = if v2 then v2.PetStatMultiplier else v2
	if typeof(v3) == "number" and v3 > 0 then
		return v3
	else
		return 1
	end
end
function t2.ApplyMultiplierToModifiers(p1, p2, p3) --[[ ApplyMultiplierToModifiers | Line: 149 | Upvalues: v9 (copy) ]]
	if typeof(p2) == "table" and p3 ~= 1 then
		local v1 = v9(p2)
		local function v2(p1) --[[ apply | Line: 155 | Upvalues: v2 (copy), p3 (copy) ]]
			for v1, v22 in p1 do
				if typeof(v22) == "table" then
					v2(v22)
					continue
				end
				if typeof(v22) == "number" then
					p1[v1] = v22 * p3
				end
			end
		end
		v2(v1)
		return v1
	else
		return p2
	end
end
function t2.GetBaseStats(p1) --[[ GetBaseStats | Line: 169 | Upvalues: t (copy) ]]
	return t
end
function t2.CalculateGroupFishingLuck(p1, p2) --[[ CalculateGroupFishingLuck | Line: 173 | Upvalues: Players (copy) ]]
	local count = 0
	for i, v in ipairs(Players:GetPlayers()) do
		if v:GetAttribute("CircleSessionToken") == p2 then
			count = count + 1
		end
	end
	return count * 0.1
end
function t2.GetModifierDisplayName(p1, p2) --[[ GetModifierDisplayName | Line: 184 | Upvalues: Combinations (copy), VisualColors (copy), VisualStats (copy) ]]
	for v1, v2 in Combinations do
		local v3, _ = p2:find(v2)
		if v3 then
			local v6 = string.split(string.sub(string.gsub(p2, "(%u)", " %1"), 2, -1), " ")
			if not (#v6 < 3) then
				local t = {}
				for i = 1, #v6 - 2 do
					table.insert(t, v6[i])
				end
				local v8 = table.concat(t, " ")
				return v8, VisualColors[v8] or Color3.fromRGB(255, 255, 255)
			end
		end
	end
	local v10 = VisualStats[p2]
	if not v10 then
		return
	end
	return v10, VisualColors[p2] or Color3.fromRGB(255, 255, 255)
end
local function getCharacterPosition(p1) --[[ getCharacterPosition | Line: 216 ]]
	local Character = p1.Character
	if Character then
		return Character:GetPivot().Position
	else
		return nil
	end
end
local function getActiveAbilityName(p1) --[[ getActiveAbilityName | Line: 225 ]]
	local v1 = getPlayerReplion(p1)
	if not v1 or v1.Destroyed then
		return nil
	end
	local v2 = v1:Get("Abilities")
	if not v2 then
		return nil
	end
	if v2.Active ~= v2.Equipped or v2.ActiveRollsRemaining <= 0 then
		return nil
	end
	for i, v in ipairs(v2.Inventory) do
		if v.UUID == v2.Equipped then
			return v.Name
		end
	end
	return nil
end
local function getNearbyDivineModifiers(p1) --[[ getNearbyDivineModifiers | Line: 249 | Upvalues: Players (copy), getActiveAbilityName (copy), Abilities (copy) ]]
	local Character = p1.Character
	local v1 = if Character then Character:GetPivot().Position else nil
	if not v1 then
		return nil
	end
	for i, v in ipairs(Players:GetPlayers()) do
		if v ~= p1 and getActiveAbilityName(v) == "Divine" then
			local Divine = Abilities.Divine
			if Divine and Divine.SupportModifiers then
				local Character_2 = v.Character
				local v2 = if Character_2 then Character_2:GetPivot().Position else nil
				if v2 and (Divine.SupportRange or 75) >= (v1 - v2).Magnitude then
					return Divine.SupportModifiers
				end
			end
		end
	end
	return nil
end
function t2.GetPityLuck(p1, p2) --[[ GetPityLuck | Line: 283 ]]
	return 0
end
function t2.GetQuestFish(p1, p2, p3) --[[ GetQuestFish | Line: 307 | Upvalues: Quests (copy), ItemUtility (copy), t2 (copy) ]]
	if not p2 or p2.Destroyed then
		return {}
	end
	local v1 = p2:GetExpect("Quests")
	local v2 = p2:GetExpect("CompletedQuests")
	local t = {}
	for v3, v4 in v1 do
		for v5, v6 in v4 do
			local v7 = Quests[v3][v5]
			if v7 and not table.find(v2, v5) then
				for v9, v10 in v7.Objectives do
					local v8
					if v10.QuestItem and (v10.Requirements and (v10.Type == "Catch" or v10.Type == "Exchange")) and (not v10.AreaRestriction or v10.AreaRestriction == p3) then
						local v11 = v6.Objectives[v9]
						if v11 and not (if v11.Progress >= v10.Goal then true else false) then
							local Id = v10.Requirements.Id
							local v13 = if Id then ItemUtility:GetItemData(Id) else Id
							v8 = if v13 then v13.Data.Name else v10.Requirements.Fish or v10.Requirements.Name
							if v8 and (table.find(t, v8) == nil and not t2:GetItemFromInventory(p2, function(p1) --[[ Line: 350 | Upvalues: Id (copy) ]]
								return Id == p1.Id
							end, "Items")) then
								table.insert(t, v8)
							end
						end
					end
				end
			end
		end
	end
	return t
end
function t2.GetBestFishingRod(p1, p2) --[[ GetBestFishingRod | Line: 365 | Upvalues: ItemUtility (copy) ]]
	local v1 = p2:GetExpect({ "Inventory", "Fishing Rods" })
	table.sort(v1, function(p1, p2) --[[ Line: 368 | Upvalues: ItemUtility (ref) ]]
		local v1 = ItemUtility.GetItemDataFromItemType("Fishing Rods", p1.Id)
		if not v1 then
			return false
		end
		local v2 = ItemUtility.GetItemDataFromItemType("Fishing Rods", p2.Id)
		if not v2 then
			return true
		end
		return (v2.Modifiers and v2.Modifiers.BaseLuck or 0) < (if v1.Modifiers then v1.Modifiers.BaseLuck or 0 else 0)
	end)
	return v1[1]
end
function t2.Transform(p1, p2, p3) --[[ Transform | Line: 388 ]]
	for v1, v2 in p3 do
		if typeof(v2) == "table" then
			for v3, v4 in v2 do
				local v5 = p2[v1]
				v5[v3] = v5[v3] + v4
			end
			continue
		end
		if typeof(v2) == "number" then
			local v6, v7 = pcall(function() --[[ Line: 397 | Upvalues: p2 (copy), v1 (copy), v2 (copy) ]]
				local v12 = p2[v1]
				if v12 == nil then
					v12 = if v1:find("Multiplier") then 1 else 0
				end
				p2[v1] = v12 + v2
			end)
			if not v6 then
				warn("ERROR WHILE TRANSFORMING STAT:", v1, v2, v7)
			end
		end
	end
end
function t2.GetPlayerModifiers(p1, p2, p3, p4) --[[ GetPlayerModifiers | Line: 413 | Upvalues: v9 (copy), t (copy), t2 (copy), ItemUtility (copy), v10 (copy), Events (copy), Abilities (copy), getNearbyDivineModifiers (copy), GamePassUtility (copy), v5 (copy), v4 (copy), v3 (copy), v2 (copy), v6 (copy) ]]
	local v1 = getPlayerReplion(p2)
	if not v1 then
		error("Unable to fetch player modifiers!")
	end
	v1:GetExpect("Inventory")
	local v22 = v1:GetExpect("EquippedPotions")
	local v32 = v1:GetExpect("TotemBoosts")
	local v42 = v1:GetExpect("EquippedItems")
	local v52 = v1:GetExpect("EquippedBaitId")
	local v62 = v1:Get("EquippedPetUUID")
	local v7 = v1:GetExpect("Settings")
	local v8 = v1:Get("Abilities")
	local v92 = v1:GetExpect("CharmModifiers")
	local v102 = v1:GetExpect("EquippedCharmId")
	local v11 = v1:GetExpect("Level")
	local sum = 1
	local v12 = v9(t)
	if v102 > 0 then
		local v13 = ItemUtility.GetItemDataFromItemType("Charms", v102)
		if v13 and (v92[v13.Data.Name] or 0) > 0 then
			if v13.Modifiers then
				t2:Transform(v12, v13.Modifiers)
			end
			if v13.FishModifiers then
				v12.FishModifiers = v13.FishModifiers
			end
		end
	end
	local v14 = v42[1]
	if v14 and string.len(v14) > 0 then
		local v15 = t2:GetItemFromInventory(v1, function(p1) --[[ Line: 461 | Upvalues: v14 (copy) ]]
			return p1.UUID == v14
		end, "Fishing Rods")
		if v15 then
			local v16 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v15.Id)
			if not v16 then
				return v12
			end
			local t3 = {}
			local Metadata = v15.Metadata
			if v16.RollData then
				t2:Transform(v12, if v15.Metadata and v15.Metadata.Modifiers then v10(v16.RollData, v15.Metadata.Modifiers) else v16.RollData)
			end
			if v16.Modifiers then
				t2:Transform(v12, v16.Modifiers)
			end
			if Metadata then
				for v19, v20 in { Metadata.EnchantId, Metadata.EnchantId2 } do
					local v21, v222 = ItemUtility:GetEnchantData(v20)
					if v21 then
						if v21.GroupFishingMultiplier then
							sum = sum + v21.GroupFishingMultiplier
						end
						t2:Transform(v12, v21.Modifiers)
						table.insert(t3, v222)
					end
				end
			end
			local v23 = getEventsReplion()
			if v23 then
				local v24 = v23:GetExpect("Events")
				for i, v in ipairs(v24) do
					local v25 = Events[v]
					if v25 then
						local v26 = nil
						if p4 then
							local v27 = v25.LinkedEvents and v25.LinkedEvents.Modifiers[p4]
							if v27 then
								v26 = v27
							end
						elseif p3 then
							local v28 = v25.AreaConfiguration and (v25.AreaConfiguration.Modifiers and v25.AreaConfiguration.Modifiers[p3])
							if v28 then
								v26 = v28
							end
						end
						if v26 then
							t2:Transform(v12, v26)
						end
						if v25.Modifiers then
							t2:Transform(v12, v25.Modifiers)
						end
					end
				end
				local sum_2 = 0
				if table.find(v24, "Night") then
					local v29 = if table.find(t3, "Stargazer I") then 0.6 else 0
					sum_2 = sum_2 + (v29 + (if table.find(t3, "Stargazer II") then 1 else 0))
				end
				if table.find(v24, "Storm") then
					local v31 = if table.find(t3, "Stormhunter I") then 0.8 else 0
					sum_2 = sum_2 + (v31 + (if table.find(t3, "Stormhunter II") then 1.4 else 0))
				end
				if sum_2 > 0 then
					t2:Transform(v12, {
						BaseLuck = sum_2
					})
				end
			end
		end
	end
	local v33 = nil
	if v8 and (v8.Active == v8.Equipped and v8.ActiveRollsRemaining > 0) then
		for i, v in ipairs(v8.Inventory) do
			if v.UUID == v8.Equipped then
				local v34 = Abilities[v.Name]
				if v34 and v34.Modifiers then
					t2:Transform(v12, v34.Modifiers)
					v33 = v.Name
				end
				break
			end
		end
	end
	if v33 ~= "Divine" then
		local v35 = getNearbyDivineModifiers(p2)
		if v35 then
			t2:Transform(v12, v35)
		end
	end
	if v52 > 0 then
		local v36 = ItemUtility:GetBaitData(v52)
		if v36 and v36.Modifiers then
			t2:Transform(v12, v36.Modifiers)
		end
	end
	if v62 and v62 ~= "" then
		local v37 = t2:GetItemFromInventory(v1, function(p1, p2) --[[ Line: 608 | Upvalues: v62 (copy) ]]
			return if p2 == "Pets" then p1.UUID == v62 else false
		end, "Pets")
		if v37 then
			local v38 = ItemUtility.GetItemDataFromItemType("Pets", v37.Id)
			if v38 and v38.Modifiers then
				t2:Transform(v12, (t2:ApplyMultiplierToModifiers(v38.Modifiers, t2:GetPetStatMultiplier(v37))))
			end
		end
	end
	if v7["Luck Modifiers"] == true then
		local v39 = p2:GetAttribute("CircleSessionToken")
		if v39 then
			v12.BaseLuck = v12.BaseLuck + t2:CalculateGroupFishingLuck(v39) * sum
		end
		if #v22 > 0 then
			for i, v in ipairs(v22) do
				local v41 = ItemUtility:GetPotionData(v.Id)
				if v41 and v41.Modifiers then
					t2:Transform(v12, v41.Modifiers)
				end
			end
		end
		if #v32 > 0 then
			local t3 = {}
			for i, v in ipairs(v32) do
				local v422 = ItemUtility:GetTotemData(v.Id)
				if v422 and v422.Boosts then
					for k, v13 in pairs(v422.Boosts) do
						local v43 = tonumber(v13)
						if not t3[v43] then
							local v44 = ItemUtility:GetPotionData((tonumber(v13)))
							if v44 and v44.Modifiers then
								t2:Transform(v12, v44.Modifiers)
								t3[v43] = true
							end
						end
					end
				end
			end
		end
		if GamePassUtility:UserOwnsGamePassAsync(p2, v5) then
			v12.BaseLuck = v12.BaseLuck + 1.5
		end
		if GamePassUtility:UserOwnsGamePassAsync(p2, v4) then
			v12.BaseLuck = v12.BaseLuck + 0.8
		end
		if GamePassUtility:UserOwnsGamePassAsync(p2, v3) then
			v12.BaseLuck = v12.BaseLuck + 0.3
		end
		if GamePassUtility:UserOwnsGamePassAsync(p2, v2) then
			v12.BaseLuck = v12.BaseLuck + 0.5
		end
		local v45 = t2:GetLevelLuck(v11)
		if v45 > 0 then
			v12.BaseLuck = v12.BaseLuck + v45
		end
		local v46 = getServerLuckReplion()
		if v46 then
			local sum_2 = v46:GetExpect("ServerMultiplier")
			if v12.SpecialLuckMultiplier and v12.SpecialLuckMultiplier > 0 then
				sum_2 = sum_2 + v12.SpecialLuckMultiplier
			end
			if sum_2 > 1 then
				v12.BaseLuck = v12.BaseLuck * sum_2
			end
		end
	end
	if v7["Friend Luck"] == true then
		v12.BaseLuck = v12.BaseLuck + t2:GetFriendLuck(p2)
	end
	if GamePassUtility:UserOwnsGamePassAsync(p2, v6) then
		v12.MutationMultiplier = v12.MutationMultiplier + 0.6
	end
	v12.BaseLuck = math.max(v12.BaseLuck, 1)
	return v12
end
function t2.GetLevelLuck(p1, p2) --[[ GetLevelLuck | Line: 741 ]]
	return math.min(math.floor(p2 / 50) * 50 / 50 * 0.075, 2.25)
end
function t2.GetFriendLuck(p1, p2) --[[ GetFriendLuck | Line: 745 | Upvalues: v1 (copy), Players (copy) ]]
	if v1 then
		return 0
	end
	local v12 = Players:GetPlayers()
	local v2 = table.find(v12, p2)
	if v2 then
		table.remove(v12, v2)
	end
	local v3 = 0
	for i, v in ipairs(v12) do
		local v4, v5 = pcall(p2.IsFriendsWith, p2, v.UserId)
		if v4 and v5 == true then
			v3 = math.min(v3 + 0.1, 0.5)
		end
		if v3 >= 0.5 then
			break
		end
	end
	return v3
end
function t2.GetItemFromInventory(p1, p2, p3, p4) --[[ GetItemFromInventory | Line: 773 ]]
	if p4 then
		local v1 = p2:Get({ "Inventory", p4 })
		if not v1 then
			return
		end
		for k, v in pairs(v1) do
			if p3(v, p4) == true then
				return v, {
					Category = p4,
					Index = k
				}
			end
		end
	else
		for k, v in pairs((p2:GetExpect("Inventory"))) do
			for k2, v3 in pairs(v) do
				if p3(v3, k) == true then
					return v3, {
						Category = k,
						Index = k2
					}
				end
			end
		end
	end
end
function t2.GetItemFromUUID(p1, p2, p3) --[[ GetItemFromUUID | Line: 808 | Upvalues: t2 (copy) ]]
	return t2:GetItemFromInventory(p2, function(p1) --[[ Line: 809 | Upvalues: p3 (copy) ]]
		return p1.UUID == p3
	end)
end
function t2.GetCharmsCopy(p1, p2) --[[ GetCharmsCopy | Line: 814 | Upvalues: ItemUtility (copy) ]]
	local v1 = p2:GetExpect("EquippedCharmId")
	local v2 = p2:GetExpect("CharmModifiers")
	local tbl = {}
	for i, v in ipairs((p2:GetExpect({ "Inventory", "Charms" }))) do
		local v4 = ItemUtility.GetItemDataFromItemType("Charms", v.Id)
		if v4 then
			tbl[v.Id] = (tbl[v4.Data.Id] or 0) + (v.Quantity or 1)
		end
	end
	if v1 > 0 and tbl[v1] == nil then
		tbl[v1] = 1
	end
	if next(v2) then
		for k, v in pairs(v2) do
			local v7 = ItemUtility.GetItemDataFromItemType("Charms", k)
			if v7 then
				tbl[v7.Data.Id] = (tbl[v7.Data.Id] or 0) + 1
			end
		end
	end
	local t = {}
	for k, v in pairs(tbl) do
		table.insert(t, {
			UUID = "NONE",
			Id = k,
			Quantity = v
		})
	end
	return t
end
function getPlayerReplion(p1) --[[ getPlayerReplion | Line: 870 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsServer() then
		return Replion.Server:GetReplionFor(p1, "Data")
	else
		return Replion.Client:WaitReplion("Data")
	end
end
function getEventsReplion() --[[ getEventsReplion | Line: 878 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsClient() then
		return Replion.Client:WaitReplion("Events")
	else
		return Replion.Server:WaitReplion("Events")
	end
end
function getServerLuckReplion() --[[ getServerLuckReplion | Line: 886 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsClient() then
		return Replion.Client:WaitReplion("ServerLuck")
	else
		return Replion.Server:WaitReplion("ServerLuck")
	end
end
return t2