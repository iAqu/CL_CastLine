-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:14
-- Luau version 6, Types version 3
-- Time taken: 0.000838 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local Parent = script.Parent
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(Parent.BG.Exit.Button, function() -- Line 20
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent.BG.Exit.Frame, "音效-场景-点击-通用返回")
function module_upvr.updateUi(arg1, arg2) -- Line 24
end
function module_upvr.openUi(arg1) -- Line 27
	--[[ Upvalues[1]:
		[1]: UIMgr_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 31
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr