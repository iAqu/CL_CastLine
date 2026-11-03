-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:18
-- Luau version 6, Types version 3
-- Time taken: 0.001544 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "DialogTextBoxFilterPreview"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("TextFilterServiceClient")
local var1_result1_upvr_3 = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 16
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._textBox = assert(arg2, "No textBox")
	setmetatable_result1_upvr_2._textFilterService = arg1:GetService(var1_result1_upvr)
	setmetatable_result1_upvr_2._lastActiveText = nil
	setmetatable_result1_upvr_2.Filtered = var1_result1_upvr_3.new(nil)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Filtered)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._textBox.FocusLost:Connect(function() -- Line 27
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:Update()
	end))
	setmetatable_result1_upvr_2:Update()
	return setmetatable_result1_upvr_2
end
local var1_result1_upvr_4 = any_load_result1("DialogTextBoxUtils")
function setmetatable_result1_upvr.Update(arg1) -- Line 36
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	local any_sanitize_result1 = var1_result1_upvr_4.sanitize(arg1._textBox.Text)
	if 0 < #any_sanitize_result1 then
		arg1:_setActiveText(any_sanitize_result1)
	else
		arg1:_setActiveText(nil)
	end
end
function setmetatable_result1_upvr._setActiveText(arg1, arg2) -- Line 45
	if arg1._lastActiveText == arg2 then
	else
		arg1._lastActiveText = arg2
		arg1.Filtered.Value = nil
		if arg2 then
			local any_PromisePreviewNonChatStringForBroadcast_result1 = arg1._textFilterService:PromisePreviewNonChatStringForBroadcast(arg2)
			any_PromisePreviewNonChatStringForBroadcast_result1:Then(function(arg1_2) -- Line 56
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1.Filtered.Value = arg1_2
			end)
			arg1._maid._currentPromise = any_PromisePreviewNonChatStringForBroadcast_result1
			return
		end
		arg1._maid._currentPromise = nil
	end
end
return setmetatable_result1_upvr