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

local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t1, v2, t2
local t3 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}

local function restoreCamera() -- line: 44
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 54
    -- upvalues: StarterGui (copy), Tabs (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref), t3 (copy)
    if t1 ~= nil then
        return
    end

    local t4 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "DragonCinematic" and child.Enabled then
            t4[child] = true
            child.Enabled = false
        end
    end

    t1 = t4

    local function v3() -- line: 69
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t5 = {}

    for _, v4 in t3 do
        t5[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t2 = t5
end

local function restoreAllUi() -- line: 79
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref)
    local t6 = t1
    local v5 = v2

    t1 = nil
    v2 = nil

    if t6 ~= nil then
        for v6 in t6 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 92
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t7 = t2

    t2 = nil

    if t7 ~= nil then
        for v8, v9 in t7 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 104
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 111
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

local function setTransparency(p1, p2) -- line: 123
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

return function(p3) -- line: 136
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
    local v13 = CutsceneHelperFunctions.GetHelperFunctions(p3)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v13.SetProperty, v13.TweenProperty, v13.PlaySequenceAsync, v13.LoadAnimationIntoRig
    local RiftCutscene = ReplicatedStorage.CutsceneAssets.RiftCutsceneAssets.RiftCutscene
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t8 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(4778.5664, 77.7973, -307.0335, -0.3841, 0.438, -0.8128, 0, 0.8803, 0.4744, 0.9233, 0.1822, -0.3381)),
            TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(9.45, Enum.EasingStyle.Linear), CFrame.new(4802.2295, 73.7093, -297.8694, -0.8171, 0, 0.5766, -0.0083, 0.9999, -0.0119, -0.5765, -0.0145, -0.817)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 45)
        },
        [407] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 35) },
        [566] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 45) },
        [567] = { TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(2.216666666666667, Enum.EasingStyle.Linear), CFrame.new(4796.2349, 71.199, -303.4302, 0.8192, 0.06, 0.5704, -0.05, 0.9982, -0.0331, -0.5714, -0.0014, 0.8207)) },
        [700] = { TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(4, Enum.EasingStyle.Linear), CFrame.new(4797.2402, 71.2416, -292.843, -0.9137, -0.2377, -0.3295, -0.1682, 0.9595, -0.2258, 0.3699, -0.1509, -0.9167)) },
        [940] = { TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(4795.6162, 72.4162, -297.8404, -0.9994, 0, -0.0349, -0, 1, -0, 0.0349, 0, -0.9994)) },
        [941] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.8666666666666667, Enum.EasingStyle.Sine), 90) },
        [1066] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Sine), 75.51428) },
        [1076] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Sine), 56.2) },
        [1080] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Sine), 25) },
        [1168] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 45) }
    }

    t8[1400] = {
        function() -- line: 200
            -- upvalues: Black (copy), TweenService (copy)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 0
            }):Play()
        end
    }

    return {
        Run = function() -- Run | line: 207
            -- upvalues: p3 (copy), LoadAnimationIntoRig (copy), RiftCutscene (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), t8 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
            local v14 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p3:Add(function() -- line: 212
                -- upvalues: v14 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v14 then
                    return
                end

                local v15 = restoreAllUi()
                local v16 = v1

                v1 = nil

                if v16 ~= nil then
                    v16()
                end

                if v15 ~= nil then
                    Tabs.Activate(v15, {
                        instant = true
                    })
                end

                v14 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v17() -- line: 220
                -- upvalues: AreaEggSlotsClient (copy), p3 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p3:Add(function() -- line: 222
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v17)

            local GuardAreas = game.Workspace.World.Areas.GuardAreas
            local t10 = {}

            for _, child in (GuardAreas:GetChildren()) do
                local Guard = child.Guard

                t10[Guard] = child
                Guard.Parent = nil
                p3:Add(function() -- line: 233
                    -- upvalues: child (copy), Guard (copy)
                    Guard.Parent = child
                end)
            end

            local Descendants = game.Workspace.World.Areas.GuardAreas["Titan Temple"].Nests:GetDescendants()

            setTransparency(Descendants, 1)
            p3:Add(function() -- line: 240
                -- upvalues: Descendants (copy), setTransparency (copy)
                setTransparency(Descendants)
            end)

            local function v18() -- line: 244
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 245
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0
                        }):Play()
                    end
                end)
            end

            pcall(v18)

            local t11 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p3:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p3:Add(function() -- line: 271
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = script.CutsceneVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p3:Add(clone2)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p3:Add(function() -- line: 282
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = RiftCutscene:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone3.Parent = workspace
            p3:Add(clone3)

            local t12 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v19 = true

            p3:Add(function() -- line: 317
                -- upvalues: v19 (ref)
                v19 = false
            end)
            p3:Add(function() -- line: 318
                -- upvalues: v19 (ref), restoreCamera (copy)
                if v19 then
                    restoreCamera()
                end
            end)

            for _, v20 in t13 do
                v20:Play(0)
            end

            local v21 = t13[clone3["Camera Rig"]]

            assert(v21, "Camera Rig needs an Animation")

            local v22 = os.clock() + 2

            while v19 and v21.TimePosition <= 0 and os.clock() < v22 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 345
                -- upvalues: v19 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v19 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t14 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p4) -- line: 359
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t8 (copy)
                n1 += p4
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v23 in t13 do
                        if v23.IsPlaying then
                            local v25 = n1

                            if math.abs(v25 - v23.TimePosition) >= 0.1 then
                                local function v26() -- line: 371
                                    -- upvalues: v23 (copy), n1 (ref)
                                    v23.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v26, _warn)
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
                    local v28 = math.floor(n1 * 60 - i)

                    if t8[v28] and not t14[v28] then
                        t14[v28] = true

                        for _, v29 in t8[v28] do
                            task.spawn(v29)
                        end
                    end
                end
            end)

            p3:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(24.5)
            connection2:Disconnect()

            local function v30() -- line: 403
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v30, _warn2)
            v19 = false
            Vignette.Visible = false

            local function v31() -- line: 409
                -- upvalues: t11 (copy)
                for _, v32 in t11 do
                    v32:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v31, _warn3)

            local function v33() -- line: 415
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn4 = warn

            xpcall(v33, _warn4)

            local function v34() -- line: 417
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 418
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0.5
                        }):Play()
                    end
                end)
            end

            pcall(v34)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v35() -- line: 436
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v35)

            local function v36() -- line: 440
                -- upvalues: v14 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v37 = restoreAllUi()
                local v38 = v1

                v1 = nil

                if v38 ~= nil then
                    v38()
                end

                if v37 ~= nil then
                    Tabs.Activate(v37, {
                        instant = true
                    })
                end

                v14 = true
            end

            local _warn6 = warn

            xpcall(v36, _warn6)
            setTransparency(Descendants)

            for v39, v40 in t10 do
                v39.Parent = v40
            end
        end
    }
end
