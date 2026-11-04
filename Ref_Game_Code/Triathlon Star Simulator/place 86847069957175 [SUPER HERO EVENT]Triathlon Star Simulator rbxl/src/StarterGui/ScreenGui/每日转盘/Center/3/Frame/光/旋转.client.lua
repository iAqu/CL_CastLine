-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:06
-- Luau version 6, Types version 3
-- Time taken: 0.000372 seconds

local Parent = script.Parent
if not Parent then
else
	Parent.Rotation = 0
	game:GetService("TweenService"):Create(Parent, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false, 0), {
		Rotation = 360;
	}):Play()
end