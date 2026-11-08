-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local IntroCutscene1 = ReplicatedStorage.CutsceneAssets.ScrambleBossCutsceneAssets.IntroCutscene1
local t1 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t2, v2, t3
local t4 = {}

local function restoreCamera() -- line: 47
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 57
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    if t2 ~= nil then
        return
    end

    local t5 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t5[child] = true
            child.Enabled = false
        end
    end

    t2 = t5

    local function v3() -- line: 72
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t6 = {}

    for _, v4 in t1 do
        t6[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t3 = t6
end

local function restoreAllUi() -- line: 82
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    local t7 = t2
    local v5 = v2

    t2 = nil
    v2 = nil

    if t7 ~= nil then
        for v6 in t7 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 95
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t8 = t3

    t3 = nil

    if t8 ~= nil then
        for v8, v9 in t8 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 107
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 114
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

local function setTransparency(p1, p2) -- line: 126
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 139
    -- upvalues: t4 (copy)
    t4[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 148
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

        p5:Add(function() -- line: 162
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

local function restoreAllGuardsAndNests() -- line: 171
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

local function setEmitting(p6, p7) -- line: 183
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p7
        end
    end
end

local function emitBurst(p8) -- line: 191
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")

            if type(EmitCount) == "number" and EmitCount ~= 0 then
                descendant:Emit(EmitCount)
            end

            if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                descendant.Enabled = true
                task.delay(EmitDuration, function() -- line: 204
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false
                end)
            end
        end
    end
end

return function(p9) -- line: 213
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), IntroCutscene1 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy), setEmitting (copy), emitBurst (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p9)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(-5252.8594, -234.99, 2545.4341, 0.791, 0.1643, -0.5893, -0, 0.9633, 0.2685, 0.6118, -0.2124, 0.762)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 30),
            function() -- line: 229
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.MainPortal, false)
            end,
            SetProperty("Lighting.DepthOfField.Enabled", true),
            SetProperty("Lighting.DepthOfField.InFocusRadius", 10),
            SetProperty("Lighting.DepthOfField.FocusDistance", 5),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 10),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 2),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(14.633333333333333, Enum.EasingStyle.Linear), Color3.new(0.596974, 1, 0.384314)),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("Lighting.CrazyBrock.Enabled", false),
            SetProperty("Lighting.CrazyBrock.Saturation", -0.5),
            TweenProperty("Lighting.CrazyBrock.Saturation", TweenInfo.new(10.583333333333334, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.CrazyBrock.Contrast", 0.7),
            TweenProperty("Lighting.CrazyBrock.Contrast", TweenInfo.new(10.583333333333334, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.CrazyBrock.TintColor", Color3.new(0.698039, 1, 0.643137)),
            TweenProperty("Lighting.CrazyBrock.TintColor", TweenInfo.new(10.583333333333334, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            SetProperty("Lighting.CrazyBrock.Brightness", -0.1),
            TweenProperty("Lighting.CrazyBrock.Brightness", TweenInfo.new(10.583333333333334, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.WhiteGreen.Enabled", false),
            SetProperty("Lighting.BlackGreen.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", TweenInfo.new(14.433333333333334, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", TweenInfo.new(14.433333333333334, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", TweenInfo.new(14.433333333333334, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.Enabled", false)
        },
        [87] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 15) },
        [89] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 5) },
        [114] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 15) },
        [115] = {
            function() -- line: 278
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Smoke)
            end
        },
        [118] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 2) },
        [263] = { TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 0) },
        [265] = { TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(15.7, Enum.EasingStyle.Linear), 5) },
        [298] = {
            function() -- line: 296
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.ClawPortal1, true)
            end
        },
        [381] = {
            function() -- line: 302
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.ClawPortal2, true)
            end
        },
        [397] = {
            function() -- line: 308
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.ClawPortal3, true)
            end
        },
        [501] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 10) },
        [538] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.5666666666666667, Enum.EasingStyle.Linear), 7) },
        [632] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), 4) },
        [635] = {
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.CrazyBrock.Enabled", true),
            TweenProperty("Lighting.CrazyBrock.Saturation", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), -0.5),
            TweenProperty("Lighting.CrazyBrock.Contrast", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), 0.7),
            TweenProperty("Lighting.CrazyBrock.TintColor", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), Color3.new(0.698039, 1, 0.643137)),
            TweenProperty("Lighting.CrazyBrock.Brightness", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), -0.1)
        },
        [726] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 10) },
        [738] = {
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 5),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 1),
            TweenProperty("Lighting.CrazyBrock.Saturation", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.CrazyBrock.Contrast", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.CrazyBrock.TintColor", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            TweenProperty("Lighting.CrazyBrock.Brightness", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 0)
        },
        [754] = {
            function() -- line: 348
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.ClawPortal1, false)
                setEmitting(clone.ClawPortal2, false)
                setEmitting(clone.ClawPortal3, false)
                setEmitting(clone.MainPortal, true)
            end
        },
        [814] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 0) },
        [859] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 25) },
        [866] = {
            SetProperty("Lighting.BlackGreen.Enabled", true),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.Enabled", true),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.Enabled", true),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.Enabled", true)
        },
        [867] = {
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902))
        },
        [868] = {
            SetProperty("Lighting.WhiteGreen.Enabled", true),
            SetProperty("Lighting.BlackGreen.Enabled", false)
        },
        [869] = {
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
        },
        [870] = {
            SetProperty("Lighting.WhiteGreen.Enabled", false),
            SetProperty("Lighting.BlackGreen.Enabled", true)
        },
        [871] = {
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.392157, 1, 0.254902))
        },
        [872] = {
            SetProperty("Lighting.WhiteGreen.Enabled", true),
            SetProperty("Lighting.BlackGreen.Enabled", false)
        },
        [873] = {
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)),
            TweenProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.FillColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
        },
        [874] = {
            SetProperty("Lighting.WhiteGreen.Enabled", false),
            SetProperty("Lighting.BlackGreen.Enabled", true)
        },
        [876] = {
            SetProperty("Lighting.BlackGreen.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BenRigWithHandles.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.HatRig.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossIntro1Rigs.BrockkodileHeadRig.Highlight.Enabled", false)
        },
        [877] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0) },
        [880] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 5) },
        [881] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 1) },
        [893] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) },
        [934] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 0) },
        [1207] = { TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(0.35, Enum.EasingStyle.Linear), 20) }
    }

    return {
        Run = function() -- Run | line: 448
            -- upvalues: p9 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), Tabs (copy), IntroCutscene1 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p9:Add(function() -- line: 453
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v18 then
                    return
                end

                local v19 = restoreAllUi()
                local v20 = v1

                v1 = nil

                if v20 ~= nil then
                    v20()
                end

                if v19 ~= nil then
                    Tabs.Activate(v19, {
                        instant = true
                    })
                end

                v18 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v21() -- line: 461
                -- upvalues: AreaEggSlotsClient (copy), p9 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p9:Add(function() -- line: 463
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
            hideAllGuardsAndNests(p9)

            local t11 = {}

            for _, child in IntroCutscene1.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p9:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p9:Add(function() -- line: 487
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = IntroCutscene1.ScrambleBossIntro1VFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p9:Add(clone2)

            local clone3 = IntroCutscene1.ScrambleBossIntro1WorkspaceAssets:Clone()

            clone3.Parent = Workspace
            p9:Add(clone3)

            local clone4 = IntroCutscene1.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            p9:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p9:Add(function() -- line: 507
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone5 = IntroCutscene1.ScrambleBossIntro1Rigs:Clone()

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace
            p9:Add(clone5)

            local t12 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v22 = true

            p9:Add(function() -- line: 543
                -- upvalues: v22 (ref)
                v22 = false
            end)
            p9:Add(function() -- line: 544
                -- upvalues: v22 (ref), restoreCamera (copy)
                if v22 then
                    restoreCamera()
                end
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone5.HumanoidCameraRig]

            assert(v24, "HumanoidCameraRig needs an Animation")

            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local Torso = clone5.HumanoidCameraRig.Torso
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 570
                -- upvalues: v22 (ref), Torso (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v22 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Torso
                CurrentCamera.Focus = Torso.CFrame
                CurrentCamera.CFrame = Torso.CFrame
            end)

            local t14 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p10) -- line: 584
                -- upvalues: clone4 (copy), t13 (copy), t14 (copy), n1 (ref), n2 (ref), t9 (copy)
                n1 += p10
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v26 in t13 do
                        if v26.IsPlaying then
                            local v28 = n1

                            if math.abs(v28 - v26.TimePosition) >= 0.4 then
                                local function v29() -- line: 596
                                    -- upvalues: v26 (copy), n1 (ref)
                                    v26.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v29, _warn)
                            end
                        end
                    end
                end

                if clone4.TimePosition < n1 - 0.001 then
                    clone4.PlaybackSpeed = 1.01
                elseif clone4.TimePosition > n1 + 0.001 then
                    clone4.PlaybackSpeed = 0.99
                else
                    clone4.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v31 = math.floor(n1 * 60 - i)

                    if t9[v31] and not t14[v31] then
                        t14[v31] = true

                        for _, v32 in t9[v31] do
                            task.spawn(v32)
                        end
                    end
                end
            end)

            p9:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(16.966666666666665)
            connection2:Disconnect()

            local function v33() -- line: 628
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v33, _warn2)

            local function v34() -- line: 629
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn3 = warn

            xpcall(v34, _warn3)

            local function v35() -- line: 630
                -- upvalues: clone4 (copy)
                clone4:Destroy()
            end

            local _warn4 = warn

            xpcall(v35, _warn4)
            v22 = false
            Vignette.Visible = false

            local function v36() -- line: 636
                -- upvalues: t11 (copy)
                for _, v37 in t11 do
                    v37:Destroy()
                end
            end

            local _warn5 = warn

            xpcall(v36, _warn5)

            local function v38() -- line: 642
                -- upvalues: clone5 (copy)
                clone5:Destroy()
            end

            local _warn6 = warn

            xpcall(v38, _warn6)

            local _warn7 = warn

            xpcall(restoreCamera, _warn7)
            task.wait(0.5)
            Vignette.Visible = false

            local function v39() -- line: 651
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v39)

            local function v40() -- line: 655
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v41 = restoreAllUi()
                local v42 = v1

                v1 = nil

                if v42 ~= nil then
                    v42()
                end

                if v41 ~= nil then
                    Tabs.Activate(v41, {
                        instant = true
                    })
                end

                v18 = true
            end

            local _warn8 = warn

            xpcall(v40, _warn8)
            restoreAllGuardsAndNests()
        end
    }
end
