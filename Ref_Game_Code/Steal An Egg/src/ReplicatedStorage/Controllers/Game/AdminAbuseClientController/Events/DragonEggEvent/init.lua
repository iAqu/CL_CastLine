-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")

game:GetService("ContentProvider")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local EggState = require(ReplicatedStorage.Client.EggState)
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Game = ReplicatedStorage.Controllers:FindFirstChild("Game")
local Plots = Game and Game:FindFirstChild("Plots")

Game = Plots and Plots:FindFirstChild("ActiveAssetsController")

local result

if Game ~= nil then
    result = require

    local ok

    ok, result = pcall(result, Game)

    if not ok then
        result = nil
    end
end

local t1 = {}
local t2 = {
    Cutscene1 = true,
    Cutscene2 = true,
    ZoneReveal = true
}
local t3 = {
    Cutscene1 = true,
    Tutorial = true,
    Steal = true
}
local t4 = {}
local t5 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local v2 = false
local v3
local v4 = Trove.new()
local clone
local Build = Workspace:WaitForChild("World"):WaitForChild("Build")
local v5 = GUI.TutorialInstructions()

assert(v5:IsA("ScreenGui"), "TutorialInstructions must be a ScreenGui")

local v6 = false
local v7 = false
local Enabled = v5.Enabled
local v8 = CameraShaker.new()
local v9 = false
local t6, t7, v10, t8

local function resolveMarker() -- line: 143
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local AdminAbuseEggSpawn = Areas and Areas:FindFirstChild("AdminAbuseEggSpawn")

    return if AdminAbuseEggSpawn ~= nil and AdminAbuseEggSpawn:IsA("BasePart") then AdminAbuseEggSpawn else nil
end

local function resolveWall() -- line: 154
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local WallStartVisual = Areas and Areas:FindFirstChild("WallStartVisual")

    return if WallStartVisual ~= nil and WallStartVisual:IsA("BasePart") then WallStartVisual else nil
end

local function resolveShot(p1, p2, p3) -- line: 165
    if (Vector3.new(-1, 0, 0)).Magnitude <= 0 then
    end

    local Unit = (Vector3.new(-1, 0, 0)).Unit
    local v13 = math.max(p2 / 0.8, p3 or 70) * 0.5 / 0.3152987888789835
    local v14 = (Unit * 0.9945218953682733 + Vector3.new(0, 0.104528464, 0)) * v13

    return CFrame.lookAt(p1 + v14, p1)
end

local function resolveModelSubject(p4) -- line: 185
    -- upvalues: Workspace (copy)
    local v15 = Workspace:FindFirstChild(p4)

    if v15 == nil or not v15:IsA("Model") then
        return nil, nil
    end

    local BoundingBox, BoundingBox2 = v15:GetBoundingBox()

    return BoundingBox.Position, BoundingBox2.Y
end

local t9 = {}

local function resolveSubject(p5) -- line: 199
    -- upvalues: Workspace (copy), t9 (copy)
    local DragonEventCutsceneBeat = Workspace:GetAttribute("DragonEventCutsceneBeat")
    local v16 = if type(DragonEventCutsceneBeat) == "string" then t9[DragonEventCutsceneBeat] else nil

    if v16 ~= nil then
        local v17 = Workspace:FindFirstChild(v16.Name)
        local Position, Y

        if v17 ~= nil and v17:IsA("Model") then
            local BoundingBox, BoundingBox2 = v17:GetBoundingBox()

            Position = BoundingBox.Position
            Y = BoundingBox2.Y
        end

        if Position ~= nil and Y ~= nil then
            return Position + Vector3.new(0, v16.FocusLift or 0, 0), Y, v16.MinFramedHeight
        end
    end

    for _, v19 in { "DragonCutscene", "DragonModel" } do
        local v20 = Workspace:FindFirstChild(v19)
        local Position, Y

        if v20 ~= nil and v20:IsA("Model") then
            local BoundingBox, BoundingBox2 = v20:GetBoundingBox()

            Position = BoundingBox.Position
            Y = BoundingBox2.Y
        end

        if Position ~= nil and Y ~= nil then
            return Position, Y
        end
    end

    return p5.Position, 70
end

local function restoreCamera() -- line: 221
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        CurrentCamera.CameraSubject = Humanoid
    end
end

