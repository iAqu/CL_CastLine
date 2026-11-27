-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Menus = require(script.Parent.Parent.UI.Menus)
local RodShop = require(script.Parent.Parent.UI.RodShop)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}

local function tutorialDone() -- line: 19
    -- upvalues: Config (copy), LocalPlayer (copy)
    return (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone
end

local function refresh() -- line: 23
    -- upvalues: Config (copy), LocalPlayer (copy), t2 (copy)
    local v1 = (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone

    for _, v2 in t2 do
        v2.Enabled = v1
    end
end

local function addPrompt(p1) -- line: 30
    -- upvalues: Config (copy), Menus (copy), RodShop (copy), LocalPlayer (copy), t2 (copy)
    local v3 = p1:IsA("Model") and p1.PrimaryPart
    local ProximityPrompt, v4

    if not v3 or v3:FindFirstChild("FeedbackPrompt") then
        return
    else
        ProximityPrompt = Instance.new("ProximityPrompt")
        ProximityPrompt.Name = "FeedbackPrompt"
        ProximityPrompt.ActionText = "Send Feedback"
        ProximityPrompt.ObjectText = "Mailbox"
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt.MaxActivationDistance = 7
        ProximityPrompt.RequiresLineOfSight = false
        v4 = (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone
    end

    ProximityPrompt.Enabled = v4
    ProximityPrompt.Triggered:Connect(function() -- line: 44
        -- upvalues: Menus (copy), RodShop (copy)
        local v6 = RodShop.isOpen()
        local v7

        if v6 then
            RodShop.close()
            v7 = RodShop.isOpen()
        end

        if not v6 or not v7 then
            Menus.open("Feedback", "Mailbox")
        end
    end)
    ProximityPrompt.Parent = v3
    table.insert(t2, ProximityPrompt)
end

function t1.init() -- line: 58
    -- upvalues: LocalPlayer (copy), refresh (copy), addPrompt (copy)
    LocalPlayer:GetAttributeChangedSignal("Tutorial"):Connect(refresh)

    local Plots = workspace:WaitForChild("Map"):WaitForChild("World1"):WaitForChild("Plots")

    local function watch(p2) -- line: 61
        -- upvalues: addPrompt (copy)
        local Mailbox = p2:FindFirstChild("Mailbox")

        if Mailbox then
            addPrompt(Mailbox)
        end

        p2.ChildAdded:Connect(function(p3) -- line: 66
            -- upvalues: addPrompt (copy)
            if p3.Name == "Mailbox" then
                task.defer(addPrompt, p3)
            end
        end)
    end

    Plots.ChildAdded:Connect(watch)

    for _, child in Plots:GetChildren() do
        local Mailbox = child:FindFirstChild("Mailbox")

        if Mailbox then
            addPrompt(Mailbox)
        end

        child.ChildAdded:Connect(function(p4) -- line: 66
            -- upvalues: addPrompt (copy)
            if p4.Name == "Mailbox" then
                task.defer(addPrompt, p4)
            end
        end)
    end
end

return t1
