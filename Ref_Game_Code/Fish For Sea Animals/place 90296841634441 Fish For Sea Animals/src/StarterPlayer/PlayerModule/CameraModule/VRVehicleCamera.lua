-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    0, 30
}
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local mapClamp = CameraUtils.mapClamp
local VehicleCameraConfig = require(script.Parent:WaitForChild("VehicleCamera"):FindFirstChild("VehicleCameraConfig"))
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude
v1.IgnoreWater = true

local function yawVelocity(p1, p2) -- line: 37
    return (math.abs((p2.YVector:Dot(p1))))
end

local function computeCameraCFrame(p3, p4, p5) -- line: 41
    local v3 = math.atan2(p4.X, p4.Z)

    return CFrame.new(p3.Position + p4 * p5) * CFrame.Angles(0, v3, 0)
end

local function vrOccludeDisplace(p6, p7, p8, p9) -- line: 46
    -- upvalues: LocalPlayer (copy), v1 (copy)
    local v4 = math.atan2(p7.X, p7.Z)
    local v5 = CFrame.new(p6.Position + p7 * p8) * CFrame.Angles(0, v4, 0)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p6.Position
        local v6 = (v5.Position - Position) * Vector3.new(1, 0, 1)
        local Magnitude = v6.Magnitude

        if not (Magnitude < 0.5) then
            local t2 = {
                CurrentCamera
            }

            if p9 then
                table.insert(t2, p9)
            end

            local v7 = LocalPlayer and LocalPlayer.Character

            if v7 then
                table.insert(t2, v7)
            end

            v1.FilterDescendantsInstances = t2

            local Unit = v6.Unit
            local v8 = workspace:Raycast(Position, v6, v1)

            if v8 and v8.Normal:Dot(Unit) < 0 then
                local v9 = (v8.Position - Position).Magnitude - 0.5

                if v9 < Magnitude then
                    local v10 = math.max(v9, 0.5)

                    return CFrame.new(p6.Position + Unit * v10) * v5.Rotation
                end
            end
        end
    end

    return v5
end

local v11 = OverlapParams.new()

v11.FilterType = Enum.RaycastFilterType.Exclude

local function findObstructions(p10, p11, p12, p13) -- line: 82
    -- upvalues: VRService (copy), LocalPlayer (copy), v1 (copy), v11 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p11.Position
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local HeadScale = CurrentCamera.HeadScale
        local v12 = p10 * (CFrame.new(UserCFrame.Position * HeadScale) * UserCFrame.Rotation)
        local v13 = v12.Position - Position
        local Magnitude = v13.Magnitude

        if not (Magnitude < 0.5) then
            local t3 = {
                CurrentCamera
            }

            if p13 then
                table.insert(t3, p13)
            end

            local v14 = LocalPlayer and LocalPlayer.Character

            if v14 then
                table.insert(t3, v14)
            end

            v1.FilterDescendantsInstances = t3

            local v15 = workspace:Raycast(Position, v13, v1)

            if v15 then
                local Magnitude2 = (v15.Position - Position).Magnitude

                if Magnitude2 < Magnitude then
                    local LookVector = v12.LookVector
                    local v19 = math.max(math.clamp((1 - -v13.Unit:Dot(LookVector)) / 0.1339745962155613, 0, 1), 1 - Magnitude2 / p12, 0.15)
                    local Position = v15.Position
                    local Position2 = v12.Position
                    local v20 = (Position + Position2) / 2
                    local v21 = Vector3.new(2, 2, (Position2 - Position).Magnitude)
                    local v22 = CFrame.lookAt(v20, Position2)

                    v11.FilterDescendantsInstances = t3

                    return v19, (workspace:GetPartBoundsInBox(v22, v21, v11))
                end
            end
        end
    end

    return 0, {}
end

local n1 = 0.016666666666666666
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 139
    -- upvalues: VRBaseCamera (copy), RunService (copy), n1 (ref), self (copy)
    local v25 = setmetatable(VRBaseCamera.new(), self)

    v25.skipOcclusion = true
    v25:Reset()

    if v25.thirdPersonOptionChanged then
        v25.thirdPersonOptionChanged:Disconnect()
        v25.thirdPersonOptionChanged = nil
    end

    RunService.Stepped:Connect(function(_, p15) -- line: 149
        -- upvalues: n1 (ref)
        n1 = p15
    end)

    return v25
end

