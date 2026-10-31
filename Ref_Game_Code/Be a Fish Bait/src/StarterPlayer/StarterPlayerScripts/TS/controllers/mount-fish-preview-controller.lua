-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ProximityPromptService, StarterGui, Workspace = services.Players, services.ProximityPromptService, services.StarterGui, services.Workspace
local mountFishPreviewItemNameAtom = RuntimeLib.import(script, script.Parent.Parent, "mount-fish-preview-atom").mountFishPreviewItemNameAtom
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, script.Parent.Parent, "transitions", "screen-transition")
local ScreenTransition, screenTransitionGuiName = v1.ScreenTransition, v1.screenTransitionGuiName
local attachMountFishVisual = RuntimeLib.import(script, script.Parent, "mount-fish-visual-utils").attachMountFishVisual
local getMountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishData
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local t1 = {
    agile = {
        buckFrequency = 1.25,
        buckHeight = 1.5,
        buckLateral = 2,
        buckPitchDegrees = 24,
        buckRollDegrees = 22,
        cameraShake = 0.2,
        heroBankDegrees = 20,
        showcaseRoamSpeed = 9,
        surgeFieldOfView = 58
    },
    heavy = {
        buckFrequency = 0.72,
        buckHeight = 2,
        buckLateral = 1.3,
        buckPitchDegrees = 16,
        buckRollDegrees = 14,
        cameraShake = 0.15,
        heroBankDegrees = 12,
        showcaseRoamSpeed = 6.5,
        surgeFieldOfView = 55
    }
}

local function getAnchorCFrame(p1) -- line: 63
    return p1.CFrame
end

local function getModelBottomY(p2) -- line: 66
    local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
    local v4 = math.abs(BoundingBox.RightVector.Y) * BoundingBox2.X / 2 + math.abs(BoundingBox.UpVector.Y) * BoundingBox2.Y / 2 + math.abs(BoundingBox.LookVector.Y) * BoundingBox2.Z / 2

    return BoundingBox.Position.Y - v4
end

local function clamp01(p3) -- line: 71
    return (math.clamp(p3, 0, 1))
end

local function lerpNumber(p4, p5, p6) -- line: 74
    return p4 + (p5 - p4) * p6
end

local function smoothstep(p7) -- line: 77
    local v5 = math.clamp(p7, 0, 1)

    return v5 * v5 * (3 - 2 * v5)
end

local function easeInCubic(p8) -- line: 81
    local v6 = math.clamp(p8, 0, 1)

    return v6 * v6 * v6
end

local function easeOutCubic(p9) -- line: 85
    local v7 = math.clamp(p9, 0, 1)

    return 1 - (1 - v7) * (1 - v7) * (1 - v7)
end

local function getPhaseProgress(p10, p11, p12) -- line: 89
    return (math.clamp((p10 - p11) / p12, 0, 1))
end

local function wrapIndex(p13, p14) -- line: 92
    return (p13 % p14 + p14) % p14
end

local function catmullRom(p15, p16, p17, p18, p19) -- line: 95
    local v9 = p19 * p19
    local v10 = v9 * p19
    local v11 = p16 * 2
    local v12 = p15 * 2
    local v13 = p16 * 5
    local v14 = p17 * 4
    local v15 = (v12 - v13 + v14 - p18) * v9
    local v16 = p15 * -1
    local v17 = p16 * 3
    local v18 = p17 * 3
    local v19 = (v16 + v17 - v18 + p18) * v10

    return (v11 + (p17 - p15) * p19 + v15 + v19) * 0.5
end

local function catmullRomTangent(p20, p21, p22, p23, p24) -- line: 114
    local v20 = p24 * p24
    local v21 = p20 * 2
    local v22 = p21 * 5
    local v23 = p22 * 4
    local v24 = 2 * p24
    local v25 = p20 * -1
    local v26 = p21 * 3
    local v27 = p22 * 3
    local v28 = 3 * v20

    return (p22 - p20 + (v21 - v22 + v23 - p23) * v24 + (v25 + v26 - v27 + p23) * v28) * 0.5
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 133
        return "MountFishPreviewController"
    end
})

self.__index = self

function self.new(...) -- line: 138
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p25, p26) -- line: 142
    p25._characterController = p26
    p25._coreGuiSnapshots = {}
    p25._screenGuiSnapshots = {}
end

function self.onStart(p27) -- line: 147
    -- upvalues: Players (copy)
    Players.LocalPlayer.CharacterAdded:Connect(function() -- line: 148
        -- upvalues: p27 (copy)
        return p27:stopPreview()
    end)
end

function self.onRender(p28, p29) -- line: 152
    local _session = p28._session

    if _session == nil then
        return nil
    end

    if _session.rig.Parent == nil or _session.mount.Parent == nil then
        p28:stopPreview()

        return nil
    end

    if not _session.cameraActive then
        return nil
    end

    local v31 = math.min(p29, 0.1)

    _session.elapsedTime += v31

    local v32 = p28:_calculatePreviewPose(_session)

    p28:_applyPreviewPose(_session, v32)

    local ridingTrack = _session.ridingTrack

    if ridingTrack ~= nil then
        ridingTrack:AdjustSpeed(v32.ridingAnimationSpeed)
    end

    p28:_applyPreviewCamera(_session, v32, v31)
end

function self.startPreview(p30, p31, p32) -- line: 174
    -- upvalues: Players (copy), Workspace (copy), attachMountFishVisual (copy), getMountFishData (copy), t1 (copy), getModelBottomY (copy)
    local v33 = p32 ~= nil and p32

    p30:stopPreview()

    local v34 = getMountFishData(p31)

    if v34 == nil then
        return false
    end

    local v35 = p30:_findOrCreatePreviewArea()
    local v36 = if v35 == nil then v35 else v35:FindFirstChild("Camera")
    local v37 = if v35 == nil then v35 else v35:FindFirstChild("PreviewOrigin")
    local CurrentCamera = Workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local v38 = v35 == nil
    local v39

    if v38 then
        v39 = v38
    else
        local v40 = (if v36 == nil then v36 else v36:IsA("BasePart")) ~= true

        v40 = v40 and (if v36 == nil then v36 else v36:IsA("Camera")) ~= true

        if v40 then
            v39 = v40
        else
            local v41 = (if v37 == nil then v37 else v37:IsA("BasePart")) ~= true

            v39 = v41 or CurrentCamera == nil or Character == nil
        end
    end

    if v39 then
        warn("[src/client/controllers/mount-fish-preview-controller.ts:275]", "Mount preview requires Workspace.FishingMountPreviewArea.Camera and PreviewOrigin.")

        return false
    end

    local v42 = p30:_cloneCharacter(Character)

    if v42 == nil then
        return false
    end

    v42.Parent = v35

    local v43 = p30:_getTravelPath(v35, v37, v36)
    local v44 = v43[1]
    local v45 = v43[2]
    local v46 = v43[3]
    local v48 = Vector3.new(-v45.Z, 0, v45.X)
    local v49 = if v48.Magnitude > 0.01 then v48.Unit else Vector3.new(0, 0, 1)
    local v50 = t1[v34.previewStyle]

    v42:PivotTo(CFrame.lookAt(v44, v44 + v45))

    local v51 = attachMountFishVisual(v42, p31, v35, {
        weldToCharacter = false
    })

    if v51 == nil then
        v42:Destroy()
        warn("[src/client/controllers/mount-fish-preview-controller.ts:299]", (("Mount preview could not attach %*."):format(p31)))

        return false
    end

    local BoundingBox, BoundingBox2 = v51.model:GetBoundingBox()
    local v52 = v42:GetPivot():PointToObjectSpace(BoundingBox.Position)
    local v54 = math.max(8, math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z) * 0.75)
    local v56 = math.max(4, BoundingBox2.Y * 0.4)
    local v58 = math.max(0, v37.Position.Y + 0.25 - getModelBottomY(v51.model))
    local v59 = p30:_createShowcaseRoute(v35, v44 + v45 * (v46 * 0.72) + Vector3.new(0, 1, 0) * v58, BoundingBox2, v52, v50.showcaseRoamSpeed)

    v42:PivotTo(v42:GetPivot() + Vector3.new(0, 1, 0) * v58)

    local v60 = p30:_playRidingAnimation(v42)
    local v61 = p30._characterController:acquireMovementLock()
    local t5 = {
        cameraSubject = CurrentCamera.CameraSubject,
        cameraType = CurrentCamera.CameraType,
        cframe = CurrentCamera.CFrame,
        fieldOfView = CurrentCamera.FieldOfView
    }
    local v62 = p30:_showTransition()
    local t6 = {
        cameraActive = false,
        elapsedTime = 0,
        camera = CurrentCamera,
        cameraAnchorCFrame = v36.CFrame,
        cameraSnapshot = t5,
        direction = v45,
        focusCenter = v37.Position + Vector3.new(0, 1, 0) * (v58 + 1),
        mount = v51.model
    }

    t6.mountFocusOffset = v52
    t6.mountSeatOffset = v51.seatOffset
    t6.motionProfile = v50
    t6.releaseMovementLock = v61
    t6.returnToShop = v33
    t6.rig = v42
    t6.ridingTrack = v60
    t6.showcaseCameraPullback = v54
    t6.showcaseCameraVerticalOffset = v56
    t6.showcaseLoopDuration = v59.loopDuration
    t6.showcaseMaximumX = v59.maximumX
    t6.showcaseMaximumZ = v59.maximumZ
    t6.showcaseMinimumX = v59.minimumX
    t6.showcaseMinimumZ = v59.minimumZ
    t6.showcaseSegmentDurations = v59.segmentDurations
    t6.showcaseWaypoints = v59.waypoints
    t6.sideDirection = v49
    t6.startPosition = v44
    t6.travelDistance = v46
    t6.verticalOffset = v58
    p30._session = t6
    p30:_revealPreviewAfterTransition(t6, p31, v62, not v33)

    return true