local function ensureOverlay() -- line: 237
    -- upvalues: LocalPlayer (copy), t6 (ref)
    local t10 = t6

    if t10 ~= nil and t10.Gui.Parent ~= nil then
        return t10
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "DragonCinematic"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 50

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Vignette"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://104574024062008"
    ImageLabel.ImageColor3 = Color3.new(0, 0, 0)
    ImageLabel.ImageTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = ScreenGui

    local function bar(p6, p7) -- line: 260
        -- upvalues: ScreenGui (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p6
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.fromScale(1, 0.11)
        Frame.Position = p7
        Frame.ZIndex = 2
        Frame.Parent = ScreenGui

        return Frame
    end

    local Top = bar("Top", UDim2.fromScale(0, -0.11))
    local Bottom = bar("Bottom", UDim2.fromScale(0, 1))

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local t11 = {
        Gui = ScreenGui,
        Top = Top,
        Bottom = Bottom,
        Vignette = ImageLabel
    }

    t6 = t11

    return t11
end

local function setOverlayShown(p8) -- line: 280
    -- upvalues: TweenService (copy), ensureOverlay (copy)
    local v21 = ensureOverlay()
    local v22 = TweenInfo.new(0.9, Enum.EasingStyle.Quint, if p8 then Enum.EasingDirection.Out else Enum.EasingDirection.In)

    TweenService:Create(v21.Top, v22, {
        Position = if p8 then UDim2.fromScale(0, 0) else UDim2.fromScale(0, -0.11)
    }):Play()
    TweenService:Create(v21.Bottom, v22, {
        Position = if p8 then UDim2.fromScale(0, 0.89) else UDim2.fromScale(0, 1)
    }):Play()
    TweenService:Create(v21.Vignette, v22, {
        ImageTransparency = p8 and 0.3 or 1
    }):Play()
end

local function hideAllUi() -- line: 305
    -- upvalues: StarterGui (copy), Tabs (copy), t5 (copy), LocalPlayer (copy), t7 (ref), v10 (ref), t8 (ref)
    if t7 ~= nil then
        return
    end

    local t15 = {}

    v10 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "DragonCinematic" and child.Enabled then
            t15[child] = true
            child.Enabled = false
        end
    end

    t7 = t15

    local function v23() -- line: 320
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v23)

    local t16 = {}

    for _, v24 in t5 do
        t16[v24] = StarterGui:GetCoreGuiEnabled(v24)
        StarterGui:SetCoreGuiEnabled(v24, false)
    end

    t8 = t16
end

local function restoreAllUi() -- line: 330
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t7 (ref), v10 (ref), t8 (ref)
    local t17 = t7
    local v25 = v10

    t7 = nil
    v10 = nil

    if t17 ~= nil then
        for v26 in t17 do
            if v26.Parent ~= nil and v26.Name ~= v25 then
                v26.Enabled = true
            end
        end
    end

    local function v27() -- line: 343
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v27)

    local t18 = t8

    t8 = nil

    if t18 ~= nil then
        for v28, v29 in t18 do
            StarterGui:SetCoreGuiEnabled(v28, v29)
        end
    end

    return v25
end

local function hideCutsceneUi() -- line: 355
    -- upvalues: HiddenUIHandler (copy), v3 (ref), hideAllUi (copy)
    if v3 == nil then
        v3 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 362
    -- upvalues: Tabs (copy), v3 (ref), restoreAllUi (copy)
    local v30 = restoreAllUi()
    local v31 = v3

    v3 = nil

    if v31 ~= nil then
        v31()
    end

    if v30 ~= nil then
        Tabs.Activate(v30, {
            instant = true
        })
    end
end

local function easeInOutCubic(p9) -- line: 374
    if p9 < 0.5 then
        return p9 * 4 * p9 * p9
    end

    return 1 - (p9 * -2 + 2) ^ 3 / 2
end

local function handheldNoise(p10, p11) -- line: 379
    return (math.noise(p10 * 0.22, p11 * 7.31, 0.5) + math.noise(p10 * 1.1, p11 * 7.31 + 3.17, 9.5) * 0.22) / 1.22 * 2
end

