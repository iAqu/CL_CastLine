-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trails = require(ReplicatedStorage.Data.Trails)
local Treadmills = require(ReplicatedStorage.Data.Treadmills)

require(script.Parent.ProductTypes)

local Trail = require(script.Parent.Parent.Builders.Trail)
local Treadmill = require(script.Parent.Parent.Builders.Treadmill)
local TreadmillSpeedEquivalent = require(script.Parent.Parent.Builders.TreadmillSpeedEquivalent)
local v1 = table.freeze({
    table.freeze({
        ProductName = "TreadmillSpeed_5Minutes",
        DurationSeconds = 300,
        ProductId = 3612508008
    }),
    table.freeze({
        ProductName = "TreadmillSpeed_30Minutes",
        DurationSeconds = 1800,
        ProductId = 3612508088
    }),
    table.freeze({
        ProductName = "TreadmillSpeed_1Hour",
        DurationSeconds = 3600,
        ProductId = 3612508192
    }),
    table.freeze({
        ProductName = "TreadmillSpeed_4Hours",
        DurationSeconds = 14400,
        ProductId = 3612508244
    })
})
local t1 = {}

for v2, v3 in Treadmills.Directory do
    local ProductId = v3.ProductId

    if type(ProductId) == "number" then
        table.insert(t1, Treadmill(("Treadmill_%*"):format(v2), v2, ProductId))
    end
end

for v5, v6 in Trails.Directory do
    local ProductId = v6.ProductId

    if type(ProductId) == "number" then
        table.insert(t1, Trail(("Trail_%*"):format(v5), v5, ProductId))
    end
end

for _, v8 in v1 do
    assert(v8.ProductId > 0, (("Treadmill speed product \"%*\" must have a positive ProductId"):format(v8.ProductName)))
    table.insert(t1, TreadmillSpeedEquivalent(v8.ProductName, v8.ProductId, v8.DurationSeconds))
end

return table.freeze({
    Records = table.freeze(t1),
    TreadmillSpeedEquivalentOffers = v1
})
