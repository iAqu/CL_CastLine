-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push = v1.produceWrapper, v1.push
local v5 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 9
        p1[p2.userId] = p2.data.bundlePurchaseHistory
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 15
        p3[p4.userId] = nil
    end),
    bundlePurchased = produceWrapper(function(p5, p6) -- line: 20
        -- upvalues: push (copy)
        local v2 = p5[p6.userId]

        if not v2 then
            return nil
        end

        push(v2, {
            bundleName = p6.bundleName,
            timePurchased = p6.timePurchased
        })
    end),
    bundleRemoved = produceWrapper(function(p7, p8) -- line: 32
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        local t3 = {}

        for _, v4 in v3 do
            if v4.bundleName ~= p8.bundleName then
                table.insert(t3, v4)
            end
        end

        p7[p8.userId] = t3
    end)
})

v5:getActions()

return {
    bundlePurchaseHistorySlice = v5
}
