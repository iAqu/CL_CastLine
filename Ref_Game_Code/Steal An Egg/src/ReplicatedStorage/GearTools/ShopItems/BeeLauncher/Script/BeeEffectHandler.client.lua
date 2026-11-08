-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent

if Parent:IsA("Model") then
    local BeeLauncher = require(ReplicatedStorage.Shared.Flags.GameplayBalance).BeeLauncher

    require(ReplicatedStorage.Controllers.Game.BeeEffectController).Apply(Parent, BeeLauncher.EFFECT_DURATION_SECONDS)
end
