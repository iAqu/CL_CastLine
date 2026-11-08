-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local Marketplace = require(ReplicatedStorage.Shared.Utils.Marketplace)
local Save = require(ReplicatedStorage.Shared.Save)
local StarBundles = require(ReplicatedStorage.Data.StarBundles)
local StarHandlerFlags = require(ReplicatedStorage.Shared.Flags.StarHandlerFlags)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local t1 = {
    "StarsSectionTitle",
    "DailyStockLabel",
    "Cards",
    "RestockTimer"
}
local v1 = false
local connection
local t2 = {}

local function frame() -- line: 37
    -- upvalues: GUI (copy)
    return GUI.Shop():FindFirstChild("Frame")
end

local function list() -- line: 41
    -- upvalues: GUI (copy)
    local Frame = GUI.Shop():FindFirstChild("Frame")

    return Frame and Frame:FindFirstChild("ScrollingFrame")
end

local function cards() -- line: 46
    -- upvalues: GUI (copy)
    local Frame = GUI.Shop():FindFirstChild("Frame")
    local ScrollingFrame = Frame and Frame:FindFirstChild("ScrollingFrame")
    local Cards = ScrollingFrame and ScrollingFrame:FindFirstChild("Cards")
    local t3 = {}

    if Cards then
        for _, child in Cards:GetChildren() do
            if child:IsA("GuiObject") and child:GetAttribute("Bundle") ~= nil then
                table.insert(t3, child)
            end
        end
    end

    table.sort(t3, function(p1, p2) -- line: 57
        return p1.LayoutOrder < p2.LayoutOrder
    end)

    return t3
end

local function bundleFor(p3) -- line: 63
    -- upvalues: StarBundles (copy)
    for _, v2 in StarBundles.Bundles do
        if v2.Key == p3 then
            return v2
        end
    end

    return nil
end

local function priceLabel(p4) -- line: 72
    local Btns = p4:FindFirstChild("Btns")
    local Buy = Btns and Btns:FindFirstChild("Buy")
    local Price = Buy and Buy:FindFirstChild("Price")

    return if Price and Price:IsA("TextLabel") then Price else nil
end

local function refreshPrices() -- line: 79
    -- upvalues: Marketplace (copy), StarBundles (copy), cards (copy)
    for _, v3 in cards() do
        local Bundle = v3:GetAttribute("Bundle")
        local v4 = false
        local v5

        for _, v6 in StarBundles.Bundles do
            if v6.Key == Bundle then
                v5 = v6
                v4 = true
                break
            end
        end

        if not v4 then
            v5 = nil
        end

        local Btns = v3:FindFirstChild("Btns")
        local Buy = Btns and Btns:FindFirstChild("Buy")
        local Price = Buy and Buy:FindFirstChild("Price")

        if not (Price and Price:IsA("TextLabel")) then
            Price = nil
        end

        if v5 and Price then
            Price.Text = "..."

            local spawn = task.spawn
            local v7 = v5
            local Price2 = Price

            spawn(function() -- line: 85
                -- upvalues: v7 (copy), Price2 (copy), Marketplace (copy), StarBundles (copy)
                local v8 = Marketplace.Price(StarBundles.ProductIdFor(v7), Enum.InfoType.Product)

                if v8 ~= nil then
                    Price2.Text = "" .. tostring(v8)
                end
            end)
        end
    end
end

local function clock(p5) -- line: 96
    local v10 = math.max(0, (math.floor(p5)))
    local v11 = v10 // 86400
    local v12 = v10 // 3600 % 24
    local v13 = v10 // 60 % 60
    local v14 = v10 % 60

    if v11 > 0 then
        return (("%*d %*hr"):format(v11, v12))
    end

    if v12 > 0 then
        return (("%*hr %*m"):format(v12, v13))
    end

    if v13 > 0 then
        return (("%*m %*s"):format(v13, v14))
    end

    return (("%*s"):format(v14))
end

local function refreshStock() -- line: 110
    -- upvalues: Workspace (copy), GUI (copy), Save (copy), StarBundles (copy), clock (copy)
    local Frame = GUI.Shop():FindFirstChild("Frame")
    local ScrollingFrame = Frame and Frame:FindFirstChild("ScrollingFrame")

    if ScrollingFrame == nil then
        return
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v15 = Save.Peek()
    local v16 = StarBundles.Remaining(if v15 then v15.MountStarStock else nil, ServerTimeNow)
    local DailyStockLabel = ScrollingFrame:FindFirstChild("DailyStockLabel")

    if DailyStockLabel and DailyStockLabel:IsA("TextLabel") then
        DailyStockLabel.Text = ("Weekly Stock: %*/%*"):format(v16, (StarBundles.WeeklyLimit()))
    end

    local RestockTimer = ScrollingFrame:FindFirstChild("RestockTimer")

    if RestockTimer and RestockTimer:IsA("TextLabel") then
        RestockTimer.Text = ("Restocks in %*"):format((clock(StarBundles.NextRestockAt(ServerTimeNow) - ServerTimeNow)))
    end
