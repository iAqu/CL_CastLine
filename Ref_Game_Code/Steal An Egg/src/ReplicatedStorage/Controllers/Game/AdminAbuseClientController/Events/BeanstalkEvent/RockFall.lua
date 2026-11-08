-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)

require(ReplicatedStorage.Packages.Trove)

local Stage3 = ReplicatedStorage.Assets.BeanstalkEventAssets.Stage3
local Children = Stage3.FallingIslands:GetChildren()
local RockBurst = Stage3.RockBurst
local v1 = Color3.fromRGB(255, 45, 70)

local function partsOf(p1) -- line: 87
    local t1 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t1, descendant)
        end
    end

    return t1
end

local function setFade(p2, p3) -- line: 97
    for _, v2 in p2.Parts do
        v2.LocalTransparencyModifier = p3
    end
end

local function place(p4, p5, p6) -- line: 103
    local v3 = p4.Path(p5.Distance)
    local v5 = math.sin((p6 - p5.BornAt) * 0.7 * 2 * 3.141592653589793 + p5.Seed) * 3

    p5.Position = v3.Position + v3.RightVector * (p5.Lateral + v5) + Vector3.new(0, 1, 0) * p5.Height
    p5.Model:PivotTo(CFrame.new(p5.Position) * p5.Turn)
end

local function chunksFrom(p7, p8) -- line: 113
    -- upvalues: Debris (copy)
    local v6

    for _, v7 in p8.Parts do
        if v6 == nil or v7.Size.Magnitude > v6.Size.Magnitude then
            v6 = v7
        end
    end

    if v6 ~= nil then
        for _ = 1, 8 do
            local clone = v6:Clone()

            for _, child in clone:GetChildren() do
                child:Destroy()
            end

            clone.Size = v6.Size * 0.16 * p7.Rng:NextNumber(0.6, 1.4)
            clone.Anchored = false
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
            clone.Massless = true
            clone.LocalTransparencyModifier = 0

            local v8 = p7.Rng:NextUnitVector()

            clone.CFrame = CFrame.new(p8.Position + v8 * p8.Radius * 0.5) * CFrame.Angles(p7.Rng:NextNumber(0, 6.28), p7.Rng:NextNumber(0, 6.28), 0)
            clone.Parent = p7.Folder
            clone.AssemblyLinearVelocity = v8 * 70 * p7.Rng:NextNumber(0.6, 1.3)
            clone.AssemblyAngularVelocity = p7.Rng:NextUnitVector() * p7.Rng:NextNumber(4, 12)
            Debris:AddItem(clone, 1.4)
        end
    end
end

local function remove(p9, p10) -- line: 145
    local v9 = table.remove(p9.Rocks, p10)

    if v9 then
        v9.Model:Destroy()
    end
end

local t2 = {}

function t2.new(p11, p12, p13, p14) -- line: 156
    -- upvalues: t2 (copy)
    local t3 = {
        Chain = 0,
        Open = 0,
        Trove = p11,
        Folder = p12,
        Path = p13,
        Width = p14,
        Rocks = {},
        Rng = Random.new()
    }

    p11:Add(function() -- line: 172
        -- upvalues: t3 (copy), t2 (copy)
        t2.Clear(t3)
    end)

    return t3
end

