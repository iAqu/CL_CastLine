-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1[0] = {
    SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(-81.0611, 138.7064, 994.4508, 0.03, 0.5169, -0.8556, 0, 0.8559, 0.5171, 0.9995, -0.0155, 0.0256)),
    SetProperty("Workspace.CurrentCamera.AttachToPart", Cam),
    SetProperty("Workspace.CurrentCamera.FieldOfView", 35),
    SetProperty("Lighting.Blur.Enabled", true),
    SetProperty("Lighting.Blur.Size", 2),
    SetProperty("Lighting.DepthOfField.Enabled", true),
    SetProperty("Lighting.DepthOfField.InFocusRadius", 25),
    SetProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", 1)
}
t1[14] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Sine), 45) }
t1[63] = {
    function() -- line: 20
        local Rumble = workspace.VFX.Rumble

        for _, descendant in pairs(Rumble:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = true
            end
        end
    end
}
t1[78] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(4.216666666666667, Enum.EasingStyle.Sine), 55) }
t1[84] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 15) }
t1[94] = {
    function() -- line: 37
        local Slam1 = workspace.VFX.Slam1

        function check(p1) -- line: 40
            return p1 ~= nil and p1 ~= 0
        end

        for _, descendant in pairs(Slam1:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 55
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[95] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), 4) }
t1[234] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 10) }
t1[240] = {
    function() -- line: 72
        local TweenService = game:GetService("TweenService")
        local Slash = workspace.VFX.Slash
        local t2 = {}

        local function check(p2) -- line: 86
            if typeof(p2) == "number" then
                return p2 > 0
            end

            return false
        end

        local function enableFor(p3, p4) -- line: 90
            p3.Enabled = true
            task.delay(p4, function() -- line: 92
                -- upvalues: p3 (copy)
                p3.Enabled = false
            end)
        end

        local function fadeBeam(p5, p6) -- line: 97
            -- upvalues: TweenService (copy), t2 (copy)
            local v1 = t2[p5] or {
                Transparency = p5.Transparency,
                Width0 = p5.Width0,
                Width1 = p5.Width1
            }

            t2[p5] = v1

            local v2 = p6 * 0.2
            local v3 = p6 * 0.4
            local v4 = p6 * 0.75

            local function setFade(p7) -- line: 111
                -- upvalues: p5 (copy), v1 (copy)
                local t3 = {}

                for v5, v6 in v1.Transparency.Keypoints do
                    t3[v5] = NumberSequenceKeypoint.new(v6.Time, v6.Value + (1 - v6.Value) * p7, v6.Envelope)
                end

                p5.Transparency = NumberSequence.new(t3)
            end

            local NumberValue = Instance.new("NumberValue")

            NumberValue.Value = 1
            setFade(1)

            local connection = NumberValue.Changed:Connect(setFade)

            p5.Width0 = v1.Width0
            p5.Width1 = v1.Width1
            p5.Enabled = true

            local tween = TweenService:Create(NumberValue, TweenInfo.new(v2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Value = 0
            })
            local tween2 = TweenService:Create(NumberValue, TweenInfo.new(v3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Value = 1
            })
            local tween3 = TweenService:Create(p5, TweenInfo.new(p6 - v4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Width0 = 0,
                Width1 = 0
            })

            tween:Play()
            task.delay(p6 - v3, function() -- line: 133
                -- upvalues: tween2 (copy)
                tween2:Play()
            end)
            task.delay(v4, function() -- line: 136
                -- upvalues: tween3 (copy)
                tween3:Play()
            end)
            task.delay(p6, function() -- line: 141
                -- upvalues: p5 (copy), v1 (copy), NumberValue (copy), connection (copy), tween (copy), tween2 (copy), tween3 (copy)
                tween:Cancel()
                tween2:Cancel()
                tween3:Cancel()
                connection:Disconnect()
                NumberValue:Destroy()
                p5.Enabled = false
                p5.Transparency = v1.Transparency
                p5.Width0 = v1.Width0
                p5.Width1 = v1.Width1
            end)
        end

        local function play(p8) -- line: 155
            -- upvalues: fadeBeam (copy)
            local EmitCount = p8:GetAttribute("EmitCount")
            local EmitDuration = p8:GetAttribute("EmitDuration")

            if p8:IsA("ParticleEmitter") then
                if typeof(EmitCount) == "number" and EmitCount > 0 then
                    p8:Emit(EmitCount)
                end

                if typeof(EmitDuration) == "number" and EmitDuration > 0 then
                    p8.Enabled = true
                    task.delay(EmitDuration, function() -- line: 92
                        -- upvalues: p8 (copy)
                        p8.Enabled = false
                    end)
                end
            elseif p8:IsA("Beam") and typeof(EmitDuration) == "number" and EmitDuration > 0 then
                fadeBeam(p8, EmitDuration)
            end
        end

        for _, descendant in Slash:GetDescendants() do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
                local EmitDelay = descendant:GetAttribute("EmitDelay")

                if typeof(EmitDelay) == "number" and EmitDelay > 0 then
                    task.delay(EmitDelay, play, descendant)
                else
                    play(descendant)
                end
            end
        end
    end
}
t1[243] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 4) }
t1[283] = {
    function() -- line: 192
        local Rumble = workspace.VFX.Rumble

        for _, descendant in pairs(Rumble:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = false
            end
        end
    end
}
t1[331] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2) }
t1[332] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Back), 35) }
t1[443] = {
    function() -- line: 209
        local Highfive = workspace.VFX.Highfive

        function check(p9) -- line: 212
            return p9 ~= nil and p9 ~= 0
        end

        for _, descendant in pairs(Highfive:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 227
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[556] = {
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 13),
    TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 5)
}
t1[557] = {
    function() -- line: 241
        local PumpkinPortal = workspace.PumpkinPortal

        function check(p10) -- line: 244
            return p10 ~= nil and p10 ~= 0
        end

        for _, descendant in pairs(PumpkinPortal:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 259
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 2)
}
t1[564] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 25) }
t1[842] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 5) }
t1[915] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 25) }
t1[961] = { TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 0) }
