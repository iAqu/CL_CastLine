-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.freeze({
    BossId = "BossId",
    Phase = "Phase",
    Ground = "Ground",
    Velocity = "Velocity",
    MovedAt = "MovedAt",
    Yaw = "Yaw",
    Health = "Health",
    MaxHealth = "MaxHealth",
    SpawnedAt = "SpawnedAt",
    SpawnSeconds = "SpawnSeconds",
    EndsAt = "EndsAt",
    CaptureUserId = "CaptureUserId",
    CaptureAt = "CaptureAt",
    CaptureSeconds = "CaptureSeconds",
    DefeatAt = "DefeatAt",
    ExplodePosition = "ExplodePosition",
    DropPosition = "DropPosition",
    Suckers = "Suckers",
    AttackSerial = "AttackSerial",
    AttackPhase = "AttackPhase",
    AttackTarget = "AttackTarget",
    AttackHits = "AttackHits",
    EscapedAt = "EscapedAt",
    Realm = "Realm"
})
local v2 = table.freeze({
    None = "",
    Windup = "Windup",
    Charge = "Charge"
})
local v3 = table.freeze({
    World = "World",
    Town = "Town"
})
local t1 = {
    DisplayName = "Ghouler",
    StateName = "GhostBossState",
    AssetsName = "GhostBossAssets",
    ToolAttribute = "GhostBossVacuum",
    TrainVacuumAttribute = "GhostVacuum",
    SuckingAttribute = "GhostBossSucking",
    Attributes = v1,
    Phases = table.freeze({
        None = "None",
        Spawning = "Spawning",
        Alive = "Alive",
        Capturing = "Capturing",
        Defeated = "Defeated",
        Escaped = "Escaped"
    }),
    AttackPhases = v2,
    Realms = v3,
    ScaleFor = function(p1, p2, p3) -- ScaleFor | line: 94
        local v5 = math.max(1 - p2, 0.001)
        local v7 = math.clamp((p1 - p2) / v5, 0, 1)

        return (p3 - 1) * v7 + 1
    end,
    CaptureProgress = function(p4, p5) -- CaptureProgress | line: 100
        local v9 = math.max(1 - p5, 0.001)

        return 1 - math.clamp((p4 - p5) / v9, 0, 1)
    end,
    Center = function(p6, p7, p8, p9) -- Center | line: 105
        return p6 + Vector3.new(0, p9 + p8 * p7, 0)
    end,
    EncodeSuckers = function(p10) -- EncodeSuckers | line: 114
        table.sort(p10)

        local v12 = table.create(#p10)

        for v13, v14 in p10 do
            v12[v13] = tostring(v14)
        end

        return table.concat(v12, ",")
    end,
    DecodeSuckers = function(p11) -- DecodeSuckers | line: 123
        local t2 = {}

        if type(p11) == "string" then
            for match in string.gmatch(p11, "[^,]+") do
                local v15 = tonumber(match)

                if v15 then
                    table.insert(t2, v15)
                end
            end
        end

        return t2
    end,
    IsVacuum = function(p12) -- IsVacuum | line: 137
        return p12:IsA("Tool") and (p12:GetAttribute("GhostBossVacuum") ~= nil or p12:GetAttribute("GhostVacuum") == true)
    end
}

function t1.IsTrainVacuum(p13) -- line: 145
    return p13:IsA("Tool") and p13:GetAttribute("GhostVacuum") == true
end

function t1.RealmOf(p14) -- line: 149
    -- upvalues: v3 (copy)
    local TrainEventPhase = p14:GetAttribute("TrainEventPhase")

    if TrainEventPhase == "Town" then
        return v3.Town
    end

    return if (TrainEventPhase == nil or TrainEventPhase == "Home") and p14:GetAttribute("InHalloweenDimension") ~= true then v3.World else nil
end

function t1.RealmNamed(p15) -- line: 163
    -- upvalues: v3 (copy)
    if p15 == v3.Town then
        return v3.Town
    end

    return v3.World
end

function t1.TemplateHalfHeight(p16) -- line: 167
    return p16:GetExtentsSize().Y / 2 / p16:GetScale()
end

return table.freeze(t1)
