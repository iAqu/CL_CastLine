-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:04
-- Luau version 6, Types version 3
-- Time taken: 0.007296 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("DialogEventTypes")
local var1_result1_upvr_2 = any_load_result1("DialogLineTypes")
local module_upvr = {}
local function searchStackForNextWord_upvr(arg1, arg2) -- Line 21, Named "searchStackForNextWord"
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	for i = arg2 + 1, #arg1 do
		if arg1[i].type == var1_result1_upvr_3.WORD then
			return arg1[i]
		end
		if arg1[i].type == var1_result1_upvr_3.FORCED_PAGE_BREAK then
			return nil
		end
	end
	return nil
end
function module_upvr.createForcedPageBreakLine() -- Line 33
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return {
		type = var1_result1_upvr_2.FORCED_PAGE_BREAK_LINE;
	}
end
function module_upvr.createLine(arg1, arg2, arg3, arg4) -- Line 39
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg1, "Bad items")
	assert(arg2, "Bad offsetY")
	assert(arg3, "Bad height")
	assert(arg4, "Bad width")
	local module = {
		type = var1_result1_upvr_2.LINE;
	}
	module.offsetY = arg2
	module.height = arg3
	module.width = arg4
	module.items = arg1
	return module
end
local var1_result1_upvr_4 = any_load_result1("DialogStyleUtils")
local TextService_upvr = game:GetService("TextService")
local vector2_upvr = Vector2.new(1000000, 1000000)
local var1_result1_upvr = any_load_result1("DialogTextUtils")
local HttpService_upvr = game:GetService("HttpService")
function module_upvr.parseStackToLines(arg1, arg2) -- Line 54
	--[[ Upvalues[8]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: module_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: searchStackForNextWord_upvr (readonly)
		[5]: TextService_upvr (readonly)
		[6]: vector2_upvr (readonly)
		[7]: var1_result1_upvr (readonly)
		[8]: HttpService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local tbl_upvr = {}
	local var14_upvw = 0
	local any_getStyleFromStack_result1_upvw = var1_result1_upvr_4.getStyleFromStack(var1_result1_upvr_4.createDefaultStack())
	local tbl_upvw = {}
	local var18_upvw = 0
	local maximum_upvw = math.max(16, any_getStyleFromStack_result1_upvw.textSize)
	local function _() -- Line 64, Named "endLine"
		--[[ Upvalues[7]:
			[1]: module_upvr (copied, readonly)
			[2]: tbl_upvw (read and write)
			[3]: var18_upvw (read and write)
			[4]: maximum_upvw (read and write)
			[5]: var14_upvw (read and write)
			[6]: tbl_upvr (readonly)
			[7]: any_getStyleFromStack_result1_upvw (read and write)
		]]
		local any_createLine_result1 = module_upvr.createLine(tbl_upvw, var18_upvw, maximum_upvw, var14_upvw)
		table.insert(tbl_upvr, any_createLine_result1)
		tbl_upvw = {}
		var14_upvw = 0
		var18_upvw = var18_upvw + any_createLine_result1.height + any_createLine_result1.height * 0.16666666666666666
		maximum_upvw = math.max(16, any_getStyleFromStack_result1_upvw.textSize)
	end
	local pairs_result1_2, pairs_result2_3, pairs_result3_4 = pairs(arg1)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [352] 253. Error Block 47 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [352] 253. Error Block 47 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [36] 29. Error Block 82 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [352.15]
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [352.16]
	if nil == nil then
		if nil == 0 then
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if not nil then
		end
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [352.18]
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [352.17]
		if nil < nil then
			if arg2 < nil then
			end
			-- KONSTANTWARNING: GOTO [352] #253
		end
	else
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if nil == nil then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if nil then
			else
			end
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if nil == nil then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if nil >= nil then
				else
				end
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if nil then
				else
				end
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if nil == nil then
					if arg2 < nil then
					end
				else
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x4)
					if nil == nil or nil == nil or nil == nil or nil == nil then
					else
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect
						if nil == nil then
						else
							-- KONSTANTERROR: Expression was reused, decompilation is incorrect
							if nil then
							else
							end
						end
					end
				end
			end
		end
	end
	-- KONSTANTERROR: [36] 29. Error Block 82 end (CF ANALYSIS FAILED)
end
function module_upvr.onlyStyleItems(arg1) -- Line 153
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	for _, v in pairs(arg1) do
		if v.type ~= var1_result1_upvr_3.PUSH_STYLE and v.type ~= var1_result1_upvr_3.POP_STYLE then
			return false
		end
	end
	return true
end
function module_upvr.centerLines(arg1, arg2) -- Line 163
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	for _, v_2 in pairs(arg1) do
		if v_2.type == var1_result1_upvr_2.LINE then
			for _, v_3 in pairs(v_2.items) do
				if v_3.type == var1_result1_upvr_3.POSITIONED_WORD or v_3.type == var1_result1_upvr_3.POSITIONED_INPUT_HINT then
					v_3.offsetX += (arg2 - v_2.width) / 2
				end
			end
		end
	end
end
return module_upvr