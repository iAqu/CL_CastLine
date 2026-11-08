-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

return require(ReplicatedStorage.Shared.Utils.CmdrToolkit).Command(require(script.Actions), {
    Name = "raceRally",
    Description = "Race mini-event QA levers on this server: `race <action> ...`. Player arguments default to you.",
    Group = "Admin",
    ActionDescription = "status | trophies | nitro | wins | unlock | lock | unclaim | restock | reset | award | start | stop",
    Aliases = { "race", "rr" }
})
