-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1 = false
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 18
    -- upvalues: v1 (ref), t1 (copy)
    v1 = p3 or false

    local self = setmetatable({}, t1)

    self._screenPart = p1
    self._model = p1.Parent
    self._range = p2
    self._viewDuration = 0
    self._confirmed = false
    self._lastDebugState = ""
    self._raycastParams = RaycastParams.new()
    self._raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    return self
end

function t1:_getDistance() -- line: 32
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        return (self._screenPart.Position - HumanoidRootPart.Position).Magnitude
    end

    return 1e999
end

function t1:_getAngle() -- line: 41
    -- upvalues: CurrentCamera (copy)
    return (math.abs(180 - math.deg((math.acos((math.clamp(self._screenPart.CFrame.LookVector:Dot(CurrentCamera.CFrame.LookVector), -1, 1)))))))
end

function t1:_getCameraDistance() -- line: 48
    -- upvalues: CurrentCamera (copy)
    return (self._screenPart.Position - CurrentCamera.CFrame.Position).Magnitude
end

function t1:_getAngularRatio() -- line: 52
    -- upvalues: CurrentCamera (copy)
    local v7 = self:_getCameraDistance()

    if v7 <= 0 then
        return 1e999
    end

    local X = self._screenPart.Size.X
    local v8 = math.rad(CurrentCamera.FieldOfView)

    return math.atan(X / 2 / v7) * 2 / v8
end

function t1:_getOcclusionCount() -- line: 62
    -- upvalues: Workspace (copy), CurrentCamera (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    self._raycastParams.FilterDescendantsInstances = {
        Character,
        self._model
    }

    local CFramePosition = CurrentCamera.CFrame.Position
    local Size, _CFrame = self._screenPart.Size, self._screenPart.CFrame
    local v10 = Size.X / 2
    local v11 = Size.Y / 2
    local n1 = 0

    for _, v12 in {
            self._screenPart.Position,
            (_CFrame * CFrame.new(-v10, v11, 0)).Position,
            (_CFrame * CFrame.new(v10, v11, 0)).Position,
            (_CFrame * CFrame.new(-v10, -v11, 0)).Position,
            (_CFrame * CFrame.new(v10, -v11, 0)).Position,
            (_CFrame * CFrame.new(-v10 / 2, v11 / 2, 0)).Position,
            (_CFrame * CFrame.new(v10 / 2, v11 / 2, 0)).Position,
            (_CFrame * CFrame.new(-v10 / 2, -v11 / 2, 0)).Position,
            (_CFrame * CFrame.new(v10 / 2, -v11 / 2, 0)).Position
        } do
        if Workspace:Raycast(CFramePosition, v12 - CFramePosition, self._raycastParams) == nil then
            n1 += 1
        end
    end

    return n1
end

function t1:_debugPrint(p10, p11, p12, p13, p14) -- line: 94
    -- upvalues: v1 (ref)
    if not v1 or p10 == self._lastDebugState then
        return
    end

    self._lastDebugState = p10

    local v13 = p11 <= self._range
    local v14 = p12 <= 85
    local v15 = p13 >= 0.1
    local v16 = p14 >= 5

    print(string.format("[Viewability] %s | Dist: %.0f/%d %s | Angle: %.1f°/%d° %s | FOV%%: %.1f%%/%.1f%% %s | Rays: %d/9 %s | Timer: %.1f/%.1fs", p10, p11, self._range, v13 and "OK" or "FAIL", p12, 85, v14 and "OK" or "FAIL", p13 * 100, 10, v15 and "OK" or "FAIL", p14, v16 and "OK" or "FAIL", self._viewDuration, 0.2))
end

function t1:update(p16) -- line: 135
    if self._confirmed then
        return true
    end

    local v17 = self:_getDistance()
    local v18 = self:_getCameraDistance()

    if self._range * 2 < v18 then
        self._viewDuration = 0
        self:_debugPrint("HARD CUTOFF", v18, 0, 0, 0)
    elseif self._range < v17 then
        self._viewDuration = 0
        self:_debugPrint("OUT OF RANGE", v17, 0, 0, 0)
    else
        local v19 = self:_getAngle()
        local v20 = self:_getAngularRatio()
        local v21 = self:_getOcclusionCount()
        local v22 = v19 <= 85
        local v23 = v20 >= 0.1
        local v24 = v21 >= 5

        if v22 then
            if v23 then
                if v24 then
                    self._viewDuration += p16
                    self:_debugPrint(string.format("VALIDATING %.1fs", self._viewDuration), v17, v19, v20, v21)

                    if not (self._viewDuration >= 0.2) then
                        return false
                    end

                    self._confirmed = true
                    self._lastDebugState = ""
                    self:_debugPrint("IMPRESSION CONFIRMED", v17, v19, v20, v21)

                    return true
                end

                self._viewDuration = 0
                self:_debugPrint("FAIL: OCCLUDED", v17, v19, v20, v21)
            else
                self._viewDuration = 0
                self:_debugPrint("FAIL: SIZE", v17, v19, v20, v21)
            end
        else
            self._viewDuration = 0
            self:_debugPrint("FAIL: ANGLE", v17, v19, v20, v21)
        end
    end

    return false
end

function t1:reset() -- line: 193
    -- upvalues: v1 (ref)
    self._viewDuration = 0
    self._confirmed = false
    self._lastDebugState = ""

    if v1 then
        print("[Viewability] RESET — awaiting new impression")
    end
end

function t1:destroy() -- line: 202
    self._screenPart = nil
    self._model = nil
    self._raycastParams = nil
end

return t1
