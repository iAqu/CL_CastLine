-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")

game:GetService("Debris")

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

require(ReplicatedStorage.Client.Modules.BulkFade)

local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local SammyEventIntroRigs, SammyEventIntroVFX = ReplicatedStorage.CutsceneAssets.SammyEvent.SammyEventIntroRigs, ReplicatedStorage.CutsceneAssets.SammyEvent.SammyEventIntroVFX
local v1, t1, v2, t2
local t3 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local t4 = {}

local function restoreCamera() -- line: 49
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 59
    -- upvalues: StarterGui (copy), Tabs (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref), t3 (copy)
    if t1 ~= nil then
        return
    end

    local t5 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "UI_NAME" and child.Enabled then
            t5[child] = true
            child.Enabled = false
        end
    end

    t1 = t5

    local function v3() -- line: 74
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t6 = {}

    for _, v4 in t3 do
        t6[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t2 = t6
end

local function restoreAllUi() -- line: 84
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref)
    local t7 = t1
    local v5 = v2

    t1 = nil
    v2 = nil

    if t7 ~= nil then
        for v6 in t7 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 97
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t8 = t2

    t2 = nil

    if t8 ~= nil then
        for v8, v9 in t8 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 109
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 116
    -- upvalues: Tabs (copy), v1 (ref), restoreAllUi (copy)
    local v10 = restoreAllUi()
    local v11 = v1

    v1 = nil

    if v11 ~= nil then
        v11()
    end

    if v10 ~= nil then
        Tabs.Activate(v10, {
            instant = true
        })
    end
end

