-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local produceWrapper, push = v1.produceWrapper, v1.push
local defaultTitleId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").defaultTitleId
local t1 = {}

local function getUnlockedTitlesWithDefault(p1) -- line: 13
    -- upvalues: defaultTitleId (copy)
    if p1 == nil then
        return { defaultTitleId }
    end

    if table.find(p1, defaultTitleId) ~= nil then
        return p1
    end

    local t2 = {
        defaultTitleId
    }
    local v2 = #t2

    table.move(p1, 1, #p1, v2 + 1, t2)

    return t2
end

local v7 = createProducer(t1, {
    playerJoined = produceWrapper(function(p2, p3) -- line: 26
        -- upvalues: defaultTitleId (copy), getUnlockedTitlesWithDefault (copy)
        local userId = p3.userId
        local t4 = {
            unlockedTitles = getUnlockedTitlesWithDefault(p3.data.titles.unlockedTitles)
        }
        local equippedTitle = p3.data.titles.equippedTitle

        t4.equippedTitle = if equippedTitle == nil then defaultTitleId else equippedTitle
        t4.seenTitleIds = p3.data.titles.seenTitleIds or {}
        p2[userId] = t4
    end),
    playerLeft = produceWrapper(function(p4, p5) -- line: 41
        p4[p5.userId] = nil
    end),
    titleUnlocked = produceWrapper(function(p6, p7) -- line: 46
        -- upvalues: push (copy)
        local v3 = p6[p7.userId]

        if not v3 then
            return nil
        end

        local unlockedTitles = v3.unlockedTitles
        local titleId = p7.titleId

        if table.find(unlockedTitles, titleId) ~= nil then
            return nil
        end

        push(v3.unlockedTitles, p7.titleId)
    end),
    titleEquipped = produceWrapper(function(p8, p9) -- line: 60
        local v4 = p8[p9.userId]

        if not v4 then
            return nil
        end

        v4.equippedTitle = p9.titleId
    end),
    titleUnequipped = produceWrapper(function(p10, p11) -- line: 69
        local v5 = p10[p11.userId]

        if not v5 then
            return nil
        end

        v5.equippedTitle = nil
    end),
    titlesSeen = produceWrapper(function(p12, p13) -- line: 78
        local v6 = p12[p13.userId]

        if not v6 then
            return nil
        end

        v6.seenTitleIds = p13.seenTitleIds
    end)
})

v7:getActions()

return {
    titlesSlice = v7
}
