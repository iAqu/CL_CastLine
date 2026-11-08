-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Confetti = require(ReplicatedStorage.Client.UI.VFX.Confetti)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local Hud = require(ReplicatedStorage.Client.Hud)
local FriendRoster = require(ReplicatedStorage.Shared.Modules.FriendRoster)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local FriendsInServerAttribute = FriendRoster.FriendsInServerAttribute
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 22
        -- upvalues: Players (copy), Confetti (copy), GameFlags (copy), Hud (copy), Remotes (copy), FriendsInServerAttribute (copy), LocalPlayer (copy)
        local FriendBoost = Hud.Find("FriendBoost")
        local CurrentBoost = if FriendBoost == nil then nil else FriendBoost:FindFirstChild("CurrentBoost")

        if FriendBoost ~= nil then
            FriendBoost.Visible = false
        end

        local function setBoostVisible(p1) -- line: 33
            -- upvalues: FriendBoost (copy)
            if FriendBoost ~= nil then
                FriendBoost.Visible = p1
            end
        end

        local function onFriendsInGame() -- line: 39
            -- upvalues: FriendBoost (copy)
            if FriendBoost ~= nil then
                FriendBoost.Visible = true
            end
        end

        local function onNoFriends() -- line: 41
            -- upvalues: FriendBoost (copy)
            if FriendBoost ~= nil then
                FriendBoost.Visible = false
            end
        end

        local function updateBoostsDisplay() -- line: 43
            -- upvalues: FriendBoost (copy), CurrentBoost (copy), GameFlags (copy), FriendsInServerAttribute (copy), LocalPlayer (copy)
            local Attribute = LocalPlayer:GetAttribute(FriendsInServerAttribute)

            if typeof(Attribute) ~= "number" or Attribute <= 0 then
                if FriendBoost ~= nil then
                    FriendBoost.Visible = false
                end
            else
                local v4 = math.floor(GameFlags.FriendBoostPercentPerFriend:Get() * math.clamp(Attribute, 0, (GameFlags.FriendBoostCap:Get())))

                if v4 <= 0 then
                    if FriendBoost ~= nil then
                        FriendBoost.Visible = false
                    end
                else
                    if FriendBoost ~= nil then
                        FriendBoost.Visible = true
                    end

                    if CurrentBoost ~= nil then
                        local v5 = string.format("Friend Boost: +%d%%", v4)

                        CurrentBoost.Text = v5

                        local Shadow = CurrentBoost:FindFirstChild("Shadow")

                        if Shadow ~= nil then
                            Shadow.Text = v5
                        end
                    end
                end
            end
        end

        LocalPlayer:GetAttributeChangedSignal(FriendsInServerAttribute):Connect(updateBoostsDisplay)
        updateBoostsDisplay()
        Players.PlayerAdded:Connect(updateBoostsDisplay)
        Players.PlayerRemoving:Connect(updateBoostsDisplay)
        GameFlags.FriendBoostPercentPerFriend.Changed:Connect(updateBoostsDisplay)
        GameFlags.FriendBoostCap.Changed:Connect(updateBoostsDisplay)
        Remotes.Referrals.InviteLanded.OnClientEvent:Connect(function() -- line: 78
            -- upvalues: Confetti (copy)
            Confetti.Burst()
        end)

        return {}
    end
}
