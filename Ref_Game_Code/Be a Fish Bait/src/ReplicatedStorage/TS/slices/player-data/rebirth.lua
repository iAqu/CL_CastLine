-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v4 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 7
        p1[p2.userId] = p2.data.rebirth
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 13
        p3[p4.userId] = nil
    end),
    rebirthCountUpdated = produceWrapper(function(p5, p6) -- line: 18
        local v1 = p5[p6.userId]

        if v1 then
            v1.rebirthCount = p6.count
        end
    end),
    currentBestZoneUpdated = produceWrapper(function(p7, p8) -- line: 26
        local v2 = p7[p8.userId]

        if v2 then
            v2.currentBestZone = p8.zone
        end
    end),
    previousRebirthBestZoneUpdated = produceWrapper(function(p9, p10) -- line: 34
        local v3 = p9[p10.userId]

        if v3 then
            v3.previousRebirthBestZone = p10.zone
        end
    end)
})

v4:getActions()

return {
    rebirthSlice = v4
}
