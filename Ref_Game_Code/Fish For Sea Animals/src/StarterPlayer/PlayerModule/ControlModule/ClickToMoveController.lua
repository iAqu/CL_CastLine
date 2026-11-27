-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function v1() -- line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end

local ok, result = pcall(v1)
local v2 = ok and result

local function v3() -- line: 17
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end

local ok2, result2 = pcall(v3)
local v4 = ok2 and result2
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

game:GetService("Debris")

local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserRaycastUpdateAPI2 = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local UserPSIASClickToMoveRelaxTeleport = FlagUtil.getUserFlag("UserPSIASClickToMoveRelaxTeleport")
local UserPlayerScriptsRefactor2 = FlagUtil.getUserFlag("UserPlayerScriptsRefactor2")
local UserDoubleJumpButtonFix = FlagUtil.getUserFlag("UserDoubleJumpButtonFix")
local CharacterContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CharacterContext")
local ClickToMoveAction = CharacterContext:WaitForChild("ClickToMoveAction")
local ClickToMovePositionAction = CharacterContext:WaitForChild("ClickToMovePositionAction")
local v5 = true
local v6 = true
local v7 = false
local n1 = 1
local n2 = 8
local LocalPlayer = Players.LocalPlayer
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local v8 = RaycastParams.new()

v8.FilterType = Enum.RaycastFilterType.Exclude

local t1 = {}

if not UserRaycastUpdateAPI2 then
    local function FindCharacterAncestor(p1) -- line: 70
        -- upvalues: FindCharacterAncestor (copy)
        if not p1 then
            return
        end

        local Humanoid = p1:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            return p1, Humanoid
        end

        return FindCharacterAncestor(p1.Parent)
    end

    t1.FindCharacterAncestor = FindCharacterAncestor

    local function Raycast(p2, p3, p4) -- line: 82
        -- upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy)
        p4 = p4 or {}

        local v10, v11, v12, v13 = Workspace:FindPartOnRayWithIgnoreList(p2, p4)

        if not v10 then
            return nil, nil
        end

        if p3 and v10.CanCollide == false then
            local Humanoid = v10:FindFirstChildOfClass("Humanoid")

            if not Humanoid then
                local v14

                v14, Humanoid = FindCharacterAncestor(v10.Parent)
            end

            if Humanoid == nil then
                table.insert(p4, v10)

                return Raycast(p2, p3, p4)
            end
        end

        return v10, v11, v12, v13
    end

    t1.Raycast = Raycast
end

local t2 = {}

local function findPlayerHumanoid(p5) -- line: 104
    -- upvalues: t2 (copy)
    local v15 = p5 and p5.Character

    if not v15 then
        return
    end

    local v16 = t2[p5]

    if v16 and v16.Parent == v15 then
        return v16
    end

    t2[p5] = nil

    local Humanoid = v15:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        t2[p5] = Humanoid
    end

    return Humanoid
end

local t3 = nil
local v17, connection, connection2

local function GetCharacter() -- line: 128
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character
end

