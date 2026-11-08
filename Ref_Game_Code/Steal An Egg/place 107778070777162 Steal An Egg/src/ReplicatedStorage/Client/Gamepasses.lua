-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gamepasses = require(ReplicatedStorage.Data.Gamepasses)
local Save = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Save"))
local t1 = {
    Owns = function(p1, p2) -- Owns | line: 14
        -- upvalues: Players (copy), Gamepasses (copy), Save (copy)
        local v1 = Gamepasses.Directory[p1]

        if v1 == nil then
            error(("\"%*\" is not a gamepass"):format((tostring(p1))), 2)
        end

        local v2 = Save.Await(p2 or Players.LocalPlayer)

        if v2 == nil then
            return false
        end

        local Gamepasses2 = v2.Gamepasses

        if typeof(Gamepasses2) == "table" then
            return Gamepasses2[v1.Name] == true
        end

        return false
    end
}

return table.freeze(t1)
