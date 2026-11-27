-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HullRig = require(script.Parent.HullRig)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = {
    Nessie_Head = {
        CFrame.new(0, 26, 34),
        (Vector3.new(14, 12, 12))
    },
    Nessie_Jaw = {
        CFrame.new(0, 19, 38),
        (Vector3.new(9, 4, 9))
    },
    Nessie_NeckTop = {
        CFrame.new(0, 34, 22),
        (Vector3.new(14, 10, 14))
    },
    Nessie_Neck = {
        CFrame.new(0, 26, 16),
        (Vector3.new(22, 16, 22))
    },
    Nessie_Body = {
        CFrame.new(0, 24, 0),
        (Vector3.new(26, 22, 40))
    },
    Nessie_Back = {
        CFrame.new(0, 40, -2),
        (Vector3.new(22, 8, 36))
    },
    Nessie_BodyRear = {
        CFrame.new(0, 22, -24),
        (Vector3.new(20, 18, 22))
    },
    Nessie_Tail = {
        CFrame.new(0, 18, -38),
        (Vector3.new(14, 14, 14))
    }
}
local v1, v2
local v3 = nil
local t3 = {}
local n1 = 0
local Position

function t1.active() -- line: 50
    return false
end

function t1.name() -- line: 54
    -- upvalues: t1 (copy)
    if t1.active() then
        return "HULLBREAKER"
    end

    return "LOCH NESS MONSTER"
end

function t1.template() -- line: 59
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local Bosses = ReplicatedStorage.Assets:FindFirstChild("Bosses")

    Bosses = Bosses and Bosses:FindFirstChild(if t1.active() then "Hullbreaker" else "LochNess")

    return if Bosses then Bosses:Clone() else nil
end

local function serverMonster() -- line: 65
    local BossArena = workspace:FindFirstChild("BossArena")

    return BossArena and BossArena:FindFirstChild("LochNessBoss")
end

local function hide(p1, p2) -- line: 70
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p2 and 1 or 0
        end
    end
end

local function build(p3) -- line: 90
    -- upvalues: HullRig (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), t3 (copy), n1 (ref), Position (ref)
    if v1 then
        v1:Destroy()
    end

    if v3 and v3.Parent then
        for _, descendant in v3:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 0
            end
        end
    end

    v1 = nil
    v2 = nil
    v3 = nil
    table.clear(t3)
    Position = nil

    local v4 = HullRig.clone(1.8)

    if not v4 then
        return
    end

    v4.Name = "BossSkin"
    v2 = HullRig.new(v4)

    for v5, v6 in t2 do
        local Part = Instance.new("Part")

        Part.Name = v5
        Part.Size = v6[2]
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Parent = v4
        t3[Part] = v6[1]
    end

    v4.Parent = p3.Parent
    v1 = v4
    v3 = p3
    n1 = os.clock()

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1
        end
    end

    p3.DescendantAdded:Connect(function(p4) -- line: 111
        -- upvalues: p3 (copy), v3 (ref)
        if p4:IsA("BasePart") and v3 == p3 then
            p4.LocalTransparencyModifier = 1
        end
    end)
end

function t1.monster() -- line: 119
    -- upvalues: t1 (copy), v1 (ref), v3 (ref), build (copy)
    local BossArena = workspace:FindFirstChild("BossArena")
    local LochNessBoss = BossArena and BossArena:FindFirstChild("LochNessBoss")
    local v7 = true

    if LochNessBoss and t1.active() then
        if v3 ~= LochNessBoss or not v1 or not v1.Parent then
            build(LochNessBoss)
        end

        v7 = false
    end

    return not v7 and v1 or LochNessBoss
end

