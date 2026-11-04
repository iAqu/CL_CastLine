-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:17
-- Luau version 6, Types version 3
-- Time taken: 0.001748 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local Parent = script.Parent
local Window = Parent.Frame.Window
local var6_upvw
local Button = script.Parent.BG.Exit.Button
AddListen.AddMouseCLick(Button, function() -- Line 27
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button.Parent)
AddListen.AddMouseCLick(Window.Confirm.Button, function() -- Line 34
	--[[ Upvalues[2]:
		[1]: var6_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	if var6_upvw and var6_upvw.func then
		var6_upvw.func()
	end
	module_upvr:closeUi()
end, Window.Confirm)
AddListen.AddMouseCLick(Window.Cancel.Button, function() -- Line 45
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Window.Cancel)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local Tips_upvr = Window.Tips
local _____________upvr = Parent.BG.Title["标题英文"]
local Left_upvr = Window.Confirm.Left
local Right_upvr = Window.Cancel.Right
function module_upvr.updateUi(arg1, arg2) -- Line 52
	--[[ Upvalues[6]:
		[1]: var6_upvw (read and write)
		[2]: TranslationHelper_upvr (readonly)
		[3]: Tips_upvr (readonly)
		[4]: _____________upvr (readonly)
		[5]: Left_upvr (readonly)
		[6]: Right_upvr (readonly)
	]]
	var6_upvw = arg2
	if var6_upvw.Tips then
		TranslationHelper_upvr.SetText(Tips_upvr, var6_upvw.Tips[1], var6_upvw.Tips[2])
	end
	if var6_upvw.Title then
		TranslationHelper_upvr.SetText(_____________upvr, var6_upvw.Title[1], var6_upvw.Title[2])
	else
		TranslationHelper_upvr.SetText(_____________upvr, "确认")
	end
	if var6_upvw.Left then
		TranslationHelper_upvr.SetText(Left_upvr, var6_upvw.Left[1], var6_upvw.Left[2])
	else
		TranslationHelper_upvr.SetText(Left_upvr, "确认")
	end
	if var6_upvw.Right then
		TranslationHelper_upvr.SetText(Right_upvr, var6_upvw.Right[1], var6_upvw.Right[2])
	else
		TranslationHelper_upvr.SetText(Right_upvr, "取消")
	end
end
function module_upvr.openUi(arg1) -- Line 78
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 81
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr