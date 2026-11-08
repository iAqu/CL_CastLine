-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarHandlerFlags = require(ReplicatedStorage.Shared.Flags.StarHandlerFlags)
local UnixTimestamp = DateTime.fromUniversalTime(2026, 10, 17, 15).UnixTimestamp
local t1 = {
    SoldOutMessage = "No more stock!",
    Bundles = {
        {
            Key = "StarBundle1",
            Count = 1,
            ProductId = 3717079594,
            DevProductId = 3717079602
        },
        {
            Key = "StarBundle3",
            Count = 3,
            ProductId = 3717079596,
            DevProductId = 3717079603,
            Badge = "POPULAR"
        },
        {
            Key = "StarBundle10",
            Count = 5,
            ProductId = 3717079601,
            DevProductId = 3717079604,
            Badge = "BEST VALUE"
        }
    }
}

function t1.WeeklyLimit() -- line: 48
    -- upvalues: StarHandlerFlags (copy)
    return StarHandlerFlags.WeeklyLimit:Get()
end

function t1.ProductIdFor(p1) -- line: 52
    if game.GameId == 10650210095 then
        return p1.DevProductId
    end

    return p1.ProductId
end

local function sundayOnOrAfter(p2, p3, p4) -- line: 56
    local UnixTimestamp = DateTime.fromUniversalTime(p2, p3, p4).UnixTimestamp

    return UnixTimestamp + (7 - (UnixTimestamp // 86400 + 4) % 7) % 7 * 86400
end

local function easternOffset(p5) -- line: 62
    local Year = DateTime.fromUnixTimestamp(p5):ToUniversalTime().Year
    local UnixTimestamp = DateTime.fromUniversalTime(Year, 3, 8).UnixTimestamp
    local v1 = UnixTimestamp + (7 - (UnixTimestamp // 86400 + 4) % 7) % 7 * 86400 + 25200
    local UnixTimestamp2 = DateTime.fromUniversalTime(Year, 11, 1).UnixTimestamp
    local v2 = UnixTimestamp2 + (7 - (UnixTimestamp2 // 86400 + 4) % 7) % 7 * 86400 + 21600

    if not (v1 <= p5 and p5 < v2) then
        return -18000
    end

    return -14400
end

function t1.StockPeriod(p6) -- line: 69
    -- upvalues: UnixTimestamp (copy), easternOffset (copy)
    local v5 = math.floor((math.max(p6, UnixTimestamp - 1)))

    return (v5 + easternOffset(v5) - 212400) // 604800
end

function t1.NextRestockAt(p7) -- line: 74
    -- upvalues: t1 (copy), easternOffset (copy)
    local v6 = (t1.StockPeriod(p7) + 1) * 604800 + 212400

    for _, v7 in { -14400, -18000 } do
        if easternOffset(v6 - v7) == v7 then
            return v6 - v7
        end
    end

    return v6 + 18000
end

function t1.Remaining(p8, p9) -- line: 84
    -- upvalues: t1 (copy)
    local v9 = if typeof(p8) == "table" and p8.Period == t1.StockPeriod(p9) and type(p8.Bought) == "number" then p8.Bought else 0

    return (math.max(t1.WeeklyLimit() - v9, 0))
end

function t1.StockRefusal(p10, p11, p12) -- line: 93
    -- upvalues: t1 (copy)
    local v11 = t1.Remaining(p10, p12)

    if p11 <= v11 then
        return nil
    end

    if v11 <= 0 then
        return t1.SoldOutMessage
    end

    return (("Only %* Star%* left this week!"):format(v11, if v11 == 1 then "" else "s"))
end

return table.freeze(t1)
