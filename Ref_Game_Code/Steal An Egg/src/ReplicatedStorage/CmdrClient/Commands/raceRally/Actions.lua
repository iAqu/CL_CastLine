-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CmdrToolkit = require(ReplicatedStorage.Shared.Utils.CmdrToolkit)
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local RaceRally = require(ReplicatedStorage.Data.RaceRally)
local RaceRallySchedule = require(ReplicatedStorage.Shared.Util.RaceRallySchedule)
local RaceRally2 = require(ReplicatedStorage.Shared.Types.RaceRally)
local Arg = CmdrToolkit.Arg
local v1, v2 = CmdrToolkit.Manifest()

local function idsOrAll(p1) -- line: 24
    local t1 = {
        "all"
    }

    for v3 in p1 do
        table.insert(t1, v3)
    end

    return t1
end

local v4 = Arg("players", "players", "Who; defaults to you", true)
local v5 = Arg(CmdrToolkit.Enum("raceRacer", function() -- line: 34
    -- upvalues: RaceRally (copy)
    local t2 = {
        "all"
    }

    for v6 in RaceRally.Racers do
        table.insert(t2, v6)
    end

    return t2
end, "racer"), "racer", "A racer id, or all")
local v7 = Arg(CmdrToolkit.Enum("raceMilestone", function() -- line: 41
    -- upvalues: RaceRally (copy)
    local t3 = {
        "all"
    }

    for v8 in RaceRally.Milestones do
        table.insert(t3, v8)
    end

    table.insert(t3, RaceRally.RepeatId)

    return t3
end, "milestone"), "milestone", "A milestone id, Repeat (the repeat rewards past the ladder), or all")

