-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:49
-- Luau version 6, Types version 3
-- Time taken: 0.000827 seconds

local module = {}
local InsMgr_upvr = require(game:GetService("ReplicatedStorage").Tool.InsMgr)
function module.TurnOnDebounce(arg1) -- Line 7
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	InsMgr_upvr.GetIns("Debounce", "NumberValue", arg1).Value = 1
end
function module.TurnOffDebounce(arg1) -- Line 18
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	InsMgr_upvr.GetIns("Debounce", "NumberValue", arg1).Value = 0
end
function module.IsDebounceReady(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	if InsMgr_upvr.GetIns("Debounce", "NumberValue", arg1).Value == 1 then
		return false
	end
	return true
end
return module