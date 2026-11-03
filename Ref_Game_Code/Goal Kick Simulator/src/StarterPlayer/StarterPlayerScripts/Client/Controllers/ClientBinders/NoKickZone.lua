-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:05
-- Luau version 6, Types version 3
-- Time taken: 0.000716 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {}
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	tbl_upvr[arg1] = true
	return function() -- Line 9
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = nil
	end
end
function module.IsInside(arg1, arg2) -- Line 14
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	for i in pairs(tbl_upvr) do
		if Util_upvr.CFrame.InsidePart(i, arg2) then
			return true
		end
	end
	return false
end
Util_upvr.NoKickZone = module
return module