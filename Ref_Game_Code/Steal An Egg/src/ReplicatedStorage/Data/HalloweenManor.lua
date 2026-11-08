-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Tags = {
        Gate = "HalloweenManorGate",
        Portal = "HalloweenManorPortal"
    },
    GearId = "Manor Key",
    RewardTitle = "MANOR KEY CLAIMED!",
    Notices = {
        Locked = "The manor door is chained shut. Fish up the Manor Key!",
        Unlocked = "The Manor Key turns... the chains give way!",
        GateSealed = "The manor gate is sealed. It opens in %s.",
        GateSealedNow = "The manor gate is sealed.",
        GateOpened = "The manor gate grinds open!",
        GateClosed = "The manor gate slams shut!",
        Quiet = "The manor is quiet for now.",
        Closed = "The portal opens in %s.",
        Defeated = "The defeated Pumpkin King will return in %s...",
        ScheduleOff = "The portal is sealed."
    },
    Sign = {
        Locked = "GATE LOCKED",
        Open = "THE PORTAL IS OPEN",
        Countdown = "PORTAL OPENS IN %02d:%02d",
        GateCountdown = "GATE OPENS IN %s",
        GateOpen = "THE GATE IS OPEN"
    },
    BossPortal = {
        Title = "PUMPKIN KING",
        Countdown = "OPENS IN %s",
        Returns = "RETURNS IN %s",
        Open = "OPEN NOW",
        Closes = "CLOSES IN %s",
        GateCountdown = "GATE OPENS IN %s",
        GateLocked = "GATE LOCKED",
        ScheduleOff = "PORTAL SEALED"
    }
}

return table.freeze(t1)
