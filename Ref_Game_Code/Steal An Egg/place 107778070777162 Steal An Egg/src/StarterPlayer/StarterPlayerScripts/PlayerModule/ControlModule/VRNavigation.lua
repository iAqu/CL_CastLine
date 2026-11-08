-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local v1
local LocalPlayer = Players.LocalPlayer
local v2 = RaycastParams.new()

v2.FilterType = Enum.RaycastFilterType.Exclude

local UserRaycastUpdateAPI = FlagUtil.getUserFlag("UserRaycastUpdateAPI")

local function IsFinite(p1) -- line: 42
    if p1 ~= p1 or p1 == 1e999 then
        return false
    end

    return p1 ~= (-1e999)
end

local function IsFiniteVector3(p2) -- line: 46
    local x = p2.x
    local v3 = x == x and x ~= 1e999 and x ~= (-1e999)

    if not v3 then
        return v3
    end

    local y = p2.y
    local v4 = y == y and y ~= 1e999 and y ~= (-1e999)

    if not v4 then
        return v4
    end

    local z = p2.z

    if z ~= z or z == 1e999 then
        return false
    end

    return z ~= (-1e999)
end

local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "MovementUpdate"
BindableEvent.Parent = script
coroutine.wrap(function() -- line: 54
    -- upvalues: v1 (ref)
    local PathDisplay = script.Parent:WaitForChild("PathDisplay")

    if PathDisplay then
        v1 = require(PathDisplay)
    end
end)()

local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new(p3) -- line: 67
    -- upvalues: BaseCharacterController (copy), self (copy)
    local v7 = setmetatable(BaseCharacterController.new(), self)

    v7.CONTROL_ACTION_PRIORITY = p3
    v7.navigationRequestedConn = nil
    v7.heartbeatConn = nil
    v7.currentDestination = nil
    v7.currentPath = nil
    v7.currentPoints = nil
    v7.currentPointIdx = 0
    v7.expectedTimeToNextPoint = 0
    v7.timeReachedLastPoint = tick()
    v7.moving = false
    v7.isJumpBound = false
    v7.moveLatch = false
    v7.userCFrameEnabledConn = nil

    return v7
end

function self.SetLaserPointerMode(_, p5) -- line: 92
    -- upvalues: StarterGui (copy)
    local function v8() -- line: 93
        -- upvalues: p5 (copy), StarterGui (copy)
        StarterGui:SetCore("VRLaserPointerMode", p5)
    end

    pcall(v8)
end

function self.GetLocalHumanoid(_) -- line: 98
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("Humanoid") then
                return child
            end
        end

        return nil
    end
end

function self.HasBothHandControllers(_) -- line: 112
    -- upvalues: VRService (copy)
    return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function self.HasAnyHandControllers(_) -- line: 116
    -- upvalues: VRService (copy)
    return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function self.IsMobileVR(_) -- line: 120
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled
end

function self.HasGamepad(_) -- line: 124
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled
end

function self.ShouldUseNavigationLaser(p11) -- line: 128
    if p11:IsMobileVR() then
        return true
    end

    if p11:HasBothHandControllers() then
        return false
    end

    if p11:HasAnyHandControllers() then
        return true
    end

    return not p11:HasGamepad()
end

function self.StartFollowingPath(p12, p13) -- line: 150
    -- upvalues: BindableEvent (copy)
    currentPath = p13
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()

    local LocalHumanoid = p12:GetLocalHumanoid()

    if LocalHumanoid and LocalHumanoid.Torso and #currentPoints >= 1 then
        expectedTimeToNextPoint = (currentPoints[1] - LocalHumanoid.Torso.Position).magnitude / LocalHumanoid.WalkSpeed
    end

    BindableEvent:Fire("targetPoint", p12.currentDestination)
end

function self.GoToPoint(p14, p15) -- line: 167
    -- upvalues: BindableEvent (copy)
    currentPath = true
    currentPoints = { p15 }
    currentPointIdx = 1
    moving = true

    local LocalHumanoid = p14:GetLocalHumanoid()
    local v9 = (LocalHumanoid.Torso.Position - p15).magnitude / LocalHumanoid.WalkSpeed

    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = v9
    BindableEvent:Fire("targetPoint", p15)
end

function self.StopFollowingPath(p16) -- line: 183
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    p16.moveVector = Vector3.new(0, 0, 0)
end

function self.TryComputePath(_, p18, p19) -- line: 191
    -- upvalues: PathfindingService (copy)
    local v11 = p19
    local n1 = 0
    local v12

    while true do
        if v12 or not (n1 < 5) then
            return v12
        end

        local v13 = PathfindingService:ComputeSmoothPathAsync(p18, v11, 200)

        n1 += 1

        if v13.Status == Enum.PathStatus.ClosestNoPath or v13.Status == Enum.PathStatus.ClosestOutOfRange then
            break
        end

        local v14, v15

        if v13 and v13.Status == Enum.PathStatus.FailStartNotEmpty then
            v15 = p18 + (v11 - p18).Unit
        else
            v14 = v13
            v15 = p18
        end

        p18 = v15

        if v14 and v14.Status == Enum.PathStatus.FailFinishNotEmpty then
            v11 += Vector3.new(0, 1, 0)
            v12 = nil
        else
            v12 = v14
        end
    end

    return nil
