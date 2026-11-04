-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:52
-- Luau version 6, Types version 3
-- Time taken: 0.000494 seconds

local Lighting = game:GetService("Lighting")
wait(1)
for _, v in pairs(script.Parent["配置"]:GetChildren()) do
	print("读取配置:", v.Name, Lighting[v.Name], v.Value)
	v.Value = Lighting[v.Name]
end