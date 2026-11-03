-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:51
-- Luau version 6, Types version 3
-- Time taken: 0.002117 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogSliderOptionTypes")
local var1_result1_upvr = any_load_result1("DialogSliderFormatTypes")
return {
	createSliderOptions = function(arg1) -- Line 12, Named "createSliderOptions"
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (readonly)
			[2]: var1_result1_upvr_2 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 54 start (CF ANALYSIS FAILED)
		local var5
		if type(arg1) ~= "table" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad options")
		if type(arg1.key) ~= "string" then
			var5 = false
			-- KONSTANTWARNING: GOTO [25] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 54 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [24] 18. Error Block 61 start (CF ANALYSIS FAILED)
		var5 = true
		assert(var5, "Bad options.key")
		if type(arg1.initialValue) ~= "number" then
			var5 = false
			-- KONSTANTWARNING: GOTO [41] #30
		end
		-- KONSTANTERROR: [24] 18. Error Block 61 end (CF ANALYSIS FAILED)
	end;
	createLocalizedSliderOptions = function(arg1) -- Line 35, Named "createLocalizedSliderOptions"
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (readonly)
			[2]: var1_result1_upvr_2 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 75 start (CF ANALYSIS FAILED)
		local var6
		if type(arg1) ~= "table" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad options")
		if type(arg1.key) ~= "string" then
			var6 = false
			-- KONSTANTWARNING: GOTO [25] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 75 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [24] 18. Error Block 82 start (CF ANALYSIS FAILED)
		var6 = true
		assert(var6, "Bad options.key")
		if type(arg1.initialValue) ~= "number" then
			var6 = false
			-- KONSTANTWARNING: GOTO [41] #30
		end
		-- KONSTANTERROR: [24] 18. Error Block 82 end (CF ANALYSIS FAILED)
	end;
	createSliderResult = function(arg1, arg2) -- Line 62, Named "createSliderResult"
		local var7
		if type(arg1) ~= "number" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad value")
		if type(arg2) ~= "number" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad percent")
		local module = {}
		module.value = arg1
		module.percent = arg2
		return module
	end;
}