end

function self.closePreview(p33) -- line: 310
    -- upvalues: clientProducer (copy)
    local _session = p33._session

    if _session ~= nil then
        _session = _session.returnToShop
    end

    local v63 = _session == true

    p33:stopPreview()

    if v63 then
        clientProducer.windowOpened({
            currentWindow = "exclusiveShop"
        })
    end
end

function self.stopPreview(p34) -- line: 323
    -- upvalues: mountFishPreviewItemNameAtom (copy)
    local _screenTransition = p34._screenTransition

    if _screenTransition ~= nil then
        _screenTransition:hideInstant()
    end

    local _session = p34._session

    p34._session = nil
    mountFishPreviewItemNameAtom(nil)

    if _session ~= nil then
        local ridingTrack = _session.ridingTrack

        if ridingTrack ~= nil then
            ridingTrack:Stop(0)
        end

        local ridingTrack2 = _session.ridingTrack

        if ridingTrack2 ~= nil then
            ridingTrack2:Destroy()
        end

        _session.mount:Destroy()
        _session.rig:Destroy()
        _session.releaseMovementLock()
        _session.camera.CameraType = _session.cameraSnapshot.cameraType
        _session.camera.CameraSubject = _session.cameraSnapshot.cameraSubject
        _session.camera.CFrame = _session.cameraSnapshot.cframe
        _session.camera.FieldOfView = _session.cameraSnapshot.fieldOfView
    end

    p34:_restoreUi()
end

function self._findOrCreatePreviewArea(_) -- line: 350
    -- upvalues: Workspace (copy)
    local FishingMountPreviewArea = Workspace:FindFirstChild("FishingMountPreviewArea")

    if (if FishingMountPreviewArea == nil then FishingMountPreviewArea else FishingMountPreviewArea:IsA("Model")) == true then
        return FishingMountPreviewArea
    end

    local CharmPreviewArea = Workspace:FindFirstChild("CharmPreviewArea")

    if (if CharmPreviewArea == nil then CharmPreviewArea else CharmPreviewArea:IsA("Model")) ~= true then
        return nil
    end

    local clone = CharmPreviewArea:Clone()

    clone.Name = "FishingMountPreviewArea"
    clone:PivotTo(clone:GetPivot() + Vector3.new(120, 0, 0))
    clone.Parent = Workspace

    return clone
end

function self._getTravelPath(_, p37, p38, p39) -- line: 375
    local TravelStart = p37:FindFirstChild("TravelStart")
    local TravelEnd = p37:FindFirstChild("TravelEnd")
    local v64 = (if TravelStart == nil then TravelStart else TravelStart:IsA("BasePart")) == true

    v64 = v64 and (if TravelEnd == nil then TravelEnd else TravelEnd:IsA("BasePart")) == true

    local v65, v66

    if v64 then
        v65 = TravelEnd.Position - TravelStart.Position
        v66 = v65.Magnitude > 0.01
    end

    if v64 and v66 then
        return {
            TravelStart.Position,
            v65.Unit,
            v65.Magnitude
        }
    end

    local RightVector = p39.CFrame.RightVector
    local v67 = Vector3.new(RightVector.X, 0, RightVector.Z)
    local v68 = if v67.Magnitude > 0.01 then v67.Unit else Vector3.new(1, 0, 0)

    return {
        p38.Position - v68 * 18,
        v68,
        36
    }
