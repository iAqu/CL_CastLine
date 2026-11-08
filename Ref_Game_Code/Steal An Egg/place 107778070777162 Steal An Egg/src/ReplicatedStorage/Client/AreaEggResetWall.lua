-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {
    Seconds = 1,
    Style = Enum.EasingStyle.Elastic,
    Direction = Enum.EasingDirection.Out
}
local t2 = {
    Seconds = 0.35,
    Style = Enum.EasingStyle.Quad,
    Direction = Enum.EasingDirection.Out
}
local t3 = {
    CollapseSeconds = t2.Seconds,
    Changed = Signal.new()
}

local function demandFolder(p1, p2) -- line: 39
    local v1 = p1[p2]

    assert(v1:IsA("Folder"), (("%* under %* is not a Folder"):format(p2, p1.Name)))

    return v1
end

local function demandPart(p3, p4) -- line: 45
    local v3 = p3[p4]

    assert(v3:IsA("BasePart"), (("%* under %* is not a BasePart"):format(p4, p3.Name)))

    return v3
end

local World = Workspace.World

assert(World:IsA("Folder"), (("World under %* is not a Folder"):format(Workspace.Name)))

local Areas = World.Areas

assert(Areas:IsA("Folder"), (("Areas under %* is not a Folder"):format(World.Name)))

local WallStartVisual = Areas.WallStartVisual

assert(WallStartVisual:IsA("BasePart"), (("WallStartVisual under %* is not a BasePart"):format(Areas.Name)))

local WallStartCollision = Areas.WallStartCollision

assert(WallStartCollision:IsA("BasePart"), (("WallStartCollision under %* is not a BasePart"):format(Areas.Name)))

local LocalPlayer = Players.LocalPlayer
local v9 = WallStartVisual.Size * Vector3.new(1, 0, 1)
local Y = WallStartVisual.Size.Y
local v10 = WallStartVisual.CFrame * CFrame.new(Vector3.new(0, 1, 0) * (Y * -0.5))
local connection = nil
local connection2 = nil
local v11 = false

WallStartVisual.CanCollide = false

local function applyHeight(p5) -- line: 67
    -- upvalues: WallStartVisual (copy), v9 (copy), Y (copy), v10 (copy)
    local v12 = math.clamp(p5, 0, Y)

    WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v12
    WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v12 * 0.5))
end

local function barrierPieces() -- line: 73
    -- upvalues: WallStartCollision (copy)
    local t4 = {
        WallStartCollision
    }

    for _, descendant in WallStartCollision:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t4, descendant)
        end
    end

    return t4
end

local function setBarrierSolid(p6) -- line: 83
    -- upvalues: barrierPieces (copy)
    for _, v13 in barrierPieces() do
        v13.CanCollide = p6
    end
end

local function partOverlapsPiece(p7, p8) -- line: 91
    local v14 = p7.Size * 0.5
    local v15 = p8.Size * 0.5 + Vector3.new(0.5, 0.5, 0.5)
    local v16 = p8.CFrame:ToObjectSpace(p7.CFrame)
    local v17 = Vector3.new(1, 1, 1) * 1e999
    local v18 = -v17

    for _, v19 in {
            -v14.X,
            v14.X
        } do
        local v20 = v17
        local v21 = v18

        for _, v22 in {
                -v14.Y,
                v14.Y
            } do
            for _, v25 in {
                    -v14.Z,
                    v14.Z
                } do
                local v26 = v16 * Vector3.new(v19, v22, v25)

                v20 = v20:Min(v26)
                v21 = v21:Max(v26)
            end

            v18 = v21
            v17 = v20
        end
    end

    if v18.X >= -v15.X and v17.X <= v15.X and v18.Y >= -v15.Y and v17.Y <= v15.Y and v18.Z >= -v15.Z then
        return v17.Z <= v15.Z
    end

    return false
end

local function characterInsideBarrier() -- line: 115
    -- upvalues: LocalPlayer (copy), barrierPieces (copy), partOverlapsPiece (copy)
    local v27 = LocalPlayer and LocalPlayer.Character

    if v27 ~= nil then
        local v28 = barrierPieces()

        for _, descendant in v27:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant.CanCollide or descendant.Name == "HumanoidRootPart") then
                for _, v29 in v28 do
                    if partOverlapsPiece(descendant, v29) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function solidifyWhenClear() -- line: 145
    -- upvalues: RunService (copy), connection2 (ref), barrierPieces (copy), characterInsideBarrier (copy)
    local connection = connection2

    connection2 = nil

    if connection then
        connection:Disconnect()
    end

    if characterInsideBarrier() then
        for _, v30 in barrierPieces() do
            v30.CanCollide = false
        end

        local connection

        connection = RunService.Heartbeat:Connect(function() -- line: 153
            -- upvalues: connection (ref), connection2 (ref), barrierPieces (copy), characterInsideBarrier (copy)
            if characterInsideBarrier() then
                return
            end

            connection:Disconnect()

            if connection2 == connection then
                connection2 = nil

                for _, v31 in barrierPieces() do
                    v31.CanCollide = true
                end
            end
        end)
        connection2 = connection
    else
        for _, v32 in barrierPieces() do
            v32.CanCollide = true
        end
    end
