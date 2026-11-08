-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Main = require(script.Parent.BackpackController.Main)
local v1 = GUI.Backpack()
local v2 = false
local v3

return {
    SetLocked = function(p1) -- SetLocked | line: 32
        -- upvalues: HiddenUIHandler (copy), Main (copy), v1 (copy), v2 (ref), v3 (ref)
        if v2 == p1 then
            return
        end

        v2 = p1

        if p1 then
            v3 = Main:GetBackpackEnabled()
            Main:SetBackpackEnabled(false)
            v1.Enabled = false
        else
            local v4 = v3

            v3 = nil

            if v4 ~= nil then
                Main:SetBackpackEnabled(v4)

                if v4 and not HiddenUIHandler.IsHidden() then
                    v1.Enabled = true
                end
            end
        end
    end
}
