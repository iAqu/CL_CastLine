-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local NotificationItem = require(ReplicatedStorage.Shared.NotificationItem)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Sparkles = require(ReplicatedStorage.Client.UI.VFX.Sparkles)
local t1 = {
    "Level",
    "Strength"
}
local t2 = {}

local function child(p1, p2) -- line: 25
    local v1 = p1:FindFirstChild(p2)

    assert(v1, (("%* is missing %*"):format(p1:GetFullName(), p2)))

    return v1
end

local function countText(p3) -- line: 31
    -- upvalues: Simple (copy)
    return (("%*x"):format((Simple.FormatCompact(p3))))
end

local function byPriority(p4, p5) -- line: 35
    return p4.Priority < p5.Priority
end

local function describeItem(p6) -- line: 39
    -- upvalues: byPriority (copy)
    local v3 = p6.Description ~= ""
    local t3 = {
        {
            Priority = 40,
            When = v3,
            Row = {
                kind = "body",
                text = p6.Description
            }
        },
        {
            Priority = 20,
            When = true,
            Row = {
                kind = "tier",
                rarity = p6.Rarity
            }
        },
        {
            Priority = 10,
            When = true,
            Row = {
                kind = "heading",
                text = p6.Name
            }
        },
        {
            Priority = 30,
            When = v3,
            Row = {
                kind = "rule"
            }
        }
    }

    table.sort(t3, byPriority)

    local t4 = {}

    for _, v4 in t3 do
        if v4.When then
            table.insert(t4, v4.Row)
        end
    end

    return t4
end

local function applyPresentation(p7, p8, p9, p10) -- line: 57
    -- upvalues: Simple (copy), t1 (copy)
    local Icon = p7:FindFirstChild("Icon")

    assert(Icon, (("%* is missing Icon"):format((p7:GetFullName()))))

    local Quantity = p7:FindFirstChild("Quantity")

    assert(Quantity, (("%* is missing Quantity"):format((p7:GetFullName()))))
    Icon.Image = p9.Icon

    local Amount = p8.Amount

    Quantity.Text = ("%*x"):format((Simple.FormatCompact(Amount)))
    Quantity.Visible = p10.ShowCount ~= false

    for _, v7 in t1 do
        local v8 = p7:FindFirstChild(v7)

        if v8 and v8:IsA("GuiObject") then
            v8.Visible = false
        end
    end
end

local function sparkleWhenPlaced(p11) -- line: 71
    -- upvalues: Sparkles (copy)
    p11:GetPropertyChangedSignal("Parent"):Once(function() -- line: 72
        -- upvalues: p11 (copy), Sparkles (copy)
        if p11.Parent ~= nil then
            task.defer(Sparkles, p11)
        end
    end)
end

function t2.Build(p12, p13) -- line: 79
    -- upvalues: HoverCard (copy), NotificationItem (copy), Sparkles (copy), describeItem (copy), applyPresentation (copy)
    assert(NotificationItem.Schema(p12), "invalid notification item card")
    p13 = p13 or {}

    local v11 = NotificationItem.Describe(p12)
    local Rarity = v11.Rarity
    local clone = Rarity.ItemTemplate:Clone()

    applyPresentation(clone, p12, v11, p13)
    HoverCard.Attach(clone, (describeItem(v11)))

    if p13.Sparkle ~= false then
        Sparkles(clone)
    end

    if Rarity.Rank >= 5 then
        clone:GetPropertyChangedSignal("Parent"):Once(function() -- line: 72
            -- upvalues: clone (copy), Sparkles (copy)
            if clone.Parent ~= nil then
                task.defer(Sparkles, clone)
            end
        end)
    end

    return clone
end

return t2
