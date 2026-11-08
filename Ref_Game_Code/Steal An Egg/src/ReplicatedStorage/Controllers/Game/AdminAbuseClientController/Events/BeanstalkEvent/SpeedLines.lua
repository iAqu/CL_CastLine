-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local SpeedLines = require(ReplicatedStorage.Client.SpeedLines)

require(ReplicatedStorage.Packages.Trove)

return {
    Run = function(p1, p2) -- Run | line: 18
        -- upvalues: GUI (copy), SpeedLines (copy)
        SpeedLines.Run(p1, GUI.BeanstalkEventUI().SpeedLines, p2)
    end
}
