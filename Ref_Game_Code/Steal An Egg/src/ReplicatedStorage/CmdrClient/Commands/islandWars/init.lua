-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

return require(ReplicatedStorage.Shared.Utils.CmdrToolkit).Command(require(script.Actions), {
    Name = "islandWars",
    Description = "Cursed Island Wars QA levers on this server: `iw <action> ...`. Player arguments default to you.",
    Group = "Admin",
    ActionDescription = "status | start | stop | skip | win | bots | god | give | wall | crystal",
    Aliases = { "iw" }
})