local function handheldOffset(p12, p13) -- line: 386
    local v32 = (math.noise(p12 * 0.22, 7.31, 0.5) + math.noise(p12 * 1.1, 10.48, 9.5) * 0.22) / 1.22 * 2 * 0.038397243543875255 * p13
    local v33 = (math.noise(p12 * 0.22, 14.62, 0.5) + math.noise(p12 * 1.1, 17.79, 9.5) * 0.22) / 1.22 * 2 * 0.026179938779914945 * p13
    local v34 = (math.noise(p12 * 0.22, 21.93, 0.5) + math.noise(p12 * 1.1, 25.1, 9.5) * 0.22) / 1.22 * 2 * 0.010471975511965976 * p13
    local v38 = Vector3.new((math.noise(p12 * 0.22, 29.24, 0.5) + math.noise(p12 * 1.1, 32.41, 9.5) * 0.22) / 1.22 * 2 * 0.25, (math.noise(p12 * 0.22, 36.55, 0.5) + math.noise(p12 * 1.1, 39.72, 9.5) * 0.22) / 1.22 * 2 * 0.20000000298023224, (math.noise(p12 * 0.22, 43.86, 0.5) + math.noise(p12 * 1.1, 47.03, 9.5) * 0.22) / 1.22 * 2 * 0.10000000149011612) * p13

    return CFrame.new(v38) * CFrame.Angles(0, v32, 0) * CFrame.Angles(v33, 0, v34)
end

local function stopCutscene() -- line: 398
    -- upvalues: RunService (copy), Workspace (copy), Tabs (copy), LocalPlayer (copy), v2 (ref), v3 (ref), setOverlayShown (copy), restoreAllUi (copy)
    if not v2 then
        return
    end

    v2 = false
    RunService:UnbindFromRenderStep("DragonEventCutsceneCamera")
    setOverlayShown(false)

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid ~= nil then
            CurrentCamera.CameraSubject = Humanoid
        end
    end

    local v39 = restoreAllUi()
    local v40 = v3

    v3 = nil

    if v40 ~= nil then
        v40()
    end

    if v39 ~= nil then
        Tabs.Activate(v39, {
            instant = true
        })
    end
end

local function resolveZoneBounds() -- line: 410
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local CherryBlossom = Areas and Areas:FindFirstChild("CherryBlossom")
    local Bounds = CherryBlossom and CherryBlossom:FindFirstChild("Bounds")

    return if Bounds ~= nil and Bounds:IsA("BasePart") then Bounds else nil
end

local function startZoneRevealCutscene() -- line: 422
    -- upvalues: RunService (copy), Workspace (copy), CameraShakerDriver (copy), HiddenUIHandler (copy), v2 (ref), v3 (ref), v8 (copy), setOverlayShown (copy), hideAllUi (copy), handheldOffset (copy), resolveZoneBounds (copy)
    local v41 = resolveZoneBounds()
    local CurrentCamera = Workspace.CurrentCamera

    if v41 == nil or CurrentCamera == nil then
        return
    end

    v2 = true

    if v3 == nil then
        v3 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
    setOverlayShown(true)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.FieldOfView = 60

    local Position = v41.Position
    local v42 = Position + Vector3.new(120, 10, 0)
    local v43 = CFrame.lookAt(Position + Vector3.new(-400, 28, 0), v42)
    local v44 = CFrame.lookAt(Position + Vector3.new(-240, 18, 0), v42)
    local elapsed = os.clock()

    RunService:BindToRenderStep("DragonEventCutsceneCamera", Enum.RenderPriority.Camera.Value + 1, function(p14) -- line: 444
        -- upvalues: CurrentCamera (copy), v43 (copy), v44 (copy), elapsed (copy), CameraShakerDriver (copy), v2 (ref), v8 (copy), handheldOffset (copy)
        if not v2 then
            return
        end

        CurrentCamera.CameraType = Enum.CameraType.Scriptable

        local v46 = os.clock() - elapsed
        local v48 = math.clamp(v46 / 9, 0, 1)
        local v49 = if v48 < 0.5 then v48 * 4 * v48 * v48 else 1 - (v48 * -2 + 2) ^ 3 / 2
        local v51 = math.clamp(v46 / 1.5, 0, 1)

        CurrentCamera.CFrame = v43:Lerp(v44, v49) * handheldOffset(v46, v51) * CameraShakerDriver.Advance(v8, p14)
    end)
end