end

local function tick() -- line: 128
    -- upvalues: RunService (copy), Tabs (copy), connection (ref), refreshStock (copy)
    if not connection then
        local n1 = 1

        connection = RunService.Heartbeat:Connect(function(p6) -- line: 133
            -- upvalues: n1 (ref), Tabs (copy), connection (ref), refreshStock (copy)
            if Tabs.IsActive("Shop") then
                n1 += p6

                if not (n1 < 1) then
                    n1 = 0
                    refreshStock()
                end
            elseif connection then
                connection:Disconnect()
                connection = nil
            end
        end)
    end
end

local function present() -- line: 150
    -- upvalues: GUI (copy), StarHandlerFlags (copy), t1 (copy)
    local v17 = StarHandlerFlags.ShouldReveal()
    local Frame = GUI.Shop():FindFirstChild("Frame")
    local ScrollingFrame = Frame and Frame:FindFirstChild("ScrollingFrame")

    if ScrollingFrame then
        for _, v18 in t1 do
            local v19 = ScrollingFrame:FindFirstChild(v18)

            if v19 and v19:IsA("GuiObject") then
                v19.Visible = v17
            end
        end
    end

    local Frame2 = GUI.Shop():FindFirstChild("Frame")
    local ButtonsHolder = Frame2 and Frame2:FindFirstChild("ButtonsHolder")
    local Stars = ButtonsHolder and ButtonsHolder:FindFirstChild("Stars")

    if Stars and Stars:IsA("GuiObject") then
        Stars.Visible = v17
    end
end

local function wire() -- line: 169
    -- upvalues: ButtonFX (copy), StarBundles (copy), Storefront (copy), cards (copy)
    for _, v20 in cards() do
        local Bundle = v20:GetAttribute("Bundle")
        local v21 = false
        local v22

        for _, v23 in StarBundles.Bundles do
            if v23.Key == Bundle then
                v22 = v23
                v21 = true
                break
            end
        end

        if not v21 then
            v22 = nil
        end

        local Title = v20:FindFirstChild("Title")

        if v22 and Title and Title:IsA("TextLabel") then
            if v22.Count == 1 then
                Title.Text = "1 STAR"
            else
                Title.Text = ("%* STARS"):format(v22.Count)
            end
        end

        local Btns = v20:FindFirstChild("Btns")
        local Buy = Btns and Btns:FindFirstChild("Buy")

        if v22 and Buy and Buy:IsA("GuiButton") then
            local v24 = StarBundles.ProductIdFor(v22)

            ButtonFX(Buy, nil, function() -- line: 180
                -- upvalues: v24 (copy), Storefront (copy)
                Storefront.Prompt(v24, true)
            end)
        end
    end
end

function t2.Initialize() -- line: 191
    -- upvalues: RunService (copy), Save (copy), StarHandlerFlags (copy), Tabs (copy), v1 (ref), connection (ref), refreshPrices (copy), refreshStock (copy), present (copy), wire (copy)
    if v1 then
        return
    end

    v1 = true
    wire()
    present()
    refreshStock()
    StarHandlerFlags.Open.Changed:Connect(present)
    StarHandlerFlags.ForceRevealed.Changed:Connect(present)
    StarHandlerFlags.WeeklyLimit.Changed:Connect(refreshStock)
    Tabs.Activated:Connect(function(p7) -- line: 202
        -- upvalues: RunService (copy), Tabs (copy), connection (ref), refreshPrices (copy), refreshStock (copy)
        if p7 ~= "Shop" then
            return
        end

        refreshPrices()
        refreshStock()

        if connection then
            return
        end

        local n2 = 1

        connection = RunService.Heartbeat:Connect(function(p8) -- line: 133
            -- upvalues: n2 (ref), Tabs (copy), connection (ref), refreshStock (copy)
            if Tabs.IsActive("Shop") then
                n2 += p8

                if not (n2 < 1) then
                    n2 = 0
                    refreshStock()
                end
            elseif connection then
                connection:Disconnect()
                connection = nil
            end
        end)
    end)
    Save.Watch("MountStarStock"):Connect(function() -- line: 209
        -- upvalues: refreshStock (copy)
        refreshStock()
    end)
    task.spawn(function() -- line: 212
        -- upvalues: Save (copy), refreshStock (copy)
        Save.Await()
        refreshStock()
    end)
end

function t2.Open() -- line: 218
    -- upvalues: ReplicatedStorage (copy), t2 (copy)
    t2.Initialize()
    require(ReplicatedStorage.Client.ShopNavigation).Open("Stars")
end

function t2.Close() -- line: 224
    -- upvalues: Tabs (copy)
    if Tabs.IsActive("Shop") then
        Tabs.Deactivate()
    end
end

return t2
