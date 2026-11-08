-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local t1 = {
    [true] = 600,
    [false] = 300
}
local t2 = {}
local t3 = {}

local function slotFor(p1, p2) -- line: 23
    -- upvalues: t3 (copy)
    assert(type(p1) == "number", (("marketplace id must be a number, got %*"):format((typeof(p1)))))

    local v3 = ("%*:%*"):format(p2.Value, p1)
    local v4 = t3[v3]

    if v4 == nil then
        v4 = {
            Value = nil,
            Answered = false,
            HoldUntil = 0
        }
        t3[v3] = v4
    end

    return v4
end

local function ask(p3, p4, p5) -- line: 34
    -- upvalues: MarketplaceService (copy), t1 (copy)
    local GetProductInfo = MarketplaceService.GetProductInfo
    local ok, result = pcall(GetProductInfo, MarketplaceService, p4, p5)

    p3.Answered = ok
    p3.HoldUntil = os.clock() + t1[ok]

    if ok then
        p3.Value = result
    else
        warn((("marketplace info unavailable for %* %*: %*"):format(p5.Name, p4, result)))
    end
end

local function trusted(p6, p7, p8) -- line: 45
    -- upvalues: ask (copy)
    if os.clock() >= p6.HoldUntil then
        ask(p6, p7, p8)
    end

    return p6.Answered
end

function t2.Info(p9, p10) -- line: 53
    -- upvalues: slotFor (copy), ask (copy)
    p10 = p10 or Enum.InfoType.Product

    local v6 = slotFor(p9, p10)

    if os.clock() >= v6.HoldUntil then
        ask(v6, p9, p10)
    end

    local _ = v6.Answered

    return v6.Value
end

function t2.Current(p11, p12) -- line: 61
    -- upvalues: slotFor (copy), ask (copy)
    p12 = p12 or Enum.InfoType.Product

    local v8 = slotFor(p11, p12)

    if os.clock() >= v8.HoldUntil then
        ask(v8, p11, p12)
    end

    return if v8.Answered then v8.Value else nil
end

function t2.Price(p13, p14) -- line: 67
    -- upvalues: t2 (copy)
    local v9 = t2.Info(p13, p14)

    if type(v9) == "table" and v9.IsForSale == true then
        local PriceInRobux = v9.PriceInRobux

        if type(PriceInRobux) == "number" then
            return PriceInRobux
        end
    end

    return nil
end

return table.freeze(t2)
