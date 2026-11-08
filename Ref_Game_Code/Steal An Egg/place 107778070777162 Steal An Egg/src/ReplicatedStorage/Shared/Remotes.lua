-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networking = require(ReplicatedStorage.Packages.Networking)

local function scope(p1, p2) -- line: 88
    -- upvalues: Networking (copy)
    Networking.namespace({
        env = "all",
        name = p1
    })

    return p2()
end

local t1 = {}

local function v1() -- line: 94
    -- upvalues: Networking (copy)
    return {
        DeviceType = Networking.remoteEvent("DeviceType")
    }
end

Networking.namespace({
    name = "UserGenerated",
    env = "all"
})
t1.UserGenerated = {
    DeviceType = Networking.remoteEvent("DeviceType")
}

v1 = function() -- line: 99
    -- upvalues: Networking (copy)
    return {
        Action = Networking.remoteFunction("Action"),
        Suction = Networking.remoteEvent("Suction"),
        CaptureState = Networking.remoteEvent("CaptureState"),
        Ghosts = Networking.remoteEvent("Ghosts"),
        Travel = Networking.remoteEvent("Travel"),
        TravelReady = Networking.remoteEvent("TravelReady"),
        State = Networking.remoteEvent("State")
    }
end

Networking.namespace({
    name = "TrainEvent",
    env = "all"
})
t1.TrainEvent = v1()

v1 = function() -- line: 110
    -- upvalues: Networking (copy)
    return {
        Suction = Networking.remoteEvent("Suction"),
        Defeated = Networking.remoteEvent("Defeated")
    }
end

Networking.namespace({
    name = "GhostBoss",
    env = "all"
})
t1.GhostBoss = {
    Suction = Networking.remoteEvent("Suction"),
    Defeated = Networking.remoteEvent("Defeated")
}

v1 = function() -- line: 116
    -- upvalues: Networking (copy)
    return {
        Drones = Networking.remoteEvent("Drones"),
        Request = Networking.remoteFunction("Request"),
        Collect = Networking.remoteEvent("Collect"),
        State = Networking.remoteEvent("State"),
        Drops = Networking.remoteEvent("Drops"),
        RemoveDrops = Networking.remoteEvent("RemoveDrops"),
        Effect = Networking.remoteEvent("Effect")
    }
end

Networking.namespace({
    name = "Scramble",
    env = "all"
})
t1.Scramble = v1()

v1 = function() -- line: 127
    -- upvalues: Networking (copy)
    return {
        AskDoff = Networking.remoteFunction("AskDoff"),
        AskLiveSnapshot = Networking.remoteFunction("AskLiveSnapshot"),
        AskSale = Networking.remoteFunction("AskSale"),
        AskWear = Networking.remoteFunction("AskWear"),
        AskWearLimit = Networking.remoteFunction("AskWearLimit"),
        CoinsGathered = Networking.remoteEvent("CoinsGathered"),
        ConfirmEquipBestBadge = Networking.remoteFunction("ConfirmEquipBestBadge"),
        ConfirmPetsBadge = Networking.remoteFunction("ConfirmPetsBadge"),
        OwnerDropped = Networking.remoteEvent("OwnerDropped"),
        OwnerShifted = Networking.remoteEvent("OwnerShifted")
    }
end

Networking.namespace({
    name = "PenRoster",
    env = "all"
})
t1.PenRoster = v1()

v1 = function() -- line: 141
    -- upvalues: Networking (copy)
    return {
        Began = Networking.remoteEvent("Began"),
        Ended = Networking.remoteEvent("Ended"),
        FetchCatalogue = Networking.remoteFunction("FetchCatalogue"),
        FetchRecurringEta = Networking.remoteFunction("FetchRecurringEta"),
        FetchRunning = Networking.remoteFunction("FetchRunning"),
        FetchScheduled = Networking.remoteFunction("FetchScheduled")
    }
end

Networking.namespace({
    name = "LiveEvents",
    env = "all"
})
t1.LiveEvents = v1()

v1 = function() -- line: 151
    -- upvalues: Networking (copy)
    return {
        AskClaimMilestone = Networking.remoteEvent("AskClaimMilestone"),
        AskCollectPowerUp = Networking.remoteEvent("AskCollectPowerUp"),
        AskCollectRing = Networking.remoteEvent("AskCollectRing"),
        AskSelectTeam = Networking.remoteEvent("AskSelectTeam"),
        FetchPowerUps = Networking.remoteFunction("FetchPowerUps"),
        FetchRings = Networking.remoteFunction("FetchRings"),
        FetchScore = Networking.remoteFunction("FetchScore"),
        PowerUpCollected = Networking.remoteEvent("PowerUpCollected"),
        PowerUpsCleared = Networking.remoteEvent("PowerUpsCleared"),
        PowerUpsDropped = Networking.remoteEvent("PowerUpsDropped"),
        PowerUpsSky = Networking.remoteEvent("PowerUpsSky"),
        RingCollected = Networking.remoteEvent("RingCollected"),
        RingRespawned = Networking.remoteEvent("RingRespawned"),
        RingsCleared = Networking.remoteEvent("RingsCleared"),
        RingsSpawned = Networking.remoteEvent("RingsSpawned"),
        ScoreChanged = Networking.remoteEvent("ScoreChanged"),
        Struck = Networking.remoteEvent("Struck")
    }
end

Networking.namespace({
    name = "LightVsDarkness",
    env = "all"
})
t1.LightVsDarkness = v1()

v1 = function() -- line: 172
    -- upvalues: Networking (copy)
    return {
        AskCollectPickup = Networking.remoteEvent("AskCollectPickup"),
        FetchPickups = Networking.remoteFunction("FetchPickups"),
        PickupCollected = Networking.remoteEvent("PickupCollected"),
        PickupRespawned = Networking.remoteEvent("PickupRespawned"),
        PickupsCleared = Networking.remoteEvent("PickupsCleared"),
        PickupsSpawned = Networking.remoteEvent("PickupsSpawned"),
        BomberRow = Networking.remoteEvent("BomberRow"),
        ElephantCharge = Networking.remoteEvent("ElephantCharge")
    }
end

Networking.namespace({
    name = "SammyEvent",
    env = "all"
})
t1.SammyEvent = v1()

