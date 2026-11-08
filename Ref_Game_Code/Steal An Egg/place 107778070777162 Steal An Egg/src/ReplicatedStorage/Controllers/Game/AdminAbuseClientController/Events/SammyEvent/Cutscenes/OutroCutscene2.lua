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
local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local SammyEventOutro2Rigs, SammyEventOutro2VFX = ReplicatedStorage.CutsceneAssets.SammyEvent.SammyEventOutro2Rigs, ReplicatedStorage.CutsceneAssets.SammyEvent.SammyEventOutro2VFX
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
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), CutsceneHelperFunctions (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), SammyEventOutro2Rigs (copy), SammyEventOutro2VFX (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p6)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.PlaySequenceAsync, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone, clone2, Torso
    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(9.131, 16.6001, -21.2199, -0.4348, 0.101, -0.8948, -0, 0.9937, 0.1121, 0.9005, 0.0487, -0.4321)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 25),
            SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
            SetProperty("Lighting.CutsceneDepthOfField.InFocusRadius", 10),
            SetProperty("Lighting.CutsceneDepthOfField.FocusDistance", 0.05),
            SetProperty("Workspace.SammyEventOutro2Rigs.Mind Control Hat Rig.BrokenHelm.Transparency", 0),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("Lighting.ClockTime", 2.3)
        },
        [528] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0) },
        [543] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 227
            -- upvalues: p6 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), clone2 (ref), Torso (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), SammyEventOutro2Rigs (copy), SammyEventOutro2VFX (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p6:Add(function() -- line: 232
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

            local function v21() -- line: 240
                -- upvalues: AreaEggSlotsClient (copy), p6 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p6:Add(function() -- line: 242
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
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
            p6:Add(function() -- line: 266
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone3 = SammyEventOutro2VFX:Clone()

            clone3.Parent = Workspace
            clone = clone3
            p6:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p6:Add(function() -- line: 277
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)
            clone2 = SammyEventOutro2Rigs:Clone()

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

            local v22 = true

            p6:Add(function() -- line: 321
                -- upvalues: v22 (ref)
                v22 = false
            end)
            p6:Add(function() -- line: 322
                -- upvalues: v22 (ref), restoreCamera (copy)
                if v22 then
                    restoreCamera()
                end
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone2.HumanoidCameraRig]

            assert(v24, "HumanoidCameraRig needs an Animation")

            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()
            Torso = clone2.HumanoidCameraRig.Torso

            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 349
                -- upvalues: v22 (ref), connection (ref), Torso (ref), CurrentCamera (copy), LocalPlayer (copy)
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
            local connection2 = RunService.Heartbeat:Connect(function(p7) -- line: 363
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t9 (copy)
                n1 += p7
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v26 in t13 do
                        if v26.IsPlaying then
                            local v28 = n1

                            if math.abs(v28 - v26.TimePosition) >= 0.1 then
                                local function v29() -- line: 375
                                    -- upvalues: v26 (copy), n1 (ref)
                                    v26.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v29, _warn)
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
            task.wait(9.616666666666667)
            connection2:Disconnect()

            local function v33() -- line: 407
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn2 = warn

            xpcall(v33, _warn2)
            v22 = false
            Vignette.Visible = false

            local function v34() -- line: 413
                -- upvalues: t11 (copy)
                for _, v35 in t11 do
                    v35:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v34, _warn3)

            local function v36() -- line: 419
                -- upvalues: clone2 (ref)
                clone2:Destroy()
            end

            local _warn4 = warn

            xpcall(v36, _warn4)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)

            local v37 = BulkFade.new(CutsceneUI.ToBeContinued, TweenInfo.new(1))

            v37:FadeOutInstant()
            task.wait()
            v37:FadeIn()
            CutsceneUI.ToBeContinued.Visible = true
            task.spawn(function() -- line: 430
                -- upvalues: CutsceneUI (copy)
                local function toDHMS(p8) -- line: 431
                    return string.format("%02i:%02i:%02i:%02i", p8 / 86400, p8 / 3600 % 24, p8 / 60 % 60, p8 % 60)
                end

                local n3 = 604799

                while CutsceneUI.ToBeContinued.Visible do
                    CutsceneUI.ToBeContinued.TimeRemaining.Text = toDHMS(n3)
                    script.ClockTick:Play()
                    task.wait(1)
                    n3 -= 1
                end
            end)
            task.wait(5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            v37:FadeOut()
            task.delay(1, function() -- line: 456
                -- upvalues: v37 (copy), CutsceneUI (copy)
                CutsceneUI.ToBeContinued.Visible = false
                v37:FadeIn()
            end)
            Lighting.ClockTime = 11.6
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v38() -- line: 468
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v38)

            local function v39() -- line: 472
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
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

                v18 = true
            end

            local _warn6 = warn

            xpcall(v39, _warn6)
            restoreAllGuardsAndNests()
        end
    }
end
