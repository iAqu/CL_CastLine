-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Globals.Constants)

return {
    Start = function() -- Start | line: 13
        -- upvalues: Players (copy), ReplicatedStorage (copy)
        local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))
        local Remotes = require(game:GetService("ReplicatedStorage").Shared.Remotes)
        local TopBarPlus = require(ReplicatedStorage.Packages.TopBarPlus)
        local v1 = false
        local t2 = {
            [1927880506] = true,
            [2790707588] = true
        }

        local function Initialize() -- line: 31
            -- upvalues: CmdrClient (copy), TopBarPlus (copy), v1 (ref)
            v1 = true
            CmdrClient:SetActivationKeys({
                Enum.KeyCode.F2
            })

            local v2 = TopBarPlus.new()

            v2:setName("Cmdr")
            v2:setImage(102459578526748)
            v2:setRight()
            v2.toggled:Connect(function() -- line: 40
                -- upvalues: CmdrClient (copy)
                CmdrClient:Show()
            end)
        end

        Remotes.StaffConsole.StaffVerdict.OnClientEvent:Connect(function(p1) -- line: 45
            -- upvalues: v1 (ref), t2 (copy), Initialize (copy), Players (copy)
            if not t2[Players.LocalPlayer.UserId] and p1 and not v1 then
                Initialize()
            end
        end)
        Remotes.StaffConsole.ProbeStaffStatus:FireServer()
    end
}
