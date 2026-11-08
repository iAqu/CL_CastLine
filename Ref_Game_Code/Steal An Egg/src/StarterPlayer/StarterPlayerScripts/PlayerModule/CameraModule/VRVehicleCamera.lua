-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function v1() -- line: 9
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end

local ok, result = pcall(v1)
local v2 = ok and result
local t1 = {
    0, 30
}
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))

require(script.Parent:WaitForChild("VehicleCamera"))

local VehicleCameraCore = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local VehicleCameraConfig = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local LocalPlayer = Players.LocalPlayer
local Spring, mapClamp, sanitizeAngle = CameraUtils.Spring, CameraUtils.mapClamp, CameraUtils.sanitizeAngle

local function pitchVelocity(p1, p2) -- line: 46
    return (math.abs((p2.XVector:Dot(p1))))
end

local function yawVelocity(p3, p4) -- line: 51
    return (math.abs((p4.YVector:Dot(p3))))
end

local n1 = 0.016666666666666666
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 59
    -- upvalues: VRBaseCamera (copy), RunService (copy), n1 (ref), self (copy)
    local v7 = setmetatable(VRBaseCamera.new(), self)

    v7:Reset()
    RunService.Stepped:Connect(function(_, p6) -- line: 64
        -- upvalues: n1 (ref)
        n1 = p6
    end)

    return v7
end

