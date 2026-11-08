-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Client.Types.GUI)

local ShopPreview = require(ReplicatedStorage.Client.ShopPreview)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = GUI.Shop()
local ScrollingFrame, ButtonsHolder = v1.Frame.ScrollingFrame, v1.Frame.ButtonsHolder
local v2 = Trove.new()
local v3 = v2:Extend()
local v4
local v5 = Color3.fromRGB(255, 230, 80)
local t1 = {
    "StarsSectionTitle",
    "DailyStockLabel",
    "Cards",
    "RestockTimer"
}
local t2 = {
    Featured = ScrollingFrame.FeaturedSectionTitle,
    Speed = ScrollingFrame.SpeedSectionTitle,
    SpeedProducts = ScrollingFrame.Speed,
    Money = ScrollingFrame.Money
}
local t3 = {
    {
        section = "Featured",
        button = ButtonsHolder.Featured,
        anchor = t2.Featured,
        color = ButtonsHolder.Featured.SectionTitle.TextColor3
    },
    {
        section = "Speed",
        button = ButtonsHolder.Speed,
        anchor = t2.Speed,
        color = ButtonsHolder.Speed.SectionTitle.TextColor3
    },
    {
        section = "Money",
        button = ButtonsHolder.Money,
        anchor = t2.Money,
        color = ButtonsHolder.Money.SectionTitle.TextColor3
    }
}
local StarsSectionTitle = ScrollingFrame:FindFirstChild("StarsSectionTitle")
local Stars = ButtonsHolder:FindFirstChild("Stars")

if StarsSectionTitle and StarsSectionTitle:IsA("GuiObject") and Stars and Stars:IsA("ImageButton") then
    t2.Stars = StarsSectionTitle
    table.insert(t3, 2, {
        section = "Stars",
        button = Stars,
        anchor = StarsSectionTitle,
        color = Stars.SectionTitle.TextColor3
    })
end

local t5 = {}

for _, v6 in t1 do
    local v7 = ScrollingFrame:FindFirstChild(v6)

    if v7 and v7:IsA("GuiObject") then
        t5[v7] = v7.LayoutOrder
    end
end

if Stars and Stars:IsA("GuiObject") then
    t5[Stars] = Stars.LayoutOrder
end

local function maximumScroll() -- line: 90
    -- upvalues: ScrollingFrame (copy)
    return (math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y))
end

local function updateSection() -- line: 97
    -- upvalues: ScrollingFrame (copy), v5 (copy), t3 (copy)
    local v9 = ScrollingFrame.AbsolutePosition.Y + 12
    local v11 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)
    local v12 = v11 > 0 and ScrollingFrame.CanvasPosition.Y >= v11 - 2
    local v13 = "Featured"
    local n1 = (-1e999)

    for _, v14 in t3 do
        local Y = v14.anchor.AbsolutePosition.Y

        if v14.anchor.Visible and (Y <= v9 or v12) and n1 <= Y then
            n1 = Y
            v13 = v14.section
        end
    end

    for _, v15 in t3 do
        local v16 = v15.section == v13
        local SectionTitle = v15.button.SectionTitle

        if v16 then
            SectionTitle.TextColor3 = v5
        else
            SectionTitle.TextColor3 = v15.color
        end

        v15.button:SetAttribute("SelectedSection", v16)
    end
end

local function placeStars() -- line: 123
    -- upvalues: ShopPreview (copy), t5 (copy), updateSection (copy)
    local v17 = ShopPreview.IsHalloween()

    for v18, v19 in t5 do
        if v17 then
            v18.LayoutOrder = v19 + 9000
        else
            v18.LayoutOrder = v19
        end
    end

    updateSection()
end

local function cancelTween() -- line: 131
    -- upvalues: v4 (ref)
    if v4 then
        v4:Cancel()
        v4 = nil
    end
end

local function stopScrolling() -- line: 138
    -- upvalues: v3 (copy), v4 (ref)
    v3:Clean()

    if v4 then
        v4:Cancel()
        v4 = nil
    end
end