end

function self.OnNavigationRequest(p20, p21, _) -- line: 218
    -- upvalues: v1 (ref)
    local Position = p21.Position
    local currentDestination = p20.currentDestination
    local x = Position.x
    local v16 = x == x and x ~= 1e999 and x ~= (-1e999)
    local v17

    if v16 then
        local y = Position.y
        local v18 = y == y and y ~= 1e999 and y ~= (-1e999)

        if v18 then
            local z = Position.z

            v17 = z == z and z ~= 1e999 and z ~= (-1e999)
        else
            v17 = v18
        end
    else
        v17 = v16
    end

    if not v17 then
        return
    end

    p20.currentDestination = Position

    local LocalHumanoid = p20:GetLocalHumanoid()

    if LocalHumanoid and LocalHumanoid.Torso then
        local TorsoPosition = LocalHumanoid.Torso.Position

        if (p20.currentDestination - TorsoPosition).magnitude < 12 then
            p20:GoToPoint(p20.currentDestination)
        elseif not currentDestination or (p20.currentDestination - currentDestination).magnitude > 4 then
            local v19 = p20:TryComputePath(TorsoPosition, p20.currentDestination)

            if v19 then
                p20:StartFollowingPath(v19)

                if v1 then
                    v1.setCurrentPoints(p20.currentPoints)
                    v1.renderPath()
                end
            else
                p20:StopFollowingPath()

                if v1 then
                    v1.clearRenderedPath()
                end
            end
        elseif moving then
            p20.currentPoints[#currentPoints] = p20.currentDestination
        else
            p20:GoToPoint(p20.currentDestination)
        end
    end
end

function self.OnJumpAction(p23, _, p25, _) -- line: 264
    if p25 == Enum.UserInputState.Begin then
        p23.isJumping = true
    end

    return Enum.ContextActionResult.Sink
end

function self.BindJumpAction(p27, p28) -- line: 270
    -- upvalues: ContextActionService (copy)
    if p28 then
        if not p27.isJumpBound then
            p27.isJumpBound = true
            ContextActionService:BindActionAtPriority("VRJumpAction", function() -- line: 274
                -- upvalues: p27 (copy)
                return p27:OnJumpAction()
            end, false, p27.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
        end
    elseif p27.isJumpBound then
        p27.isJumpBound = false
        ContextActionService:UnbindAction("VRJumpAction")
    end
end

function self.ControlCharacterGamepad(p29, _, p31, p32) -- line: 285
    -- upvalues: v1 (ref), BindableEvent (copy)
    if p32.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end

    if p31 ~= Enum.UserInputState.Cancel then
        if p31 == Enum.UserInputState.End then
            p29.moveVector = Vector3.new(0, 0, 0)

            if p29:ShouldUseNavigationLaser() then
                p29:BindJumpAction(false)
                p29:SetLaserPointerMode("Navigation")
            end

            if p29.moveLatch then
                p29.moveLatch = false
                BindableEvent:Fire("offtrack")
            end
        else
            p29:StopFollowingPath()

            if v1 then
                v1.clearRenderedPath()
            end

            if p29:ShouldUseNavigationLaser() then
                p29:BindJumpAction(true)
                p29:SetLaserPointerMode("Hidden")
            end

            if p32.Position.magnitude > 0.22 then
                p29.moveVector = Vector3.new(p32.Position.X, 0, -p32.Position.Y)

                if p29.moveVector.magnitude > 0 then
                    p29.moveVector = p29.moveVector.unit * math.min(1, p32.Position.magnitude)
                end

                p29.moveLatch = true
            end
        end

        return Enum.ContextActionResult.Sink
    end

    p29.moveVector = Vector3.new(0, 0, 0)
end

function self.OnHeartbeat(p33, p34) -- line: 328
    -- upvalues: v1 (ref), v2 (copy), UserRaycastUpdateAPI (copy), BindableEvent (copy)
    local moveVector = p33.moveVector
    local LocalHumanoid = p33:GetLocalHumanoid()

    if not (LocalHumanoid and LocalHumanoid.Torso) then
        return
    end

    if p33.moving and p33.currentPoints then
        local TorsoPosition = LocalHumanoid.Torso.Position
        local v21 = (currentPoints[1] - TorsoPosition) * Vector3.new(1, 0, 1)
        local magnitude = v21.magnitude
        local v22 = v21 / magnitude

        if magnitude < 1 then
            local v23 = 0
            local v24 = currentPoints[1]

            for v25, v26 in pairs(currentPoints) do
                if v25 ~= 1 then
                    v23 += (v26 - v24).magnitude / LocalHumanoid.WalkSpeed
                    v24 = v26
                end
            end

            table.remove(currentPoints, 1)
            currentPointIdx = currentPointIdx + 1

            if #currentPoints == 0 then
                p33:StopFollowingPath()

                if v1 then
                    v1.clearRenderedPath()
                end

                return
            end

            if v1 then
                v1.setCurrentPoints(currentPoints)
                v1.renderPath()
            end

            expectedTimeToNextPoint = (currentPoints[1] - TorsoPosition).magnitude / LocalHumanoid.WalkSpeed
            timeReachedLastPoint = tick()
        else
            if UserRaycastUpdateAPI then
                v2.FilterDescendantsInstances = {
                    game.Players.LocalPlayer.Character,
                    workspace.CurrentCamera
                }

                local v27 = workspace:Raycast(TorsoPosition - Vector3.new(0, 1, 0), v22 * 3, v2)

                if v27 then
                    local v28 = workspace:Raycast(v27.Position + v22 * 0.5 + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0, -0), v2).Position.Y - TorsoPosition.Y

                    if v28 < 6 and v28 > -2 then
                        LocalHumanoid.Jump = true
                    end
                end
            else
                local t2 = {
                    game.Players.LocalPlayer.Character,
                    workspace.CurrentCamera
                }
                local v29 = Ray.new(TorsoPosition - Vector3.new(0, 1, 0), v22 * 3)
                local v30, v31 = workspace:FindPartOnRayWithIgnoreList(v29, t2)

                if v30 then
                    local v32 = Ray.new(v31 + v22 * 0.5 + Vector3.new(0, 100, 0), (Vector3.new(-0, -100, -0, -0)))
                    local _, v33 = workspace:FindPartOnRayWithIgnoreList(v32, t2)
                    local v34 = v33.Y - TorsoPosition.Y

                    if v34 < 6 and v34 > -2 then
                        LocalHumanoid.Jump = true
                    end
                end
            end

            if tick() - timeReachedLastPoint > expectedTimeToNextPoint + 2 then
                p33:StopFollowingPath()

                if v1 then
                    v1.clearRenderedPath()
                end

                BindableEvent:Fire("offtrack")
            end

            moveVector = p33.moveVector:Lerp(v22, p34 * 10)
        end
    end

    local x = moveVector.x
    local v35 = x == x and x ~= 1e999 and x ~= (-1e999)
    local v36

    if v35 then
        local y = moveVector.y
        local v37 = y == y and y ~= 1e999 and y ~= (-1e999)

        if v37 then
            local z = moveVector.z

            v36 = z == z and z ~= 1e999 and z ~= (-1e999)
        else
            v36 = v37
        end
    else
        v36 = v35
    end

    if v36 then
        p33.moveVector = moveVector
    end
end

function self.OnUserCFrameEnabled(p35) -- line: 426
    if p35:ShouldUseNavigationLaser() then
        p35:BindJumpAction(false)
        p35:SetLaserPointerMode("Navigation")
    else
        p35:BindJumpAction(true)
        p35:SetLaserPointerMode("Hidden")
    end
end

function self.Enable(p36, p37) -- line: 436
    -- upvalues: VRService (copy), RunService (copy), ContextActionService (copy)
    p36.moveVector = Vector3.new(0, 0, 0)
    p36.isJumping = false

    if p37 then
        p36.navigationRequestedConn = VRService.NavigationRequested:Connect(function(p38, p39) -- line: 442
            -- upvalues: p36 (copy)
            p36:OnNavigationRequest(p38, p39)
        end)
        p36.heartbeatConn = RunService.Heartbeat:Connect(function(p40) -- line: 443
            -- upvalues: p36 (copy)
            p36:OnHeartbeat(p40)
        end)
        ContextActionService:BindAction("MoveThumbstick", function(p41, p42, p43) -- line: 445
            -- upvalues: p36 (copy)
            return p36:ControlCharacterGamepad(p41, p42, p43)
        end, false, p36.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
        ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        p36.userCFrameEnabledConn = VRService.UserCFrameEnabled:Connect(function() -- line: 449
            -- upvalues: p36 (copy)
            p36:OnUserCFrameEnabled()
        end)
        p36:OnUserCFrameEnabled()
        VRService:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
        VRService:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
        p36.enabled = true
    else
        p36:StopFollowingPath()
        ContextActionService:UnbindAction("MoveThumbstick")
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        p36:BindJumpAction(false)
        p36:SetLaserPointerMode("Disabled")

        if p36.navigationRequestedConn then
            p36.navigationRequestedConn:Disconnect()
            p36.navigationRequestedConn = nil
        end

        if p36.heartbeatConn then
            p36.heartbeatConn:Disconnect()
            p36.heartbeatConn = nil
        end

        if p36.userCFrameEnabledConn then
            p36.userCFrameEnabledConn:Disconnect()
            p36.userCFrameEnabledConn = nil
        end

        p36.enabled = false
    end
end

return self
