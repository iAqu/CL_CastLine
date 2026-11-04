-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:25
-- Luau version 6, Types version 3
-- Time taken: 0.000474 seconds

require(game.ReplicatedStorage.Tool.AddListen).NumValueAdd(game.Players.LocalPlayer:WaitForChild("EquipmentName", math.huge), function(arg1) -- Line 4
	if arg1 == "" then
		script.Parent.Visible = false
	else
		script.Parent.Visible = true
	end
end)