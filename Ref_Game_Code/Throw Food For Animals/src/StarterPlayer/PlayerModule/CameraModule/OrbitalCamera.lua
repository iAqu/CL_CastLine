-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserFixOrbitalCameraAzimuth = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserFixOrbitalCameraAzimuth")

require(script.Parent:WaitForChild("CameraUtils"))

local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 33
    -- upvalues: BaseCamera (copy), self (copy)
    local v3 = setmetatable(BaseCamera.new(), self)

    v3.lastUpdate = tick()
    v3.changedSignalConnections = {}
    v3.refAzimuthRad = nil
    v3.curAzimuthRad = nil
    v3.minAzimuthAbsoluteRad = nil
    v3.maxAzimuthAbsoluteRad = nil
    v3.useAzimuthLimits = nil
    v3.curElevationRad = nil
    v3.minElevationRad = nil
    v3.maxElevationRad = nil
    v3.curDistance = nil
    v3.minDistance = nil
    v3.maxDistance = nil
    v3.gamepadDollySpeedMultiplier = 1
    v3.lastUserPanCamera = tick()
    v3.externalProperties = {}
    v3.externalProperties.InitialDistance = 25
    v3.externalProperties.MinDistance = 10
    v3.externalProperties.MaxDistance = 100
    v3.externalProperties.InitialElevation = 35
    v3.externalProperties.MinElevation = 35
    v3.externalProperties.MaxElevation = 35
    v3.externalProperties.ReferenceAzimuth = -45
    v3.externalProperties.CWAzimuthTravel = 90
    v3.externalProperties.CCWAzimuthTravel = 90
    v3.externalProperties.UseAzimuthLimits = false
    v3:LoadNumberValueParameters()

    return v3
end

function self.LoadOrCreateNumberValueParameter(p1, p2, p3, p4) -- line: 72
    local v4 = script:FindFirstChild(p2)

    if not (v4 and v4:IsA(p3)) then
        if p1.externalProperties[p2] == nil then
            return
        end

        v4 = Instance.new(p3)
        v4.Name = p2
        v4.Parent = script
        v4.Value = p1.externalProperties[p2]
    else
        p1.externalProperties[p2] = v4.Value
    end

    if not p4 then
        return
    end

    if p1.changedSignalConnections[p2] then
        p1.changedSignalConnections[p2]:Disconnect()
    end

    p1.changedSignalConnections[p2] = v4.Changed:Connect(function(p5) -- line: 92
        -- upvalues: p1 (copy), p2 (copy), p4 (copy)
        p1.externalProperties[p2] = p5
        p4(p1)
    end)
end

function self.SetAndBoundsCheckAzimuthValues(p6) -- line: 99
    p6.minAzimuthAbsoluteRad = math.rad(p6.externalProperties.ReferenceAzimuth) - math.abs((math.rad(p6.externalProperties.CWAzimuthTravel)))
    p6.maxAzimuthAbsoluteRad = math.rad(p6.externalProperties.ReferenceAzimuth) + math.abs((math.rad(p6.externalProperties.CCWAzimuthTravel)))
    p6.useAzimuthLimits = p6.externalProperties.UseAzimuthLimits

    if p6.useAzimuthLimits then
        p6.curAzimuthRad = math.max(p6.curAzimuthRad, p6.minAzimuthAbsoluteRad)
        p6.curAzimuthRad = math.min(p6.curAzimuthRad, p6.maxAzimuthAbsoluteRad)
    end
end

function self.SetAndBoundsCheckElevationValues(p7) -- line: 109
    local v9 = math.max(p7.externalProperties.MinElevation, -80)
    local v10 = math.min(p7.externalProperties.MaxElevation, 80)

    p7.minElevationRad = math.rad((math.min(v9, v10)))
    p7.maxElevationRad = math.rad((math.max(v9, v10)))
    p7.curElevationRad = math.max(p7.curElevationRad, p7.minElevationRad)
    p7.curElevationRad = math.min(p7.curElevationRad, p7.maxElevationRad)
end

function self.SetAndBoundsCheckDistanceValues(p8) -- line: 125
    p8.minDistance = p8.externalProperties.MinDistance
    p8.maxDistance = p8.externalProperties.MaxDistance
    p8.curDistance = math.max(p8.curDistance, p8.minDistance)
    p8.curDistance = math.min(p8.curDistance, p8.maxDistance)
end

