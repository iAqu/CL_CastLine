-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Debris")
game:GetService("Lighting")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("ServerScriptService")
game:GetService("ServerStorage")
game:GetService("Workspace")

local v1 = require(ReplicatedStorage.Packages.Trove).new()
local v2 = false

return {
    StartEvent = function(_, _) -- StartEvent | line: 26
        -- upvalues: v1 (copy), v2 (ref)
        v1:Clean()
        v2 = true
    end,
    StopEvent = function(_) -- StopEvent | line: 31
        -- upvalues: v1 (copy), v2 (ref)
        v1:Clean()
        v2 = false
    end
}
