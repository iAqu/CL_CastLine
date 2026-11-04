-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:06
-- Luau version 6, Types version 3
-- Time taken: 0.000486 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Tool.InsMgr).GetIns("IsAutoHatch", "BoolValue", game.Players.LocalPlayer).Value = false
local DrawModule_upvr = require(ReplicatedStorage.Tool.DrawModule)
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 12
	--[[ Upvalues[1]:
		[1]: DrawModule_upvr (readonly)
	]]
	DrawModule_upvr.StopContinueDraw()
	script.Parent.Parent.Parent.Visible = false
end, script.Parent.Parent)