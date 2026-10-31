-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    frostwyrmAnnouncementSlice = createProducer({
        announcement = nil
    }, {
        frostwyrmCaughtAnnounced = produceWrapper(function(p1, p2) -- line: 9
            p1.announcement = {
                exclusiveIndex = p2.exclusiveIndex,
                id = p2.id,
                playerName = p2.playerName
            }
        end)
    })
}
