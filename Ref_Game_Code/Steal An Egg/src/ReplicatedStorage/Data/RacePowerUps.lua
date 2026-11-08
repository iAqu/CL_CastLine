-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function item(p1, p2, p3, p4, p5, p6, p7) -- line: 23
    return table.freeze({
        Id = p1,
        Name = p2,
        Icon = p3,
        Color = p4,
        Uses = p5,
        Seconds = p6,
        Model = p7
    })
end

local t1 = {
    SimStep = 0.03333333333333333,
    Order = table.freeze({ "Shield", "Spike", "Serum", "Skywhale", "Pod", "Drilla", "Egg" })
}
local freeze = table.freeze
local v1 = Color3.fromRGB(80, 205, 255)
local t2 = {}

t2.Shield = table.freeze({
    Id = "Shield",
    Name = "Scramble Shield",
    Icon = "",
    Uses = 1,
    Seconds = 7,
    Model = "Shield",
    Color = v1
})

local v2 = Color3.fromRGB(255, 165, 60)

t2.Spike = table.freeze({
    Id = "Spike",
    Name = "Spike",
    Icon = "rbxassetid://80985497889360",
    Uses = 3,
    Seconds = nil,
    Model = nil,
    Color = v2
})

local v3 = Color3.fromRGB(130, 255, 70)

t2.Serum = table.freeze({
    Id = "Serum",
    Name = "Scramble Serum",
    Icon = "rbxassetid://98847011195862",
    Uses = 1,
    Seconds = 5,
    Model = nil,
    Color = v3
})

local v4 = Color3.fromRGB(185, 110, 255)

t2.Skywhale = table.freeze({
    Id = "Skywhale",
    Name = "Royale Skywhale Express",
    Icon = "rbxassetid://140420688307546",
    Uses = 1,
    Seconds = 4,
    Model = nil,
    Color = v4
})

local v5 = Color3.fromRGB(255, 70, 70)

t2.Pod = table.freeze({
    Id = "Pod",
    Name = "Dr Scramble Pod",
    Icon = "rbxassetid://135238935953633",
    Uses = 1,
    Seconds = nil,
    Model = nil,
    Color = v5
})

local v6 = Color3.fromRGB(255, 200, 60)

t2.Drilla = table.freeze({
    Id = "Drilla",
    Name = "Drilla Ambush",
    Icon = "rbxassetid://85987118042621",
    Uses = 1,
    Seconds = nil,
    Model = nil,
    Color = v6
})

local v7 = Color3.fromRGB(255, 215, 40)

t2.Egg = table.freeze({
    Id = "Egg",
    Name = "Egg Splatter",
    Icon = "",
    Uses = 1,
    Seconds = nil,
    Model = "Splat",
    Color = v7
})
t1.Items = freeze(t2)
t1.Weights = table.freeze({
    Front = table.freeze({
        Shield = 30,
        Spike = 30,
        Egg = 35,
        Pod = 5
    }),
    Middle = table.freeze({
        Shield = 14,
        Spike = 20,
        Egg = 14,
        Serum = 14,
        Pod = 18,
        Drilla = 12,
        Skywhale = 8
    }),
    Back = table.freeze({
        Shield = 4,
        Spike = 8,
        Egg = 4,
        Serum = 26,
        Pod = 16,
        Drilla = 18,
        Skywhale = 24
    }),
    Bot = table.freeze({
        Shield = 12,
        Serum = 12,
        Skywhale = 8,
        Spike = 24,
        Pod = 18,
        Drilla = 12,
        Egg = 14
    })
})
t1.Attributes = table.freeze({
    Enabled = "RacePowerUps",
    Item = "RacePowerUp",
    Uses = "RacePowerUpUses",
    RollEndsAt = "RacePowerUpRollEndsAt",
    Effect = "RacePowerUpEffect",
    EffectEndsAt = "RacePowerUpEffectEndsAt",
    StunEndsAt = "RacePowerUpStunEndsAt",
    BoxReadyAt = "RaceBoxReadyAt",
    BoardPlace = "RaceBoardPlace",
    BotAvatar = "RaceBotAvatar"
})
t1.Tuning = table.freeze({
    RollSeconds = 2.4,
    BoxRespawnSeconds = 2.5,
    BoxReach = 22,
    BoxLeadSeconds = 0.5,
    BoxTrailSeconds = 0.15,
    BoxLeadSpeedCap = 2.5,
    PickupInterval = 0.2,
    UseCooldown = 0.35,
    SerumScale = 1.75,
    SkywhaleScale = 2.25,
    SkywhaleHeight = 7,
    SpikeSpeed = 2.6,
    SpikeSeconds = 2.8,
    SpikeRadius = 9,
    SpikeScale = 1.4,
    SpikeGrace = 0.6,
    SpikeStun = 1.2,
    PodSpeed = 2.4,
    PodRange = 50,
    PodSeconds = 7,
    PodRadius = 6,
    PodHeight = 3.5,
    PodStun = 1.5,
    DrillaSpeed = 3.4,
    DrillaBehind = 40,
    DrillaLead = 0.8,
    DrillaWarnSeconds = 0.8,
    DrillaRadius = 9,
    DrillaStun = 1.7,
    DrillaSeconds = 14,
    EggBehind = 8,
    EggRadius = 5.5,
    EggGrace = 0.8,
    EggSeconds = 45,
    EggStun = 2,
    EggSpinSeconds = 0.8
})
t1.Assets = ReplicatedStorage.Assets.MountRace.PowerUps