local function startCutscene(p15) -- line: 460
    -- upvalues: RunService (copy), Workspace (copy), CameraShakerDriver (copy), HiddenUIHandler (copy), Tabs (copy), t4 (copy), v1 (copy), v2 (ref), v3 (ref), v8 (copy), resolveSubject (copy), setOverlayShown (copy), hideAllUi (copy), restoreAllUi (copy), handheldOffset (copy), startZoneRevealCutscene (copy)
    if v2 then
        return
    end

    if p15 == "ZoneReveal" then
        startZoneRevealCutscene()
    elseif p15 == "Cutscene1" then
        if v3 == nil then
            v3 = HiddenUIHandler.Acquire()
        end

        hideAllUi()

        local v52 = require(script.CutscenePart1)(v1)

        task.spawn(function() -- line: 473
            -- upvalues: v52 (copy), Tabs (copy), v2 (ref), v3 (ref), restoreAllUi (copy)
            v52.Run()

            if v2 then
                return
            end

            local v53 = restoreAllUi()
            local v54 = v3

            v3 = nil

            if v54 ~= nil then
                v54()
            end

            if v53 ~= nil then
                Tabs.Activate(v53, {
                    instant = true
                })
            end
        end)
    elseif p15 == "Cutscene2" then
        if v3 == nil then
            v3 = HiddenUIHandler.Acquire()
        end

        hideAllUi()

        local v55 = require(script.CutscenePart2)(v1)

        task.spawn(function() -- line: 485
            -- upvalues: v55 (copy), Tabs (copy), v2 (ref), v3 (ref), restoreAllUi (copy)
            v55.Run()

            if v2 then
                return
            end

            local v56 = restoreAllUi()
            local v57 = v3

            v3 = nil

            if v57 ~= nil then
                v57()
            end

            if v56 ~= nil then
                Tabs.Activate(v56, {
                    instant = true
                })
            end
        end)
    else
        local World = Workspace:FindFirstChild("World")
        local Areas = World and World:FindFirstChild("Areas")
        local AdminAbuseEggSpawn = Areas and Areas:FindFirstChild("AdminAbuseEggSpawn")

        if AdminAbuseEggSpawn == nil or not AdminAbuseEggSpawn:IsA("BasePart") then
            AdminAbuseEggSpawn = nil
        end

        local CurrentCamera = Workspace.CurrentCamera

        if AdminAbuseEggSpawn ~= nil and CurrentCamera ~= nil then
            v2 = true

            if v3 == nil then
                v3 = HiddenUIHandler.Acquire()
            end

            hideAllUi()
            setOverlayShown(true)
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.FieldOfView = 80

            local Position = AdminAbuseEggSpawn.Position

            if (Vector3.new(-1, 0, 0)).Magnitude <= 0 then
            end

            local v58 = ((Vector3.new(-1, 0, 0)).Unit * 0.9945218953682733 + Vector3.new(0, 0.104528464, 0)) * 138.75727260339056
            local v59 = CFrame.lookAt(Position + v58, Position)
            local v60 = v59

            CurrentCamera.CFrame = v59

            local v61 = v59
            local n1 = 80
            local elapsed = os.clock()
            local DragonEventCutsceneBeat = Workspace:GetAttribute("DragonEventCutsceneBeat")
            local elapsed2 = os.clock()
            local v62
            local v63 = Enum.RenderPriority.Camera.Value + 1
            local AdminAbuseEggSpawn2 = AdminAbuseEggSpawn

            RunService:BindToRenderStep("DragonEventCutsceneCamera", v63, function(p16) -- line: 523
                -- upvalues: CurrentCamera (copy), v60 (ref), v61 (ref), n1 (ref), elapsed (ref), DragonEventCutsceneBeat (ref), elapsed2 (copy), v62 (ref), AdminAbuseEggSpawn2 (copy), Workspace (copy), CameraShakerDriver (copy), t4 (copy), v2 (ref), v8 (copy), resolveSubject (copy), handheldOffset (copy)
                if not v2 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable

                local DragonEventCutsceneBeat2 = Workspace:GetAttribute("DragonEventCutsceneBeat")

                if DragonEventCutsceneBeat2 ~= DragonEventCutsceneBeat then
                    DragonEventCutsceneBeat = DragonEventCutsceneBeat2
                    v61 = v60
                    n1 = CurrentCamera.FieldOfView
                    elapsed = os.clock()
                    v62 = nil
                end

                local v64, v65, v66 = resolveSubject(AdminAbuseEggSpawn2)
                local v67 = v62

                if v67 ~= nil then
                    v64 = v67:Lerp(v64, 1 - math.exp(-p16 / 0.18))
                end

                v62 = v64

                if (Vector3.new(-1, 0, 0)).Magnitude <= 0 then
                end

                local Unit = (Vector3.new(-1, 0, 0)).Unit
                local v71 = math.max(v65 / 0.8, v66 or 70) * 0.5 / 0.3152987888789835
                local v72 = (Unit * 0.9945218953682733 + Vector3.new(0, 0.104528464, 0)) * v71
                local v73 = CFrame.lookAt(v64 + v72, v64)
                local v74 = if type(DragonEventCutsceneBeat2) ~= "string" or t4[DragonEventCutsceneBeat2] == nil then 1.6 else t4[DragonEventCutsceneBeat2]
                local v76 = math.clamp((os.clock() - elapsed) / v74, 0, 1)
                local v77 = if v76 < 0.5 then v76 * 4 * v76 * v76 else 1 - (v76 * -2 + 2) ^ 3 / 2

                v60 = v61:Lerp(v73, v77)

                local v78 = os.clock() - elapsed2
                local v80 = math.clamp(v78 / 1.5, 0, 1)

                CurrentCamera.CFrame = v60 * handheldOffset(v78, v80) * CameraShakerDriver.Advance(v8, p16)
                CurrentCamera.FieldOfView = n1 + (35 - n1) * v77
            end)
        end
    end
