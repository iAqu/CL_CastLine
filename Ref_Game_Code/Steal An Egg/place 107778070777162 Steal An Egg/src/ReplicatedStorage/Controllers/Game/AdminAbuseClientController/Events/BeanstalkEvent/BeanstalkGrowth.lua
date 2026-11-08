-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)

require(ReplicatedStorage.Packages.Trove)

local Stage = BeanstalkEvent.Stage
local BeanstalkTileableSegment = ReplicatedStorage.Assets.BeanstalkEventAssets.BeanstalkTileableSegment
local PrimaryPart = BeanstalkTileableSegment.PrimaryPart
local TileHeight = BeanstalkTileableSegment:GetAttribute("TileHeight")

assert(typeof(TileHeight) == "number", "BeanstalkTileableSegment needs a numeric TileHeight attribute")

local v2 = Color3.fromRGB(150, 115, 60)
local v3, Folder
local t1 = {}
local t2 = {}
local n1 = 0
local v4 = CFrame.identity
local n2 = 0
local v5 = Vector3.new(0, 0, 0)
local identity = CFrame.identity
local t3 = {}

t3[1] = identity

local t4 = {}

t4[1] = 1

local n3 = 1
local n4 = 0

local function map() -- line: 54
    -- upvalues: v3 (ref)
    local v6 = v3

    assert(v6 ~= nil, "BeanstalkGrowth.Start has not run")

    return v6
end

local function floorTop(p1) -- line: 60
    return p1.Position.Y + p1.Size.Y * 0.5
end

local function tileBottom(p2) -- line: 64
    -- upvalues: TileHeight (copy), n1 (ref)
    return n1 - 10 + (p2 - 1) * TileHeight
end

local function topY() -- line: 68
    -- upvalues: PrimaryPart (copy), TileHeight (copy), t1 (copy), n1 (ref)
    if #t1 == 0 then
        return n1
    end

    local v8 = #t1

    return n1 - 10 + (v8 - 1) * TileHeight + PrimaryPart.Size.Y
end

local function restingPivot(p3) -- line: 75
    -- upvalues: TileHeight (copy), n1 (ref), v4 (ref), n2 (ref)
    local v9 = v4

    return v9 + Vector3.new(0, n1 - 10 + (p3 - 1) * TileHeight - n2, 0)
end

local function addTile() -- line: 79
    -- upvalues: BeanstalkTileableSegment (copy), TileHeight (copy), Folder (ref), t1 (copy), t2 (copy), n1 (ref), v4 (ref), n2 (ref)
    local Folder2 = Folder

    assert(Folder2 ~= nil, "BeanstalkGrowth.Start has not run")

    local clone = BeanstalkTileableSegment:Clone()
    local v12 = #t1 + 1
    local v13 = v4

    clone:PivotTo(v13 + Vector3.new(0, n1 - 10 + (v12 - 1) * TileHeight - n2, 0))

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            t2[descendant] = descendant.Color
        end
    end

    clone.Parent = Folder2
    table.insert(t1, clone)

    return clone
end

local t5 = {}

function t5.Start(p4, p5) -- line: 105
    -- upvalues: Workspace (copy), BeanstalkEvent (copy), BeanstalkTileableSegment (copy), PrimaryPart (copy), v3 (ref), Folder (ref), t1 (copy), t2 (copy), n1 (ref), v4 (ref), n2 (ref), v5 (ref), t3 (copy), t4 (copy), n3 (ref), n4 (ref)
    v3 = p5

    local BoundingBox, BoundingBox2 = p5:WaitForChild("Beanstalk"):GetBoundingBox()

    n1 = BoundingBox.Position.Y + BoundingBox2.Y * 0.5
    t3[1] = p5.Beanstalk:GetPivot()
    t4[1] = p5.Beanstalk:GetScale()
    n3 = 1

    local v15 = BeanstalkEvent.MapShift(p5.Beanstalk)
    local v16 = v15 * PrimaryPart.CFrame

    v4 = v15 * BeanstalkTileableSegment:GetPivot()
    n2 = v16.Position.Y - PrimaryPart.Size.Y * 0.5
    v5 = v16.Position

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "BeanstalkGrowth"
    Folder2.Parent = Workspace
    Folder = Folder2
    p4:Add(function() -- line: 123
        -- upvalues: p5 (copy), Folder2 (copy), v3 (ref), Folder (ref), t1 (copy), t2 (copy), t3 (copy), t4 (copy), n3 (ref), n4 (ref)
        n4 += 1

        if p5.Beanstalk.Parent ~= nil then
            local v17 = v3

            assert(v17 ~= nil, "BeanstalkGrowth.Start has not run")

            local Beanstalk = v17.Beanstalk

            Beanstalk:ScaleTo(t4[1] * 1)
            Beanstalk:PivotTo(t3[1] * CFrame.Angles(0, 0, 0))
            n3 = 1
        end

        Folder2:Destroy()
        Folder = nil
        v3 = nil
        table.clear(t1)
        table.clear(t2)
    end)
