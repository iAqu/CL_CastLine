-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent:WaitForChild("CameraUtils"))

local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 22
    -- upvalues: BaseCamera (copy), self (copy)
    local v3 = setmetatable(BaseCamera.new(), self)

    v3.cameraType = Enum.CameraType.Fixed
    v3.lastUpdate = tick()
    v3.lastDistanceToSubject = nil

    return v3
end

function self.GetModuleName(_) -- line: 32
    return "LegacyCamera"
end

function self.Update(p2, p3) -- line: 36
    -- upvalues: CameraInput (copy), Players (copy)
    if not p2.cameraType then
        return nil, nil
    end

    local v4 = tick()
    local v5 = v4 - p2.lastUpdate
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame, Focus = CurrentCamera.CFrame, CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v6 = CameraInput.getRotation(p3)

    if p2.lastUpdate == nil or v5 > 1 then
        p2.lastDistanceToSubject = nil
    end

    local SubjectPosition = p2:GetSubjectPosition()

    if p2.cameraType == Enum.CameraType.Fixed then
        if SubjectPosition and LocalPlayer and CurrentCamera then
            local CameraToSubjectDistance = p2:GetCameraToSubjectDistance()
            local v7 = p2:CalculateNewLookVectorFromArg(nil, v6)

            Focus = CurrentCamera.Focus
            _CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + CameraToSubjectDistance * v7)
        end
    elseif p2.cameraType == Enum.CameraType.Attach then
        local SubjectCFrame = p2:GetSubjectCFrame()
        local v8 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
        local _, v9 = SubjectCFrame:ToEulerAnglesYXZ()
        local v11 = math.clamp(v8 - v6.Y, -1.3962634015954636, 1.3962634015954636)

        Focus = CFrame.new(SubjectCFrame.Position) * CFrame.fromEulerAnglesYXZ(v11, v9, 0)
        _CFrame = Focus * CFrame.new(0, 0, p2:StepZoom(p3))
    else
        if p2.cameraType ~= Enum.CameraType.Watch then
            return CurrentCamera.CFrame, CurrentCamera.Focus
        end

        if SubjectPosition and LocalPlayer and CurrentCamera then
            if SubjectPosition == CurrentCamera.CFrame.Position then
                warn("Camera cannot watch subject in same position as itself")

                return CurrentCamera.CFrame, CurrentCamera.Focus
            end

            local Humanoid = p2:GetHumanoid()
            local unit

            if Humanoid and Humanoid.RootPart then
                local v12 = SubjectPosition - CurrentCamera.CFrame.Position

                unit = v12.unit

                if p2.lastDistanceToSubject and p2.lastDistanceToSubject == p2:GetCameraToSubjectDistance() then
                    p2:SetCameraToSubjectDistance(v12.magnitude)
                end
            end

            local CameraToSubjectDistance = p2:GetCameraToSubjectDistance()
            local v13 = p2:CalculateNewLookVectorFromArg(unit, v6)

            Focus = CFrame.new(SubjectPosition)
            _CFrame = CFrame.new(SubjectPosition - CameraToSubjectDistance * v13, SubjectPosition)
            p2.lastDistanceToSubject = CameraToSubjectDistance
        end
    end

    p2.lastUpdate = v4

    return _CFrame, Focus
end

return self
