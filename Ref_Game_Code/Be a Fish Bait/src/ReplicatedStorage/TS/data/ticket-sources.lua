-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TicketRain = 80,
    Fishing = 110,
    PinataBash = 110,
    ["Minigame:rgl"] = 60,
    ["Minigame:obby"] = 80,
    ["Minigame:catchSticks"] = 70,
    DailyLogin = 150
}
local t2 = {
    TicketRain = "Ticket Rain",
    Fishing = "Fishing",
    PinataBash = "Piñata Bash",
    ["Minigame:rgl"] = "Red Light Green Light",
    ["Minigame:obby"] = "Speed Run Obby",
    ["Minigame:catchSticks"] = "Catch Sticks",
    DailyLogin = "Daily Login"
}

return {
    ticketSourceDisplayName = function(p1) -- ticketSourceDisplayName | line: 36
        -- upvalues: t2 (copy)
        return t2[p1]
    end,
    formatCapResetCountdown = function(p2, p3) -- formatCapResetCountdown | line: 40
        local v2 = math.max(0, p2 - p3)

        return (("%*h %*m"):format(math.floor(v2 / 3600), (math.floor(v2 % 3600 / 60))))
    end,
    ticketSourceCaps = t1
}
