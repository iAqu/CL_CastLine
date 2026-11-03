-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Areas = require(ReplicatedStorage.Areas)
local Baits = require(ReplicatedStorage.Baits)
local Items = require(ReplicatedStorage.Items)
local Potions = require(ReplicatedStorage.Potions)
local Boats = require(ReplicatedStorage.Boats)
local Totems = require(ReplicatedStorage.Totems)
local Lanterns = require(ReplicatedStorage.Lanterns)
local Enchants = require(ReplicatedStorage.Enchants)
local Variants = require(ReplicatedStorage.Variants)
local Events = require(ReplicatedStorage.Events)
local Charms = require(ReplicatedStorage.Charms)
local Emotes = require(ReplicatedStorage.Emotes)
local Halos = require(ReplicatedStorage.Halos)
local Booths = require(ReplicatedStorage.Booths)
local Abilities = require(ReplicatedStorage.Abilities)
local Pets = require(ReplicatedStorage.Pets)
local PetEggs = require(ReplicatedStorage.PetEggs)
local VariantPool = require(script:WaitForChild("VariantPool"))
require(ReplicatedStorage.Types.Modifiers)
local t = {}
local v1 = nil
local t2 = {}
function t2.GetAllItems() --[[ GetAllItems | Line: 43 | Upvalues: t2 (copy) ]]
	return {
		Baits = t2:GetBaits(),
		Fish = t2:GetFish(),
		Potions = t2:GetPotions(),
		Totems = t2:GetTotems(),
		Lanterns = t2:GetLanterns(),
		Boats = t2:GetBoats(),
		Gears = t2:GetGears(),
		Trophies = t2:GetTrophies(),
		Charms = t2:GetCharms(),
		Emotes = t2:GetEmotes(),
		Halos = t2:GetHalos(),
		Booths = t2:GetBooths(),
		Pets = t2:GetPets(),
		["Pet Eggs"] = t2:GetPetEggs(),
		["Fishing Rods"] = t2:GetFishingRods(),
		["Enchant Stones"] = t2:GetEnchantStones()
	}
end
function t2.GetItemDataFromItemType(p1, p2) --[[ GetItemDataFromItemType | Line: 65 | Upvalues: v1 (ref), t2 (copy) ]]
	local v12 = v1[p1]
	if v12 then
		return v12(t2, p2)
	else
		return t2:GetItemData(p2)
	end
end
function t2.GetAbilityData(p1, p2) --[[ GetAbilityData | Line: 74 | Upvalues: Abilities (copy) ]]
	if typeof(p2) == "string" then
		return Abilities[p2]
	end
end
function t2.GetPetData(p1, p2) --[[ GetPetData | Line: 82 | Upvalues: Pets (copy) ]]
	if typeof(p2) == "string" then
		return Pets[p2]
	end
	for v1, v2 in Pets do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetPetEggData(p1, p2) --[[ GetPetEggData | Line: 96 | Upvalues: PetEggs (copy) ]]
	if typeof(p2) == "string" then
		return PetEggs[p2]
	end
	for v1, v2 in PetEggs do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetBoothData(p1, p2) --[[ GetBoothData | Line: 110 | Upvalues: Booths (copy) ]]
	if typeof(p2) == "string" then
		return Booths[p2]
	end
	for v1, v2 in Booths do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetHaloData(p1, p2) --[[ GetHaloData | Line: 124 | Upvalues: Halos (copy) ]]
	if typeof(p2) == "string" then
		return Halos[p2]
	end
	for v1, v2 in Halos do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetCharmData(p1, p2) --[[ GetCharmData | Line: 138 | Upvalues: Charms (copy) ]]
	if typeof(p2) == "string" then
		return Charms[p2]
	end
	for v1, v2 in Charms do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetEmoteData(p1, p2) --[[ GetEmoteData | Line: 152 | Upvalues: Emotes (copy) ]]
	if typeof(p2) == "string" then
		return Emotes[p2]
	end
	for v1, v2 in Emotes do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetLanternData(p1, p2) --[[ GetLanternData | Line: 166 | Upvalues: Lanterns (copy) ]]
	if typeof(p2) == "string" then
		return Lanterns[p2]
	end
	for v1, v2 in Lanterns do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetBoatData(p1, p2) --[[ GetBoatData | Line: 180 | Upvalues: Boats (copy) ]]
	if typeof(p2) == "string" then
		return Boats[p2]
	end
	for v1, v2 in Boats do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetTotemData(p1, p2) --[[ GetTotemData | Line: 194 | Upvalues: Totems (copy) ]]
	if typeof(p2) == "string" then
		return Totems[p2]
	end
	for v1, v2 in Totems do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetBaitData(p1, p2) --[[ GetBaitData | Line: 208 | Upvalues: Baits (copy) ]]
	if typeof(p2) == "string" then
		return Baits[p2]
	end
	for v1, v2 in Baits do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetItemData(p1, p2) --[[ GetItemData | Line: 222 | Upvalues: Items (copy) ]]
	if typeof(p2) == "string" then
		return Items[p2] or Items[("!!! %*"):format(p2)]
	else
		for v2, v3 in Items do
			if v3.Data.Id == p2 then
				return v3
			end
		end
	end
