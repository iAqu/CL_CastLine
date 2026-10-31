-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local t1 = {}
local v1

local function floorCount(p1) -- line: 25
    local FloorSegments = p1 and p1:FindFirstChild("FloorSegments")
    local v2

    if not FloorSegments then
        v2 = 0

        return v2
    end

    v2 = 0

    for _, child in ipairs(FloorSegments:GetChildren()) do
        if child:IsA("BasePart") and tonumber(child.Name) then
            v2 += 1
        end
    end

    return v2
end

ReleaseConfig.OnChanged(function() -- line: 38
    -- upvalues: AreasConfig (copy), v1 (ref), floorCount (copy)
    task.spawn(function() -- line: 39
        -- upvalues: AreasConfig (copy), v1 (ref), floorCount (copy)
        local Biomes = workspace:WaitForChild("Biomes")
        local elapsed = os.clock()

        for _, v3 in ipairs(AreasConfig.List) do
            local v4 = Biomes:FindFirstChild(v3.Key)

            while (not v4 or floorCount(v4) < AreasConfig.SubAreas) and os.clock() - elapsed < 30 do
                task.wait(0.1)
                v4 = Biomes:FindFirstChild(v3.Key)
            end
        end

        v1 = nil
    end)
end)

local function buildGeometry() -- line: 53
    -- upvalues: AreasConfig (copy), GameConfig (copy)
    local Biomes = workspace:WaitForChild("Biomes")
    local t2 = {}

    for v5, v6 in ipairs(AreasConfig.List) do
        local v7 = Biomes:FindFirstChild(v6.Key) or Biomes:WaitForChild(v6.Key, 15)
        local t3 = {}

        if v7 then
            local v8 = v7:FindFirstChild("FloorSegments") or v7:WaitForChild("FloorSegments", 15)

            if v8 then
                for _, child in ipairs(v8:GetChildren()) do
                    if child:IsA("BasePart") and tonumber(child.Name) then
                        table.insert(t3, child)
                    end
                end
            elseif v7:FindFirstChild("Grass") then
                t3 = { v7.Grass }
            end
        end

        local t4

        if #t3 > 0 then
            local n2 = (-1e999)
            local n3 = 1e999
            local n4 = 1e999
            local n5 = (-1e999)
            local v9

            for _, v10 in ipairs(t3) do
                local Position, Size = v10.Position, v10.Size

                n2 = math.max(n2, Position.Z + Size.Z / 2)
                n3 = math.min(n3, Position.Z - Size.Z / 2)
                n4 = math.min(n4, Position.X - Size.X / 2)
                n5 = math.max(n5, Position.X + Size.X / 2)
                v9 = math.max(v9 or (-1e999), Position.Y + Size.Y / 2)
            end

            t4 = {
                Index = v5,
                Key = v6.Key,
                Name = v6.Name,
                FloorY = v9,
                ZStart = n2,
                ZEnd = n3,
                XMin = n4,
                XMax = n5
            }
            t4.Center = Vector3.new((n4 + n5) / 2, v9, (n2 + n3) / 2)
            t4.Floors = t3
            t4.Floor = t3[1]
        else
            warn("[AreaUtil] Biome folder or floor parts missing for " .. v6.Key .. " - using the configured layout")

            local v19 = GameConfig.Throw.LaunchPosition.Z - v6.StartDistance
            local v20 = -14.5 - 3 * (v5 - 1)

            t4 = {
                XMin = -40,
                XMax = 40,
                Index = v5,
                Key = v6.Key,
                Name = v6.Name,
                FloorY = v20,
                ZStart = v19,
                ZEnd = v19 - v6.Length
            }
            t4.Center = Vector3.new(0, v20, v19 - v6.Length / 2)
        end

        t2[v5] = t4
    end

    return t2
end

function t1.GetAll() -- line: 108
    -- upvalues: v1 (ref), buildGeometry (copy)
    v1 = v1 or buildGeometry()

    return v1
end

function t1.Get(p2) -- line: 113
    -- upvalues: t1 (copy)
    return t1.GetAll()[p2]
end

function t1.Count() -- line: 117
    -- upvalues: t1 (copy)
    return #t1.GetAll()
end

function t1.GetLaunchPosition() -- line: 122
    -- upvalues: GameConfig (copy)
    local StarterArea = workspace:FindFirstChild("StarterArea")

    if StarterArea then
        return (Vector3.new(StarterArea.Position.X, StarterArea.Position.Y + StarterArea.Size.Y / 2, StarterArea.Position.Z))
    end

    local LaunchPosition = GameConfig.Throw.LaunchPosition

    return (Vector3.new(LaunchPosition.X, 2.5, LaunchPosition.Z))
