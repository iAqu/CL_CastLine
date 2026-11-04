-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:35
-- Luau version 6, Types version 3
-- Time taken: 0.001351 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local Parent_upvr = script.Parent
local Window = Parent_upvr.Frame.Window
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
AddListen.AddMouseCLick(Window.Confirm.Button, function() -- Line 22
	--[[ Upvalues[2]:
		[1]: RemoteFunction_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	RemoteFunction_upvr:InvokeServer("传送到起点")
	module_upvr:closeUi()
end, Window.Confirm)
AddListen.AddMouseCLick(Window.Cancel.Button, function() -- Line 29
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Window.Cancel)
function module_upvr.updateUi(arg1) -- Line 33
end
function module_upvr.openUi(arg1) -- Line 37
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 41
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local Tips_upvr = Window.Tips
AddListen.NumValueAdd(game.Workspace:WaitForChild("准备时间", math.huge), function(arg1) -- Line 51
	--[[ Upvalues[2]:
		[1]: TranslationHelper_upvr (readonly)
		[2]: Tips_upvr (readonly)
	]]
	TranslationHelper_upvr.SetText(Tips_upvr, "比赛多少秒后开始", {math.ceil(math.max(0, arg1) / 1000)})
end)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
AddListen.NumValueAdd(game.Workspace:WaitForChild("比赛状态", math.huge), function(arg1) -- Line 60
	--[[ Upvalues[3]:
		[1]: Parent_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if Parent_upvr.Visible == true and arg1 ~= EnumMgr_upvr.GameState.Prepear then
		module_upvr:closeUi()
	end
end)
return module_upvr