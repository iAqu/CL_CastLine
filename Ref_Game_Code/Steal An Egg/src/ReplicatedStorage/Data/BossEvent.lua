-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local BossEventSounds = ReplicatedStorage.Assets.Sounds:WaitForChild("BossEventSounds")
local t1 = {}
local v1
local t2 = {
    IntervalSeconds = 1800,
    BossName = "Abyss Overlord"
}

function t2.CurrentPeriod() -- line: 54
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow() // 1800
end

function t2.PeriodStart(p1) -- line: 58
    return p1 * 1800
end

function t2.ClampDuration(p2) -- line: 64
    return (math.clamp(p2, 1, 1740))
end

function t2.HealthMultiplier(p3) -- line: 71
    -- upvalues: BossEventFlags (copy)
    local v3 = math.max(math.floor(p3), 1)
    local n1 = (-1e999)
    local n2 = 1e999
    local v5
    local v4

    for v6, v7 in BossEventFlags.HealthScalesWithPlayers:Get() do
        local v8 = tonumber(v6)

        if v8 ~= nil then
            if v8 <= v3 and n1 < v8 then
                n1 = v8
                v4 = v7
            end

            if v8 < n2 then
                n2 = v8
                v5 = v7
            end
        end
    end

    return v4 or v5 or 1
end

local function soundNamed(p4) -- line: 99
    -- upvalues: BossEventSounds (copy), t1 (copy)
    local v9 = t1[p4]

    if v9 ~= nil then
        return v9
    end

    local v10 = BossEventSounds:FindFirstChild(p4)

    assert(v10 ~= nil and v10:IsA("Sound"), (("BossEventSounds needs the Sound %*"):format(p4)))
    t1[p4] = v10

    return v10
end

function t2.PlaySound(p5, p6, p7) -- line: 114
    -- upvalues: RunService (copy), Audio (copy), BossEventSounds (copy), t1 (copy), v1 (ref)
    local v13 = t1[p5]

    if v13 == nil then
        v13 = BossEventSounds:FindFirstChild(p5)
        assert(v13 ~= nil and v13:IsA("Sound"), (("BossEventSounds needs the Sound %*"):format(p5)))
        t1[p5] = v13
    end

    local v17 = if p7 == nil then {} else table.clone(p7)

    v17.MaxDistance = v17.MaxDistance or v13.RollOffMaxDistance
    v17.SoundGroup = v17.SoundGroup or "SFX"

    local v18 = v1

    if not RunService:IsServer() or v18 == nil or v17.Recipient ~= nil then
        return Audio.Play(v13, p6, v17)
    end

    for _, v19 in v18() do
        local v20 = table.clone(v17)

        v20.Recipient = v19
        Audio.Play(v13, p6, v20)
    end

    return nil
end

function t2.SetAudience(p8) -- line: 136
    -- upvalues: v1 (ref)
    v1 = p8
end

function t2.PlaySoundEverywhere(p9, p10) -- line: 144
    -- upvalues: BossEventSounds (copy), t2 (copy)
    return t2.PlaySound(p9, BossEventSounds, p10)
end

function t2.CurrentWindow(p11) -- line: 148
    -- upvalues: Workspace (copy), t2 (copy)
    local v21 = t2.ClampDuration(p11)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v22 = t2.PeriodStart(ServerTimeNow // 1800)

    if ServerTimeNow - v22 < v21 then
        return {
            Open = true,
            OpensAt = v22,
            ClosesAt = v22 + v21
        }
    end

    local v23 = v22 + 1800

    return {
        Open = false,
        OpensAt = v23,
        ClosesAt = v23 + v21
    }
end

function t2.SecondsUntilNextOpen() -- line: 169
    -- upvalues: Workspace (copy)
    return 1800 - Workspace:GetServerTimeNow() % 1800
end

return table.freeze(t2)
