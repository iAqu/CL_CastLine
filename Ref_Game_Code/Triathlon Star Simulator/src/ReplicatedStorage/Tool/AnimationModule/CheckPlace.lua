-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:57
-- Luau version 6, Types version 3
-- Time taken: 0.000692 seconds

local module = {}
local tbl_upvr_2 = {80845170579094}
local tbl_upvr = {70906625936847}
function module.CheckPlaceID() -- Line 20
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local PlaceId = game.PlaceId
	if not PlaceId then
		return 2
	end
	for _, v in pairs(tbl_upvr_2) do
		if PlaceId == v then
			return 1
		end
	end
	for _, v_2 in pairs(tbl_upvr) do
		if PlaceId == v_2 then
			return 2
		end
	end
	return 2
end
return module