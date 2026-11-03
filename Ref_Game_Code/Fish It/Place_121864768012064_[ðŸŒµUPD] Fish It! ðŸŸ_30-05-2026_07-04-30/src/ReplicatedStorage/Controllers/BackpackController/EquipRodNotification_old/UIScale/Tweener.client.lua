-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local v1 = script.Parent.Parent
TweenService:Create(v1, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, true), {
	Position = v1.Position - UDim2.fromOffset(0, 5)
}):Play()