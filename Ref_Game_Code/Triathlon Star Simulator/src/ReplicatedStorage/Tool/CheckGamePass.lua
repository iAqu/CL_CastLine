-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:30
-- Luau version 6, Types version 3
-- Time taken: 0.001139 seconds

local module_upvr = {
	IsHasPass = function(arg1, arg2) -- Line 7, Named "IsHasPass"
		local GamePass = arg1:FindFirstChild("GamePass")
		if not GamePass then
			return false
		end
		local SOME = GamePass:FindFirstChild(arg2)
		if not SOME then
			return false
		end
		if SOME and 0 < SOME.Value then
			return true
		end
		return false
	end;
}
local CfgFind_upvr = require(game.ReplicatedStorage.Tool.CfgFind)
function module_upvr.GetCanBuyOnlyTag(arg1, arg2) -- Line 28
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_FindCfgByOnlyTag_result1 = CfgFind_upvr.FindCfgByOnlyTag(arg2)
	local NeedBuy = any_FindCfgByOnlyTag_result1.NeedBuy
	if NeedBuy ~= "" then
		if module_upvr.IsHasPass(arg1, NeedBuy) then
			if module_upvr.IsHasPass(arg1, arg2) then
				local NextBug_2 = any_FindCfgByOnlyTag_result1.NextBug
				if NextBug_2 ~= "" then
					if module_upvr.IsHasPass(arg1, NextBug_2) then
						return module_upvr.GetCanBuyOnlyTag(arg1, NextBug_2)
					end
					return NextBug_2
				end
				return arg2
			end
			return arg2
		end
		return module_upvr.GetCanBuyOnlyTag(arg1, NeedBuy)
	end
	if module_upvr.IsHasPass(arg1, arg2) then
		local NextBug = any_FindCfgByOnlyTag_result1.NextBug
		if NextBug ~= "" then
			if module_upvr.IsHasPass(arg1, NextBug) then
				return module_upvr.GetCanBuyOnlyTag(arg1, NextBug)
			end
			return NextBug
		end
		return arg2
	end
	return arg2
end
return module_upvr