local function setTransparency(p1, p2) -- line: 128
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 141
    -- upvalues: t4 (copy)
    t4[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 150
    -- upvalues: t4 (copy), setTransparency (copy)
    for _, child in (game.Workspace.World.Areas.GuardAreas:GetChildren()) do
        local Guard = child.Guard

        t4[Guard] = child
        Guard.Parent = nil

        local Nests = child:FindFirstChild("Nests")
        local v13 = Nests and Nests:GetDescendants()

        if v13 then
            setTransparency(v13, 1)
        end

        p5:Add(function() -- line: 164
            -- upvalues: child (copy), Guard (copy), Nests (copy), v13 (copy), t4 (copy), setTransparency (copy)
            t4[Guard] = nil

            local Guard2 = child:FindFirstChild("Guard")

            if Guard2 == nil or Guard2 == Guard then
                Guard.Parent = child
            end

            if Nests then
                setTransparency(v13)
            end
        end)
    end
end

local function restoreAllGuardsAndNests() -- line: 173
    -- upvalues: t4 (copy), setTransparency (copy)
    for v14, v15 in t4 do
        t4[v14] = nil

        local Guard = v15:FindFirstChild("Guard")

        if Guard == nil or Guard == v14 then
            v14.Parent = v15
        end

        local Nests = v15:FindFirstChild("Nests")
        local v16 = Nests and Nests:GetDescendants()

        if v16 then
            setTransparency(v16)
        end
    end
end

return function(p6) -- line: 187
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), SammyEventIntroRigs (copy), SammyEventIntroVFX (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p6)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.PlaySequenceAsync, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone, clone2, v18
    local t9 = {}

    t9[0] = {
        SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.75, Enum.EasingStyle.Linear), 35),
        SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(3796.665, 86.7965, -386.4179, -0.9931, 0.0378, -0.1106, -0, 0.9463, 0.3233, 0.1169, 0.3211, -0.9398)),
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(8.516666666666667, Enum.EasingStyle.Linear), CFrame.new(3753.5005, 75.0279, -354.4407, 0.0198, -0.0393, -0.999, 0.0055, 0.9992, -0.0392, 0.9998, -0.0047, 0.02)),
        function() -- line: 209
            -- upvalues: clone (ref), clone2 (ref)
            local Glitch = clone2.Sammy.HypnoFace.Glitch

            for _, descendant in pairs(Glitch:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end

            local Hearts = clone.Hearts

            for _, descendant in pairs(Hearts:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end,
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.9833333333333333, Enum.EasingStyle.Linear), 1),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
        SetProperty("Lighting.Close.Enabled", false),
        SetProperty("Lighting.Far.Enabled", true),
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(0, 0, 0)),
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(9.683333333333334, Enum.EasingStyle.Linear), Color3.new(0.36618, 1, 0.258824)),
        SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
        SetProperty("Lighting.Glitch.TintColor", Color3.new(1, 1, 1)),
        SetProperty("Lighting.Glitch.Brightness", 0),
        SetProperty("Lighting.Glitch.Saturation", 0),
        SetProperty("Lighting.Glitch.Contrast", 0),
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 2),
        SetProperty("Workspace.SammyEventIntroVFX.Hearts.CFrame", CFrame.new(3808.9578, 71.9718, -354.5645, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
        TweenProperty("Workspace.SammyEventIntroVFX.Hearts.CFrame", TweenInfo.new(0.7666666666666667, Enum.EasingStyle.Linear), CFrame.new(3804.4009, 71.9718, -354.5645, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
        SetProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.Color", Color3.new(0.180392, 0.388235, 0.168627)),
        TweenProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.Color", TweenInfo.new(9.85, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
        SetProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.Transparency", 1),
        SetProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.CFrame", CFrame.new(3750.9365, 76.2239, -354.1235, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    }
    t9[18] = {
        function() -- line: 243
            -- upvalues: clone (ref)
            local Aura = clone.Aura

            for _, descendant in pairs(Aura:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[46] = { TweenProperty("Workspace.SammyEventIntroVFX.Hearts.CFrame", TweenInfo.new(2.2333333333333334, Enum.EasingStyle.Linear), CFrame.new(3790.2185, 71.9718, -354.5645, 1, 0, 0, 0, 1, 0, 0, 0, 1)) }
    t9[180] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 45),
        TweenProperty("Workspace.SammyEventIntroVFX.Hearts.CFrame", TweenInfo.new(1.5, Enum.EasingStyle.Linear), CFrame.new(3780.9097, 71.9718, -354.5645, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    }
    t9[181] = {
        SetProperty("Lighting.Close.Enabled", true),
        SetProperty("Lighting.Far.Enabled", false)
    }
    t9[271] = {
        SetProperty("Lighting.Close.Enabled", false),
        SetProperty("Lighting.Far.Enabled", true)
    }
    t9[273] = {
        function() -- line: 271
            local Hearts = workspace.SammyEventIntroVFX.Hearts

            for _, descendant in pairs(Hearts:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[361] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.6, Enum.EasingStyle.Sine), 50) }
    t9[397] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.8833333333333333, Enum.EasingStyle.Sine), 55) }
    t9[433] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4, Enum.EasingStyle.Linear), 15) }
    t9[457] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 4) }
    t9[510] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 47.5) }
    t9[511] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 45),
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(12.483333333333333, Enum.EasingStyle.Linear), CFrame.new(3771.3481, 69.0059, -377.0066, -0.1228, -0.0156, -0.9923, -0.0066, 0.9999, -0.0149, 0.9924, 0.0047, -0.1228))
    }
    t9[543] = {
        function() -- line: 305
            -- upvalues: clone (ref)
            local Exclaim = clone.Exclaim

            local function check(p7) -- line: 308
                return p7 ~= nil and p7 ~= 0
            end

            for _, descendant in pairs(Exclaim:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")

                    if EmitCount ~= nil and EmitCount ~= 0 then
                        descendant:Emit(EmitCount)
                    end

                    if EmitDuration ~= nil and EmitDuration ~= 0 then
                        descendant.Enabled = true
                        task.delay(EmitDuration, function() -- line: 323
                            -- upvalues: descendant (copy)
                            descendant.Enabled = false
                        end)
                    end
                end
            end
        end
    }
    t9[579] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) }
    t9[581] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.9666666666666667, Enum.EasingStyle.Linear), 0) }
    t9[587] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.9833333333333333, Enum.EasingStyle.Linear), 4) }
    t9[591] = {
        TweenProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.Color", TweenInfo.new(1.15, Enum.EasingStyle.Linear), Color3.new(0.180392, 0.388235, 0.168627)),
        TweenProperty("Workspace.SammyEventIntroVFX.Dome.BlackDome.Transparency", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 0)
    }
    t9[606] = {
        function() -- line: 349
            -- upvalues: clone (ref)
            local BlackDome = clone.Dome.BlackDome

            for _, descendant in pairs(BlackDome:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[657] = {
        function() -- line: 358
            -- upvalues: clone2 (ref)
            local Glitch = clone2.Sammy.HypnoFace.Glitch

            for _, descendant in pairs(Glitch:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[661] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(2.316666666666667, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 95),
        function() -- line: 368
            -- upvalues: clone2 (ref), v18 (ref)
            v18 = clone2.Sammy.SammyFacecam.SamCam
        end,
        TweenProperty("Lighting.Glitch.Saturation", TweenInfo.new(0.6, Enum.EasingStyle.Linear), -2)
    }
    t9[697] = { TweenProperty("Lighting.Glitch.Contrast", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), -2) }
    t9[734] = { TweenProperty("Lighting.Glitch.Saturation", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 2) }
    t9[756] = {
        TweenProperty("Lighting.Glitch.Saturation", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), -3),
        TweenProperty("Lighting.Glitch.Contrast", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), 0)
    }
    t9[769] = { TweenProperty("Lighting.Glitch.TintColor", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), Color3.new(0.421552, 1, 0.34902)) }
    t9[795] = {
        function() -- line: 392
            -- upvalues: clone2 (ref)
            local Glitch = clone2.Sammy.HypnoFace.Glitch

            for _, descendant in pairs(Glitch:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[800] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 70),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.0884083, 0.133333, 0.0522876)),
        TweenProperty("Lighting.Glitch.TintColor", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
        TweenProperty("Lighting.Glitch.Saturation", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), -1.1)
    }
    t9[801] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 68.85742),
        function() -- line: 410
            -- upvalues: clone2 (ref), v18 (ref)
            v18 = clone2["Camera Rig"].Cam
        end
    }
    t9[806] = {
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.8666666666666667, Enum.EasingStyle.Linear), 1),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(6.883333333333334, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
    }
    t9[822] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 63.71582) }
    t9[834] = { TweenProperty("Lighting.Glitch.Saturation", TweenInfo.new(0.7, Enum.EasingStyle.Linear), 0) }
    t9[835] = {
        TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), 7.5)
    }
    t9[867] = {
        function() -- line: 434
            -- upvalues: clone (ref)
            local BlackDome = clone.Dome.BlackDome

            for _, descendant in pairs(BlackDome:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[995] = {
        function() -- line: 443
            -- upvalues: clone (ref)
            local Aura = clone.Aura

            for _, descendant in pairs(Aura:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[1013] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 25) }
    t9[1014] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(4.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 22.80357) }
    t9[1098] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.5833333333333333, Enum.EasingStyle.Linear), 4) }
    t9[1219] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.6833333333333333, Enum.EasingStyle.Linear), 0) }

    return {
        Run = function() -- Run | line: 469
            -- upvalues: p6 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), clone2 (ref), v18 (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), SammyEventIntroRigs (copy), SammyEventIntroVFX (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy)
            local v19 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p6:Add(function() -- line: 474
                -- upvalues: v19 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v19 then
                    return
                end

                local v20 = restoreAllUi()
                local v21 = v1

                v1 = nil

                if v21 ~= nil then
                    v21()
                end

                if v20 ~= nil then
                    Tabs.Activate(v20, {
                        instant = true
                    })
                end

                v19 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v22() -- line: 482
                -- upvalues: AreaEggSlotsClient (copy), p6 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p6:Add(function() -- line: 484
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v22)
            hideAllGuardsAndNests(p6)

            local t11 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p6:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p6:Add(function() -- line: 508
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone3 = SammyEventIntroVFX:Clone()

            clone3.Parent = Workspace
            clone = clone3
            p6:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p6:Add(function() -- line: 519
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)
            clone2 = SammyEventIntroRigs:Clone()

            for _, child in clone2:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            local clone4 = clone2

            clone4.Parent = workspace

            local clone5 = clone2

            p6:Add(clone5)

            local t12 = {}

            for _, child in clone2:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone2:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            for _, child in clone:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v23 = true

            p6:Add(function() -- line: 563
                -- upvalues: v23 (ref)
                v23 = false
            end)
            p6:Add(function() -- line: 564
                -- upvalues: v23 (ref), restoreCamera (copy)
                if v23 then
                    restoreCamera()
                end
            end)

            for _, v24 in t13 do
                v24:Play(0)
            end

            local v25 = t13[clone2["Camera Rig"]]

            assert(v25, "Camera Rig needs an Animation")

            local v26 = os.clock() + 2

            while v23 and v25.TimePosition <= 0 and os.clock() < v26 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()
            v18 = clone2["Camera Rig"].Cam

            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 591
                -- upvalues: v23 (ref), connection (ref), v18 (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v23 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = v18
                CurrentCamera.Focus = v18.CFrame
                CurrentCamera.CFrame = v18.CFrame
            end)

            local t14 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p8) -- line: 605
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t9 (copy)
                n1 += p8
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v27 in t13 do
                        if v27.IsPlaying then
                            local v29 = n1

                            if math.abs(v29 - v27.TimePosition) >= 0.1 then
                                local function v30() -- line: 617
                                    -- upvalues: v27 (copy), n1 (ref)
                                    v27.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v30, _warn)
                            end
                        end
                    end
                end

                if CutsceneMusic.TimePosition < n1 - 0.001 then
                    CutsceneMusic.PlaybackSpeed = 1.01
                elseif CutsceneMusic.TimePosition > n1 + 0.001 then
                    CutsceneMusic.PlaybackSpeed = 0.99
                else
                    CutsceneMusic.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v32 = math.floor(n1 * 60 - i)

                    if t9[v32] and not t14[v32] then
                        t14[v32] = true

                        for _, v33 in t9[v32] do
                            task.spawn(v33)
                        end
                    end
                end
            end)

            p6:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(21.516666666666666)
            connection2:Disconnect()

            local function v34() -- line: 649
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn2 = warn

            xpcall(v34, _warn2)
            v23 = false
            Vignette.Visible = false

            local function v35() -- line: 655
                -- upvalues: t11 (copy)
                for _, v36 in t11 do
                    v36:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v35, _warn3)

            local function v37() -- line: 661
                -- upvalues: clone2 (ref)
                clone2:Destroy()
            end

            local _warn4 = warn

            xpcall(v37, _warn4)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v38() -- line: 672
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v38)

            local function v39() -- line: 676
                -- upvalues: v19 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v40 = restoreAllUi()
                local v41 = v1

                v1 = nil

                if v41 ~= nil then
                    v41()
                end

                if v40 ~= nil then
                    Tabs.Activate(v40, {
                        instant = true
                    })
                end

                v19 = true
            end

            local _warn6 = warn

            xpcall(v39, _warn6)
        end
    }
end