local function update(p5) -- line: 130
    -- upvalues: HullRig (copy), t1 (copy), v1 (ref), v2 (ref), v3 (ref), t3 (copy), n1 (ref), Position (ref), build (copy)
    local BossArena = workspace:FindFirstChild("BossArena")
    local LochNessBoss = BossArena and BossArena:FindFirstChild("LochNessBoss")

    if LochNessBoss and t1.active() then
        if v3 == LochNessBoss and v1 and v1.Parent then
            local Parent = LochNessBoss.Parent
            local WaterY = if Parent then Parent:GetAttribute("WaterY") else nil

            if not Parent or not WaterY then
                WaterY = 0
            end

            local Pivot = LochNessBoss:GetPivot()
            local v8 = Pivot.Position.Y - WaterY - -53
            local v9 = if v8 > 0 then v8 * 0.8 else v8
            local v11 = Vector3.new(Pivot.Position.X, WaterY - 27 + v9, Pivot.Position.Z) + Vector3.new(0, 23, 0)
            local v12 = CFrame.new(v11) * Pivot.Rotation * CFrame.new(0, -23, 0)
            local v14 = os.clock() - n1
            local Position2 = Position
            local v15 = if Position2 then (Pivot.Position - Position).Magnitude / math.max(p5, 0.004166666666666667) else 0

            Position = Pivot.Position

            local v17 = math.clamp(v8 / 30, 0, 1)

            HullRig.pose(v2, v12, v14, {
                walk = math.clamp(0.35 + v15 / 60, 0.35, 1),
                speed = math.clamp(v15 / 40, 0, 1.5) + 1,
                open = v17 * 0.6 + 0.3,
                snap = v17 > 0.3,
                raise = v17,
                jaw = v17 * 0.8 + (math.sin(v14 * 1.7) + 1) * 0.08,
                prop = v17 + 0.6
            })

            local t5 = {}
            local t6 = {}

            for v23, v24 in t3 do
                table.insert(t5, v23)
                table.insert(t6, v12 * v24)
            end

            workspace:BulkMoveTo(t5, t6, Enum.BulkMoveMode.FireCFrameChanged)
        else
            build(LochNessBoss)

            if v1 then
                local Parent = LochNessBoss.Parent
                local WaterY = Parent and Parent:GetAttribute("WaterY") or 0
                local Pivot = LochNessBoss:GetPivot()
                local v26 = Pivot.Position.Y - WaterY - -53
                local v27 = if v26 > 0 then v26 * 0.8 else v26
                local v29 = Vector3.new(Pivot.Position.X, WaterY - 27 + v27, Pivot.Position.Z) + Vector3.new(0, 23, 0)
                local v30 = CFrame.new(v29) * Pivot.Rotation * CFrame.new(0, -23, 0)
                local v32 = os.clock() - n1
                local Position2 = Position
                local v33 = if Position2 then (Pivot.Position - Position).Magnitude / math.max(p5, 0.004166666666666667) else 0

                Position = Pivot.Position

                local v35 = math.clamp(v26 / 30, 0, 1)

                HullRig.pose(v2, v30, v32, {
                    walk = math.clamp(0.35 + v33 / 60, 0.35, 1),
                    speed = math.clamp(v33 / 40, 0, 1.5) + 1,
                    open = v35 * 0.6 + 0.3,
                    snap = v35 > 0.3,
                    raise = v35,
                    jaw = v35 * 0.8 + (math.sin(v32 * 1.7) + 1) * 0.08,
                    prop = v35 + 0.6
                })

                local t8 = {}
                local t9 = {}

                for v41, v42 in t3 do
                    table.insert(t8, v41)
                    table.insert(t9, v30 * v42)
                end

                workspace:BulkMoveTo(t8, t9, Enum.BulkMoveMode.FireCFrameChanged)
            end
        end
    else
        if not v1 then
            return
        end

        if v1 then
            v1:Destroy()
        end

        if v3 and v3.Parent then
            for _, descendant in v3:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end

        v1 = nil
        v2 = nil
        v3 = nil
        table.clear(t3)
        Position = nil
    end
end

function t1.init() -- line: 175
    -- upvalues: RunService (copy), t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), v3 (ref), t3 (copy), Position (ref), update (copy)
    RunService:BindToRenderStep("BossSkin", Enum.RenderPriority.Camera.Value - 2, update)
    LocalPlayer:GetAttributeChangedSignal("World2Unlocked"):Connect(function() -- line: 178
        -- upvalues: t1 (copy), v1 (ref), v2 (ref), v3 (ref), t3 (copy), Position (ref)
        if t1.active() then
            return
        end

        if v1 then
            v1:Destroy()
        end

        if v3 and v3.Parent then
            for _, descendant in v3:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end

        v1 = nil
        v2 = nil
        v3 = nil
        table.clear(t3)
        Position = nil
    end)
end

return t1
