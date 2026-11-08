-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)
local Player = require(ReplicatedStorage.Shared.Player)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Cameras = require(PlayerScripts.PlayerModule):GetCameras()
local v1, t1, t2
local n1 = 0
local t3 = {}
local t4 = {}
local t5 = {}

local function restoreSnapshot(p1) -- line: 69
    for v2, v3 in pairs(p1.PartStates) do
        if v2.Parent ~= nil then
            v2.Transparency = v3
        end
    end
end

local function restoreActiveSnapshot() -- line: 77
    -- upvalues: t1 (ref)
    local t6 = t1

    t1 = nil

    if t6 ~= nil then
        t6.DescendantTrove:Destroy()

        for v4, v5 in pairs(t6.PartStates) do
            if v4.Parent ~= nil then
                v4.Transparency = v5
            end
        end
    end
end

local function restoreBillboardAlwaysOnTop(p2, p3) -- line: 89
    -- upvalues: t3 (copy)
    if t3[p2] == p3 then
        t3[p2] = nil

        if p2.Parent ~= nil and p2.AlwaysOnTop == false then
            p2.AlwaysOnTop = p3
        end
    end
end

local function setBillboardNotAlwaysOnTop(p4) -- line: 100
    -- upvalues: t (copy), v1 (ref), t3 (copy)
    t.strict(t.instanceIsA("BillboardGui"))(p4)

    local v6 = v1

    if v6 == nil or t3[p4] ~= nil then
        return
    end

    local AlwaysOnTop = p4.AlwaysOnTop

    t3[p4] = AlwaysOnTop
    p4.AlwaysOnTop = false
    v6:Connect(p4:GetPropertyChangedSignal("AlwaysOnTop"), function() -- line: 111
        -- upvalues: p4 (copy), t3 (copy)
        if p4.AlwaysOnTop ~= false then
            t3[p4] = nil
        end
    end)
    v6:Add(function() -- line: 116
        -- upvalues: p4 (copy), AlwaysOnTop (copy), t3 (copy)
        if t3[p4] == AlwaysOnTop then
            t3[p4] = nil

            if p4.Parent ~= nil and p4.AlwaysOnTop == false then
                p4.AlwaysOnTop = AlwaysOnTop
            end
        end
    end)
end

local function restoreHumanoidDisplayDistanceType(p5, p6) -- line: 119
    -- upvalues: t4 (copy)
    if t4[p5] == p6 then
        t4[p5] = nil

        if p5.Parent ~= nil and p5.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None then
            p5.DisplayDistanceType = p6
        end
    end
end

local function hideVisibleHumanoidDisplayDistance(p7) -- line: 136
    -- upvalues: t (copy), v1 (ref), t4 (copy)
    t.strict(t.instanceIsA("Humanoid"))(p7)

    local v7 = v1

    if v7 ~= nil and t4[p7] == nil then
        local DisplayDistanceType = p7.DisplayDistanceType

        if DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
            t4[p7] = DisplayDistanceType
            p7.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            v7:Connect(p7:GetPropertyChangedSignal("DisplayDistanceType"), function() -- line: 151
                -- upvalues: p7 (copy), t4 (copy)
                if p7.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
                    t4[p7] = nil
                end
            end)
            v7:Add(function() -- line: 157
                -- upvalues: p7 (copy), DisplayDistanceType (copy), t4 (copy)
                if t4[p7] == DisplayDistanceType then
                    t4[p7] = nil

                    if p7.Parent ~= nil and p7.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None then
                        p7.DisplayDistanceType = DisplayDistanceType
                    end
                end
            end)
        end
    end
end

local function getCameraTransparency(p8) -- line: 161
    if p8 <= 5 then
        return 1
    end

    return (math.clamp(1 - (p8 - 5) / 8, 0, 1))
end

local function trackCharacterPart(p9, p10) -- line: 171
    if p10:IsA("BasePart") and p10:FindFirstAncestorWhichIsA("Tool") == nil and p9.PartStates[p10] == nil then
        p9.PartStates[p10] = p10.Transparency
    end
end

