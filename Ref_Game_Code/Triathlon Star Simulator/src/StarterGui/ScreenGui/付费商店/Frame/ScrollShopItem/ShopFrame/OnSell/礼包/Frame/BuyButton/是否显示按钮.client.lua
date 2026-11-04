-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:01
-- Luau version 6, Types version 3
-- Time taken: 0.000479 seconds

require(game.ReplicatedStorage.Tool.AddListen).NumValueAdd(game.Players.LocalPlayer:WaitForChild("Record", math.huge):WaitForChild("StarterPack", math.huge), function(arg1) -- Line 6
	if 0 < arg1 then
		script.Parent.Visible = false
	else
		script.Parent.Visible = true
	end
end)