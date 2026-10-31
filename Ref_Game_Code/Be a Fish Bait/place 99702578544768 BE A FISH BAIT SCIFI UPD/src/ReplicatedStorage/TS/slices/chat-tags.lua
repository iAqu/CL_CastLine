-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push = v1.produceWrapper, v1.push
local v9 = createProducer({}, {
    playerLeft = produceWrapper(function(p1, p2) -- line: 9
        p1[p2.userId] = nil
    end),
    chatTagAdded = produceWrapper(function(p3, p4) -- line: 14
        -- upvalues: push (copy)
        local v2 = p3[p4.userId]

        if not v2 then
            v2 = {
                tags = {}
            }
            p3[p4.userId] = v2
        end

        local v3

        for v4, v5 in v2.tags do
            local _ = v4 - 1

            if v5.name == p4.tag.name == true then
                v3 = v5
                break
            end

            v3 = nil
        end

        if v3 then
            return nil
        end

        push(v2.tags, p4.tag)
    end),
    chatTagRemoved = produceWrapper(function(p5, p6) -- line: 45
        local v6 = p5[p6.userId]

        if not v6 then
            return nil
        end

        local tags = v6.tags
        local t3 = {}
        local n1 = 0

        for v7, v8 in tags do
            local _ = v7 - 1

            if v8.name ~= p6.tagName == true then
                n1 += 1
                t3[n1] = v8
            end
        end

        v6.tags = t3
    end)
})

v9:getActions()

return {
    chatTagsSlice = v9
}
