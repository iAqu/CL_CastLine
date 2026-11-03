-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:38
-- Luau version 6, Types version 3
-- Time taken: 0.009507 seconds

local var1_upvw = false
local pcall_result1, pcall_result2 = pcall(function() -- Line 41
	return UserSettings():IsUserFeatureEnabled("UserFixOverlappingRtlChatMessages2")
end)
local var5_upvw
if pcall_result1 then
	var1_upvw = pcall_result2
end
var5_upvw = "TextService"
local Players_upvr = game:GetService("Players")
var5_upvw = Players_upvr.LocalPlayer
while not var5_upvw do
	Players_upvr.ChildAdded:wait()
	var5_upvw = Players_upvr.LocalPlayer
end
local Parent = script.Parent.Parent
local module_3_upvr = require(Parent:WaitForChild("ChatSettings"))
local module = {}
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
local service_upvr = game:GetService(var5_upvw)
function tbl_upvr.GetStringTextBounds(arg1, arg2, arg3, arg4, arg5) -- Line 66
	--[[ Upvalues[1]:
		[1]: service_upvr (readonly)
	]]
	local var12 = arg5
	if not var12 then
		var12 = Vector2.new(10000, 10000)
	end
	return service_upvr:GetTextSize(arg2, arg4, arg3, var12)
end
function tbl_upvr.GetMessageHeight(arg1, arg2, arg3, arg4) -- Line 72
	--[[ Upvalues[1]:
		[1]: var1_upvw (read and write)
	]]
	local var13
	if not var13 then
		var13 = arg3.AbsoluteSize.X
	end
	if var1_upvw then
		var13 = arg2.ContentText
	else
		var13 = arg2.Text
	end
	local any_GetStringTextBounds_result1_4 = arg1:GetStringTextBounds(var13, arg2.Font, arg2.TextSize, Vector2.new(var13, 1000))
	if any_GetStringTextBounds_result1_4.Y ~= math.floor(any_GetStringTextBounds_result1_4.Y) then
		return any_GetStringTextBounds_result1_4.Y + 1
	end
	return any_GetStringTextBounds_result1_4.Y
end
function tbl_upvr.GetNumberOfSpaces(arg1, arg2, arg3, arg4) -- Line 84
	return math.ceil(arg1:GetStringTextBounds(arg2, arg3, arg4).X / arg1:GetStringTextBounds(' ', arg3, arg4).X)
end
function tbl_upvr.CreateLeadingSpaces(arg1, arg2) -- Line 90
	--[[ Upvalues[1]:
		[1]: var1_upvw (read and write)
	]]
	if var1_upvw then
		return "<font dir=\"ltr\">"..string.rep(' ', arg2).."</font>"
	end
	return string.rep(' ', arg2)
end
function tbl_upvr.SanitizeForRichText(arg1, arg2) -- Line 98
	--[[ Upvalues[1]:
		[1]: var1_upvw (read and write)
	]]
	if var1_upvw then
		return string.gsub(arg2, "%p", {
			['<'] = "&lt;";
			['>'] = "&gt;";
			['&'] = "&amp;";
		})
	end
	return arg2
