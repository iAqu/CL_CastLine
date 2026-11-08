-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1[0] = {
    SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(3748.5474, 85.5723, -360.1614, -0.0513, -0.9347, 0.3516, 0, 0.3521, 0.936, -0.9987, 0.048, -0.0181)),
    SetProperty("Workspace.CurrentCamera.AttachToPart", Cam),
    SetProperty("Workspace.CurrentCamera.FieldOfView", 35),
    function() -- line: 8
        local Decor = workspace.EnvelopeRig.GoldenEnvelope.Decor

        for _, descendant in pairs(Decor:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = true
            end
        end
    end,
    SetProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageColor3", Color3.new(1, 0.588978, 0.25098)),
    SetProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", 1),
    SetProperty("Lighting.Gold.TintColor", Color3.new(1, 1, 1)),
    SetProperty("Lighting.Gold.Brightness", 0),
    SetProperty("Lighting.Gold.Saturation", 0),
    SetProperty("Lighting.Gold.Contrast", 0),
    SetProperty("Lighting.DepthOfField.Enabled", true),
    SetProperty("Lighting.DepthOfField.FarIntensity", 0.09),
    SetProperty("Lighting.Blur.Enabled", true),
    SetProperty("Lighting.Blur.Size", 15),
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 2),
    SetProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", 0),
    TweenProperty("CoreGui.MoonAnimatorEffects.Screen Cover.BackgroundTransparency", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1)
}
t1[180] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 15) }
t1[197] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(1, Enum.EasingStyle.Linear), 4) }
t1[240] = {
    TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gold.TintColor", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.784314, 0.415686)),
    TweenProperty("Lighting.Gold.Brightness", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.3),
    TweenProperty("Lighting.Gold.Saturation", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.5),
    TweenProperty("Lighting.Gold.Contrast", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0.7)
}
t1[307] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 10) }
t1[322] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 4) }
t1[390] = {
    TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 1),
    TweenProperty("Lighting.Gold.TintColor", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
    TweenProperty("Lighting.Gold.Brightness", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gold.Saturation", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0),
    TweenProperty("Lighting.Gold.Contrast", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 0)
}
t1[402] = {
    function() -- line: 62
        local Decor = workspace.EnvelopeRig.GoldenEnvelope.Decor

        for _, descendant in pairs(Decor:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = false
            end
        end
    end
}
t1[421] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 10) }
t1[424] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.5) }
t1[425] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 2) }
t1[645] = {
    TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 32),
    TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 100),
    TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 7)
}
t1[646] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 4) }
t1[769] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 0) }
t1[796] = { TweenProperty("CoreGui.MoonAnimatorEffects.Vignette.ImageTransparency", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 1) }
t1[1147] = { TweenProperty("Lighting.Blur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 10) }