v1 = function() -- line: 184
    -- upvalues: Networking (copy)
    return {
        AskCatchFirefly = Networking.remoteEvent("AskCatchFirefly"),
        AskPour = Networking.remoteEvent("AskPour"),
        AskFinishFlight = Networking.remoteEvent("AskFinishFlight"),
        AskStealEgg = Networking.remoteEvent("AskStealEgg"),
        AskFinishEscape = Networking.remoteEvent("AskFinishEscape"),
        AskSlideCrash = Networking.remoteEvent("AskSlideCrash"),
        AskClaimReward = Networking.remoteEvent("AskClaimReward"),
        AskLaunch = Networking.remoteEvent("AskLaunch"),
        AskStartTimer = Networking.remoteEvent("AskStartTimer")
    }
end

Networking.namespace({
    name = "BeanstalkEvent",
    env = "all"
})
t1.BeanstalkEvent = v1()

v1 = function() -- line: 198
    -- upvalues: Networking (copy)
    return {
        AskLeave = Networking.remoteEvent("AskLeave"),
        OutroFinished = Networking.remoteEvent("OutroFinished"),
        PowerUp = Networking.remoteEvent("PowerUp"),
        PowerUpMoment = Networking.remoteEvent("PowerUpMoment")
    }
end

Networking.namespace({
    name = "MountRace",
    env = "all"
})
t1.MountRace = v1()

v1 = function() -- line: 208
    -- upvalues: Networking (copy)
    return {
        AskBuyEgg = Networking.remoteFunction("AskBuyEgg"),
        AskDropEgg = Networking.remoteFunction("AskDropEgg"),
        AskCarryEgg = Networking.remoteFunction("AskCarryEgg"),
        AskTutorialSeen = Networking.remoteFunction("AskTutorialSeen"),
        AskClaimMastery = Networking.remoteFunction("AskClaimMastery"),
        AskClaimHorseman = Networking.remoteFunction("AskClaimHorseman"),
        MonsterHit = Networking.remoteEvent("MonsterHit")
    }
end

Networking.namespace({
    name = "HalloweenDimension",
    env = "all"
})
t1.HalloweenDimension = v1()

v1 = function() -- line: 222
    -- upvalues: Networking (copy)
    return {
        FlashUserId = Networking.remoteEvent("FlashUserId"),
        RaiseNotice = Networking.remoteEvent("RaiseNotice")
    }
end

Networking.namespace({
    name = "Broadcasts",
    env = "all"
})
t1.Broadcasts = {
    FlashUserId = Networking.remoteEvent("FlashUserId"),
    RaiseNotice = Networking.remoteEvent("RaiseNotice")
}

v1 = function() -- line: 228
    -- upvalues: Networking (copy)
    return {
        GrantSelfEgg = Networking.remoteEvent("GrantSelfEgg"),
        GrantSelfPet = Networking.remoteEvent("GrantSelfPet"),
        GrantVerdict = Networking.remoteEvent("GrantVerdict"),
        ProbeStaffStatus = Networking.remoteEvent("ProbeStaffStatus"),
        SpeedPowerVerdict = Networking.remoteEvent("SpeedPowerVerdict"),
        StaffVerdict = Networking.remoteEvent("StaffVerdict"),
        WipeSelfProfile = Networking.remoteEvent("WipeSelfProfile"),
        WipeVerdict = Networking.remoteEvent("WipeVerdict"),
        WriteSpeedPower = Networking.remoteEvent("WriteSpeedPower"),
        WriteWalkSpeed = Networking.remoteEvent("WriteWalkSpeed")
    }
end

Networking.namespace({
    name = "StaffConsole",
    env = "all"
})
t1.StaffConsole = v1()

v1 = function() -- line: 242
    -- upvalues: Networking (copy)
    return {
        AskIdleHopFlush = Networking.remoteFunction("AskIdleHopFlush"),
        SubmitIdleHop = Networking.remoteFunction("SubmitIdleHop"),
        SubmitIdleState = Networking.remoteEvent("SubmitIdleState")
    }
end

Networking.namespace({
    name = "Telemetry",
    env = "all"
})
t1.Telemetry = v1()

v1 = function() -- line: 249
    -- upvalues: Networking (copy)
    return {
        SellEveryPet = Networking.remoteEvent("SellEveryPet"),
        SellSelection = Networking.remoteEvent("SellSelection"),
        SellPet = Networking.remoteEvent("SellPet"),
        WriteFavourite = Networking.remoteEvent("WriteFavourite")
    }
end

Networking.namespace({
    name = "PetSatchel",
    env = "all"
})
t1.PetSatchel = v1()

v1 = function() -- line: 257
    -- upvalues: Networking (copy)
    return {
        EmitSound = Networking.remoteEvent("EmitSound")
    }
end

Networking.namespace({
    name = "SoundBus",
    env = "all"
})
t1.SoundBus = {
    EmitSound = Networking.remoteEvent("EmitSound")
}

v1 = function() -- line: 262
    -- upvalues: Networking (copy)
    return {
        FetchAutoSell = Networking.remoteFunction("FetchAutoSell"),
        FetchWearBestStatus = Networking.remoteFunction("FetchWearBestStatus"),
        OfferFullSatchelSale = Networking.remoteFunction("OfferFullSatchelSale"),
        WearBest = Networking.remoteFunction("WearBest"),
        WriteAutoSell = Networking.remoteFunction("WriteAutoSell")
    }
end

Networking.namespace({
    name = "Haul",
    env = "all"
})
t1.Haul = v1()

v1 = function() -- line: 271
    -- upvalues: Networking (copy)
    return {
        Trigger = Networking.remoteEvent("Trigger")
    }
end

Networking.namespace({
    name = "BatSwing",
    env = "all"
})
t1.BatSwing = {
    Trigger = Networking.remoteEvent("Trigger")
}

v1 = function() -- line: 276
    -- upvalues: Networking (copy)
    return {
        AskSwap = Networking.remoteEvent("AskSwap"),
        EmitFx = Networking.remoteEvent("EmitFx"),
        EmitSfx = Networking.remoteEvent("EmitSfx")
    }
end

Networking.namespace({
    name = "SwapGadget",
    env = "all"
})
t1.SwapGadget = v1()

v1 = function() -- line: 283
    -- upvalues: Networking (copy)
    return {
        AskDance = Networking.remoteEvent("AskDance"),
        AttachEffect = Networking.remoteEvent("AttachEffect"),
        DetachEffect = Networking.remoteEvent("DetachEffect"),
        EmitSfx = Networking.remoteEvent("EmitSfx")
    }
end

Networking.namespace({
    name = "DanceGadget",
    env = "all"
})
t1.DanceGadget = v1()

