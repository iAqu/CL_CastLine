-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local t1 = {
    Vector2.new(0, 0),
    Vector2.new(0, 3),
    Vector2.new(0, -3),
    Vector2.new(3, 0),
    Vector2.new(-3, 0),
    Vector2.new(0, 6),
    Vector2.new(0, -6),
    Vector2.new(3, 3),
    Vector2.new(3, -3)
}
local Part = Instance.new("Part")

Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
Part.Transparency = 1

local t2 = {
    ShowAt = 1792249200,
    TeamSize = 4,
    Broadcast = "YOU WANT TO ENTER MY DIMENSION? THEN PROVE YOU DESERVE TO SURVIVE.",
    IslandAnchor = CFrame.new(-9000, 1200, 11000),
    TeamIds = table.freeze({ "Red", "Blue" }),
    Teams = table.freeze({
        Red = table.freeze({
            Name = "RED",
            Color = Color3.fromRGB(255, 0, 0),
            FxColor = Color3.fromRGB(255, 70, 55)
        }),
        Blue = table.freeze({
            Name = "BLUE",
            Color = Color3.fromRGB(0, 85, 255),
            FxColor = Color3.fromRGB(0, 85, 255)
        })
    }),
    Tools = table.freeze({ "Bat", "PumpkinLauncher", "WallBuilder", "Landmine", "JumpPad" }),
    Pickups = table.freeze({ "Landmine", "JumpPad" }),
    ToolNames = table.freeze({
        Bat = "Bat",
        PumpkinLauncher = "Pumpkin Launcher",
        WallBuilder = "Wall Builder",
        Landmine = "Landmine",
        JumpPad = "Jump Pad"
    }),
    Timing = table.freeze({
        IntroTeleport = 30,
        Intro = 46
    }),
    Tuning = table.freeze({
        KillCredit = 10,
        VoidDepth = 40,
        Mine = table.freeze({
            Gap = 1.2,
            Side = 0.55,
            Step = 2,
            TriggerRadius = 5,
            Radius = 14,
            StructureRadius = 9
        }),
        Wall = table.freeze({
            MinRange = 6,
            Range = 18,
            Width = 5,
            Height = 3,
            RowDelay = 0.1
        }),
        Pad = table.freeze({
            Range = 14
        }),
        Crystal = table.freeze({
            Stages = table.freeze({ 0.75, 0.5, 0.25 })
        }),
        Barrier = table.freeze({
            Stages = table.freeze({ 0.75, 0.5, 0.25 })
        }),
        Brick = table.freeze({
            Size = 3
        })
    }),
    Rewards = table.freeze({
        Participation = nil,
        WinningTeam = nil,
        Placements = table.freeze({})
    }),
    BotNames = table.freeze({ "PumpkinPal", "GhostlyGus", "CandyCrusher", "SpookySam", "BatBuddy", "WitchyWin", "BonesMcGee" }),
    BotAvatars = table.freeze({ 156, 261, 1, 2, 3 }),
    Assets = ReplicatedStorage.Assets.CursedIslandWars
}

function t2.WallCells(p1, p2, p3, p4) -- line: 135
    -- upvalues: Workspace (copy), t2 (copy)
    local Size = t2.Tuning.Brick.Size
    local Wall = t2.Tuning.Wall
    local Pivot = p1:GetPivot()
    local v1 = Pivot:PointToObjectSpace(p3)
    local v6 = Vector3.new(math.round(v1.X / Size) * Size, 0, math.round(v1.Z / Size) * Size)
    local v7 = if p4 then Vector3.new(0, 0, 1) else Vector3.new(1, 0, 0)
    local v8 = RaycastParams.new()

    v8.FilterType = Enum.RaycastFilterType.Include
    v8.FilterDescendantsInstances = { p1 }
    v8.RespectCanCollide = true

    local v9 = OverlapParams.new()

    v9.FilterType = Enum.RaycastFilterType.Include
    v9.FilterDescendantsInstances = p2
    v9.RespectCanCollide = true

    local v10 = (Wall.Width - 1) / 2
    local t3 = {}

    for i = -v10, v10 do
        local v11 = Pivot:PointToWorldSpace(v6 + v7 * i * Size)
        local v13 = Workspace:Raycast(Vector3.new(v11.X, p3.Y + 6, v11.Z), Vector3.new(0, -18, 0), v8)

        if v13 ~= nil and not (v13.Normal.Y < 0.7) then
            for j = 0, Wall.Height - 1 do
                table.insert(t3, CFrame.new(v11.X, v13.Position.Y + Size * (j + 0.5), v11.Z) * Pivot.Rotation)
            end
        end
    end

    return t2.FreeCells(t3, v9)
end

function t2.FreeCells(p5, p6) -- line: 165
    -- upvalues: Workspace (copy), Part (copy), t2 (copy)
    Part.Size = Vector3.new(1, 1, 1) * (t2.Tuning.Brick.Size - 0.4)
    Part.Parent = Workspace

    local t4 = {}

    for _, v15 in p5 do
        Part.CFrame = v15

        if #Workspace:GetPartsInPart(Part, p6) == 0 then
            table.insert(t4, v15)
        end
    end

    Part.Parent = nil

    return t4
end

function t2.WallSearch(p7, p8, p9, p10) -- line: 179
    -- upvalues: t1 (copy), t2 (copy)
    local Wall = t2.Tuning.Wall
    local v18 = Vector3.new(p10.X - p9.X, 0, p10.Z - p9.Z)

    if v18.Magnitude < 0.1 then
        return nil, false, {}
    end

    local Unit = v18.Unit
    local v20 = Vector3.new(-Unit.Z, 0, Unit.X)
    local v21 = math.clamp(v18.Magnitude, Wall.MinRange, Wall.Range)
    local v22 = p7:GetPivot():VectorToObjectSpace(Unit)
    local v24 = math.abs(v22.X) > math.abs(v22.Z)
    local v25 = {}
    local v27 = v25
    local v28
    local v26

    for _, v29 in t1 do
        local v31 = p9 + Unit * math.clamp(v21 + v29.X, Wall.MinRange, Wall.Range) + v20 * v29.Y
        local v32 = t2.WallCells(p7, p8, v31, v24)

        if #v32 > #v27 then
            v27 = v32
            v26 = v31
        end

        if #v27 == Wall.Width * Wall.Height then
            v28 = v26
            v25 = v27
            break
        end

        v25 = v27
        v28 = v26
    end

    return v28, v24, v25
end

function t2.Steer(p11, p12, p13, p14) -- line: 207
    local v33 = p13 - p12
    local v34 = p11:Cross(v33)

    if v34.Magnitude < 1E-06 then
        return p11
    end

    local v37 = math.acos((math.clamp(p11.Unit:Dot(v33.Unit), -1, 1)))

    return CFrame.fromAxisAngle(v34.Unit, (math.min(v37, p14))):VectorToWorldSpace(p11)
end

return t2
