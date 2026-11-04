-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:44
-- Luau version 6, Types version 3
-- Time taken: 0.000444 seconds

require(game:GetService("ReplicatedStorage").Tool.AddListen).AddMouseCLick(script.Parent, function() -- Line 9
	script.Parent.Parent.Parent.Parent["当前标签"].Value = tonumber(script.Parent.Parent.Name)
end, script.Parent.Parent)