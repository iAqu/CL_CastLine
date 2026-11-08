-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Tutorial = ReplicatedStorage.Assets.UI.Tutorial
local v1 = Log.new()

return {
    Clone = function(p1, p2) -- Clone | line: 16
        -- upvalues: Trove (copy), Tutorial (copy)
        local v2 = Trove.new()
        local clone = Tutorial[p1]:Clone()

        clone.Name = p2
        v2:Add(clone)

        return clone, v2
    end,
    Teardown = function(p3, p4) -- Teardown | line: 25
        -- upvalues: v1 (copy)
        local function detach() -- line: 26
            -- upvalues: p3 (copy), p4 (copy), v1 (copy)
            v1:AtTrace():Log(p3)
            p4:Destroy()
        end

        return detach
    end
}
