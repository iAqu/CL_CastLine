-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

return require(ReplicatedStorage.Shared.Utils.CmdrToolkit).Command(require(script.Actions), {
    Name = "theHollow",
    Description = "The Hollow race QA levers on this server: `hollow <action> ...`. Player arguments default to you.",
    Group = "Admin",
    ActionDescription = "status | wins | prizes | unclaim | reset | start | stop",
    Aliases = { "hollow" }
})
