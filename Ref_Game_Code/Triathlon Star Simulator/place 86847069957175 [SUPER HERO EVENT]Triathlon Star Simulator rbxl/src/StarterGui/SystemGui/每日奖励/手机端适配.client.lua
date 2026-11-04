-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:12
-- Luau version 6, Types version 3
-- Time taken: 0.000368 seconds

if game:GetService("UserInputService").TouchEnabled == true then
	script.Parent["每日奖励"]:Destroy()
	script.Parent.Size = UDim2.new(0, 32, 0, 32)
else
	script.Parent.Size = UDim2.new(0, 104, 0, 32)
	script.Parent.Position = UDim2.new(1, -52, 0, 4)
end