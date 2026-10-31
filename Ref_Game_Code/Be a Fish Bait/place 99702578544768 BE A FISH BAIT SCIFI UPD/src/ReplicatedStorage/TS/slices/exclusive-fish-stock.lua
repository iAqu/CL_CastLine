-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    exclusiveFishStockSlice = createProducer({}, {
        exclusiveFishStockUpdated = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.fishName] = {
                remainingStock = p2.remainingStock,
                reserved = p2.reserved,
                sold = p2.sold,
                timeUpdated = p2.timeUpdated,
                totalStock = p2.totalStock
            }
        end)
    })
}
