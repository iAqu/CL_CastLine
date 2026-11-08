-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1[0] = {
    SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(60.7566, 55.578, -22.9851, -0.9307, -0.1829, 0.3168, -0, 0.866, 0.5, -0.3658, 0.4653, -0.806)),
    SetProperty("Workspace.CurrentCamera.AttachToPart", Head),
    SetProperty("Workspace.CurrentCamera.FieldOfView", 50),
    SetProperty("Lighting.DepthOfField.Enabled", true),
    SetProperty("Lighting.DepthOfField.FarIntensity", 0.74),
    SetProperty("Lighting.DepthOfField.InFocusRadius", 10),
    TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(26.35, Enum.EasingStyle.Linear), 5),
    SetProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", 0),
    TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 1),
    SetProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundColor3", Color3.new(0, 0, 0)),
    SetProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageColor3", Color3.new(0, 0, 0)),
    SetProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", 1),
    SetProperty("Lighting.Black+White.Enabled", false),
    SetProperty("Lighting.White+Black.Enabled", false),
    SetProperty("Lighting.OrangeWhite.Enabled", false),
    SetProperty("Lighting.OrangeBlack.Enabled", false),
    SetProperty("Lighting.Moon.Enabled", false),
    SetProperty("Lighting.Moon.Saturation", 0.4),
    TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Moon.Contrast", -0.1),
    TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Moon.TintColor", Color3.new(1, 0.690196, 0.905882)),
    TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
    SetProperty("Lighting.Moon.Brightness", 0.1),
    TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(37.43333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Gray.Enabled", false),
    SetProperty("Lighting.Gray.Saturation", -0.4),
    TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Gray.Contrast", 1),
    TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Gray.TintColor", Color3.new(1, 1, 1)),
    SetProperty("Lighting.Gray.Brightness", 0.1),
    TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(46.6, Enum.EasingStyle.Linear), 0),
    SetProperty("Workspace.VFX.PumpkinLight.Attachment.SurfaceLight.Brightness", 0),
    SetProperty("Lighting.Pumpkin.Enabled", false),
    SetProperty("Lighting.Pumpkin.Saturation", 0.1),
    TweenProperty("Lighting.Pumpkin.Saturation", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Pumpkin.Contrast", 0.1),
    TweenProperty("Lighting.Pumpkin.Contrast", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Pumpkin.TintColor", Color3.new(1, 0.596078, 0.458824)),
    TweenProperty("Lighting.Pumpkin.TintColor", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
    SetProperty("Lighting.Pumpkin.Brightness", 0.2),
    TweenProperty("Lighting.Pumpkin.Brightness", TweenInfo.new(48.88333333333333, Enum.EasingStyle.Linear), 0),
    SetProperty("Lighting.Blur.Enabled", true),
    SetProperty("Lighting.Blur.Size", 15),
    SetProperty("Workspace.Animatables.pumpkinbossagain.Pumpkin Monster Neon.Color", Color3.new(0.0901961, 0.0408195, 0.0212226)),
    SetProperty("Lighting.Atmosphere.Color", Color3.new(0.501961, 0.305882, 1)),
    SetProperty("Lighting.Atmosphere.Density", 0.5)
}
t1[26] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(1.0333333333333334, Enum.EasingStyle.Linear), 2) }
t1[58] = { TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundColor3", TweenInfo.new(0.45, Enum.EasingStyle.Linear), Color3.new(0.113788, 0.0602099, 0.00981705)) }
t1[85] = { TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundColor3", TweenInfo.new(11.033333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.529139, 0.0862745)) }
t1[224] = {
    function() -- line: 68
        local PumpkinPortal = workspace.Animatables.PumpkinPortal

        function check(p1) -- line: 71
            return p1 ~= nil and p1 ~= 0
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
                    task.delay(EmitDuration, function() -- line: 86
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[256] = {
    function() -- line: 95
        local Bats = workspace.VFX.Bats

        function check(p2) -- line: 98
            return p2 ~= nil and p2 ~= 0
        end

        for _, descendant in pairs(Bats:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 113
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[274] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(1, Enum.EasingStyle.Linear), 0.1) }
t1[334] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 0.1) }
t1[361] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.8) }
t1[362] = {
    function() -- line: 134
        local PumpkinPortal = workspace.Animatables.PumpkinPortal

        function check(p3) -- line: 137
            return p3 ~= nil and p3 ~= 0
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
                    task.delay(EmitDuration, function() -- line: 152
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 0.6)
}
t1[384] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), 0.2) }
t1[415] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(4.633333333333334, Enum.EasingStyle.Linear), 0.12626) }
t1[693] = {
    TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 60),
    TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.3)
}
t1[694] = {
    function() -- line: 175
        local PumpkinPortal = workspace.Animatables.PumpkinPortal

        function check(p4) -- line: 178
            return p4 ~= nil and p4 ~= 0
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
                    task.delay(EmitDuration, function() -- line: 193
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(1.6333333333333333, Enum.EasingStyle.Linear), 0.1)
}
t1[747] = { TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 0) }
t1[748] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 15) }
t1[780] = { TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1) }
t1[787] = {
    function() -- line: 215
        local PumpkinPortal = workspace.Animatables.PumpkinPortal

        function check(p5) -- line: 218
            return p5 ~= nil and p5 ~= 0
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
                    task.delay(EmitDuration, function() -- line: 233
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[792] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1) }
t1[817] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.6833333333333333, Enum.EasingStyle.Linear), 2) }
t1[917] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 8) }
t1[935] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2) }
t1[1020] = {
    TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50),
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 10)
}
t1[1021] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 4) }
t1[1047] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 6) }
t1[1070] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.7, Enum.EasingStyle.Linear), 2) }
t1[1103] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 15) }
t1[1106] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 0.5) }
t1[1112] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 12) }
t1[1120] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 0.51735) }
t1[1121] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 2) }
t1[1141] = {
    function() -- line: 295
        local Flip = workspace.VFX.Flip

        function check(p6) -- line: 298
            return p6 ~= nil and p6 ~= 0
        end

        for _, descendant in pairs(Flip:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 313
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1149] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 7) }
t1[1162] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 2) }
t1[1183] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0) }
t1[1184] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 6) }
t1[1186] = {
    function() -- line: 338
        local Leap = workspace.VFX.Leap

        function check(p7) -- line: 341
            return p7 ~= nil and p7 ~= 0
        end

        for _, descendant in pairs(Leap:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 356
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1195] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 0.00172) }
t1[1198] = {
    TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 60),
    TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2)
}
t1[1289] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50) }
t1[1311] = {
    function() -- line: 379
        local Hit = workspace.VFX.Hit

        function check(p8) -- line: 382
            return p8 ~= nil and p8 ~= 0
        end

        for _, descendant in pairs(Hit:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 397
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1335] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 14) }
t1[1336] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.6333333333333333, Enum.EasingStyle.Linear), 2) }
t1[1413] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 12) }
t1[1414] = {
    function() -- line: 418
        local PumpkinHit = workspace.VFX.PumpkinHit

        function check(p9) -- line: 421
            return p9 ~= nil and p9 ~= 0
        end

        for _, descendant in pairs(PumpkinHit:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 436
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    SetProperty("Lighting.OrangeWhite.Enabled", true)
}
t1[1416] = {
    SetProperty("Lighting.OrangeWhite.Enabled", false),
    SetProperty("Lighting.OrangeBlack.Enabled", true)
}
t1[1418] = { SetProperty("Lighting.OrangeBlack.Enabled", false) }
t1[1419] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2) }
t1[1476] = {
    function() -- line: 459
        local Fall = workspace.VFX.Fall

        function check(p10) -- line: 462
            return p10 ~= nil and p10 ~= 0
        end

        for _, descendant in pairs(Fall:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 477
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1598] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 10) }
t1[1769] = { SetProperty("Lighting.OrangeWhite.Enabled", true) }
t1[1770] = {
    function() -- line: 494
        local Kick1 = workspace.VFX.Kicks.Kick1

        function check(p11) -- line: 497
            return p11 ~= nil and p11 ~= 0
        end

        for _, descendant in pairs(Kick1:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 512
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1771] = { SetProperty("Lighting.OrangeWhite.Enabled", false) }
t1[1810] = {
    function() -- line: 525
        local Kick2 = workspace.VFX.Kicks.Kick2

        function check(p12) -- line: 528
            return p12 ~= nil and p12 ~= 0
        end

        for _, descendant in pairs(Kick2:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 543
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    SetProperty("Lighting.OrangeWhite.Enabled", true)
}
t1[1812] = { SetProperty("Lighting.OrangeWhite.Enabled", false) }
t1[1902] = {
    function() -- line: 557
        local Kick3 = workspace.VFX.Kicks.Kick3

        function check(p13) -- line: 560
            return p13 ~= nil and p13 ~= 0
        end

        for _, descendant in pairs(Kick3:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 575
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    SetProperty("Lighting.OrangeWhite.Enabled", true)
}
t1[1904] = {
    SetProperty("Lighting.OrangeWhite.Enabled", false),
    SetProperty("Lighting.OrangeBlack.Enabled", true)
}
t1[1906] = { SetProperty("Lighting.OrangeBlack.Enabled", false) }
t1[1983] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10) }
t1[1986] = {
    function() -- line: 598
        local Jump = workspace.VFX.Jump

        function check(p14) -- line: 601
            return p14 ~= nil and p14 ~= 0
        end

        for _, descendant in pairs(Jump:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 616
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[1990] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 2) }
t1[2126] = { SetProperty("Lighting.OrangeWhite.Enabled", true) }
t1[2127] = {
    function() -- line: 633
        local Kick4 = workspace.VFX.Kicks.Kick4

        function check(p15) -- line: 636
            return p15 ~= nil and p15 ~= 0
        end

        for _, descendant in pairs(Kick4:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 651
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[2128] = { SetProperty("Lighting.OrangeWhite.Enabled", false) }
t1[2185] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 80) }
t1[2193] = {
    function() -- line: 668
        local Kick5 = workspace.VFX.Kicks.Kick5

        local function check(p16) -- line: 671
            if typeof(p16) == "number" then
                return p16 > 0
            end

            return false
        end

        local function play(p17) -- line: 675
            local EmitCount = p17:GetAttribute("EmitCount")
            local EmitDuration = p17:GetAttribute("EmitDuration")

            if typeof(EmitCount) == "number" and EmitCount > 0 then
                p17:Emit(EmitCount)
            end

            if typeof(EmitDuration) == "number" and EmitDuration > 0 then
                p17.Enabled = true
                task.delay(EmitDuration, function() -- line: 685
                    -- upvalues: p17 (copy)
                    p17.Enabled = false
                end)
            end
        end

        for _, descendant in Kick5:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
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
t1[2208] = { SetProperty("Lighting.OrangeBlack.Enabled", true) }
t1[2210] = { SetProperty("Lighting.OrangeBlack.Enabled", false) }
t1[2211] = { SetProperty("Lighting.OrangeWhite.Enabled", true) }
t1[2213] = {
    TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageColor3", TweenInfo.new(0.8333333333333334, Enum.EasingStyle.Linear), Color3.new(0.377869, 1, 0.337255)),
    SetProperty("Lighting.OrangeWhite.Enabled", false),
    SetProperty("Lighting.OrangeBlack.Enabled", true)
}
t1[2215] = {
    SetProperty("Lighting.White+Black.Enabled", true),
    SetProperty("Lighting.OrangeBlack.Enabled", false)
}
t1[2217] = {
    SetProperty("Lighting.Black+White.Enabled", true),
    SetProperty("Lighting.White+Black.Enabled", false)
}
t1[2219] = { SetProperty("Lighting.Black+White.Enabled", false) }
t1[2222] = { SetProperty("Lighting.OrangeBlack.Enabled", true) }
t1[2224] = {
    SetProperty("Lighting.OrangeWhite.Enabled", true),
    SetProperty("Lighting.OrangeBlack.Enabled", false)
}
t1[2226] = { SetProperty("Lighting.OrangeWhite.Enabled", false) }
t1[2245] = {
    TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 50),
    TweenProperty("Lighting.Atmosphere.Density", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.27)
}
t1[2246] = {
    SetProperty("Lighting.Moon.Enabled", true),
    TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 0.4),
    TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), -0.1),
    TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), Color3.new(1, 0.690196, 0.905882)),
    TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 0.1)
}
t1[2253] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0) }
t1[2263] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0.75) }
t1[2329] = {
    TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 1),
    TweenProperty("Lighting.Moon.Saturation", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Moon.Contrast", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Moon.TintColor", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
    TweenProperty("Lighting.Moon.Brightness", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0)
}
t1[2333] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 1) }
t1[2335] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageColor3", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) }
t1[2345] = {
    SetProperty("Lighting.Moon.Enabled", false),
    TweenProperty("Lighting.Atmosphere.Density", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.5)
}
t1[2379] = {
    function() -- line: 793
        local Head = workspace.VFX.Head

        function check(p18) -- line: 796
            return p18 ~= nil and p18 ~= 0
        end

        for _, descendant in pairs(Head:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 811
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end,
    SetProperty("Lighting.OrangeBlack.Enabled", true)
}
t1[2381] = { SetProperty("Lighting.OrangeBlack.Enabled", false) }
t1[2384] = { TweenProperty("Workspace.Animatables.pumpkinbossagain.Pumpkin Monster Neon.Color", TweenInfo.new(0.2, Enum.EasingStyle.Linear), Color3.new(0.760784, 0.345098, 0.180392)) }
t1[2501] = {
    function() -- line: 829
        local Rumble = workspace.VFX.Rumble

        for _, descendant in pairs(Rumble:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = true
            end
        end
    end
}
t1[2534] = {
    function() -- line: 838
        local Slam1 = workspace.VFX.Slam1

        function check(p19) -- line: 841
            return p19 ~= nil and p19 ~= 0
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
                    task.delay(EmitDuration, function() -- line: 856
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[2547] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 10) }
t1[2572] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 6) }
t1[2573] = {
    function() -- line: 873
        local Slam2 = workspace.VFX.Slam2

        function check(p20) -- line: 876
            return p20 ~= nil and p20 ~= 0
        end

        for _, descendant in pairs(Slam2:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local EmitCount = descendant:GetAttribute("EmitCount")
                local EmitDuration = descendant:GetAttribute("EmitDuration")

                if check(EmitCount) then
                    descendant:Emit(EmitCount)
                end

                if check(EmitDuration) then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 891
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end
        end
    end
}
t1[2595] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 8) }
t1[2621] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 3) }
t1[2650] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 7) }
t1[2677] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 2) }
t1[2703] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Linear), 20) }
t1[2729] = {
    function() -- line: 920
        local Rumble = workspace.VFX.Rumble

        for _, descendant in pairs(Rumble:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = false
            end
        end
    end
}
t1[2779] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 0.2) }
t1[2785] = {
    function() -- line: 933
        local Roar = workspace.VFX.Roar

        for _, descendant in pairs(Roar:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = true
            end
        end
    end
}
t1[2790] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(2.3666666666666667, Enum.EasingStyle.Linear), 0.2) }
t1[2796] = {
    SetProperty("Lighting.Gray.Enabled", true),
    TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), -0.4),
    TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
    TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.1)
}
t1[2813] = {
    TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 0)
}
t1[2832] = {
    TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), -0.4),
    TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
    TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.1)
}
t1[2865] = {
    TweenProperty("Lighting.Gray.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gray.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gray.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0)
}
t1[2882] = { SetProperty("Lighting.Gray.Enabled", false) }
t1[2889] = {
    function() -- line: 975
        local Roar = workspace.VFX.Roar

        for _, descendant in pairs(Roar:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = false
            end
        end
    end
}
t1[2932] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 10) }
t1[2933] = {
    TweenProperty("Workspace.VFX.PumpkinLight.Attachment.SurfaceLight.Brightness", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 2),
    SetProperty("Lighting.Pumpkin.Enabled", true),
    TweenProperty("Lighting.Pumpkin.Saturation", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.1),
    TweenProperty("Lighting.Pumpkin.Contrast", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.1),
    TweenProperty("Lighting.Pumpkin.TintColor", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), Color3.new(1, 0.596078, 0.458824)),
    TweenProperty("Lighting.Pumpkin.Brightness", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.2)
}
t1[2936] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 0) }