local function bindCharacter(p11) -- line: 187
    -- upvalues: v1 (ref), t1 (ref)
    local v9 = v1

    if v9 == nil then
        return
    end

    local t7 = t1

    t1 = nil

    if t7 ~= nil then
        t7.DescendantTrove:Destroy()

        for v10, v11 in pairs(t7.PartStates) do
            if v10.Parent ~= nil then
                v10.Transparency = v11
            end
        end
    end

    local t8 = {
        Character = p11,
        DescendantTrove = v9:Extend(),
        PartStates = {}
    }

    t1 = t8

    for _, descendant in ipairs(p11:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:FindFirstAncestorWhichIsA("Tool") == nil and t8.PartStates[descendant] == nil then
            t8.PartStates[descendant] = descendant.Transparency
        end
    end

    t8.DescendantTrove:Connect(p11.DescendantAdded, function(p12) -- line: 208
        -- upvalues: t8 (copy)
        if p12:IsA("BasePart") and p12:FindFirstAncestorWhichIsA("Tool") == nil and t8.PartStates[p12] == nil then
            t8.PartStates[p12] = p12.Transparency
        end
    end)
end

local function updateCharacterTransparency() -- line: 212
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), t1 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local v12 = Player.FindHead(LocalPlayer)

    if CurrentCamera == nil or v12 == nil then
        return
    end

    local t9 = t1
    local Parent = v12.Parent

    if t9 ~= nil and Parent == t9.Character then
        local Magnitude = (CurrentCamera.CFrame.Position - v12.Position).Magnitude
        local v13 = if Magnitude <= 5 then 1 else math.clamp(1 - (Magnitude - 5) / 8, 0, 1)

        for v15, v16 in pairs(t9.PartStates) do
            if v15.Parent ~= nil then
                v15.Transparency = math.max(v16, v13)
            else
                t9.PartStates[v15] = nil
            end
        end
    end
end

local function resolveCurrentTransparency() -- line: 237
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), t1 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local v17 = Player.FindHead(LocalPlayer)

    if CurrentCamera == nil or v17 == nil then
        return nil
    end

    local t10 = t1

    if t10 == nil or v17.Parent ~= t10.Character then
        return nil
    end

    local Magnitude = (CurrentCamera.CFrame.Position - v17.Position).Magnitude

    if Magnitude <= 5 then
        return 1
    end

    return (math.clamp(1 - (Magnitude - 5) / 8, 0, 1))
end

local function restoreAutoCameraState() -- line: 253
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

local function commitAutoCameraDistance(p13) -- line: 260
    -- upvalues: Cameras (copy)
    Cameras:CommitCameraCFrame(p13, Enum.CameraType.Custom)
end

local function completeAutoCameraState(p14) -- line: 264
    -- upvalues: Workspace (copy), Cameras (copy), t2 (ref)
    local t11 = t2

    t2 = nil

    if t11 == nil then
        return
    end

    Cameras:CommitCameraCFrame(p14, Enum.CameraType.Custom)

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

local function clearAutoCameraState() -- line: 275
    -- upvalues: Workspace (copy), t2 (ref)
    local t12 = t2

    t2 = nil

    if t12 ~= nil then
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end
end

local function resolveAutoCameraFocusPoint(p15, p16) -- line: 285
    return p15.CFrame:PointToWorldSpace(p16)
end

local function resolveAutoCameraTargetCFrame(p17, p18) -- line: 289
    local v19 = p17.Position - p18

    if v19.Magnitude <= 0.001 then
        v19 = -p17.CFrame.LookVector
    end

    local v20 = p18 - v19.Unit * 1.8

    return CFrame.lookAt(v20, p17.Position + Vector3.new(0, 0.12, 0), (Vector3.new(0, 1, 0)))
end

local function updateAutoCamera() -- line: 304
    -- upvalues: TweenService (copy), Workspace (copy), Player (copy), LocalPlayer (copy), Cameras (copy), t2 (ref)
    local t13 = t2

    if t13 == nil then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v21 = Player.FindHead(LocalPlayer)
    local v22 = Player.FindRootPart(LocalPlayer)
    local VideoScreenPart = t13.VideoScreenPart

    if CurrentCamera ~= nil and v21 ~= nil and v22 ~= nil and VideoScreenPart ~= nil then
        if VideoScreenPart.Parent ~= nil then
            local FocusOffset = t13.FocusOffset
            local v23 = v22.CFrame:PointToWorldSpace(FocusOffset)
            local v24 = VideoScreenPart.Position - v23

            if v24.Magnitude <= 0.001 then
                v24 = -VideoScreenPart.CFrame.LookVector
            end

            local v25 = v23 - v24.Unit * 1.8
            local v26 = CFrame.lookAt(v25, VideoScreenPart.Position + Vector3.new(0, 0.12, 0), (Vector3.new(0, 1, 0)))
            local v28 = math.clamp((os.clock() - t13.StartedAt) / 0.35, 0, 1)

            CurrentCamera.CFrame = t13.InitialCameraCFrame:Lerp(v26, TweenService:GetValue(v28, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))

            if v28 >= 1 then
                local t15 = t2

                t2 = nil

                if t15 == nil then
                    return
                end

                Cameras:CommitCameraCFrame(v26, Enum.CameraType.Custom)

                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                end
            end
        else
            local t14 = t2

            t2 = nil

            if t14 ~= nil then
                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                end
            end
        end
    end
