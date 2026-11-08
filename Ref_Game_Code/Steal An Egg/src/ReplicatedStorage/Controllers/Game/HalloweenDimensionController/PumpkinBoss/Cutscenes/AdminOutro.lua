-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local MoonScene = require(script.Parent.MoonScene)

require(script.Parent.Parent.Scenes)

local OutroCutscene = ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets.OutroCutscene

local function linear(p1, p2) -- line: 35
    return TweenInfo.new((p2 - p1) / 60, Enum.EasingStyle.Linear)
end

local function fadeBeam(p3, p4) -- line: 39
    -- upvalues: TweenService (copy)
    local Transparency, Width0, Width1 = p3.Transparency, p3.Width0, p3.Width1
    local v1 = p4 * 0.2
    local v2 = p4 * 0.4
    local v3 = p4 * 0.75

    local function setFade(p5) -- line: 47
        -- upvalues: p3 (copy), Transparency (copy)
        local t1 = {}

        for v4, v5 in Transparency.Keypoints do
            t1[v4] = NumberSequenceKeypoint.new(v5.Time, v5.Value + (1 - v5.Value) * p5, v5.Envelope)
        end

        p3.Transparency = NumberSequence.new(t1)
    end

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = 1
    setFade(1)

    local connection = NumberValue.Changed:Connect(setFade)

    p3.Enabled = true

    local tween = TweenService:Create(NumberValue, TweenInfo.new(v1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = 0
    })
    local tween2 = TweenService:Create(NumberValue, TweenInfo.new(v2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Value = 1
    })
    local tween3 = TweenService:Create(p3, TweenInfo.new(p4 - v3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Width0 = 0,
        Width1 = 0
    })

    tween:Play()
    task.delay(p4 - v2, function() -- line: 73
        -- upvalues: tween2 (copy)
        tween2:Play()
    end)
    task.delay(v3, function() -- line: 76
        -- upvalues: tween3 (copy)
        tween3:Play()
    end)
    task.delay(p4, function() -- line: 79
        -- upvalues: p3 (copy), Transparency (copy), Width0 (copy), Width1 (copy), NumberValue (copy), connection (copy), tween (copy), tween2 (copy), tween3 (copy)
        tween:Cancel()
        tween2:Cancel()
        tween3:Cancel()
        connection:Disconnect()
        NumberValue:Destroy()
        p3.Enabled = false
        p3.Transparency = Transparency
        p3.Width0 = Width0
        p3.Width1 = Width1
    end)
end

local function slash(p6) -- line: 93
    -- upvalues: fadeBeam (copy)
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 102
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy), fadeBeam (copy)
                if descendant:IsA("ParticleEmitter") then
                    if type(EmitCount) == "number" and EmitCount > 0 then
                        descendant:Emit(EmitCount)
                    end

                    if type(EmitDuration) == "number" and EmitDuration > 0 then
                        descendant.Enabled = true
                        task.delay(EmitDuration, function() -- line: 109
                            -- upvalues: descendant (copy)
                            descendant.Enabled = false
                        end)
                    end
                elseif descendant:IsA("Beam") and type(EmitDuration) == "number" and EmitDuration > 0 then
                    fadeBeam(descendant, EmitDuration)
                end
            end)
        end
    end
end

local function build(p7) -- line: 120
    -- upvalues: slash (copy)
    local SetProperty, TweenProperty, Emit, SetEmitting = p7.SetProperty, p7.TweenProperty, p7.Emit, p7.SetEmitting
    local Vfx, Set = p7.Vfx, p7.Set
    local t2 = {}

    t2[0] = {
        SetProperty("Workspace.CurrentCamera.FieldOfView", 35),
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 2),
        SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
        SetProperty("Lighting.CutsceneDepthOfField.InFocusRadius", 25),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1)
    }
    t2[14] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Sine), 45) }
    t2[63] = {
        function() -- line: 139
            -- upvalues: SetEmitting (copy), Vfx (copy)
            SetEmitting(Vfx.Rumble, true)
        end
    }
    t2[78] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(4.216666666666667, Enum.EasingStyle.Sine), 55) }
    t2[84] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 15) }
    t2[94] = {
        function() -- line: 146
            -- upvalues: Emit (copy), Vfx (copy)
            Emit(Vfx.Slam1)
        end
    }
    t2[95] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), 4) }
    t2[234] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 10) }
    t2[240] = {
        function() -- line: 153
            -- upvalues: Vfx (copy), slash (copy)
            slash(Vfx.Slash)
        end
    }
    t2[243] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 4) }
    t2[283] = {
        function() -- line: 159
            -- upvalues: SetEmitting (copy), Vfx (copy)
            SetEmitting(Vfx.Rumble, false)
        end
    }
    t2[331] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2) }
    t2[332] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Back), 35) }
    t2[443] = {
        function() -- line: 166
            -- upvalues: Emit (copy), Vfx (copy)
            Emit(Vfx.Highfive)
        end
    }
    t2[556] = {
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 13),
        TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 5)
    }
    t2[557] = {
        function() -- line: 175
            -- upvalues: Emit (copy), Set (copy)
            Emit(Set.PumpkinPortal)
        end,
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 2)
    }
    t2[564] = { TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 25) }
    t2[842] = { TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 5) }
    t2[915] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 25) }
    t2[961] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 0) }

    return t2
end

local function play(p8) -- line: 187
    -- upvalues: PumpkinBossState (copy), MoonScene (copy), OutroCutscene (copy), build (copy)
    local Attribute = p8.Arena:GetAttribute(PumpkinBossState.Attributes.Center)

    assert(typeof(Attribute) == "Vector3" and (Attribute - Vector3.new(-133552.14, 476.24, 980.7)).Magnitude < 0.5, "AdminOutro assets were baked for another arena position; re-bake them")

    return MoonScene.Play(p8, {
        Prefix = "PumpkinOutro",
        Frames = 1044,
        CameraPart = "Cam",
        HoldBlack = true,
        Assets = OutroCutscene,
        Build = build
    })
end

return table.freeze({
    Play = play
})