v1 = function() -- line: 291
    -- upvalues: Networking (copy)
    return {
        Post = Networking.remoteEvent("Post")
    }
end

Networking.namespace({
    name = "ChatFeed",
    env = "all"
})
t1.ChatFeed = {
    Post = Networking.remoteEvent("Post")
}

v1 = function() -- line: 296
    -- upvalues: Networking (copy)
    return {
        AskRigWipe = Networking.remoteEvent("AskRigWipe"),
        CorrectionBegan = Networking.remoteEvent("CorrectionBegan"),
        Primed = Networking.remoteEvent("Primed"),
        ProbeSatchel = Networking.remoteEvent("ProbeSatchel"),
        Reconcile = Networking.remoteFunction("Reconcile"),
        Refresh = Networking.remoteEvent("Refresh"),
        SeedSatchel = Networking.remoteEvent("SeedSatchel")
    }
end

Networking.namespace({
    name = "RigSync",
    env = "all"
})
t1.RigSync = v1()

v1 = function() -- line: 307
    -- upvalues: Networking (copy)
    return {
        Line = Networking.remoteEvent("Line")
    }
end

Networking.namespace({
    name = "Toasts",
    env = "all"
})
t1.Toasts = {
    Line = Networking.remoteEvent("Line")
}

v1 = function() -- line: 312
    -- upvalues: Networking (copy)
    return {
        Shower = Networking.remoteEvent("Shower")
    }
end

Networking.namespace({
    name = "Payouts",
    env = "all"
})
t1.Payouts = {
    Shower = Networking.remoteEvent("Shower")
}

v1 = function() -- line: 317
    -- upvalues: Networking (copy)
    return {
        AskDoffTool = Networking.remoteFunction("AskDoffTool"),
        AskEggRecord = Networking.remoteFunction("AskEggRecord"),
        AskFieldEggCarry = Networking.remoteFunction("AskFieldEggCarry"),
        AskFieldEggDrop = Networking.remoteFunction("AskFieldEggDrop"),
        AskFieldEggRarityShows = Networking.remoteFunction("AskFieldEggRarityShows"),
        AskFieldEggSnapshot = Networking.remoteFunction("AskFieldEggSnapshot"),
        AskFinishHatch = Networking.remoteFunction("AskFinishHatch"),
        AskHatch = Networking.remoteFunction("AskHatch"),
        AskLiveSnapshot = Networking.remoteFunction("AskLiveSnapshot"),
        AskPlaceEgg = Networking.remoteFunction("AskPlaceEgg"),
        AskSkipGrowth = Networking.remoteFunction("AskSkipGrowth"),
        AskWearTool = Networking.remoteFunction("AskWearTool"),
        FieldEggBatchShifted = Networking.remoteEvent("FieldEggBatchShifted"),
        FieldEggCarry = Networking.remoteEvent("FieldEggCarry"),
        FieldEggCycleCountdown = Networking.remoteEvent("FieldEggCycleCountdown"),
        FieldEggGone = Networking.remoteEvent("FieldEggGone"),
        FieldEggRaritiesShown = Networking.remoteEvent("FieldEggRaritiesShown"),
        FieldEggRedeemVerdict = Networking.remoteEvent("FieldEggRedeemVerdict"),
        FieldEggShifted = Networking.remoteEvent("FieldEggShifted"),
        OwnerDropped = Networking.remoteEvent("OwnerDropped"),
        OwnerShifted = Networking.remoteEvent("OwnerShifted")
    }
end

Networking.namespace({
    name = "EggWorld",
    env = "all"
})
t1.EggWorld = v1()

v1 = function() -- line: 342
    -- upvalues: Networking (copy)
    return {
        CutsceneBegan = Networking.remoteEvent("CutsceneBegan"),
        StandingsRefreshed = Networking.remoteEvent("StandingsRefreshed")
    }
end

Networking.namespace({
    name = "EggCapture",
    env = "all"
})
t1.EggCapture = {
    CutsceneBegan = Networking.remoteEvent("CutsceneBegan"),
    StandingsRefreshed = Networking.remoteEvent("StandingsRefreshed")
}

v1 = function() -- line: 348
    -- upvalues: Networking (copy)
    return {
        Caught = Networking.remoteEvent("Caught"),
        Cover = Networking.remoteEvent("Cover")
    }
end

Networking.namespace({
    name = "RedLightGreenLight",
    env = "all"
})
t1.RedLightGreenLight = {
    Caught = Networking.remoteEvent("Caught"),
    Cover = Networking.remoteEvent("Cover")
}

v1 = function() -- line: 354
    -- upvalues: Networking (copy)
    return {
        FetchHerd = Networking.remoteFunction("FetchHerd"),
        Herd = Networking.remoteEvent("Herd"),
        Trampled = Networking.remoteEvent("Trampled"),
        Wave = Networking.remoteEvent("Wave")
    }
end

Networking.namespace({
    name = "TrexRun",
    env = "all"
})
t1.TrexRun = v1()

v1 = function() -- line: 362
    -- upvalues: Networking (copy)
    return {
        AskRescueHop = Networking.remoteEvent("AskRescueHop"),
        SubmitIdleFlag = Networking.remoteEvent("SubmitIdleFlag")
    }
end

Networking.namespace({
    name = "IdleRescue",
    env = "all"
})
t1.IdleRescue = {
    AskRescueHop = Networking.remoteEvent("AskRescueHop"),
    SubmitIdleFlag = Networking.remoteEvent("SubmitIdleFlag")
}

v1 = function() -- line: 368
    -- upvalues: Networking (copy)
    return {
        AskChestClaim = Networking.remoteFunction("AskChestClaim"),
        AskChestRevealComplete = Networking.remoteFunction("AskChestRevealComplete"),
        AskChestTake = Networking.remoteFunction("AskChestTake"),
        AskFeed = Networking.remoteFunction("AskFeed"),
        AskFullChargeReset = Networking.remoteEvent("AskFullChargeReset"),
        AskGrowthSwap = Networking.remoteEvent("AskGrowthSwap"),
        AskSnapshot = Networking.remoteFunction("AskSnapshot"),
        ChestOpened = Networking.remoteEvent("ChestOpened"),
        EventStateShifted = Networking.remoteEvent("EventStateShifted"),
        FeedSettled = Networking.remoteEvent("FeedSettled"),
        StateShifted = Networking.remoteEvent("StateShifted")
    }
end

Networking.namespace({
    name = "MonsterParasite",
    env = "all"
})
t1.MonsterParasite = v1()

