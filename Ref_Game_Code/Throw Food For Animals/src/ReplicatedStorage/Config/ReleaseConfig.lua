-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {
    Released = {
        ShadowRealm = true,
        Upcoming = false,
        HarvestHarbor = false
    },
    Schedule = {
        ShadowRealm = {
            Year = 2026,
            Month = 10,
            Day = 6,
            Hour = 22,
            Minute = 0,
            UtcOffset = 2
        },
        HarvestHarbor = {
            Year = 2026,
            Month = 10,
            Day = 25,
            Hour = 19,
            Minute = 0,
            UtcOffset = 1
        }
    },
    ByProgress = {
        HarvestHarbor = {
            FromArea = 7
        }
    },
    Show = {
        HarvestHarbor = {
            Title = "2 NEW MAPS!",
            SmallText = "2 new maps are out!",
            BigFromArea = 7,
            CutsceneFromArea = 13,
            LobbyTheme = "Halloween",
            EventId = "204931155982680674",
            Maps = { "HarvestFields", "PhantomHarbor" }
        }
    },
    EventFollow = {
        AskAfterMinutes = 20,
        MaxAsks = 2,
        AskGapMinutes = 20,
        TrainingSeconds = 4,
        IdleSeconds = 12,
        AskFrom = {
            Area = "AncientRuins",
            Part = 0.75
        }
    },
    StandInFrom = {
        HalloweenUpdateBoard = {
            Year = 2026,
            Month = 10,
            Day = 24,
            Hour = 17,
            Minute = 50,
            UtcOffset = 2
        }
    },
    StudioPreview = false,
    StudioTestReleaseIn = nil,
    DevServer = {
        ReservedServers = true,
        StudioTest = false,
        Owners = {
            [8413545680] = "KosmicarIII",
            [1883085200] = "Kosmicar"
        },
        Keys = {
            HarvestHarbor = true
        }
    }
}
local v1 = RunService:IsStudio()
local v2

function t1.IsDevServer() -- line: 202
    -- upvalues: RunService (copy), t1 (copy), v1 (copy), v2 (ref)
    if v2 ~= nil then
        return v2
    end

    local DevServer = t1.DevServer

    if not RunService:IsRunning() then
        return false
    end

    if RunService:IsServer() then
        local v3, v4

        if game.PrivateServerId == "" then
            v4 = 0
            v3 = false
        else
            v4 = game.PrivateServerOwnerId
            v3 = v4 == 0
        end

        local v5 = false

        if v3 and DevServer.ReservedServers == true then
            local function v6() -- line: 217
                local v7 = game:GetService("ServerScriptService"):WaitForChild("Server", 10)

                return require(v7:WaitForChild("ServerKind", 10)).ReservedKind()
            end

            local ok, result = pcall(v6)

            v5 = ok and result == "Dev"
        end

        v2 = v4 ~= 0 and DevServer.Owners[v4] ~= nil or v5 or v1 and DevServer.StudioTest == true
        workspace:SetAttribute("DevServer", v2)
    else
        local DevServer = workspace:GetAttribute("DevServer")

        if DevServer == nil then
            local elapsed = os.clock()

            repeat
                task.wait()
                DevServer = workspace:GetAttribute("DevServer")
            until DevServer ~= nil or os.clock() - elapsed > 10
        end

        v2 = DevServer == true
    end

    return v2
end

function t1.IsDeveloper(p1) -- line: 245
    -- upvalues: t1 (copy)
    return p1 ~= nil and t1.DevServer.Owners[p1.UserId] ~= nil
end

function t1.IsOn(p2) -- line: 251
    -- upvalues: t1 (copy), v1 (copy)
    if p2 == nil or t1.Released[p2] or t1.Schedule[p2] or t1.DevServer.Keys[p2] and t1.IsDevServer() then
        return true
    end

    if t1.StudioPreview == true then
        return v1
    end

    return false
end

function t1.IsDevOpen(p3) -- line: 260
    -- upvalues: t1 (copy)
    if p3 ~= nil and t1.DevServer.Keys[p3] == true then
        return (t1.IsDevServer())
    end

    return false
end

function t1.IsScheduled(p4) -- line: 266
    -- upvalues: t1 (copy)
    local v9

    if p4 ~= nil then
        v9 = not t1.Released[p4]

        if v9 then
            v9 = t1.Schedule[p4] ~= nil and not t1.IsDevOpen(p4)
        end
    else
        v9 = false
    end

    return v9
end