local function UpdateIgnoreTag(p6) -- line: 132
    -- upvalues: CollectionService (copy), LocalPlayer (copy), t3 (ref), v17 (ref), connection (ref), connection2 (ref)
    if p6 == v17 then
        return
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection2 then
        connection2:Disconnect()
        connection2 = nil
    end

    v17 = p6
    t3 = {
        LocalPlayer and LocalPlayer.Character
    }

    if v17 == nil then
        return
    end

    local Tagged = CollectionService:GetTagged(v17)

    for _, v18 in ipairs(Tagged) do
        table.insert(t3, v18)
    end

    connection = CollectionService:GetInstanceAddedSignal(v17):Connect(function(p7) -- line: 152
        -- upvalues: t3 (ref)
        table.insert(t3, p7)
    end)
    connection2 = CollectionService:GetInstanceRemovedSignal(v17):Connect(function(p8) -- line: 156
        -- upvalues: t3 (ref)
        for i = 1, #t3 do
            if t3[i] == p8 then
                t3[i] = t3[#t3]
                table.remove(t3)

                return
            end
        end
    end)
end

local function minV(p9, p10) -- line: 178
    return (Vector3.new(math.min(p9.X, p10.X), math.min(p9.Y, p10.Y), (math.min(p9.Z, p10.Z))))
end

local function maxV(p11, p12) -- line: 181
    return (Vector3.new(math.max(p11.X, p12.X), math.max(p11.Y, p12.Y), (math.max(p11.Z, p12.Z))))
end

local function getCollidableExtentsSize(p13) -- line: 184
    if p13 ~= nil and p13.PrimaryPart ~= nil then
        assert(p13, "")
        assert(p13.PrimaryPart, "")

        local v25 = p13.PrimaryPart.CFrame:Inverse()
        local v26 = Vector3.new(1e999, 1e999, 1e999)
        local v27 = Vector3.new((-1e999), (-1e999), (-1e999))

        for _, descendant in pairs(p13:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanCollide then
                local v28 = v25 * descendant.CFrame
                local v32 = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2)
                local t9 = {
                    Vector3.new(v32.X, v32.Y, v32.Z),
                    Vector3.new(v32.X, v32.Y, -v32.Z),
                    Vector3.new(v32.X, -v32.Y, v32.Z),
                    Vector3.new(v32.X, -v32.Y, -v32.Z),
                    Vector3.new(-v32.X, v32.Y, v32.Z),
                    Vector3.new(-v32.X, v32.Y, -v32.Z),
                    Vector3.new(-v32.X, -v32.Y, v32.Z),
                    (Vector3.new(-v32.X, -v32.Y, -v32.Z))
                }

                for _, v54 in ipairs(t9) do
                    local v55 = v28 * v54

                    v26 = Vector3.new(math.min(v26.X, v55.X), math.min(v26.Y, v55.Y), (math.min(v26.Z, v55.Z)))
                    v27 = Vector3.new(math.max(v27.X, v55.X), math.max(v27.Y, v55.Y), (math.max(v27.Z, v55.Z)))
                end
            end
        end

        local v62 = v27 - v26

        return if not (v62.X < 0) and not (v62.Y < 0) and not (v62.Z < 0) then v62 else nil
    end
end

local function Pather(p14, p15, p16) -- line: 223
    -- upvalues: v2 (copy), v4 (copy), PathfindingService (copy), Workspace (copy), UserRaycastUpdateAPI2 (copy), UserPSIASClickToMoveRelaxTeleport (copy), v5 (ref), v7 (ref), n1 (ref), n2 (ref), LocalPlayer (copy), ClickToMoveDisplay (copy), v8 (copy), t2 (copy), t3 (ref), getCollidableExtentsSize (copy)
    local v63, v64

    if p16 ~= nil then
        v64 = p16
        v63 = p16
    else
        v64 = v7
        v63 = true
    end

    local t10 = {}

    t10.Cancelled = false
    t10.Started = false
    t10.Finished = Instance.new("BindableEvent")
    t10.PathFailed = Instance.new("BindableEvent")
    t10.PathComputing = false
    t10.PathComputed = false
    t10.OriginalTargetPoint = p14
    t10.TargetPoint = p14
    t10.TargetSurfaceNormal = p15
    t10.DiedConn = nil
    t10.SeatedConn = nil
    t10.BlockedConn = nil
    t10.TeleportedConn = nil
    t10.CurrentPoint = 0
    t10.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    t10.CurrentWaypointPosition = nil
    t10.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    t10.CurrentWaypointPlaneDistance = 0
    t10.CurrentWaypointNeedsJump = false
    t10.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    t10.CurrentHumanoidVelocity = 0
    t10.NextActionMoveDirection = Vector3.new(0, 0, 0)
    t10.NextActionJump = false
    t10.Timeout = 0

    local v65 = LocalPlayer and LocalPlayer.Character
    local v66

    if v65 then
        v66 = t2[LocalPlayer]

        if not v66 or v66.Parent ~= v65 then
            t2[LocalPlayer] = nil

            local Humanoid = v65:FindFirstChildOfClass("Humanoid")

            v66 = Humanoid

            if Humanoid then
                t2[LocalPlayer] = Humanoid
            end
        end
    end

    t10.Humanoid = v66
    t10.OriginPoint = nil
    t10.AgentCanFollowPath = false
    t10.DirectPath = false
    t10.DirectPathRiseFirst = false
    t10.stopTraverseFunc = nil
    t10.setPointFunc = nil
    t10.pointList = nil

    local v67 = t10.Humanoid and t10.Humanoid.RootPart
    local v68 = false
    local v69 = false
    local v70 = false
    local v71 = false
    local v72 = false
    local v73 = false

    if v67 then
        v68 = true
    else
        v73 = true
    end

    local SeatPart

    if v68 then
        t10.OriginPoint = v67.CFrame.Position
        SeatPart = t10.Humanoid.SeatPart

        if SeatPart then
            v69 = true
        else
            v70 = true
        end
    end

    v68 = false

    if v69 then
        if SeatPart:IsA("VehicleSeat") then
            v68 = true
        else
            v70 = true
        end
    end

    v69 = false

    if v70 then
        if v2 then
            v69 = true
        else
            v71 = true
        end
    end

    v70 = false

    local v75

    if v69 then
        if LocalPlayer then
            v70 = true
        else
            v75 = LocalPlayer
            v72 = true
        end
    end

    v69 = false

    if v70 then
        v75 = LocalPlayer.Character
        v72 = true
    end

    v70 = false

    if v72 then
        if v75 ~= nil then
            v70 = true
        else
            v71 = true
        end
    end

    v72 = false

    local v74

    if v70 then
        v74 = getCollidableExtentsSize(v75)
        v71 = true
    end

    v70 = false

    local v76

    if v71 then
        if v74 ~= nil then
            v76 = v74
            v72 = true
        else
            v70 = true
        end
    end

    v71 = false

    local v77

    if v70 then
        if LocalPlayer then
            v71 = true
        else
            v77 = LocalPlayer
            v69 = true
        end
    end

    if v71 then
        v77 = LocalPlayer.Character
        v69 = true
    end

    v71 = false

    if v69 then
        v76 = v77:GetExtentsSize()
        v72 = true
    end

    v69 = false

    local v78, v79

    if v72 then
        assert(v76, "")
        v78 = n1 * 0.5 * math.sqrt(v76.X * v76.X + v76.Z * v76.Z)

        local v82 = n1

        v79 = v82 * v76.Y

        if t10.Humanoid.JumpPower > 0 then
            v71 = true
        else
            v69 = true
        end
    end

    v72 = false

    local v83

    if v69 then
        v83 = false
        v72 = true
    end

    if v71 then
        v83 = true
        v72 = true
    end

    v71 = false

    local v84, v85, v86

    if v72 then
        t10.AgentCanFollowPath = true
        t10.DirectPath = v64
        t10.DirectPathRiseFirst = t10.Humanoid.Sit
        v84 = v78
        v85 = v79
        v86 = v83
        v73 = false
    end

    v72 = false

    local Model

    if v68 then
        Model = SeatPart:FindFirstAncestorOfClass("Model")

        if Model then
            v72 = true
        else
            v84 = 2
            v85 = 5
            v86 = true
            v73 = false
        end
    end

    v68 = false

    local PrimaryPart, v87, v88, v89

    if v72 then
        PrimaryPart = Model.PrimaryPart
        Model.PrimaryPart = SeatPart

        if v63 then
            v68 = true
        else
            v87 = 2
            v88 = 5
            v89 = true
            v71 = true
        end
    end

    if v68 then
        local ExtentsSize = Model:GetExtentsSize()

        v87 = n1 * 0.5 * math.sqrt(ExtentsSize.X * ExtentsSize.X + ExtentsSize.Z * ExtentsSize.Z)

        local v92 = n1

        v88 = v92 * ExtentsSize.Y
        t10.AgentCanFollowPath = true
        v89 = false
        v71 = true
        t10.DirectPath = v63
    end

    if v71 then
        Model.PrimaryPart = PrimaryPart
        v84 = v87
        v85 = v88
        v86 = v89
        v73 = false
    end

    if not v73 then
        t10.pathResult = if v4 then PathfindingService:CreatePath({
            AgentCanClimb = true,
            AgentRadius = v84,
            AgentHeight = v85,
            AgentCanJump = v86
        }) else PathfindingService:CreatePath({
            AgentRadius = v84,
            AgentHeight = v85,
            AgentCanJump = v86
        })
    end

    function t10.Cleanup(_) -- line: 352
        -- upvalues: t10 (copy)
        if t10.stopTraverseFunc then
            t10.stopTraverseFunc()
            t10.stopTraverseFunc = nil
        end

        if t10.BlockedConn then
            t10.BlockedConn:Disconnect()
            t10.BlockedConn = nil
        end

        if t10.DiedConn then
            t10.DiedConn:Disconnect()
            t10.DiedConn = nil
        end

        if t10.SeatedConn then
            t10.SeatedConn:Disconnect()
            t10.SeatedConn = nil
        end

        if t10.TeleportedConn then
            t10.TeleportedConn:Disconnect()
            t10.TeleportedConn = nil
        end

        t10.Started = false
    end

    function t10.Cancel(_) -- line: 381
        -- upvalues: t10 (copy)
        t10.Cancelled = true
        t10:Cleanup()
    end

    function t10.IsActive(_) -- line: 386
        -- upvalues: t10 (copy)
        return t10.AgentCanFollowPath and t10.Started and not t10.Cancelled
    end

    function t10.OnPathInterrupted(_) -- line: 390
        -- upvalues: t10 (copy)
        t10.Cancelled = true
        t10:OnPointReached(false)
    end

    function t10.ComputePath(_) -- line: 396
        -- upvalues: t10 (copy)
        if t10.OriginPoint then
            if t10.PathComputed or t10.PathComputing then
                return
            end

            t10.PathComputing = true

            if t10.AgentCanFollowPath then
                if t10.DirectPath then
                    t10.pointList = {
                        PathWaypoint.new(t10.OriginPoint, Enum.PathWaypointAction.Walk),
                        PathWaypoint.new(t10.TargetPoint, t10.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk)
                    }
                    t10.PathComputed = true
                else
                    t10.pathResult:ComputeAsync(t10.OriginPoint, t10.TargetPoint)
                    t10.pointList = t10.pathResult:GetWaypoints()
                    t10.BlockedConn = t10.pathResult.Blocked:Connect(function(p22) -- line: 415
                        -- upvalues: t10 (copy)
                        t10:OnPathBlocked(p22)
                    end)
                    t10.PathComputed = t10.pathResult.Status == Enum.PathStatus.Success
                end
            end

            t10.PathComputing = false
        end
    end

    function t10.IsValidPath(_) -- line: 425
        -- upvalues: t10 (copy)
        t10:ComputePath()

        return t10.PathComputed and t10.AgentCanFollowPath
    end

    t10.Recomputing = false

    function t10.OnPathBlocked(_, p25) -- line: 431
        -- upvalues: t10 (copy), v5 (ref), ClickToMoveDisplay (copy)
        if not (t10.CurrentPoint <= p25) or t10.Recomputing then
            return
        else
            t10.Recomputing = true

            if t10.stopTraverseFunc then
                t10.stopTraverseFunc()
                t10.stopTraverseFunc = nil
            end
        end

        t10.OriginPoint = t10.Humanoid.RootPart.CFrame.Position
        t10.pathResult:ComputeAsync(t10.OriginPoint, t10.TargetPoint)
        t10.pointList = t10.pathResult:GetWaypoints()

        if #t10.pointList > 0 then
            t10.HumanoidOffsetFromPath = t10.pointList[1].Position - t10.OriginPoint
        end

        t10.PathComputed = t10.pathResult.Status == Enum.PathStatus.Success

        if v5 then
            local v95, v96 = ClickToMoveDisplay.CreatePathDisplay(t10.pointList)

            t10.stopTraverseFunc = v95
            t10.setPointFunc = v96
        end

        if t10.PathComputed then
            t10.CurrentPoint = 1
            t10:OnPointReached(true)
        else
            t10.PathFailed:Fire()
            t10:Cleanup()
        end

        t10.Recomputing = false
    end

    function t10.OnRenderStepped(_, p27) -- line: 467
        -- upvalues: t10 (copy), n2 (ref)
        if not t10.Started or t10.Cancelled then
            return
        end

        t10.Timeout += p27

        if t10.Timeout > n2 then
            t10:OnPointReached(false)
        else
            t10.CurrentHumanoidPosition = t10.Humanoid.RootPart.Position + t10.HumanoidOffsetFromPath
            t10.CurrentHumanoidVelocity = t10.Humanoid.RootPart.Velocity

            while t10.Started and t10:IsCurrentWaypointReached() do
                t10:OnPointReached(true)
            end

            if t10.Started then
                t10.NextActionMoveDirection = t10.CurrentWaypointPosition - t10.CurrentHumanoidPosition
                t10.NextActionMoveDirection = if t10.NextActionMoveDirection.Magnitude > 1E-06 then t10.NextActionMoveDirection.Unit else Vector3.new(0, 0, 0)

                if t10.CurrentWaypointNeedsJump then
                    t10.NextActionJump = true
                    t10.CurrentWaypointNeedsJump = false
                else
                    t10.NextActionJump = false
                end
            end
        end
    end

    function t10.IsCurrentWaypointReached(_) -- line: 505
        -- upvalues: t10 (copy)
        local v97 = t10.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) or t10.CurrentWaypointPlaneNormal:Dot(t10.CurrentHumanoidPosition) - t10.CurrentWaypointPlaneDistance < math.max(1, 0.0625 * -t10.CurrentWaypointPlaneNormal:Dot(t10.CurrentHumanoidVelocity))

        if v97 then
            t10.CurrentWaypointPosition = nil
            t10.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t10.CurrentWaypointPlaneDistance = 0
        end

        return v97
    end

    function t10.OnPointReached(_, p30) -- line: 532
        -- upvalues: t10 (copy)
        if not p30 or t10.Cancelled then
            t10.PathFailed:Fire()
            t10:Cleanup()

            return
        elseif t10.setPointFunc then
            t10.setPointFunc(t10.CurrentPoint)
        end

        local v101 = t10.CurrentPoint + 1

        if #t10.pointList < v101 then
            if t10.stopTraverseFunc then
                t10.stopTraverseFunc()
            end

            t10.Finished:Fire()
            t10:Cleanup()
        else
            local v102 = t10.pointList[t10.CurrentPoint]
            local v103 = t10.pointList[v101]
            local State = t10.Humanoid:GetState()

            if State == Enum.HumanoidStateType.FallingDown or State == Enum.HumanoidStateType.Freefall or State == Enum.HumanoidStateType.Jumping then
                local v104 = v103.Action == Enum.PathWaypointAction.Jump

                if not v104 and t10.CurrentPoint > 1 then
                    local v105 = t10.pointList[t10.CurrentPoint - 1]
                    local v106 = v102.Position - v105.Position
                    local v107 = v103.Position - v102.Position

                    v104 = Vector2.new(v106.x, v106.z).Unit:Dot(Vector2.new(v107.x, v107.z).Unit) < 0.996
                end

                if v104 then
                    t10.Humanoid.FreeFalling:Wait()
                    wait(0.1)
                end
            end

            t10:MoveToNextWayPoint(v102, v103, v101)
        end
    end

    function t10.MoveToNextWayPoint(_, p32, p33, p34) -- line: 594
        -- upvalues: t10 (copy), v4 (copy)
        t10.CurrentWaypointPlaneNormal = p32.Position - p33.Position

        if not v4 or p33.Label ~= "Climb" then
            t10.CurrentWaypointPlaneNormal = Vector3.new(t10.CurrentWaypointPlaneNormal.X, 0, t10.CurrentWaypointPlaneNormal.Z)
        end

        if t10.CurrentWaypointPlaneNormal.Magnitude > 1E-06 then
            t10.CurrentWaypointPlaneNormal = t10.CurrentWaypointPlaneNormal.Unit
            t10.CurrentWaypointPlaneDistance = t10.CurrentWaypointPlaneNormal:Dot(p33.Position)
        else
            t10.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t10.CurrentWaypointPlaneDistance = 0
        end

        t10.CurrentWaypointNeedsJump = p33.Action == Enum.PathWaypointAction.Jump
        t10.CurrentWaypointPosition = p33.Position
        t10.CurrentPoint = p34
        t10.Timeout = 0
    end

    function t10.Start(_, p36) -- line: 627
        -- upvalues: t10 (copy), UserPSIASClickToMoveRelaxTeleport (copy), v5 (ref), ClickToMoveDisplay (copy)
        if not t10.AgentCanFollowPath then
            t10.PathFailed:Fire()

            return
        end

        if not t10.Started then
            t10.Started = true
            ClickToMoveDisplay.CancelFailureAnimation()

            if v5 and (p36 == nil or p36) then
                local v108, v109 = ClickToMoveDisplay.CreatePathDisplay(t10.pointList, t10.OriginalTargetPoint)

                t10.stopTraverseFunc = v108
                t10.setPointFunc = v109
            end

            if #t10.pointList > 0 then
                t10.HumanoidOffsetFromPath = Vector3.new(0, t10.pointList[1].Position.Y - t10.OriginPoint.Y, 0)
                t10.CurrentHumanoidPosition = t10.Humanoid.RootPart.Position + t10.HumanoidOffsetFromPath
                t10.CurrentHumanoidVelocity = t10.Humanoid.RootPart.Velocity
                t10.SeatedConn = t10.Humanoid.Seated:Connect(function(_, _) -- line: 657
                    -- upvalues: t10 (copy)
                    t10:OnPathInterrupted()
                end)
                t10.DiedConn = t10.Humanoid.Died:Connect(function() -- line: 660
                    -- upvalues: t10 (copy)
                    t10:OnPathInterrupted()
                end)

                if UserPSIASClickToMoveRelaxTeleport then
                    t10.lastPosition = t10.Humanoid.RootPart.CFrame.Position
                    t10.TeleportedConn = t10.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 665
                        -- upvalues: t10 (copy)
                        local CFramePosition = t10.Humanoid.RootPart.CFrame.Position
                        local Magnitude = (CFramePosition - t10.lastPosition).Magnitude

                        t10.lastPosition = CFramePosition

                        if t10.Humanoid.WalkSpeed < Magnitude then
                            t10:OnPathInterrupted()
                        end
                    end)
                else
                    t10.TeleportedConn = t10.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 674
                        -- upvalues: t10 (copy)
                        t10:OnPathInterrupted()
                    end)
                end

                t10.CurrentPoint = 1
                t10:OnPointReached(true)
            else
                t10.PathFailed:Fire()

                if t10.stopTraverseFunc then
                    t10.stopTraverseFunc()
                end
            end
        end
    end

    local v111 = t10.TargetPoint + t10.TargetSurfaceNormal * 1.5

    if UserRaycastUpdateAPI2 then
        if not t3 then
            t3 = {}
            assert(t3, "")

            local t12 = t3

            table.insert(t12, LocalPlayer and LocalPlayer.Character)
        end

        local t13 = t3

        v8.FilterDescendantsInstances = t13

        local v113 = Workspace:Raycast(v111, Vector3.new(-0, -50, -0, -0), v8)

        if v113 then
            t10.TargetPoint = v113.Position
        end
    else
        local v114 = Ray.new(v111, (Vector3.new(0, -50, 0)))

        if not t3 then
            t3 = {}
            assert(t3, "")

            local t15 = t3

            table.insert(t15, LocalPlayer and LocalPlayer.Character)
        end

        local t16 = t3
        local v116, v117 = Workspace:FindPartOnRayWithIgnoreList(v114, t16)

        if v116 then
            t10.TargetPoint = v117
        end
    end

    t10:ComputePath()

    return t10
