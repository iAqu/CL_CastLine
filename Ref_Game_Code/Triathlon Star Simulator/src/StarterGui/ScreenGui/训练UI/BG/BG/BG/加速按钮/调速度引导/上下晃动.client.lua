-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:04
-- Luau version 6, Types version 3
-- Time taken: 0.000437 seconds

if script.Parent then
	script.Parent.Position = UDim2.new(0.5, 0, 0, 0)
	game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, true), {
		Position = UDim2.new(0.5, 0, -0.3, 0);
	}):Play()
end