end

local function findActiveTreadmill(p19) -- line: 344
    -- upvalues: CollectionService (copy)
    for _, v29 in CollectionService:GetTagged("ActiveTreadmill") do
        if v29:GetAttribute("ActiveTreadmillId") == p19 then
            return v29
        end
    end

    return nil
end

local function bindAutoCameraScreen(p20, p21) -- line: 353
    -- upvalues: Workspace (copy), TreadmillUtil (copy), t2 (ref), findActiveTreadmill (copy)
    local v30 = findActiveTreadmill(p20)

    assert(v30 ~= nil, (("No active treadmill is bound for \"%*\""):format(p20)))
    assert(v30:IsA("Tool"), (("Runtime treadmill \"%*\" must be a Tool"):format(p20)))

    local t16 = t2

    if t16 ~= nil and t16.Token == p21 then
        local v34 = TreadmillUtil.FindVideoFeedScreenPart(v30)

        if v34 ~= nil then
            t16.VideoScreenPart = v34
        else
            local t17 = t2

            t2 = nil

            if t17 ~= nil then
                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                end
            end
        end
    end
end

local function bindPlayerDisplayDistance(p22) -- line: 371
    -- upvalues: t (copy), Player (copy), v1 (ref), hideVisibleHumanoidDisplayDistance (copy)
    t.strict(t.instanceIsA("Player"))(p22)

    local v35 = v1

    if v35 == nil then
        return
    end

    local v36 = Player.FindHumanoid(p22)

    if v36 ~= nil then
        hideVisibleHumanoidDisplayDistance(v36)
    end

    local function bindPlayerCharacterDisplayDistance(p23) -- line: 384
        -- upvalues: p22 (copy), v35 (copy), t (copy), Player (copy), hideVisibleHumanoidDisplayDistance (copy)
        t.strict(t.instanceIsA("Model"))(p23)

        local v37 = Player.FindHumanoid(p22)

        if v37 ~= nil then
            hideVisibleHumanoidDisplayDistance(v37)
        end

        v35:Connect(p23.ChildAdded, function(p24) -- line: 392
            -- upvalues: hideVisibleHumanoidDisplayDistance (copy)
            if p24:IsA("Humanoid") then
                hideVisibleHumanoidDisplayDistance(p24)
            end
        end)
    end

    if p22.Character ~= nil then
        bindPlayerCharacterDisplayDistance(p22.Character)
    end

    v35:Connect(p22.CharacterAdded, bindPlayerCharacterDisplayDistance)
end

local function bindHumanoidDisplayPresentation() -- line: 405
    -- upvalues: Players (copy), v1 (ref), bindPlayerDisplayDistance (copy)
    local v38 = v1

    if v38 == nil then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        task.defer(bindPlayerDisplayDistance, player)
    end

    v38:Connect(Players.PlayerAdded, bindPlayerDisplayDistance)
end

local function bindYourBaseBillboardPresentation() -- line: 417
    -- upvalues: PlotState (copy), v1 (ref), setBillboardNotAlwaysOnTop (copy)
    local v39 = v1

    if v39 == nil then
        return
    end

    local function bindCurrentPlot() -- line: 423
        -- upvalues: PlotState (copy), setBillboardNotAlwaysOnTop (copy)
        local v40 = PlotState.FindLocalBaseSign()

        if v40 ~= nil then
            setBillboardNotAlwaysOnTop(v40)
        end
    end

    local v41 = PlotState.FindLocalBaseSign()

    if v41 ~= nil then
        setBillboardNotAlwaysOnTop(v41)
    end

    v39:Add(PlotState.LocalPlotChanged:Connect(bindCurrentPlot))
end