v1 = function() -- line: 383
    -- upvalues: Networking (copy)
    return {
        FetchState = Networking.remoteFunction("FetchState"),
        FlagSeen = Networking.remoteFunction("FlagSeen")
    }
end

Networking.namespace({
    name = "SeasonBanner",
    env = "all"
})
t1.SeasonBanner = {
    FetchState = Networking.remoteFunction("FetchState"),
    FlagSeen = Networking.remoteFunction("FlagSeen")
}

v1 = function() -- line: 389
    -- upvalues: Networking (copy)
    return {
        FetchSeen = Networking.remoteFunction("FetchSeen"),
        FlagSeen = Networking.remoteFunction("FlagSeen"),
        Replay = Networking.remoteEvent("Replay")
    }
end

Networking.namespace({
    name = "ConcertReveal",
    env = "all"
})
t1.ConcertReveal = v1()

v1 = function() -- line: 396
    -- upvalues: Networking (copy)
    return {
        FetchState = Networking.remoteFunction("FetchState"),
        FlagSeen = Networking.remoteFunction("FlagSeen")
    }
end

Networking.namespace({
    name = "ShopCta",
    env = "all"
})
t1.ShopCta = {
    FetchState = Networking.remoteFunction("FetchState"),
    FlagSeen = Networking.remoteFunction("FlagSeen")
}

v1 = function() -- line: 402
    -- upvalues: Networking (copy)
    return {
        Fetch = Networking.remoteFunction("Fetch"),
        Refresh = Networking.remoteEvent("Refresh")
    }
end

Networking.namespace({
    name = "Trials",
    env = "all"
})
t1.Trials = {
    Fetch = Networking.remoteFunction("Fetch"),
    Refresh = Networking.remoteEvent("Refresh")
}

v1 = function() -- line: 408
    -- upvalues: Networking (copy)
    return {
        PortalTransition = Networking.remoteEvent("PortalTransition")
    }
end

Networking.namespace({
    name = "FuseBiome",
    env = "all"
})
t1.FuseBiome = {
    PortalTransition = Networking.remoteEvent("PortalTransition")
}

v1 = function() -- line: 413
    -- upvalues: Networking (copy)
    return {
        BeginFuse = Networking.remoteFunction("BeginFuse"),
        ConfirmBriefing = Networking.remoteFunction("ConfirmBriefing"),
        EjectPet = Networking.remoteFunction("EjectPet"),
        FinishReveal = Networking.remoteFunction("FinishReveal"),
        LoadPet = Networking.remoteFunction("LoadPet")
    }
end

Networking.namespace({
    name = "Fusery",
    env = "all"
})
t1.Fusery = v1()

v1 = function() -- line: 422
    -- upvalues: Networking (copy)
    return {
        Awarded = Networking.remoteEvent("Awarded")
    }
end

Networking.namespace({
    name = "PassGrants",
    env = "all"
})
t1.PassGrants = {
    Awarded = Networking.remoteEvent("Awarded")
}

v1 = function() -- line: 427
    -- upvalues: Networking (copy)
    return {
        Gained = Networking.remoteEvent("Gained"),
        Lost = Networking.remoteEvent("Lost")
    }
end

Networking.namespace({
    name = "GearSatchel",
    env = "all"
})
t1.GearSatchel = {
    Gained = Networking.remoteEvent("Gained"),
    Lost = Networking.remoteEvent("Lost")
}

v1 = function() -- line: 433
    -- upvalues: Networking (copy)
    return {
        RedeemPerk = Networking.remoteFunction("RedeemPerk")
    }
end

Networking.namespace({
    name = "GroupPerk",
    env = "all"
})
t1.GroupPerk = {
    RedeemPerk = Networking.remoteFunction("RedeemPerk")
}

v1 = function() -- line: 438
    -- upvalues: Networking (copy)
    return {
        AskLiveState = Networking.remoteFunction("AskLiveState"),
        AskProgressSync = Networking.remoteFunction("AskProgressSync"),
        LiveStateShifted = Networking.remoteEvent("LiveStateShifted")
    }
end

Networking.namespace({
    name = "GuardOnboarding",
    env = "all"
})
t1.GuardOnboarding = v1()

v1 = function() -- line: 445
    -- upvalues: Networking (copy)
    return {
        AskEnabled = Networking.remoteFunction("AskEnabled"),
        EnabledShifted = Networking.remoteEvent("EnabledShifted"),
        ForestHandoff = Networking.remoteEvent("ForestHandoff"),
        ForestStrike = Networking.remoteEvent("ForestStrike"),
        Rouse = Networking.remoteEvent("Rouse"),
        SpeedTollOffer = Networking.remoteEvent("SpeedTollOffer"),
        SpeedTollWarning = Networking.remoteEvent("SpeedTollWarning")
    }
end

Networking.namespace({
    name = "GuardPatrol",
    env = "all"
})
t1.GuardPatrol = v1()

v1 = function() -- line: 456
    -- upvalues: Networking (copy)
    return {
        AskDischarge = Networking.remoteEvent("AskDischarge"),
        DropCaster = Networking.remoteEvent("DropCaster")
    }
end

Networking.namespace({
    name = "GunGadget",
    env = "all"
})
t1.GunGadget = {
    AskDischarge = Networking.remoteEvent("AskDischarge"),
    DropCaster = Networking.remoteEvent("DropCaster")
}

v1 = function() -- line: 462
    -- upvalues: Networking (copy)
    return {
        AskRedeem = Networking.remoteFunction("AskRedeem"),
        AskRedeemAll = Networking.remoteFunction("AskRedeemAll"),
        AskRedeemLimitedEgg = Networking.remoteFunction("AskRedeemLimitedEgg"),
        AskWearFieldBat = Networking.remoteFunction("AskWearFieldBat")
    }
end

Networking.namespace({
    name = "Codex",
    env = "all"
})
t1.Codex = v1()

v1 = function() -- line: 470
    -- upvalues: Networking (copy)
    return {
        InviteLanded = Networking.remoteEvent("InviteLanded")
    }
end

Networking.namespace({
    name = "Referrals",
    env = "all"
})
t1.Referrals = {
    InviteLanded = Networking.remoteEvent("InviteLanded")
}

v1 = function() -- line: 475
    -- upvalues: Networking (copy)
    return {
        AskDischarge = Networking.remoteEvent("AskDischarge"),
        EmitBeam = Networking.remoteEvent("EmitBeam"),
        EmitSfx = Networking.remoteEvent("EmitSfx")
    }