function self.Reset(p7) -- line: 72
    -- upvalues: v2 (copy), t1 (copy), CameraUtils (copy), VehicleCameraCore (copy), VehicleCameraConfig (copy), Spring (copy)
    p7.vehicleCameraCore = VehicleCameraCore.new(p7:GetSubjectCFrame())

    if v2 then
        p7.pitchSpring = Spring.new(0, 0)
    else
        p7.pitchSpring = Spring.new(0, -math.rad(VehicleCameraConfig.pitchBaseAngle))
    end

    p7.yawSpring = Spring.new(0, 0)

    if v2 then
        p7.lastPanTick = 0
        p7.currentDriftAngle = 0
        p7.needsReset = true
    end

    local CurrentCamera = workspace.CurrentCamera
    local v8 = CurrentCamera and CurrentCamera.CameraSubject

    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(v8)
    assert(v8:IsA("VehicleSeat"))

    local ConnectedParts = v8:GetConnectedParts(true)
    local v9, v10 = CameraUtils.getLooseBoundingSphere(ConnectedParts)

    p7.assemblyRadius = math.max(v10, 5)
    p7.assemblyOffset = v8.CFrame:Inverse() * v9
    p7.gamepadZoomLevels = {}

    for _, v11 in t1 do
        table.insert(p7.gamepadZoomLevels, v11 * p7.headScale * p7.assemblyRadius / 10)
    end

    p7.lastCameraFocus = nil
    p7:SetCameraToSubjectDistance(p7.gamepadZoomLevels[#p7.gamepadZoomLevels])
end

function self._StepRotation(p8, p9, p10) -- line: 112
    -- upvalues: CameraInput (copy), VehicleCameraConfig (copy), mapClamp (copy), sanitizeAngle (copy)
    local yawSpring, pitchSpring = p8.yawSpring, p8.pitchSpring
    local v13 = -p8:getRotation(p9)

    yawSpring.pos = sanitizeAngle(yawSpring.pos + v13)
    pitchSpring.pos = sanitizeAngle((math.clamp(pitchSpring.pos, -1.3962634015954636, 1.3962634015954636)))

    if CameraInput.getRotationActivated() then
        p8.lastPanTick = os.clock()
    end

    local v14 = math.rad(VehicleCameraConfig.pitchDeadzoneAngle)

    if os.clock() - p8.lastPanTick > VehicleCameraConfig.autocorrectDelay then
        local v15 = mapClamp(p10, VehicleCameraConfig.autocorrectMinCarSpeed, VehicleCameraConfig.autocorrectMaxCarSpeed, 0, VehicleCameraConfig.autocorrectResponse)

        yawSpring.freq = v15
        pitchSpring.freq = v15

        if yawSpring.freq < 0.001 then
            yawSpring.vel = 0
        end

        if pitchSpring.freq < 0.001 then
            pitchSpring.vel = 0
        end

        if math.abs((sanitizeAngle(0 - pitchSpring.pos))) <= v14 then
            pitchSpring.goal = pitchSpring.pos
        else
            pitchSpring.goal = 0
        end
    else
        yawSpring.freq = 0
        yawSpring.vel = 0
        pitchSpring.freq = 0
        pitchSpring.vel = 0
        pitchSpring.goal = 0
    end

    return CFrame.fromEulerAnglesYXZ(pitchSpring:step(p9), yawSpring:step(p9), 0)
end

function self._GetThirdPersonLocalOffset(p11) -- line: 176
    -- upvalues: VehicleCameraConfig (copy)
    return p11.assemblyOffset + Vector3.new(0, p11.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function self._GetFirstPersonLocalOffset(p12, p13) -- line: 180
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")

        if Head and Head:IsA("BasePart") then
            return p13:Inverse() * Head.Position
        end
    end

    return p12:_GetThirdPersonLocalOffset()
end

function self.Update(p14) -- line: 194
    -- upvalues: v2 (copy), VRService (copy), LocalPlayer (copy), n1 (ref)
    if not v2 then
        return p14:UpdateComfortCamera()
    end

    local v18 = n1

    n1 = 0
    p14:UpdateFadeFromBlack(v18)
    p14:UpdateEdgeBlur(LocalPlayer, v18)

    if VRService.ThirdPersonFollowCamEnabled then
        local v19, v20 = p14:UpdateStepRotation(v18)

        return v19, v20
    end

    local v21, v22 = p14:UpdateComfortCamera(v18)

    return v21, v22
end

function self.addDrift(p15, p16, p17) -- line: 217
    -- upvalues: VRService (copy), LocalPlayer (copy)
    local function NormalizeAngle(p18) -- line: 218
        local v23 = (p18 + 12.566370614359172) % 6.283185307179586

        if v23 > 3.141592653589793 then
            v23 -= 6.283185307179586
        end

        return v23
    end

    local CurrentCamera = workspace.CurrentCamera
    local CameraToSubjectDistance = p15:GetCameraToSubjectDistance()
    local SubjectVelocity = p15:GetSubjectVelocity()
    local SubjectCFrame = p15:GetSubjectCFrame()

    require(LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))

    if not (SubjectVelocity.Magnitude > 0.1) then
        local v24 = p16

        return v24, p17
    end

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v25 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
    local v26 = CurrentCamera.CFrame * v25
    local _, v27 = v26:ToEulerAnglesYXZ()
    local _, v28 = SubjectCFrame:ToEulerAnglesYXZ()
    local v29 = (v27 - p15.currentDriftAngle + 12.566370614359172) % 6.283185307179586

    if v29 > 3.141592653589793 then
        v29 -= 6.283185307179586
    end

    local v30 = (v28 - p15.currentDriftAngle + 12.566370614359172) % 6.283185307179586

    if v30 > 3.141592653589793 then
        v30 -= 6.283185307179586
    end

    local v31 = math.min(v30, v29)
    local v32 = math.max(v30, v29)

    if not (v31 > 0) then
        v31 = if v32 < 0 then v32 else 0
    end

    p15.currentDriftAngle = v31 + p15.currentDriftAngle

    local LookVector = CFrame.fromEulerAnglesYXZ(0, p15.currentDriftAngle, 0).LookVector
    local v33 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance
    local v34 = p17.Position - v33

    return p16:Lerp(CFrame.new(CurrentCamera.CFrame.Position + v34 - v26.Position) * CurrentCamera.CFrame.Rotation, 0.01), p17
end

function self.UpdateRotationCamera(p19, p20) -- line: 275
    -- upvalues: LocalPlayer (copy), mapClamp (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v35 = CurrentCamera and CurrentCamera.CameraSubject
    local vehicleCameraCore = p19.vehicleCameraCore

    assert(CurrentCamera)
    assert(v35)
    assert(v35:IsA("VehicleSeat"))

    local SubjectCFrame = p19:GetSubjectCFrame()
    local SubjectVelocity = p19:GetSubjectVelocity()
    local SubjectRotVelocity = p19:GetSubjectRotVelocity()
    local v37 = math.abs((SubjectVelocity:Dot(SubjectCFrame.ZVector)))
    local v39 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))
    local v41 = math.abs((SubjectCFrame.XVector:Dot(SubjectRotVelocity)))
    local CameraToSubjectDistance = p19:GetCameraToSubjectDistance()
    local v42 = mapClamp(CameraToSubjectDistance, 0.5, p19.assemblyRadius, 1, 0)
    local v43 = p19:_GetThirdPersonLocalOffset():Lerp(p19:_GetFirstPersonLocalOffset(SubjectCFrame), v42)

    vehicleCameraCore:setTransform(SubjectCFrame)

    local v44 = vehicleCameraCore:step(p20, v41, v39, v42)
    local v45 = p19:_StepRotation(p20, v37)
    local v46 = p19:GetVRFocus(SubjectCFrame * v43, p20) * v44 * v45
    local v47 = v46 * CFrame.new(0, 0, CameraToSubjectDistance)

    if SubjectVelocity.Magnitude > 0.1 then
        p19:StartVREdgeBlur(LocalPlayer)
    end

    return v47, v46
end

function self.UpdateStepRotation(p21, p22) -- line: 322
    -- upvalues: UserGameSettings (copy), VRService (copy), LocalPlayer (copy), mapClamp (copy)
    local CurrentCamera = workspace.CurrentCamera
    local lastSubjectCFrame = p21.lastSubjectCFrame
    local SubjectCFrame = p21:GetSubjectCFrame()
    local SubjectVelocity = p21:GetSubjectVelocity()
    local CameraToSubjectDistance = p21:GetCameraToSubjectDistance()
    local v48 = mapClamp(CameraToSubjectDistance, 0.5, p21.assemblyRadius, 1, 0)
    local v49 = p21:_GetThirdPersonLocalOffset():Lerp(p21:_GetFirstPersonLocalOffset(SubjectCFrame), v48)
    local VRFocus = p21:GetVRFocus(SubjectCFrame * v49, p22)
    local v50, v51 = p21:addDrift(VRFocus:ToWorldSpace(p21:GetVRFocus(lastSubjectCFrame * v49, p22):ToObjectSpace(CurrentCamera.CFrame)), VRFocus)
    local v52 = p21:getRotation(p22)

    if math.abs(v52) > 0 then
        local v53 = v51:ToObjectSpace(v50)
        local v54 = v51 * CFrame.Angles(0, -v52, 0) * v53

        if not UserGameSettings.VRSmoothRotationEnabled then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v55 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local v56 = v51 * SubjectCFrame.Rotation
            local v57 = v56:ToObjectSpace(v50 * v55)
            local v59 = math.acos((Vector3.new(v57.X, 0, v57.Z).Unit:Dot((Vector3.new(0, 0, 1)))))
            local v60 = v56:ToObjectSpace(v54 * v55)

            if math.acos((Vector3.new(v60.X, 0, v60.Z).Unit:Dot((Vector3.new(0, 0, 1))))) < v59 then
                if v52 < 0 then
                    v59 *= -1
                end

                v54 = v51 * CFrame.Angles(0, -v59, 0) * v53
            end
        end

        v50 = v54
    end

    if SubjectVelocity.Magnitude > 0.1 then
        p21:StartVREdgeBlur(LocalPlayer)
    end

    if p21.needsReset then
        p21.needsReset = false
        VRService:RecenterUserHeadCFrame()
        p21:StartFadeFromBlack()
        p21:ResetZoom()
    end

    if p21.recentered then
        v50 = v51 * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance)
        p21.recentered = false
    end

    return v50, v50 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

