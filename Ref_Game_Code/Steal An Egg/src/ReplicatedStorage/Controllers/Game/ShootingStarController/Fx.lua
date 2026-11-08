-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Shake = require(ReplicatedStorage.Client.Shake)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local v1 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ColorCorrectionEffect, tween
local tween2 = nil
local FieldOfView
local t1 = {}

function t1.Kit() -- line: 33
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    return if Assets then Assets:FindFirstChild("ShootingStar") else nil
end

function t1.KitReady() -- line: 38
    -- upvalues: t1 (copy)
    local v2 = t1.Kit()

    if v2 == nil or v2:FindFirstChild("Meteor") == nil then
        return false
    end

    return v2:FindFirstChild("FallingStar") ~= nil
end

function t1.ReducedMotion() -- line: 45
    -- upvalues: GuiService (copy)
    return GuiService.ReducedMotionEnabled
end

function t1.Sound(p1, p2, p3, p4) -- line: 49
    -- upvalues: Audio (copy), t1 (copy)
    local v3 = t1.Kit()
    local Sounds = v3 and v3:FindFirstChild("Sounds")
    local v4 = Sounds and Sounds:FindFirstChild(p1)
    local Play, v5, v6

    if v4 ~= nil then
        if v4:IsA("Sound") then
            Play = Audio.Play
            v5 = p2 or script
            v6 = false
        else
            v6 = true
        end
    else
        v6 = true
    end

    if v6 then
        return nil
    end

    return Play(v4, v5, {
        Volume = p3 or v4.Volume,
        PlaybackSpeed = p4 or v4.PlaybackSpeed,
        MaxDistance = if p2 then v4.RollOffMaxDistance else nil
    })
end

function t1.Emit(p5, p6, p7) -- line: 63
    -- upvalues: VFX (copy), t1 (copy)
    local v7 = t1.Kit()
    local Vfx = v7 and v7:FindFirstChild("Vfx")
    local v8 = Vfx and Vfx:FindFirstChild(p5)

    if v8 == nil then
        return
    end

    local t3 = {}

    for _, descendant in v8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t3, descendant)
        end
    end

    VFX.EmitAt(p6, t3, function(p8) -- line: 76
        -- upvalues: p7 (copy), VFX (copy)
        if p7 and p7 ~= 1 then
            VFX.Rescale(p8, p7)
        end
    end)
end

function t1.Flash(p9, p10, p11) -- line: 83
    -- upvalues: Flash (copy)
    Flash.Play({
        Attack = 0.02,
        Decay = p11 or 0.3,
        Tint = p9,
        Opacity = p10
    })
end

function t1.Dip(p12, p13) -- line: 87
    -- upvalues: Flash (copy)
    Flash.Play({
        Opacity = 1,
        Attack = p12,
        Decay = p13 or p12,
        Tint = Color3.new(0, 0, 0)
    })
end

function t1.Grade(p14, p15, p16) -- line: 96
    -- upvalues: Lighting (copy), TweenService (copy), ColorCorrectionEffect (ref), tween (ref)
    if ColorCorrectionEffect == nil or ColorCorrectionEffect.Parent == nil then
        local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect")

        ColorCorrectionEffect2.Name = "ShootingStarImpact"
        ColorCorrectionEffect2.Parent = Lighting
        ColorCorrectionEffect = ColorCorrectionEffect2
    end

    local ColorCorrectionEffect2 = ColorCorrectionEffect

    if tween then
        tween:Cancel()
    end

    ColorCorrectionEffect2.Brightness = p15 * 0.25
    ColorCorrectionEffect2.Contrast = p15 * 0.6
    ColorCorrectionEffect2.Saturation = p15 * -0.3
    ColorCorrectionEffect2.TintColor = Color3.new(1, 1, 1):Lerp(p14, 0.4)

    local tween2 = TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(p16, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    })

    tween = tween2
    tween2:Play()
end

function t1.FovPunch(p17, p18) -- line: 120
    -- upvalues: TweenService (copy), Workspace (copy), v1 (copy), tween2 (ref), FieldOfView (ref), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if t1.ReducedMotion() or CurrentCamera == nil then
        return
    end

    if tween2 ~= nil then
        tween2:Cancel()
    else
        FieldOfView = CurrentCamera.FieldOfView
    end

    local v9 = FieldOfView or CurrentCamera.FieldOfView
    local tween = TweenService:Create(CurrentCamera, v1, {
        FieldOfView = v9 - p17
    })

    tween2 = tween
    tween:Play()
    tween.Completed:Once(function(p19) -- line: 134
        -- upvalues: p18 (copy), CurrentCamera (copy), v9 (copy), tween (copy), TweenService (copy), tween2 (ref), FieldOfView (ref)
        if p19 == Enum.PlaybackState.Completed and tween2 == tween then
            local tween3 = TweenService:Create(CurrentCamera, TweenInfo.new(p18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                FieldOfView = v9
            })

            tween2 = tween3
            tween3:Play()
            tween3.Completed:Once(function() -- line: 145
                -- upvalues: tween3 (copy), tween2 (ref), FieldOfView (ref)
                if tween2 == tween3 then
                    tween2 = nil
                    FieldOfView = nil
                end
            end)
        end
    end)
end

function t1.Shake(p20, p21, p22) -- line: 154
    -- upvalues: Shake (copy), t1 (copy)
    local v10 = if t1.ReducedMotion() then p21 * 0.3 else p21

    Shake.Play({
        Shape = "Fade",
        Rumble = true,
        Seconds = p20,
        Magnitude = v10,
        Range = if p22 then {
            Near = 40,
            Far = 260,
            Center = p22
        } else nil
    })
end

function t1.HitFlash(p23, p24) -- line: 167
    -- upvalues: TweenService (copy), VFX (copy)
    local HitFlash = p23:FindFirstChild("HitFlash")

    if HitFlash then
        HitFlash:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "HitFlash"
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 0.05
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p23
    Highlight.Parent = p23
    TweenService:Create(Highlight, TweenInfo.new(p24, Enum.EasingStyle.Quad), {
        FillTransparency = 1
    }):Play()
    VFX.Discard(Highlight, p24 + 0.05)
end

return t1