end

Networking.namespace({
    name = "LaserGadget",
    env = "all"
})
t1.LaserGadget = v1()

v1 = function() -- line: 482
    -- upvalues: Networking (copy)
    return {
        AskTug = Networking.remoteEvent("AskTug"),
        EmitBeam = Networking.remoteEvent("EmitBeam"),
        EmitTargetFx = Networking.remoteEvent("EmitTargetFx"),
        HaltBeam = Networking.remoteEvent("HaltBeam"),
        HaltTargetFx = Networking.remoteEvent("HaltTargetFx")
    }
end

Networking.namespace({
    name = "MagnetGadget",
    env = "all"
})
t1.MagnetGadget = v1()

v1 = function() -- line: 491
    -- upvalues: Networking (copy)
    return {
        CloseEffectWindow = Networking.remoteEvent("CloseEffectWindow"),
        EmitFx = Networking.remoteEvent("EmitFx"),
        EmitSfx = Networking.remoteEvent("EmitSfx"),
        OpenEffectWindow = Networking.remoteEvent("OpenEffectWindow"),
        Rouse = Networking.remoteEvent("Rouse")
    }
end

Networking.namespace({
    name = "MegaphoneGadget",
    env = "all"
})
t1.MegaphoneGadget = v1()

v1 = function() -- line: 500
    -- upvalues: Networking (copy)
    return {
        RoundShifted = Networking.remoteEvent("RoundShifted")
    }
end

Networking.namespace({
    name = "Whodunnit",
    env = "all"
})
t1.Whodunnit = {
    RoundShifted = Networking.remoteEvent("RoundShifted")
}

v1 = function() -- line: 505
    -- upvalues: Networking (copy)
    return {
        Raise = Networking.remoteEvent("Raise")
    }
end

Networking.namespace({
    name = "Alerts",
    env = "all"
})
t1.Alerts = {
    Raise = Networking.remoteEvent("Raise")
}

v1 = function() -- line: 510
    -- upvalues: Networking (copy)
    return {
        ShowNotice = Networking.remoteEvent("ShowNotice")
    }
end

Networking.namespace({
    name = "RollbackRewards",
    env = "all"
})
t1.RollbackRewards = {
    ShowNotice = Networking.remoteEvent("ShowNotice")
}

v1 = function() -- line: 515
    -- upvalues: Networking (copy)
    return {
        AskCollect = Networking.remoteFunction("AskCollect"),
        FetchSummary = Networking.remoteFunction("FetchSummary"),
        PendingCheck = Networking.remoteFunction("PendingCheck"),
        Redeemed = Networking.remoteEvent("Redeemed"),
        SummaryRefreshed = Networking.remoteEvent("SummaryRefreshed")
    }
end

Networking.namespace({
    name = "AwayEarnings",
    env = "all"
})
t1.AwayEarnings = v1()

v1 = function() -- line: 524
    -- upvalues: Networking (copy)
    return {
        AskBaseTierRaise = Networking.remoteEvent("AskBaseTierRaise"),
        AskLobbyHop = Networking.remoteEvent("AskLobbyHop"),
        AskNearbyPurchase = Networking.remoteEvent("AskNearbyPurchase"),
        AskState = Networking.remoteFunction("AskState"),
        BaseTierRaised = Networking.remoteEvent("BaseTierRaised"),
        DimBaseOutline = Networking.remoteEvent("DimBaseOutline"),
        LitBaseOutline = Networking.remoteEvent("LitBaseOutline"),
        StateShifted = Networking.remoteEvent("StateShifted")
    }
end

Networking.namespace({
    name = "Homestead",
    env = "all"
})
t1.Homestead = v1()

v1 = function() -- line: 536
    -- upvalues: Networking (copy)
    return {
        Received = Networking.remoteEvent("Received"),
        PromptFinished = Networking.remoteEvent("PromptFinished"),
        AskGift = Networking.remoteFunction("AskGift"),
        Completed = Networking.remoteEvent("Completed")
    }
end

Networking.namespace({
    name = "Gifting",
    env = "all"
})
t1.Gifting = v1()

v1 = function() -- line: 544
    -- upvalues: Networking (copy)
    return {
        AllowPurchase = Networking.remoteFunction("AllowPurchase"),
        AskPurchaseOffer = Networking.remoteFunction("AskPurchaseOffer"),
        AskServerProbe = Networking.remoteFunction("AskServerProbe"),
        Awarded = Networking.remoteEvent("Awarded"),
        PurchaseRejected = Networking.remoteEvent("PurchaseRejected"),
        PurchaseSettled = Networking.remoteEvent("PurchaseSettled"),
        ReceiptCleared = Networking.remoteEvent("ReceiptCleared")
    }
end

Networking.namespace({
    name = "Storefront",
    env = "all"
})
t1.Storefront = v1()

v1 = function() -- line: 555
    -- upvalues: Networking (copy)
    return {
        WriteLimpness = Networking.remoteEvent("WriteLimpness")
    }
end

Networking.namespace({
    name = "Limpness",
    env = "all"
})
t1.Limpness = {
    WriteLimpness = Networking.remoteEvent("WriteLimpness")
}

v1 = function() -- line: 560
    -- upvalues: Networking (copy)
    return {
        FetchProfile = Networking.remoteFunction("FetchProfile"),
        ProfileDelta = Networking.remoteEvent("ProfileDelta")
    }
end

Networking.namespace({
    name = "ProfileMirror",
    env = "all"
})
t1.ProfileMirror = {
    FetchProfile = Networking.remoteFunction("FetchProfile"),
    ProfileDelta = Networking.remoteEvent("ProfileDelta")
}

v1 = function() -- line: 566
    -- upvalues: Networking (copy)
    return {
        JoltOnce = Networking.remoteEvent("JoltOnce")
    }
end

Networking.namespace({
    name = "SharedFx",
    env = "all"
})
t1.SharedFx = {
    JoltOnce = Networking.remoteEvent("JoltOnce")
}

v1 = function() -- line: 571
    -- upvalues: Networking (copy)
    return {
        AskBriefingConfirm = Networking.remoteFunction("AskBriefingConfirm"),
        AskCraneReturn = Networking.remoteFunction("AskCraneReturn"),
        AskEjectEgg = Networking.remoteFunction("AskEjectEgg"),
        AskGatherPetal = Networking.remoteFunction("AskGatherPetal"),
        AskHandoff = Networking.remoteFunction("AskHandoff"),
        AskLoadEgg = Networking.remoteFunction("AskLoadEgg"),
        AskMutate = Networking.remoteFunction("AskMutate"),
        AskStrikeTree = Networking.remoteEvent("AskStrikeTree"),
        CutsceneOpened = Networking.remoteEvent("CutsceneOpened"),
        PetalsGathered = Networking.remoteEvent("PetalsGathered")
    }