local function scrollTo(p1) -- line: 143
    -- upvalues: TweenService (copy), ScrollingFrame (copy), v4 (ref), t2 (copy), updateSection (copy)
    local v20 = t2[p1.section]
    local v21 = true

    if v20 ~= nil then
        if v20.Visible then
            if v4 then
                v4:Cancel()
                v4 = nil
            end

            v21 = false
        end
    end

    if v21 then
        return
    end

    local v22 = v20.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y - 6
    local v25 = Vector2.new(0, (math.clamp(v22, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)))))

    if p1.animated then
        v4 = TweenService:Create(ScrollingFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = v25
        })
        v4:Play()
    else
        ScrollingFrame.CanvasPosition = v25
        updateSection()
    end
end

local t6 = {
    Open = function(p2) -- Open | line: 169
        -- upvalues: ShopPreview (copy), Promise (copy), Tabs (copy), v3 (copy), v4 (ref), t5 (copy), updateSection (copy), scrollTo (copy)
        v3:Clean()

        if v4 then
            v4:Cancel()
            v4 = nil
        end

        local v26 = ShopPreview.IsHalloween()

        for v27, v28 in t5 do
            if v26 then
                v27.LayoutOrder = v28 + 9000
            else
                v27.LayoutOrder = v28
            end
        end

        updateSection()

        if Tabs.Activate("Shop") then
            v3:AddPromise(Promise.delay(0.22):andThen(function() -- line: 177
                -- upvalues: p2 (copy), Tabs (copy), scrollTo (copy)
                if Tabs.IsActive("Shop") then
                    scrollTo({
                        animated = false,
                        section = p2
                    })
                end
            end))
        else
            scrollTo({
                animated = false,
                section = p2
            })
        end
    end
}

v2:AttachToInstance(v1)
v2:Add(stopScrolling)

for _, v30 in t3 do
    v30.button.Active = true
    v30.button.Selectable = true
    v2:Add(ButtonFX(v30.button, 1.08, function() -- line: 189
        -- upvalues: v3 (copy), v4 (ref), scrollTo (copy), v30 (copy)
        v3:Clean()

        if v4 then
            v4:Cancel()
            v4 = nil
        end

        scrollTo({
            animated = true,
            section = v30.section
        })
    end))
    v2:Add(v30.anchor:GetPropertyChangedSignal("Visible"):Connect(updateSection))
end

v2:Add(ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateSection))
v2:Add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateSection))
v2:Add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateSection))
v2:Add(ScrollingFrame.InputBegan:Connect(function(p3) -- line: 211
    -- upvalues: v3 (copy), v4 (ref)
    if p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1 then
        v3:Clean()

        if v4 then
            v4:Cancel()
            v4 = nil
        end
    end
end))
v2:Add(ScrollingFrame.InputChanged:Connect(function(p4) -- line: 219
    -- upvalues: v3 (copy), v4 (ref)
    if p4.UserInputType == Enum.UserInputType.MouseWheel then
        v3:Clean()

        if v4 then
            v4:Cancel()
            v4 = nil
        end
    end
end))
v2:Add(Tabs.Deactivated:Connect(function(p5) -- line: 224
    -- upvalues: v3 (copy), v4 (ref)
    if p5 == "Shop" then
        v3:Clean()

        if v4 then
            v4:Cancel()
            v4 = nil
        end
    end
end))
v2:Add(Tabs.Activated:Connect(function(p6) -- line: 229
    -- upvalues: ShopPreview (copy), t5 (copy), updateSection (copy)
    if p6 ~= "Shop" then
        return
    end

    local v31 = ShopPreview.IsHalloween()

    for v32, v33 in t5 do
        if v31 then
            v32.LayoutOrder = v33 + 9000
        else
            v32.LayoutOrder = v33
        end
    end

    updateSection()
end))
v2:Add(BalanceConfig.Changed:Connect(placeStars))
v2:Add(ShopPreview.Changed:Connect(placeStars))

for _, v34 in { "OldRobuxShop", "SpeedShop", "RobuxShopOLD" } do
    local v35 = GUI.PlayerGui():FindFirstChild(v34)

    if v35 and v35:IsA("ScreenGui") then
        v35.Enabled = false
    end
end

v1.ResetOnSpawn = false
ScrollingFrame.CanvasPosition = Vector2.zero

local v36 = ShopPreview.IsHalloween()

for v37, v38 in t5 do
    if v36 then
        v37.LayoutOrder = v38 + 9000
    else
        v37.LayoutOrder = v38
    end
end

updateSection()

return table.freeze(t6)
