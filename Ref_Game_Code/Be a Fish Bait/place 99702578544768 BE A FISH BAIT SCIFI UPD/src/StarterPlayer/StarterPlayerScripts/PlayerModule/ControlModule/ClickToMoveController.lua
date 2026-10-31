-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function v1() -- line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end

local ok, result = pcall(v1)
local v2 = ok and result

local function v3() -- line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end

local ok2, result2 = pcall(v3)
local v4 = ok2 and result2
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

game:GetService("Debris")

local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserRaycastUpdateAPI2 = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI2")
local v5 = true
local v6 = true
local v7 = false
local n1 = 1
local n2 = 8
local t1 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
}
local LocalPlayer = Players.LocalPlayer
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local v8 = RaycastParams.new()

v8.FilterType = Enum.RaycastFilterType.Exclude

local t2 = {}

if not UserRaycastUpdateAPI2 then
    local function FindCharacterAncestor(p1) -- line: 65
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

    t2.FindCharacterAncestor = FindCharacterAncestor

    local function Raycast(p2, p3, p4) -- line: 77
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

    t2.Raycast = Raycast
end

local t3 = {}

local function findPlayerHumanoid(p5) -- line: 99
    -- upvalues: t3 (copy)
    local v15 = p5 and p5.Character

    if not v15 then
        return
    end

    local v16 = t3[p5]

    if v16 and v16.Parent == v15 then
        return v16
    end

    t3[p5] = nil

    local Humanoid = v15:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        t3[p5] = Humanoid
    end

    return Humanoid
end

local t4 = nil
local v17, connection, connection2

local function GetCharacter() -- line: 123
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character
end