end

function self._createShowcaseRoute(_, p41, p42, p43, p44, p45) -- line: 407
    local Floor = p41:FindFirstChild("Floor")
    local v72 = math.sqrt(p43.X * p43.X + p43.Z * p43.Z) / 2 + math.sqrt(p44.X * p44.X + p44.Z * p44.Z) + 8
    local v73 = p42.X - 24
    local v74 = p42.X + 24
    local v75 = p42.Z - 32
    local v76 = p42.Z + 32

    if (if Floor == nil then Floor else Floor:IsA("BasePart")) == true then
        v73 = Floor.Position.X - Floor.Size.X / 2 + v72
        v74 = Floor.Position.X + Floor.Size.X / 2 - v72
        v75 = Floor.Position.Z - Floor.Size.Z / 2 + v72
        v76 = Floor.Position.Z + Floor.Size.Z / 2 - v72
    end

    if v74 < v73 then
        v74 = (v73 + v74) / 2
        v73 = v74
    end

    if v76 < v75 then
        v75 = (v75 + v76) / 2
        v76 = v75
    end

    local v77 = Random.new()
    local t7 = {
        (Vector3.new(math.clamp(p42.X, v73, v74), p42.Y, (math.clamp(p42.Z, v75, v76))))
    }

    for _ = 1, 8 do
        local v80 = t7[#t7]

        for _ = 0, 7 do
            v80 = Vector3.new(v77:NextNumber(v73, v74), p42.Y + v77:NextNumber(0.2, 1.4), v77:NextNumber(v75, v76))

            if (v80 - t7[#t7]).Magnitude >= 12 then
                break
            end
        end

        table.insert(t7, v80)
    end

    local t8 = {}
    local v83 = #t7 - 1
    local n1 = 0

    for i = 0, v83 do
        local v85 = math.clamp((t7[(i + 1) % #t7 + 1] - t7[i + 1]).Magnitude / p45, 2.4, 4.5)

        table.insert(t8, v85)
        n1 += v85
    end

    return {
        loopDuration = n1,
        maximumX = v74,
        maximumZ = v76,
        minimumX = v73,
        minimumZ = v75,
        segmentDurations = t8,
        waypoints = t7
    }
end

function self._cloneCharacter(_, p47) -- line: 471
    local Archivable = p47.Archivable

    p47.Archivable = true

    local clone = p47:Clone()

    p47.Archivable = Archivable

    if clone == nil then
        return nil
    end

    clone.Name = "MountFishPreviewRig"

    for _, child in clone:GetChildren() do
        if child:HasTag("ToolbarSelectedItem") then
            child:Destroy()
        end
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BaseScript") or descendant:IsA("Tool") or descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") or descendant:IsA("Beam") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        end
    end

    local HumanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

    if (if HumanoidRootPart == nil then HumanoidRootPart else HumanoidRootPart:IsA("BasePart")) == true then
        HumanoidRootPart.Anchored = true
        clone.PrimaryPart = HumanoidRootPart
    end

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.AutoRotate = false
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    return clone
end

function self._playRidingAnimation(_, p49) -- line: 514
    -- upvalues: animations (copy)
    local Humanoid = p49:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        return nil
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = animations.playerMount

    local track = Animator:LoadAnimation(Animation)

    Animation:Destroy()
    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action
    track:Play(0.1, 1, 1)

    return track
end

function self._calculatePreviewPose(_, p51) -- line: 533
    local elapsedTime, motionProfile, travelDistance = p51.elapsedTime, p51.motionProfile, p51.travelDistance
    local v86 = p51.startPosition + Vector3.new(0, 1, 0) * p51.verticalOffset
    local direction = p51.direction
    local v87 = CFrame.new()
    local v88 = CFrame.new()
    local v89, v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100

    if elapsedTime < 0.8 then
        local v103 = math.clamp(math.clamp((elapsedTime - 0) / 0.8, 0, 1), 0, 1)
        local v104 = 1 - (1 - v103) * (1 - v103) * (1 - v103)

        v90 = v86 + p51.direction * (travelDistance * 0.12 * v104)
        v91 = 0.08726646259971647 * (1 - v104)
        v92 = 0
        v93 = 0
        v99 = 46 + 4 * v104
        v95 = -1.2 + 1.2 * v104
        v97 = 0
        v98 = 0.35 + -0.35 * v104
        v96 = 0
        v94 = 0.95
        v89 = 0
        v100 = 0.85 + 0.15000000000000002 * v104
    elseif elapsedTime < 5.3 then
        local v106 = math.clamp((elapsedTime - 0.8) / 4.5, 0, 1)
        local v107 = elapsedTime - 0.8
        local v109 = math.sin(3.141592653589793 * v106)
        local buckFrequency = motionProfile.buckFrequency
        local v113 = math.sin(v107 * 9.2 * buckFrequency) + math.sin(v107 * 15.7 * buckFrequency + 0.8) * 0.35
        local v117 = math.sin(v107 * 5.3 * buckFrequency + 0.4) + math.sin(v107 * 8.1 * buckFrequency) * 0.25
        local direction = p51.direction
        local v118 = math.clamp(v106, 0, 1)
        local v119 = travelDistance * (0.12 + 0.06 * (v118 * v118 * (3 - 2 * v118)))
        local sideDirection = p51.sideDirection
        local v120 = v117 * motionProfile.buckLateral * v109
        local v121 = math.abs(v113) * motionProfile.buckHeight * v109

        v90 = v86 + direction * v119 + sideDirection * v120 + Vector3.new(0, 1, 0) * v121
        v91 = math.rad(motionProfile.buckPitchDegrees) * math.sin(v107 * 8.8 * buckFrequency) * v109
        v92 = math.sin(v107 * 5.6 * buckFrequency + 0.7) * 0.13962634015954636 * v109
        v93 = math.rad(motionProfile.buckRollDegrees) * math.sin(v107 * 6.4 * buckFrequency + 1.1) * v109
        v99 = v109 * 2 + 50
        v96 = motionProfile.cameraShake * v109
        v94 = 0.92 + -0.06000000000000005 * v109

        local v127 = v117 * v109
        local v128 = v113 * v109

        v88 = CFrame.new(-v127 * 0.65, math.abs(v128) * 0.32, -v128 * 0.35) * CFrame.Angles(v128 * 0.4886921905584123, 0, v127 * -0.7853981633974483)

        local v130 = math.clamp((v106 - 0.72) / 0.18, 0, 1)
        local v131 = v130 * v130 * (3 - 2 * v130)

        v95 = 0
        v97 = 0
        v98 = 0
        v89 = 0
        v87 = CFrame.Angles(-0.4188790204786391 * v131, 0, 0)
        v100 = v109 * 0.25 + 1
    elseif elapsedTime < 6.699999999999999 then
        local v133 = math.clamp((elapsedTime - 5.3) / 1.4, 0, 1)
        local v134 = math.clamp(v133, 0, 1)
        local v135 = v134 * v134 * (3 - 2 * v134)
        local v137 = math.sin(3.141592653589793 * v133)
        local v139 = math.clamp(v133 / 0.4, 0, 1)
        local v140 = 1 - v139 * v139 * (3 - 2 * v139)
        local direction = p51.direction
        local v141 = travelDistance * (0.18 + 0.14 * v135)
        local v142 = v137 * 0.35

        v90 = v86 + direction * v141 + Vector3.new(0, 1, 0) * v142
        v93 = v137 * 0.08726646259971647
        v87 = CFrame.Angles(-0.4188790204786391 * v140, 0, 0)
        v91 = 0
        v92 = 0
        v99 = 50 + 2 * v135
        v95 = 0
        v97 = 0
        v98 = 0
        v96 = 0
        v94 = 0.92 + -0.020000000000000018 * v135
        v89 = 0
        v100 = 1 - v137 * 0.1
    elseif elapsedTime < 8.7 then
        local v144 = math.clamp((elapsedTime - 6.699999999999999) / 2, 0, 1)
        local v145 = math.clamp(v144, 0, 1)
        local v146 = v145 * v145 * v145
        local v148 = math.sin(3.141592653589793 * v144)
        local direction = p51.direction
        local v149 = travelDistance * (0.32 + 0.3 * v146)
        local v152 = math.abs((math.sin(v144 * 3.141592653589793 * 2))) * 0.22

        v90 = v86 + direction * v149 + Vector3.new(0, 1, 0) * v152
        v91 = v148 * -0.13962634015954636
        v93 = math.sin(v144 * 3.141592653589793 * 2) * 0.06981317007977318

        local surgeFieldOfView = motionProfile.surgeFieldOfView
        local v154 = math.clamp(v144, 0, 1)
        local v155 = v154 * v154 * (3 - 2 * v154)

        v99 = 52 + (surgeFieldOfView - 52) * v155

        local v156 = math.clamp(v144, 0, 1)

        v95 = 0 + 2.2 * (v156 * v156 * (3 - 2 * v156))

        local v157 = math.clamp(v144, 0, 1)

        v98 = 0.6 + -0.6 * (v157 * v157 * (3 - 2 * v157))

        local v158 = math.clamp(v144, 0, 1)

        v94 = 0.9 + -0.28 * (v158 * v158 * (3 - 2 * v158))

        local v159 = math.clamp(v144, 0, 1)

        v92 = 0
        v97 = 0
        v96 = 0
        v89 = 0
        v100 = 1 + 0.30000000000000004 * (v159 * v159 * (3 - 2 * v159))
    elseif elapsedTime < 10 then
        local v161 = math.clamp((elapsedTime - 8.7) / 1.3, 0, 1)
        local v162 = math.clamp(v161, 0, 1)
        local v163 = 1 - (1 - v162) * (1 - v162) * (1 - v162)
        local v165 = math.sin(3.141592653589793 * v161)
        local direction = p51.direction
        local v166 = travelDistance * (0.62 + 0.09999999999999998 * v163)
        local v167 = Vector3.new(0, 1, 0) * v165

        v90 = v86 + direction * v166 + v167
        v91 = v165 * 0.08726646259971647
        v92 = v165 * -0.10471975511965978
        v93 = math.rad(motionProfile.heroBankDegrees) * v165

        local surgeFieldOfView = motionProfile.surgeFieldOfView
        local v168 = math.clamp(v161, 0, 1)
        local v169 = v168 * v168 * (3 - 2 * v168)

        v99 = surgeFieldOfView + (50 - surgeFieldOfView) * v169

        local v170 = math.clamp(v161, 0, 1)

        v95 = 2.2 + -1.5000000000000002 * (v170 * v170 * (3 - 2 * v170))
        v97 = v165 * 1.1

        local v171 = math.clamp(v161, 0, 1)

        v94 = 0.62 + 0.13 * (v171 * v171 * (3 - 2 * v171))

        local v172 = math.clamp(v161, 0, 1)

        v98 = 0
        v96 = 0
        v89 = 0
        v100 = 1.3 + -0.30000000000000004 * (v172 * v172 * (3 - 2 * v172))
    else
        local v173 = elapsedTime - 10
        local v175 = math.clamp(v173 / 1.5, 0, 1)

        v89 = v175 * v175 * (3 - 2 * v175)

        local v176 = v173 % p51.showcaseLoopDuration
        local v177 = #p51.showcaseSegmentDurations - 1
        local n2 = 0

        for i = 0, v177 do
            local v178 = p51.showcaseSegmentDurations[i + 1]

            if v176 <= v178 then
                n2 = i
                break
            end

            v176 -= v178
        end

        local v179 = #p51.showcaseWaypoints
        local v181 = math.clamp(v176 / p51.showcaseSegmentDurations[n2 + 1], 0, 1)
        local v182 = p51.showcaseWaypoints[((n2 - 1) % v179 + v179) % v179 + 1]
        local v183 = p51.showcaseWaypoints[n2 + 1]
        local v184 = p51.showcaseWaypoints[((n2 + 1) % v179 + v179) % v179 + 1]
        local v185 = p51.showcaseWaypoints[((n2 + 2) % v179 + v179) % v179 + 1]
        local v186 = v181 * v181
        local v187 = v186 * v181
        local v188 = v183 * 2
        local v189 = v182 * 2
        local v190 = v183 * 5
        local v191 = v184 * 4
        local v192 = (v189 - v190 + v191 - v185) * v186
        local v193 = v182 * -1
        local v194 = v183 * 3
        local v195 = v184 * 3
        local v196 = (v193 + v194 - v195 + v185) * v187
        local v199 = (v188 + (v184 - v182) * v181 + v192 + v196) * 0.5 + Vector3.new(0, 1, 0) * (math.sin(v173 * 1.1) * 0.2)

        v90 = Vector3.new(math.clamp(v199.X, p51.showcaseMinimumX, p51.showcaseMaximumX), v199.Y, (math.clamp(v199.Z, p51.showcaseMinimumZ, p51.showcaseMaximumZ)))

        local v202 = v181 * v181
        local v203 = v182 * 2
        local v204 = v183 * 5
        local v205 = v184 * 4
        local v206 = 2 * v181
        local v207 = v182 * -1
        local v208 = v183 * 3
        local v209 = v184 * 3
        local v210 = 3 * v202
        local v211 = (v184 - v182 + (v203 - v204 + v205 - v185) * v206 + (v207 + v208 - v209 + v185) * v210) * 0.5

        if v211.Magnitude > 0.01 then
            direction = v211.Unit
        end

        v91 = math.sin(v173 * 1.1) * 0.03490658503988659
        v93 = -math.rad(motionProfile.heroBankDegrees * 0.35) * math.sin(v173 * 0.8)
        v95 = 0.7 + (p51.showcaseCameraPullback - 0.7) * v89
        v97 = math.sin(v173 * 0.65) * 0.5
        v92 = 0
        v99 = 50
        v98 = 0 + (p51.showcaseCameraVerticalOffset - 0) * v89 + math.sin(v173 * 1.1) * 0.12 * v89
        v96 = 0
        v94 = 0.75 + 0.25 * v89
        v100 = 1
    end

    local v219 = CFrame.lookAt(v90, v90 + direction, (Vector3.new(0, 1, 0))) * CFrame.Angles(v91, v92, v93)

    return {
        cameraFollow = v94,
        cameraFocusPosition = (v219.Position + Vector3.new(0, 1.5, 0)):Lerp(v219:PointToWorldSpace(p51.mountFocusOffset), v89),
        cameraPullback = v95,
        cameraShake = v96,
        cameraSideOffset = v97,
        cameraVerticalOffset = v98,
        cframe = v219,
        fieldOfView = v99,
        mountBodyOffset = v87,
        riderBodyOffset = v88,
        ridingAnimationSpeed = v100
    }
end

function self._showTransition(p52) -- line: 709
    -- upvalues: RuntimeLib (copy), Players (copy), ScreenTransition (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui == nil then
        return RuntimeLib.Promise.resolve()
    end

    if p52._screenTransition == nil then
        p52._screenTransition = ScreenTransition.new(PlayerGui)
    end

    return p52._screenTransition:show()
end

function self._revealPreviewAfterTransition(p53, p54, p55, p56, p57) -- line: 719
    -- upvalues: mountFishPreviewItemNameAtom (copy)
    p56:andThen(function() -- line: 720
        -- upvalues: p53 (copy), p54 (copy), p55 (copy), p57 (copy), mountFishPreviewItemNameAtom (copy)
        if p53._session ~= p54 then
            return nil
        end

        p53:_hideUi()
        task.spawn(function() -- line: 725
            -- upvalues: p53 (copy), p54 (copy), p55 (copy), p57 (copy), mountFishPreviewItemNameAtom (copy)
            if p57 then
                local v220 = os.clock() + 1

                while p53._session == p54 and p53:_hasRenderedPromptGui() and os.clock() < v220 do
                    task.wait()
                end

                if p53._session ~= p54 then
                    return nil
                end

                if p53:_hasRenderedPromptGui() then
                    p53:_destroyRenderedPromptGuis()
                end
            end

            if p53._session ~= p54 then
                return nil
            end

            local v221 = p53:_calculatePreviewPose(p54)

            p53:_applyPreviewPose(p54, v221)
            p54.cameraActive = true
            mountFishPreviewItemNameAtom(p55)
            p53:_applyPreviewCamera(p54, v221, 0, true)
            task.wait()

            if p53._session ~= p54 then
                return nil
            end

            local _screenTransition = p53._screenTransition

            if _screenTransition ~= nil then
                _screenTransition:hide()
            end
        end)
    end)
end

function self._hasRenderedPromptGui(_) -- line: 757
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        PlayerGui = PlayerGui:FindFirstChild("ProximityPrompts")
    end

    if PlayerGui ~= nil then
        local Descendants = PlayerGui:GetDescendants()

        local function v222(p59) -- line: 769
            return p59:IsA("BillboardGui")
        end

        for v223, v224 in Descendants do
            local _ = v223 - 1

            if v224:IsA("BillboardGui") then
                return true
            end
        end
    end

    return false
end

function self._destroyRenderedPromptGuis(_) -- line: 781
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        PlayerGui = PlayerGui:FindFirstChild("ProximityPrompts")
    end

    if PlayerGui == nil then
        return nil
    end

    for _, descendant in PlayerGui:GetDescendants() do
        if descendant:IsA("BillboardGui") then
            descendant:Destroy()
        end
    end
end

function self._applyPreviewCamera(_, p62, p63, p64, p65) -- line: 796
    local v225 = p65 ~= nil and p65

    p62.camera.CameraType = Enum.CameraType.Scriptable
    p62.camera.CameraSubject = nil

    local cameraAnchorCFrame = p62.cameraAnchorCFrame
    local v227 = math.sin(p62.elapsedTime * 27.4) * p63.cameraShake
    local v229 = math.sin(p62.elapsedTime * 34.1 + 0.4) * p63.cameraShake * 0.6
    local cameraAnchorCFramePosition, LookVector = cameraAnchorCFrame.Position, cameraAnchorCFrame.LookVector
    local cameraPullback = p63.cameraPullback
    local RightVector = cameraAnchorCFrame.RightVector
    local v230 = p63.cameraSideOffset + v227
    local v231 = p63.cameraVerticalOffset + v229
    local v232 = cameraAnchorCFramePosition - LookVector * cameraPullback + RightVector * v230 + Vector3.new(0, 1, 0) * v231
    local v233 = p62.focusCenter:Lerp(p63.cameraFocusPosition, p63.cameraFollow)
    local v234 = CFrame.lookAt(v232, v233, (Vector3.new(0, 1, 0)))
    local v235 = if v225 then 1 else 1 - math.exp(-8 * p64)

    p62.camera.CFrame = p62.camera.CFrame:Lerp(v234, v235)

    local camera = p62.camera
    local FieldOfView = p62.camera.FieldOfView

    camera.FieldOfView = FieldOfView + (p63.fieldOfView - FieldOfView) * v235
end

function self._applyPreviewPose(_, p67, p68) -- line: 819
    local mount = p67.mount
    local cframe, mountBodyOffset = p68.cframe, p68.mountBodyOffset
    local v237 = p67.mountSeatOffset:Inverse()

    mount:PivotTo(cframe * mountBodyOffset * v237)
    p67.rig:PivotTo(p68.cframe * p68.riderBodyOffset)
end

function self._hideUi(p69) -- line: 830
    -- upvalues: Players (copy), ProximityPromptService (copy), StarterGui (copy), screenTransitionGuiName (copy)
    p69._proximityPromptsEnabledSnapshot = ProximityPromptService.Enabled
    ProximityPromptService.Enabled = false

    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        local t9 = {
            PlayerGui
        }
        local v238 = #t9
        local Descendants = PlayerGui:GetDescendants()

        table.move(Descendants, 1, #Descendants, v238 + 1, t9)

        for _, v239 in t9 do
            if v239:IsA("ScreenGui") and v239.Name ~= "MountFishPreviewOverlay" and v239.Name ~= screenTransitionGuiName then
                p69._screenGuiSnapshots[v239] = v239.Enabled
                v239.Enabled = false
            end
        end
    end

    for _, v240 in Enum.CoreGuiType:GetEnumItems() do
        if v240 ~= Enum.CoreGuiType.All then
            local function v241() -- line: 853
                -- upvalues: v240 (copy), StarterGui (copy)
                return StarterGui:GetCoreGuiEnabled(v240)
            end

            local ok, result = pcall(v241)

            if ok and type(result) == "boolean" then
                p69._coreGuiSnapshots[v240] = result

                local function v242() -- line: 860
                    -- upvalues: v240 (copy), StarterGui (copy)
                    return StarterGui:SetCoreGuiEnabled(v240, false)
                end

                pcall(v242)
            end
        end
    end
end

function self._restoreUi(p70) -- line: 865
    -- upvalues: ProximityPromptService (copy), StarterGui (copy)
    if p70._proximityPromptsEnabledSnapshot ~= nil then
        ProximityPromptService.Enabled = p70._proximityPromptsEnabledSnapshot
        p70._proximityPromptsEnabledSnapshot = nil
    end

    for v243, v244 in p70._screenGuiSnapshots do
        if v243.Parent ~= nil then
            v243.Enabled = v244
        end
    end

    table.clear(p70._screenGuiSnapshots)

    for v245, v246 in p70._coreGuiSnapshots do
        local function v247() -- line: 877
            -- upvalues: v245 (copy), v246 (copy), StarterGui (copy)
            return StarterGui:SetCoreGuiEnabled(v245, v246)
        end

        pcall(v247)
    end

    table.clear(p70._coreGuiSnapshots)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/mount-fish-preview-controller@MountFishPreviewController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    MountFishPreviewController = self
}
