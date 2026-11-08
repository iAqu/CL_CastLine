-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("ServerScriptService")

local Minigames = require(ReplicatedStorage.Shared.Modules.Minigames)
local t1 = {
    "RecoveryEvent",
    "DemonicEvent",
    "Countdown",
    "DragonEggEvent",
    "CaptureTheEgg",
    "GreatBloom",
    "AdminAbuse",
    "MonsterEvent",
    "RiftEvent",
    "RiftOpen",
    "LightVsDarkness",
    "SammyEvent",
    "ScrambleBoss",
    "BeanstalkEvent",
    "ButterflyBloom",
    "TrainEvent",
    "RedLightGreenLight",
    "TrexRun",
    "RaceEvent",
    "RaceRally",
    "CursedIslandWars",
    "PumpkinBoss"
}
local t2 = {}

for _, v1 in t1 do
    if not Minigames.IsMinigame(v1) then
        table.insert(t2, v1)
    end
end

return function(p1) -- line: 38
    -- upvalues: t1 (copy), t2 (copy)
    p1:RegisterType("adminEventType", p1.Cmdr.Util.MakeEnumType("AdminEventType", t1))
    p1:RegisterType("adminStartEventType", p1.Cmdr.Util.MakeEnumType("AdminStartEventType", t2))
end