local function UpdateIgnoreTag(p6) -- line: 127
    -- upvalues: CollectionService (copy), LocalPlayer (copy), t4 (ref), v17 (ref), connection (ref), connection2 (ref)
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
    t4 = {
        LocalPlayer and LocalPlayer.Character
    }

    if v17 == nil then
        return
    end

    local Tagged = CollectionService:GetTagged(v17)

    for _, v18 in ipairs(Tagged) do
        table.insert(t4, v18)
    end

    connection = CollectionService:GetInstanceAddedSignal(v17):Connect(function(p7) -- line: 147
        -- upvalues: t4 (ref)
        table.insert(t4, p7)
    end)
    connection2 = CollectionService:GetInstanceRemovedSignal(v17):Connect(function(p8) -- line: 151
        -- upvalues: t4 (ref)
        for i = 1, #t4 do
            if t4[i] == p8 then
                t4[i] = t4[#t4]
                table.remove(t4)

                return
            end
        end
    end)
end

local function minV(p9, p10) -- line: 173
    return (Vector3.new(math.min(p9.X, p10.X), math.min(p9.Y, p10.Y), (math.min(p9.Z, p10.Z))))
end

local function maxV(p11, p12) -- line: 176
    return (Vector3.new(math.max(p11.X, p12.X), math.max(p11.Y, p12.Y), (math.max(p11.Z, p12.Z))))
end

local function getCollidableExtentsSize(p13) -- line: 179
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
                local t10 = {
                    Vector3.new(v32.X, v32.Y, v32.Z),
                    Vector3.new(v32.X, v32.Y, -v32.Z),
                    Vector3.new(v32.X, -v32.Y, v32.Z),
                    Vector3.new(v32.X, -v32.Y, -v32.Z),
                    Vector3.new(-v32.X, v32.Y, v32.Z),
                    Vector3.new(-v32.X, v32.Y, -v32.Z),
                    Vector3.new(-v32.X, -v32.Y, v32.Z),
                    (Vector3.new(-v32.X, -v32.Y, -v32.Z))
                }

                for _, v54 in ipairs(t10) do
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

local function Pather(p14, p15, p16) -- line: 214
    -- upvalues: v2 (copy), v4 (copy), PathfindingService (copy), Workspace (copy), UserRaycastUpdateAPI2 (copy), v5 (ref), v7 (ref), n1 (ref), n2 (ref), LocalPlayer (copy), ClickToMoveDisplay (copy), v8 (copy), t3 (copy), t4 (ref), getCollidableExtentsSize (copy)
    local v63, v64

    if p16 ~= nil then
        v64 = p16
        v63 = p16
    else
        v64 = v7
        v63 = true
    end

    local t11 = {}

    t11.Cancelled = false
    t11.Started = false
    t11.Finished = Instance.new("BindableEvent")
    t11.PathFailed = Instance.new("BindableEvent")
    t11.PathComputing = false
    t11.PathComputed = false
    t11.OriginalTargetPoint = p14
    t11.TargetPoint = p14
    t11.TargetSurfaceNormal = p15
    t11.DiedConn = nil
    t11.SeatedConn = nil
    t11.BlockedConn = nil
    t11.TeleportedConn = nil
    t11.CurrentPoint = 0
    t11.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    t11.CurrentWaypointPosition = nil
    t11.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    t11.CurrentWaypointPlaneDistance = 0
    t11.CurrentWaypointNeedsJump = false
    t11.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    t11.CurrentHumanoidVelocity = 0
    t11.NextActionMoveDirection = Vector3.new(0, 0, 0)
    t11.NextActionJump = false
    t11.Timeout = 0

    local v65 = LocalPlayer and LocalPlayer.Character
    local v66

    if v65 then
        v66 = t3[LocalPlayer]

        if not v66 or v66.Parent ~= v65 then
            t3[LocalPlayer] = nil

            local Humanoid = v65:FindFirstChildOfClass("Humanoid")

            v66 = Humanoid

            if Humanoid then
                t3[LocalPlayer] = Humanoid
            end
        end
    end

    t11.Humanoid = v66
    t11.OriginPoint = nil
    t11.AgentCanFollowPath = false
    t11.DirectPath = false
    t11.DirectPathRiseFirst = false
    t11.stopTraverseFunc = nil
    t11.setPointFunc = nil
    t11.pointList = nil

    local v67 = t11.Humanoid and t11.Humanoid.RootPart
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
        t11.OriginPoint = v67.CFrame.Position
        SeatPart = t11.Humanoid.SeatPart

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

        if t11.Humanoid.JumpPower > 0 then
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
        t11.AgentCanFollowPath = true
        t11.DirectPath = v64
        t11.DirectPathRiseFirst = t11.Humanoid.Sit
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
        t11.AgentCanFollowPath = true
        v89 = false
        v71 = true
        t11.DirectPath = v63
    end

    if v71 then
        Model.PrimaryPart = PrimaryPart
        v84 = v87
        v85 = v88
        v86 = v89
        v73 = false
    end

    if not v73 then
        t11.pathResult = if v4 then PathfindingService:CreatePath({
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

    function t11.Cleanup(_) -- line: 332
        -- upvalues: t11 (copy)
        if t11.stopTraverseFunc then
            t11.stopTraverseFunc()
            t11.stopTraverseFunc = nil
        end

        if t11.BlockedConn then
            t11.BlockedConn:Disconnect()
            t11.BlockedConn = nil
        end

        if t11.DiedConn then
            t11.DiedConn:Disconnect()
            t11.DiedConn = nil
        end

        if t11.SeatedConn then
            t11.SeatedConn:Disconnect()
            t11.SeatedConn = nil
        end

        if t11.TeleportedConn then
            t11.TeleportedConn:Disconnect()
            t11.TeleportedConn = nil
        end

        t11.Started = false
    end

    function t11.Cancel(_) -- line: 361
        -- upvalues: t11 (copy)
        t11.Cancelled = true
        t11:Cleanup()
    end

    function t11.IsActive(_) -- line: 366
        -- upvalues: t11 (copy)
        return t11.AgentCanFollowPath and t11.Started and not t11.Cancelled
    end

    function t11.OnPathInterrupted(_) -- line: 370
        -- upvalues: t11 (copy)
        t11.Cancelled = true
        t11:OnPointReached(false)
    end

    function t11.ComputePath(_) -- line: 376
        -- upvalues: t11 (copy)
        if t11.OriginPoint then
            if t11.PathComputed or t11.PathComputing then
                return
            end

            t11.PathComputing = true

            if t11.AgentCanFollowPath then
                if t11.DirectPath then
                    t11.pointList = {
                        PathWaypoint.new(t11.OriginPoint, Enum.PathWaypointAction.Walk),
                        PathWaypoint.new(t11.TargetPoint, t11.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk)
                    }
                    t11.PathComputed = true
                else
                    t11.pathResult:ComputeAsync(t11.OriginPoint, t11.TargetPoint)
                    t11.pointList = t11.pathResult:GetWaypoints()
                    t11.BlockedConn = t11.pathResult.Blocked:Connect(function(p22) -- line: 390
                        -- upvalues: t11 (copy)
                        t11:OnPathBlocked(p22)
                    end)
                    t11.PathComputed = t11.pathResult.Status == Enum.PathStatus.Success
                end
            end

            t11.PathComputing = false
        end
    end

    function t11.IsValidPath(_) -- line: 398
        -- upvalues: t11 (copy)
        t11:ComputePath()

        return t11.PathComputed and t11.AgentCanFollowPath
    end

    t11.Recomputing = false

    function t11.OnPathBlocked(_, p25) -- line: 404
        -- upvalues: t11 (copy), v5 (ref), ClickToMoveDisplay (copy)
        if not (t11.CurrentPoint <= p25) or t11.Recomputing then
            return
        else
            t11.Recomputing = true

            if t11.stopTraverseFunc then
                t11.stopTraverseFunc()
                t11.stopTraverseFunc = nil
            end
        end

        t11.OriginPoint = t11.Humanoid.RootPart.CFrame.p
        t11.pathResult:ComputeAsync(t11.OriginPoint, t11.TargetPoint)
        t11.pointList = t11.pathResult:GetWaypoints()

        if #t11.pointList > 0 then
            t11.HumanoidOffsetFromPath = t11.pointList[1].Position - t11.OriginPoint
        end

        t11.PathComputed = t11.pathResult.Status == Enum.PathStatus.Success

        if v5 then
            local v95, v96 = ClickToMoveDisplay.CreatePathDisplay(t11.pointList)

            t11.stopTraverseFunc = v95
            t11.setPointFunc = v96
        end

        if t11.PathComputed then
            t11.CurrentPoint = 1
            t11:OnPointReached(true)
        else
            t11.PathFailed:Fire()
            t11:Cleanup()
        end

        t11.Recomputing = false
    end

    function t11.OnRenderStepped(_, p27) -- line: 440
        -- upvalues: t11 (copy), n2 (ref)
        if not t11.Started or t11.Cancelled then
            return
        end

        t11.Timeout += p27

        if t11.Timeout > n2 then
            t11:OnPointReached(false)
        else
            t11.CurrentHumanoidPosition = t11.Humanoid.RootPart.Position + t11.HumanoidOffsetFromPath
            t11.CurrentHumanoidVelocity = t11.Humanoid.RootPart.Velocity

            while t11.Started and t11:IsCurrentWaypointReached() do
                t11:OnPointReached(true)
            end

            if t11.Started then
                t11.NextActionMoveDirection = t11.CurrentWaypointPosition - t11.CurrentHumanoidPosition
                t11.NextActionMoveDirection = if t11.NextActionMoveDirection.Magnitude > 1E-06 then t11.NextActionMoveDirection.Unit else Vector3.new(0, 0, 0)

                if t11.CurrentWaypointNeedsJump then
                    t11.NextActionJump = true
                    t11.CurrentWaypointNeedsJump = false
                else
                    t11.NextActionJump = false
                end
            end
        end
    end

    function t11.IsCurrentWaypointReached(_) -- line: 478
        -- upvalues: t11 (copy)
        local v97 = t11.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) or t11.CurrentWaypointPlaneNormal:Dot(t11.CurrentHumanoidPosition) - t11.CurrentWaypointPlaneDistance < math.max(1, 0.0625 * -t11.CurrentWaypointPlaneNormal:Dot(t11.CurrentHumanoidVelocity))

        if v97 then
            t11.CurrentWaypointPosition = nil
            t11.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t11.CurrentWaypointPlaneDistance = 0
        end

        return v97
    end

    function t11.OnPointReached(_, p30) -- line: 504
        -- upvalues: t11 (copy)
        if not p30 or t11.Cancelled then
            t11.PathFailed:Fire()
            t11:Cleanup()

            return
        elseif t11.setPointFunc then
            t11.setPointFunc(t11.CurrentPoint)
        end

        local v101 = t11.CurrentPoint + 1

        if #t11.pointList < v101 then
            if t11.stopTraverseFunc then
                t11.stopTraverseFunc()
            end

            t11.Finished:Fire()
            t11:Cleanup()
        else
            local v102 = t11.pointList[t11.CurrentPoint]
            local v103 = t11.pointList[v101]
            local State = t11.Humanoid:GetState()

            if State == Enum.HumanoidStateType.FallingDown or State == Enum.HumanoidStateType.Freefall or State == Enum.HumanoidStateType.Jumping then
                local v104 = v103.Action == Enum.PathWaypointAction.Jump

                if not v104 and t11.CurrentPoint > 1 then
                    local v105 = t11.pointList[t11.CurrentPoint - 1]
                    local v106 = v102.Position - v105.Position
                    local v107 = v103.Position - v102.Position

                    v104 = Vector2.new(v106.x, v106.z).Unit:Dot(Vector2.new(v107.x, v107.z).Unit) < 0.996
                end

                if v104 then
                    t11.Humanoid.FreeFalling:Wait()
                    wait(0.1)
                end
            end

            t11:MoveToNextWayPoint(v102, v103, v101)
        end
    end

    function t11.MoveToNextWayPoint(_, p32, p33, p34) -- line: 567
        -- upvalues: t11 (copy), v4 (copy)
        t11.CurrentWaypointPlaneNormal = p32.Position - p33.Position

        if not v4 or p33.Label ~= "Climb" then
            t11.CurrentWaypointPlaneNormal = Vector3.new(t11.CurrentWaypointPlaneNormal.X, 0, t11.CurrentWaypointPlaneNormal.Z)
        end

        if t11.CurrentWaypointPlaneNormal.Magnitude > 1E-06 then
            t11.CurrentWaypointPlaneNormal = t11.CurrentWaypointPlaneNormal.Unit
            t11.CurrentWaypointPlaneDistance = t11.CurrentWaypointPlaneNormal:Dot(p33.Position)
        else
            t11.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t11.CurrentWaypointPlaneDistance = 0
        end

        t11.CurrentWaypointNeedsJump = p33.Action == Enum.PathWaypointAction.Jump
        t11.CurrentWaypointPosition = p33.Position
        t11.CurrentPoint = p34
        t11.Timeout = 0
    end

    function t11.Start(_, p36) -- line: 599
        -- upvalues: t11 (copy), v5 (ref), ClickToMoveDisplay (copy)
        if not t11.AgentCanFollowPath then
            t11.PathFailed:Fire()

            return
        end

        if not t11.Started then
            t11.Started = true
            ClickToMoveDisplay.CancelFailureAnimation()

            if v5 and (p36 == nil or p36) then
                local v108, v109 = ClickToMoveDisplay.CreatePathDisplay(t11.pointList, t11.OriginalTargetPoint)

                t11.stopTraverseFunc = v108
                t11.setPointFunc = v109
            end

            if #t11.pointList > 0 then
                t11.HumanoidOffsetFromPath = Vector3.new(0, t11.pointList[1].Position.Y - t11.OriginPoint.Y, 0)
                t11.CurrentHumanoidPosition = t11.Humanoid.RootPart.Position + t11.HumanoidOffsetFromPath
                t11.CurrentHumanoidVelocity = t11.Humanoid.RootPart.Velocity
                t11.SeatedConn = t11.Humanoid.Seated:Connect(function(_, _) -- line: 626
                    -- upvalues: t11 (copy)
                    t11:OnPathInterrupted()
                end)
                t11.DiedConn = t11.Humanoid.Died:Connect(function() -- line: 627
                    -- upvalues: t11 (copy)
                    t11:OnPathInterrupted()
                end)
                t11.TeleportedConn = t11.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 628
                    -- upvalues: t11 (copy)
                    t11:OnPathInterrupted()
                end)
                t11.CurrentPoint = 1
                t11:OnPointReached(true)
            else
                t11.PathFailed:Fire()

                if t11.stopTraverseFunc then
                    t11.stopTraverseFunc()
                end
            end
        end
    end

    local v111 = t11.TargetPoint + t11.TargetSurfaceNormal * 1.5

    if UserRaycastUpdateAPI2 then
        if not t4 then
            t4 = {}
            assert(t4, "")

            local t13 = t4

            table.insert(t13, LocalPlayer and LocalPlayer.Character)
        end

        local t14 = t4

        v8.FilterDescendantsInstances = t14

        local v113 = Workspace:Raycast(v111, Vector3.new(-0, -50, -0, -0), v8)

        if v113 then
            t11.TargetPoint = v113.Position
        end
    else
        local v114 = Ray.new(v111, (Vector3.new(0, -50, 0)))

        if not t4 then
            t4 = {}
            assert(t4, "")

            local t16 = t4

            table.insert(t16, LocalPlayer and LocalPlayer.Character)
        end

        local t17 = t4
        local v116, v117 = Workspace:FindPartOnRayWithIgnoreList(v114, t17)

        if v116 then
            t11.TargetPoint = v117
        end
    end

    t11:ComputePath()

    return t11
end

local function CheckAlive() -- line: 664
    -- upvalues: LocalPlayer (copy), t3 (copy)
    local v118 = LocalPlayer and LocalPlayer.Character
    local v119

    if v118 then
        v119 = t3[LocalPlayer]

        if not v119 or v119.Parent ~= v118 then
            t3[LocalPlayer] = nil

            local Humanoid = v118:FindFirstChildOfClass("Humanoid")

            v119 = Humanoid

            if Humanoid then
                t3[LocalPlayer] = Humanoid
            end
        end
    end

    return v119 ~= nil and v119.Health > 0
end

local function GetEquippedTool(p39) -- line: 669
    if p39 == nil then
        return
    end

    for _, child in pairs(p39:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
end

local v120, connection3, connection4

local function CleanupPath() -- line: 684
    -- upvalues: v120 (ref), connection3 (ref), connection4 (ref)
    if v120 then
        v120:Cancel()
        v120 = nil
    end

    if connection3 then
        connection3:Disconnect()
        connection3 = nil
    end

    if connection4 then
        connection4:Disconnect()
        connection4 = nil
    end
end

local function HandleMoveTo(p40, p41, p42, p43, p44) -- line: 702
    -- upvalues: v6 (ref), ClickToMoveDisplay (copy), GetEquippedTool (copy), v120 (ref), connection3 (ref), connection4 (ref)
    if v120 then
        v120:Cancel()
        v120 = nil

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end
    end

    v120 = p40
    p40:Start(p44)
    connection3 = p40.Finished.Event:Connect(function() -- line: 709
        -- upvalues: p42 (copy), p43 (copy), GetEquippedTool (copy), v120 (ref), connection3 (ref), connection4 (ref)
        if v120 then
            v120:Cancel()
            v120 = nil
        end

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end

        if p42 then
            local v121 = GetEquippedTool(p43)

            if v121 then
                v121:Activate()
            end
        end
    end)
    connection4 = p40.PathFailed.Event:Connect(function() -- line: 718
        -- upvalues: p41 (copy), p44 (copy), v6 (ref), ClickToMoveDisplay (copy), v120 (ref), connection3 (ref), connection4 (ref)
        if v120 then
            v120:Cancel()
            v120 = nil
        end

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end

        if p44 == nil or p44 then
            if v6 and not (v120 and v120:IsActive()) then
                ClickToMoveDisplay.PlayFailureAnimation()
            end

            ClickToMoveDisplay.DisplayFailureWaypoint(p41)
        end
    end)
end

local function ShowPathFailedFeedback(p45) -- line: 730
    -- upvalues: v6 (ref), ClickToMoveDisplay (copy), v120 (ref)
    if v120 and v120:IsActive() then
        v120:Cancel()
    end

    if v6 then
        ClickToMoveDisplay.PlayFailureAnimation()
    end

    ClickToMoveDisplay.DisplayFailureWaypoint(p45)
end

function OnTap(p46, p47, p48) -- line: 740
    -- upvalues: Players (copy), StarterGui (copy), Workspace (copy), UserRaycastUpdateAPI2 (copy), v6 (ref), LocalPlayer (copy), ClickToMoveDisplay (copy), v8 (copy), t2 (copy), t3 (copy), t4 (ref), Pather (copy), GetEquippedTool (copy), v120 (ref), connection3 (ref), connection4 (ref), HandleMoveTo (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v122 = LocalPlayer and LocalPlayer.Character
    local v123

    if v122 then
        v123 = t3[LocalPlayer]

        if not v123 or v123.Parent ~= v122 then
            t3[LocalPlayer] = nil

            local Humanoid = v122:FindFirstChildOfClass("Humanoid")

            v123 = Humanoid

            if Humanoid then
                t3[LocalPlayer] = Humanoid
            end
        end
    end

    if v123 ~= nil and v123.Health > 0 then
        if #p46 == 1 or p47 then
            if CurrentCamera then
                local v124 = CurrentCamera:ScreenPointToRay(p46[1].X, p46[1].Y)

                if UserRaycastUpdateAPI2 then
                    if not t4 then
                        t4 = {}
                        assert(t4, "")

                        local t19 = t4

                        table.insert(t19, LocalPlayer and LocalPlayer.Character)
                    end

                    local t20 = t4
                    local v126, Humanoid

                    if not t20 then
                        Humanoid = nil
                        v126 = nil
                        t20 = {}
                    end

                    local v127

                    repeat
                        v8.FilterDescendantsInstances = t20
                        v127 = Workspace:Raycast(v124.Origin, v124.Direction * 1000, v8)

                        local v128

                        if v127 then
                            local Instance = v127.Instance

                            if Instance.CanCollide then
                                v128 = true
                            else
                                v126 = Instance

                                local Parent

                                while true do
                                    Humanoid = v126:FindFirstChildOfClass("Humanoid")
                                    Parent = v126.Parent

                                    if not Humanoid and Parent then
                                        v126 = Parent
                                        continue
                                    end

                                    break
                                end

                                if Humanoid then
                                    v128 = true
                                elseif Parent then
                                    v126 = nil
                                    v128 = false
                                    table.insert(t20, Parent)
                                else
                                    v128 = true
                                end
                            end
                        else
                            v128 = true
                        end
                    until v128

                    if p48 and Humanoid and StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(Humanoid.Parent) then
                        if v120 then
                            v120:Cancel()
                            v120 = nil
                        end

                        if connection3 then
                            connection3:Disconnect()
                            connection3 = nil
                        end

                        if connection4 then
                            connection4:Disconnect()
                            connection4 = nil
                        end
                    elseif v127 and Character then
                        local Position = v127.Position
                        local v129

                        if p47 then
                            Position = p47
                        else
                            v129 = v126
                        end

                        if v120 then
                            v120:Cancel()
                            v120 = nil
                        end

                        if connection3 then
                            connection3:Disconnect()
                            connection3 = nil
                        end

                        if connection4 then
                            connection4:Disconnect()
                            connection4 = nil
                        end

                        local v130 = Pather(Position, v127.Normal)

                        if v130:IsValidPath() then
                            HandleMoveTo(v130, Position, v129, Character)
                        else
                            v130:Cleanup()

                            if v120 and v120:IsActive() then
                                v120:Cancel()
                            end

                            if v6 then
                                ClickToMoveDisplay.PlayFailureAnimation()
                            end

                            ClickToMoveDisplay.DisplayFailureWaypoint(Position)
                        end
                    end
                else
                    local v131 = Ray.new(v124.Origin, v124.Direction * 1000)
                    local Raycast = t2.Raycast

                    if not t4 then
                        t4 = {}
                        assert(t4, "")

                        local t22 = t4

                        table.insert(t22, LocalPlayer and LocalPlayer.Character)
                    end

                    local v133, v134, v135 = Raycast(v131, true, t4)
                    local v136, v137 = t2.FindCharacterAncestor(v133)

                    if p48 and v137 and StarterGui:GetCore("AvatarContextMenuEnabled") and Players:GetPlayerFromCharacter(v137.Parent) then
                        if v120 then
                            v120:Cancel()
                            v120 = nil
                        end

                        if connection3 then
                            connection3:Disconnect()
                            connection3 = nil
                        end

                        if connection4 then
                            connection4:Disconnect()
                            connection4 = nil
                        end
                    else
                        if p47 then
                            v134 = p47
                            v136 = nil
                        end

                        if v134 and Character then
                            if v120 then
                                v120:Cancel()
                                v120 = nil
                            end

                            if connection3 then
                                connection3:Disconnect()
                                connection3 = nil
                            end

                            if connection4 then
                                connection4:Disconnect()
                                connection4 = nil
                            end

                            local v138 = Pather(v134, v135)

                            if v138:IsValidPath() then
                                HandleMoveTo(v138, v134, v136, Character)
                            else
                                v138:Cleanup()

                                if v120 and v120:IsActive() then
                                    v120:Cancel()
                                end

                                if v6 then
                                    ClickToMoveDisplay.PlayFailureAnimation()
                                end

                                ClickToMoveDisplay.DisplayFailureWaypoint(v134)
                            end
                        end
                    end
                end
            end
        elseif #p46 >= 2 and CurrentCamera then
            local v139 = GetEquippedTool(Character)

            if v139 then
                v139:Activate()
            end
        end
    end
end

local function DisconnectEvent(p49) -- line: 850
    if p49 then
        p49:Disconnect()
    end
end

local Keyboard = require(script.Parent:WaitForChild("Keyboard"))
local self = setmetatable({}, Keyboard)

self.__index = self

function self.new(p50) -- line: 861
    -- upvalues: Keyboard (copy), self (copy)
    local v142 = setmetatable(Keyboard.new(p50), self)

    v142.fingerTouches = {}
    v142.numUnsunkTouches = 0
    v142.mouse2DownTime = tick()
    v142.mouse2DownPos = Vector2.new()
    v142.mouse2UpTime = tick()
    v142.keyboardMoveVector = Vector3.new(0, 0, 0)
    v142.tapConn = nil
    v142.inputBeganConn = nil
    v142.inputChangedConn = nil
    v142.inputEndedConn = nil
    v142.humanoidDiedConn = nil
    v142.characterChildAddedConn = nil
    v142.onCharacterAddedConn = nil
    v142.characterChildRemovedConn = nil
    v142.renderSteppedConn = nil
    v142.menuOpenedConnection = nil
    v142.preferredInputChangedConnection = nil
    v142.running = false
    v142.wasdEnabled = false

    return v142
end

function self.DisconnectEvents(p51) -- line: 892
    local tapConn = p51.tapConn

    if tapConn then
        tapConn:Disconnect()
    end

    local inputBeganConn = p51.inputBeganConn

    if inputBeganConn then
        inputBeganConn:Disconnect()
    end

    local inputChangedConn = p51.inputChangedConn

    if inputChangedConn then
        inputChangedConn:Disconnect()
    end

    local inputEndedConn = p51.inputEndedConn

    if inputEndedConn then
        inputEndedConn:Disconnect()
    end

    local humanoidDiedConn = p51.humanoidDiedConn

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect()
    end

    local characterChildAddedConn = p51.characterChildAddedConn

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect()
    end

    local onCharacterAddedConn = p51.onCharacterAddedConn

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect()
    end

    local renderSteppedConn = p51.renderSteppedConn

    if renderSteppedConn then
        renderSteppedConn:Disconnect()
    end

    local characterChildRemovedConn = p51.characterChildRemovedConn

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect()
    end

    local menuOpenedConnection = p51.menuOpenedConnection

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect()
    end

    local preferredInputChangedConnection = p51.preferredInputChangedConnection

    if preferredInputChangedConnection then
        preferredInputChangedConnection:Disconnect()
    end
end

function self.OnTouchBegan(p52, p53, p54) -- line: 906
    if p52.fingerTouches[p53] == nil and not p54 then
        p52.numUnsunkTouches += 1
    end

    p52.fingerTouches[p53] = p54
end

function self.OnTouchChanged(p55, p56, p57) -- line: 913
    if p55.fingerTouches[p56] == nil then
        p55.fingerTouches[p56] = p57

        if not p57 then
            p55.numUnsunkTouches += 1
        end
    end
end

function self.OnTouchEnded(p58, p59, _) -- line: 922
    if p58.fingerTouches[p59] ~= nil and p58.fingerTouches[p59] == false then
        p58.numUnsunkTouches -= 1
    end

    p58.fingerTouches[p59] = nil
end

function self.OnPreferredInputChanged(_) -- line: 929
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

function self.OnCharacterAdded(p62, p63) -- line: 941
    -- upvalues: UserInputService (copy), GuiService (copy), t1 (copy), ClickToMoveDisplay (copy), v120 (ref), connection3 (ref), connection4 (ref)
    p62:DisconnectEvents()
    p62.inputBeganConn = UserInputService.InputBegan:Connect(function(p64, p65) -- line: 944
        -- upvalues: p62 (copy), t1 (copy), ClickToMoveDisplay (copy), v120 (ref), connection3 (ref), connection4 (ref)
        if p64.UserInputType == Enum.UserInputType.Touch then
            p62:OnTouchBegan(p64, p65)
        end

        if p62.wasdEnabled and p65 == false and p64.UserInputType == Enum.UserInputType.Keyboard and t1[p64.KeyCode] then
            if v120 then
                v120:Cancel()
                v120 = nil
            end

            if connection3 then
                connection3:Disconnect()
                connection3 = nil
            end

            if connection4 then
                connection4:Disconnect()
                connection4 = nil
            end

            ClickToMoveDisplay.CancelFailureAnimation()
        end

        if p64.UserInputType == Enum.UserInputType.MouseButton2 then
            p62.mouse2DownTime = tick()
            p62.mouse2DownPos = p64.Position
        end
    end)
    p62.inputChangedConn = UserInputService.InputChanged:Connect(function(p66, p67) -- line: 961
        -- upvalues: p62 (copy)
        if p66.UserInputType == Enum.UserInputType.Touch then
            p62:OnTouchChanged(p66, p67)
        end
    end)
    p62.inputEndedConn = UserInputService.InputEnded:Connect(function(p68, p69) -- line: 967
        -- upvalues: p62 (copy), v120 (ref)
        if p68.UserInputType == Enum.UserInputType.Touch then
            p62:OnTouchEnded(p68, p69)
        end

        if p68.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        p62.mouse2UpTime = tick()

        local Position = p68.Position
        local v144 = v120 or p62.keyboardMoveVector.Magnitude <= 0

        if p62.mouse2UpTime - p62.mouse2DownTime < 0.25 and (Position - p62.mouse2DownPos).magnitude < 5 and v144 then
            local t24 = {
                Position
            }

            OnTap(t24)
        end
    end)
    p62.tapConn = UserInputService.TouchTap:Connect(function(p70, p71) -- line: 984
        if not p71 then
            OnTap(p70, nil, true)
        end
    end)
    p62.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- line: 990
        -- upvalues: v120 (ref), connection3 (ref), connection4 (ref)
        if v120 then
            v120:Cancel()
            v120 = nil
        end

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end
    end)

    local function OnCharacterChildAdded(p72) -- line: 994
        -- upvalues: p62 (copy), UserInputService (copy)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p72:IsA("Tool") then
            p72.ManualActivationOnly = true
        end

        if p72:IsA("Humanoid") then
            local humanoidDiedConn = p62.humanoidDiedConn

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect()
            end

            p62.humanoidDiedConn = p72.Died:Connect(function() -- line: 1002
            end)
        end
    end

    p62.characterChildAddedConn = p63.ChildAdded:Connect(function(p73) -- line: 1010
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p73)
    end)
    p62.characterChildRemovedConn = p63.ChildRemoved:Connect(function(p74) -- line: 1013
        -- upvalues: UserInputService (copy)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p74:IsA("Tool") then
            p74.ManualActivationOnly = false
        end
    end)

    for _, child in pairs(p63:GetChildren()) do
        OnCharacterChildAdded(child)
    end

    p62.preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1024
        -- upvalues: p62 (copy)
        p62:OnPreferredInputChanged()
    end)
