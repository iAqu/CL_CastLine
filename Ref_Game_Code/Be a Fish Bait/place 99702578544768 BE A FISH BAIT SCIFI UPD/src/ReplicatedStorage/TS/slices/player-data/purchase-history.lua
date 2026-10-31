-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push, remove = v1.produceWrapper, v1.push, v1.remove
local v20 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        local userId = p2.userId
        local purchaseHistory = p2.data.purchaseHistory
        local v2 = table.create(#purchaseHistory)

        local function v3(p3) -- line: 16
            local v4 = table.clone(p3)

            setmetatable(v4, nil)
            v4.hasBeenSavedInDatastore = true

            return v4
        end

        for v5, v6 in purchaseHistory do
            local _ = v5 - 1
            local v7 = table.clone(v6)

            setmetatable(v7, nil)
            v7.hasBeenSavedInDatastore = true
            v2[v5] = v7
        end

        p1[userId] = v2
    end),
    playerLeft = produceWrapper(function(p4, p5) -- line: 28
        p4[p5.userId] = nil
    end),
    receiptProcessed = produceWrapper(function(p6, p7) -- line: 33
        -- upvalues: push (copy)
        local v8 = p6[p7.userId]

        if v8 == nil then
            return nil
        end

        local v9

        for v10, v11 in v8 do
            local _ = v10 - 1

            if v11.purchaseId == p7.purchaseId == true then
                v9 = v11
                break
            end

            v9 = nil
        end

        if v9 then
            return nil
        end

        push(v8, {
            hasBeenSavedInDatastore = false,
            productId = p7.productId,
            purchaseId = p7.purchaseId,
            timeBought = p7.timeBought
        })
    end),
    receiptForceSaved = produceWrapper(function(p8, p9) -- line: 63
        local v12 = p8[p9.userId]

        if v12 == nil then
            return nil
        end

        local v13

        for v14, v15 in v12 do
            local _ = v14 - 1

            if v15.purchaseId == p9.purchaseId == true then
                v13 = v15
                break
            end

            v13 = nil
        end

        if v13 == nil then
            return nil
        end

        v13.hasBeenSavedInDatastore = true
    end),
    receiptRemoved = produceWrapper(function(p10, p11) -- line: 88
        -- upvalues: remove (copy)
        local v16 = p10[p11.userId]

        if not v16 then
            return nil
        end

        local n1 = -1

        for v17, v18 in v16 do
            local _ = v17 - 1

            if v18.purchaseId == p11.purchaseId == true then
                n1 = v17 - 1
                break
            end
        end

        if n1 == -1 then
            return nil
        end

        remove(v16, n1)
    end),
    gamepassAlreadyOwnedReimbursed = produceWrapper(function(p12, p13) -- line: 113
        -- upvalues: push (copy)
        local v19 = p12[p13.userId]

        if not v19 then
            return nil
        end

        push(v19, {
            hasBeenSavedInDatastore = false,
            productId = p13.productId,
            purchaseId = p13.customPurchaseId,
            timeBought = p13.timeReimbursed
        })
    end)
})

v20:getActions()

return {
    purchaseHistorySlice = v20
}