function t5.Stop() -- line: 438
    -- upvalues: Workspace (copy), v1 (ref), t1 (ref), t2 (ref), n1 (ref)
    n1 += 1

    local t18 = t2

    t2 = nil

    if t18 ~= nil then
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end

    local v42 = v1

    v1 = nil

    if v42 ~= nil then
        v42:Destroy()

        return
    end

    local t19 = t1

    t1 = nil

    if t19 ~= nil then
        t19.DescendantTrove:Destroy()

        for v43, v44 in pairs(t19.PartStates) do
            if v43.Parent ~= nil then
                v43.Transparency = v44
            end
        end
    end
end

function t5.StopCameraTransparency() -- line: 452
    -- upvalues: t5 (copy)
    t5.Stop()
end

function t5.Start(p25) -- line: 456
    -- upvalues: Workspace (copy), t (copy), Player (copy), PlotState (copy), TreadmillFlags (copy), Trove (copy), LocalPlayer (copy), Cameras (copy), v1 (ref), t2 (ref), n1 (ref), t5 (copy), restoreActiveSnapshot (copy), setBillboardNotAlwaysOnTop (copy), bindCharacter (copy), updateCharacterTransparency (copy), clearAutoCameraState (copy), updateAutoCamera (copy), bindAutoCameraScreen (copy), bindHumanoidDisplayPresentation (copy)
    t.strict(t.string)(p25)
    t5.Stop()
    n1 += 1

    local v45 = n1
    local v46 = Trove.new()

    v1 = v46

    local CurrentCamera = Workspace.CurrentCamera
    local v47 = Player.FindRootPart(LocalPlayer)
    local CameraSubjectPosition = Cameras:GetCameraSubjectPosition(Enum.CameraType.Custom)

    if CurrentCamera ~= nil and CameraSubjectPosition ~= nil and v47 ~= nil and not TreadmillFlags.CameraAutoFrameDisabled:Get() then
        t2 = {
            VideoScreenPart = nil,
            FocusOffset = v47.CFrame:PointToObjectSpace(CameraSubjectPosition),
            InitialCameraCFrame = CurrentCamera.CFrame,
            StartedAt = os.clock(),
            Token = v45
        }
        task.spawn(bindAutoCameraScreen, p25, v45)
    end

    local Character = LocalPlayer.Character

    if Character ~= nil then
        bindCharacter(Character)
    end

    v46:Connect(LocalPlayer.CharacterAdded, bindCharacter)
    v46:BindToRenderStep("TreadmillCameraAutoFrame", Enum.RenderPriority.Camera.Value + 1, updateAutoCamera)
    v46:BindToRenderStep("TreadmillCameraTransparency", Enum.RenderPriority.Camera.Value + 2, updateCharacterTransparency)
    bindHumanoidDisplayPresentation()

    local v48 = v1

    if v48 ~= nil then
        local function bindCurrentPlot() -- line: 423
            -- upvalues: PlotState (copy), setBillboardNotAlwaysOnTop (copy)
            local v49 = PlotState.FindLocalBaseSign()

            if v49 ~= nil then
                setBillboardNotAlwaysOnTop(v49)
            end
        end

        local v50 = PlotState.FindLocalBaseSign()

        if v50 ~= nil then
            setBillboardNotAlwaysOnTop(v50)
        end

        v48:Add(PlotState.LocalPlotChanged:Connect(bindCurrentPlot))
    end

    v46:Add(restoreActiveSnapshot)
    v46:Add(clearAutoCameraState)
end

function t5.StartCameraTransparency(p26) -- line: 507
    -- upvalues: t5 (copy)
    t5.Start(p26)
end

function t5.IsLocalCharacterFullyTransparent() -- line: 511
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), t1 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local v51 = Player.FindHead(LocalPlayer)
    local v52

    if CurrentCamera ~= nil and v51 ~= nil then
        local t20 = t1

        if t20 ~= nil and v51.Parent == t20.Character then
            local Magnitude = (CurrentCamera.CFrame.Position - v51.Position).Magnitude

            v52 = if Magnitude <= 5 then 1 else math.clamp(1 - (Magnitude - 5) / 8, 0, 1)
        end
    end

    return v52 ~= nil and v52 >= 1
end

TreadmillFlags.CameraAutoFrameDisabled.Changed:Connect(function(p27) -- line: 516
    -- upvalues: Workspace (copy), t2 (ref)
    if not p27 then
        return
    end

    local t21 = t2

    t2 = nil

    if t21 == nil then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end)

return t5