end
function t2.GetVariantData(p1, p2) --[[ GetVariantData | Line: 236 | Upvalues: Variants (copy) ]]
	if typeof(p2) == "string" then
		return Variants[p2]
	end
	for v1, v2 in Variants do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetPotionData(p1, p2) --[[ GetPotionData | Line: 250 | Upvalues: Potions (copy) ]]
	if typeof(p2) == "string" then
		return Potions[p2]
	end
	for v1, v2 in Potions do
		if v2.Data.Id == p2 then
			return v2
		end
	end
end
function t2.GetEnchantData(p1, p2) --[[ GetEnchantData | Line: 264 | Upvalues: Enchants (copy) ]]
	if typeof(p2) == "string" then
		return Enchants[p2], p2
	end
	local v1 = tonumber(p2)
	for v2, v3 in Enchants do
		if v3.Data.Id == v1 then
			return v3, v2
		end
	end
	return nil, nil
end
function t2._getItemFromType(p1, p2) --[[ _getItemFromType | Line: 279 | Upvalues: Items (copy) ]]
	local t = {}
	for v1, v2 in Items do
		if v2.Data.Type == p2 then
			table.insert(t, v2)
		end
	end
	return t
end
function t2.GetFish(p1) --[[ GetFish | Line: 291 | Upvalues: t2 (copy) ]]
	return t2:_getItemFromType("Fish")
end
function t2.GetEnchantStones(p1) --[[ GetEnchantStones | Line: 295 | Upvalues: t2 (copy) ]]
	return t2:_getItemFromType("Enchant Stones")
end
function t2.GetFishingRods(p1) --[[ GetFishingRods | Line: 299 | Upvalues: t2 (copy) ]]
	return t2:_getItemFromType("Fishing Rods")
end
function t2.GetGears(p1) --[[ GetGears | Line: 303 | Upvalues: t2 (copy) ]]
	return t2:_getItemFromType("Gears")
end
function t2.GetTrophies(p1) --[[ GetTrophies | Line: 307 | Upvalues: t2 (copy) ]]
	return t2:_getItemFromType("Trophies")
end
function t2.GetTotems(p1) --[[ GetTotems | Line: 311 | Upvalues: Totems (copy) ]]
	local t = {}
	for v1, v2 in Totems do
		table.insert(t, v2)
	end
	return t
end
function t2.GetCharms(p1) --[[ GetCharms | Line: 321 | Upvalues: Charms (copy) ]]
	local t = {}
	for v1, v2 in Charms do
		table.insert(t, v2)
	end
	return t
end
function t2.GetEmotes(p1) --[[ GetEmotes | Line: 331 | Upvalues: Emotes (copy) ]]
	local t = {}
	for v1, v2 in Emotes do
		table.insert(t, v2)
	end
	return t
end
function t2.GetAbilities(p1) --[[ GetAbilities | Line: 341 | Upvalues: Abilities (copy) ]]
	local t = {}
	for v1, v2 in Abilities do
		table.insert(t, v2)
	end
	return t
end
function t2.GetPets(p1) --[[ GetPets | Line: 351 | Upvalues: Pets (copy) ]]
	local t = {}
	for v1, v2 in Pets do
		table.insert(t, v2)
	end
	return t
end
function t2.GetPetEggs(p1) --[[ GetPetEggs | Line: 361 | Upvalues: PetEggs (copy) ]]
	local t = {}
	for v1, v2 in PetEggs do
		table.insert(t, v2)
	end
	return t
end
function t2.GetLanterns(p1) --[[ GetLanterns | Line: 371 | Upvalues: Lanterns (copy) ]]
	local t = {}
	for v1, v2 in Lanterns do
		table.insert(t, v2)
	end
	return t
end
function t2.GetBaits(p1) --[[ GetBaits | Line: 381 | Upvalues: Baits (copy) ]]
	local t = {}
	for v1, v2 in Baits do
		table.insert(t, v2)
	end
	return t
end
function t2.GetBooths(p1) --[[ GetBooths | Line: 391 | Upvalues: Booths (copy) ]]
	local t = {}
	for v1, v2 in Booths do
		table.insert(t, v2)
	end
	return t
end
function t2.GetBoats(p1) --[[ GetBoats | Line: 401 | Upvalues: Boats (copy) ]]
	local t = {}
	for v1, v2 in Boats do
		table.insert(t, v2)
	end
	return t
end
function t2.GetVariants(p1) --[[ GetVariants | Line: 411 | Upvalues: Variants (copy) ]]
	local t = {}
	for v1, v2 in Variants do
		table.insert(t, v2)
	end
	return t