end

Networking.namespace({
    name = "Bloomery",
    env = "all"
})
t1.Bloomery = v1()

v1 = function() -- line: 585
    -- upvalues: Networking (copy)
    return {
        FetchState = Networking.remoteFunction("FetchState"),
        StateRefreshed = Networking.remoteEvent("StateRefreshed")
    }
end

Networking.namespace({
    name = "LuckWindow",
    env = "all"
})
t1.LuckWindow = {
    FetchState = Networking.remoteFunction("FetchState"),
    StateRefreshed = Networking.remoteEvent("StateRefreshed")
}

v1 = function() -- line: 591
    -- upvalues: Networking (copy)
    return {
        AskWrite = Networking.remoteFunction("AskWrite"),
        PreferenceShifted = Networking.remoteEvent("PreferenceShifted")
    }
end

Networking.namespace({
    name = "Preferences",
    env = "all"
})
t1.Preferences = {
    AskWrite = Networking.remoteFunction("AskWrite"),
    PreferenceShifted = Networking.remoteEvent("PreferenceShifted")
}

v1 = function() -- line: 597
    -- upvalues: Networking (copy)
    return {
        AskPlace = Networking.remoteEvent("AskPlace"),
        AttachOutline = Networking.remoteEvent("AttachOutline"),
        TrapSet = Networking.remoteEvent("TrapSet")
    }
end

Networking.namespace({
    name = "MineTrap",
    env = "all"
})
t1.MineTrap = v1()

v1 = function() -- line: 604
    -- upvalues: Networking (copy)
    return {
        BeginShutdown = Networking.remoteEvent("BeginShutdown")
    }
end

Networking.namespace({
    name = "Lifecycle",
    env = "all"
})
t1.Lifecycle = {
    BeginShutdown = Networking.remoteEvent("BeginShutdown")
}

v1 = function() -- line: 609
    -- upvalues: Networking (copy)
    return {
        Trigger = Networking.remoteEvent("Trigger")
    }
end

Networking.namespace({
    name = "ToolTrigger",
    env = "all"
})
t1.ToolTrigger = {
    Trigger = Networking.remoteEvent("Trigger")
}

v1 = function() -- line: 614
    -- upvalues: Networking (copy)
    return {
        AskChoose = Networking.remoteFunction("AskChoose"),
        AskDoff = Networking.remoteFunction("AskDoff"),
        AskPurchase = Networking.remoteFunction("AskPurchase"),
        AskWornSnapshot = Networking.remoteFunction("AskWornSnapshot"),
        WornTrailShifted = Networking.remoteEvent("WornTrailShifted")
    }
end

Networking.namespace({
    name = "Trailwear",
    env = "all"
})
t1.Trailwear = v1()

v1 = function() -- line: 623
    -- upvalues: Networking (copy)
    return {
        AskPlace = Networking.remoteEvent("AskPlace")
    }
end

Networking.namespace({
    name = "TrapPlacement",
    env = "all"
})
t1.TrapPlacement = {
    AskPlace = Networking.remoteEvent("AskPlace")
}

v1 = function() -- line: 628
    -- upvalues: Networking (copy)
    return {
        AskPlace = Networking.remoteEvent("AskPlace"),
        Burst = Networking.remoteEvent("Burst")
    }
end

Networking.namespace({
    name = "GravityDisruptor",
    env = "all"
})
t1.GravityDisruptor = {
    AskPlace = Networking.remoteEvent("AskPlace"),
    Burst = Networking.remoteEvent("Burst")
}

v1 = function() -- line: 634
    -- upvalues: Networking (copy)
    return {
        AskClipFavour = Networking.remoteFunction("AskClipFavour"),
        AskDoff = Networking.remoteFunction("AskDoff"),
        AskFavourSnapshot = Networking.remoteFunction("AskFavourSnapshot"),
        AskFriendFavourSnapshot = Networking.remoteFunction("AskFriendFavourSnapshot"),
        AskPostReply = Networking.remoteFunction("AskPostReply"),
        AskRenderSnapshot = Networking.remoteFunction("AskRenderSnapshot"),
        AskReplyCounts = Networking.remoteFunction("AskReplyCounts"),
        AskReplyFavour = Networking.remoteFunction("AskReplyFavour"),
        AskReplyPage = Networking.remoteFunction("AskReplyPage"),
        AskSlowToggle = Networking.remoteFunction("AskSlowToggle"),
        AskSlowToggleSet = Networking.remoteFunction("AskSlowToggleSet"),
        AskTierRaise = Networking.remoteFunction("AskTierRaise"),
        AskWearStill = Networking.remoteFunction("AskWearStill"),
        AssignedBeltShifted = Networking.remoteEvent("AssignedBeltShifted"),
        GaugeClipLength = Networking.remoteFunction("GaugeClipLength"),
        OverlaySnapshot = Networking.remoteEvent("OverlaySnapshot"),
        RefreshClipCursor = Networking.remoteEvent("RefreshClipCursor"),
        RenderStateShifted = Networking.remoteEvent("RenderStateShifted"),
        SpeedGained = Networking.remoteEvent("SpeedGained"),
        SubmitClipView = Networking.remoteEvent("SubmitClipView"),
        ViewStateShifted = Networking.remoteEvent("ViewStateShifted")
    }
end

Networking.namespace({
    name = "Treadmill",
    env = "all"
})
t1.Treadmill = v1()

v1 = function() -- line: 659
    -- upvalues: Networking (copy)
    return {
        AnchorForZone = Networking.remoteEvent("AnchorForZone")
    }
end

Networking.namespace({
    name = "ZoneProbe",
    env = "all"
})
t1.ZoneProbe = {
    AnchorForZone = Networking.remoteEvent("AnchorForZone")
}

v1 = function() -- line: 664
    -- upvalues: Networking (copy)
    return {
        GetWins = Networking.remoteFunction("GetWins"),
        WinsUpdated = Networking.remoteEvent("WinsUpdated"),
        GetWinParts = Networking.remoteFunction("GetWinParts"),
        WinPartsUpdated = Networking.remoteEvent("WinPartsUpdated"),
        RequestTeleport = Networking.remoteFunction("RequestTeleport"),
        PlaySFX = Networking.remoteEvent("PlaySFX")
    }
