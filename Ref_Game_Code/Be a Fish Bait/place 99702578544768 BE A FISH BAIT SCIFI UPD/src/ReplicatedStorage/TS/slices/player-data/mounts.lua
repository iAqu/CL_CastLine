-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v5 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = {
            activeMountName = p2.data.mounts.activeMountName,
            isMounted = p2.data.mounts.isMounted,
            ownedMountNames = p2.data.mounts.ownedMountNames or {}
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 20
        p3[p4.userId] = nil
    end),
    mountObtained = produceWrapper(function(p5, p6) -- line: 25
        -- upvalues: includesOriginal (copy), push (copy)
        local v2 = p5[p6.userId]

        if not v2 or includesOriginal(v2.ownedMountNames, p6.mountName) then
            return nil
        end

        push(v2.ownedMountNames, p6.mountName)

        if v2.activeMountName == nil then
            v2.activeMountName = p6.mountName
        end
    end),
    mountEquipped = produceWrapper(function(p7, p8) -- line: 40
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        v3.activeMountName = p8.mountName
    end),
    mountToggled = produceWrapper(function(p9, p10) -- line: 49
        local v4 = p9[p10.userId]

        if not v4 then
            return nil
        end

        v4.isMounted = p10.isMounted
    end)
})

v5:getActions()

return {
    mountsSlice = v5
}
