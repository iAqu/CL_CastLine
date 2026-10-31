-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local atom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local v1 = atom(true)
local v2 = atom(true)

local function playEffect(p1, p2) -- line: 7
    -- upvalues: Workspace (copy), v1 (copy)
    if not v1() then
        return nil
    end

    local HapticEffect = Instance.new("HapticEffect")

    HapticEffect.Type = p1
    HapticEffect.Parent = p2 or Workspace
    HapticEffect:Play()
    HapticEffect.Ended:Once(function() -- line: 15
        -- upvalues: HapticEffect (copy)
        return HapticEffect:Destroy()
    end)
end

return {
    hapticCircleClick = function() -- hapticCircleClick | line: 20
        -- upvalues: playEffect (copy)
        playEffect(Enum.HapticEffectType.GameplayCollision)
    end,
    hapticCrateTap = function(p3) -- hapticCrateTap | line: 24
        -- upvalues: playEffect (copy)
        playEffect(if p3 ~= nil and p3 then Enum.HapticEffectType.GameplayCollision else Enum.HapticEffectType.UIClick)
    end,
    hapticWaterSkip = function() -- hapticWaterSkip | line: 31
    end,
    hapticBonusRoll = function() -- hapticBonusRoll | line: 36
    end,
    hapticPerfectHit = function() -- hapticPerfectHit | line: 41
        -- upvalues: playEffect (copy)
        playEffect(Enum.HapticEffectType.GameplayCollision)
    end,
    hapticCatch = function() -- hapticCatch | line: 45
        -- upvalues: playEffect (copy)
        playEffect(Enum.HapticEffectType.UIClick)
    end,
    hapticDrag = function() -- hapticDrag | line: 49
        -- upvalues: playEffect (copy)
        playEffect(Enum.HapticEffectType.GameplayCollision)
    end,
    hapticsEnabledAtom = v1,
    cameraShakeEnabledAtom = v2
}
