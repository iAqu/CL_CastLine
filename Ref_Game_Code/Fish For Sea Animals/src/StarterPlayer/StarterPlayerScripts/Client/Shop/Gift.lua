-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Robux)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local LocalPlayer = Players.LocalPlayer
local t2 = {
    VIP = "VIP",
    CashX2 = "2x Cash",
    StrengthX2 = "2x Training"
}
local Left = Enum.TextXAlignment.Left
local TextButton, ScrollingFrame, v1, v2, v3, v4, t3
local v5 = false
local t1 = {}

function t1.available(p1) -- line: 33
    -- upvalues: RunService (copy), Products (copy)
    local v6 = Products.Gifts[p1]

    if v6 == nil then
        return false
    end

    if Products.Items[v6].Id > 0 then
        return true
    end

    return (RunService:IsStudio())
end

function t1.close() -- line: 38
    -- upvalues: TextButton (ref), v4 (ref)
    if TextButton then
        TextButton.Visible = false
    end

    v4 = nil
end

local function header(p2, p3) -- line: 45
    -- upvalues: Style (copy), Left (copy), ScrollingFrame (ref)
    return (Style.text(ScrollingFrame, p2, {
        Name = "Header",
        StrokeThickness = 4,
        LayoutOrder = p3,
        Size = UDim2.new(1, -16, 0, 44),
        TextXAlignment = Left,
        TextColor3 = Style.YELLOW
    }))
end

local function choose(p4, p5) -- line: 58
    -- upvalues: Products (copy), Remotes (copy), UIUtil (copy), Robux (copy), t1 (copy), v4 (ref), v5 (ref)
    if v5 or not v4 then
        return
    end

    v5 = true

    local v7 = v4
    local Text = p5.Label.Text

    p5.Label.Text = "..."

    local v8, v9 = Remotes.GiftPass:InvokeServer(v7, p4)

    p5.Label.Text = Text
    v5 = false

    if v8 then
        Robux.buy(Products.Gifts[v7], function() -- line: 73
            -- upvalues: t1 (copy)
            t1.close()
        end)
    else
        UIUtil.toast(v9 or "Couldn't gift that.", "error")
    end
end

local function row(p6, p7) -- line: 78
    -- upvalues: Kit (copy), Style (copy), Left (copy), ScrollingFrame (ref), choose (copy)
    local v10 = Kit.frame(ScrollingFrame, {
        Name = "Row",
        BackgroundTransparency = 0.35,
        ZIndex = 33,
        LayoutOrder = p7,
        BackgroundColor3 = Style.DEEP,
        Size = UDim2.new(1, -16, 0, 92)
    })

    Kit.corner(v10, 16)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundColor3 = Style.OCEAN
    ImageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p6.Id)
    ImageLabel.Position = UDim2.fromOffset(12, 8)
    ImageLabel.Size = UDim2.fromOffset(76, 76)
    ImageLabel.ZIndex = 34
    ImageLabel.Parent = v10

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ImageLabel
    Kit.stroke(ImageLabel, 3)
    Style.text(v10, p6.DisplayName, {
        ZIndex = 34,
        Position = UDim2.fromOffset(100, 10),
        Size = UDim2.new(1, -322, 0, 40),
        TextXAlignment = Left
    })
    Style.text(v10, ("@%* · %*"):format(p6.Username, p6.Where), {
        ZIndex = 34,
        Position = UDim2.fromOffset(100, 52),
        Size = UDim2.new(1, -322, 0, 28),
        TextXAlignment = Left,
        TextColor3 = if p6.Where == "Offline" then Style.GREY else Style.MINT
    })

    local v12

    v12 = Kit.button(v10, "🎁 GIFT", Style.BUY, {
        ZIndex = 34,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(190, 66)
    }, function() -- line: 118
        -- upvalues: p6 (copy), v12 (ref), choose (copy)
        task.spawn(choose, p6.Id, v12)
    end)
    v12.Label.ZIndex = 36
    Style.dress(v12, 12)
end

local function fill() -- line: 126
    -- upvalues: Players (copy), LocalPlayer (copy), ScrollingFrame (ref), v3 (ref), t3 (ref), header (copy), row (copy)
    for _, child in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local t5 = {
        [LocalPlayer.UserId] = true
    }
    local t6 = {}

    for _, player in Players:GetPlayers() do
        if not t5[player.UserId] then
            t5[player.UserId] = true
            table.insert(t6, {
                Where = "In this server",
                Id = player.UserId,
                DisplayName = player.DisplayName,
                Username = player.Name
            })
        end
    end

    local v13

    if #t6 > 0 then
        v13 = 0 + 1
        header("IN THIS SERVER", v13)

        local v14 = v13

        for _, v15 in t6 do
            v14 += 1
            v13 = v14
            row(v15, v14)
        end
    else
        v13 = 0
    end

    local t8 = {}

    for _, v16 in t3 or {} do
        if not t5[v16.Id] then
            t5[v16.Id] = true
            table.insert(t8, v16)
        end
    end

    table.sort(t8, function(p8, p9) -- line: 156
        if p8.IsOnline == p9.IsOnline then
            return p8.DisplayName:lower() < p9.DisplayName:lower()
        end

        return p8.IsOnline
    end)

    if #t8 > 0 then
        v13 += 1
        header("FRIENDS", v13)

        local v17 = v13

        for _, v18 in t8 do
            v17 += 1
            v13 = v17
            row({
                Id = v18.Id,
                DisplayName = v18.DisplayName,
                Username = v18.Username,
                Where = v18.IsOnline and "Online" or "Offline"
            }, v17)
        end
    end

    local v19 = v3

    v19.Visible = v13 == 0
