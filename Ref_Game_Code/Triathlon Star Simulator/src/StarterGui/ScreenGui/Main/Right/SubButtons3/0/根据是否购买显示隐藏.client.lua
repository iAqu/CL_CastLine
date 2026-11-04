-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:48
-- Luau version 6, Types version 3
-- Time taken: 0.000732 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OnlyTag = script.Parent.OnlyTag
if require(ReplicatedStorage.Tool.CfgFind).FindCfgByOnlyTag(OnlyTag.Value) then
	require(ReplicatedStorage.Tool.AddListen).NumValueAdd(game.Players.LocalPlayer:WaitForChild("GamePass", math.huge):FindFirstChild(OnlyTag.Value), function(arg1) -- Line 20
		local script = script
		if arg1 > 0 then
			script = false
		else
			script = true
		end
		script.Parent.Visible = script
	end)
end