end

Networking.namespace({
    name = "MonsterEvent",
    env = "all"
})
t1.MonsterEvent = v1()

v1 = function() -- line: 674
    -- upvalues: Networking (copy)
    return {
        AskState = Networking.remoteFunction("AskState"),
        AskSubmit = Networking.remoteFunction("AskSubmit"),
        Feedback = Networking.remoteEvent("Feedback"),
        StateChanged = Networking.remoteEvent("StateChanged"),
        Ritual = Networking.remoteEvent("Ritual")
    }
end

Networking.namespace({
    name = "ShrineFusion",
    env = "all"
})
t1.ShrineFusion = v1()

v1 = function() -- line: 683
    -- upvalues: Networking (copy)
    return {
        AskClaim = Networking.remoteFunction("AskClaim"),
        Aim = Networking.remoteEvent("Aim"),
        BridgeFormed = Networking.remoteEvent("BridgeFormed"),
        Effect = Networking.remoteEvent("Effect"),
        Squish = Networking.remoteEvent("Squish")
    }
end

Networking.namespace({
    name = "BanjoCricket",
    env = "all"
})
t1.BanjoCricket = v1()

v1 = function() -- line: 692
    -- upvalues: Networking (copy)
    return {
        AskState = Networking.remoteFunction("AskState"),
        AskTradeIn = Networking.remoteFunction("AskTradeIn"),
        AskRefresh = Networking.remoteFunction("AskRefresh"),
        AskFinishReveal = Networking.remoteFunction("AskFinishReveal"),
        BannerRotated = Networking.remoteEvent("BannerRotated")
    }
end

Networking.namespace({
    name = "Rift",
    env = "all"
})
t1.Rift = v1()

v1 = function() -- line: 701
    -- upvalues: Networking (copy)
    return {
        AskState = Networking.remoteFunction("AskState"),
        AskTradeIn = Networking.remoteFunction("AskTradeIn"),
        AskRefresh = Networking.remoteFunction("AskRefresh"),
        AskFinishReveal = Networking.remoteFunction("AskFinishReveal"),
        BannerRotated = Networking.remoteEvent("BannerRotated")
    }
end

Networking.namespace({
    name = "ScrambleTradeIn",
    env = "all"
})
t1.ScrambleTradeIn = v1()

v1 = function() -- line: 710
    -- upvalues: Networking (copy)
    return {
        Show = Networking.remoteEvent("Show")
    }
end

Networking.namespace({
    name = "RewardScreen",
    env = "all"
})
t1.RewardScreen = {
    Show = Networking.remoteEvent("Show")
}

v1 = function() -- line: 715
    -- upvalues: Networking (copy)
    return {
        AskAcknowledge = Networking.remoteFunction("AskAcknowledge"),
        AskClaim = Networking.remoteFunction("AskClaim")
    }
end

Networking.namespace({
    name = "OnboardingQuestline",
    env = "all"
})
t1.OnboardingQuestline = {
    AskAcknowledge = Networking.remoteFunction("AskAcknowledge"),
    AskClaim = Networking.remoteFunction("AskClaim")
}

v1 = function() -- line: 721
    -- upvalues: Networking (copy)
    return {
        AskEnter = Networking.remoteFunction("AskEnter"),
        AskSnapshot = Networking.remoteFunction("AskSnapshot"),
        BlackHoleHit = Networking.remoteEvent("BlackHoleHit"),
        BossDamaged = Networking.remoteEvent("BossDamaged"),
        HazardHit = Networking.remoteEvent("HazardHit"),
        HealthShifted = Networking.remoteEvent("HealthShifted"),
        StateShifted = Networking.remoteEvent("StateShifted"),
        Vfx = Networking.remoteEvent("Vfx")
    }
end

Networking.namespace({
    name = "BossEvent",
    env = "all"
})
t1.BossEvent = v1()

v1 = function() -- line: 735
    -- upvalues: Networking (copy)
    return {
        EnterArena = Networking.remoteFunction("EnterArena"),
        Fx = Networking.remoteEvent("Fx"),
        Hazard = Networking.remoteEvent("Hazard"),
        HazardHit = Networking.remoteEvent("HazardHit"),
        Transition = Networking.remoteEvent("Transition")
    }
end

Networking.namespace({
    name = "ScrambleBoss",
    env = "all"
})
t1.ScrambleBoss = v1()

v1 = function() -- line: 744
    -- upvalues: Networking (copy)
    return {
        Fx = Networking.remoteEvent("Fx"),
        Hazard = Networking.remoteEvent("Hazard"),
        HazardHit = Networking.remoteEvent("HazardHit"),
        Transition = Networking.remoteEvent("Transition"),
        CannonFire = Networking.remoteEvent("CannonFire"),
        Drops = Networking.remoteEvent("Drops"),
        Collect = Networking.remoteEvent("Collect"),
        RemoveDrops = Networking.remoteEvent("RemoveDrops")
    }
end

Networking.namespace({
    name = "PumpkinBoss",
    env = "all"
})
t1.PumpkinBoss = v1()

v1 = function() -- line: 756
    -- upvalues: Networking (copy)
    return {
        Talk = Networking.remoteFunction("Talk"),
        Collect = Networking.remoteFunction("Collect"),
        Cast = Networking.remoteFunction("Cast"),
        Dive = Networking.remoteFunction("Dive"),
        Restart = Networking.remoteFunction("Restart"),
        Claim = Networking.remoteFunction("Claim"),
        Surface = Networking.remoteFunction("Surface"),
        Abort = Networking.remoteFunction("Abort")
    }
end

Networking.namespace({
    name = "GhostDogQuest",
    env = "all"
})
t1.GhostDogQuest = v1()

v1 = function() -- line: 768
    -- upvalues: Networking (copy)
    return {
        Hold = Networking.remoteEvent("Hold"),
        Cast = Networking.remoteFunction("Cast"),
        Reel = Networking.remoteFunction("Reel"),
        Cancel = Networking.remoteEvent("Cancel")
    }
end

Networking.namespace({
    name = "Fishing",
    env = "all"
})
t1.Fishing = v1()

v1 = function() -- line: 776
    -- upvalues: Networking (copy)
    return {
        AskBuyShopItem = Networking.remoteFunction("AskBuyShopItem"),
        AskClaimMilestone = Networking.remoteFunction("AskClaimMilestone"),
        AskUseMutationConsumable = Networking.remoteFunction("AskUseMutationConsumable")
    }
