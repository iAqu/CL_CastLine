-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images")
local fishImages, images2 = images.fishImages, images.images
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local getTimeToAddToPlaytime = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getTimeToAddToPlaytime
local t1 = {
    600, 1200, 2100, 3000, 3900
}
local v1 = #t1

local function getSpinWheelDailyPlaytimeSeconds(p1, p2, p3, p4) -- line: 26
    -- upvalues: getTimeToAddToPlaytime (copy)
    return p2 + getTimeToAddToPlaytime(p1, p3, p4)
end

local function getSpinWheelMilestonesReached(p5) -- line: 30
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v2 in t1 do
        if not (v2 <= p5) then
            break
        end

        n1 += 1
    end

    return n1
end

local function getSecondsUntilNextSpinWheelSpin(p6, p7) -- line: 47
    -- upvalues: t1 (copy), v1 (copy)
    return if not (v1 <= p7) then math.max(0, t1[p7 + 1] - p6) else nil
end

local t2 = {
    1, 2, 5, 10, 15, 20, 30, 60
}

local function getTimeSkipSeconds(p8) -- line: 55
    return p8 * 60
end

local function getTimeSkipMinutes(p9) -- line: 58
    -- upvalues: t2 (copy)
    local v4 = p9 / 60

    for _, v5 in t2 do
        if v4 == v5 then
            return v5
        end
    end

    return nil
end

local t3 = {
    CashIcon = "rbxassetid://138217158436519",
    Pointer = "rbxassetid://94548699455197",
    RobuxIcon = "",
    WheelFace = "rbxassetid://107616658187358",
    WheelRim = "",
    GodlyMysteryIcon = fishImages.mechShark,
    LegendaryMysteryIcon = fishImages.mjFish,
    MythicMysteryIcon = fishImages.megaladon,
    TimeSkipIcon = images2.timeSkipIcon
}
local t4 = {
    SpinWheel_ButtonClick = "",
    SpinWheel_Close = "",
    SpinWheel_Land = "",
    SpinWheel_LandRare = "",
    SpinWheel_NoSpins = "",
    SpinWheel_Open = "",
    SpinWheel_RewardPop = "",
    SpinWheel_SpinLoop = "",
    SpinWheel_Start = "",
    SpinWheel_Tick = ""
}
local t5 = {
    {
        centerAngle = 0,
        chance = 2,
        id = "title_monarch",
        rarity = "godly",
        color = Color3.fromRGB(255, 116, 232),
        reward = {
            kind = "title",
            titleId = "monarch"
        }
    },
    {
        centerAngle = 60,
        chance = 15,
        id = "cash_1b",
        rarity = "common",
        color = Color3.fromRGB(77, 218, 255),
        reward = {
            kind = "timeSkip",
            seconds = 300
        }
    },
    {
        centerAngle = 120,
        chance = 1,
        id = "skin_jurassic",
        rarity = "mythic",
        color = Color3.fromRGB(232, 46, 52),
        reward = {
            kind = "aquariumSkin",
            skinName = "Jurassic"
        }
    },
    {
        centerAngle = 180,
        chance = 10,
        id = "cash_10b",
        rarity = "common",
        color = Color3.fromRGB(248, 239, 67),
        reward = {
            kind = "timeSkip",
            seconds = 600
        }
    },
    {
        centerAngle = 240,
        chance = 47,
        id = "cash_50m",
        rarity = "common",
        color = Color3.fromRGB(238, 238, 238),
        reward = {
            kind = "timeSkip",
            seconds = 60
        }
    },
    {
        centerAngle = 300,
        chance = 30,
        id = "cash_250m",
        rarity = "common",
        color = Color3.fromRGB(73, 225, 94),
        reward = {
            kind = "timeSkip",
            seconds = 120
        }
    }
}

local function getSpinWheelTimeSkipCash(p10, p11) -- line: 168
    return (math.max(math.floor(math.max(p10, 0) * math.max(p11, 0)), 100))
