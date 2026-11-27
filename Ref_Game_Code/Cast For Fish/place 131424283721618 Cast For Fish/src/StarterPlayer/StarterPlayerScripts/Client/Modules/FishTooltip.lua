-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Data = Shared.Data
local Parent = script.Parent
local Fish = require(Data.Fish)
local Rarities = require(Data.Rarities)
local Variants = require(Data.Variants)
local Sizes = require(Data.Sizes)
local Events = require(Data.Events)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(Parent.UIKit)
local fromRGB = Color3.fromRGB
local Colors = UIKit.Colors
local Left = Enum.TextXAlignment.Left
local v1 = fromRGB(205, 210, 230)
local v2 = fromRGB(30, 34, 70)
local v3 = fromRGB(14, 16, 34)
local v4, v5, UIGradient, UIStroke
local t1 = {}
local v6 = nil
local v7
local n1 = 0

local function readable(p1) -- line: 57
    -- upvalues: Colors (copy)
    local _, _, v8 = p1:ToHSV()

    return p1:Lerp(Colors.White, if v8 < 0.6 then 0.75 else 0.35)
end

local function tag(p2, p3) -- line: 62
    return ("<font color=\"#%s\">%s</font>"):format(p3:ToHex(), p2)
end

local function shrink(p4, p5, p6) -- line: 66
    p4.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p5
    UITextSizeConstraint.MinTextSize = p6
    UITextSizeConstraint.Parent = p4
end

