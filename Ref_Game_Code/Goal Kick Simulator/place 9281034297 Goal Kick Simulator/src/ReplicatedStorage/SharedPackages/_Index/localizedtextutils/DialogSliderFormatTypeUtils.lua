-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:43
-- Luau version 6, Types version 3
-- Time taken: 0.001207 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("DialogSliderFormatTypes")
function module.formatValue(arg1, arg2) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	if arg1 == var2_upvr.DEFAULT then
		return tostring(arg2)
	end
	if arg1 == var2_upvr.TIME_OF_DAY_HOURS then
		local floored = math.floor(arg2)
		if floored == 0 then
			floored = 12
		end
		return "%d:%02d":format(floored, math.floor(arg2 % 1 * 60))
	end
	if arg1 == var2_upvr.LOG_10_SCALE then
		return "%0.3f":format(10 ^ arg2)
	end
	error("[DialogSliderFormatTypeUtils] - Unknown format type %q":format(tostring(arg1)))
end
return module