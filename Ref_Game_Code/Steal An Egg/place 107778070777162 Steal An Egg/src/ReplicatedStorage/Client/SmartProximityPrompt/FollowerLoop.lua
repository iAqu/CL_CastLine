-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = require(ReplicatedStorage.Shared.Player)

require(script.Parent.SurfaceTracker)

local t1 = {
    Size = Vector3.new(1, 1, 1),
    Transparency = 1,
    Anchored = true,
    CanCollide = false,
    CanTouch = false,
    CanQuery = false
}
local t2 = {}
local LocalPlayer = Players.LocalPlayer
local t3 = {}
local connection
local n1 = 0

local function stopPulseIfIdle() -- line: 49
    -- upvalues: t3 (copy), connection (ref)
    if next(t3) ~= nil or connection == nil then
        return
    end

    connection:Disconnect()
    connection = nil
end

local function chase(p1, p2, p3) -- line: 58
    local ClosestSurfacePoint, ClosestSurfacePoint2 = p1.tracker:GetClosestSurfacePoint(p2, p1.standoff, p1.range)

    if ClosestSurfacePoint == nil or ClosestSurfacePoint2 == nil or p1.range < ClosestSurfacePoint2 then
        p1.anchor.CFrame = p1.model:GetPivot()

        return
    end

    local v1 = if (p1.anchor.Position - ClosestSurfacePoint).Magnitude > p1.range then 1 else math.clamp(p3 * p1.rate, 0, 1)

    p1.anchor.CFrame = CFrame.new(p1.anchor.Position:Lerp(ClosestSurfacePoint, v1))
end

local function dropFollower(p4, p5) -- line: 70
    -- upvalues: t3 (copy), connection (ref)
    local v3 = t3[p4]

    if v3 == nil or p5 ~= nil and v3.id ~= p5 then
        return
    end

    t3[p4] = nil

    for _, v4 in v3.connections do
        v4:Disconnect()
    end

    table.clear(v3.connections)

    if next(t3) == nil and connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    if p4.Parent == v3.anchor then
        p4.Parent = nil
    end

    v3.tracker:Destroy()
    v3.anchor:Destroy()
end

function t2.Drop(p6) -- line: 93
    -- upvalues: dropFollower (copy)
    dropFollower(p6, nil)
end

local function advance(p7) -- line: 97
    -- upvalues: Player (copy), LocalPlayer (copy), t3 (copy), chase (copy), dropFollower (copy)
    local v5 = Player.FindPrimaryPart(LocalPlayer)
    local Position = if v5 then v5.Position else nil

    for v6, v7 in t3 do
        if v6.Parent == v7.anchor and v7.anchor.Parent ~= nil then
            if v7.model:IsDescendantOf(game) then
                if Position ~= nil then
                    chase(v7, Position, p7)
                else
                    v7.anchor.CFrame = v7.model:GetPivot()
                end
            end
        else
            dropFollower(v6, v7.id)
        end
    end
end

function t2.MakeAnchor(p8, p9) -- line: 115
    -- upvalues: t1 (copy)
    local Part = Instance.new("Part")

    for v8, v9 in t1 do
        Part[v8] = v9
    end

    Part.Name = p8 or "SmartPromptPart"
    Part.CFrame = p9
    Part.Parent = workspace

    return Part
end

function t2.Add(p10, p11, p12, p13, p14) -- line: 127
    -- upvalues: RunService (copy), t2 (copy), t3 (copy), connection (ref), n1 (ref), dropFollower (copy), advance (copy)
    t2.Drop(p10)
    n1 += 1

    local v10 = n1
    local t4 = {
        id = v10,
        model = p11,
        anchor = p12,
        tracker = p13,
        connections = {},
        standoff = p14.SurfaceOffset or 0.75,
        rate = p14.FollowSpeed or 18,
        range = math.max(p14.TrackDistance or 7, p10.MaxActivationDistance)
    }

    t3[p10] = t4

    local function dropCurrent() -- line: 150
        -- upvalues: p10 (copy), v10 (copy), dropFollower (copy)
        dropFollower(p10, v10)
    end

    t4.connections = {
        p10.Destroying:Connect(dropCurrent),
        p11.Destroying:Connect(dropCurrent),
        p10.AncestryChanged:Connect(function() -- line: 157
            -- upvalues: p10 (copy), p12 (copy), v10 (copy), dropFollower (copy)
            if p10.Parent ~= p12 then
                dropFollower(p10, v10)
            end
        end)
    }

    if p12.Parent ~= nil then
        p10.Parent = p12
    else
        dropFollower(p10, v10)
    end

    if t3[p10] == t4 and connection == nil then
        connection = RunService.Heartbeat:Connect(advance)
    end

    local v12 = true

    return function() -- line: 175
        -- upvalues: p10 (copy), v10 (copy), v12 (ref), dropFollower (copy)
        if v12 then
            v12 = false
            dropFollower(p10, v10)
        end
    end
end

return t2
