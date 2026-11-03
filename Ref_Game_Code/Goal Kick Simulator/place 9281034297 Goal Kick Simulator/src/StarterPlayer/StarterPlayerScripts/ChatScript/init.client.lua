-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:15
-- Luau version 6, Types version 3
-- Time taken: 0.006898 seconds

local module_upvr = require(game:GetService("Chat"):WaitForChild("ClientChatModules"):WaitForChild("ChatSettings"))
local StarterGui_upvr = game:GetService("StarterGui")
function SetCoreGuiChatConnections(arg1) -- Line 107
	--[[ Upvalues[1]:
		[1]: StarterGui_upvr (readonly)
	]]
	local const_number = 0
	while const_number < 10 do
		local pcall_result1, pcall_result2 = pcall(function() -- Line 111
			--[[ Upvalues[2]:
				[1]: StarterGui_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			StarterGui_upvr:SetCore("CoreGuiChatConnections", arg1)
		end)
		if pcall_result1 then break end
		if not pcall_result1 and const_number + 1 == 10 then
			error("Error calling SetCore CoreGuiChatConnections: "..pcall_result2)
		end
		wait()
	end
end
function checkBothChatTypesDisabled() -- Line 122
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.BubbleChatEnabled ~= nil and module_upvr.ClassicChatEnabled ~= nil then
		local BubbleChatEnabled = module_upvr.BubbleChatEnabled
		if not BubbleChatEnabled then
			BubbleChatEnabled = module_upvr.ClassicChatEnabled
		end
		return not BubbleChatEnabled
	end
	return false
end
if not game:GetService("GuiService"):IsTenFootInterface() then
	if not checkBothChatTypesDisabled() then
		(function() -- Line 16, Named "DoEverything"
			--[[ Upvalues[1]:
				[1]: module_upvr (readonly)
			]]
			local module_upvr_2 = require(script:WaitForChild("ChatMain"))
			local tbl_upvr = {
				ChatWindow = {};
				SetCore = {};
				GetCore = {};
			}
			tbl_upvr.ChatWindow.ChatTypes = {}
			tbl_upvr.ChatWindow.ChatTypes.BubbleChatEnabled = module_upvr.BubbleChatEnabled
			tbl_upvr.ChatWindow.ChatTypes.ClassicChatEnabled = module_upvr.ClassicChatEnabled
			local function _(arg1) -- Line 29, Named "ConnectEvent"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableEvent = Instance.new("BindableEvent")
				BindableEvent.Name = arg1
				tbl_upvr.ChatWindow[arg1] = BindableEvent
				BindableEvent.Event:connect(function(...) -- Line 34
					--[[ Upvalues[2]:
						[1]: module_upvr_2 (copied, readonly)
						[2]: arg1 (readonly)
					]]
					module_upvr_2[arg1](module_upvr_2, ...)
				end)
			end
			local function _(arg1) -- Line 37, Named "ConnectFunction"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableFunction_4 = Instance.new("BindableFunction")
				BindableFunction_4.Name = arg1
				tbl_upvr.ChatWindow[arg1] = BindableFunction_4
				function BindableFunction_4.OnInvoke(...) -- Line 42
					--[[ Upvalues[2]:
						[1]: module_upvr_2 (copied, readonly)
						[2]: arg1 (readonly)
					]]
					return module_upvr_2[arg1](module_upvr_2, ...)
				end
			end
			local function _(arg1) -- Line 45, Named "ReverseConnectEvent"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableEvent_9_upvr = Instance.new("BindableEvent")
				BindableEvent_9_upvr.Name = arg1
				tbl_upvr.ChatWindow[arg1] = BindableEvent_9_upvr
				module_upvr_2[arg1]:connect(function(...) -- Line 50
					--[[ Upvalues[1]:
						[1]: BindableEvent_9_upvr (readonly)
					]]
					BindableEvent_9_upvr:Fire(...)
				end)
			end
			local function _(arg1) -- Line 53, Named "ConnectSignal"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableEvent_2 = Instance.new("BindableEvent")
				BindableEvent_2.Name = arg1
				tbl_upvr.ChatWindow[arg1] = BindableEvent_2
				BindableEvent_2.Event:connect(function(...) -- Line 58
					--[[ Upvalues[2]:
						[1]: module_upvr_2 (copied, readonly)
						[2]: arg1 (readonly)
					]]
					module_upvr_2[arg1]:fire(...)
				end)
			end
			local function _(arg1) -- Line 61, Named "ConnectSetCore"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableEvent_8 = Instance.new("BindableEvent")
				BindableEvent_8.Name = arg1
				tbl_upvr.SetCore[arg1] = BindableEvent_8
				BindableEvent_8.Event:connect(function(...) -- Line 66
					--[[ Upvalues[2]:
						[1]: module_upvr_2 (copied, readonly)
						[2]: arg1 (readonly)
					]]
					module_upvr_2[arg1.."Event"]:fire(...)
				end)
			end
			local function _(arg1) -- Line 69, Named "ConnectGetCore"
				--[[ Upvalues[2]:
					[1]: tbl_upvr (readonly)
					[2]: module_upvr_2 (readonly)
				]]
				local BindableFunction_3 = Instance.new("BindableFunction")
				BindableFunction_3.Name = arg1
				tbl_upvr.GetCore[arg1] = BindableFunction_3
				function BindableFunction_3.OnInvoke(...) -- Line 74
					--[[ Upvalues[2]:
						[1]: module_upvr_2 (copied, readonly)
						[2]: arg1 (readonly)
					]]
					return module_upvr_2['f'..arg1](...)
				end
			end
			local BindableEvent_7 = Instance.new("BindableEvent")
			BindableEvent_7.Name = "ToggleVisibility"
			tbl_upvr.ChatWindow.ToggleVisibility = BindableEvent_7
			local var18_upvr = "ToggleVisibility"
			BindableEvent_7.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			local BindableEvent_5 = Instance.new("BindableEvent")
			BindableEvent_5.Name = "SetVisible"
			tbl_upvr.ChatWindow.SetVisible = BindableEvent_5
			var18_upvr = "SetVisible"
			BindableEvent_5.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			local BindableEvent_6 = Instance.new("BindableEvent")
			BindableEvent_6.Name = "FocusChatBar"
			tbl_upvr.ChatWindow.FocusChatBar = BindableEvent_6
			var18_upvr = "FocusChatBar"
			BindableEvent_6.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			local BindableEvent_4 = Instance.new("BindableEvent")
			BindableEvent_4.Name = "EnterWhisperState"
			tbl_upvr.ChatWindow.EnterWhisperState = BindableEvent_4
			var18_upvr = "EnterWhisperState"
			BindableEvent_4.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			local BindableFunction_2 = Instance.new("BindableFunction")
			BindableFunction_2.Name = "GetVisibility"
			tbl_upvr.ChatWindow.GetVisibility = BindableFunction_2
			local var27_upvr = "GetVisibility"
			function BindableFunction_2.OnInvoke(...) -- Line 42
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2[var27_upvr](module_upvr_2, ...)
			end
			local BindableFunction = Instance.new("BindableFunction")
			BindableFunction.Name = "GetMessageCount"
			tbl_upvr.ChatWindow.GetMessageCount = BindableFunction
			var27_upvr = "GetMessageCount"
			function BindableFunction.OnInvoke(...) -- Line 42
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2[var27_upvr](module_upvr_2, ...)
			end
			local BindableEvent_10 = Instance.new("BindableEvent")
			BindableEvent_10.Name = "TopbarEnabledChanged"
			tbl_upvr.ChatWindow.TopbarEnabledChanged = BindableEvent_10
			var18_upvr = "TopbarEnabledChanged"
			BindableEvent_10.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			local BindableFunction_5 = Instance.new("BindableFunction")
			BindableFunction_5.Name = "IsFocused"
			tbl_upvr.ChatWindow.IsFocused = BindableFunction_5
			var27_upvr = "IsFocused"
			function BindableFunction_5.OnInvoke(...) -- Line 42
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2[var27_upvr](module_upvr_2, ...)
			end
			local BindableEvent_3_upvr = Instance.new("BindableEvent")
			BindableEvent_3_upvr.Name = "ChatBarFocusChanged"
			tbl_upvr.ChatWindow.ChatBarFocusChanged = BindableEvent_3_upvr
			module_upvr_2.ChatBarFocusChanged:connect(function(...) -- Line 50
				--[[ Upvalues[1]:
					[1]: BindableEvent_3_upvr (readonly)
				]]
				BindableEvent_3_upvr:Fire(...)
			end)
			BindableEvent_3_upvr = Instance.new("BindableEvent")
			local var36_upvr = BindableEvent_3_upvr
			var36_upvr.Name = "VisibilityStateChanged"
			tbl_upvr.ChatWindow.VisibilityStateChanged = var36_upvr
			module_upvr_2.VisibilityStateChanged:connect(function(...) -- Line 50
				--[[ Upvalues[1]:
					[1]: var36_upvr (readonly)
				]]
				var36_upvr:Fire(...)
			end)
			var36_upvr = Instance.new("BindableEvent")
			local var38_upvr = var36_upvr
			var38_upvr.Name = "MessagesChanged"
			tbl_upvr.ChatWindow.MessagesChanged = var38_upvr
			module_upvr_2.MessagesChanged:connect(function(...) -- Line 50
				--[[ Upvalues[1]:
					[1]: var38_upvr (readonly)
				]]
				var38_upvr:Fire(...)
			end)
			var38_upvr = Instance.new("BindableEvent")
			local var40_upvr = var38_upvr
			var40_upvr.Name = "MessagePosted"
			tbl_upvr.ChatWindow.MessagePosted = var40_upvr
			module_upvr_2.MessagePosted:connect(function(...) -- Line 50
				--[[ Upvalues[1]:
					[1]: var40_upvr (readonly)
				]]
				var40_upvr:Fire(...)
			end)
			var40_upvr = Instance.new("BindableEvent")
			local var42 = var40_upvr
			var42.Name = "CoreGuiEnabled"
			tbl_upvr.ChatWindow.CoreGuiEnabled = var42
			var18_upvr = "CoreGuiEnabled"
			var42.Event:connect(function(...) -- Line 58
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr]:fire(...)
			end)
			var42 = Instance.new("BindableEvent")
			local var44 = var42
			var44.Name = "ChatMakeSystemMessage"
			tbl_upvr.SetCore.ChatMakeSystemMessage = var44
			var18_upvr = "ChatMakeSystemMessage"
			var44.Event:connect(function(...) -- Line 66
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr.."Event"]:fire(...)
			end)
			var44 = Instance.new("BindableEvent")
			local var46 = var44
			var46.Name = "ChatWindowPosition"
			tbl_upvr.SetCore.ChatWindowPosition = var46
			var18_upvr = "ChatWindowPosition"
			var46.Event:connect(function(...) -- Line 66
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr.."Event"]:fire(...)
			end)
			var46 = Instance.new("BindableEvent")
			local var48 = var46
			var48.Name = "ChatWindowSize"
			tbl_upvr.SetCore.ChatWindowSize = var48
			var18_upvr = "ChatWindowSize"
			var48.Event:connect(function(...) -- Line 66
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr.."Event"]:fire(...)
			end)
			var48 = Instance.new("BindableFunction")
			local var50 = var48
			var50.Name = "ChatWindowPosition"
			tbl_upvr.GetCore.ChatWindowPosition = var50
			var27_upvr = "ChatWindowPosition"
			function var50.OnInvoke(...) -- Line 74
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2['f'..var27_upvr](...)
			end
			var50 = Instance.new("BindableFunction")
			local var52 = var50
			var52.Name = "ChatWindowSize"
			tbl_upvr.GetCore.ChatWindowSize = var52
			var27_upvr = "ChatWindowSize"
			function var52.OnInvoke(...) -- Line 74
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2['f'..var27_upvr](...)
			end
			var52 = Instance.new("BindableEvent")
			local var54 = var52
			var54.Name = "ChatBarDisabled"
			tbl_upvr.SetCore.ChatBarDisabled = var54
			var18_upvr = "ChatBarDisabled"
			var54.Event:connect(function(...) -- Line 66
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr.."Event"]:fire(...)
			end)
			var54 = Instance.new("BindableFunction")
			local var56 = var54
			var56.Name = "ChatBarDisabled"
			tbl_upvr.GetCore.ChatBarDisabled = var56
			var27_upvr = "ChatBarDisabled"
			function var56.OnInvoke(...) -- Line 74
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var27_upvr (readonly)
				]]
				return module_upvr_2['f'..var27_upvr](...)
			end
			var56 = Instance.new("BindableEvent")
			local var58 = var56
			var58.Name = "SpecialKeyPressed"
			tbl_upvr.ChatWindow.SpecialKeyPressed = var58
			var18_upvr = "SpecialKeyPressed"
			var58.Event:connect(function(...) -- Line 34
				--[[ Upvalues[2]:
					[1]: module_upvr_2 (readonly)
					[2]: var18_upvr (readonly)
				]]
				module_upvr_2[var18_upvr](module_upvr_2, ...)
			end)
			var58 = SetCoreGuiChatConnections
			var58(tbl_upvr)
		end)()
	else
		local tbl = {
			ChatWindow = {};
		}
		tbl.ChatWindow.ChatTypes = {}
		tbl.ChatWindow.ChatTypes.BubbleChatEnabled = false
		tbl.ChatWindow.ChatTypes.ClassicChatEnabled = false
		SetCoreGuiChatConnections(tbl)
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents").GetInitDataRequest:InvokeServer()