end

function t5.Axis(p6) -- line: 137
    -- upvalues: v5 (ref)
    return (Vector3.new(v5.X, p6, v5.Z))
end

function t5.HeightFor(p7) -- line: 142
    -- upvalues: Stage (copy), v3 (ref), n1 (ref)
    local v19 = v3

    assert(v19 ~= nil, "BeanstalkGrowth.Start has not run")

    local Sections = v19.Sections

    if p7 <= Stage.Fireflies then
        return n1
    end

    if p7 == Stage.Watering then
        local Floor = Sections.Stage2.Floor

        return Floor.Position.Y + Floor.Size.Y * 0.5 + 60
    end

    local Floor = Sections.Stage4.Floor

    return Floor.Position.Y + Floor.Size.Y * 0.5
end

local function riseInto(p8, p9, p10) -- line: 153
    -- upvalues: TweenService (copy), TileHeight (copy)
    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = p9 - Vector3.new(0, TileHeight, 0)
    p8:PivotTo(CFrameValue.Value)

    local connection = CFrameValue.Changed:Connect(function(p11) -- line: 157
        -- upvalues: p8 (copy)
        p8:PivotTo(p11)
    end)
    local tween = TweenService:Create(CFrameValue, TweenInfo.new(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = p9
    })

    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()
    CFrameValue:Destroy()
    p8:PivotTo(p9)
end

function t5.GrowTo(p12, p13) -- line: 171
    -- upvalues: PrimaryPart (copy), TileHeight (copy), t1 (copy), n1 (ref), v4 (ref), n2 (ref), addTile (copy), riseInto (copy)
    local t6 = {}

    while true do
        local v21

        if #t1 == 0 then
            v21 = n1
        else
            local v22 = #t1

            v21 = n1 - 10 + (v22 - 1) * TileHeight + PrimaryPart.Size.Y
        end

        if v21 < p12 then
            table.insert(t6, (addTile()))
            continue
        end

        break
    end

    if p13 == nil or #t6 == 0 then
        return
    end

    local v24 = p13 / #t6

    for _, v25 in t6 do
        v25:PivotTo(v25:GetPivot() - Vector3.new(0, TileHeight, 0))
    end

    task.spawn(function() -- line: 183
        -- upvalues: t6 (copy), v24 (copy), TileHeight (copy), t1 (copy), n1 (ref), v4 (ref), n2 (ref), riseInto (copy)
        for v26, v27 in t6 do
            local v28 = table.find(t1, v27) or v26

            riseInto(v27, v4 + Vector3.new(0, n1 - 10 + (v28 - 1) * TileHeight - n2, 0), v24)
        end
    end)
end

function t5.SetBaseGrowth(p14, p15) -- line: 193
    -- upvalues: RunService (copy), v3 (ref), t3 (copy), t4 (copy), n3 (ref), n4 (ref)
    n4 += 1

    local v31 = n4
    local v32 = math.clamp(p14, 0, 1)

    if p15 ~= nil then
        local v35 = n3

        task.spawn(function() -- line: 202
            -- upvalues: p15 (copy), v31 (copy), v32 (copy), v35 (copy), RunService (copy), v3 (ref), t3 (copy), t4 (copy), n3 (ref), n4 (ref)
            local elapsed = os.clock()

            while true do
                if v31 == n4 then
                    if v3 == nil then
                        return
                    end

                    local v37 = math.min((os.clock() - elapsed) / p15, 1)
                    local v38 = v35 + (v32 - v35) * (1 - (1 - v37) ^ 3)
                    local v39 = v3

                    assert(v39 ~= nil, "BeanstalkGrowth.Start has not run")

                    local Beanstalk = v39.Beanstalk

                    Beanstalk:ScaleTo(t4[1] * (v38 * 0.5 + 0.5))
                    Beanstalk:PivotTo(t3[1] * CFrame.Angles(0, (1 - v38) * 6.283185307179586, 0))
                    n3 = v38

                    if v37 >= 1 then
                        break
                    end

                    RunService.Heartbeat:Wait()
                    continue
                end

                return
            end
        end)
    else
        local v33 = v3

        assert(v33 ~= nil, "BeanstalkGrowth.Start has not run")

        local Beanstalk = v33.Beanstalk

        Beanstalk:ScaleTo(t4[1] * (v32 * 0.5 + 0.5))
        Beanstalk:PivotTo(t3[1] * CFrame.Angles(0, (1 - v32) * 6.283185307179586, 0))
        n3 = v32
    end
end

function t5.SetWilted(p16) -- line: 216
    -- upvalues: TweenService (copy), v2 (copy), t2 (copy)
    for v41, v42 in t2 do
        TweenService:Create(v41, TweenInfo.new(0.25), {
            Color = v42:Lerp(v2, (math.clamp(p16, 0, 1)))
        }):Play()
    end
end

return t5
