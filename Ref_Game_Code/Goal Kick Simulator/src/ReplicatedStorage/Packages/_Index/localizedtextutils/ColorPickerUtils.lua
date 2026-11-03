-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:56
-- Luau version 6, Types version 3
-- Time taken: 0.001307 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("LuvColor3Utils")
function module.getOutlineWithContrast(arg1, arg2) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var3
	if typeof(arg1) ~= "Color3" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "Bad color")
	if typeof(arg2) ~= "Color3" then
		var3 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var3 = true
	assert(var3, "Bad backingColor")
	var3 = var2_upvr.fromColor3(arg1)
	local unpack_result1, unpack_result2, unpack_result3 = unpack(var3)
	local unpack_result1_2, _, unpack_result3_2 = unpack(var2_upvr.fromColor3(arg2))
	if unpack_result3_2 <= 50 then
	else
	end
	do
		return var2_upvr.toColor3({unpack_result1, unpack_result2, math.clamp(math.clamp(unpack_result3 + 80, 0, 100) - 80, 0, 100)})
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
return module