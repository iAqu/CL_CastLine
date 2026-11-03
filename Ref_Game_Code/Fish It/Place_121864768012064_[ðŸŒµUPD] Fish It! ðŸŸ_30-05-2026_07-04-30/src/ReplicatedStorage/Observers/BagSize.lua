-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local Constants = require(ReplicatedStorage.Shared.Constants)
local t = {
	FishCount = 0,
	ItemCount = 0,
	RodCount = 0
}
local t2 = {
	FishCount = {},
	ItemCount = {},
	RodCount = {}
}
local t3 = {
	FishCount = StringLibrary:AddCommas(Constants.MaxInventorySize),
	ItemCount = StringLibrary:AddCommas(Constants.MaxItemSize),
	RodCount = StringLibrary:AddCommas(Constants.RodSize)
}
local t4 = { "Inventory", "Items" }
local t5 = { "Inventory", "Fishing Rods" }
local v1 = Color3.fromRGB(255, 67, 86)
local v2 = Color3.fromRGB(255, 255, 255)
local function OnFishCountChanged(p1, p2) --[[ OnFishCountChanged | Line: 42 | Upvalues: t3 (copy), t2 (copy), StringLibrary (copy), Constants (copy), v1 (copy), v2 (copy) ]]
	local v22 = t2[p1]
	if not v22 then
		return
	end
	local v4 = ("%*/%*"):format(StringLibrary:AddCommas(p2), t3[p1])
	for i, v in ipairs(v22) do
		v.Text = v4
		v.TextColor3 = if Constants.MaxInventorySize <= p2 then v1 else v2
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 60 | Upvalues: Constants (copy), t (copy), OnFishCountChanged (copy), t5 (copy), t4 (copy) ]]
	local function inventoryChanged() --[[ inventoryChanged | Line: 62 | Upvalues: Constants (ref), p1 (copy), t (ref), OnFishCountChanged (ref) ]]
		local v1, v2 = Constants:CountInventorySize(p1)
		t.FishCount = v1
		t.ItemCount = v2
		OnFishCountChanged("FishCount", v1)
		OnFishCountChanged("ItemCount", v2)
	end
	p1:OnChange(t5, function() --[[ rodChanged | Line: 71 | Upvalues: Constants (ref), p1 (copy), t (ref), OnFishCountChanged (ref) ]]
		local v1 = Constants:CountRodSize(p1)
		t.RodCount = v1
		OnFishCountChanged("RodCount", v1)
	end)
	local v1 = Constants:CountRodSize(p1)
	t.RodCount = v1
	OnFishCountChanged("RodCount", v1)
	p1:OnChange(t4, inventoryChanged)
	p1:OnArrayInsert(t4, inventoryChanged)
	p1:OnArrayRemove(t4, inventoryChanged)
	local v2, v3 = Constants:CountInventorySize(p1)
	t.FishCount = v2
	t.ItemCount = v3
	OnFishCountChanged("FishCount", v2)
	OnFishCountChanged("ItemCount", v3)
end)
local function AddLabel(p1, p2) --[[ AddLabel | Line: 87 | Upvalues: t2 (copy), t (copy), OnFishCountChanged (copy) ]]
	local v1 = t2[p2]
	table.insert(v1, p1)
	local v2 = t[p2]
	if not v2 then
		return function() --[[ Line: 96 | Upvalues: v1 (copy), p1 (copy) ]]
			local v12 = table.find(v1, p1)
			if not v12 then
				return
			end
			table.remove(v1, v12)
		end
	end
	OnFishCountChanged(p2, v2)
	return function() --[[ Line: 96 | Upvalues: v1 (copy), p1 (copy) ]]
		local v12 = table.find(v1, p1)
		if not v12 then
			return
		end
		table.remove(v1, v12)
	end
end
Observers.observeTag("BagSize", function(p1) --[[ Line: 104 | Upvalues: t2 (copy), t (copy), OnFishCountChanged (copy) ]]
	local FishCount = t2.FishCount
	table.insert(FishCount, p1)
	local FishCount_2 = t.FishCount
	if not FishCount_2 then
		return function() --[[ Line: 96 | Upvalues: FishCount (copy), p1 (copy) ]]
			local v12 = table.find(FishCount, p1)
			if not v12 then
				return
			end
			table.remove(FishCount, v12)
		end
	end
	OnFishCountChanged("FishCount", FishCount_2)
	return function() --[[ Line: 96 | Upvalues: FishCount (copy), p1 (copy) ]]
		local v12 = table.find(FishCount, p1)
		if not v12 then
			return
		end
		table.remove(FishCount, v12)
	end
end)
Observers.observeTag("ItemSize", function(p1) --[[ Line: 108 | Upvalues: t2 (copy), t (copy), OnFishCountChanged (copy) ]]
	local ItemCount = t2.ItemCount
	table.insert(ItemCount, p1)
	local ItemCount_2 = t.ItemCount
	if not ItemCount_2 then
		return function() --[[ Line: 96 | Upvalues: ItemCount (copy), p1 (copy) ]]
			local v12 = table.find(ItemCount, p1)
			if not v12 then
				return
			end
			table.remove(ItemCount, v12)
		end
	end
	OnFishCountChanged("ItemCount", ItemCount_2)
	return function() --[[ Line: 96 | Upvalues: ItemCount (copy), p1 (copy) ]]
		local v12 = table.find(ItemCount, p1)
		if not v12 then
			return
		end
		table.remove(ItemCount, v12)
	end
end)
Observers.observeTag("RodSize", function(p1) --[[ Line: 112 | Upvalues: t2 (copy), t (copy), OnFishCountChanged (copy) ]]
	local RodCount = t2.RodCount
	table.insert(RodCount, p1)
	local RodCount_2 = t.RodCount
	if not RodCount_2 then
		return function() --[[ Line: 96 | Upvalues: RodCount (copy), p1 (copy) ]]
			local v12 = table.find(RodCount, p1)
			if not v12 then
				return
			end
			table.remove(RodCount, v12)
		end
	end
	OnFishCountChanged("RodCount", RodCount_2)
	return function() --[[ Line: 96 | Upvalues: RodCount (copy), p1 (copy) ]]
		local v12 = table.find(RodCount, p1)
		if not v12 then
			return
		end
		table.remove(RodCount, v12)
	end
end)
return {}