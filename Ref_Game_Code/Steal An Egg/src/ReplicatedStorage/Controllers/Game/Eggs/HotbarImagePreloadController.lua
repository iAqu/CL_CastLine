-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HotbarImagePreloadController = require(ReplicatedStorage.Client.HotbarImagePreloadController)
local Trove = require(ReplicatedStorage.Packages.Trove)

return {
    Start = function() -- Start | line: 10
        -- upvalues: HotbarImagePreloadController (copy), Trove (copy)
        local v1 = Trove.new()

        v1:Add(HotbarImagePreloadController.new()):Start()
        v1:AttachToInstance(script)
    end
}