end
function tbl_upvr.CreateBaseMessage(arg1, arg2, arg3, arg4, arg5) -- Line 110
	--[[ Upvalues[1]:
		[1]: var1_upvw (read and write)
	]]
	local any_GetFromObjectPool_result1_3 = arg1:GetFromObjectPool("Frame")
	any_GetFromObjectPool_result1_3.Selectable = false
	any_GetFromObjectPool_result1_3.Size = UDim2.new(1, 0, 0, 18)
	any_GetFromObjectPool_result1_3.Visible = true
	any_GetFromObjectPool_result1_3.BackgroundTransparency = 1
	local any_GetFromObjectPool_result1_5 = arg1:GetFromObjectPool("TextLabel")
	any_GetFromObjectPool_result1_5.Selectable = false
	any_GetFromObjectPool_result1_5.Size = UDim2.new(1, -14, 1, 0)
	any_GetFromObjectPool_result1_5.Position = UDim2.new(0, 8, 0, 0)
	any_GetFromObjectPool_result1_5.BackgroundTransparency = 1
	any_GetFromObjectPool_result1_5.Font = arg3
	any_GetFromObjectPool_result1_5.TextSize = arg4
	any_GetFromObjectPool_result1_5.TextXAlignment = Enum.TextXAlignment.Left
	any_GetFromObjectPool_result1_5.TextYAlignment = Enum.TextYAlignment.Top
	any_GetFromObjectPool_result1_5.TextTransparency = 0
	any_GetFromObjectPool_result1_5.TextStrokeTransparency = 0.75
	any_GetFromObjectPool_result1_5.TextColor3 = arg5
	any_GetFromObjectPool_result1_5.TextWrapped = true
	any_GetFromObjectPool_result1_5.ClipsDescendants = true
	any_GetFromObjectPool_result1_5.Text = arg2
	local var18 = true
	any_GetFromObjectPool_result1_5.Visible = var18
	if var1_upvw then
		var18 = true
	else
		var18 = false
	end
	any_GetFromObjectPool_result1_5.RichText = var18
	any_GetFromObjectPool_result1_5.Parent = any_GetFromObjectPool_result1_3
	return any_GetFromObjectPool_result1_3, any_GetFromObjectPool_result1_5
end
function tbl_upvr.AddNameButtonToBaseMessage(arg1, arg2, arg3, arg4, arg5) -- Line 141
	local any_GetStringTextBounds_result1_2 = arg1:GetStringTextBounds(arg4, arg2.Font, arg2.TextSize)
	local any_GetFromObjectPool_result1_6_upvr = arg1:GetFromObjectPool("TextButton")
	any_GetFromObjectPool_result1_6_upvr.Selectable = false
	any_GetFromObjectPool_result1_6_upvr.Size = UDim2.new(0, any_GetStringTextBounds_result1_2.X, 0, any_GetStringTextBounds_result1_2.Y)
	any_GetFromObjectPool_result1_6_upvr.Position = UDim2.new(0, 0, 0, 0)
	any_GetFromObjectPool_result1_6_upvr.BackgroundTransparency = 1
	any_GetFromObjectPool_result1_6_upvr.Font = arg2.Font
	any_GetFromObjectPool_result1_6_upvr.TextSize = arg2.TextSize
	any_GetFromObjectPool_result1_6_upvr.TextXAlignment = arg2.TextXAlignment
	any_GetFromObjectPool_result1_6_upvr.TextYAlignment = arg2.TextYAlignment
	any_GetFromObjectPool_result1_6_upvr.TextTransparency = arg2.TextTransparency
	any_GetFromObjectPool_result1_6_upvr.TextStrokeTransparency = arg2.TextStrokeTransparency
	any_GetFromObjectPool_result1_6_upvr.TextColor3 = arg3
	any_GetFromObjectPool_result1_6_upvr.Text = arg4
	any_GetFromObjectPool_result1_6_upvr.Visible = true
	any_GetFromObjectPool_result1_6_upvr.Parent = arg2
	local any_connect_result1_upvr = any_GetFromObjectPool_result1_6_upvr.MouseButton1Click:connect(function() -- Line 159
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_GetFromObjectPool_result1_6_upvr (readonly)
			[3]: arg5 (readonly)
		]]
		arg1:NameButtonClicked(any_GetFromObjectPool_result1_6_upvr, arg5)
	end)
	local var24_upvw
	var24_upvw = any_GetFromObjectPool_result1_6_upvr.Changed:connect(function(arg1_2) -- Line 164
		--[[ Upvalues[2]:
			[1]: any_connect_result1_upvr (readonly)
			[2]: var24_upvw (read and write)
		]]
		if arg1_2 == "Parent" then
			any_connect_result1_upvr:Disconnect()
			var24_upvw:Disconnect()
		end
	end)
	return any_GetFromObjectPool_result1_6_upvr
