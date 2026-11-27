-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local WeatherConfig = require(script.Parent:WaitForChild("WeatherConfig"))
local AdminAbuseConfig = require(script.Parent:WaitForChild("AdminAbuseConfig"))
local t1 = {
    INTERVAL = 180,
    STORM_ROLL = 60
}
local t2 = {}
local n1 = 0

local function pick(p1) -- line: 27
    -- upvalues: WeatherConfig (copy), t2 (ref), n1 (ref)
    local v3 = tostring(workspace:GetAttribute("WeatherForce")) .. "|" .. tostring(workspace:GetAttribute("HalloweenTest")) .. "|" .. tostring(workspace:GetAttribute("TicketWeathers"))
    local v4 = t2[p1]

    if v4 and v4.force == v3 then
        return v4.id
    end

    if n1 > 16 then
        t2 = {}
        n1 = 0
    end

    local v5 = WeatherConfig.Pick(p1)
    local t3 = t2

    t3[p1] = {
        force = v3,
        id = v5
    }
    n1 += 1

    return v5
end

local function stormOf(p2, p3) -- line: 40
    -- upvalues: WeatherConfig (copy), pick (copy)
    local v6 = WeatherConfig.WEATHERS[pick(p2)]

    if v6 and v6.fish then
        local v7 = WeatherConfig.SlotEnd(p2) - p3

        return {
            v7 - WeatherConfig.EVENT,
            v7
        }
    end

    return nil
end

function t1.NextTick(p4) -- line: 49
    -- upvalues: WeatherConfig (copy), AdminAbuseConfig (copy), t1 (copy), stormOf (copy)
    local INTERVAL = t1.INTERVAL
    local v8 = WeatherConfig.Shift(0)
    local v9 = WeatherConfig.SlotOf(p4 + v8)
    local t4 = {}

    for i = v9, v9 + 1 do
        local v10 = stormOf(i, v8)

        if v10 then
            t4[#t4 + 1] = v10
        end
    end

    local n2 = 1e999

    for _, v11 in ipairs(t4) do
        local v12 = v11[1] + t1.STORM_ROLL
        local v13 = v11[2] - t1.STORM_ROLL

        if p4 < v12 and v12 < n2 then
            n2 = v12
        end

        if p4 < v13 and v13 < n2 then
            n2 = v13
        end
    end

    local LEVEL1 = AdminAbuseConfig.LEVEL1
    local v14 = AdminAbuseConfig.FromServerTime(0)
    local v15 = AdminAbuseConfig.START + LEVEL1.at - v14
    local v16 = AdminAbuseConfig.START + AdminAbuseConfig.LEVEL2.at - v14
    local v17 = n2

    if p4 < v16 then
        v17 = math.max(math.floor(p4 / LEVEL1.EVERY) + 1, (math.ceil(v15 / LEVEL1.EVERY))) * LEVEL1.EVERY

        if not (v17 < v16 and v17 < n2) then
            v17 = n2
        end
    end

    local v23 = (math.floor(p4 / INTERVAL) + 1) * INTERVAL

    for _ = 1, 4 do
        local v24 = false

        for _, v25 in ipairs(t4) do
            if v25[1] <= v23 and v23 < v25[2] then
                v24 = true
            end
        end

        if not v24 then
            break
        end

        v23 += INTERVAL
    end

    return (math.min(v17, v23))
end

function t1.SecondsLeft(p5) -- line: 87
    -- upvalues: t1 (copy)
    return t1.NextTick(p5) - p5
end

return t1
