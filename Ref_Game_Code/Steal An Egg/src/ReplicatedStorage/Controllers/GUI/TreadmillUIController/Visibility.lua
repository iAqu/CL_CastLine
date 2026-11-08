-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Hud = require(ReplicatedStorage.Client.Hud)
local Player = require(ReplicatedStorage.Shared.Player)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Main = require(script.Parent.Parent.BackpackController.Main)
local TopBar = GUI.OfflineMoneyInPlot().TopBar
local v1 = GUI.TopBarStandard()
local v2 = GUI.Backpack()
local t1
local v3 = Trove.new()
local t2 = {}

local function IsBackpackVisibilityAllowed() -- line: 45
    -- upvalues: HiddenUIHandler (copy), Main (copy)
    return Main:GetBackpackEnabled() and not HiddenUIHandler.IsHidden()
end

local function UnequipTools() -- line: 50
    -- upvalues: Player (copy)
    local v4 = Player.FindHumanoid()

    if v4 ~= nil then
        v4:UnequipTools()
    end
end

function t2.Apply(p1) -- line: 61
    -- upvalues: CollectionService (copy), HiddenUIHandler (copy), Hud (copy), Player (copy), Main (copy), TopBar (copy), v1 (copy), v2 (copy), t1 (ref), v3 (copy)
    if p1 then
        if t1 == nil then
            t1 = {
                OfflineMoneyInPlotVisible = TopBar.Visible,
                TopBarEnabled = v1.Enabled
            }

            local v5 = Player.FindCharacter()

            if v5 ~= nil then
                v3:Add(v5.ChildAdded:Connect(function(p2) -- line: 71
                    -- upvalues: CollectionService (copy), Player (copy)
                    if p2:IsA("Tool") and not CollectionService:HasTag(p2, "PhoneTool") then
                        local v6 = Player.FindHumanoid()

                        if v6 ~= nil then
                            v6:UnequipTools()
                        end
                    end
                end))
            end
        end

        Main:SetTreadmillPhoneOnlyMode(true)
        Hud.SetTreadmillActive(true)
        TopBar.Visible = false
        v1.Enabled = false

        local v7 = Player.FindHumanoid()

        if v7 ~= nil then
            v7:UnequipTools()
        end
    else
        Hud.SetTreadmillActive(false)
        Main:SetTreadmillPhoneOnlyMode(false)

        local t3 = t1

        v3:Clean()

        if t3 ~= nil then
            v1.Enabled = t3.TopBarEnabled
            TopBar.Visible = t3.OfflineMoneyInPlotVisible
            v2.Enabled = Main:GetBackpackEnabled() and not HiddenUIHandler.IsHidden()
            t1 = nil
        end
    end
end

return t2