end

function self.Start(p75) -- line: 1029
    p75:Enable(true)
end

function self.Stop(p76) -- line: 1033
    p76:Enable(false)
end

function self.CleanupPath(_) -- line: 1037
    -- upvalues: v120 (ref), connection3 (ref), connection4 (ref)
    if v120 then
        v120:Cancel()
        v120 = nil
    end

    if connection3 then
        connection3:Disconnect()
        connection3 = nil
    end

    if connection4 then
        connection4:Disconnect()
        connection4 = nil
    end
end

function self.Enable(p78, p79, p80, p81) -- line: 1041
    -- upvalues: UserInputService (copy), LocalPlayer (copy), v120 (ref), connection3 (ref), connection4 (ref), Keyboard (copy)
    if p79 then
        if not p78.running then
            if LocalPlayer.Character then
                p78:OnCharacterAdded(LocalPlayer.Character)
            end

            p78.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p82) -- line: 1047
                -- upvalues: p78 (copy)
                p78:OnCharacterAdded(p82)
            end)
            p78.running = true
        end

        p78.touchJumpController = p81

        if p78.touchJumpController then
            p78.touchJumpController:Enable(p78.jumpEnabled)
        end
    else
        if p78.running then
            p78:DisconnectEvents()

            if v120 then
                v120:Cancel()
                v120 = nil
            end

            if connection3 then
                connection3:Disconnect()
                connection3 = nil
            end

            if connection4 then
                connection4:Disconnect()
                connection4 = nil
            end

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

            p78.running = false
        end

        if p78.touchJumpController and not p78.jumpEnabled then
            p78.touchJumpController:Enable(true)
        end

        p78.touchJumpController = nil
    end

    Keyboard.Enable(p78, p79)
    p78.wasdEnabled = not not (p79 and p80) and p80
    p78.enabled = p79
