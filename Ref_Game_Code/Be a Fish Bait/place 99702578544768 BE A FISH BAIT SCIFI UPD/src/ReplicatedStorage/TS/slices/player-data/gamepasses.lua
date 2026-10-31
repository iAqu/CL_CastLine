-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push = v1.produceWrapper, v1.push
local v13 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 9
        p1[p2.userId] = p2.data.gamepasses
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 15
        p3[p4.userId] = nil
    end),
    gamepassObtained = produceWrapper(function(p5, p6) -- line: 20
        -- upvalues: push (copy)
        local v2 = p5[p6.userId]

        if not v2 then
            return nil
        end

        local v3

        for v4, v5 in v2 do
            local _ = v4 - 1

            if v5.gamepassName == p6.gamepassName == true then
                v3 = v5
                break
            end

            v3 = nil
        end

        if v3 then
            return nil
        end

        push(v2, {
            gamepassName = p6.gamepassName,
            sourceInfo = p6.sourceInfo,
            timeObtained = p6.timeObtained
        })
    end),
    gamepassAlreadyOwnedReimbursed = produceWrapper(function(p7, p8) -- line: 48
        local v6 = p7[p8.userId]

        if not v6 then
            return nil
        end

        for _, v7 in v6 do
            if v7.sourceInfo.source ~= "store" and v7.gamepassName == p8.gamepassName then
                v7.reimbursementInfo = {
                    status = "reimbursed",
                    timeReimbursed = p8.timeReimbursed
                }
            end
        end
    end),
    gamepassesOwnedSynced = produceWrapper(function(p9, p10) -- line: 67
        -- upvalues: push (copy)
        local v8 = p9[p10.userId]

        if not v8 then
            return nil
        end

        for _, v9 in p10.gamepassNamesOwnedButNotInState do
            ({})[1] = v9

            local v10

            for v11, v12 in v8 do
                local _ = v11 - 1

                if v12.gamepassName == v9 == true then
                    v10 = v12
                    break
                end

                v10 = nil
            end

            if not v10 then
                push(v8, {
                    gamepassName = v9,
                    sourceInfo = {
                        source = "store"
                    },
                    timeObtained = p10.timeSynced
                })
            end
        end
    end)
})

v13:getActions()

return {
    gamepassesSlice = v13
}
