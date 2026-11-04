-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:57
-- Luau version 6, Types version 3
-- Time taken: 0.000868 seconds

local module_upvr = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local Tips_upvr = Parent.Frame.Window.Tips
local Agree = Parent.Frame.Window.Agree
Tips_upvr.AutoLocalize = false
require(ReplicatedStorage_upvr.Tool.AddListen).AddMouseCLick(Agree.Button, function() -- Line 13
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Agree)
local TranslationHelper_upvr = require(ReplicatedStorage_upvr.Tool.TranslationHelper)
function module_upvr.updateUi(arg1, arg2) -- Line 17
	--[[ Upvalues[2]:
		[1]: TranslationHelper_upvr (readonly)
		[2]: Tips_upvr (readonly)
	]]
	TranslationHelper_upvr.SetText(Tips_upvr, arg2.Key, arg2.args)
end
function module_upvr.openUi(arg1) -- Line 21
end
function module_upvr.closeUi(arg1) -- Line 25
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	require(ReplicatedStorage_upvr:WaitForChild("Tool"):WaitForChild("UIanima")).PopBack(script.Parent)
end
return module_upvr