-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:35
-- Luau version 6, Types version 3
-- Time taken: 0.003152 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local UI_StringFormat_upvr = arg1:GetAttribute("UI_StringFormat")
	local var5 = arg1:GetAttribute("UI_InfoType") or ""
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1 = Util_upvr.Link:GetLink(arg1:GetAttribute("UI_LinkName") or "PlayerData")
	local var8_upvw
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var8_upvw = tonumber(any_GetLink_result1[var5])
		return var8_upvw
	end
	if typeof(any_GetLink_result1[var5]) == "table" or not INLINED() then
		var8_upvw = 0
	end
	if not UI_StringFormat_upvr or not string.format(UI_StringFormat_upvr, Util_upvr.ValueConvertor:ShrinkNumber(math.floor(var8_upvw))) then
	end
	arg1.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(var8_upvw))
	local Size_upvr = arg1.Parent.Size
	any_new_result1_upvr:GiveTask(any_GetLink_result1.Changed:On(var5, function(arg1_2) -- Line 17
		--[[ Upvalues[6]:
			[1]: var8_upvw (read and write)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: UI_StringFormat_upvr (readonly)
			[6]: Size_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 16 start (CF ANALYSIS FAILED)
		local var11
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var11 = tonumber(arg1_2)
			return var11
		end
		if typeof(arg1_2) == "table" or not INLINED_2() then
			var11 = 0
		end
		local var12_upvw = var8_upvw
		var8_upvw = var11
		-- KONSTANTERROR: [0] 1. Error Block 16 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [19] 16. Error Block 21 start (CF ANALYSIS FAILED)
		if not any_new_result1_upvr.Animation then
			local const_number_upvw = 0
			local const_number_upvw_2 = -1
			any_new_result1_upvr.Animation = Util_upvr.Thread.Loop(function(arg1_3) -- Line 25
				--[[ Upvalues[9]:
					[1]: var8_upvw (copied, read and write)
					[2]: var12_upvw (read and write)
					[3]: const_number_upvw (read and write)
					[4]: arg1 (copied, readonly)
					[5]: UI_StringFormat_upvr (copied, readonly)
					[6]: Util_upvr (copied, readonly)
					[7]: Size_upvr (copied, readonly)
					[8]: const_number_upvw_2 (read and write)
					[9]: any_new_result1_upvr (copied, readonly)
				]]
				-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
				-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
				local var16
				-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [136] 108. Error Block 25 start (CF ANALYSIS FAILED)
				var16 = arg1
				var16 = Size_upvr
				var16.Parent.Size = var16
				local function INLINED_3() -- Internal function, doesn't exist in bytecode
					var16 = string.format(UI_StringFormat_upvr, Util_upvr.ValueConvertor:ShrinkNumber(math.floor(var8_upvw)))
					return var16
				end
				if not UI_StringFormat_upvr or not INLINED_3() then
					var16 = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(var8_upvw))
				end
				arg1.Text = var16
				do
					return
				end
				-- KONSTANTERROR: [136] 108. Error Block 25 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [175] 137. Error Block 26 start (CF ANALYSIS FAILED)
				any_new_result1_upvr.Animation = nil
				arg1.Parent.Size = Size_upvr
				local function INLINED_4() -- Internal function, doesn't exist in bytecode
					var16 = Util_upvr
					return string.format(UI_StringFormat_upvr, var16.ValueConvertor:ShrinkNumber(math.floor(var8_upvw)))
				end
				if not UI_StringFormat_upvr or not INLINED_4() then
					var16 = var8_upvw
				end
				arg1.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(var16))
				-- KONSTANTERROR: [175] 137. Error Block 26 end (CF ANALYSIS FAILED)
			end)
			-- KONSTANTWARNING: GOTO [82] #66
		end
		-- KONSTANTERROR: [19] 16. Error Block 21 end (CF ANALYSIS FAILED)
	end))
	return any_new_result1_upvr
end
return module