end

function self.OnRenderStepped(p83, p84) -- line: 1086
    -- upvalues: v120 (ref)
    p83.isJumping = false

    if v120 then
        v120:OnRenderStepped(p84)

        if v120 then
            p83.moveVector = v120.NextActionMoveDirection
            p83.moveVectorIsCameraRelative = false

            if v120.NextActionJump then
                p83.isJumping = true
            end
        else
            p83.moveVector = p83.keyboardMoveVector
            p83.moveVectorIsCameraRelative = true
        end
    else
        p83.moveVector = p83.keyboardMoveVector
        p83.moveVectorIsCameraRelative = true
    end

    if p83.jumpRequested then
        p83.isJumping = true
    end
end

function self.UpdateMovement(p85, p86) -- line: 1121
    if p86 == Enum.UserInputState.Cancel then
        p85.keyboardMoveVector = Vector3.new(0, 0, 0)
    elseif p85.wasdEnabled then
        p85.keyboardMoveVector = Vector3.new(p85.leftValue + p85.rightValue, 0, p85.forwardValue + p85.backwardValue)
    end
end

function self.UpdateJump(_) -- line: 1130
end

function self.SetShowPath(_, p89) -- line: 1135
    -- upvalues: v5 (ref)
    v5 = p89
end

function self.GetShowPath(_) -- line: 1139
    -- upvalues: v5 (ref)
    return v5