local function build() -- line: 74
    -- upvalues: UIKit (copy), Colors (copy), Left (copy), v1 (copy), v2 (copy), v3 (copy), v4 (ref), v5 (ref), UIGradient (ref), UIStroke (ref), t1 (copy)
    v4 = UIKit.screenGui("FishTooltip", 30)

    local v9 = UIKit.frame(v4, {
        Name = "Card",
        Corner = 14,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(310, 124),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = v2,
        Color2 = v3
    })

    v9.Active = false
    v9.Visible = false
    UIGradient = v9:FindFirstChildOfClass("UIGradient")
    UIStroke = UIKit.dress(v9, 14, Colors.White, 2):FindFirstChildOfClass("UIStroke")
    t1.Tags = UIKit.text(v9, {
        Name = "Tags",
        Text = "",
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.fromOffset(12, 9),
        XAlign = Left,
        Color = Colors.Gold
    })
    t1.Tags.RichText = true

    local Tags = t1.Tags

    Tags.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 18
    UITextSizeConstraint.MinTextSize = 11
    UITextSizeConstraint.Parent = Tags
    t1.Name = UIKit.text(v9, {
        Name = "FishName",
        Text = "",
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 32),
        Position = UDim2.fromOffset(12, 31),
        XAlign = Left
    })

    local Name = t1.Name

    Name.TextScaled = true

    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint2.MaxTextSize = 28
    UITextSizeConstraint2.MinTextSize = 16
    UITextSizeConstraint2.Parent = Name
    t1.Rate = UIKit.text(v9, {
        Name = "Rate",
        Text = "",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.fromOffset(12, 64),
        XAlign = Left,
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    t1.Details = UIKit.text(v9, {
        Name = "Details",
        Text = "",
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.fromOffset(12, 92),
        XAlign = Left,
        Color = v1
    })

    local Details = t1.Details

    Details.TextScaled = true

    local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint3.MaxTextSize = 19
    UITextSizeConstraint3.MinTextSize = 11
    UITextSizeConstraint3.Parent = Details
    v5 = v9
end

local function fill(p7) -- line: 93
    -- upvalues: Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), Events (copy), Roll (copy), NumberFormat (copy), Colors (copy), v2 (copy), v3 (copy), v5 (ref), UIGradient (ref), UIStroke (ref), t1 (copy), readable (copy), tag (copy)
    local v10 = Fish.ById[p7.id]

    if not (v10 and v5 and UIGradient and UIStroke) then
        return false
    end

    local v11 = Rarities.ById[v10.rarity] or Rarities.List[1]
    local v12 = Variants.List[p7.v or 1] or Variants.List[1]
    local v13 = Sizes.List[p7.s or Sizes.NORMAL_INDEX] or Sizes.List[Sizes.NORMAL_INDEX]
    local v14 = if p7.e then Events.ById[p7.e] else nil
    local t2 = { tag(string.upper(v11.name), readable(v11.Color)) }

    if v14 then
        table.insert(t2, tag(("%s x%d"):format(string.upper(v14.mutation), v14.mult), v14.Color))
    end

    if v12.index >= 2 then
        table.insert(t2, tag(string.upper(v12.id), v12.Color))
    end

    if v13.index ~= Sizes.NORMAL_INDEX then
        table.insert(t2, tag(string.upper(v13.id), v13.Color))
    end

    t1.Tags.Text = table.concat(t2, "  •  ")
    t1.Name.Text = v10.name

    local Name = t1.Name
    local Color = v11.Color
    local _, _, v18 = Color:ToHSV()

    Name.TextColor3 = Color:Lerp(Colors.White, v18 < 0.6 and 0.75 or 0.35)
    t1.Rate.Text = NumberFormat.rate(Roll.incomeOf(p7))
    t1.Details.Text = NumberFormat.weight(tonumber(p7.kg) or 0) .. "  •  " .. "Sell " .. NumberFormat.money(Roll.sellOf(p7))

    local UIGradient2 = UIGradient

    UIGradient2.Color = ColorSequence.new(v11.Color:Lerp(v2, 0.72), v11.Color:Lerp(v3, 0.86))

    local UIStroke2 = UIStroke

    UIStroke2.Color = v11.Color:Lerp(Colors.White, 0.4)

    return true
end

local function place(p8) -- line: 122
    -- upvalues: v4 (ref), v5 (ref)
    if v4 and v5 then
        local UIScale = v4:FindFirstChildOfClass("UIScale")
        local v19 = if UIScale and UIScale.Scale > 0 then UIScale.Scale else 1
        local v20 = v4.AbsoluteSize.X / v19
        local v21 = (p8.AbsolutePosition.X + p8.AbsoluteSize.X / 2) / v19
        local v22 = if v4.IgnoreGuiInset then game:GetService("GuiService"):GetGuiInset().Y else 0
        local v23 = (p8.AbsolutePosition.Y + v22) / v19 - 10
        local v26 = math.clamp(v21, 163, (math.max(163, v20 - 155 - 8)))
        local v27 = math.max(v23, 132)
        local v28 = v5

        v28.Position = UDim2.fromOffset(v26, v27)
    end
end

local function hide() -- line: 137
    -- upvalues: v5 (ref)
    if v5 then
        v5.Visible = false
    end
end

local t3 = {}

function t3.Refresh() -- line: 145
    -- upvalues: v5 (ref), v6 (ref), v7 (ref), fill (copy), place (copy)
    if not v5 then
        return
    end

    local v29 = if not (v6 and v7) then nil else v7()

    if v6 and v29 and fill(v29) then
        place(v6)
        v5.Visible = true
    elseif v5 then
        v5.Visible = false
    end
end

function t3.Init() -- line: 158
    -- upvalues: RunService (copy), v4 (ref), v6 (ref), n1 (ref), build (copy), t3 (copy)
    if not v4 then
        build()
        RunService.Heartbeat:Connect(function(p9) -- line: 163
            -- upvalues: v6 (ref), n1 (ref), t3 (copy)
            if v6 then
                n1 += p9

                if n1 >= 0.25 then
                    n1 = 0
                    t3.Refresh()
                end
            end
        end)
    end
end

function t3.Bind(p10, p11) -- line: 175
    -- upvalues: UserInputService (copy), v5 (ref), v6 (ref), v7 (ref), n1 (ref), t3 (copy)
    t3.Init()
    p10.MouseEnter:Connect(function() -- line: 177
        -- upvalues: p10 (copy), p11 (copy), UserInputService (copy), v6 (ref), v7 (ref), n1 (ref), t3 (copy)
        if UserInputService.MouseEnabled then
            v6 = p10
            v7 = p11
            n1 = 0
            t3.Refresh()
        end
    end)
    p10.MouseLeave:Connect(function() -- line: 186
        -- upvalues: p10 (copy), v5 (ref), v6 (ref), v7 (ref)
        if v6 ~= p10 then
            return
        end

        v6 = nil
        v7 = nil

        if v5 then
            v5.Visible = false
        end
    end)
end

function t3.IsVisible() -- line: 195
    -- upvalues: v5 (ref)
    return v5 ~= nil and v5.Visible
end

return t3