function t1.IsUnlocked(p5) -- line: 272
    -- upvalues: t1 (copy)
    if p5 == nil or t1.Released[p5] then
        return true
    end

    if t1.Schedule[p5] and not t1.IsDevOpen(p5) then
        return workspace:GetAttribute("Unlocked_" .. p5) == true
    end

    return t1.IsOn(p5)
end

local function toUnix(p6) -- line: 279
    return DateTime.fromUniversalTime(p6.Year, p6.Month, p6.Day, 0, 0, 0).UnixTimestamp + ((p6.Hour or 0) - (p6.UtcOffset or 0)) * 3600 + (p6.Minute or 0) * 60
end

function t1.ScheduledTime(p7) -- line: 285
    -- upvalues: t1 (copy)
    local v11 = t1.Schedule[p7]

    return if v11 then DateTime.fromUniversalTime(v11.Year, v11.Month, v11.Day, 0, 0, 0).UnixTimestamp + ((v11.Hour or 0) - (v11.UtcOffset or 0)) * 3600 + (v11.Minute or 0) * 60 else nil
end

function t1.StandInTime(p8) -- line: 292
    -- upvalues: t1 (copy), v1 (copy)
    local v12 = t1.StandInFrom[p8]

    return if v12 and (not v1 or type(t1.StudioTestReleaseIn) ~= "number" and not t1.StudioPreview) then DateTime.fromUniversalTime(v12.Year, v12.Month, v12.Day, 0, 0, 0).UnixTimestamp + ((v12.Hour or 0) - (v12.UtcOffset or 0)) * 3600 + (v12.Minute or 0) * 60 else nil
end

function t1.ServerReleaseTime(p9, p10) -- line: 301
    -- upvalues: t1 (copy), v1 (copy)
    if not v1 then
        return t1.ScheduledTime(p9)
    end

    if type(t1.StudioTestReleaseIn) == "number" then
        return p10 + t1.StudioTestReleaseIn
    end

    if t1.StudioPreview then
        return 0
    end

    return t1.ScheduledTime(p9)
end

function t1.TimeLeft(p11) -- line: 313
    -- upvalues: t1 (copy)
    if t1.IsUnlocked(p11) then
        return 0
    end

    local Attribute = workspace:GetAttribute("ReleaseAt_" .. tostring(p11))

    return if type(Attribute) == "number" then math.max(0, Attribute - workspace:GetServerTimeNow()) else nil
end

function t1.FormatTime(p12) -- line: 321
    local v16 = math.max(0, (math.floor(p12 or 0)))
    local v17 = v16 // 86400
    local v18 = v16 % 86400 // 3600
    local v19 = v16 % 3600 // 60
    local v20 = v16 % 60

    if v17 > 0 then
        return string.format("%dd %dh %02dm", v17, v18, v19)
    end

    if v18 > 0 then
        return string.format("%d:%02d:%02d", v18, v19, v20)
    end

    return string.format("%d:%02d", v19, v20)
end

function t1.Filter(p13) -- line: 333
    -- upvalues: t1 (copy)
    local t2 = {}

    for _, v21 in ipairs(p13) do
        if t1.IsOn(v21.Release) then
            table.insert(t2, v21)
        end
    end

    return t2
end

function t1.FillUnlocked(p14, p15) -- line: 344
    -- upvalues: t1 (copy)
    table.clear(p14)

    for _, v22 in ipairs(p15) do
        if not t1.IsUnlocked(v22.Release) then
            break
        end

        table.insert(p14, v22)
    end

    return p14
end

local t3 = {}
local t4 = {}

function t1.OnChanged(p16) -- line: 362
    -- upvalues: t3 (copy)
    table.insert(t3, p16)
end

function t1.Refresh() -- line: 369
    -- upvalues: t1 (copy), t3 (copy), t4 (copy)
    for v23 in pairs(t1.Schedule) do
        local v24 = t1.IsUnlocked(v23)

        if t4[v23] ~= v24 then
            t4[v23] = v24

            for _, v25 in ipairs(t3) do
                local ok, result = pcall(v25, v23, v24)

                if not ok then
                    warn("[ReleaseConfig] listener failed for " .. v23 .. ": " .. tostring(result))
                end
            end
        end
    end
end

for v26 in pairs(t1.Schedule) do
    t4[v26] = t1.IsUnlocked(v26)
    workspace:GetAttributeChangedSignal("Unlocked_" .. v26):Connect(t1.Refresh)
end

if RunService:IsServer() and RunService:IsRunning() then
    t1.IsDevServer()
end

return t1