end

local function preloadCutsceneAssets() -- line: 566
    -- upvalues: v9 (ref)
    v9 = v9 or true
end

local function setNightGuiHidden(p17) -- line: 573
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer.PlayerGui
    local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

    if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
        ResetStartTimer.Enabled = not p17
    end
end

local function destroyTutorial() -- line: 581
    -- upvalues: v4 (copy), clone (ref)
    clone = nil
    v4:Clean()
end

local function showTutorial() -- line: 586
    -- upvalues: RunService (copy), Workspace (copy), AreaEggCycle (copy), LocalPlayer (copy), v4 (copy), clone (ref)
    if clone ~= nil then
        return
    end

    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local WallStartVisual = Areas and Areas:FindFirstChild("WallStartVisual")

    if WallStartVisual == nil or not WallStartVisual:IsA("BasePart") then
        WallStartVisual = nil
    end

    if WallStartVisual == nil then
        return
    end

    local clone2 = script.WallStartVisual:Clone()

    v4:Add(clone2)
    clone2.Parent = Workspace
    clone = clone2

    local Main = clone2.SurfaceGui.Main
    local Title, TimerLabel = Main.Title, Main.TimerLabel
    local ServerTimeNow

    v4:Add(RunService.Heartbeat:Connect(function() -- line: 607
        -- upvalues: Title (copy), TimerLabel (copy), ServerTimeNow (ref), Workspace (copy), AreaEggCycle (copy), LocalPlayer (copy)
        local ServerTimeNow2 = Workspace:GetServerTimeNow()

        Title.Text = AreaEggCycle.IsNightPhase(ServerTimeNow2) and "Starting in" or "Time Remaining"

        local v84 = AreaEggCycle.SecondsUntilPhaseEnd(ServerTimeNow2)
        local v86 = math.floor(v84 / 60)
        local v88 = math.floor(v84 % 60)

        if v84 < 1 then
            ServerTimeNow = ServerTimeNow2
        end

        if ServerTimeNow then
            TimerLabel.Text = "GET READY!!!"

            if ServerTimeNow2 - ServerTimeNow > 7 then
                ServerTimeNow = nil
            end
        else
            TimerLabel.Text = string.format("%d:%02d", v86, v88)
        end

        local PlayerGui = LocalPlayer.PlayerGui
        local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

        if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
            ResetStartTimer.Enabled = false
        end
    end))
    v4:Add(function() -- line: 631
        -- upvalues: LocalPlayer (copy)
        local PlayerGui = LocalPlayer.PlayerGui
        local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

        if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
            ResetStartTimer.Enabled = true
        end
    end)
end

local function setPetsHidden(p18) -- line: 634
    -- upvalues: result (ref)
    if result ~= nil then
        local SetAllPetsHidden = result.SetAllPetsHidden

        pcall(SetAllPetsHidden, p18)
    end
end

local function isInsideCherryBlossom() -- line: 647
    -- upvalues: Player (copy), LocalPlayer (copy), resolveZoneBounds (copy)
    local v89 = resolveZoneBounds()

    if v89 == nil then
        return false
    end

    local v90 = Player.FindPrimaryPart(LocalPlayer)

    if v90 == nil then
        return false
    end

    local v91 = v89.CFrame:PointToObjectSpace(v90.Position)

    if not (math.abs(v91.X) <= v89.Size.X / 2) then
        return false
    end

    return math.abs(v91.Z) <= v89.Size.Z / 2
