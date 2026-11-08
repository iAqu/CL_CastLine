-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ShopNavigation = require(ReplicatedStorage.Client.ShopNavigation)
local LimitedTimePopups = require(ReplicatedStorage.Data.LimitedTimePopups)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local LimitedTimePopupsUI = Players.LocalPlayer.PlayerGui:WaitForChild("LimitedTimePopupsUI")

local function FindRootFrame(p1) -- line: 23
    -- upvalues: LimitedTimePopupsUI (copy), FindRootFrame (copy)
    if p1.Parent == LimitedTimePopupsUI or not p1.Parent then
        return p1
    end

    return FindRootFrame(p1.Parent)
end

local function toDHMS(p2) -- line: 31
    if p2 > 86400 then
        return string.format("%id %ih %02im %02is", p2 / 86400, p2 / 3600 % 24, p2 / 60 % 60, p2 % 60)
    end

    if p2 > 3600 then
        return string.format("%ih %02im %02is", p2 / 3600 % 24, p2 / 60 % 60, p2 % 60)
    end

    return string.format("%02im %02is", p2 / 60 % 60, p2 % 60)
end

return {
    Start = function() -- Start | line: 61
        -- upvalues: Remotes (copy), ShopNavigation (copy), LimitedTimePopups (copy), ButtonFX (copy), GamepadBindings (copy), LimitedTimePopupsUI (copy), FindRootFrame (copy), toDHMS (copy)
        Remotes.LimitedTimePopups.ShowLimitedTimePopup.OnClientEvent:Connect(function(p3) -- line: 62
            -- upvalues: LimitedTimePopupsUI (copy)
            local v1 = LimitedTimePopupsUI:FindFirstChild(p3)

            if v1 then
                if v1:FindFirstChild("Animation") then
                    v1:SetAttribute("Open", true)
                else
                    v1.Visible = true
                end
            end
        end)

        for _, descendant in LimitedTimePopupsUI:GetDescendants() do
            if descendant:IsA("GuiButton") and descendant.Name == "Close" then
                ButtonFX(descendant, 1.08, function() -- line: 76
                    -- upvalues: descendant (copy), LimitedTimePopupsUI (copy), FindRootFrame (copy)
                    local v2 = descendant

                    if descendant.Parent ~= LimitedTimePopupsUI and descendant.Parent then
                        v2 = FindRootFrame(descendant.Parent)
                    end

                    if v2:FindFirstChild("Animation") then
                        v2:SetAttribute("Open", false)
                    else
                        v2.Visible = false
                    end
                end)
                GamepadBindings.Inspect(descendant)
            elseif descendant:IsA("GuiButton") and descendant:GetAttribute("Nav") == "Shop" then
                ButtonFX(descendant, 1.08, function() -- line: 86
                    -- upvalues: descendant (copy), ShopNavigation (copy), LimitedTimePopupsUI (copy), FindRootFrame (copy)
                    local v3 = descendant

                    if descendant.Parent ~= LimitedTimePopupsUI and descendant.Parent then
                        v3 = FindRootFrame(descendant.Parent)
                    end

                    v3.Visible = false
                    v3:SetAttribute("Open", nil)
                    ShopNavigation.Open("Featured")
                end)
                GamepadBindings.Inspect(descendant)
            elseif descendant:IsA("TextLabel") and descendant.Name == "Timer" then
                local v5 = LimitedTimePopups[(if descendant.Parent == LimitedTimePopupsUI then descendant elseif descendant.Parent then FindRootFrame(descendant.Parent) else descendant).Name]

                if v5 then
                    if os.time() > v5.EndTime then
                        descendant.Text = "LAST CHANCE!"
                    else
                        task.spawn(function() -- line: 103
                            -- upvalues: descendant (copy), v5 (copy), toDHMS (copy)
                            while true do
                                task.wait(1)

                                local v6 = v5.EndTime - os.time()
                                local v7 = v6 > 0
                                local v8 = if v7 then toDHMS(v6) else nil

                                descendant.Text = if not v7 or not v8 then "LAST CHANCE!" else v8
                            end
                        end)
                    end
                end
            end
        end
    end
}
