-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CmdrToolkit = require(ReplicatedStorage.Shared.Utils.CmdrToolkit)
local TheHollowFlags = require(ReplicatedStorage.Shared.Flags.TheHollowFlags)
local TheHollow = require(ReplicatedStorage.Data.TheHollow)
local TheHollow2 = require(ReplicatedStorage.Shared.Types.TheHollow)
local Arg = CmdrToolkit.Arg
local v1, v2 = CmdrToolkit.Manifest()
local v3 = Arg("players", "players", "Who; defaults to you", true)
local v4 = Arg(CmdrToolkit.Enum("hollowPrize", function() -- line: 23
    -- upvalues: TheHollow (copy)
    local t1 = {
        "all"
    }

    for v5 in TheHollow.Prizes do
        table.insert(t1, v5)
    end

    return t1
end, "prize"), "prize", "A prize id, or all")

local function clock(p1) -- line: 34
    local v7 = math.max(math.floor(p1), 0)

    return string.format("%dm %02ds", v7 // 60, v7 % 60)
end

local function claimed(p2) -- line: 39
    -- upvalues: TheHollow (copy)
    local t2 = {}

    for _, v8 in TheHollow.OrderedPrizes() do
        if p2.Claimed[v8.Id] then
            table.insert(t2, v8.Id)
        end
    end

    if #t2 > 0 then
        return (table.concat(t2, ", "))
    end

    return "none"
end

local function describe(p3, p4) -- line: 49
    -- upvalues: claimed (copy)
    return (("%*: %* Hollow wins | prizes claimed: %*"):format(p3.Name, p4.Wins, (claimed(p4))))
end

local function raceLine(p5) -- line: 53
    -- upvalues: Workspace (copy), TheHollowFlags (copy)
    if not TheHollowFlags.ContentEnabled:Get() then
        return "The Hollow: switched off (Game.TheHollow.ContentEnabled)"
    end

    local v9 = ("The Hollow: %*/%* races, %* queued"):format(#p5.Service.Races(), TheHollowFlags.MaxConcurrentRaces:Get(), (p5.Service.Queued()))
    local TheHollowJoinEndsAt = Workspace:GetAttribute("TheHollowJoinEndsAt")

    if type(TheHollowJoinEndsAt) == "number" then
        local v10 = Workspace:GetAttribute("TheHollowRacers") or 0
        local v13 = math.max(math.floor(TheHollowJoinEndsAt - Workspace:GetServerTimeNow()), 0)

        v9 ..= (" | one filling, %* in, closes in %*"):format(v10, (string.format("%dm %02ds", v13 // 60, v13 % 60)))
    end

    return v9
end

local function targets(p6, p7) -- line: 68
    return p7 or { p6.executor }
end

local function edit(p8, p9, p10) -- line: 72
    -- upvalues: claimed (copy)
    local t3 = {}

    for _, v14 in p9 or { p8.executor } do
        local v15, v16, v17 = p8.Service.Write(v14, p10)

        table.insert(t3, if not v15 then ("%*: %*"):format(v14.Name, v16) elseif v17 == nil then ("%*: %*"):format(v14.Name, v16) else ("%*: %* Hollow wins | prizes claimed: %*"):format(v14.Name, v17.Wins, (claimed(v17))))
    end

    return table.concat(t3, "\n")
end

v2("status", "Hollow progress and this server's Hollow races", {
    v3
}, function(p11, p12) -- line: 88
    -- upvalues: claimed (copy), raceLine (copy)
    local t4 = {
        (raceLine(p11))
    }

    for _, v19 in p12 or { p11.executor } do
        local v20 = p11.Service.Get(v19)

        table.insert(t4, if v20 == nil then ("%*: profile not loaded"):format(v19.Name) else ("%*: %* Hollow wins | prizes claimed: %*"):format(v19.Name, v20.Wins, (claimed(v20))))
    end

    return table.concat(t4, "\n")
end)
v2("wins", "Add Hollow wins; negative takes them away. Run prizes to pay what they reach", {
    Arg("integer", "amount", "Wins to add"),
    v3
}, function(p13, p14, p15) -- line: 106
    -- upvalues: edit (copy)
    return edit(p13, p15, function(p16) -- line: 107
        -- upvalues: p14 (copy)
        p16.Wins = math.max(p16.Wins + p14, 0)
    end)
end)
v2("prizes", "Pay every prize (and the badge) their Hollow wins have reached, like a win does", {
    v3
}, function(p17, p18) -- line: 116
    -- upvalues: claimed (copy)
    local t5 = {}

    for _, v23 in p18 or { p17.executor } do
        p17.Service.GrantPrizes(v23)

        local v24 = p17.Service.Get(v23)

        table.insert(t5, if v24 == nil then ("%*: profile not loaded"):format(v23.Name) else ("%*: %* Hollow wins | prizes claimed: %*"):format(v23.Name, v24.Wins, (claimed(v24))))
    end

    return table.concat(t5, "\n")
end)
v2("unclaim", "Mark a prize unclaimed so it pays again; rewards already given stay", {
    v4,
    v3
}, function(p19, p20, p21) -- line: 136
    -- upvalues: edit (copy)
    return edit(p19, p21, function(p22) -- line: 137
        -- upvalues: p20 (copy)
        if p20 == "all" then
            table.clear(p22.Claimed)
        else
            p22.Claimed[p20] = nil
        end
    end)
end)
v2("reset", "Wipe Hollow wins and claimed prizes back to a new player's; a badge already earned stays", {
    v3
}, function(p23, p24) -- line: 151
    -- upvalues: TheHollow2 (copy), edit (copy)
    return edit(p23, p24, function(p25) -- line: 152
        -- upvalues: TheHollow2 (copy)
        for v26, v27 in TheHollow2.Blank() do
            p25[v26] = v27
        end
    end)
end)
v2("start", "Open a Hollow race at the start line on this server now", {
    Arg("integer", "joinSeconds", "How long it waits for racers; default Game.TheHollow.JoinSeconds", true),
    Arg("integer", "laps", "Default Game.TheHollow.Laps", true),
    Arg("integer", "racers", "Bots fill the grid up to this many (1 = no bots); default Game.TheHollow.RacersWithBots", true)
}, function(p26, p27, p28, p29) -- line: 174
    if p27 ~= nil and (p27 < 5 or p27 > 600) then
        return (`joinSeconds must be {5}-{600}.`)
    end

    if p28 ~= nil and (p28 < 1 or p28 > 10) then
        return (`laps must be 1-{10}.`)
    end

    if p29 ~= nil and (p29 < 1 or p29 > 20) then
        return (`racers must be 1-{20}.`)
    end

    local _, v28 = p26.Service.StartRace(p27, p28, p29)

    return v28
end)
v2("stop", "End every Hollow race on this server and clear its queue", {}, function(p30) -- line: 190
    local v29 = p30.Service.StopRaces()

    if v29 > 0 then
        return (("Stopped %* Hollow race(s)."):format(v29))
    end

    return "No Hollow race is running on this server."
end)

return v1