function self.LoadNumberValueParameters(p9) -- line: 133
    -- upvalues: UserFixOrbitalCameraAzimuth (copy)
    p9:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    p9:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    p9:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", if UserFixOrbitalCameraAzimuth then p9.SetAndBoundsCheckAzimuthValues else p9.SetAndBoundsCheckAzimuthValue)
    p9:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p9.SetAndBoundsCheckAzimuthValues)
    p9:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p9.SetAndBoundsCheckAzimuthValues)
    p9:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p9.SetAndBoundsCheckElevationValues)
    p9:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p9.SetAndBoundsCheckElevationValues)
    p9:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p9.SetAndBoundsCheckDistanceValues)
    p9:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p9.SetAndBoundsCheckDistanceValues)
    p9:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p9.SetAndBoundsCheckAzimuthValues)
    p9.curAzimuthRad = math.rad(p9.externalProperties.ReferenceAzimuth)
    p9.curElevationRad = math.rad(p9.externalProperties.InitialElevation)
    p9.curDistance = p9.externalProperties.InitialDistance
    p9:SetAndBoundsCheckAzimuthValues()
    p9:SetAndBoundsCheckElevationValues()
    p9:SetAndBoundsCheckDistanceValues()
end

function self.GetModuleName(_) -- line: 159
    return "OrbitalCamera"
end

function self.GetCameraToSubjectDistance(p11) -- line: 164
    return p11.curDistance
end

function self.SetCameraToSubjectDistance(p12, p13) -- line: 168
    -- upvalues: Players (copy)
    if Players.LocalPlayer then
        p12.currentSubjectDistance = math.clamp(p13, p12.minDistance, p12.maxDistance)
        p12.currentSubjectDistance = math.max(p12.currentSubjectDistance, p12.FIRST_PERSON_DISTANCE_THRESHOLD)
    end

    p12.inFirstPerson = false
    p12:UpdateMouseBehavior()

    return p12.currentSubjectDistance
end

function self.CalculateNewLookVector(p14, p15, p16) -- line: 181
    p15 = p15 or p14:GetCameraLookVector()

    local v14 = math.asin(p15.Y)
    local v17 = math.clamp(p16.Y, v14 - 1.3962634015954636, v14 - -1.3962634015954636)
    local v18 = Vector2.new(p16.X, v17)
    local v19 = CFrame.new(Vector3.new(0, 0, 0), p15)

    return (CFrame.Angles(0, -v18.X, 0) * v19 * CFrame.Angles(-v18.Y, 0, 0)).LookVector
end

function self.Update(p17, p18) -- line: 192
    -- upvalues: CameraInput (copy), Players (copy)
    local v20 = tick()
    local v21 = v20 - p17.lastUpdate
    local v22 = CameraInput.getRotation(p18) ~= Vector2.new()
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame, Focus = CurrentCamera.CFrame, CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v23 = CurrentCamera and CurrentCamera.CameraSubject
    local v24, v25

    if v23 then
        v24 = v23:IsA("VehicleSeat")
        v25 = v23:IsA("SkateboardPlatform")
    else
        v25 = v23
        v24 = v23
    end

    if p17.lastUpdate == nil or v21 > 1 then
        p17.lastCameraTransform = nil
    end

    if v22 then
        p17.lastUserPanCamera = tick()
    end

    local SubjectPosition = p17:GetSubjectPosition()
    local v26, v27

    if SubjectPosition and LocalPlayer and CurrentCamera then
        if p17.gamepadDollySpeedMultiplier ~= 1 then
            p17:SetCameraToSubjectDistance(p17.currentSubjectDistance * p17.gamepadDollySpeedMultiplier)
        end

        v26 = CFrame.new(SubjectPosition)

        local v28 = CameraInput.getRotation(p18)

        p17.curAzimuthRad -= v28.X

        if p17.useAzimuthLimits then
            p17.curAzimuthRad = math.clamp(p17.curAzimuthRad, p17.minAzimuthAbsoluteRad, p17.maxAzimuthAbsoluteRad)
        elseif p17.curAzimuthRad == 0 then
            p17.curAzimuthRad = 0
        else
            p17.curAzimuthRad = math.sign(p17.curAzimuthRad) * (math.abs(p17.curAzimuthRad) % 6.283185307179586) or 0
        end

        p17.curElevationRad = math.clamp(p17.curElevationRad + v28.Y, p17.minElevationRad, p17.maxElevationRad)

        local v31 = SubjectPosition + p17.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-p17.curElevationRad, p17.curAzimuthRad, 0) * Vector3.new(0, 0, 1))

        v27 = CFrame.new(v31, SubjectPosition)
        p17.lastCameraTransform = v27
        p17.lastCameraFocus = v26

        if (v24 or v25) and v23:IsA("BasePart") then
            p17.lastSubjectCFrame = v23.CFrame
        else
            p17.lastSubjectCFrame = nil
        end
    else
        v26 = Focus
        v27 = _CFrame
    end

    p17.lastUpdate = v20

    return v27, v26
end

return self
