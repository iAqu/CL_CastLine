-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReleaseConfig = require(script.Parent.ReleaseConfig)
local t1 = {
    SegmentLength = 24,
    SubAreas = 3,
    StartGap = 5
}
local t2 = {
    {
        Key = "Forest",
        Name = "Forest",
        Emoji = "🌳",
        Segments = 7,
        Color = Color3.fromRGB(96, 200, 72),
        RarityPattern = { "Common", "Common", "Common", "Uncommon", "Uncommon", "Uncommon", "Rare", "Epic" }
    },
    {
        Key = "Savana",
        Name = "Savanna",
        Emoji = "☀️",
        Segments = 7,
        Color = Color3.fromRGB(230, 190, 80),
        RarityPattern = { "Common", "Common", "Uncommon", "Uncommon", "Uncommon", "Rare", "Rare", "Epic" }
    },
    {
        Key = "Desert",
        Name = "Desert",
        Emoji = "🌵",
        Segments = 7,
        Color = Color3.fromRGB(240, 170, 70),
        RarityPattern = { "Common", "Uncommon", "Uncommon", "Uncommon", "Rare", "Rare", "Epic", "Epic" }
    },
    {
        Key = "Jungle",
        Name = "Jungle",
        Emoji = "🌴",
        Segments = 7,
        Color = Color3.fromRGB(40, 160, 80),
        RarityPattern = { "Uncommon", "Uncommon", "Uncommon", "Rare", "Rare", "Epic", "Epic", "Legendary" }
    },
    {
        Key = "Ocean",
        Name = "Ocean",
        Emoji = "🌊",
        Segments = 7,
        Color = Color3.fromRGB(60, 170, 240),
        RarityPattern = { "Uncommon", "Uncommon", "Rare", "Rare", "Epic", "Epic", "Legendary", "Legendary" }
    },
    {
        Key = "Mountains",
        Name = "Mountains",
        Emoji = "🏔️",
        Segments = 8,
        Color = Color3.fromRGB(150, 150, 170),
        RarityPattern = { "Uncommon", "Rare", "Rare", "Epic", "Epic", "Legendary", "Legendary", "Mythic" }
    },
    {
        Key = "Taiga",
        Name = "Taiga",
        Emoji = "🌲",
        Segments = 9,
        Color = Color3.fromRGB(70, 130, 110),
        RarityPattern = { "Rare", "Rare", "Epic", "Epic", "Legendary", "Legendary", "Mythic", "Mythic" }
    },
    {
        Key = "Winter",
        Name = "Winter",
        Emoji = "❄️",
        Segments = 10,
        Color = Color3.fromRGB(190, 230, 255),
        RarityPattern = { "Rare", "Epic", "Epic", "Legendary", "Legendary", "Mythic", "Mythic", "Secret" }
    },
    {
        Key = "PrehistoricForest",
        Name = "Prehistoric Forest",
        Emoji = "🦖",
        Segments = 11,
        Color = Color3.fromRGB(120, 100, 60),
        RarityPattern = { "Epic", "Epic", "Legendary", "Legendary", "Mythic", "Mythic", "Secret", "Secret" }
    },
    {
        Key = "DeepWaters",
        Name = "Deep Waters",
        Emoji = "🐙",
        Segments = 12,
        Color = Color3.fromRGB(30, 60, 140),
        RarityPattern = { "Epic", "Legendary", "Legendary", "Mythic", "Mythic", "Secret", "Secret", "Divine" }
    },
    {
        Key = "Hell",
        Name = "Hell",
        Emoji = "🔥",
        Segments = 14,
        Color = Color3.fromRGB(220, 50, 40),
        RarityPattern = { "Legendary", "Legendary", "Mythic", "Mythic", "Secret", "Secret", "Divine", "Divine" }
    },
    {
        Key = "AncientRuins",
        Name = "Ancient Ruins",
        Emoji = "🏛️",
        Segments = 16,
        Color = Color3.fromRGB(200, 180, 120),
        RarityPattern = { "Legendary", "Mythic", "Mythic", "Secret", "Secret", "Divine", "Divine", "Celestial" }
    },
    {
        Key = "MythicalParadise",
        Name = "Mythical Paradise",
        Emoji = "🌈",
        Segments = 20,
        Color = Color3.fromRGB(255, 150, 255),
        RarityPattern = { "Mythic", "Mythic", "Secret", "Secret", "Divine", "Divine", "Celestial", "Celestial" }
    },
    {
        Key = "ShadowRealm",
        Name = "Shadow Realm",
        Emoji = "🌑",
        Segments = 35,
        Release = "ShadowRealm",
        Color = Color3.fromRGB(150, 110, 235),
        RarityPattern = { "Mythic", "Secret", "Secret", "Divine", "Divine", "Celestial", "Celestial", "Eternal" }
    },
    {
        Key = "HarvestFields",
        Name = "Harvest Fields",
        Emoji = "🌾",
        Segments = 45,
        Release = "HarvestHarbor",
        Color = Color3.fromRGB(240, 160, 50),
        RarityPattern = { "Secret", "Secret", "Divine", "Divine", "Celestial", "Celestial", "Eternal", "Eternal" }
    },
    {
        Key = "PhantomHarbor",
        Name = "Phantom Harbor",
        Emoji = "⚓",
        Segments = 45,
        Release = "HarvestHarbor",
        Color = Color3.fromRGB(80, 210, 200),
        RarityPattern = { "Secret", "Divine", "Divine", "Celestial", "Celestial", "Eternal", "Eternal", "Cosmic" }
    }
}

t1.All = ReleaseConfig.Filter(t2)
t1.ByKey = {}
t1.IndexByKey = {}

local StartGap = t1.StartGap

for v1, v2 in ipairs(t1.All) do
    v2.Index = v1
    v2.Length = v2.Segments * t1.SegmentLength
    v2.StartDistance = StartGap
    StartGap += v2.Length
    t1.ByKey[v2.Key] = v2
    t1.IndexByKey[v2.Key] = v1
end

t1.List = {}

local function refresh() -- line: 85
    -- upvalues: ReleaseConfig (copy), t1 (copy)
    ReleaseConfig.FillUnlocked(t1.List, t1.All)

    local v3 = t1.List[#t1.List]

    t1.TotalDistance = v3 and v3.StartDistance + v3.Length or t1.StartGap
end

ReleaseConfig.FillUnlocked(t1.List, t1.All)

local v5 = t1.List[#t1.List]

t1.TotalDistance = v5 and v5.StartDistance + v5.Length or t1.StartGap
ReleaseConfig.OnChanged(refresh)

function t1.IsPlayable(p1) -- line: 94
    -- upvalues: t1 (copy)
    return p1 ~= nil and p1.Index <= #t1.List
end

function t1.ProgressForDistance(p2) -- line: 103
    -- upvalues: t1 (copy)
    local List = t1.List

    if not (p2 <= List[1].StartDistance) then
        for i = #List, 1, -1 do
            local v7 = List[i]

            if v7.StartDistance <= p2 then
                local v8 = (p2 - v7.StartDistance) / v7.Length

                return i - 1 + math.min(v8, 1)
            end
        end
    end

    return 0
end

function t1.Get(p3) -- line: 115
    -- upvalues: t1 (copy)
    return t1.List[p3]
end

function t1.Count() -- line: 119
    -- upvalues: t1 (copy)
    return #t1.List
end

return t1
