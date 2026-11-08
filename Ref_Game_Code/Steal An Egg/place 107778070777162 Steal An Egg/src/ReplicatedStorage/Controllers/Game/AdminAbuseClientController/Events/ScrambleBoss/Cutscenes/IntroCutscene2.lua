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

local IntroCutscene2 = ReplicatedStorage.CutsceneAssets.ScrambleBossCutsceneAssets.IntroCutscene2
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

local function restoreCamera() -- line: 48
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 58
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

    local function v3() -- line: 73
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

local function restoreAllUi() -- line: 83
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

    local function v7() -- line: 96
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

local function hideCutsceneUi() -- line: 108
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 115
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

local function setTransparency(p1, p2) -- line: 127
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 140
    -- upvalues: t4 (copy)
    t4[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 149
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

        p5:Add(function() -- line: 163
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

local function restoreAllGuardsAndNests() -- line: 172
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

return function(p6) -- line: 186
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), IntroCutscene2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p6)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(106.2726, 5.5588, 56.7516, 0.2516, -0.278, 0.927, -0, 0.9579, 0.2872, -0.9678, -0.0723, 0.241)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 61.55506),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 1),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 2),
            SetProperty("Lighting.DepthOfField.Enabled", true),
            SetProperty("Lighting.DepthOfField.FarIntensity", 1),
            SetProperty("Lighting.DepthOfField.FocusDistance", 0.05),
            SetProperty("Lighting.DepthOfField.InFocusRadius", 8),
            SetProperty("Lighting.DepthOfField.NearIntensity", 0)
        },
        [61] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)) },
        [67] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 15) },
        [69] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 0) },
        [77] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.35, Enum.EasingStyle.Linear), 0) },
        [86] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.5, Enum.EasingStyle.Linear), 1) },
        [98] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 1) },
        [109] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 7) },
        [138] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(6.016666666666667, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) },
        [178] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.4833333333333334, Enum.EasingStyle.Linear), 0) },
        [193] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5833333333333334, Enum.EasingStyle.Linear), 12) },
        [268] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.9833333333333333, Enum.EasingStyle.Linear), 4) },
        [425] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.5, Enum.EasingStyle.Linear), 1) },
        [453] = {
            TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 28),
            TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 9.5),
            TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 0.05)
        },
        [503] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 20) },
        [508] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 279
            -- upvalues: p6 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), Tabs (copy), IntroCutscene2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p6:Add(function() -- line: 284
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

            local function v21() -- line: 292
                -- upvalues: AreaEggSlotsClient (copy), p6 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p6:Add(function() -- line: 294
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
            hideAllGuardsAndNests(p6)

            local t11 = {}

            for _, child in IntroCutscene2.LightingAssets:GetChildren() do
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
            p6:Add(function() -- line: 318
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone = IntroCutscene2.ScrambleBossIntro2VFX:Clone()

            clone.Parent = Workspace
            p6:Add(clone)

            local clone2 = IntroCutscene2.ScrambleBossIntro2WorkspaceAssets:Clone()

            clone2.Parent = Workspace
            p6:Add(clone2)

            local clone3 = IntroCutscene2.CutsceneMusic:Clone()

            clone3.Parent = SoundService
            p6:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p6:Add(function() -- line: 336
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone4 = IntroCutscene2.ScrambleBossIntro2Rigs:Clone()

            for _, child in clone4:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone4.Parent = Workspace
            p6:Add(clone4)

            local t12 = {}

            for _, child in clone4:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone4:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v22 = true

            p6:Add(function() -- line: 372
                -- upvalues: v22 (ref)
                v22 = false
            end)
            p6:Add(function() -- line: 373
                -- upvalues: v22 (ref), restoreCamera (copy)
                if v22 then
                    restoreCamera()
                end
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone4.HumanoidCameraRig]

            assert(v24, "HumanoidCameraRig needs an Animation")

            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            clone3:Play()

            local Torso = clone4.HumanoidCameraRig.Torso
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 399
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
            local connection2 = RunService.Heartbeat:Connect(function(p7) -- line: 413
                -- upvalues: clone3 (copy), t13 (copy), t14 (copy), n1 (ref), n2 (ref), t9 (copy)
                n1 += p7
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v26 in t13 do
                        if v26.IsPlaying then
                            local v28 = n1

                            if math.abs(v28 - v26.TimePosition) >= 0.4 then
                                local function v29() -- line: 425
                                    -- upvalues: v26 (copy), n1 (ref)
                                    v26.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v29, _warn)
                            end
                        end
                    end
                end

                if clone3.TimePosition < n1 - 0.001 then
                    clone3.PlaybackSpeed = 1.01
                elseif clone3.TimePosition > n1 + 0.001 then
                    clone3.PlaybackSpeed = 0.99
                else
                    clone3.PlaybackSpeed = 1
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

            p6:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(9.366666666666667)
            connection2:Disconnect()

            local function v33() -- line: 457
                -- upvalues: clone (copy)
                clone:Destroy()
            end

            local _warn2 = warn

            xpcall(v33, _warn2)

            local function v34() -- line: 458
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn3 = warn

            xpcall(v34, _warn3)

            local function v35() -- line: 459
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn4 = warn

            xpcall(v35, _warn4)
            v22 = false
            Vignette.Visible = false

            local function v36() -- line: 465
                -- upvalues: t11 (copy)
                for _, v37 in t11 do
                    v37:Destroy()
                end
            end

            local _warn5 = warn

            xpcall(v36, _warn5)

            local function v38() -- line: 471
                -- upvalues: clone4 (copy)
                clone4:Destroy()
            end

            local _warn6 = warn

            xpcall(v38, _warn6)

            local _warn7 = warn

            xpcall(restoreCamera, _warn7)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v39() -- line: 482
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v39)

            local function v40() -- line: 486
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
