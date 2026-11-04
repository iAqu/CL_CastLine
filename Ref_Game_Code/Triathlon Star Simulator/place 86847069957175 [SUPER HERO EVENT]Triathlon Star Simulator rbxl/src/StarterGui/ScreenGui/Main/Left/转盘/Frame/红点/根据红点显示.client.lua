-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:18
-- Luau version 6, Types version 3
-- Time taken: 0.000506 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Tool.AddListen).NumValueAdd(require(ReplicatedStorage.Tool.GetData).WaitBagNumberValue(game.Players.LocalPlayer, require(ReplicatedStorage.Tool.EnumMgr).ItemID.DailyToken), function(arg1) -- Line 10
	if 0 < arg1 then
		script.Parent.Visible = true
	else
		script.Parent.Visible = false
	end
end)