end

local function isInBloom(p19) -- line: 661
    -- upvalues: Workspace (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), isInsideCherryBlossom (copy)
    local v92 = Save.IsLoaded()
    local v93 = if v92 then Save.Peek() else nil

    if not SakuraBloomPolicy.HasBloomUnlocked(v92, v93) then
        return false
    end

    local Attribute = Workspace:GetAttribute(Sakura.Bloom.EndsAtAttribute)

    if typeof(Attribute) == "number" and p19 < Attribute then
        return (isInsideCherryBlossom())
    end

    return false
end

local function onPhaseChanged() -- line: 672
    -- upvalues: RunService (copy), Workspace (copy), AreaEggCycle (copy), PlacedEggRenderer (copy), Tabs (copy), result (ref), t2 (copy), t3 (copy), LocalPlayer (copy), v2 (ref), v3 (ref), v4 (copy), clone (ref), v6 (ref), v7 (ref), Enabled (ref), setOverlayShown (copy), restoreAllUi (copy), startCutscene (copy), showTutorial (copy), isInBloom (copy)
    local DragonEventPhase = Workspace:GetAttribute("DragonEventPhase")

    if DragonEventPhase == nil or not t2[DragonEventPhase] then
        if v2 then
            v2 = false
            RunService:UnbindFromRenderStep("DragonEventCutsceneCamera")
            setOverlayShown(false)

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.FieldOfView = 70

                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                if Humanoid ~= nil then
                    CurrentCamera.CameraSubject = Humanoid
                end
            end

            local v94 = restoreAllUi()
            local v95 = v3

            v3 = nil

            if v95 ~= nil then
                v95()
            end

            if v94 ~= nil then
                Tabs.Activate(v94, {
                    instant = true
                })
            end
        end
    else
        startCutscene(DragonEventPhase)
    end

    if DragonEventPhase == "Tutorial" or DragonEventPhase == "Steal" then
        showTutorial()
    else
        clone = nil
        v4:Clean()
    end

    local function v96() -- line: 688
        -- upvalues: DragonEventPhase (copy), Workspace (copy), AreaEggCycle (copy), LocalPlayer (copy), v6 (ref), v7 (ref), Enabled (ref), isInBloom (copy)
        LocalPlayer.PlayerGui.DragonEggEventUI.Enabled = DragonEventPhase == "Steal"
        task.spawn(function() -- line: 691
            -- upvalues: DragonEventPhase (copy), Workspace (copy), AreaEggCycle (copy), LocalPlayer (copy), v6 (ref), v7 (ref), Enabled (ref), isInBloom (copy)
            if DragonEventPhase ~= "Steal" then
                return
            end

            while LocalPlayer.PlayerGui.DragonEggEventUI.Enabled do
                task.wait(1)

                local ServerTimeNow = Workspace:GetServerTimeNow()

                if not isInBloom(ServerTimeNow) and not AreaEggCycle.IsNightPhase(ServerTimeNow) and AreaEggCycle.IsCloseToReset(AreaEggCycle.SecondsUntilPhaseEnd(ServerTimeNow)) and not v6 and not v7 and not Enabled then
                    LocalPlayer.PlayerGui.DragonEggEventUI.Enabled = false
                end
            end
        end)
    end

    pcall(v96)

    local v97 = DragonEventPhase ~= nil and t3[DragonEventPhase] == true
    local PlayerGui = LocalPlayer.PlayerGui
    local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

    if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
        ResetStartTimer.Enabled = not v97
    end

    if result ~= nil then
        local SetAllPetsHidden = result.SetAllPetsHidden

        pcall(SetAllPetsHidden, v97)
    end

    PlacedEggRenderer.SetAllHidden(v97)
end

local function onBeatChanged() -- line: 716
    -- upvalues: Workspace (copy), t1 (copy), v2 (ref), v8 (copy)
    local DragonEventCutsceneBeat = Workspace:GetAttribute("DragonEventCutsceneBeat")
    local v98 = if type(DragonEventCutsceneBeat) == "string" then t1[DragonEventCutsceneBeat] else nil

    if v98 ~= nil and v2 then
        v8:ShakeOnce(v98.Magnitude, v98.Roughness, v98.FadeIn, v98.FadeOut)
    end
