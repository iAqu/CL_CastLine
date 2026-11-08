-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CmdrToolkit = require(ReplicatedStorage.Shared.Utils.CmdrToolkit)
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local CursedIslandWarsFlags = require(ReplicatedStorage.Shared.Flags.CursedIslandWarsFlags)
local Arg = CmdrToolkit.Arg
local v1, v2 = CmdrToolkit.Manifest()
local t1 = {
    red = "Red",
    blue = "Blue"
}
local t2 = {
    mine = "Landmine",
    pad = "JumpPad"
}

local function words(p1) -- line: 23
    local t3 = {}

    for v3 in p1 do
        table.insert(t3, v3)
    end

    return t3
end

local v4 = Arg("players", "players", "Who; defaults to you", true)
local Enum = CmdrToolkit.Enum
local t4 = {}

for v5 in t1 do
    table.insert(t4, v5)
end

local v6 = Arg(Enum("islandTeam", t4, "team"), "team", "red or blue")
local Enum2 = CmdrToolkit.Enum
local t5 = {}

for v7 in t2 do
    table.insert(t5, v7)
end

local v8 = Arg(Enum2("islandPickup", t5, "pickup"), "pickup", "mine (landmine) or pad (jump pad)")
local v9 = Arg(CmdrToolkit.Enum("islandSwitch", { "on", "off" }, "setting"), "setting", "on or off")