end

local function publishSealed(p9) -- line: 166
    -- upvalues: t3 (copy), v11 (ref)
    if v11 == p9 then
        return
    end

    v11 = p9

    local Changed = t3.Changed

    Changed:Fire(v11)
end

local function runSweep(p10, p11, p12) -- line: 184
    -- upvalues: RunService (copy), TweenService (copy), WallStartVisual (copy), v9 (copy), Y (copy), v10 (copy), connection (ref)
    local connection2 = connection

    connection = nil

    if connection2 then
        connection2:Disconnect()
    end

    local v34 = math.clamp(p11, 0, Y)

    WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v34
    WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v34 * 0.5))

    local v35 = p12 - p11
    local t5 = {}

    t5[1] = 0

    local connection3

    connection3 = RunService.PreRender:Connect(function(p13) -- line: 191
        -- upvalues: p10 (copy), p11 (copy), v35 (copy), t5 (copy), connection3 (ref), TweenService (copy), WallStartVisual (copy), v9 (copy), Y (copy), v10 (copy)
        t5[1] = math.min(t5[1] + p13, p10.Seconds)

        local v38 = math.clamp(p11 + v35 * TweenService:GetValue(t5[1] / p10.Seconds, p10.Style, p10.Direction), 0, Y)

        WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v38
        WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v38 * 0.5))

        if t5[1] >= p10.Seconds then
            connection3:Disconnect()
        end
    end)
    connection = connection3
    task.delay(p10.Seconds * 3, function() -- line: 202
        -- upvalues: connection3 (ref), connection (ref)
        if connection == connection3 then
            connection3:Disconnect()
        end
    end)

    while connection3.Connected do
        task.wait()
    end

    if connection ~= connection3 then
        return false
    end

    connection = nil

    local v39 = math.clamp(p12, 0, Y)

    WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v39
    WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v39 * 0.5))

    return true
end

function t3.ArmReveal() -- line: 219
    -- upvalues: t3 (copy), WallStartVisual (copy), v9 (copy), Y (copy), v10 (copy), connection (ref), v11 (ref), solidifyWhenClear (copy)
    local connection2 = connection

    connection = nil

    if connection2 then
        connection2:Disconnect()
    end

    local v40 = math.clamp(0, 0, Y)

    WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v40
    WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v40 * 0.5))
    solidifyWhenClear()

    if v11 == true then
        return
    end

    v11 = true
    t3.Changed:Fire(v11)
end

function t3.RaiseWall() -- line: 226
    -- upvalues: t1 (copy), Y (copy), runSweep (copy)
    runSweep(t1, 0, Y)
end

function t3.DropWall() -- line: 228
    -- upvalues: t2 (copy), t3 (copy), WallStartVisual (copy), connection2 (ref), v11 (ref), barrierPieces (copy), runSweep (copy)
    local connection = connection2

    connection2 = nil

    if connection then
        connection:Disconnect()
    end

    for _, v42 in barrierPieces() do
        v42.CanCollide = false
    end

    if v11 ~= false then
        v11 = false
        t3.Changed:Fire(v11)
    end

    runSweep(t2, WallStartVisual.Size.Y, 0)
end

function t3.ClearWall() -- line: 236
    -- upvalues: t3 (copy), WallStartVisual (copy), v9 (copy), Y (copy), v10 (copy), connection (ref), connection2 (ref), v11 (ref), barrierPieces (copy)
    local connection3 = connection

    connection = nil

    if connection3 then
        connection3:Disconnect()
    end

    local connection4 = connection2

    connection2 = nil

    if connection4 then
        connection4:Disconnect()
    end

    local v44 = math.clamp(0, 0, Y)

    WallStartVisual.Size = v9 + Vector3.new(0, 1, 0) * v44
    WallStartVisual.CFrame = v10 * CFrame.new(Vector3.new(0, 1, 0) * (v44 * 0.5))

    for _, v45 in barrierPieces() do
        v45.CanCollide = false
    end

    if v11 == false then
        return
    end

    v11 = false
    t3.Changed:Fire(v11)
end

function t3.ResolveWallPart() -- line: 244
    -- upvalues: WallStartVisual (copy)
    return WallStartVisual
end

function t3.ResolveFullHeight() -- line: 246
    -- upvalues: Y (copy)
    return Y
end

function t3.IsSealed() -- line: 248
    -- upvalues: v11 (ref)
    return v11
end

return t3
