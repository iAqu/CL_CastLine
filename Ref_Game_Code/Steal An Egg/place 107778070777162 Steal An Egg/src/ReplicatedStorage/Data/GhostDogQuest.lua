-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Stage = table.freeze({
        NotMet = 0,
        Collecting = 1,
        Reunion = 2,
        HasRod = 3,
        Done = 4
    }),
    DogName = "Echo",
    FishermanName = "Ghost Fisherman",
    RodName = "Haunted Rod",
    TicketName = "Train Pass",
    RewardTitle = "TRAIN PASS UNLOCKED!",
    RewardSubtitle = "You can now board the Phantom Express whenever it appears.",
    TicketImage = "rbxassetid://106321524065478",
    FolderName = "GhostDogQuest",
    MarkersName = "Markers",
    RodAttribute = "GhostDogRod",
    ChaseAttribute = "GhostDogChase",
    PhaseAttribute = "GhostDogPhase",
    TalkDistance = 12,
    PickupDistance = 9,
    CastDistance = 8,
    Artifacts = table.freeze({
        table.freeze({
            Id = "Collar",
            DisplayName = "Old Collar",
            Model = "OldCollar_Studs",
            Marker = "Artifact_Collar",
            Hint = "I used to watch the trains at the old station...",
            Found = "My collar! I remember the jingle!"
        }),
        table.freeze({
            Id = "Bone",
            DisplayName = "Chewed Bone",
            Model = "ChewedBone_Studs",
            Marker = "Artifact_Bone",
            Hint = "I buried something in the swampy marsh... probably!",
            Found = "My bone! Still tastes like home."
        }),
        table.freeze({
            Id = "Toy",
            DisplayName = "Favourite Toy",
            Model = "FavouriteToy_Studs",
            Marker = "Artifact_Toy",
            Hint = "I was playing by the big pumpkin altar... I dropped something there.",
            Found = "Mr. Squeaky! I missed you!"
        }),
        table.freeze({
            Id = "Photo",
            DisplayName = "Old Photograph",
            Model = "OldPhotograph_Studs",
            Marker = "Artifact_Photo",
            Hint = "Those glowing crystals by the manor gate... something shiny was there.",
            Found = "That's me... and someone with a fishing rod?"
        })
    }),
    Lines = table.freeze({
        DogFirst = table.freeze({ "*whimper* Huh? You can see me?", "I can't remember anything... not even where my owner went.", "My memories got scattered all over this place.", "If you find them, maybe I'll remember! Please?" }),
        DogWaiting = table.freeze({ "You found {found}! Just {left} more to go!" }),
        DogRemembers = table.freeze({ "My collar... my bone... Mr. Squeaky... the photo!", "I remember now! My owner fishes at the old pier!", "Follow me! Woof!" }),
        DogHappy = table.freeze({ "*happy wag* Thank you for bringing me home!" }),
        FisherIdle = table.freeze({ "Shh... the fish under this pier are restless tonight.", "I lost my best friend a long time ago. A little ghost pup named Echo..." }),
        FisherReunion = table.freeze({ "Echo?! Is that really you?!", "You brought him home. Thank you, friend!", "Here, I conjured you a Haunted Rod of your own. You earned it!", "Cast it off the end of the pier, at the glowing ripples.", "And hold on tight. Something BIG lives down there!" }),
        FisherHint = table.freeze({ "Cast at the glowing ripples off the end of the pier.", "And hold on tight!" }),
        FisherAfter = table.freeze({ "Keep that pass safe. The Phantom Express could come any night!" }),
        Rescue = table.freeze({ "Whoa! What's that you found?", "A Train Pass?! The ghost train is REAL?!", "Take it to the old station when the train comes!" })
    }),
    Captions = table.freeze({
        Rescue = "HOLD ON! I've got you!",
        Ticket = "TRAIN PASS",
        AfterQuest = "Find the Phantom Express at the old station"
    }),
    Objectives = table.freeze({
        Collecting = "Find the dog's lost things",
        Return = "Bring them to Echo!",
        Follow = "Follow Echo!",
        Reunion = "Talk to the Ghost Fisherman",
        Cast = "Cast at the glowing ripples!"
    }),
    Chase = table.freeze({
        Center = Vector3.new(-6000, 1400, -6000),
        Radius = 960,
        SlotCount = 6,
        SlotDepth = 140,
        StartAngle = 3.490658503988659,
        Lanes = 3,
        LaneSpacing = 9,
        WaveHeight = 5,
        WaveLength = 170,
        RiderLift = 0
    }),
    Sounds = table.freeze({
        Splash = "rbxasset://sounds/impact_water.mp3",
        Swim = "rbxasset://sounds/action_swim.mp3",
        PulledUnder = "rbxassetid://71367247595167",
        Surfaced = "rbxassetid://114905457965260",
        GrowlLong = "rbxassetid://102163247789915",
        GrowlShort = "rbxassetid://99846927830206",
        CountdownTick = "rbxassetid://122458334422848",
        CountdownGo = "rbxassetid://122070283098235",
        UnderwaterDrone = "rbxassetid://88133289595143",
        FishTurn = "rbxassetid://130483295530337",
        LineSnap = "rbxassetid://115396020785351",
        LineTug = table.freeze({ "rbxassetid://126878217889318", "rbxassetid://121739776996455", "rbxassetid://70402933991549" }),
        Nibble = table.freeze({ "rbxassetid://138369829515190", "rbxassetid://112028362877350" })
    })
}

function t1.Artifact(p1) -- line: 186
    -- upvalues: t1 (copy)
    for _, v1 in t1.Artifacts do
        if v1.Id == p1 then
            return v1
        end
    end

    return nil
end

function t1.ChaseFrame(p2, p3) -- line: 195
    -- upvalues: t1 (copy)
    local Chase = t1.Chase
    local v2 = Chase.StartAngle + p3 / Chase.Radius
    local v3 = p2 * Chase.SlotDepth
    local v5 = math.sin(p3 / Chase.WaveLength * 6.283185307179586) * Chase.WaveHeight
    local v9 = Chase.Center + Vector3.new(math.cos(v2) * Chase.Radius, v5 - v3, math.sin(v2) * Chase.Radius)
    local v10 = v2 + 1 / Chase.Radius
    local v15 = Chase.Center + Vector3.new(math.cos(v10) * Chase.Radius, math.sin((p3 + 1) / Chase.WaveLength * 6.283185307179586) * Chase.WaveHeight - v3, math.sin(v10) * Chase.Radius)

    return CFrame.lookAt(v9, v15, (Vector3.new(0, 1, 0)))
end

function t1.LaneOffset(p4) -- line: 212
    -- upvalues: t1 (copy)
    return p4 * t1.Chase.LaneSpacing
end

return table.freeze(t1)