local function clock(p2) -- line: 50
    local v10 = math.max(math.floor(p2), 0)

    return string.format("%dm %02ds", v10 // 60, v10 % 60)
end

local function names(p3) -- line: 55
    local t4 = {}

    for v11 in p3 do
        table.insert(t4, v11)
    end

    table.sort(t4)

    if #t4 > 0 then
        return (table.concat(t4, ", "))
    end

    return "none"
end

local function describe(p4, p5) -- line: 64
    -- upvalues: RaceRally (copy), names (copy)
    return ("%*: %* trophies, %* wins, %* races, %* nitro"):format(p4.Name, p5.Tokens, p5.Wins, p5.Races, p5.MutationConsumables) .. (" | claimed: %* + %* repeats | racers: %*"):format(names(p5.Milestones), p5.Repeats, (names(p5.Racers))) .. (" | riding: %* | shop limits: %*"):format(RaceRally.ResolveRacer(p5.EquippedRacer, p5.Racers), (names(p5.Purchases)))
end

local function raceLine() -- line: 74
    -- upvalues: Workspace (copy), RaceRallyFlags (copy), RaceRally (copy), RaceRallySchedule (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()

    if Workspace:GetAttribute(RaceRally.Attributes.Running) == true then
        local Attribute = Workspace:GetAttribute(RaceRally.Attributes.JoinEndsAt)

        if type(Attribute) ~= "number" then
            return "Race: racing"
        end

        local v14 = math.max(math.floor(Attribute - ServerTimeNow), 0)

        return (("Race: portal open, closes in %*"):format((string.format("%dm %02ds", v14 // 60, v14 % 60))))
    end

    if not RaceRallyFlags.ContentEnabled:Get() then
        return "Race: switched off (Game.RaceRally.ContentEnabled)"
    end

    if not RaceRallyFlags.ScheduleEnabled:Get() then
        return "Race: idle, schedule off (Game.RaceRally.ScheduleEnabled)"
    end

    local _, v15 = RaceRallySchedule.Window(ServerTimeNow)
    local v18 = math.max(math.floor(v15 + RaceRallyFlags.ScheduleIntervalSeconds:Get() - ServerTimeNow), 0)

    return (("Race: idle, next portal in %*"):format((string.format("%dm %02ds", v18 // 60, v18 % 60))))
end

local function targets(p6, p7) -- line: 92
    return p7 or { p6.executor }
end

local function edit(p8, p9, p10) -- line: 97
    -- upvalues: describe (copy)
    local t5 = {}

    for _, v19 in p9 or { p8.executor } do
        local v20, v21, v22 = p8.Profile.Write(v19, function(p11) -- line: 100
            -- upvalues: p10 (copy)
            p10(p11)

            return true
        end)

        table.insert(t5, if not v20 then ("%*: %*"):format(v19.Name, v21) elseif v22 == nil then ("%*: %*"):format(v19.Name, v21) else describe(v19, v22))
    end

    return table.concat(t5, "\n")
end

v2("status", "Race progress and this server's race clock", {
    v4
}, function(p12, p13) -- line: 112
    -- upvalues: describe (copy), raceLine (copy)
    local t6 = {
        (raceLine())
    }

    for _, v24 in p13 or { p12.executor } do
        local v25 = p12.Profile.Get(v24)

        table.insert(t6, if v25 == nil then ("%*: profile not loaded"):format(v24.Name) else describe(v24, v25))
    end

    return table.concat(t6, "\n")
end)
v2("trophies", "Add Trophies; negative takes them away", {
    Arg("integer", "amount", "Trophies to add"),
    v4
}, function(p14, p15, p16) -- line: 127
    -- upvalues: edit (copy)
    return edit(p14, p16, function(p17) -- line: 128
        -- upvalues: p15 (copy)
        p17.Tokens = math.max(p17.Tokens + p15, 0)
    end)
end)
v2("nitro", "Add Nitro mutation uses; negative takes them away", {
    Arg("integer", "amount", "Uses to add"),
    v4
}, function(p18, p19, p20) -- line: 136
    -- upvalues: edit (copy)
    local v28 = edit(p18, p20, function(p21) -- line: 137
        -- upvalues: p19 (copy)
        p21.MutationConsumables = math.max(p21.MutationConsumables + p19, 0)
    end)

    for _, v30 in p20 or { p18.executor } do
        p18.Service.SyncNitro(v30)
    end

    return v28
end)
v2("wins", "Add race wins toward the milestones; negative takes them away", {
    Arg("integer", "amount", "Wins to add"),
    v4
}, function(p22, p23, p24) -- line: 149
    -- upvalues: edit (copy)
    return edit(p22, p24, function(p25) -- line: 150
        -- upvalues: p23 (copy)
        p25.Wins = math.max(p25.Wins + p23, 0)
    end)
end)
v2("unlock", "Unlock a racer without claiming its milestone", {
    v5,
    v4
}, function(p26, p27, p28) -- line: 159
    -- upvalues: RaceRally (copy), edit (copy)
    return edit(p26, p28, function(p29) -- line: 160
        -- upvalues: p27 (copy), RaceRally (copy)
        for v32 in RaceRally.Racers do
            if (p27 == "all" or v32 == p27) and v32 ~= RaceRally.DefaultRacer then
                p29.Racers[v32] = true
            end
        end
    end)
end)
v2("lock", "Lock a racer again; riding it falls back to the default", {
    v5,
    v4
}, function(p30, p31, p32) -- line: 174
    -- upvalues: RaceRally (copy), edit (copy)
    return edit(p30, p32, function(p33) -- line: 175
        -- upvalues: p31 (copy), RaceRally (copy)
        for v33 in RaceRally.Racers do
            if p31 == "all" or v33 == p31 then
                p33.Racers[v33] = nil
            end
        end

        if not p33.Racers[p33.EquippedRacer] then
            p33.EquippedRacer = ""
        end
    end)
end)
v2("unclaim", "Mark a milestone unclaimed so it can be claimed again; rewards already given stay", {
    v7,
    v4
}, function(p34, p35, p36) -- line: 192
    -- upvalues: RaceRally (copy), edit (copy)
    return edit(p34, p36, function(p37) -- line: 193
        -- upvalues: p35 (copy), RaceRally (copy)
        if p35 == "all" then
            table.clear(p37.Milestones)
            p37.Repeats = 0
        elseif p35 == RaceRally.RepeatId then
            p37.Repeats = 0
        else
            p37.Milestones[p35] = nil
        end
    end)
end)
v2("restock", "Clear the shop purchase limits", {
    v4
}, function(p38, p39) -- line: 206
    -- upvalues: edit (copy)
    return edit(p38, p39, function(p40) -- line: 207
        table.clear(p40.Purchases)
    end)
end)
v2("reset", "Wipe race progress back to a new player's and let them race again this window", {
    v4
}, function(p41, p42) -- line: 216
    -- upvalues: RaceRally2 (copy), edit (copy)
    for _, v34 in p42 or { p41.executor } do
        p41.Service.ClearLockout(v34)
    end

    return edit(p41, p42, function(p43) -- line: 220
        -- upvalues: RaceRally2 (copy)
        for v35, v36 in RaceRally2.Blank() do
            p43[v35] = v36
        end

        p43.LastRacedWindow = nil
    end)
end)
v2("award", "Pay a race result as if they finished in that place; 0 = did not finish", {
    Arg("integer", "place", "1 = a win; 0 = did not finish"),
    v4
}, function(p44, p45, p46) -- line: 232
    -- upvalues: describe (copy)
    if p45 < 0 then
        return "Place can't be negative."
    end

    local t7 = {}

    for _, v37 in p46 or { p44.executor } do
        local v38, v39, v40 = p44.Service.Award(v37, math.max(p45, 1), p45 > 0)

        table.insert(t7, if v40 == nil then ("%*: the save failed"):format(v37.Name) else ("+%* trophies, +%* wins -> %*"):format(v38, v39, (describe(v37, v40))))
    end

    return table.concat(t7, "\n")
end)
v2("start", "Open the race portal on this server now", {
    Arg("integer", "joinSeconds", "How long the portal stays open; default Game.RaceRally.JoinSeconds", true),
    Arg("integer", "laps", "Default Game.RaceRally.Laps", true),
    Arg("integer", "racers", "Bots fill the grid up to this many (1 = no bots); default Game.RaceRally.RacersWithBots", true)
}, function(p47, p48, p49, p50) -- line: 263
    if p48 ~= nil and (p48 < 5 or p48 > 600) then
        return (`joinSeconds must be {5}-{600}.`)
    end

    if p49 ~= nil and (p49 < 1 or p49 > 10) then
        return (`laps must be 1-{10}.`)
    end

    if p50 ~= nil and (p50 < 1 or p50 > 20) then
        return (`racers must be 1-{20}.`)
    end

    local _, v42 = p47.Service.StartRace(p48, p49, p50)

    return v42
end)
v2("stop", "End the race on this server", {}, function(p51) -- line: 279
    if p51.Service.StopRace() then
        return "Race stopped."
    end

    return "No race is running on this server."
end)

return v1