end

local function CheckAlive() -- line: 713
    -- upvalues: LocalPlayer (copy), t2 (copy)
    local v118 = LocalPlayer and LocalPlayer.Character
    local v119

    if v118 then
        v119 = t2[LocalPlayer]

        if not v119 or v119.Parent ~= v118 then
            t2[LocalPlayer] = nil

            local Humanoid = v118:FindFirstChildOfClass("Humanoid")

            v119 = Humanoid

            if Humanoid then
                t2[LocalPlayer] = Humanoid
            end
        end
    end

    return v119 ~= nil and v119.Health > 0
end

local function GetEquippedTool(p39) -- line: 718
    if p39 == nil then
        return
    end

    for _, child in pairs(p39:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
end

local function DisconnectEvent(p40) -- line: 728
    if p40 then
        p40:Disconnect()
    end
end

local function calculateLocalMoveVector(p41) -- line: 734
    -- upvalues: Workspace (copy)
    local v120 = Vector3.new(p41.X, 0, p41.Z)

    if v120.Magnitude < 1E-06 then
        return Vector2.zero
    end

    local Unit = v120.Unit
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return Vector2.new(Unit.X, -Unit.Z)
    end

    local _, v121 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v122 = CFrame.Angles(0, v121, 0):VectorToObjectSpace(Unit)

    return Vector2.new(v122.X, -v122.Z)
end

local t17 = {}

t17.__index = t17

function t17.new(_) -- line: 754
    -- upvalues: UserDoubleJumpButtonFix (copy), t17 (copy)
    local self = setmetatable({}, t17)

    self.mouse2DownTime = tick()
    self.mouse2DownPos = Vector2.new()
    self.mouse2UpTime = tick()
    self.humanoidDiedConn = nil
    self.characterChildAddedConn = nil
    self.onCharacterAddedConn = nil
    self.characterChildRemovedConn = nil
    self.renderSteppedConn = nil
    self.menuOpenedConnection = nil
    self.preferredInputChangedConnection = nil

    if not UserDoubleJumpButtonFix then
        self.jumpEnabled = true
    end

    self.clickPressedConn = nil
    self.clickReleasedConn = nil
    self.shouldCleanupPath = false
    self.lastPatherJumped = false
    self.data = nil
    self.running = false

    return self
end

local v124, connection3, connection4

function t17:CleanupPath() -- line: 788
    -- upvalues: v124 (ref), connection3 (ref), connection4 (ref)
    if v124 then
        v124:Cancel()
        v124 = nil
    end

    if connection3 then
        connection3:Disconnect()
        connection3 = nil
    end

    if connection4 then
        connection4:Disconnect()
        connection4 = nil
    end

    self.shouldCleanupPath = true
end

function t17:HandleMoveTo(p45, p46, p47, p48, p49) -- line: 807
    -- upvalues: v6 (ref), ClickToMoveDisplay (copy), GetEquippedTool (copy), v124 (ref), connection3 (ref), connection4 (ref)
    self.shouldCleanupPath = false

    if v124 then
        self:CleanupPath()
    end

    v124 = p45
    p45:Start(p49)
    connection3 = p45.Finished.Event:Connect(function() -- line: 816
        -- upvalues: self (copy), p47 (copy), p48 (copy), GetEquippedTool (copy)
        self:CleanupPath()

        if p47 then
            local v125 = GetEquippedTool(p48)

            if v125 then
                v125:Activate()
            end
        end
    end)
    connection4 = p45.PathFailed.Event:Connect(function() -- line: 825
        -- upvalues: self (copy), p46 (copy), p49 (copy), v6 (ref), ClickToMoveDisplay (copy), v124 (ref)
        self:CleanupPath()

        if p49 == nil or p49 then
            if v6 and not (v124 and v124:IsActive()) then
                ClickToMoveDisplay.PlayFailureAnimation()
            end

            ClickToMoveDisplay.DisplayFailureWaypoint(p46)
        end
    end)
end

function t17.ShowPathFailedFeedback(_, p51) -- line: 837
    -- upvalues: v6 (ref), ClickToMoveDisplay (copy), v124 (ref)
    if v124 and v124:IsActive() then
        v124:Cancel()
    end

    if v6 then
        ClickToMoveDisplay.PlayFailureAnimation()
    end

    ClickToMoveDisplay.DisplayFailureWaypoint(p51)
end

function t17.OnTap(p52, p53, p54) -- line: 847
    -- upvalues: Workspace (copy), UserRaycastUpdateAPI2 (copy), LocalPlayer (copy), v8 (copy), t1 (copy), t2 (copy), t3 (ref), Pather (copy), GetEquippedTool (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v126 = LocalPlayer and LocalPlayer.Character
    local v127

    if v126 then
        v127 = t2[LocalPlayer]

        if not v127 or v127.Parent ~= v126 then
            t2[LocalPlayer] = nil

            local Humanoid = v126:FindFirstChildOfClass("Humanoid")

            v127 = Humanoid

            if Humanoid then
                t2[LocalPlayer] = Humanoid
            end
        end
    end

    if v127 ~= nil and v127.Health > 0 then
        if #p53 == 1 or p54 then
            if CurrentCamera then
                local v128 = CurrentCamera:ScreenPointToRay(p53[1].X, p53[1].Y)

                if UserRaycastUpdateAPI2 then
                    if not t3 then
                        t3 = {}
                        assert(t3, "")

                        local t20 = t3

                        table.insert(t20, LocalPlayer and LocalPlayer.Character)
                    end

                    local t21 = t3
                    local v130

                    if not t21 then
                        v130 = nil
                        t21 = {}
                    end

                    local v131

                    repeat
                        v8.FilterDescendantsInstances = t21
                        v131 = Workspace:Raycast(v128.Origin, v128.Direction * 1000, v8)

                        local v132

                        if v131 then
                            local Instance = v131.Instance

                            if Instance.CanCollide then
                                v132 = true
                            else
                                v130 = Instance

                                local Humanoid, Parent

                                while true do
                                    Humanoid = v130:FindFirstChildOfClass("Humanoid")
                                    Parent = v130.Parent

                                    if not Humanoid and Parent then
                                        v130 = Parent
                                        continue
                                    end

                                    break
                                end

                                if Humanoid then
                                    v132 = true
                                elseif Parent then
                                    v130 = nil
                                    v132 = false
                                    table.insert(t21, Parent)
                                else
                                    v132 = true
                                end
                            end
                        else
                            v132 = true
                        end
                    until v132

                    if v131 and Character then
                        local Position = v131.Position
                        local v133

                        if p54 then
                            Position = p54
                        else
                            v133 = v130
                        end

                        p52:CleanupPath()

                        local v134 = Pather(Position, v131.Normal)

                        if v134:IsValidPath() then
                            p52:HandleMoveTo(v134, Position, v133, Character)
                        else
                            v134:Cleanup()
                            p52:ShowPathFailedFeedback(Position)
                        end
                    end
                else
                    local v135 = Ray.new(v128.Origin, v128.Direction * 1000)
                    local Raycast = t1.Raycast

                    if not t3 then
                        t3 = {}
                        assert(t3, "")

                        local t23 = t3

                        table.insert(t23, LocalPlayer and LocalPlayer.Character)
                    end

                    local v137, v138, v139 = Raycast(v135, true, t3)
                    local v140 = t1.FindCharacterAncestor(v137)

                    if p54 then
                        v138 = p54
                        v140 = nil
                    end

                    if v138 and Character then
                        p52:CleanupPath()

                        local v141 = Pather(v138, v139)

                        if v141:IsValidPath() then
                            p52:HandleMoveTo(v141, v138, v140, Character)
                        else
                            v141:Cleanup()
                            p52:ShowPathFailedFeedback(v138)
                        end
                    end
                end
            end
        elseif #p53 >= 2 and CurrentCamera then
            local v142 = GetEquippedTool(Character)

            if v142 then
                v142:Activate()
            end
        end
    end
end

function t17:DisconnectEvents() -- line: 944
    local humanoidDiedConn = self.humanoidDiedConn

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect()
    end

    local characterChildAddedConn = self.characterChildAddedConn

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect()
    end

    local onCharacterAddedConn = self.onCharacterAddedConn

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect()
    end

    local renderSteppedConn = self.renderSteppedConn

    if renderSteppedConn then
        renderSteppedConn:Disconnect()
    end

    local characterChildRemovedConn = self.characterChildRemovedConn

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect()
    end

    local menuOpenedConnection = self.menuOpenedConnection

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect()
    end

    local preferredInputChangedConnection = self.preferredInputChangedConnection

    if preferredInputChangedConnection then
        preferredInputChangedConnection:Disconnect()
    end

    local clickPressedConn = self.clickPressedConn

    if clickPressedConn then
        clickPressedConn:Disconnect()
    end

    local clickReleasedConn = self.clickReleasedConn

    if clickReleasedConn then
        clickReleasedConn:Disconnect()
    end
end

function t17.OnPreferredInputChanged(_) -- line: 956
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        local v143 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("Tool") then
                child.ManualActivationOnly = v143
            end
        end
    end
end

function t17:OnCharacterAdded(p58) -- line: 968
    -- upvalues: UserInputService (copy), GuiService (copy), UserPlayerScriptsRefactor2 (copy), ClickToMoveAction (copy), ClickToMovePositionAction (copy), v124 (ref)
    self:DisconnectEvents()
    self.clickPressedConn = ClickToMoveAction.Pressed:Connect(function() -- line: 971
        -- upvalues: self (copy), GuiService (copy), UserPlayerScriptsRefactor2 (copy), ClickToMovePositionAction (copy)
        local GuiInset = GuiService:GetGuiInset()
        local State = ClickToMovePositionAction:GetState()

        if State.X == -1 and State.Y == -1 then
            return
        end

        local v144

        if UserPlayerScriptsRefactor2 then
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min

            v144 = Vector2.new(State.X + Min.X, State.Y + Min.Y)
        else
            v144 = Vector2.new(State.X - GuiInset.X, State.Y - GuiInset.Y)
        end

        self.mouse2DownPos = v144
        self.mouse2DownTime = tick()
    end)
    self.clickReleasedConn = ClickToMoveAction.Released:Connect(function() -- line: 987
        -- upvalues: self (copy), v124 (ref)
        self.mouse2UpTime = tick()

        local mouse2DownPos = self.mouse2DownPos

        if not (self.data and self.data.controlModule.actions.MoveAction) then
            return
        end

        local v145 = v124 or self.data.controlModule.actions.MoveAction:GetState().Magnitude <= 0

        if self.mouse2UpTime - self.mouse2DownTime < 0.25 and v145 then
            self:OnTap({
                mouse2DownPos
            })
        end
    end)
    self.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- line: 1002
        -- upvalues: self (copy)
        self:CleanupPath()
    end)

    local function OnCharacterChildAdded(p59) -- line: 1006
        -- upvalues: self (copy), UserInputService (copy)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p59:IsA("Tool") then
            p59.ManualActivationOnly = true
        end

        if p59:IsA("Humanoid") then
            local humanoidDiedConn = self.humanoidDiedConn

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect()
            end

            self.humanoidDiedConn = p59.Died:Connect(function() -- line: 1014
            end)
        end
    end

    self.characterChildAddedConn = p58.ChildAdded:Connect(function(p60) -- line: 1022
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p60)
    end)
    self.characterChildRemovedConn = p58.ChildRemoved:Connect(function(p61) -- line: 1025
        -- upvalues: UserInputService (copy)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p61:IsA("Tool") then
            p61.ManualActivationOnly = false
        end
    end)

    for _, child in pairs(p58:GetChildren()) do
        OnCharacterChildAdded(child)
    end

    self.preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1037
        -- upvalues: self (copy)
        self:OnPreferredInputChanged()
    end)