end

function t1.GetAreaIndexForZ(p3) -- line: 132
    -- upvalues: t1 (copy)
    local v23 = t1.GetAll()

    for v24, v25 in ipairs(v23) do
        if p3 <= v25.ZStart and v25.ZEnd < p3 then
            return v24
        end
    end

    if v23[1].ZStart < p3 then
        return 1
    end

    return #v23
end

function t1.DepthInArea(p4, p5) -- line: 145
    -- upvalues: t1 (copy)
    local v26 = t1.Get(p4)
    local v28 = math.max(v26.ZStart - v26.ZEnd, 1)

    return (math.clamp((v26.ZStart - p5) / v28, 0, 1))
end

function t1.SubAreaLines(p6) -- line: 152
    -- upvalues: AreasConfig (copy), t1 (copy)
    local v30 = t1.Get(p6)
    local v31 = v30.ZStart - v30.ZEnd
    local t5 = {}

    for i = 1, AreasConfig.SubAreas - 1 do
        table.insert(t5, v30.ZStart - v31 * i / AreasConfig.SubAreas)
    end

    return t5
end

function t1.KeepOffLines(p7, p8, p9) -- line: 165
    -- upvalues: t1 (copy)
    for _, v33 in ipairs(t1.SubAreaLines(p7)) do
        if math.abs(p8 - v33) < p9 then
            return v33 - p9
        end
    end

    return p8
end

function t1.SubAreaForZ(p10, p11) -- line: 175
    -- upvalues: AreasConfig (copy), t1 (copy)
    return (math.clamp(math.floor(t1.DepthInArea(p10, p11) * AreasConfig.SubAreas) + 1, 1, AreasConfig.SubAreas))
end

function t1.ProgressForZ(p12) -- line: 183
    -- upvalues: t1 (copy)
    if t1.GetAll()[1].ZStart <= p12 then
        return 0
    end

    local v37 = t1.GetAreaIndexForZ(p12)

    return v37 - 1 + t1.DepthInArea(v37, p12)
end

function t1.LuckStepsForZ(p13) -- line: 198
    -- upvalues: AreasConfig (copy), t1 (copy)
    if t1.GetAll()[1].ZStart <= p13 then
        return 0
    end

    local v38 = t1.GetAreaIndexForZ(p13)
    local SubAreas = AreasConfig.SubAreas
    local v39 = (v38 - 1) * SubAreas + t1.DepthInArea(v38, p13) * SubAreas

    if v39 <= 0.5 then
        return 0
    end

    if v39 < 1 then
        return (v39 - 0.5) * 2
    end

    return v39
end

function t1.DistanceToAreaCenter(p14) -- line: 210
    -- upvalues: t1 (copy)
    local v40 = t1.Get(p14)

    return t1.GetLaunchPosition().Z - v40.Center.Z
end

function t1.DistanceToAreaStart(p15) -- line: 216
    -- upvalues: GameConfig (copy), t1 (copy)
    local v41 = t1.Get(p15)

    return t1.GetLaunchPosition().Z - v41.ZStart + GameConfig.Throw.LandingEdgeMargin
end

function t1.MaxReachableArea(p16) -- line: 222
    -- upvalues: t1 (copy)
    local n6 = 1

    for i = 1, t1.Count() do
        if t1.DistanceToAreaStart(i) <= p16 then
            n6 = i
        end
    end

    return n6
end

function t1.ComputeLanding(p17, p18) -- line: 234
    -- upvalues: GameConfig (copy), t1 (copy)
    local v43 = t1.GetLaunchPosition()
    local LandingEdgeMargin = GameConfig.Throw.LandingEdgeMargin
    local v44 = v43.Z - p17
    local v45 = t1.GetAll()
    local v49 = math.min(math.max(v44, v45[#v45].ZEnd + LandingEdgeMargin), v45[1].ZStart - LandingEdgeMargin)
    local v50 = t1.GetAreaIndexForZ(v49)
    local v51 = v45[v50]
    local v54 = math.clamp(v49, v51.ZEnd + LandingEdgeMargin, v51.ZStart - LandingEdgeMargin)

    return Vector3.new(math.clamp(p18 or 0, v51.XMin + LandingEdgeMargin, v51.XMax - LandingEdgeMargin), v51.FloorY, v54), v50
end

function t1.TargetDistanceForArea(p19) -- line: 250
    -- upvalues: t1 (copy)
    return t1.DistanceToAreaCenter(p19)
end

return t1
