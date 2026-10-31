-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local ClientState = require(Parent.ClientState)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local HUDController = require(Parent.HUDController)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local t2 = {
    Color3.fromRGB(255, 84, 84),
    Color3.fromRGB(200, 30, 60)
}
local t3 = {}

for _, v1 in pairs(AnimalsData) do
    for _, v2 in ipairs(v1) do
        t3[v2.ModelName] = v2.Name
    end
end

local function rarityOf(p1) -- line: 57
    -- upvalues: AnimalEconomy (copy)
    local v3 = AnimalEconomy.Get(p1)

    return v3 and v3.Rarity or "Common"
end

local v4, v5, TextButton, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, t4
local t5 = nil

local function comma(p2) -- line: 69
    return (tostring((math.floor(p2))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function robux(p3) -- line: 76
    if p3 and p3 > 0 then
        return "<font color=\"" .. "#FFD84A" .. "\">" .. tostring((math.floor((math.floor(p3 + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux</font>"
    end

    return "<font color=\"#FFD84A\">Robux</font>"
end

local function money(p4) -- line: 83
    -- upvalues: NumberFormat (copy)
    return "<font color=\"" .. "#8CFF3C" .. "\">" .. NumberFormat.Money(p4 or 0) .. "</font>"
end

local t9 = {
    {
        Title = "ARE YOU SURE?",
        Sell = "YES, SELL",
        SellLeft = false,
        Text = function(p5) -- Text | line: 94
            local Paid = p5.Paid

            return "You paid " .. (if not (Paid and Paid > 0) then "<font color=\"#FFD84A\">Robux</font>" else "<font color=\"" .. "#FFD84A" .. "\">" .. tostring((math.floor((math.floor(Paid + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux</font>") .. " for this animal.\n<font color=\"" .. "#FF5A5A" .. "\">Robux purchases can't be returned!</font>"
        end
    },
    {
        Title = "REALLY SURE?",
        Sell = "I'M SURE",
        SellLeft = true,
        Text = function(p6) -- Text | line: 101
            local v26 = "\">gone forever</font>.\nYou will NOT get your "
            local Paid = p6.Paid

            return "Once sold, it is <font color=\"" .. "#FF5A5A" .. v26 .. (if not (Paid and Paid > 0) then "<font color=\"#FFD84A\">Robux</font>" else "<font color=\"" .. "#FFD84A" .. "\">" .. tostring((math.floor((math.floor(Paid + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux</font>") .. " back!"
        end
    },
    {
        Title = "LAST WARNING!",
        Sell = "SELL ANYWAY",
        SellLeft = false,
        Countdown = 3,
        Text = function(p7) -- Text | line: 108
            -- upvalues: NumberFormat (copy)
            local Price = p7.Price
            local v31 = "<font color=\"" .. "#8CFF3C" .. "\">" .. NumberFormat.Money(Price or 0) .. "</font>"
            local Paid = p7.Paid

            return "Selling only gives you " .. v31 .. " - not the " .. (if not (Paid and Paid > 0) then "<font color=\"#FFD84A\">Robux</font>" else "<font color=\"" .. "#FFD84A" .. "\">" .. tostring((math.floor((math.floor(Paid + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux</font>") .. " you paid.\n<font color=\"" .. "#FF5A5A" .. "\">This can't be undone!</font>"
        end
    }
}

local function close() -- line: 115
    -- upvalues: ClientState (copy), UIKit (copy), Sounds (copy), v4 (ref), v5 (ref), t5 (ref)
    if not t5 then
        return
    end

    t5 = nil
    ClientState.ProtectedSellOpen = false
    Sounds.Play("Slide", {
        Volume = 0.2
    })
    UIKit.PopOut(v5.Root, 0.18, 0.8).Completed:Once(function() -- line: 120
        -- upvalues: v4 (ref), v5 (ref), t5 (ref)
        if not t5 then
            v4.Enabled = false
        end

        v5.Root.Visible = true
    end)
end

local function placeButtons(p8) -- line: 126
    -- upvalues: v13 (ref), v14 (ref)
    local v36 = v13

    v36.Position = UDim2.fromScale(p8 and 0.74 or 0.26, 0.92)

    local v37 = v14

    v37.Position = UDim2.fromScale(p8 and 0.26 or 0.74, 0.92)
end

local function setSellEnabled(p9) -- line: 131
    -- upvalues: UIKit (copy), Colors (copy), v14 (ref)
    local SetButtonColors = UIKit.SetButtonColors
    local v38 = v14

    SetButtonColors(v38, p9 and {
        Colors.RedA,
        Colors.RedB
    } or {
        Colors.GrayA,
        Colors.GrayB
    })
end

local v39

local function showWarning(p10) -- line: 137
    -- upvalues: UIKit (copy), Sounds (copy), Colors (copy), v5 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), t5 (ref), t9 (copy), setSellEnabled (copy)
    local t10 = t5

    t10.Stage = p10

    local v40 = t9[p10]

    v16.Visible = false
    v10.Visible = true
    v5.Title.Text = "SELL BOUGHT ANIMAL (" .. p10 .. "/4)"

    local v41 = v11

    v41.Text = v40.Title

    local v42 = v12

    v42.Text = v40.Text(t10)

    local SellLeft = v40.SellLeft
    local v43 = v13

    v43.Position = UDim2.fromScale(SellLeft and 0.74 or 0.26, 0.92)

    local v44 = v14

    v44.Position = UDim2.fromScale(SellLeft and 0.26 or 0.74, 0.92)

    local t11 = {}

    t10.Token = t11
    t10.Ready = false
    UIKit.SetButtonColors(v14, {
        Colors.GrayA,
        Colors.GrayB
    })

    local v45 = v15

    v45.Text = v40.Sell
    UIKit.PopIn(v10, 0.25, 0.85)
    UIKit.Punch(v11, 0.2, 0.4)
    Sounds.Play(p10 == 3 and "Deny" or "Pop", {
        Volume = 0.45
    })
    task.spawn(function() -- line: 155
        -- upvalues: t10 (copy), v40 (copy), t11 (copy), v15 (ref), t5 (ref), setSellEnabled (copy)
        local v47 = math.max(0.8, v40.Countdown or 0)
        local elapsed = os.clock()

        while t5 == t10 do
            local v48 = true

            if t10.Token == t11 then
                local v49 = v47 - (os.clock() - elapsed)

                if v49 <= 0 then
                else
                    if v40.Countdown then
                        v15.Text = v40.Sell .. " (" .. math.ceil(v49) .. ")"
                    end

                    v48 = false
                end
            end

            if v48 then
                break
            end

            task.wait(0.1)
        end

        if t5 ~= t10 or t10.Token ~= t11 then
            return
        end

        t10.Ready = true
        v15.Text = v40.Sell
        setSellEnabled(true)
    end)
end

local function onSellClicked() -- line: 172
    -- upvalues: UIKit (copy), Sounds (copy), v14 (ref), t5 (ref), t9 (copy), v39 (ref), showWarning (copy)
    local t12 = t5

    if t12 then
        if t12.Ready and not (t12.Stage > #t9) then
            if t12.Stage < #t9 then
                showWarning(t12.Stage + 1)
            else
                v39()
            end
        elseif not t12.Ready then
            Sounds.Play("PurchaseFail", {
                Volume = 0.3
            })
            UIKit.Punch(v14, 0.08, 0.25)
        end
    end
end

local function resetTiles() -- line: 188
    -- upvalues: UIKit (copy), Colors (copy), t4 (ref), t5 (ref)
    for v52, v53 in ipairs(t4) do
        v53.Done = false
        UIKit.SetButtonColors(v53.Button, {
            Colors.BlueA,
            Colors.BlueB
        })
        v53.Label.Text = tostring(t5.Order[v52])
    end

    t5.Next = 1

    local t13 = t5

    t13.Tapped = {}
end

local function shake(p11) -- line: 198
    local Position = p11.Position

    task.spawn(function() -- line: 200
        -- upvalues: p11 (copy), Position (copy)
        for i = 1, 6 do
            p11.Position = Position + UDim2.fromOffset((i % 2 == 0 and -1 or 1) * 8, 0)
            task.wait(0.04)
        end

        p11.Position = Position
    end)
end

local function finish() -- line: 209
    -- upvalues: NumberFormat (copy), Remotes (copy), Sounds (copy), HUDController (copy), v17 (ref), t5 (ref), close (copy), resetTiles (copy)
    local t14 = t5

    if not t14 or t14.Selling then
        return
    end

    t14.Selling = true
    v17.Text = "Selling..."

    local v55 = Remotes.Invoke("Sell_Protected", "Finish", t14.Id, t14.Tapped)

    if t5 == t14 then
        t14.Selling = false

        if not (v55 and v55.Ok) then
            Sounds.Play("PurchaseFail", {
                Volume = 0.4
            })

            local v56 = Remotes.Invoke("Sell_Protected", "Begin", t14.Id)

            if t5 == t14 then
                if not (v56 and v56.Ok) then
                    close()
                else
                    t14.Order = v56.Order
                    resetTiles()

                    local v57 = v17

                    v57.Text = "Try again: tap <font color=\"" .. "#FFD84A" .. "\">1 to " .. 6 .. "</font> in order"
                end
            end
        else
            Sounds.Play("MoneyReward")
            HUDController.Notify("Sold for " .. NumberFormat.Money(v55.Money or 0) .. "!", "Success")
            close()
        end
    end
end

local function onTile(p12) -- line: 236
    -- upvalues: UIKit (copy), Sounds (copy), Colors (copy), v16 (ref), v17 (ref), t4 (ref), t5 (ref), resetTiles (copy), finish (copy)
    local t15 = t5

    if not t15 or t15.Stage ~= 4 or t15.Selling then
        return
    end

    local v58 = t4[p12]

    if not v58.Done then
        if t15.Order[p12] == t15.Next then
            if t15.Next == 1 then
                local v59 = v17

                v59.Text = t15.TaskText
            end

            v58.Done = true
            table.insert(t15.Tapped, p12)
            UIKit.SetButtonColors(v58.Button, {
                Colors.GreenA,
                Colors.GreenB
            })
            UIKit.Punch(v58.Button, 0.15, 0.3)
            Sounds.Play("Pop", {
                Pitch = 1 + t15.Next * 0.08
            })
            t15.Next += 1

            if t15.Next > 6 then
                finish()
            end
        else
            Sounds.Play("PurchaseFail", {
                Volume = 0.4
            })

            local v60 = v16
            local Position = v60.Position

            task.spawn(function() -- line: 200
                -- upvalues: v60 (copy), Position (copy)
                for i = 1, 6 do
                    v60.Position = Position + UDim2.fromOffset((i % 2 == 0 and -1 or 1) * 8, 0)
                    task.wait(0.04)
                end

                v60.Position = Position
            end)
            UIKit.SetButtonColors(v58.Button, {
                Colors.RedA,
                Colors.RedB
            })
            task.delay(0.35, function() -- line: 254
                -- upvalues: t15 (copy), t5 (ref), resetTiles (copy)
                if t5 == t15 and t15.Stage == 4 and not t15.Selling then
                    resetTiles()
                end
            end)
            v17.Text = "Wrong! Start again from <font color=\"#FFD84A\">1</font>"
        end
    end
end

v39 = function() -- line: 261
    -- upvalues: UIKit (copy), Sounds (copy), v5 (ref), v10 (ref), v16 (ref), v17 (ref), t5 (ref), resetTiles (copy)
    local t16 = t5

    t16.Stage = 4
    t16.Token = {}
    v10.Visible = false
    v16.Visible = true
    v5.Title.Text = "SELL BOUGHT ANIMAL (4/4)"
    t16.TaskText = "To sell, tap <font color=\"" .. "#FFD84A" .. "\">1 to " .. 6 .. "</font> in order\n<font color=\"" .. "#FF5A5A" .. "\">" .. (if t16.Paid then tostring((math.floor((math.floor(t16.Paid + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux" or "Robux" else "Robux") .. " - no refunds!</font>"
    v17.Text = t16.TaskText
    resetTiles()
    UIKit.PopIn(v16, 0.25, 0.85)
    Sounds.Play("Pop", {
        Volume = 0.45
    })
end

function t1.Open(p13) -- line: 279
    -- upvalues: AnimalEconomy (copy), AnimalUtil (copy), Mutations (copy), Boosts (copy), Remotes (copy), DataController (copy), ClientState (copy), UIKit (copy), Sounds (copy), LocalPlayer (copy), t3 (copy), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), t5 (ref), showWarning (copy)
    local v66, v67

    if t5 then
        v67 = true
    elseif v4 and type(p13) == "string" then
        v66 = DataController:Get("Animals") or {}
        v67 = false
    else
        v67 = true
    end

    if v67 then
        return
    end

    local v68 = v66[p13]

    if not (v68 and v68.Bought) then
        return
    end

    local t17 = {
        Stage = 0,
        Id = p13,
        Entry = v68
    }

    t5 = t17
    ClientState.ProtectedSellOpen = true

    local v69 = Remotes.Invoke("Sell_Protected", "Begin", p13)

    if t5 == t17 then
        if v69 and v69.Ok then
            local Order, Price, Paid = v69.Order, v69.Price, v69.Paid

            t17.Order = Order
            t17.Price = Price
            t17.Paid = Paid

            local ModelName = v68.ModelName
            local v70 = AnimalEconomy.Get(ModelName)
            local v71 = v70 and v70.Rarity or "Common"

            v7.Text = t3[ModelName] or ModelName

            local UIGradient = v7:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                UIGradient:Destroy()
            end

            UIKit.RarityGradient(v7, v71, 90)

            local FrameParent = v6.Frame.Parent
            local UIGradient2 = FrameParent:FindFirstChildOfClass("UIGradient")

            if UIGradient2 then
                UIGradient2:Destroy()
            end

            UIKit.RarityGradient(FrameParent, v71, 90)

            local v73 = AnimalUtil.Create(ModelName)

            if v73 then
                Mutations.Apply(v73, v68.Mutation, {
                    Particles = false
                })
            end

            v6:SetModel(v73)

            local v74 = Mutations.IncomeOf(v68, LocalPlayer:GetAttribute("BestIncome") or 0)

            v8.Text = Boosts.AnimalIncomeText(v74, LocalPlayer, v68.OfBest)

            local v76 = v9

            if t17.Paid then
                v76.Text = tostring((math.floor((math.floor(t17.Paid + 0.5))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or "?"
            else
                v76.Text = "?"
            end

            v4.Enabled = true
            UIKit.PopIn(v5.Root, 0.3, 0.75)
            showWarning(1)
        else
            t5 = nil
            ClientState.ProtectedSellOpen = false
            Sounds.Play("PurchaseFail", {
                Volume = 0.4
            })
        end
    end
end

function t1.IsOpen() -- line: 317
    -- upvalues: t5 (ref)
    return t5 ~= nil
end

local function build() -- line: 325
    -- upvalues: UIKit (copy), Colors (copy), t2 (copy), v4 (ref), v5 (ref), TextButton (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), t4 (ref), close (copy), onSellClicked (copy), onTile (copy)
    v4 = UIKit.ScreenGui("ProtectedSell", 40, true)
    v4.Enabled = false
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Dim"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false

    local TextButton2 = TextButton

    TextButton2.Size = UDim2.fromScale(1, 1)

    local TextButton3 = TextButton

    TextButton3.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 0.45
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 1
    TextButton.Parent = v4
    v5 = UIKit.Panel({
        Name = "ProtectedSellPanel",
        Ratio = 1.3,
        Title = "SELL BOUGHT ANIMAL",
        HeaderHeight = 0.13,
        ZIndex = 3,
        Parent = v4,
        Size = UDim2.fromScale(0.46, 0.6),
        Position = UDim2.fromScale(0.5, 0.5),
        HeaderColors = t2,
        OnClose = function() -- OnClose | line: 340
            -- upvalues: close (copy)
            close()
        end
    })

    local Content = v5.Content
    local ZIndex = Content.ZIndex
    local v80 = UIKit.Frame({
        Name = "Animal",
        Corner = 12,
        Stroke = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.92, 0.36),
        Position = UDim2.fromScale(0.5, 0.04),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(36, 36, 44),
        StrokeColor = Color3.new(0, 0, 0),
        ZIndex = ZIndex + 1
    })
    local v81 = UIKit.Card({
        Name = "Preview",
        Rarity = "Common",
        Parent = v80,
        Size = UDim2.fromScale(0.86, 0.86),
        Position = UDim2.fromScale(0.02, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        ZIndex = ZIndex + 2
    })

    v81.SizeConstraint = Enum.SizeConstraint.RelativeYY
    v6 = UIKit.Viewport({
        Yaw = -0.6108652381980153,
        Pitch = -0.20943951023931956,
        Padding = 1.05,
        Rotate = true,
        Parent = v81,
        Size = UDim2.fromScale(0.94, 0.94),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = ZIndex + 4
    })
    v7 = UIKit.Text({
        Name = "Name",
        Text = "",
        Stroke = 3,
        Parent = v80,
        Size = UDim2.fromScale(0.43, 0.32),
        Position = UDim2.fromScale(0.27, 0.1),
        XAlign = Enum.TextXAlignment.Left,
        Color = Color3.new(1, 1, 1),
        ZIndex = ZIndex + 2
    })
    v8 = UIKit.Text({
        Name = "Income",
        Text = "",
        Rich = true,
        Stroke = 2,
        Parent = v80,
        Size = UDim2.fromScale(0.43, 0.24),
        Position = UDim2.fromScale(0.27, 0.44),
        XAlign = Enum.TextXAlignment.Left,
        Color = Colors.Money,
        ZIndex = ZIndex + 2
    })

    local v82 = UIKit.Frame({
        Name = "Paid",
        Corner = 10,
        Stroke = 3,
        Parent = v80,
        Size = UDim2.fromScale(0.25, 0.78),
        Position = UDim2.fromScale(0.98, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Color3.fromRGB(60, 44, 20),
        StrokeColor = Color3.new(0, 0, 0),
        Gradient = {
            Color3.fromRGB(255, 214, 90),
            Color3.fromRGB(226, 150, 20),
            90
        },
        ZIndex = ZIndex + 2
    })

    UIKit.Text({
        Name = "Caption",
        Text = "YOU PAID",
        Stroke = 2,
        Parent = v82,
        Size = UDim2.fromScale(0.9, 0.3),
        Position = UDim2.fromScale(0.5, 0.08),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = ZIndex + 3
    })

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "RobuxIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxasset://textures/ui/common/robux.png"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.36, 0.4)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Position = UDim2.fromScale(0.08, 0.68)
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.ZIndex = ZIndex + 3
    ImageLabel.Parent = v82
    v9 = UIKit.Text({
        Name = "Amount",
        Text = "",
        Stroke = 3,
        Parent = v82,
        Size = UDim2.fromScale(0.6, 0.42),
        Position = UDim2.fromScale(0.94, 0.68),
        AnchorPoint = Vector2.new(1, 0.5),
        XAlign = Enum.TextXAlignment.Right,
        ZIndex = ZIndex + 3
    })
    v10 = UIKit.Frame({
        Name = "Warning",
        Transparency = 1,
        Parent = Content,
        Size = UDim2.fromScale(1, 0.58),
        Position = UDim2.fromScale(0, 0.42),
        ZIndex = ZIndex + 1
    })
    v11 = UIKit.Text({
        Name = "Title",
        Text = "",
        Stroke = 4,
        Parent = v10,
        Size = UDim2.fromScale(0.8, 0.22),
        Position = UDim2.fromScale(0.5, 0.02),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(255, 90, 90),
        ZIndex = ZIndex + 2
    })
    v12 = UIKit.Text({
        Name = "Text",
        Text = "",
        Rich = true,
        Stroke = 3,
        Parent = v10,
        Size = UDim2.fromScale(0.9, 0.34),
        Position = UDim2.fromScale(0.5, 0.26),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = ZIndex + 2
    })
    v13 = UIKit.Button({
        Name = "Keep",
        Text = "KEEP IT",
        Parent = v10,
        Size = UDim2.fromScale(0.42, 0.26),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        ZIndex = ZIndex + 3,
        Juice = {
            HoverScale = 1.05
        },
        OnClick = function() -- OnClick | line: 371
            -- upvalues: close (copy)
            close()
        end
    })
    v14, v15 = UIKit.Button({
        Name = "Sell",
        Text = "SELL",
        Parent = v10,
        Size = UDim2.fromScale(0.34, 0.2),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        ZIndex = ZIndex + 3,
        Juice = {
            HoverScale = 1.03
        },
        OnClick = onSellClicked
    })

    local v83 = v13

    v83.Position = UDim2.fromScale(0.26, 0.92)

    local v84 = v14

    v84.Position = UDim2.fromScale(0.74, 0.92)
    v16 = UIKit.Frame({
        Name = "Task",
        Transparency = 1,
        Parent = Content,
        Size = UDim2.fromScale(1, 0.58),
        Position = UDim2.fromScale(0, 0.42),
        ZIndex = ZIndex + 1
    })
    v16.Visible = false
    v17 = UIKit.Text({
        Name = "Text",
        Text = "",
        Rich = true,
        Stroke = 3,
        Parent = v16,
        Size = UDim2.fromScale(0.9, 0.3),
        Position = UDim2.fromScale(0.5, 0.02),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = ZIndex + 2
    })

    local v85 = UIKit.Frame({
        Name = "Tiles",
        Transparency = 1,
        Parent = v16,
        Size = UDim2.fromScale(0.92, 0.36),
        Position = UDim2.fromScale(0.5, 0.36),
        AnchorPoint = Vector2.new(0.5, 0),
        ZIndex = ZIndex + 2
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.025, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v85
    t4 = {}

    for i = 1, 6 do
        local v86, v87 = UIKit.Button({
            Text = "?",
            Ratio = 1,
            TextStroke = 4,
            Parent = v85,
            Name = "Tile" .. i,
            Size = UDim2.fromScale(0.14, 1),
            Colors = {
                Colors.BlueA,
                Colors.BlueB
            },
            ZIndex = ZIndex + 3,
            Juice = {
                HoverScale = 1.08
            },
            OnClick = function() -- OnClick | line: 389
                -- upvalues: i (copy), onTile (copy)
                onTile(i)
            end
        })

        v86.LayoutOrder = i

        local t19 = t4

        t19[i] = {
            Button = v86,
            Label = v87
        }
    end

    UIKit.Button({
        Name = "Keep",
        Text = "KEEP IT",
        Parent = v16,
        Size = UDim2.fromScale(0.42, 0.2),
        Position = UDim2.fromScale(0.5, 0.95),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        ZIndex = ZIndex + 3,
        Juice = {
            HoverScale = 1.05
        },
        OnClick = function() -- OnClick | line: 393
            -- upvalues: close (copy)
            close()
        end
    })
end

function t1.Init() -- line: 396
    -- upvalues: DataController (copy), t5 (ref), close (copy), build (copy)
    build()
    DataController:ObserveTable("Animals", function(p14) -- line: 399
        -- upvalues: t5 (ref), close (copy)
        if t5 and not (p14 or {})[t5.Id] then
            close()
        end
    end)
end

return t1