function self.Reset(p16) -- line: 156
    -- upvalues: t1 (copy), CameraUtils (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v26 = CurrentCamera and CurrentCamera.CameraSubject

    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(v26)
    assert(v26:IsA("VehicleSeat"))
    p16.lastOrbitalDir = nil
    p16.wasInFirstPerson = nil

    local ConnectedParts = v26:GetConnectedParts(true)

    table.insert(ConnectedParts, v26)

    local v27, v28 = CameraUtils.getLooseBoundingSphere(ConnectedParts)

    p16.vehicleModel = v26:FindFirstAncestorOfClass("Model") or v26.Parent
    p16.assemblyRadius = math.max(v28, 5)
    p16.assemblyOffset = v26.CFrame:Inverse() * v27
    p16.gamepadZoomLevels = {}

    for _, v29 in t1 do
        table.insert(p16.gamepadZoomLevels, v29 * p16.headScale * p16.assemblyRadius / 10)
    end

    p16.lastCameraFocus = nil

    if not p16:IsInFirstPerson() then
        p16:SetCameraToSubjectDistance(p16.gamepadZoomLevels[#p16.gamepadZoomLevels])
    end

    p16.needsReset = false
end

function self._getThirdPersonLocalOffset(p17) -- line: 190
    -- upvalues: VehicleCameraConfig (copy)
    return p17.assemblyOffset + Vector3.new(0, p17.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function self._getFirstPersonLocalOffset(p18, p19) -- line: 194
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")

        if Head and Head:IsA("BasePart") then
            return p19:Inverse() * Head.Position
        end
    end

    return p18:_getThirdPersonLocalOffset()
end

function self._vrOccludeVignette(p20, p21, p22, p23) -- line: 208
    -- upvalues: Lighting (copy), LocalPlayer (copy), findObstructions (copy)
    local v32 = math.atan2(p22.X, p22.Z)
    local v33 = CFrame.new(p21.Position + p22 * p23) * CFrame.Angles(0, v32, 0)
    local v34, v35 = findObstructions(v33, p21, p23, p20.vehicleModel)
    local VRFade = Lighting:FindFirstChild("VRFade")

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect")
        VRFade.Name = "VRFade"
        VRFade.Parent = Lighting
    end

    VRFade.Brightness = -v34

    if p20.lastOccludedParts then
        for _, v36 in p20.lastOccludedParts do
            v36.LocalTransparencyModifier = 0
        end
    end

    if #v35 > 0 then
        for _, v37 in v35 do
            v37.LocalTransparencyModifier = 1
        end

        p20:StartVREdgeBlur(LocalPlayer, true)
    end

    p20.lastOccludedParts = v35

    return v33
end

function self.Update(p24) -- line: 235
    -- upvalues: LocalPlayer (copy), n1 (ref)
    local v38 = n1

    n1 = 0
    p24:UpdateFadeFromBlack(v38)
    p24:UpdateEdgeBlur(LocalPlayer, v38)

    local v39, v40 = p24:_updateStepRotation(v38)

    return v39, v40
end

function self._updateStepRotation(p25, p26) -- line: 247
    -- upvalues: CameraInput (copy), mapClamp (copy), VehicleCameraConfig (copy), vrOccludeDisplace (copy)
    local SubjectCFrame = p25:GetSubjectCFrame()
    local CameraToSubjectDistance = p25:GetCameraToSubjectDistance()
    local v41 = mapClamp(CameraToSubjectDistance, 0.5, p25.assemblyRadius, 1, 0)
    local v42 = SubjectCFrame * p25:_getThirdPersonLocalOffset():Lerp(p25:_getFirstPersonLocalOffset(SubjectCFrame), v41)
    local v43 = CFrame.new(v42 + Vector3.new(0, p25:GetCameraHeight(), 0))

    if p25.needsReset or p25.recentered then
        p25.lastOrbitalDir = nil
        p25.needsReset = false
        p25.recentered = false
    end

    local lastOrbitalDir = p25.lastOrbitalDir

    if not lastOrbitalDir then
        lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
        p25:StartFadeFromBlack()
    end

    local v44 = (p25:GetSubjectVelocity() * Vector3.new(1, 0, 1)).Magnitude > 2

    if v44 then
        CameraInput.getRotation(p26)
    else
        local v45 = p25:getRotation(p26)

        if math.abs(v45) > 0 then
            lastOrbitalDir = (CFrame.Angles(0, -v45, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            p25.lastRotateTime = os.clock()
        end
    end

    local v46

    if p25:IsInFirstPerson() then
        if not p25.wasInFirstPerson or v44 then
            lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            p25.wasInFirstPerson = true
        end

        local v49 = math.atan2(-SubjectCFrame.LookVector.X, -SubjectCFrame.LookVector.Z)

        if p25.lastVehicleYaw then
            local v50 = (v49 - p25.lastVehicleYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            if math.abs(v50) > 0.001 then
                lastOrbitalDir = (CFrame.Angles(0, v50, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            end
        end

        p25.lastVehicleYaw = v49

        local v51 = math.atan2(lastOrbitalDir.X, lastOrbitalDir.Z)

        v46 = CFrame.new(v43.Position + lastOrbitalDir * CameraToSubjectDistance) * CFrame.Angles(0, v51, 0)
    else
        p25.wasInFirstPerson = false
        p25.lastVehicleYaw = nil

        local v52 = p25.lastRotateTime and os.clock() - p25.lastRotateTime < VehicleCameraConfig.autocorrectDelay

        if v44 and not v52 then
            local Unit = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            local v55 = math.acos((math.clamp(lastOrbitalDir:Dot(Unit), -1, 1)))
            local SubjectRotVelocity = p25:GetSubjectRotVelocity()
            local v57 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))

            lastOrbitalDir = lastOrbitalDir:Lerp(Unit, (math.min(0.01 + v55 / 3.141592653589793 * 0.05 + v57 * 0.02, 0.15)))
        end

        v46 = vrOccludeDisplace(v43, lastOrbitalDir, CameraToSubjectDistance, p25.vehicleModel)
    end

    p25.lastOrbitalDir = lastOrbitalDir

    return v46, v46 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

return self