end

function t17.Start(p62) -- line: 1042
    p62:Enable(true)
end

function t17.Stop(p63) -- line: 1046
    p63:Enable(false)
end

function t17:Enable(p65, p66, p67) -- line: 1051
    -- upvalues: UserInputService (copy), UserDoubleJumpButtonFix (copy), ClickToMoveAction (copy), ClickToMovePositionAction (copy), LocalPlayer (copy)
    if p65 then
        if not self.running then
            if LocalPlayer.Character then
                self:OnCharacterAdded(LocalPlayer.Character)
            end

            self.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p68) -- line: 1057
                -- upvalues: self (copy)
                self:OnCharacterAdded(p68)
            end)
            self.running = true
        end

        if not UserDoubleJumpButtonFix then
            self.touchJumpController = p67

            if self.touchJumpController then
                self.touchJumpController:Enable(self.jumpEnabled)
            end
        end
    else
        if self.running then
            self:DisconnectEvents()
            self:CleanupPath()

            if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                local Character = LocalPlayer.Character

                if Character then
                    for _, child in pairs(Character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false
                        end
                    end
                end
            end

            self.running = false
        end

        if not UserDoubleJumpButtonFix then
            if self.touchJumpController and not self.jumpEnabled then
                self.touchJumpController:Enable(true)
            end

            self.touchJumpController = nil
        end
    end

    ClickToMoveAction.Enabled = p65
    ClickToMovePositionAction.Enabled = p65
    self.wasdEnabled = not not (p65 and p66) and p66
    self.enabled = p65
end

function t17:Update(p70, p71) -- line: 1100
    -- upvalues: calculateLocalMoveVector (copy), v124 (ref)
    assert(p70.controlModule.actions.MoveAction)
    assert(p70.controlModule.actions.JumpAction)

    if not self.data then
        self.data = p70
    end

    local v147 = v124

    if v147 then
        v147:OnRenderStepped(p71)

        if v124 and v124 == v147 then
            local v148 = calculateLocalMoveVector(v147.NextActionMoveDirection)
            local ClickToMoveScriptableBinding = p70.controlModule.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding")

            if ClickToMoveScriptableBinding then
                ClickToMoveScriptableBinding:Fire(v148)
            end

            p70.controlModule.moveVector = v148

            if v147.NextActionJump then
                if p70.controlModule.actions.JumpAction:GetState() ~= true then
                    local ClickToMoveScriptableBinding = p70.controlModule.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding")

                    if ClickToMoveScriptableBinding then
                        ClickToMoveScriptableBinding:Fire(true)
                    end
                end

                self.lastPatherJumped = true
                p70.controlModule.isJumping = true
            elseif self.lastPatherJumped then
                if p70.controlModule.actions.JumpAction:GetState() == true then
                    local ClickToMoveScriptableBinding = p70.controlModule.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding")

                    if ClickToMoveScriptableBinding then
                        ClickToMoveScriptableBinding:Fire(false)
                    end
                end

                self.lastPatherJumped = false
                p70.controlModule.isJumping = false
            end
        elseif self.lastPatherJumped then
            if p70.controlModule.actions.JumpAction:GetState() == true then
                local ClickToMoveScriptableBinding = p70.controlModule.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding")

                if ClickToMoveScriptableBinding then
                    ClickToMoveScriptableBinding:Fire(false)
                end
            end

            self.lastPatherJumped = false
        end
    end

    if self.shouldCleanupPath then
        self.shouldCleanupPath = false

        local ClickToMoveScriptableBinding = p70.controlModule.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding")

        if ClickToMoveScriptableBinding then
            ClickToMoveScriptableBinding:Fire(Vector2.zero)
        end

        p70.controlModule.moveVector = Vector2.zero
        self.lastPatherJumped = false

        local ClickToMoveScriptableBinding2 = p70.controlModule.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding")

        if ClickToMoveScriptableBinding2 then
            ClickToMoveScriptableBinding2:Fire(false)
        end

        p70.controlModule.isJumping = false
    end
end

function t17.SetShowPath(_, p73) -- line: 1176
    -- upvalues: v5 (ref)
    v5 = p73
end

function t17.GetShowPath(_) -- line: 1180
    -- upvalues: v5 (ref)
    return v5
end

function t17.SetWaypointTexture(_, p76) -- line: 1184
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p76)
end