end
function tbl_upvr.AddTranslationButtonToBaseMessage(arg1, arg2) -- Line 174
	local floored = math.floor(arg2.TextSize * 0.9)
	local vector2 = Vector2.new(floored, floored)
	local any_GetFromObjectPool_result1_4 = arg1:GetFromObjectPool("ImageButton")
	any_GetFromObjectPool_result1_4.Selectable = false
	any_GetFromObjectPool_result1_4.Size = UDim2.new(0, vector2.X, 0, vector2.Y)
	any_GetFromObjectPool_result1_4.Position = UDim2.new(0, 0, 0, 0)
	any_GetFromObjectPool_result1_4.BackgroundTransparency = 1
	any_GetFromObjectPool_result1_4.Visible = false
	any_GetFromObjectPool_result1_4.Parent = arg2
	any_GetFromObjectPool_result1_4.Image = "rbxasset://textures/translateIcon.png"
	any_GetFromObjectPool_result1_4.HoverImage = "rbxasset://textures/translateIconDark.png"
	any_GetFromObjectPool_result1_4.PressedImage = "rbxasset://textures/translateIconDark.png"
	return any_GetFromObjectPool_result1_4
end
function tbl_upvr.AddChannelButtonToBaseMessage(arg1, arg2, arg3, arg4, arg5) -- Line 191
	local any_GetStringTextBounds_result1_3 = arg1:GetStringTextBounds(arg4, arg2.Font, arg2.TextSize)
	local any_GetFromObjectPool_result1_2_upvr = arg1:GetFromObjectPool("TextButton")
	any_GetFromObjectPool_result1_2_upvr.Selectable = false
	any_GetFromObjectPool_result1_2_upvr.Size = UDim2.new(0, any_GetStringTextBounds_result1_3.X, 0, any_GetStringTextBounds_result1_3.Y)
	any_GetFromObjectPool_result1_2_upvr.Position = UDim2.new(0, 0, 0, 0)
	any_GetFromObjectPool_result1_2_upvr.BackgroundTransparency = 1
	any_GetFromObjectPool_result1_2_upvr.Font = arg2.Font
	any_GetFromObjectPool_result1_2_upvr.TextSize = arg2.TextSize
	any_GetFromObjectPool_result1_2_upvr.TextXAlignment = arg2.TextXAlignment
	any_GetFromObjectPool_result1_2_upvr.TextYAlignment = arg2.TextYAlignment
	any_GetFromObjectPool_result1_2_upvr.TextTransparency = arg2.TextTransparency
	any_GetFromObjectPool_result1_2_upvr.TextStrokeTransparency = arg2.TextStrokeTransparency
	any_GetFromObjectPool_result1_2_upvr.TextColor3 = arg3
	any_GetFromObjectPool_result1_2_upvr.Text = arg4
	any_GetFromObjectPool_result1_2_upvr.Visible = true
	any_GetFromObjectPool_result1_2_upvr.Parent = arg2
	local any_connect_result1_upvr_2 = any_GetFromObjectPool_result1_2_upvr.MouseButton1Click:connect(function() -- Line 209
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_GetFromObjectPool_result1_2_upvr (readonly)
			[3]: arg5 (readonly)
		]]
		arg1:ChannelButtonClicked(any_GetFromObjectPool_result1_2_upvr, arg5)
	end)
	local var33_upvw
	var33_upvw = any_GetFromObjectPool_result1_2_upvr.Changed:connect(function(arg1_3) -- Line 214
		--[[ Upvalues[2]:
			[1]: any_connect_result1_upvr_2 (readonly)
			[2]: var33_upvw (read and write)
		]]
		if arg1_3 == "Parent" then
			any_connect_result1_upvr_2:Disconnect()
			var33_upvw:Disconnect()
		end
	end)
	return any_GetFromObjectPool_result1_2_upvr
