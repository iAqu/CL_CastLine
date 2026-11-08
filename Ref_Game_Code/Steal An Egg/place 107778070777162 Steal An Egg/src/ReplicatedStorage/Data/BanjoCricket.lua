-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Tags = {
        Mushroom = "BanjoCricketMushroom",
        Roots = "BanjoCricketRoots",
        Door = "BanjoCricketDoor",
        Npc = "BanjoCricketNpc",
        Performer = "BanjoCricketPerformer",
        Music = "BanjoCricketMusic",
        Bridge = "BanjoCricketBridge",
        Doorway = "BanjoCricketDoorway",
        Gate = "BanjoCricketGate"
    },
    Attributes = {
        MushroomIndex = "MushroomIndex",
        RevealOffset = "RevealOffset",
        DoorOpenAngle = "DoorOpenAngleDegrees"
    },
    InteractionPoint = "InteractionPoint",
    NpcDisplayName = "Jitterbug",
    GearId = "Cricket's Banjo",
    DreamTransition = "BanjoDream",
    PerformerAnimations = {
        BanjoCricket = "rbxassetid://77041701511026",
        DrumBeetle = "rbxassetid://71486259242774",
        TrumpetFirefly = "rbxassetid://102990240844170",
        DoubleBassBeetle = "rbxassetid://118987047686433",
        Atavi = "rbxassetid://122725193792592",
        KinqAndi = "rbxassetid://77126402764308",
        Scrufus = "rbxassetid://99077049042591",
        Thernus = "rbxassetid://138100631757228",
        UmarFrxst = "rbxassetid://76597002689844"
    },
    TalkDistance = 10,
    MaxStages = 10,
    RewardTitle = "SECRET DISCOVERED!",
    Mushrooms = {
        {
            Sound = "rbxassetid://95819607166252",
            Speed = 1,
            Color = Color3.fromRGB(170, 85, 255)
        },
        {
            Sound = "rbxassetid://105687787264838",
            Speed = 1,
            Color = Color3.fromRGB(60, 150, 255)
        },
        {
            Sound = "rbxassetid://74952438377377",
            Speed = 1,
            Color = Color3.fromRGB(255, 70, 70)
        },
        {
            Sound = "rbxassetid://116577555120519",
            Speed = 1,
            Color = Color3.fromRGB(80, 210, 90)
        },
        {
            Sound = "rbxassetid://86170149701983",
            Speed = 1,
            Color = Color3.fromRGB(255, 200, 50)
        }
    },
    Timing = {
        StartPause = 1,
        Note = 0.45,
        NoteGap = 0.2,
        StagePause = 1.6,
        WrongPause = 1.8,
        ListenTimeout = 20
    },
    Reveal = {
        LightsAt = 0.5,
        HarmonyAt = 1,
        MusicAt = 2,
        RootsAt = 2.5,
        RootsSeconds = 0.5,
        DoorAt = 4,
        DoorSeconds = 1.2,
        LightsOffAt = 5
    },
    Sounds = {
        Creak = "rbxassetid://9125407239",
        Fail = "rbxassetid://137877663954529",
        Band = "rbxassetid://73987573231214",
        BanjoLoop = "rbxassetid://121515559450531"
    },
    Textures = {
        Spore = "rbxasset://textures/particles/sparkles_main.dds",
        Note = "rbxassetid://243331916"
    },
    Volume = {
        Note = 0.8,
        Muted = 0.35,
        Soft = 0.4,
        Fail = 0.7,
        Strum = 0.45,
        Creak = 0.6,
        BandFaint = 0.12,
        Band = 0.5,
        BanjoLoop = 0.6
    },
    Lines = {
        Reward = { "Well, howdy! Nobody's found our little hideout in ages.", "Those mushrooms only sing for folks with a real ear for music.", "Every band needs a new member... here, take these!" },
        Encore = { "Back for an encore? The band never stops playing!" }
    }
}

function t1.PlaybackSeconds(p1) -- line: 149
    -- upvalues: t1 (copy)
    local Timing = t1.Timing

    return p1 * Timing.Note + math.max(p1 - 1, 0) * Timing.NoteGap
end

return table.freeze(t1)