end
function t2.GetPotions(p1) --[[ GetPotions | Line: 421 | Upvalues: Potions (copy) ]]
	local t = {}
	for v1, v2 in Potions do
		table.insert(t, v2)
	end
	return t
end
function t2.GetHalos(p1) --[[ GetHalos | Line: 431 | Upvalues: Halos (copy) ]]
	local t = {}
	for v1, v2 in Halos do
		table.insert(t, v2)
	end
	return t
end
function t2.GetFishIdentifiers(p1) --[[ GetFishIdentifiers | Line: 441 | Upvalues: Items (copy) ]]
	local t = {}
	for v1, v2 in Items do
		if v2.Data.Type == "Fish" then
			table.insert(t, v1)
		end
	end
	return t
end
function t2.CreateWeightedVariantTable(p1, p2, p3, p4, p5, p6) --[[ CreateWeightedVariantTable | Line: 454 | Upvalues: Events (copy), Areas (copy), VariantPool (copy), Variants (copy), t2 (copy), t (copy) ]]
	local v1 = p4 and p4.MutationMultiplier or 1
	local v2 = table.clone(p3)
	local v3 = getEventsReplion()
	if v3 then
		for i, v in ipairs((v3:GetExpect("Events"))) do
			local v5 = Events[v]
			if v5 then
				local v6 = nil
				if p5 then
					local v7 = v5.LinkedEvents and v5.LinkedEvents.Variants[p5]
					if v7 then
						v6 = v7
					end
				elseif p2 then
					local v8 = v5.AreaConfiguration and v5.AreaConfiguration.Variants[p2]
					if v8 then
						v6 = v8
					end
				end
				if v6 then
					for i2, v7 in ipairs(v6) do
						table.insert(v2, v7)
					end
				end
				if v5.Variants then
					for i2, v7 in ipairs(v5.Variants) do
						table.insert(v2, v7)
					end
				end
			end
		end
	end
	local v9 = Areas[p2]
	if v9 and v9.Variants then
		for i, v in ipairs(v9.Variants) do
			if not table.find(v2, v) then
				table.insert(v2, v)
			end
		end
	end
	for i, v in ipairs(VariantPool) do
		if not table.find(v2, v) then
			table.insert(v2, v)
		end
	end
	if p4 then
		for v10 in Variants do
			local v11 = v10:gsub(" ", "")
			if (p4[("%*Mutation"):format(v11)] or p4[("%*MutationMultiplier"):format(v11)]) and not table.find(v2, v10) then
				table.insert(v2, v10)
			end
		end
	end
	local t3 = {}
	for i, v in ipairs(v2) do
		local sum
		local v12 = t2:GetVariantData(v)
		if v12 then
			local Probability = v12.Probability
			if Probability then
				local v13 = v:gsub(" ", "")
				local v14 = if p4 then p4[("%*Mutation"):format(v13)] else p4
				local v15 = if v9 and (v9.VariantsChance and v9.VariantsChance[v]) then v9.VariantsChance[v] else nil
				if not v12.Exclusive or v14 then
					local v16 = if p4 then p4[("%*MutationMultiplier"):format(v13)] else p4
					local v17 = if v16 then v1 + v16 else v1
					sum = if v15 and v15 then v15 else Probability.Chance
					if v14 then
						sum = sum + v14
					end
					if sum ~= 0 then
						t3[v] = sum * v17
					end
				end
			end
		end
	end
	if p6 then
		for i, v in ipairs(p6) do
			local v18 = t[v]
			if v18 then
				if next(v18.Replace) then
					for v19, v20 in v18.Replace do
						local v21 = t3[v19]
						if v21 then
							t3[v20] = v21
							t3[v19] = nil
						end
					end
				end
				if #v18.Remove > 0 then
					for i2, v4 in ipairs(v18.Remove) do
						if t3[v4] then
							t3[v4] = nil
						end
					end
				end
			end
		end
	end
	return t3
end
function getEventsReplion() --[[ getEventsReplion | Line: 613 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsClient() then
		return Replion.Client:WaitReplion("Events")
	else
		return Replion.Server:WaitReplion("Events")
	end
end
v1 = {
	Potions = t2.GetPotionData,
	Boats = t2.GetBoatData,
	Baits = t2.GetBaitData,
	Variants = t2.GetVariantData,
	Enchantments = t2.GetEnchantData,
	Totems = t2.GetTotemData,
	Lanterns = t2.GetLanternData,
	Charms = t2.GetCharmData,
	Emotes = t2.GetEmoteData,
	Halos = t2.GetHaloData,
	Booths = t2.GetBoothData,
	Abilities = t2.GetAbilityData,
	Pets = t2.GetPetData,
	["Pet Eggs"] = t2.GetPetEggData
}
return t2