function t17.GetWaypointTexture(_) -- line: 1188
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture()
end

function t17.SetWaypointRadius(_, p79) -- line: 1192
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p79)
end

function t17.GetWaypointRadius(_) -- line: 1196
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius()
end

function t17.SetEndWaypointTexture(_, p82) -- line: 1200
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p82)
end

function t17.GetEndWaypointTexture(_) -- line: 1204
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture()
end

function t17.SetWaypointsAlwaysOnTop(_, p85) -- line: 1208
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p85)
end

function t17.GetWaypointsAlwaysOnTop(_) -- line: 1212
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
end

function t17.SetFailureAnimationEnabled(_, p88) -- line: 1216
    -- upvalues: v6 (ref)
    v6 = p88
end

function t17.GetFailureAnimationEnabled(_) -- line: 1220
    -- upvalues: v6 (ref)
    return v6
end

function t17.SetIgnoredPartsTag(_, p91) -- line: 1224
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p91)
end

function t17.GetIgnoredPartsTag(_) -- line: 1228
    -- upvalues: v17 (ref)
    return v17
end

function t17.SetUseDirectPath(_, p94) -- line: 1232
    -- upvalues: v7 (ref)
    v7 = p94
end

function t17.GetUseDirectPath(_) -- line: 1236
    -- upvalues: v7 (ref)
    return v7