function t1.Pool(p8) -- line: 150
    -- upvalues: t1 (copy)
    if p8 <= 0.2 then
        return t1.Weights.Front
    end

    if p8 <= 0.6 then
        return t1.Weights.Middle
    end

    return t1.Weights.Back
end

function t1.BoxAttribute(p9) -- line: 159
    -- upvalues: t1 (copy)
    if p9 == nil then
        return t1.Attributes.BoxReadyAt
    end

    return (("%*_%*"):format(t1.Attributes.BoxReadyAt, p9))
end

function t1.Params(p10) -- line: 163
    local v8 = RaycastParams.new()

    v8.FilterType = Enum.RaycastFilterType.Include
    v8.FilterDescendantsInstances = {
        p10.Track,
        p10.Map
    }
    v8.RespectCanCollide = true

    return v8
end

function t1.SpikePath(p11, p12, p13, p14) -- line: 171
    -- upvalues: Workspace (copy), t1 (copy)
    local v9 = Vector3.new(p12.X, 0, p12.Z)
    local v10 = if v9.Magnitude > 0.001 then v9.Unit else Vector3.new(0, 0, 1)
    local v11 = p13 * 0.03333333333333333
    local t3 = {
        p11
    }
    local v13 = math.floor(t1.Tuning.SpikeSeconds / 0.03333333333333333)
    local v14 = p11
    local n1 = 0
    local n2 = 0

    for _ = 1, v13 do
        local v15 = Workspace:Raycast(v14, v10 * (v11 + 1.5), p14)

        if v15 ~= nil and v15.Normal.Y < 0.6 then
            local v16 = Vector3.new(v15.Normal.X, 0, v15.Normal.Z)

            if n1 >= 2 or v16.Magnitude < 0.001 then
                table.insert(t3, v15.Position - v10 * 1.5)

                return t3
            end

            n1 += 1

            local Unit = v16.Unit

            v10 = (v10 - Unit * 2 * v10:Dot(Unit)).Unit
        end

        local v18 = v14 + v10 * v11
        local v19 = Workspace:Raycast(v18 + Vector3.new(0, 7, 0), Vector3.new(-0, -26, -0, -0), p14)

        if v19 ~= nil then
            n2 = 0
            v14 = Vector3.new(v18.X, v19.Position.Y + 1.8, v18.Z)
        else
            n2 += 1
            v14 = v18 - Vector3.new(0, 1, 0) * v11 * 0.6 * n2

            if n2 > 8 then
                table.insert(t3, v14)

                return t3
            end
        end

        table.insert(t3, v14)
    end

    return t3
end

function t1.PathAt(p15, p16) -- line: 210
    local v21 = p16 / 0.03333333333333333 + 1
    local v22 = math.floor(v21)

    if #p15 <= v22 then
        return p15[#p15], true
    end

    if v22 < 1 then
        return p15[1], false
    end

    return p15[v22]:Lerp(p15[v22 + 1], v21 - v22), false
end

return table.freeze(t1)