local function clock(p2) -- line: 36
    local v11 = math.max(math.floor(p2), 0)

    return string.format("%dm %02ds", v11 // 60, v11 % 60)
end

local function onOff(p3) -- line: 41
    if p3 then
        return "on"
    end

    return "off"
end

v2("status", "Phase, clock, walls, crystals and both rosters", {}, function(p4) -- line: 45
    -- upvalues: Workspace (copy), CursedIslandWars (copy)
    local v12 = ("bots %*"):format(if p4.Service.BotsOn() then "on" else "off")
    local v13 = p4.Service.Current()

    if v13 == nil then
        return (("Cursed Island Wars isn't running on this server. (%*)"):format(v12))
    end

    local v14 = if v13.Winner then ", " .. v13.Winner .. " won" else ""
    local Phase = v13.Phase
    local v17 = math.max(math.floor(v13.PhaseEndsAt - Workspace:GetServerTimeNow()), 0)
    local t6 = {
        (("%*, %* left%* | %*"):format(Phase, string.format("%dm %02ds", v17 // 60, v17 % 60), v14, v12))
    }

    for _, v18 in CursedIslandWars.TeamIds do
        local v19 = v13.Barriers[v18]
        local v20 = v13.Crystals[v18]
        local t7 = {}

        for _, v21 in v13.Entries do
            if v21.Team == v18 then
                local v22 = v21.Player ~= nil and p4.Combat.Invincible[v21.Player] == true

                table.insert(t7, (("%*%* %* %*hp%*"):format(v21.Name, if v21.Player then "" else " (bot)", v21.State, v21.Health, if v22 then " god" else "")))
            end
        end

        table.insert(t6, ("%*: wall %*, crystal %*"):format(v18, if v19 then v19.Health else "-", if v20 then v20.Health else "-") .. (" | %*"):format((table.concat(t7, ", "))))
    end

    return table.concat(t6, "\n")
end)
v2("start", "Start the event on this server", { Arg(CmdrToolkit.Enum("islandIntro", { "skip" }, "option"), "intro", "skip: start without the intro cutscene", true) }, function(p5, p6) -- line: 78
    if p5.Service.Current() then
        return "Already running; `iw stop` first."
    end

    p5.Events.StartEvent("CursedIslandWars", 1800, {
        SkipCutscenes = p6 == "skip"
    })

    if p6 == "skip" then
        return "Started without the intro."
    end

    return "Started."
end)
v2("stop", "End the event on this server and send everyone home", {}, function(p7) -- line: 86
    if p7.Service.Current() == nil then
        return "Cursed Island Wars isn't running on this server."
    end

    p7.Events.StopEvent("CursedIslandWars")

    return "Stopped."
end)
v2("skip", "End the current phase now; in Sudden Death the tiebreak picks the winner", {}, function(p8) -- line: 94
    return p8.Service.Skip()
end)
v2("win", "End the fight now with this team winning", {
    v6
}, function(p9, p10) -- line: 98
    -- upvalues: t1 (copy)
    return p9.Service.Win(t1[p10])
end)
v2("bots", "Bots fill empty slots at the start and replace players who leave", {
    v9
}, function(p11, p12) -- line: 104
    local v25 = p12 == "on"

    p11.Service.SetBots(v25)

    return (("Bots %*; this applies from the next start and to players who leave."):format(if v25 then "on" else "off"))
end)
v2("god", "Immune to event damage, or vulnerable again", {
    v9,
    v4
}, function(p13, p14, p15) -- line: 113
    local v26 = p14 == "on"
    local t8 = {}

    for _, v27 in p15 or { p13.executor } do
        local Invincible = p13.Combat.Invincible

        if v26 then
            Invincible[v27] = true
        else
            Invincible[v27] = nil
        end

        table.insert(t8, v27.Name)
    end

    return (("God mode %*: %*"):format(if v26 then "on" else "off", (table.concat(t8, ", "))))
end)
v2("give", "Give pickup uses, past the carry cap", {
    v8,
    Arg("integer", "uses", "How many; default one pickup's worth", true),
    v4
}, function(p16, p17, p18, p19) -- line: 127
    -- upvalues: CursedIslandWarsFlags (copy), t2 (copy)
    local v28 = p16.Service.Current()

    if v28 == nil then
        return "Cursed Island Wars isn't running on this server."
    end

    local v29 = t2[p17]

    p18 = p18 or (if v29 == "Landmine" then CursedIslandWarsFlags.MinePickupUses:Get() else CursedIslandWarsFlags.PadPickupUses:Get())

    if p18 < 1 then
        return "uses must be at least 1."
    end

    local t9 = {}

    for _, v31 in p19 or { p16.executor } do
        local v32 = p16.Match.EntryForPlayer(v28, v31)

        if v32 ~= nil then
            local v34 = p16.Tools.Ammo(v32, v29)

            if p16.Tools.Grant(v28, v32, v29, p18, v34 + p18) then
                table.insert(t9, (("%*: %* x%*"):format(v31.Name, v29, (p16.Tools.Ammo(v32, v29)))))
            else
                table.insert(t9, (("%*: not alive"):format(v31.Name)))
            end
        else
            table.insert(t9, (("%*: not in the match"):format(v31.Name)))
        end
    end

    return table.concat(t9, "\n")
end)
v2("wall", "Lower a team's wall health; 0 breaks it", {
    v6,
    Arg("integer", "health", "New health")
}, function(p20, p21, p22) -- line: 157
    -- upvalues: t1 (copy)
    local v37 = p20.Service.Current()

    if v37 == nil then
        return "Cursed Island Wars isn't running on this server."
    end

    if not p20.Match.IsFighting(v37) then
        return "Only during the match or Sudden Death."
    end

    local v38 = t1[p21]
    local v39 = v37.Barriers[v38]

    if v39.Health <= p22 then
        return (("The %* wall is at %*; set it lower."):format(v38, v39.Health))
    end

    p20.Structures.DamageBarrier(v37, v38, v39.Health - math.max(p22, 0), v39.Hitbox.Position, nil)

    return (("%* wall now %*."):format(v38, v39.Health))
end)
v2("crystal", "Lower a team's crystal health, even behind its wall; 0 shatters it", {
    v6,
    Arg("integer", "health", "New health")
}, function(p23, p24, p25) -- line: 177
    -- upvalues: t1 (copy)
    local v40 = p23.Service.Current()

    if v40 == nil then
        return "Cursed Island Wars isn't running on this server."
    end

    if not p23.Match.IsFighting(v40) then
        return "Only during the match or Sudden Death."
    end

    local v41 = t1[p24]
    local v42 = v40.Crystals[v41]

    if v42.Health <= p25 then
        return (("The %* crystal is at %*; set it lower."):format(v41, v42.Health))
    end

    p23.Structures.DamageCrystal(v40, v41, v42.Health - math.max(p25, 0), nil)

    return (("%* crystal now %*."):format(v41, v42.Health))
end)

return v1
