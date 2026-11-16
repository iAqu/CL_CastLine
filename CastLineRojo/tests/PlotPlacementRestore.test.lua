local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

_G.typeof = type

local PlotPlacementUtil = dofile("src/ReplicatedStorage/Modules/PlotPlacementUtil.lua")

local function stringifyKeys(source)
	local encoded = {}
	for key, value in pairs(source) do
		encoded[tostring(key)] = value
	end
	return encoded
end

-- Current restore lookup before coercion: number slot vs DataStore string keys.
local function oldRestoreLookup(placements, slot)
	return type(slot) == "number" and placements[slot] or nil
end

local function resolveJoinLocation(placements, items, slot, instanceId)
	local itemUid = PlotPlacementUtil.GetItemUid(placements, slot)
	local canDisplay = itemUid == instanceId
	if canDisplay then
		return "plot"
	end
	if PlotPlacementUtil.IsPlaced(placements, instanceId) then
		return "lost"
	end
	if type(items) == "table" and items[instanceId] ~= nil then
		return "backpack"
	end
	return "lost"
end

local ITEM_UID = "item_placed_1"
local items = {
	[ITEM_UID] = {
		ItemId = "Item_1",
		Weight = 2,
		ConditionId = "Codition_1",
	},
}

local stringKeyedPlacements = stringifyKeys({
	[2] = ITEM_UID,
})

assert(oldRestoreLookup(stringKeyedPlacements, 2) == nil, "DataStore string keys must miss a raw numeric slot lookup")
assert(PlotPlacementUtil.GetItemUid(stringKeyedPlacements, 2) == ITEM_UID, "Restore must read either numeric or string slot keys")
assert(resolveJoinLocation(stringKeyedPlacements, items, 2, ITEM_UID) == "plot", "A saved placement must stay on the plot after a DataStore round-trip")

-- Old restore treated a missed lookup as an empty slot and only cleared the numeric key.
local wipedLikeOldRestore = stringifyKeys({ [2] = ITEM_UID })
wipedLikeOldRestore[2] = nil
assert(oldRestoreLookup(wipedLikeOldRestore, 2) == nil, "Old restore still cannot see the string-keyed placement")
assert(PlotPlacementUtil.GetItemUid(wipedLikeOldRestore, 2) == ITEM_UID, "Clearing placements[2] must not erase placements['2']")
assert(resolveJoinLocation(wipedLikeOldRestore, items, 2, ITEM_UID) == "plot", "The item must remain placeable after a numeric-only clear")
assert(
	PlotPlacementUtil.IsPlaced(wipedLikeOldRestore, ITEM_UID)
		and oldRestoreLookup(wipedLikeOldRestore, 2) == nil,
	"A missed restore plus a still-marked placement hides the item from both the plot and backpack"
)

local emptyPlacements = {}
assert(resolveJoinLocation(emptyPlacements, items, 2, ITEM_UID) == "backpack", "Wiping the placement record must send the surviving item back to the backpack")

local coerced = PlotPlacementUtil.CoerceNumericKeys(stringKeyedPlacements)
assert(coerced[2] == ITEM_UID, "Sanitizing must restore numeric slot keys")
assert(coerced["2"] == nil, "Sanitizing must drop the string twin key")

local writable = stringifyKeys({ [1] = "old" })
PlotPlacementUtil.SetItemUid(writable, 1, "new")
assert(writable[1] == "new", "Writes must use a numeric slot key")
assert(writable["1"] == nil, "Writes must clear the string twin key")
PlotPlacementUtil.ClearSlot(writable, 1)
assert(writable[1] == nil and writable["1"] == nil, "Clears must remove both slot key forms")

local plotFishService = read("src/ServerScriptService/Services/PlotFishService.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")
local cashPoolService = read("src/ReplicatedStorage/Modules/PlotFishIncome.lua")

assert(plotFishService:find("PlotPlacementUtil.GetItemUid", 1, true), "Fish restore must coerce saved slot keys")
assert(plotFishService:find("PlotPlacementUtil.SetItemUid", 1, true), "Placing must write a numeric slot key")
assert(plotFishService:find("PlotPlacementUtil.ClearSlot", 1, true), "Pickup must clear both key forms")
assert(
	not plotFishService:find('typeof(slot) == "number" and profile.Data.PlotPlacements[slot]', 1, true),
	"Raw numeric PlotPlacements lookup is the DataStore key-mismatch bug"
)
assert(playerDataService:find("PlotPlacementUtil.CoerceNumericKeys", 1, true), "Loaded profiles must sanitize placement keys")
assert(cashPoolService:find("PlotPlacementUtil.GetItemUid", 1, true), "Cash production must read coerced placement keys")

print("PlotPlacementRestore.test.lua passed")