end

function self.SetWaypointTexture(_, p92) -- line: 1143
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p92)
end

function self.GetWaypointTexture(_) -- line: 1147
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture()
end

function self.SetWaypointRadius(_, p95) -- line: 1151
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p95)
end

function self.GetWaypointRadius(_) -- line: 1155
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius()
end

function self.SetEndWaypointTexture(_, p98) -- line: 1159
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p98)
end

function self.GetEndWaypointTexture(_) -- line: 1163
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture()
end

function self.SetWaypointsAlwaysOnTop(_, p101) -- line: 1167
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p101)
end

function self.GetWaypointsAlwaysOnTop(_) -- line: 1171
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
end

function self.SetFailureAnimationEnabled(_, p104) -- line: 1175
    -- upvalues: v6 (ref)
    v6 = p104
end

function self.GetFailureAnimationEnabled(_) -- line: 1179
    -- upvalues: v6 (ref)
    return v6
end

function self.SetIgnoredPartsTag(_, p107) -- line: 1183
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p107)
end

function self.GetIgnoredPartsTag(_) -- line: 1187
    -- upvalues: v17 (ref)
    return v17
end

function self.SetUseDirectPath(_, p110) -- line: 1191
    -- upvalues: v7 (ref)
    v7 = p110
end

