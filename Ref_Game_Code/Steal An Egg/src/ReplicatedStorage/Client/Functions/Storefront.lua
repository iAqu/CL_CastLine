-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PurchaseSession = require(ReplicatedStorage.Client.Functions.PurchaseSession)

return {
    Prompt = function(p1, p2, p3) -- Prompt | line: 11
        -- upvalues: PurchaseSession (copy)
        PurchaseSession.Request(p1, p2, p3)
    end
}
