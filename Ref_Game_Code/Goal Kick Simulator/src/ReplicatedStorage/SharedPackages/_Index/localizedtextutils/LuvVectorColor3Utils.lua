-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:45
-- Luau version 6, Types version 3
-- Time taken: 0.000861 seconds

local var1_upvr = require(script.Parent.loader).load(script)("LuvUtils")
return {
	fromColor3 = function(arg1) -- Line 17, Named "fromColor3"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local any_rgb_to_hsluv_result1 = var1_upvr.rgb_to_hsluv({arg1.r, arg1.g, arg1.b})
		return Vector3.new(any_rgb_to_hsluv_result1[1] / 200 + 0.5, any_rgb_to_hsluv_result1[2] / 200 + 0.5, any_rgb_to_hsluv_result1[3] / 200 + 0.5)
	end;
	toColor3 = function(arg1) -- Line 32, Named "toColor3"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		return Color3.new(unpack(var1_upvr.hsluv_to_rgb({(arg1.x - 0.5) * 200, (arg1.y - 0.5) * 200, (arg1.z - 0.5) * 200})))
	end;
}