function self.UpdateComfortCamera(p23, p24) -- line: 408
    -- upvalues: v2 (copy), LocalPlayer (copy), mapClamp (copy), n1 (ref)
    local CurrentCamera = workspace.CurrentCamera
    local v62 = CurrentCamera and CurrentCamera.CameraSubject
    local vehicleCameraCore = p23.vehicleCameraCore

    assert(CurrentCamera)
    assert(v62)
    assert(v62:IsA("VehicleSeat"))

    local v63

    if v2 then
        v63 = p24
    else
        v63 = n1
        n1 = 0
    end

    local SubjectCFrame = p23:GetSubjectCFrame()
    local SubjectVelocity = p23:GetSubjectVelocity()
    local SubjectRotVelocity = p23:GetSubjectRotVelocity()

    math.abs((SubjectVelocity:Dot(SubjectCFrame.ZVector)))

    local v66 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))
    local v68 = math.abs((SubjectCFrame.XVector:Dot(SubjectRotVelocity)))
    local v69 = p23:StepZoom()
    local v70 = mapClamp(v69, 0.5, p23.assemblyRadius, 1, 0)
    local v71 = p23:_GetThirdPersonLocalOffset():Lerp(p23:_GetFirstPersonLocalOffset(SubjectCFrame), v70)

    vehicleCameraCore:setTransform(SubjectCFrame)

    local v72 = vehicleCameraCore:step(v63, v68, v66, v70)

    if not v2 then
        p23:UpdateFadeFromBlack(v63)
    end

    local v73, v74

    if p23:IsInFirstPerson() then
        local Unit = Vector3.new(v72.LookVector.X, 0, v72.LookVector.Z).Unit
        local v75 = CFrame.new(v72.Position, Unit)

        v73 = CFrame.new(SubjectCFrame * v71) * v75
        v74 = v73 * CFrame.new(0, 0, v69)

        if v2 then
            if SubjectVelocity.Magnitude > 0.1 then
                p23:StartVREdgeBlur(LocalPlayer)

                return v74, v73
            end
        else
            p23:StartVREdgeBlur(LocalPlayer)
        end
    else
        v73 = CFrame.new(SubjectCFrame * v71) * v72
        v74 = v73 * CFrame.new(0, 0, v69)

        if not p23.lastCameraFocus then
            p23.lastCameraFocus = v73
            p23.needsReset = true
        end

        local v76 = v73.Position - CurrentCamera.CFrame.Position
        local magnitude = v76.magnitude

        if v76.Unit:Dot(CurrentCamera.CFrame.LookVector) > 0.56 and magnitude < 200 and not p23.needsReset then
            v73 = p23.lastCameraFocus

            local p = v73.p
            local CameraLookVector = p23:GetCameraLookVector()
            local v77 = p23:CalculateNewLookVectorFromArg(Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit, Vector2.new(0, 0))

            v74 = CFrame.new(p - v69 * v77, p)
        else
            p23.lastCameraFocus = p23:GetVRFocus(SubjectCFrame.Position, v63)
            p23.needsReset = false
            p23:StartFadeFromBlack()
            p23:ResetZoom()
        end

        if not v2 then
            p23:UpdateEdgeBlur(LocalPlayer, v63)

            return v74, v73
        end
    end

    return v74, v73
end

return self
