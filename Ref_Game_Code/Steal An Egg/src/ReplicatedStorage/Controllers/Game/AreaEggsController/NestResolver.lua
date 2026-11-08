-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AreaEggSlotIdentity = require(ReplicatedStorage.Shared.Util.AreaEggSlotIdentity)

require(ReplicatedStorage.Shared.Types.AreaEggs)

local t = require(ReplicatedStorage.Packages.t)
local World = Workspace.World

assert(World:IsA("Folder"), "Workspace.World must be a Folder")

local Areas = World.Areas

assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

local GuardAreas = Areas.GuardAreas

assert(GuardAreas:IsA("Folder"), "Workspace.World.Areas.GuardAreas must be a Folder")

return {
    Resolve = function(p1) -- Resolve | line: 42
        -- upvalues: AreaEggSlotIdentity (copy), t (copy), GuardAreas (copy)
        t.strict(t.string)(p1.AreaId)
        t.strict(t.string)(p1.NestId)

        local v1 = GuardAreas[p1.AreaId]

        assert(v1:IsA("Model"), (("Guard area %* must be a Model"):format(p1.AreaId)))

        return AreaEggSlotIdentity.NestFor(v1, p1.NestId)
    end
}