end

local function loadFriends() -- line: 173
    -- upvalues: Players (copy), LocalPlayer (copy), t3 (ref)
    local t10 = {}
    local GetFriendsAsync = Players.GetFriendsAsync
    local UserId = LocalPlayer.UserId
    local ok, result = pcall(GetFriendsAsync, Players, UserId)

    while ok and result and #t10 < 200 do
        for _, v20 in result:GetCurrentPage() do
            table.insert(t10, {
                Id = v20.Id,
                Username = v20.Username,
                DisplayName = v20.DisplayName or v20.Username,
                IsOnline = v20.IsOnline == true
            })
        end

        if result.IsFinished then
            break
        end

        local AdvanceToNextPageAsync = result.AdvanceToNextPageAsync

        ok = pcall(AdvanceToNextPageAsync, result)
    end

    t3 = t10
end

function t1.open(p10) -- line: 194
    -- upvalues: Products (copy), UIUtil (copy), Robux (copy), t1 (copy), t2 (copy), TextButton (ref), v1 (ref), v2 (ref), v4 (ref), t3 (ref), fill (copy), loadFriends (copy)
    if not (TextButton and t1.available(p10)) then
        return
    end

    v4 = p10
    v1.Text = ("🎁 GIFT %*"):format((string.upper(t2[p10] or p10)))
    v2.Label.Text = tostring(Robux.price(Products.Gifts[p10]))
    TextButton.Visible = true
    UIUtil.pop(TextButton.Card, 0.85)
    fill()

    if not t3 then
        task.spawn(function() -- line: 205
            -- upvalues: TextButton (ref), fill (copy), loadFriends (copy)
            loadFriends()

            if TextButton.Visible then
                fill()
            end
        end)
    end
end

function t1.init(p11) -- line: 215
    -- upvalues: Kit (copy), Style (copy), Fx (copy), t1 (copy), Left (copy), TextButton (ref), ScrollingFrame (ref), v1 (ref), v2 (ref), v3 (ref)
    TextButton = Instance.new("TextButton")
    TextButton.Name = "GiftPicker"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 0.4
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 30
    TextButton.Visible = false
    Kit.corner(TextButton, 26)
    TextButton.Parent = p11

    local v23 = Style.card(TextButton, Style.ABYSS, {
        Name = "Card",
        ZIndex = 31,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(860, 720)
    })

    Style.polish(v23)
    Fx.sparkles(v23, 6, Style.YELLOW, 26, 32)
    v1 = Style.text(v23, "", {
        StrokeThickness = 6,
        ZIndex = 33,
        Position = UDim2.fromOffset(30, 18),
        Size = UDim2.new(1, -260, 0, 66),
        TextXAlignment = Left
    })
    Style.gradient(v1, ColorSequence.new(Style.YELLOW, Style.GOLD))
    Style.text(v23, "They get it forever, and everyone sees who it's from!", {
        ZIndex = 33,
        Position = UDim2.fromOffset(32, 86),
        Size = UDim2.new(1, -64, 0, 32),
        TextXAlignment = Left,
        TextColor3 = Style.SAND
    })
    v2 = Kit.frame(v23, {
        Name = "Price",
        BackgroundTransparency = 0.3,
        ZIndex = 33,
        BackgroundColor3 = Style.DEEP,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -120, 0, 24),
        Size = UDim2.fromOffset(150, 56)
    })
    Kit.corner(v2, 14)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = Style.ROBUX
    ImageLabel.Position = UDim2.fromOffset(12, 12)
    ImageLabel.Size = UDim2.fromOffset(32, 32)
    ImageLabel.ZIndex = 34
    ImageLabel.Parent = v2
    Kit.text(v2, "", {
        Name = "Label",
        ZIndex = 34,
        Position = UDim2.fromOffset(50, 8),
        Size = UDim2.new(1, -60, 1, -16)
    })
    Kit.button(v23, "X", Color3.fromRGB(235, 70, 70), {
        ZIndex = 33,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, 18),
        Size = UDim2.fromOffset(76, 76)
    }, t1.close).Label.ZIndex = 35
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(24, 132)
    ScrollingFrame.Size = UDim2.new(1, -40, 1, -150)
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollBarImageColor3 = Style.YELLOW
    ScrollingFrame.ZIndex = 33
    ScrollingFrame.Parent = v23

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    v3 = Style.text(v23, "Nobody to gift to yet!\nInvite a friend to play 💌", {
        ZIndex = 33,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.58),
        Size = UDim2.new(1, -120, 0, 120),
        TextColor3 = Style.SAND
    })
end

return t1