end
function tbl_upvr.AddTagLabelToBaseMessage(arg1, arg2, arg3, arg4) -- Line 224
	local any_GetStringTextBounds_result1 = arg1:GetStringTextBounds(arg4, arg2.Font, arg2.TextSize)
	local any_GetFromObjectPool_result1 = arg1:GetFromObjectPool("TextLabel")
	any_GetFromObjectPool_result1.Selectable = false
	any_GetFromObjectPool_result1.Size = UDim2.new(0, any_GetStringTextBounds_result1.X, 0, any_GetStringTextBounds_result1.Y)
	any_GetFromObjectPool_result1.Position = UDim2.new(0, 0, 0, 0)
	any_GetFromObjectPool_result1.BackgroundTransparency = 1
	any_GetFromObjectPool_result1.Font = arg2.Font
	any_GetFromObjectPool_result1.TextSize = arg2.TextSize
	any_GetFromObjectPool_result1.TextXAlignment = arg2.TextXAlignment
	any_GetFromObjectPool_result1.TextYAlignment = arg2.TextYAlignment
	any_GetFromObjectPool_result1.TextTransparency = arg2.TextTransparency
	any_GetFromObjectPool_result1.TextStrokeTransparency = arg2.TextStrokeTransparency
	any_GetFromObjectPool_result1.TextColor3 = arg3
	any_GetFromObjectPool_result1.Text = arg4
	any_GetFromObjectPool_result1.Visible = true
	any_GetFromObjectPool_result1.Parent = arg2
	return any_GetFromObjectPool_result1
end
local module_2_upvr = require(Parent:WaitForChild("ChatConstants"))
function GetWhisperChannelPrefix() -- Line 245
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	if module_2_upvr.WhisperChannelPrefix then
		return module_2_upvr.WhisperChannelPrefix
	end
	return "To "
end
function tbl_upvr.NameButtonClicked(arg1, arg2, arg3) -- Line 252
	--[[ Upvalues[3]:
		[1]: module_3_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: var5_upvw (read and write)
	]]
	if not arg1.ChatWindow then
	elseif module_3_upvr.ClickOnPlayerNameToWhisper then
		local SOME_2 = Players_upvr:FindFirstChild(arg3)
		if SOME_2 and SOME_2 ~= var5_upvw then
			local var40 = GetWhisperChannelPrefix()..arg3
			if arg1.ChatWindow:GetChannel(var40) then
				arg1.ChatBar:ResetCustomState()
				if arg1.ChatWindow:GetTargetMessageChannel() ~= var40 then
					arg1.ChatWindow:SwitchCurrentChannel(var40)
				end
				arg1.ChatBar:SetText("/w "..arg3)
				arg1.ChatBar:CaptureFocus()
				return
			end
			if not arg1.ChatBar:IsInCustomState() then
				arg1.ChatBar:SetText("/w "..arg3)
				arg1.ChatBar:CaptureFocus()
			end
		end
	end
end
function tbl_upvr.ChannelButtonClicked(arg1, arg2, arg3) -- Line 282
	--[[ Upvalues[1]:
		[1]: module_3_upvr (readonly)
	]]
	if not arg1.ChatWindow then
	elseif module_3_upvr.ClickOnChannelNameToSetMainChannel then
		if arg1.ChatWindow:GetChannel(arg3) then
			arg1.ChatBar:ResetCustomState()
			if arg1.ChatWindow:GetTargetMessageChannel() ~= arg3 then
				arg1.ChatWindow:SwitchCurrentChannel(arg3)
			end
			arg1.ChatBar:ResetText()
			arg1.ChatBar:CaptureFocus()
		end
	end
end
function tbl_upvr.RegisterChatWindow(arg1, arg2) -- Line 300
	arg1.ChatWindow = arg2
	arg1.ChatBar = arg2:GetChatBar()
end
function tbl_upvr.GetFromObjectPool(arg1, arg2) -- Line 305
	if arg1.ObjectPool == nil then
		return Instance.new(arg2)
	end
	return arg1.ObjectPool:GetInstance(arg2)
