-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:02
-- Luau version 6, Types version 3
-- Time taken: 0.001693 seconds

local module_upvr = {
	getRelativeLuminance = function(arg1) -- Line 18, Named "getRelativeLuminance"
		local module = {}
		for i, v in pairs({arg1.r, arg1.g, arg1.b}) do
			if v <= 0.03928 then
				module[i] = v / 12.92
			else
				module[i] = ((v + 0.055) / 1.055) ^ 2.4
			end
		end
		return 0.2126 * module[1] + 0.7152 * module[2] + 0.0722 * module[3]
	end;
}
function module_upvr.textShouldBeBlack(arg1) -- Line 41
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var9
	if 0.179 >= module_upvr.getRelativeLuminance(arg1) then
		var9 = false
	else
		var9 = true
	end
	return var9
end
function module_upvr.scaleValue(arg1, arg2) -- Line 51
	local Color3_toHSV_result1_4, Color3_toHSV_result2_4, Color3_toHSV_result3 = Color3.toHSV(arg1)
	return Color3.fromHSV(Color3_toHSV_result1_4, Color3_toHSV_result2_4, arg2 * Color3_toHSV_result3)
end
function module_upvr.setValue(arg1, arg2) -- Line 62
	local Color3_toHSV_result1_2, Color3_toHSV_result2, _ = Color3.toHSV(arg1)
	return Color3.fromHSV(Color3_toHSV_result1_2, Color3_toHSV_result2, arg2)
end
function module_upvr.setHue(arg1, arg2) -- Line 73
	local _, Color3_toHSV_result2_2, Color3_toHSV_result3_4 = Color3.toHSV(arg1)
	return Color3.fromHSV(arg2, Color3_toHSV_result2_2, Color3_toHSV_result3_4)
end
function module_upvr.scaleSaturation(arg1, arg2) -- Line 84
	local Color3_toHSV_result1_3, Color3_toHSV_result2_3, Color3_toHSV_result3_2 = Color3.toHSV(arg1)
	return Color3.fromHSV(Color3_toHSV_result1_3, arg2 * Color3_toHSV_result2_3, Color3_toHSV_result3_2)
end
function module_upvr.setSaturation(arg1, arg2) -- Line 95
	local Color3_toHSV_result1, _, Color3_toHSV_result3_3 = Color3.toHSV(arg1)
	return Color3.fromHSV(Color3_toHSV_result1, arg2, Color3_toHSV_result3_3)
end
return module_upvr