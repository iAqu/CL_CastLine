-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MountRace = ReplicatedStorage.Assets.MountRace
local t1 = {
    TrackTag = "RaceTrack",
    MountTag = "RaceMount",
    MountName = "RaceMount",
    HeatsFolder = "RaceHeats",
    HeatWaitSeconds = 10,
    RaceNameAttribute = "RaceName",
    CutsceneAttribute = "RaceCutscenePlaying",
    OutroAttribute = "RaceEventOutro",
    RandomColorAttribute = "RandomColor",
    AmbientEvents = table.freeze({
        AdminAbuse = true,
        AdminTreadmill = true,
        ButterflyBloom = true,
        Countdown = true,
        EarningsBoost = true,
        EggLuckBoost = true,
        EggSizeBoost = true,
        GreatBloom = true,
        MutationBoost = true,
        RaceRally = true,
        RecoveryEvent = true,
        RiftOpen = true,
        SpeedBoost = true,
        TrainEvent = true
    }),
    Phase = table.freeze({
        Joining = "Joining",
        Countdown = "Countdown",
        Racing = "Racing",
        Results = "Results"
    }),
    TrackAttributes = table.freeze({
        Phase = "RacePhase",
        JoinEndsAt = "RaceJoinEndsAt",
        GoAt = "RaceGoAt",
        EndsAt = "RaceEndsAt",
        Laps = "RaceLaps",
        WaitForOthers = "RaceWaitForOthers"
    }),
    PlayerAttributes = table.freeze({
        RaceId = "RaceId",
        Heat = "RaceHeat",
        GridFrame = "RaceGridFrame",
        Place = "RacePlace",
        Lap = "RaceLap",
        FinishPlace = "RaceFinishPlace",
        FinishTime = "RaceFinishTime"
    }),
    ComponentTags = table.freeze({
        BoostPad = "RaceBoostPad",
        SlowPad = "RaceSlowPad",
        Jump = "RaceJump",
        LoopTheLoop = "RaceLoop",
        PowerUpSpawn = "RacePowerUpSpawn"
    }),
    RandomColors = table.freeze({
        Color3.fromRGB(196, 76, 65),
        Color3.fromRGB(51, 88, 130),
        Color3.fromRGB(213, 91, 34),
        Color3.fromRGB(123, 0, 123),
        Color3.fromRGB(52, 142, 64),
        Color3.fromRGB(255, 176, 0),
        Color3.fromRGB(255, 102, 204),
        Color3.fromRGB(99, 226, 255)
    }),
    RiderAnimations = table.freeze({
        Ride = "rbxassetid://77661864641148",
        Jump = "rbxassetid://74199050307163"
    }),
    Mounts = MountRace.Mounts,
    Effects = MountRace.Effects,
    Sounds = ReplicatedStorage.Assets.Sounds.MountRace,
    RiderFrame = function(p1, p2) -- RiderFrame | line: 168
        local HumanoidRootPart = p1.HumanoidRootPart
        local v1 = HumanoidRootPart.CFrame:ToObjectSpace(p1.Hitbox.CFrame).Y - p1.Hitbox.Size.Y / 2

        return p2 * CFrame.new(0, 0.5 - v1, 0) * HumanoidRootPart.Seat.CFrame
    end
}

function t1.IsInsidePart(p3, p4, p5) -- line: 176
    local v2 = p3.CFrame:PointToObjectSpace(p4)
    local v3 = p3.Size / 2 + p5

    if math.abs(v2.X) <= v3.X then
        if not (math.abs(v2.Y) <= v3.Y) then
            return false
        end

        return math.abs(v2.Z) <= v3.Z
    end

    return false
end

function t1.NumberAttribute(p6, p7, p8) -- line: 183
    local Attribute = p6:GetAttribute(p7)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p8
end

function t1.StateOf(p9, p10) -- line: 188
    -- upvalues: t1 (copy)
    if p10 == nil then
        return p9
    end

    local v4 = p9:WaitForChild(t1.HeatsFolder, t1.HeatWaitSeconds)

    return if v4 ~= nil then v4:WaitForChild(p10, t1.HeatWaitSeconds) else nil
end

function t1.HeatOf(p11) -- line: 196
    -- upvalues: t1 (copy)
    local Attribute = p11:GetAttribute(t1.PlayerAttributes.Heat)

    return if type(Attribute) == "string" then Attribute else nil
end

function t1.InOtherHeat(p12, p13, p14) -- line: 201
    -- upvalues: t1 (copy)
    if p12:GetAttribute(t1.PlayerAttributes.RaceId) == p13 then
        return t1.HeatOf(p12) ~= p14
    end

    return false
end

function t1.FormatPlace(p15) -- line: 208
    local v5 = p15 % 100

    return (("%*%*"):format(p15, if v5 >= 11 and v5 <= 13 then "th"
        elseif p15 % 10 == 1 then "st"
        elseif p15 % 10 == 2 then "nd"
        elseif p15 % 10 == 3 then "rd"
        else "th"))
end

function t1.FormatTime(p16) -- line: 218
    return string.format("%d:%04.1f", p16 // 60, p16 % 60)
end

return table.freeze(t1)
