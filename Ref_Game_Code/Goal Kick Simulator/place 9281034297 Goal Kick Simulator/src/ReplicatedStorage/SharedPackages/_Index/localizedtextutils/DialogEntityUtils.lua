-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:46
-- Luau version 6, Types version 3
-- Time taken: 0.004948 seconds

local var1_upvr = require(script.Parent.loader).load(script)("DialogEntityTypes")
local module_upvr = {
	createEntity = function(arg1, arg2) -- Line 11, Named "createEntity"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var3
		if type(arg1) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad text")
		if typeof(arg2) ~= "Color3" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad color")
		local module_2 = {}
		var3 = var1_upvr.ENTITY
		module_2.type = var3
		module_2.text = arg1
		module_2.textColor3 = arg2
		return module_2
	end;
	createLocalizedEntity = function(arg1, arg2, arg3) -- Line 22, Named "createLocalizedEntity"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var5
		if type(arg1) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad translationKey")
		if typeof(arg2) ~= "Color3" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad color")
		var5 = true
		if type(arg3) ~= "table" then
			if arg3 ~= nil then
				var5 = false
			else
				var5 = true
			end
		end
		assert(var5, "Bad translationArgs")
		local module_4 = {}
		var5 = var1_upvr.LOCALIZED_ENTITY
		module_4.type = var5
		module_4.translationKey = arg1
		var5 = arg3
		if not var5 then
			var5 = {}
		end
		module_4.translationArgs = var5
		module_4.textColor3 = arg2
		return module_4
	end;
	createLocalizedCurrencyAmount = function(arg1, arg2, arg3) -- Line 35, Named "createLocalizedCurrencyAmount"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
		local var7
		if type(arg1) ~= "number" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad amount")
		if type(arg2) ~= "string" then
			var7 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
		var7 = true
		assert(var7, "Bad formatKey")
		if typeof(arg3) ~= "Color3" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad color")
		local module_3 = {}
		var7 = var1_upvr.LOCALIZED_CURRENCY_AMOUNT
		module_3.type = var7
		module_3.amount = arg1
		module_3.formatKey = arg2
		module_3.textColor3 = arg3
		do
			return module_3
		end
		-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
	end;
	createInputHint = function(arg1) -- Line 48, Named "createInputHint"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var9
		if type(arg1) ~= "table" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad inputKeyMapList")
		var9 = arg1
		assert(var9, "Bad inputKeyMapList")
		local module = {}
		var9 = var1_upvr.INPUT_HINT
		module.type = var9
		module.inputKeyMapList = arg1
		return module
	end;
	createLocalizedInputHint = function(arg1, arg2) -- Line 58, Named "createLocalizedInputHint"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var11
		if type(arg1) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad inputKeyMapListProviderName")
		if type(arg2) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad inputKeyMapListName")
		local module_5 = {}
		var11 = var1_upvr.LOCALIZED_INPUT_HINT
		module_5.type = var11
		module_5.inputKeyMapListProviderName = arg1
		module_5.inputKeyMapListName = arg2
		return module_5
	end;
}
function module_upvr.createTalkerEntity(arg1, arg2, arg3) -- Line 69
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var13
	if type(arg1) ~= "string" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad text")
	if typeof(arg2) ~= "Color3" then
		var13 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var13 = true
	assert(var13, "Bad color")
	if type(arg3) ~= "number" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad voicePitchAdjustment")
	var13 = module_upvr
	var13 = arg1
	local any_createEntity_result1 = var13.createEntity(var13, arg2)
	var13 = var1_upvr.TALKER_ENTITY
	any_createEntity_result1.type = var13
	any_createEntity_result1.voicePitchAdjustment = arg3
	do
		return any_createEntity_result1
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.createLocalizedTalkerEntity(arg1, arg2, arg3, arg4) -- Line 81
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
	local var15
	if type(arg1) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad translationKey")
	if typeof(arg2) ~= "Color3" then
		var15 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 31 start (CF ANALYSIS FAILED)
	var15 = true
	assert(var15, "Bad color")
	if type(arg3) ~= "number" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad voicePitchAdjustment")
	var15 = true
	if type(arg4) ~= "table" then
		if arg4 ~= nil then
			var15 = false
		else
			var15 = true
		end
	end
	assert(var15, "Bad translationArgs")
	var15 = module_upvr
	var15 = arg1
	local any_createLocalizedEntity_result1 = var15.createLocalizedEntity(var15, arg2, arg4)
	var15 = var1_upvr.LOCALIZED_TALKER_ENTITY
	any_createLocalizedEntity_result1.type = var15
	any_createLocalizedEntity_result1.voicePitchAdjustment = arg3
	do
		return any_createLocalizedEntity_result1
	end
	-- KONSTANTERROR: [23] 18. Error Block 31 end (CF ANALYSIS FAILED)
end
function module_upvr.createPlayerEntityFromPlayer(arg1) -- Line 94
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "No player")
	return module_upvr.createPlayerEntity(arg1.DisplayName)
end
function module_upvr.createPlayerEntity(arg1) -- Line 100
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.createEntity(arg1, module_upvr._getPlayerEntityColor())
end
function module_upvr.createTalkingPlayerEntityFromPlayer(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.createTalkingPlayerEntity(arg1.DisplayName)
end
function module_upvr.createTalkingPlayerEntity(arg1) -- Line 108
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.createTalkerEntity(arg1, module_upvr._getPlayerEntityColor(), 0)
end
function module_upvr._getPlayerEntityColor() -- Line 112
	return Color3.fromRGB(0, 170, 127)
end
function module_upvr.createLocalizedGameNameEntity() -- Line 116
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.createLocalizedEntity("game.name", Color3.fromRGB(255, 85, 127))
end
function module_upvr.createNumberEntity(arg1) -- Line 120
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var17
	if type(arg1) ~= "number" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad number")
	var17 = module_upvr
	var17 = tostring(arg1)
	return var17.createEntity(var17, Color3.fromRGB(255, 85, 127))
end
return module_upvr