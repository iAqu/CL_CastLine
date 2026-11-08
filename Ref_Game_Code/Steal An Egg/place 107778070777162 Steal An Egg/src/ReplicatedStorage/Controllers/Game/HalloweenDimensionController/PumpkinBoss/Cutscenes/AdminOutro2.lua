-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local MoonScene = require(script.Parent.MoonScene)

require(script.Parent.Parent.Scenes)

local Transition = require(script.Parent.Parent.Transition)

require(ReplicatedStorage.Packages.Trove)

local OutroCutscene2 = ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets.OutroCutscene2
local UnixTimestamp = DateTime.fromUniversalTime(2026, 10, 28, 15).UnixTimestamp
local v1 = Color3.new(1, 0.784314, 0.415686)
local v2 = Color3.new(1, 1, 1)

local function linear(p1, p2) -- line: 44
    return TweenInfo.new((p2 - p1) / 60, Enum.EasingStyle.Linear)
end

local function countdown(p3) -- line: 48
    local v4 = math.max(0, (math.floor(p3)))

    return string.format("%02i:%02i:%02i:%02i", v4 // 86400, v4 // 3600 % 24, v4 // 60 % 60, v4 % 60)
end

local function build(p4) -- line: 53
    -- upvalues: v1 (copy), v2 (copy)
    local SetProperty, TweenProperty, SetEmitting = p4.SetProperty, p4.TweenProperty, p4.SetEmitting
    local Decor = p4.Rigs.EnvelopeRig.GoldenEnvelope.Decor
    local t1 = {}

    t1[0] = {
        SetProperty("Workspace.CurrentCamera.FieldOfView", 35),
        function() -- line: 62
            -- upvalues: SetEmitting (copy), Decor (copy)
            SetEmitting(Decor, true)
        end,
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(1, 0.588978, 0.25098)),
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
        SetProperty("Lighting.Gold.TintColor", v2),
        SetProperty("Lighting.Gold.Brightness", 0),
        SetProperty("Lighting.Gold.Saturation", 0),
        SetProperty("Lighting.Gold.Contrast", 0),
        SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
        SetProperty("Lighting.CutsceneDepthOfField.FarIntensity", 0.09),
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 15),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 2),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1)
    }
    t1[180] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 15) }
    t1[197] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1, Enum.EasingStyle.Linear), 4) }
    t1[240] = {
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gold.TintColor", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), v1),
        TweenProperty("Lighting.Gold.Brightness", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.3),
        TweenProperty("Lighting.Gold.Saturation", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.5),
        TweenProperty("Lighting.Gold.Contrast", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.7)
    }
    t1[307] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 10) }
    t1[322] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 4) }
    t1[390] = {
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Gold.TintColor", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), v2),
        TweenProperty("Lighting.Gold.Brightness", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gold.Saturation", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Gold.Contrast", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0)
    }
    t1[402] = {
        function() -- line: 98
            -- upvalues: SetEmitting (copy), Decor (copy)
            SetEmitting(Decor, false)
        end
    }
    t1[421] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 10) }
    t1[424] = { TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.5) }
    t1[425] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 2) }
    t1[645] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 32),
        TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 7)
    }
    t1[646] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 4) }
    t1[769] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 0) }
    t1[796] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 1) }
    t1[1147] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 10) }
    t1[1160] = { SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0) }

    return t1
end

local function play(p5) -- line: 119
    -- upvalues: Players (copy), SoundService (copy), Workspace (copy), BulkFade (copy), MoonScene (copy), Transition (copy), OutroCutscene2 (copy), UnixTimestamp (copy), build (copy)
    local ConcertTeaser = p5.Player.PlayerGui.CutsceneUI.ConcertTeaser
    local TimeRemaining = ConcertTeaser.TimeRemaining
    local v5 = BulkFade.new(ConcertTeaser, TweenInfo.new(1))
    local v6

    local function showTeaser() -- line: 125
        -- upvalues: ConcertTeaser (copy), TimeRemaining (copy), v5 (copy), v6 (ref), Workspace (copy), UnixTimestamp (copy)
        v5:FadeOutInstant()
        ConcertTeaser.Visible = true
        v5:FadeIn()

        local v7 = os.clock() + 5 + 1

        while ConcertTeaser.Visible and os.clock() < v7 do
            local v10 = math.max(0, (math.floor(UnixTimestamp - Workspace:GetServerTimeNow())))

            TimeRemaining.Text = ("ARTIST REVEAL IN %*"):format((string.format("%02i:%02i:%02i:%02i", v10 // 86400, v10 // 3600 % 24, v10 // 60 % 60, v10 % 60)))

            local v11 = v6

            if v11 then
                v11:Play()
            end

            task.wait(1)
        end
    end

    return MoonScene.Play(p5, {
        Prefix = "PumpkinOutro2",
        Frames = 1580,
        CameraPart = "Cam",
        HoldBlack = true,
        Assets = OutroCutscene2,
        Build = function(p6) -- Build | line: 146
            -- upvalues: v5 (copy), showTeaser (copy), build (copy)
            local v12 = build(p6)

            table.insert(v12[1160], showTeaser)
            v12[1520] = {
                function() -- line: 150
                    -- upvalues: v5 (copy)
                    v5:FadeOut()
                end
            }

            return v12
        end,
        Setup = function(p7) -- Setup | line: 156
            -- upvalues: ConcertTeaser (copy), v5 (copy), v6 (ref), Players (copy), SoundService (copy), Transition (copy)
            Players.LocalPlayer.PlayerGui.CutsceneUI.Black.BackgroundTransparency = 0
            Transition.Reveal(0)

            local v14 = p7:Add(Instance.new("Sound"))

            v14.SoundId = "rbxassetid://119317416196943"
            v14.Volume = 0.2
            v14.Parent = SoundService
            v6 = v14
            p7:Add(function() -- line: 166
                -- upvalues: ConcertTeaser (copy), v5 (copy), v6 (ref)
                v6 = nil
                ConcertTeaser.Visible = false
                v5:FadeIn()
            end)
        end
    })
end

return table.freeze({
    Play = play
})
