-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Confetti = require(ReplicatedStorage.Client.UI.VFX.Confetti)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GUI = require(ReplicatedStorage.Client.GUI)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local Log = require(ReplicatedStorage.Packages.Log)
local Message = require(ReplicatedStorage.Client.Message)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local SpeedPower = require(ReplicatedStorage.Client.RewardFeedback.SpeedPower)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local v1 = ColorSequence.new(Color3.fromRGB(150, 150, 150), Color3.fromRGB(110, 110, 110))

return {
    Start = function() -- Start | line: 33
        -- upvalues: GroupService (copy), Players (copy), Workspace (copy), t (copy), ButtonFX (copy), Confetti (copy), Constants (copy), GUI (copy), TryLock (copy), Log (copy), Message (copy), Remotes (copy), Save (copy), SpeedPower (copy), Tabs (copy), v1 (copy)
        local v2 = Log.new()
        local LocalPlayer = Players.LocalPlayer
        local BuyCash = GUI.GroupReward().Frame.BuyCash
        local Price = BuyCash:FindFirstChild("Price")
        local UIGradient = BuyCash:FindFirstChildOfClass("UIGradient")
        local ProximityPrompt = Workspace.World.GroupReward.ProximityPrompt
        local Text = Price.Text
        local Color = if UIGradient == nil then nil else UIGradient.Color
        local v3 = TryLock()

        assert(ProximityPrompt:IsA("ProximityPrompt"), "Expected GroupReward.ProximityPrompt to be a ProximityPrompt")
        assert(Price ~= nil and Price:IsA("TextLabel"), "FreeGift.Frame.BuyCash.Price must be a TextLabel")

        local function renderClaimState(p1) -- line: 60
            -- upvalues: Price (copy), UIGradient (copy), Text (copy), Color (copy), t (copy), v1 (copy)
            t.strict(t.boolean)(p1)
            Price.Text = if p1 then "CLAIMED!" else Text

            if UIGradient ~= nil and Color ~= nil then
                UIGradient.Color = if p1 then v1 else Color
            end
        end

        local function updateView() -- line: 68
            -- upvalues: Price (copy), UIGradient (copy), Text (copy), Color (copy), t (copy), Save (copy), v1 (copy)
            local v7 = Save.Await()

            if v7 == nil then
                return
            end

            local v8 = v7.ClaimedGroupReward == true

            t.strict(t.boolean)(v8)
            Price.Text = if v8 then "CLAIMED!" else Text

            if UIGradient ~= nil and Color ~= nil then
                UIGradient.Color = if v8 then v1 else Color
            end
        end

        local function invokeClaim(p2) -- line: 77
            -- upvalues: Price (copy), UIGradient (copy), Color (copy), t (copy), Confetti (copy), Message (copy), Remotes (copy), SpeedPower (copy), Tabs (copy), v1 (copy)
            t.strict(t.boolean)(p2)

            local v11, v12, v13 = Remotes.GroupPerk.RedeemPerk:InvokeServer(p2)

            if v11 then
                t.strict(t.number)(v13)

                if Tabs.IsActive("GroupReward") then
                    Tabs.Deactivate()
                end

                t.strict(t.boolean)(true)
                Price.Text = "CLAIMED!"

                if UIGradient ~= nil and Color ~= nil then
                    UIGradient.Color = v1
                end

                Message.Notice("REWARD CLAIMED!")
                Confetti.Burst()
                SpeedPower.Announce(v13)

                return true
            end

            Message.Notice(v12 or "Failed to claim reward!")

            return false
        end

        local function resolveClientMembership() -- line: 98
            -- upvalues: LocalPlayer (copy), GroupService (copy), Constants (copy), Message (copy)
            local function v14() -- line: 100
                -- upvalues: LocalPlayer (copy), Constants (copy)
                return LocalPlayer:IsInGroupAsync(Constants.GROUP_ID)
            end

            local ok, result = pcall(v14)

            if not ok then
                Message.Notice("Failed to verify your group membership!")

                return false, false
            end

            if result then
                return true, true
            end

            local function v15() -- line: 112
                -- upvalues: GroupService (copy), Constants (copy)
                return GroupService:PromptJoinAsync(Constants.GROUP_ID)
            end

            local ok2, result2 = pcall(v15)

            if ok2 then
                if result2 == Enum.GroupMembershipStatus.Joined or result2 == Enum.GroupMembershipStatus.AlreadyMember then
                    return true, true
                end

                if result2 == Enum.GroupMembershipStatus.JoinRequestPending then
                    Message.Notice("Your request to join the group is pending approval.")
                else
                    Message.Notice("You must join the group to claim this reward!")
                end

                return false, false
            end

            Message.Notice("Failed to open the group join prompt!")

            return false, false
        end

        local function onClaimActivated() -- line: 135
            -- upvalues: invokeClaim (copy), resolveClientMembership (copy), Message (copy), Save (copy)
            local v16 = Save.Await()

            if v16 ~= nil then
                if v16.ClaimedGroupReward == true then
                    Message.Notice("You already claimed this reward!")
                else
                    local v17, v18 = resolveClientMembership()

                    if v17 then
                        invokeClaim(v18)
                    end
                end
            else
                Message.WarnGeneric()
            end
        end

        ButtonFX(BuyCash, 1.08, function() -- line: 159
            -- upvalues: v3 (copy), onClaimActivated (copy)
            v3(onClaimActivated)
        end)
        ProximityPrompt.Triggered:Connect(function() -- line: 161
            -- upvalues: Tabs (copy)
            Tabs.Toggle("GroupReward")
        end)

        if Save.IsLoaded() then
            local v19 = Save.Await()

            if v19 ~= nil then
                local v20 = v19.ClaimedGroupReward == true

                t.strict(t.boolean)(v20)
                Price.Text = if v20 then "CLAIMED!" else Text

                if UIGradient ~= nil and Color ~= nil then
                    UIGradient.Color = if v20 then v1 else Color
                end
            end
        else
            Save.Loaded:Connect(updateView)
        end

        Save.WatchFields({ "ClaimedGroupReward" }, updateView)
        v2:AtInfo():Log("Group rewards client initialized")
    end
}