end

local function formatTimeSkip(p12) -- line: 172
    -- upvalues: t2 (copy)
    local v8 = p12 / 60
    local v9 = false
    local v10

    for _, v11 in t2 do
        if v8 == v11 then
            v10 = v11
            v9 = true
            break
        end
    end

    if not v9 then
        v10 = nil
    end

    return (("%* MIN SKIP"):format(v10 or p12 / 60))
end

return {
    playtimeSpinWheelSegmentAngle = 60,
    minSpinWheelTimeSkipCash = 100,
    getSpinWheelDailyPlaytimeSeconds = getSpinWheelDailyPlaytimeSeconds,
    getSpinWheelMilestonesReached = getSpinWheelMilestonesReached,
    getSecondsUntilNextSpinWheelSpin = getSecondsUntilNextSpinWheelSpin,
    getTimeSkipSeconds = getTimeSkipSeconds,
    getTimeSkipMinutes = getTimeSkipMinutes,
    getSpinWheelTimeSkipCash = getSpinWheelTimeSkipCash,
    getSpinWheelSegmentDisplay = function(p13, p14) -- getSpinWheelSegmentDisplay | line: 183
        -- upvalues: abbreviate (copy), getTitleData (copy), t2 (copy)
        if p13.reward.kind == "fish" then
            local v12 = string.upper(p13.reward.fishRarity)

            return {
                shortText = "???",
                rewardText = ("%* FISH"):format(v12),
                title = v12
            }
        end

        if p13.reward.kind == "title" then
            local v13 = getTitleData(p13.reward.titleId)
            local t6 = {
                rewardText = "PLAYER TITLE"
            }

            if v13 ~= nil then
                v13 = string.upper(v13.displayName)
            end

            t6.shortText = if v13 == nil then "TITLE" else v13
            t6.title = "PLAYER\nTITLE"

            return t6
        end

        if p13.reward.kind == "aquariumSkin" then
            return {
                rewardText = "AQUARIUM SKIN",
                title = "AQUARIUM SKIN",
                shortText = string.upper(p13.reward.skinName)
            }
        end

        local v16 = math.max(math.floor(math.max(p13.reward.seconds, 0) * math.max(p14, 0)), 100)
        local t7 = {
            rewardText = ("+%* CASH"):format((abbreviate(v16))),
            shortText = ("+%*"):format((abbreviate(v16)))
        }
        local seconds2 = p13.reward.seconds
        local v17 = seconds2 / 60
        local v18 = false
        local v19

        for _, v20 in t2 do
            if v17 == v20 then
                v19 = v20
                v18 = true
                break
            end
        end

        if not v18 then
            v19 = nil
        end

        t7.title = ("%* MIN SKIP"):format(v19 or seconds2 / 60)

        return t7
    end,
    getPlaytimeSpinWheelSegmentById = function(p15) -- getPlaytimeSpinWheelSegmentById | line: 224
        -- upvalues: t5 (copy)
        for _, v21 in t5 do
            if v21.id == p15 then
                return v21
            end
        end

        return nil
    end,
    rollPlaytimeSpinWheelSegment = function() -- rollPlaytimeSpinWheelSegment | line: 233
        -- upvalues: t5 (copy)
        local n2 = 0

        for _, v22 in t5 do
            n2 += v22.chance
        end

        local v23 = math.random() * n2

        for _, v24 in t5 do
            v23 -= v24.chance

            if v23 <= 0 then
                return v24
            end
        end

        return t5[#t5]
    end,
    playtimeSpinWheelGrantSeconds = t1,
    maxDailySpinWheelSpins = v1,
    timeSkipMinuteOptions = t2,
    monarchDuplicateTimeSkipSeconds = 900,
    jurassicDuplicateTimeSkipSeconds = 1200,
    playtimeSpinWheelAssets = t3,
    playtimeSpinWheelSfxIds = t4,
    playtimeSpinWheelSegments = t5
}