end

function t17.SetAgentSizeIncreaseFactor(_, p97) -- line: 1240
    -- upvalues: n1 (ref)
    n1 = p97 / 100 + 1
end

function t17.GetAgentSizeIncreaseFactor(_) -- line: 1244
    -- upvalues: n1 (ref)
    return (n1 - 1) * 100
end

function t17.SetUnreachableWaypointTimeout(_, p100) -- line: 1248
    -- upvalues: n2 (ref)
    n2 = p100
end

function t17.GetUnreachableWaypointTimeout(_) -- line: 1252
    -- upvalues: n2 (ref)
    return n2
end

if not UserDoubleJumpButtonFix then
    function t17:SetUserJumpEnabled(p103) -- line: 1257
        self.jumpEnabled = p103

        if self.touchJumpController then
            self.touchJumpController:Enable(p103)
        end
    end

    function t17:GetUserJumpEnabled() -- line: 1264
        return self.jumpEnabled
    end
end

function t17.MoveTo(p105, p106, p107, p108) -- line: 1269
    -- upvalues: LocalPlayer (copy), Pather (copy)
    local Character = LocalPlayer.Character

    if Character == nil then
        return false
    end

    local v149 = Pather(p106, Vector3.new(0, 1, 0), p108)

    if v149 and v149:IsValidPath() then
        p105:HandleMoveTo(v149, p106, nil, Character, p107)

        return true
    end

    return false
end

return t17
