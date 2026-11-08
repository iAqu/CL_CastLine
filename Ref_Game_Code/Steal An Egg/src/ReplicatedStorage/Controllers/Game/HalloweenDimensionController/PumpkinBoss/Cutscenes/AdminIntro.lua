-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)

require(ReplicatedStorage.Packages.Trove)

local MoonScene = require(script.Parent.MoonScene)

require(script.Parent.Parent.Scenes)

local IntroCutscene = ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets.IntroCutscene
local t1 = {
    "DoorLeft",
    "DoorRight"
}
local v1 = Color3.new(0, 0, 0)
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(1, 0.690196, 0.905882)
local v4 = Color3.new(1, 0.596078, 0.458824)

local function linear(p1, p2) -- line: 39
    return TweenInfo.new((p2 - p1) / 60, Enum.EasingStyle.Linear)
end

local function sine(p3, p4) -- line: 43
    return TweenInfo.new((p4 - p3) / 60, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
end

local function build(p5) -- line: 47
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy)
    local SetProperty, TweenProperty, Emit, SetEmitting = p5.SetProperty, p5.TweenProperty, p5.Emit, p5.SetEmitting
    local Rigs, Vfx = p5.Rigs, p5.Vfx

    local function burst(p6) -- line: 55
        -- upvalues: Emit (copy)
        return function() -- line: 56
            -- upvalues: p6 (copy), Emit (copy)
            Emit(p6)
        end
    end

    local function emitting(p7, p8) -- line: 61
        -- upvalues: SetEmitting (copy)
        return function() -- line: 62
            -- upvalues: p7 (copy), p8 (copy), SetEmitting (copy)
            SetEmitting(p7, p8)
        end
    end

    local function enabled(p9, p10) -- line: 67
        -- upvalues: SetProperty (copy)
        return SetProperty(("Lighting.%*.Enabled"):format(p9), p10)
    end

    local t2 = {}

    t2[0] = {
        SetProperty("Workspace.CurrentCamera.FieldOfView", 50),
        SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
        SetProperty("Lighting.CutsceneDepthOfField.FarIntensity", 0.74),
        SetProperty("Lighting.CutsceneDepthOfField.InFocusRadius", 10),
        TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(26.35, Enum.EasingStyle.Linear), 5),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 1),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", v1),
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", v1),
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
        SetProperty("Lighting.Black+White.Enabled", false),
        SetProperty("Lighting.White+Black.Enabled", false),
        SetProperty("Lighting.OrangeWhite.Enabled", false),
        SetProperty("Lighting.OrangeBlack.Enabled", false),
        SetProperty("Lighting.Moon.Enabled", false),
        SetProperty("Lighting.Moon.Saturation", 0.4),
        TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Moon.Contrast", -0.1),
        TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Moon.TintColor", v3),
        TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), v2),
        SetProperty("Lighting.Moon.Brightness", 0.1),
        TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Gray.Enabled", false),
        SetProperty("Lighting.Gray.Saturation", -0.4),
        TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Gray.Contrast", 1),
        TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Gray.TintColor", v2),
        SetProperty("Lighting.Gray.Brightness", 0.1),
        TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
        SetProperty("Workspace.PumpkinIntroVFX.PumpkinLight.Attachment.SurfaceLight.Brightness", 0),
        SetProperty("Lighting.Pumpkin.Enabled", false),
        SetProperty("Lighting.Pumpkin.Saturation", 0.1),
        TweenProperty("Lighting.Pumpkin.Saturation", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Pumpkin.Contrast", 0.1),
        TweenProperty("Lighting.Pumpkin.Contrast", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.Pumpkin.TintColor", v4),
        TweenProperty("Lighting.Pumpkin.TintColor", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), v2),
        SetProperty("Lighting.Pumpkin.Brightness", 0.2),
        TweenProperty("Lighting.Pumpkin.Brightness", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 15),
        SetProperty("Workspace.PumpkinIntroRigs.pumpkinbossagain.Pumpkin Monster Neon.Color", Color3.new(0.0901961, 0.0408195, 0.0212226)),
        SetProperty("Lighting.Atmosphere.Color", Color3.new(0.501961, 0.305882, 1)),
        SetProperty("Lighting.Atmosphere.Density", 0.5),
        function() -- line: 119
            local BossPortal = game.Workspace.HalloweenDimension.BossPortal

            BossPortal.Parent = nil
            task.delay(60, function() -- line: 123
                -- upvalues: BossPortal (copy)
                BossPortal.Parent = game.Workspace.HalloweenDimension
            end)
        end
    }
    t2[26] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.0333333333333334, Enum.EasingStyle.Linear), 2) }
    t2[58] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.45, Enum.EasingStyle.Linear), Color3.new(0.113788, 0.0602099, 0.00981705)) }
    t2[85] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(11.033333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.529139, 0.0862745)) }

    local PumpkinPortal = Rigs.PumpkinPortal

    t2[224] = {
        function() -- line: 56
            -- upvalues: Emit (copy), PumpkinPortal (copy)
            Emit(PumpkinPortal)
        end
    }

    local Bats = Vfx.Bats

    t2[256] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Bats (copy)
            Emit(Bats)
        end
    }
    t2[274] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(1, Enum.EasingStyle.Linear), 0.1) }
    t2[334] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 0.1) }
    t2[361] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.8) }

    local PumpkinPortal2 = Rigs.PumpkinPortal

    t2[362] = {
        function() -- line: 56
            -- upvalues: Emit (copy), PumpkinPortal2 (copy)
            Emit(PumpkinPortal2)
        end,
        TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 0.6)
    }
    t2[384] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), 0.2) }
    t2[415] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(4.633333333333334, Enum.EasingStyle.Linear), 0.12626) }
    t2[693] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 60),
        TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.3)
    }

    local PumpkinPortal3 = Rigs.PumpkinPortal

    t2[694] = {
        function() -- line: 56
            -- upvalues: Emit (copy), PumpkinPortal3 (copy)
            Emit(PumpkinPortal3)
        end,
        TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(1.6333333333333333, Enum.EasingStyle.Linear), 0.1)
    }
    t2[747] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 0) }
    t2[748] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 15) }
    t2[780] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1) }

    local PumpkinPortal4 = Rigs.PumpkinPortal

    t2[787] = {
        function() -- line: 56
            -- upvalues: Emit (copy), PumpkinPortal4 (copy)
            Emit(PumpkinPortal4)
        end
    }
    t2[792] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1) }
    t2[817] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6833333333333333, Enum.EasingStyle.Linear), 2) }
    t2[917] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 8) }
    t2[935] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2) }
    t2[1020] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 10)
    }
    t2[1021] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 4) }
    t2[1047] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 6) }
    t2[1070] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7, Enum.EasingStyle.Linear), 2) }
    t2[1103] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 15) }
    t2[1106] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 0.5) }
    t2[1112] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 12) }
    t2[1120] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 0.51735) }
    t2[1121] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 2) }

    local Flip = Vfx.Flip

    t2[1141] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Flip (copy)
            Emit(Flip)
        end
    }
    t2[1149] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 7) }
    t2[1162] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 2) }
    t2[1183] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0) }
    t2[1184] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 6) }

    local Leap = Vfx.Leap

    t2[1186] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Leap (copy)
            Emit(Leap)
        end
    }
    t2[1195] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 0.00172) }
    t2[1198] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 60),
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2)
    }
    t2[1289] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50) }

    local Hit = Vfx.Hit

    t2[1311] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Hit (copy)
            Emit(Hit)
        end
    }
    t2[1335] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 14) }
    t2[1336] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 2) }
    t2[1413] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 12) }

    local PumpkinHit = Vfx.PumpkinHit

    t2[1414] = {
        function() -- line: 56
            -- upvalues: Emit (copy), PumpkinHit (copy)
            Emit(PumpkinHit)
        end,
        enabled("OrangeWhite", true)
    }
    t2[1416] = {
        SetProperty("Lighting.OrangeWhite.Enabled", false),
        enabled("OrangeBlack", true)
    }
    t2[1418] = { enabled("OrangeBlack", false) }
    t2[1419] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2) }

    local Fall = Vfx.Fall

    t2[1476] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Fall (copy)
            Emit(Fall)
        end
    }
    t2[1598] = { TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 10) }
    t2[1769] = { enabled("OrangeWhite", true) }

    local Kick1 = Vfx.Kicks.Kick1

    t2[1770] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Kick1 (copy)
            Emit(Kick1)
        end
    }
    t2[1771] = { enabled("OrangeWhite", false) }

    local Kick2 = Vfx.Kicks.Kick2

    t2[1810] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Kick2 (copy)
            Emit(Kick2)
        end,
        enabled("OrangeWhite", true)
    }
    t2[1812] = { enabled("OrangeWhite", false) }

    local Kick3 = Vfx.Kicks.Kick3

    t2[1902] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Kick3 (copy)
            Emit(Kick3)
        end,
        enabled("OrangeWhite", true)
    }
    t2[1904] = {
        SetProperty("Lighting.OrangeWhite.Enabled", false),
        enabled("OrangeBlack", true)
    }
    t2[1906] = { enabled("OrangeBlack", false) }
    t2[1983] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10) }

    local Jump = Vfx.Jump

    t2[1986] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Jump (copy)
            Emit(Jump)
        end
    }
    t2[1990] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 2) }
    t2[2126] = { enabled("OrangeWhite", true) }

    local Kick4 = Vfx.Kicks.Kick4

    t2[2127] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Kick4 (copy)
            Emit(Kick4)
        end
    }
    t2[2128] = { enabled("OrangeWhite", false) }
    t2[2185] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 80) }

    local Kick5 = Vfx.Kicks.Kick5

    t2[2193] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Kick5 (copy)
            Emit(Kick5)
        end
    }
    t2[2208] = { enabled("OrangeBlack", true) }
    t2[2210] = { enabled("OrangeBlack", false) }
    t2[2211] = { enabled("OrangeWhite", true) }
    t2[2213] = {
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.8333333333333334, Enum.EasingStyle.Linear), Color3.new(0.377869, 1, 0.337255)),
        SetProperty("Lighting.OrangeWhite.Enabled", false),
        enabled("OrangeBlack", true)
    }
    t2[2215] = {
        SetProperty("Lighting.White+Black.Enabled", true),
        enabled("OrangeBlack", false)
    }
    t2[2217] = {
        SetProperty("Lighting.Black+White.Enabled", true),
        enabled("White+Black", false)
    }
    t2[2219] = { enabled("Black+White", false) }
    t2[2222] = { enabled("OrangeBlack", true) }
    t2[2224] = {
        SetProperty("Lighting.OrangeWhite.Enabled", true),
        enabled("OrangeBlack", false)
    }
    t2[2226] = { enabled("OrangeWhite", false) }
    t2[2245] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50),
        TweenProperty("Lighting.Atmosphere.Density", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.27)
    }
    t2[2246] = {
        SetProperty("Lighting.Moon.Enabled", true),
        TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 0.4),
        TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), -0.1),
        TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), v3),
        TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 0.1)
    }
    t2[2253] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0) }
    t2[2263] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0.75) }
    t2[2329] = {
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), v2),
        TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0)
    }
    t2[2333] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 1) }
    t2[2335] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), v1) }
    t2[2345] = {
        SetProperty("Lighting.Moon.Enabled", false),
        TweenProperty("Lighting.Atmosphere.Density", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.5)
    }

    local Head = Vfx.Head

    t2[2379] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Head (copy)
            Emit(Head)
        end,
        enabled("OrangeBlack", true)
    }
    t2[2381] = { enabled("OrangeBlack", false) }
    t2[2384] = { TweenProperty("Workspace.PumpkinIntroRigs.pumpkinbossagain.Pumpkin Monster Neon.Color", TweenInfo.new(0.2, Enum.EasingStyle.Linear), Color3.new(0.760784, 0.345098, 0.180392)) }

    local Rumble = Vfx.Rumble
    local v5 = true

    t2[2501] = {
        function() -- line: 62
            -- upvalues: SetEmitting (copy), Rumble (copy), v5 (copy)
            SetEmitting(Rumble, v5)
        end
    }

    local Slam1 = Vfx.Slam1

    t2[2534] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Slam1 (copy)
            Emit(Slam1)
        end
    }
    t2[2547] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 10) }
    t2[2572] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 6) }

    local Slam2 = Vfx.Slam2

    t2[2573] = {
        function() -- line: 56
            -- upvalues: Emit (copy), Slam2 (copy)
            Emit(Slam2)
        end
    }
    t2[2595] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 8) }
    t2[2621] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 3) }
    t2[2650] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 7) }
    t2[2677] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 2) }
    t2[2703] = { TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 20) }

    local Rumble2 = Vfx.Rumble
    local v6 = false

    t2[2729] = {
        function() -- line: 62
            -- upvalues: SetEmitting (copy), Rumble2 (copy), v6 (copy)
            SetEmitting(Rumble2, v6)
        end
    }
    t2[2779] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 0.2) }

    local Roar = Vfx.Roar
    local v7 = true

    t2[2785] = {
        function() -- line: 62
            -- upvalues: SetEmitting (copy), Roar (copy), v7 (copy)
            SetEmitting(Roar, v7)
        end
    }
    t2[2790] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(2.3666666666666667, Enum.EasingStyle.Linear), 0.2) }
    t2[2796] = {
        SetProperty("Lighting.Gray.Enabled", true),
        TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), -0.4),
        TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.1)
    }
    t2[2813] = {
        TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0)
    }
    t2[2832] = {
        TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), -0.4),
        TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.1)
    }
    t2[2865] = {
        TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0)
    }
    t2[2882] = { enabled("Gray", false) }

    local Roar2 = Vfx.Roar
    local v8 = false

    t2[2889] = {
        function() -- line: 62
            -- upvalues: SetEmitting (copy), Roar2 (copy), v8 (copy)
            SetEmitting(Roar2, v8)
        end
    }
    t2[2932] = { TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 10) }
    t2[2933] = {
        TweenProperty("Workspace.PumpkinIntroVFX.PumpkinLight.Attachment.SurfaceLight.Brightness", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 2),
        SetProperty("Lighting.Pumpkin.Enabled", true),
        TweenProperty("Lighting.Pumpkin.Saturation", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.1),
        TweenProperty("Lighting.Pumpkin.Contrast", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.1),
        TweenProperty("Lighting.Pumpkin.TintColor", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), v4),
        TweenProperty("Lighting.Pumpkin.Brightness", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.2)
    }
    t2[2936] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 0) }
    t2[2970] = {
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", v1),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.5, Enum.EasingStyle.Linear), 0)
    }

    return t2
end

local function play(p11) -- line: 307
    -- upvalues: Workspace (copy), HalloweenDimension (copy), MoonScene (copy), IntroCutscene (copy), t1 (copy), build (copy)
    local v9 = Workspace:FindFirstChild(HalloweenDimension.MapName)

    assert(v9 ~= nil, "AdminIntro plays on the Halloween dimension map, which is not open")

    local CastleGate = v9.CastleGate
    local t3 = {}

    for _, v11 in t1 do
        for _, descendant in CastleGate[v11]:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                table.insert(t3, descendant)
            end
        end
    end

    return MoonScene.Play(p11, {
        Prefix = "PumpkinIntro",
        Frames = 3000,
        CameraPart = "Head",
        HoldBlack = true,
        Assets = IntroCutscene,
        Build = build,
        Setup = function(p12) -- Setup | line: 327
            -- upvalues: t3 (copy)
            for _, v12 in t3 do
                v12.LocalTransparencyModifier = 1
            end

            p12:Add(function() -- line: 331
                -- upvalues: t3 (copy)
                for _, v13 in t3 do
                    v13.LocalTransparencyModifier = 0
                end
            end)
        end
    })
end

return table.freeze({
    Play = play
})
