-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:08
-- Luau version 6, Types version 3
-- Time taken: 0.001759 seconds

local module = {}
local tbl_upvr = {
	["待机"] = {18733008653, 131398984967009};
	["龙虾教练鼓励"] = {18967201457, 130839281676759};
	["星球武士教练鼓励"] = {18967216057, 132373487720041};
	["麦克教练鼓励"] = {18967222372, 103602183164694};
	["钉子教练鼓励"] = {18967228017, 78661285697763};
	["女教练鼓励"] = {18764283518, 120725845460788};
	["男教练鼓励"] = {18764275299, 111733911414584};
	["胖胖女教练鼓励"] = {18967212432, 138731793368032};
	["加速战斗奔跑"] = {110430412702742, 98470703996184};
	["加速骑行"] = {121448147231065, 132611658795836};
	["加速游泳"] = {73166328908107, 85315098807206};
	["游泳"] = {132664597877950, 84862189616779};
	["加速骑行自行车"] = {129038216849320, 128339965167700};
	["骑行自行车"] = {82306039151445, 78638205768244};
	["骑行"] = {126230278451602, 86242312298957};
	["自行车移动"] = {80197080354655, 113729561092402};
	["飞行待机"] = {18858400269, 127784835981359};
	["行走待机"] = {18858394247, 111033731757948};
	["宠物飞行"] = {18843056911, 101984351813705};
	["宠物行走"] = {18843075089, 121771869056014};
	["战斗奔跑"] = {18721735423, 76136253477833};
	["行走"] = {913402848, 85547856220792};
}
local CheckPlace_upvr = require(script.CheckPlace)
function module.GetPreloadTable() -- Line 115
	--[[ Upvalues[2]:
		[1]: CheckPlace_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local module_2 = {}
	local var31
	if not var31 then
		var31 = 2
	end
	for _, v in pairs(tbl_upvr) do
		table.insert(module_2, "rbxassetid://"..v[var31])
	end
	return module_2
end
return module