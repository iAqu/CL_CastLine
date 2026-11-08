-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)
local t1 = {
    "ZonesAssets",
    "Zone 3 - Abandoned Manor",
    "Structures",
    "Haunted Castle",
    "Doors"
}
local t2 = {
    InteriorName = "ManorInterior",
    InteriorTag = "ManorInterior",
    MarkersName = "Markers",
    ExitMarkerName = "ManorDoorExit",
    DoorwayName = "ManorDoorway",
    LightingPreset = "ManorInterior",
    LockName = "Lock",
    DoorNames = table.freeze({ "Door1", "Door2" }),
    Markers = table.freeze({
        Spawn = "Spawn",
        Exit = "Exit",
        Bounds = "Bounds",
        DoorInside = "DoorInside"
    }),
    Attributes = table.freeze({
        Inside = "InManorInterior"
    }),
    Door = table.freeze({
        Reach = 40,
        Height = 50,
        Depth = 7
    }),
    Sounds = table.freeze({
        Ambience = "rbxassetid://134369162018854",
        ChainRattle = "rbxassetid://96614250520996",
        PadlockClunk = "rbxassetid://116406137162867",
        GateClank = "rbxassetid://106997203137026",
        Creak = "rbxassetid://120769059226866",
        FloorCreak = "rbxassetid://130308112542819"
    }),
    Prompt = table.freeze({
        Object = "Manor Door",
        Locked = "Locked",
        Unlock = "Unlock"
    }),
    Messages = table.freeze({
        Locked = "The door is chained shut. Fish up the Manor Key!",
        Unlocked = "The chains give way! Walk in through the open doors.",
        Ragdolled = "Wait until you recover first!",
        Mounted = "Get off your mount first!",
        TooFar = "Get closer to the manor door.",
        Closed = "The manor is sealed right now.",
        Fallback = "The manor door spat you out back in the lobby!"
    })
}

function t2.GateOpen() -- line: 73
    -- upvalues: HalloweenDimensionFlags (copy)
    return HalloweenDimensionFlags.ManorGateOpen:Get() == true
end

function t2.GateOpensAt(p1) -- line: 77
    -- upvalues: HalloweenDimensionFlags (copy)
    for _, v1 in HalloweenDimensionFlags.ManorGateOpen:GetPendingSteps() do
        if v1.Value == true and p1 < v1.At then
            return v1.At
        end
    end

    local v2 = HalloweenDimensionFlags.ManorGateUnlockTime:Get()

    return if p1 < v2 then v2 else nil
end

function t2.DescribeWait(p2) -- line: 87
    if p2 < 60 then
        return "less than a minute"
    end

    local v4 = math.ceil(p2 / 60)

    if v4 < 60 then
        if v4 == 1 then
            return "1 minute"
        end

        return (("%* minutes"):format(v4))
    end

    local v6 = math.ceil(p2 / 3600)

    if v6 < 48 then
        if v6 == 1 then
            return "1 hour"
        end

        return (("%* hours"):format(v6))
    end

    return (("%* days"):format((math.ceil(p2 / 86400))))
end

function t2.Interior() -- line: 102
    -- upvalues: Workspace (copy)
    local ManorInterior = Workspace:FindFirstChild("ManorInterior")

    return if ManorInterior ~= nil and ManorInterior:IsA("Model") then ManorInterior else nil
end

function t2.Marker(p3) -- line: 107
    -- upvalues: t2 (copy)
    local v8 = t2.Interior()
    local Markers = v8 and v8:FindFirstChild("Markers")
    local v9 = Markers and Markers:FindFirstChild(p3)

    return if v9 ~= nil and v9:IsA("BasePart") then v9 else nil
end

function t2.Rooms() -- line: 114
    -- upvalues: t2 (copy)
    local v10 = t2.Interior()
    local Collision = v10 and v10:FindFirstChild("Collision")
    local Rooms = Collision and Collision:FindFirstChild("Rooms")
    local t3 = {}

    if Rooms ~= nil then
        for _, child in Rooms:GetChildren() do
            if child:IsA("BasePart") then
                table.insert(t3, child)
            end
        end
    end

    return t3
end

function t2.RealmMap() -- line: 129
    -- upvalues: Workspace (copy)
    local HalloweenDimension = Workspace:FindFirstChild("HalloweenDimension")

    return if HalloweenDimension ~= nil and HalloweenDimension:IsA("Model") then HalloweenDimension else nil
end

function t2.Doors() -- line: 134
    -- upvalues: t1 (copy), t2 (copy)
    local v11 = t2.RealmMap()

    for _, v12 in t1 do
        v11 = v11 and v11:FindFirstChild(v12)
    end

    return if v11 ~= nil and v11:IsA("Model") then v11 else nil
end

local function realmPart(p4) -- line: 142
    -- upvalues: t2 (copy)
    local v13 = t2.RealmMap()
    local v14 = v13 and v13:FindFirstChild(p4)

    return if v14 ~= nil and v14:IsA("BasePart") then v14 else nil
end

function t2.ExitMarker() -- line: 148
    -- upvalues: t2 (copy)
    local ExitMarkerName = t2.ExitMarkerName
    local v15 = t2.RealmMap()
    local v16 = v15 and v15:FindFirstChild(ExitMarkerName)

    return if v16 ~= nil and v16:IsA("BasePart") then v16 else nil
end

function t2.Doorway() -- line: 152
    -- upvalues: t2 (copy)
    local DoorwayName = t2.DoorwayName
    local v17 = t2.RealmMap()
    local v18 = v17 and v17:FindFirstChild(DoorwayName)

    return if v18 ~= nil and v18:IsA("BasePart") then v18 else nil
end

function t2.DoorOutside(p5) -- line: 156
    -- upvalues: t2 (copy)
    local BoundingBox, BoundingBox2 = p5:GetBoundingBox()
    local v21 = Vector3.new(-BoundingBox.LookVector.X, 0, -BoundingBox.LookVector.Z)

    if v21.Magnitude < 0.01 then
        v21 = Vector3.new(-0, -0, -1, -0)
    end

    local v22 = BoundingBox.Position + v21.Unit * (BoundingBox2.Z / 2 + t2.Door.Depth)

    return CFrame.lookAlong(v22, -v21.Unit)
end

function t2.Within(p6, p7, p8) -- line: 166
    local v23 = p6.CFrame:PointToObjectSpace(p7)
    local v24 = p6.Size / 2 + Vector3.new(1, 1, 1) * p8

    if math.abs(v23.X) <= v24.X then
        if not (math.abs(v23.Y) <= v24.Y) then
            return false
        end

        return math.abs(v23.Z) <= v24.Z
    end

    return false
end

function t2.NearDoors(p9, p10, p11) -- line: 174
    -- upvalues: t2 (copy)
    local BoundingBox = p9:GetBoundingBox()

    if not (Vector2.new(p10.X - BoundingBox.Position.X, p10.Z - BoundingBox.Position.Z).Magnitude <= t2.Door.Reach + p11) then
        return false
    end

    return math.abs(p10.Y - BoundingBox.Position.Y) <= t2.Door.Height + p11
end

return table.freeze(t2)
