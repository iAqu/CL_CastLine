-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:39
-- Luau version 6, Types version 3
-- Time taken: 0.000508 seconds

require(game:GetService("ReplicatedStorage").Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 9
	local SOME = script.Parent.Parent.Parent.Parent["当前选中装备"]:FindFirstChild(script.Parent.Parent.Name)
	if SOME then
		SOME.Value = 0
	end
end, script.Parent.Parent)