function self.GetUseDirectPath(_) -- line: 1195
    -- upvalues: v7 (ref)
    return v7
end

function self.SetAgentSizeIncreaseFactor(_, p113) -- line: 1199
    -- upvalues: n1 (ref)
    n1 = p113 / 100 + 1
end

function self.GetAgentSizeIncreaseFactor(_) -- line: 1203
    -- upvalues: n1 (ref)
    return (n1 - 1) * 100
end

function self.SetUnreachableWaypointTimeout(_, p116) -- line: 1207
    -- upvalues: n2 (ref)
    n2 = p116
end

function self.GetUnreachableWaypointTimeout(_) -- line: 1211
    -- upvalues: n2 (ref)
    return n2
end

function self.SetUserJumpEnabled(p118, p119) -- line: 1215
    p118.jumpEnabled = p119

    if p118.touchJumpController then
        p118.touchJumpController:Enable(p119)
    end
end

function self.GetUserJumpEnabled(p120) -- line: 1222
    return p120.jumpEnabled
end

function self.MoveTo(_, p122, p123, p124) -- line: 1226
    -- upvalues: LocalPlayer (copy), Pather (copy), HandleMoveTo (copy)
    local Character = LocalPlayer.Character

    if Character == nil then
        return false
    end

    local v148 = Pather(p122, Vector3.new(0, 1, 0), p124)

    if v148 and v148:IsValidPath() then
        HandleMoveTo(v148, p122, nil, Character, p123)

        return true
    end

    return false
end

return self