end
function tbl_upvr.RegisterObjectPool(arg1, arg2) -- Line 312
	arg1.ObjectPool = arg2
end
function tbl_upvr.CreateFadeFunctions(arg1, arg2) -- Line 332
	local tbl_upvr_2 = {}
	for i, v in pairs(arg2) do
		tbl_upvr_2[i] = {}
		for i_2, v_2 in pairs(v) do
			tbl_upvr_2[i][i_2] = {
				Target = v_2.FadedIn;
				Current = i[i_2];
				NormalizedExptValue = 1;
			}
		end
	end
	local function AnimGuiObjects_upvr() -- Line 363, Named "AnimGuiObjects"
		--[[ Upvalues[1]:
			[1]: tbl_upvr_2 (readonly)
		]]
		for i_7, v_7 in pairs(tbl_upvr_2) do
			for i_8, v_8 in pairs(v_7) do
				i_7[i_8] = v_8.Current
			end
		end
	end
	return function(arg1_4, arg2_2) -- Line 345, Named "FadeInFunction"
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: arg2 (readonly)
		]]
		for i_3, v_3 in pairs(tbl_upvr_2) do
			for i_4, v_4 in pairs(v_3) do
				v_4.Target = arg2[i_3][i_4].FadedIn
				v_4.NormalizedExptValue = arg2_2:NormalizedDefaultExptValueInSeconds(arg1_4)
			end
		end
	end, function(arg1_5, arg2_3) -- Line 354, Named "FadeOutFunction"
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: arg2 (readonly)
		]]
		for i_5, v_5 in pairs(tbl_upvr_2) do
			for i_6, v_6 in pairs(v_5) do
				v_6.Target = arg2[i_5][i_6].FadedOut
				v_6.NormalizedExptValue = arg2_3:NormalizedDefaultExptValueInSeconds(arg1_5)
			end
		end
	end, function(arg1_6, arg2_4) -- Line 371, Named "UpdateAnimFunction"
		--[[ Upvalues[2]:
			[1]: tbl_upvr_2 (readonly)
			[2]: AnimGuiObjects_upvr (readonly)
		]]
		for _, v_9 in pairs(tbl_upvr_2) do
			for _, v_10 in pairs(v_9) do
				v_10.Current = arg2_4:Expt(v_10.Current, v_10.Target, v_10.NormalizedExptValue, arg1_6)
			end
		end
		AnimGuiObjects_upvr()
	end
end
function tbl_upvr.NewBindableEvent(arg1, arg2) -- Line 389
	local BindableEvent = Instance.new("BindableEvent")
	BindableEvent.Name = arg2
	return BindableEvent
end
function tbl_upvr.RegisterGuiRoot(arg1) -- Line 396
end
function module.new() -- Line 401
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, tbl_upvr)
	setmetatable_result1.ObjectPool = nil
	setmetatable_result1.ChatWindow = nil
	setmetatable_result1.DEFAULT_MESSAGE_CREATOR = "UnknownMessage"
	setmetatable_result1.MESSAGE_CREATOR_MODULES_VERSION = 1
	setmetatable_result1.KEY_MESSAGE_TYPE = "MessageType"
	setmetatable_result1.KEY_CREATOR_FUNCTION = "MessageCreatorFunc"
	setmetatable_result1.KEY_BASE_FRAME = "BaseFrame"
	setmetatable_result1.KEY_BASE_MESSAGE = "BaseMessage"
	setmetatable_result1.KEY_UPDATE_TEXT_FUNC = "UpdateTextFunction"
	setmetatable_result1.KEY_GET_HEIGHT = "GetHeightFunction"
	setmetatable_result1.KEY_FADE_IN = "FadeInFunction"
	setmetatable_result1.KEY_FADE_OUT = "FadeOutFunction"
	setmetatable_result1.KEY_UPDATE_ANIMATION = "UpdateAnimFunction"
	return setmetatable_result1
end
return module.new()