end

Networking.namespace({
    name = "BossMastery",
    env = "all"
})
t1.BossMastery = v1()

v1 = function() -- line: 783
    -- upvalues: Networking (copy)
    return {
        Fetch = Networking.remoteFunction("Fetch"),
        Updated = Networking.remoteEvent("Updated")
    }
end

Networking.namespace({
    name = "Leaderboards",
    env = "all"
})
t1.Leaderboards = {
    Fetch = Networking.remoteFunction("Fetch"),
    Updated = Networking.remoteEvent("Updated")
}

v1 = function() -- line: 789
    -- upvalues: Networking (copy)
    return {
        Vote = Networking.remoteEvent("Vote")
    }
end

Networking.namespace({
    name = "Voting",
    env = "all"
})
t1.Voting = {
    Vote = Networking.remoteEvent("Vote")
}

v1 = function() -- line: 794
    -- upvalues: Networking (copy)
    return {
        ShowLimitedTimePopup = Networking.remoteEvent("ShowLimitedTimePopup")
    }
end

Networking.namespace({
    name = "LimitedTimePopups",
    env = "all"
})
t1.LimitedTimePopups = {
    ShowLimitedTimePopup = Networking.remoteEvent("ShowLimitedTimePopup")
}

v1 = function() -- line: 799
    -- upvalues: Networking (copy)
    return {
        Request = Networking.remoteFunction("Request")
    }
end

Networking.namespace({
    name = "PetMount",
    env = "all"
})
t1.PetMount = {
    Request = Networking.remoteFunction("Request")
}

v1 = function() -- line: 802
    -- upvalues: Networking (copy)
    return {
        Request = Networking.remoteFunction("Request")
    }
end

Networking.namespace({
    name = "WispCompanion",
    env = "all"
})
t1.WispCompanion = {
    Request = Networking.remoteFunction("Request")
}

v1 = function() -- line: 805
    -- upvalues: Networking (copy)
    return {
        AskState = Networking.remoteFunction("AskState"),
        Fall = Networking.remoteEvent("Fall"),
        Wander = Networking.remoteEvent("Wander"),
        Hold = Networking.remoteEvent("Hold"),
        Catch = Networking.remoteEvent("Catch"),
        Slipped = Networking.remoteEvent("Slipped"),
        Claimed = Networking.remoteEvent("Claimed"),
        Celebrate = Networking.remoteEvent("Celebrate"),
        Expired = Networking.remoteEvent("Expired"),
        AskFeed = Networking.remoteFunction("AskFeed"),
        Fed = Networking.remoteEvent("Fed")
    }
end

Networking.namespace({
    name = "ShootingStar",
    env = "all"
})
t1.ShootingStar = v1()

v1 = function() -- line: 820
    -- upvalues: Networking (copy)
    return {
        AskSwarm = Networking.remoteFunction("AskSwarm"),
        AskSwing = Networking.remoteFunction("AskSwing"),
        AskClaimNet = Networking.remoteFunction("AskClaimNet"),
        AskTradeUp = Networking.remoteFunction("AskTradeUp"),
        AskCraftEssence = Networking.remoteFunction("AskCraftEssence"),
        Spawned = Networking.remoteEvent("Spawned"),
        Escaped = Networking.remoteEvent("Escaped"),
        Removed = Networking.remoteEvent("Removed"),
        Announce = Networking.remoteEvent("Announce"),
        NetClaimed = Networking.remoteEvent("NetClaimed")
    }
end

Networking.namespace({
    name = "Butterflies",
    env = "all"
})
t1.Butterflies = v1()

v1 = function() -- line: 834
    -- upvalues: Networking (copy)
    return {
        Transition = Networking.remoteEvent("Transition")
    }
end

Networking.namespace({
    name = "EnchantedTree",
    env = "all"
})
t1.EnchantedTree = {
    Transition = Networking.remoteEvent("Transition")
}

v1 = function() -- line: 839
    -- upvalues: Networking (copy)
    return {
        Travel = Networking.remoteEvent("Travel"),
        Arrive = Networking.remoteFunction("Arrive"),
        Leave = Networking.remoteFunction("Leave"),
        MetWorker = Networking.remoteEvent("MetWorker")
    }
end

Networking.namespace({
    name = "SewerCave",
    env = "all"
})
t1.SewerCave = v1()

v1 = function() -- line: 847
    -- upvalues: Networking (copy)
    return {
        Travel = Networking.remoteEvent("Travel"),
        Request = Networking.remoteFunction("Request"),
        Arrive = Networking.remoteFunction("Arrive"),
        Leave = Networking.remoteFunction("Leave")
    }
end

Networking.namespace({
    name = "ManorInterior",
    env = "all"
})
t1.ManorInterior = v1()

v1 = function() -- line: 855
    -- upvalues: Networking (copy)
    return {
        Spin = Networking.remoteFunction("Spin"),
        Finish = Networking.remoteEvent("Finish")
    }
end

Networking.namespace({
    name = "PetWheel",
    env = "all"
})
t1.PetWheel = {
    Spin = Networking.remoteFunction("Spin"),
    Finish = Networking.remoteEvent("Finish")
}

v1 = function() -- line: 861
    -- upvalues: Networking (copy)
    return {
        AskBuy = Networking.remoteFunction("AskBuy"),
        AskClaimMilestone = Networking.remoteFunction("AskClaimMilestone"),
        AskEquipRacer = Networking.remoteFunction("AskEquipRacer")
    }
end

Networking.namespace({
    name = "RaceRally",
    env = "all"
})
t1.RaceRally = v1()

v1 = function() -- line: 868
    -- upvalues: Networking (copy)
    return {
        AskEnter = Networking.remoteFunction("AskEnter")
    }
end

Networking.namespace({
    name = "TheHollow",
    env = "all"
})
t1.TheHollow = {
    AskEnter = Networking.remoteFunction("AskEnter")
}

v1 = function() -- line: 873
    -- upvalues: Networking (copy)
    return {
        Fetch = Networking.remoteFunction("Fetch"),
        State = Networking.remoteEvent("State"),
        Moment = Networking.remoteEvent("Moment"),
        Use = Networking.remoteEvent("Use"),
        OutroFinished = Networking.remoteEvent("OutroFinished")
    }
end

Networking.namespace({
    name = "IslandWars",
    env = "all"
})
t1.IslandWars = v1()
Networking.close()

return t1