function t2.Spawn(p15, p16, p17, p18, p19, p20) -- line: 178
    -- upvalues: Children (copy), partsOf (copy), place (copy)
    local clone = Children[p15.Rng:NextInteger(1, #Children)]:Clone()
    local Highlight = clone:FindFirstChildOfClass("Highlight")

    if Highlight then
        Highlight.Enabled = false
    end

    local _, BoundingBox = clone:GetBoundingBox()
    local v10 = math.min(BoundingBox.X, BoundingBox.Z) * 0.5 * 0.58
    local v11 = partsOf(clone)
    local t4 = {}

    for _, v12 in v11 do
        t4[v12] = v12.Color
    end

    local t5 = {
        Tinted = false,
        Position = Vector3.new(0, 0, 0),
        Closest = 1e999,
        Hit = false,
        Passed = false,
        Model = clone,
        Warning = Highlight,
        Parts = v11,
        Colors = t4,
        Ratio = p20,
        Distance = p16,
        Lateral = p17,
        Height = p19,
        FallSpeed = p18,
        Radius = v10,
        Axis = (Vector3.new(0, 1, 0) + p15.Rng:NextUnitVector() * 0.3).Unit,
        Spin = p15.Rng:NextNumber(0.4363323129985824, 1.2217304763960306) * (p15.Rng:NextNumber() < 0.5 and -1 or 1),
        Turn = CFrame.Angles(0, p15.Rng:NextNumber(0, 6.283185307179586), p15.Rng:NextNumber(-0.4, 0.4)),
        Seed = p15.Rng:NextNumber(0, 6.283185307179586),
        BornAt = os.clock()
    }

    for _, v13 in t5.Parts do
        v13.LocalTransparencyModifier = 1
    end

    place(p15, t5, t5.BornAt)
    clone.Parent = p15.Folder
    table.insert(p15.Rocks, t5)
end

function t2.Wave(p21, p22, p23, p24, p25, p26, p27) -- line: 232
    -- upvalues: t2 (copy)
    local v14 = p21.Chain <= 0

    if v14 then
        p21.Chain = p21.Rng:NextInteger(3, 4) + math.floor(p23 * 2)
    end

    local v17 = -p21.Open

    if v17 == 0 then
        v17 = if p21.Rng:NextNumber() < 0.5 then -1 else 1
    elseif v14 and p21.Rng:NextNumber() < 0.25 then
        v17 = 0
    end

    p21.Open = v17

    local v18 = p21.Width * 0.66

    for i = -1, 1 do
        if i ~= v17 then
            t2.Spawn(p21, p22, i * v18, p24, p25, p26)
        end
    end

    p21.Chain -= 1

    if p21.Chain <= 0 then
        return p27 * 1.3
    end

    return p27 * (p23 * -0.16999999999999993 + 0.82)
end

function t2.Step(p28, p29, p30, p31, p32) -- line: 267
    -- upvalues: v1 (copy), place (copy)
    local elapsed = os.clock()
    local v19 = #p28.Rocks
    local v20, v21

    for i = v19, 1, -1 do
        local v22 = p28.Rocks[i]
        local v23 = v22.Distance - p30

        if v23 > 0 then
            v22.Height = math.min(v22.Height - v22.FallSpeed * p29 * 0.25, v23 * v22.Ratio)
        else
            v22.Height -= v22.FallSpeed * p29
        end

        v22.Turn = CFrame.fromAxisAngle(v22.Axis, v22.Spin * p29) * v22.Turn

        local v26 = elapsed - v22.BornAt

        if v26 < 0.8 then
            local v27 = 1 - v26 / 0.8

            for _, v28 in v22.Parts do
                v28.LocalTransparencyModifier = v27
            end
        elseif v26 - p29 < 0.8 then
            for _, v29 in v22.Parts do
                v29.LocalTransparencyModifier = 0
            end
        end

        place(p28, v22, elapsed)

        local v31 = math.abs(v22.Lateral - p31) - 9
        local v32 = v22.Distance - p30
        local v33 = math.abs(v22.Height)

        if math.abs(v32) < v22.Radius * 1.5 and v33 < v22.Radius * 1.5 then
            v22.Closest = math.min(v22.Closest, v31)
        end

        if not v22.Hit and math.abs(v32) < v22.Radius and v31 < v22.Radius and v33 < v22.Radius * 1.2 then
            v22.Hit = true

            if p32 and v20 == nil then
                v20 = v22
            end
        end

        local v34 = not v22.Hit and not v22.Passed and -v22.Radius < v32 and v22.Height > -v22.Radius and v31 < v22.Radius + 1.5
        local v36 = math.sin(elapsed * 5 * 2 * 3.141592653589793) * 0.5 + 0.5
        local Warning = v22.Warning

        if Warning then
            Warning.Enabled = v34

            if v34 then
                Warning.OutlineTransparency = v36 * 0.35 + 0.15
            end
        end

        if v34 then
            v22.Tinted = true

            local v37 = v36 * 0.35000000000000003 + 0.45

            for v38, v39 in v22.Colors do
                v38.Color = v39:Lerp(v1, v37)
            end
        elseif v22.Tinted then
            v22.Tinted = false

            for v40, v41 in v22.Colors do
                v40.Color = v41
            end
        end

        local v42 = v21

        if v22.Passed then
        elseif v32 < -v22.Radius or v22.Height < -v22.Radius * 2 then
            v22.Passed = true

            if v22.Hit then
            elseif v22.Closest < v22.Radius * 2.1 then
                v42 = v22
            end
        end

        v21 = v42

        if v20 ~= v22 and (v32 < -170 or v22.Height < -300) then
            local v43 = table.remove(p28.Rocks, i)

            if v43 then
                v43.Model:Destroy()
            end
        end
    end

    return v20, v21
end

function t2.Shatter(p33, p34) -- line: 355
    -- upvalues: Debris (copy), EmitOnce (copy), RockBurst (copy), chunksFrom (copy)
    local clone = RockBurst:Clone()

    clone.CFrame = CFrame.new(p34.Position)
    clone.Parent = p33.Folder

    local n1 = 0

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            n1 = math.max(n1, EmitOnce(descendant))
        end
    end

    Debris:AddItem(clone, math.max(n1, 0.5) + 0.2)
    chunksFrom(p33, p34)

    local v44 = table.find(p33.Rocks, p34)
    local v45

    if v44 then
        v45 = table.remove(p33.Rocks, v44)
    else
        p34.Model:Destroy()
    end

    if (not v44 or v45) and v44 then
        v45.Model:Destroy()
    end
end

function t2.Clear(p35) -- line: 375
    for i = #p35.Rocks, 1, -1 do
        local v46 = table.remove(p35.Rocks, i)

        if v46 then
            v46.Model:Destroy()
        end
    end
end

return t2
