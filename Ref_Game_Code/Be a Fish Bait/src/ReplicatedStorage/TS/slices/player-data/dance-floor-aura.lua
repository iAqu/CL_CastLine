-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v2 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 8
        local userId = p2.userId
        local t3 = {
            buffExpiresAt = p2.data.danceFloorAura.buffExpiresAt
        }
        local ticketMultiplierExpiresAt = p2.data.danceFloorAura.ticketMultiplierExpiresAt

        t3.ticketMultiplierExpiresAt = if ticketMultiplierExpiresAt == nil then 0 else ticketMultiplierExpiresAt
        p1[userId] = t3
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 22
        p3[p4.userId] = nil
    end),
    danceFloorAuraGranted = produceWrapper(function(p5, p6) -- line: 27
        local v1 = p5[p6.userId]

        if not v1 then
            return nil
        end

        v1.buffExpiresAt = p6.buffExpiresAt

        if p6.ticketMultiplierExpiresAt ~= nil then
            v1.ticketMultiplierExpiresAt = p6.ticketMultiplierExpiresAt
        end
    end)
})

v2:getActions()

return {
    danceFloorAuraSlice = v2
}