end

local function onMapChanged() -- line: 724
    -- upvalues: LightingController (copy), Build (copy)
    if Build:GetAttribute("DragonEventMap") == true then
        LightingController.SetLayer("DragonEvent", "DragonEvent", 50, 2)
    else
        LightingController.ClearLayer("DragonEvent", 2)
    end
end

local function onNestGuideBeamAdded(p20) -- line: 735
    -- upvalues: LocalPlayer (copy)
    if p20:IsA("Beam") then
        p20.Enabled = p20:GetAttribute("Owner") == LocalPlayer.UserId
    end
end

local t19 = {
    StartEvent = function(_, _, _) -- StartEvent | line: 745
    end,
    StopEvent = function(_) -- StopEvent | line: 747
        -- upvalues: RunService (copy), Workspace (copy), PlacedEggRenderer (copy), Tabs (copy), result (ref), LocalPlayer (copy), v2 (ref), v3 (ref), v4 (copy), clone (ref), setOverlayShown (copy), restoreAllUi (copy)
        if v2 then
            v2 = false
            RunService:UnbindFromRenderStep("DragonEventCutsceneCamera")
            setOverlayShown(false)

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.FieldOfView = 70

                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                if Humanoid ~= nil then
                    CurrentCamera.CameraSubject = Humanoid
                end
            end

            local v99 = restoreAllUi()
            local v100 = v3

            v3 = nil

            if v100 ~= nil then
                v100()
            end

            if v99 ~= nil then
                Tabs.Activate(v99, {
                    instant = true
                })
            end
        end

        clone = nil
        v4:Clean()

        local PlayerGui = LocalPlayer.PlayerGui
        local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

        if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
            ResetStartTimer.Enabled = true
        end

        if result ~= nil then
            local SetAllPetsHidden = result.SetAllPetsHidden

            pcall(SetAllPetsHidden, false)
        end

        PlacedEggRenderer.SetAllHidden(false)

        local v101 = restoreAllUi()
        local v102 = v3

        v3 = nil

        if v102 ~= nil then
            v102()
        end

        if v101 ~= nil then
            Tabs.Activate(v101, {
                instant = true
            })
        end
    end
}

Workspace:GetAttributeChangedSignal("DragonEventPhase"):Connect(onPhaseChanged)
Workspace:GetAttributeChangedSignal("DragonEventCutsceneBeat"):Connect(onBeatChanged)
Build:GetAttributeChangedSignal("DragonEventMap"):Connect(onMapChanged)
CollectionService:GetInstanceAddedSignal("DragonNestGuideBeam"):Connect(onNestGuideBeamAdded)

for _, v103 in CollectionService:GetTagged("DragonNestGuideBeam") do
    if v103:IsA("Beam") then
        v103.Enabled = v103:GetAttribute("Owner") == LocalPlayer.UserId
    end
end

EggState.CarryChanged:Connect(function(p25) -- line: 764
    -- upvalues: v6 (ref)
    v6 = p25.IsCarrying
end)
Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p26) -- line: 766
    -- upvalues: v7 (ref)
    v7 = p26 ~= nil
end)
v5:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 769
    -- upvalues: v5 (copy), Enabled (ref)
    Enabled = v5.Enabled
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 771
    -- upvalues: Workspace (copy), t3 (copy), LocalPlayer (copy), v2 (ref)
    local CurrentCamera, Humanoid

    if not v2 then
        CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = 70

            local Character = LocalPlayer.Character

            Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid ~= nil then
                CurrentCamera.CameraSubject = Humanoid
            end
        end
    end

    local DragonEventPhase = Workspace:GetAttribute("DragonEventPhase")
    local v104 = DragonEventPhase ~= nil and t3[DragonEventPhase] == true
    local PlayerGui = LocalPlayer.PlayerGui
    local ResetStartTimer = PlayerGui and PlayerGui:FindFirstChild("ResetStartTimer")

    if ResetStartTimer ~= nil and ResetStartTimer:IsA("SurfaceGui") then
        ResetStartTimer.Enabled = not v104
    end
end)
onPhaseChanged()

if Build:GetAttribute("DragonEventMap") == true then
    LightingController.SetLayer("DragonEvent", "DragonEvent", 50, 2)
else
    LightingController.ClearLayer("DragonEvent", 2)
end

return t19
