-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local MarketplaceService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MarketplaceService
local atom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom
local getAllStorePriceTargets = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getAllStorePriceTargets

local function cacheKey(p1, p2) -- line: 8
    return (("%*:%*"):format(p2.Name, p1))
end

local function withEntry(p3, p4, p5) -- line: 11
    local t1 = {}

    for v1, v2 in p3 do
        t1[v1] = v2
    end

    t1[p4] = p5

    return t1
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 41
        return "ProductPriceController"
    end
})

self.__index = self

function self.new(...) -- line: 46
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p6) -- line: 50
    -- upvalues: atom (copy)
    p6.priceCache = atom({})
    p6._fetchingKeys = {}
end

function self.onStart(p7) -- line: 54
    -- upvalues: getAllStorePriceTargets (copy)
    for _, v5 in getAllStorePriceTargets() do
        p7:_fetch(v5.id, v5.infoType)
    end
end

function self.getPrice(p8, p9, p10) -- line: 59
    local v6 = p8.priceCache()[("%*:%*"):format(p10.Name, p9)]

    return if (if v6 == nil then v6 else v6.status) == "loaded" then v6.price else nil
end

function self.requestPrice(p11, p12, p13) -- line: 69
    local v7 = p11.priceCache()[("%*:%*"):format(p13.Name, p12)]
    local v8 = (if v7 == nil then v7 else v7.status) == "loaded"

    if not v8 then
        v8 = (if v7 == nil then v7 else v7.status) == "loading"
    end

    if v8 then
        return nil
    end

    p11:_fetch(p12, p13)
end

function self._fetch(p14, p15, p16) -- line: 90
    -- upvalues: MarketplaceService (copy), withEntry (copy)
    local v9 = ("%*:%*"):format(p16.Name, p15)

    if p14._fetchingKeys[v9] ~= nil then
        return nil
    end

    p14._fetchingKeys[v9] = true
    p14.priceCache(function(p17) -- line: 96
        -- upvalues: v9 (copy), withEntry (copy)
        return (withEntry(p17, v9, {
            status = "loading"
        }))
    end)
    task.spawn(function() -- line: 101
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), v9 (copy), MarketplaceService (copy), withEntry (copy)
        local function v10() -- line: 102
            -- upvalues: p15 (copy), p16 (copy), MarketplaceService (copy)
            return MarketplaceService:GetProductInfo(p15, p16)
        end

        local ok, result = pcall(v10)

        p14._fetchingKeys[v9] = nil

        local PriceInRobux = if ok then result.PriceInRobux else nil

        p14.priceCache(function(p18) -- line: 107
            -- upvalues: PriceInRobux (copy), v9 (copy), withEntry (copy)
            return (withEntry(p18, v9, if PriceInRobux == nil then {
                status = "failed"
            } else {
                status = "loaded",
                price = PriceInRobux
            }))
        end)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/product-price-controller@ProductPriceController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ProductPriceController = self
}
