-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Dumbbells = require(ReplicatedStorage:WaitForChild("Shared").Data.Dumbbells)
local DataClient = require(script.Parent.DataClient)
local v1 = Color3.fromRGB(110, 255, 120)
local v2 = Color3.fromRGB(255, 60, 60)
local t1 = {}

t1.Last = nil

local function refresh() -- line: 12
    -- upvalues: Players (copy), Dumbbells (copy), DataClient (copy), t1 (copy), v1 (copy), v2 (copy)
    local LocalPlayer = Players.LocalPlayer
    local v3 = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Plots")

    if v3 then
        for _, child in ipairs(v3:GetChildren()) do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                local TrainingSpot = child:FindFirstChild("TrainingSpot")
                local BuyPad = TrainingSpot and TrainingSpot:FindFirstChild("BuyPad")
                local PriceTag = BuyPad and BuyPad:FindFirstChild("PriceTag")
                local Price = PriceTag and PriceTag:FindFirstChild("Price")
                local v4 = Dumbbells.List[(DataClient.Get("DumbbellTier") or 0) + 1]

                if Price and v4 then
                    local v5 = (DataClient.Get("Cash") or 0) >= v4.price

                    if v5 then
                        Price.TextColor3 = v1
                    else
                        Price.TextColor3 = v2
                    end

                    t1.Last = v5 and "green" or "red"
                end
            end
        end
    end
end

function t1.Init() -- line: 34
    -- upvalues: DataClient (copy), refresh (copy)
    DataClient.Observe("Cash", refresh)
    DataClient.Observe("DumbbellTier", refresh)
    task.spawn(function() -- line: 37
        -- upvalues: refresh (copy)
        while true do
            refresh()
            task.wait(1)
        end
    end)
end

return t1
