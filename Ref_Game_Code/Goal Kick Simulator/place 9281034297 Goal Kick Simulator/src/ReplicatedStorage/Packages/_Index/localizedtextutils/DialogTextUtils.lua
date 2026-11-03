-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:40
-- Luau version 6, Types version 3
-- Time taken: 0.005248 seconds

local var1_upvr = require(script.Parent.loader).load(script)("DialogEventTypes")
local module_5_upvr = {}
local tbl_upvr = {
	[' '] = true;
	['\n'] = true;
}
function module_5_upvr.splitIntoWords(arg1) -- Line 16
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local module_7 = {}
	local var12
	for i, v in utf8.graphemes(arg1) do
		local any_sub_result1 = arg1:sub(i, v)
		if tbl_upvr[any_sub_result1] then
			if any_sub_result1 == '\n' then
				if 0 < #var12 then
					table.insert(module_7, var12)
				end
				table.insert(module_7, any_sub_result1)
				var12 = ""
			else
				var12 = var12..any_sub_result1
			end
		elseif true then
			table.insert(module_7, var12)
			var12 = any_sub_result1
		else
			var12 = var12..any_sub_result1
		end
	end
	if 0 < #var12 then
		table.insert(module_7, var12)
	end
	return module_7
end
function module_5_upvr.parseWordsToStack(arg1) -- Line 57
	--[[ Upvalues[1]:
		[1]: module_5_upvr (readonly)
	]]
	for _, v_2 in pairs(arg1) do
		if v_2 == '\n' then
			table.insert({}, module_5_upvr.createForcedPageBreak())
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.insert({}, module_5_upvr.createWord(v_2))
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_5_upvr.createPositionedWord(arg1, arg2, arg3) -- Line 71
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	assert(arg1, "Bad text")
	assert(arg2, "Bad offsetX")
	local var19 = arg3
	assert(var19, "Bad size")
	if 0 >= #arg1 then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad text length (0)")
	local module_8 = {
		type = var1_upvr.POSITIONED_WORD;
	}
	module_8.text = arg1
	module_8.offsetX = arg2
	module_8.size = arg3
	return module_8
end
function module_5_upvr.createAddPlaybackSpeedMultiplier(arg1) -- Line 86
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	local var21
	if type(arg1) ~= "number" then
		var21 = false
	else
		var21 = true
	end
	assert(var21, "Bad multiplier")
	local module_3 = {}
	var21 = var1_upvr.ADD_PLAYBACK_SPEED_MULTIPLIER
	module_3.type = var21
	module_3.multiplier = arg1
	return module_3
end
function module_5_upvr.createAddVolumeMultiplier(arg1) -- Line 95
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	local var23
	if type(arg1) ~= "number" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad multiplier")
	local module_6 = {}
	var23 = var1_upvr.ADD_VOLUME_MULTIPLIER
	module_6.type = var23
	module_6.multiplier = arg1
	return module_6
end
function module_5_upvr.createInputImage(arg1) -- Line 104
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	assert(arg1, "Bad inputKeyMapList")
	local module_10 = {
		type = var1_upvr.INPUT_HINT;
	}
	module_10.inputKeyMapList = arg1
	return module_10
end
function module_5_upvr.createPositionedInputHint(arg1, arg2, arg3) -- Line 113
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	assert(arg1, "Bad inputKeyMapList")
	local module_9 = {
		type = var1_upvr.POSITIONED_INPUT_HINT;
	}
	module_9.inputKeyMapList = arg1
	module_9.offsetX = arg2
	module_9.size = arg3
	return module_9
end
function module_5_upvr.createForcedPageBreak() -- Line 124
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	return {
		type = var1_upvr.FORCED_PAGE_BREAK;
	}
end
function module_5_upvr.createDialogHumanoidParticipantEvent(arg1) -- Line 130
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	local var28
	if type(arg1) ~= "table" then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Bad event")
	if type(arg1.type) ~= "string" then
		var28 = false
	else
		var28 = true
	end
	assert(var28, "Bad event.type")
	local module = {}
	var28 = var1_upvr.HUMANOID_PARTICIPANT_EVENT
	module.type = var28
	module.event = arg1
	return module
end
function module_5_upvr.createWord(arg1) -- Line 141
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	local var30 = arg1
	if var30 then
		if 0 >= #arg1 then
			var30 = false
		else
			var30 = true
		end
	end
	assert(var30, "Bad text")
	local module_4 = {
		type = var1_upvr.WORD;
	}
	module_4.text = arg1
	return module_4
end
function module_5_upvr.createPause(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	assert(arg1, "Bad length")
	local module_11 = {
		type = var1_upvr.PAUSE;
	}
	module_11.length = arg1
	return module_11
end
function module_5_upvr.createTag(arg1) -- Line 159
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	assert(arg1, "Bad text")
	local module_2 = {
		type = var1_upvr.TAG;
	}
	module_2.text = arg1
	return module_2
end
return module_5_upvr