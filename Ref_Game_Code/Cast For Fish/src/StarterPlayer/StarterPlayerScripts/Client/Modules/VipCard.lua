-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Parent = script.Parent
local Products = require(Shared.Data.Products)
local Rods = require(Shared.Data.Rods)
local UIKit = require(Parent.UIKit)
local fromRGB = Color3.fromRGB
local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right
local v1 = Vector2.new(0.5, 0.5)
local LocalPlayer = Players.LocalPlayer
local v2 = utf8.char(10003)
local v3 = fromRGB(255, 255, 255)
local v4 = fromRGB(255, 215, 70)
local v5 = fromRGB(230, 130, 20)
local v6 = fromRGB(255, 240, 166)
local v7 = fromRGB(176, 96, 0)
local v8 = fromRGB(176, 120, 255)
local v9 = fromRGB(112, 62, 222)
local v10 = fromRGB(16, 18, 30)
local v11 = fromRGB(133, 255, 145)
local v12 = fromRGB(255, 241, 194)
local v13 = fromRGB(255, 210, 60)
local v14 = fromRGB(150, 250, 70)
local v15 = fromRGB(40, 190, 30)
local v16 = fromRGB(110, 185, 110)
local v17 = fromRGB(60, 130, 70)
local v18 = fromRGB(120, 122, 140)
local v19 = fromRGB(64, 66, 80)
local v20 = fromRGB(255, 250, 220)
local _ = {
    Crown = "rbxassetid://125732863205647",
    Pattern = "rbxassetid://78056422817085",
    Cash = "rbxassetid://82001651296436",
    Rod = "rbxassetid://113425379872268",
    Tags = "rbxassetid://128234568586401"
}

local function findPass() -- line: 99
    -- upvalues: Products (copy)
    for _, v21 in Products.Gamepasses do
        if v21.key == "VIP" then
            return v21
        end
    end

    return nil
end

local function capText(p1, p2) -- line: 108
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p2
    UITextSizeConstraint.Parent = p1
end

local function pattern(p3) -- line: 114
    -- upvalues: UIKit (copy), v7 (copy)
    local v22 = UIKit.image(p3, "rbxassetid://78056422817085", {
        Transparency = 0.8,
        ZIndex = 12,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5),
        Color = v7
    })

    v22.Name = "CrownPattern"
    v22.ScaleType = Enum.ScaleType.Tile
    v22.TileSize = UDim2.fromOffset(104, 104)
    UIKit.corner(v22, 16)
end

local function plusSign(p4, p5) -- line: 122
    -- upvalues: UIKit (copy), v1 (copy), v13 (copy)
    UIKit.text(p4, {
        Name = "Plus",
        Text = "+",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 18,
        Size = UDim2.fromOffset(46, 46),
        Position = p5,
        AnchorPoint = v1,
        Color = v13
    })
end

local function tile(p6, p7, p8) -- line: 126
    -- upvalues: UIKit (copy), Right (copy), v1 (copy), v10 (copy), v13 (copy)
    local v23 = UIKit.frame(p6, {
        Transparency = 0.2,
        Corner = 14,
        Stroke = 3,
        ZIndex = 14,
        Name = p7.Header,
        Size = UDim2.fromOffset(140, 126),
        Position = UDim2.fromOffset(p8, 126),
        Color = v10
    })
    local v24 = UIKit.text(p6, {
        Stroke = 4,
        ZIndex = 18,
        Name = p7.Header .. "Header",
        Text = p7.Header,
        Size = UDim2.fromOffset(164, 28),
        Position = UDim2.fromOffset(p8 + 70, 122),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = p7.HeaderColor
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 24
    UITextSizeConstraint.Parent = v24

    local v25 = UIKit.frame(v23, {
        Name = "Art",
        Transparency = 1,
        ZIndex = 15,
        Size = UDim2.fromOffset(86, 86),
        Position = UDim2.new(0.5, 0, 0, 3),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    UIKit.image(v25, p7.Art, {
        ZIndex = 16,
        Size = UDim2.fromScale(1.6, 1.6),
        Position = UDim2.fromScale(0.5, 0.52),
        AnchorPoint = v1
    }).Name = "Picture"

    local v26 = UIKit.text(v23, {
        Name = "Amount",
        Stroke = 3,
        ZIndex = 17,
        Text = p7.Text,
        Size = UDim2.new(1, -12, 0, 30),
        Position = UDim2.new(0.5, 0, 1, -6),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint2.MaxTextSize = 24
    UITextSizeConstraint2.Parent = v26

    if p7.Badge then
        UIKit.text(v23, {
            Name = "Badge",
            TextSize = 18,
            Stroke = 3,
            ZIndex = 18,
            Text = p7.Badge,
            Size = UDim2.fromOffset(84, 22),
            Position = UDim2.new(1, -6, 0, 4),
            AnchorPoint = Vector2.new(1, 0),
            XAlign = Right,
            Color = v13
        })
    end
end

local function tileRow(p9, p10) -- line: 140
    -- upvalues: plusSign (copy), tile (copy)
    for v27, v28 in p10 do
        local v29 = (v27 - 1) * 170 + 26

        if v27 > 1 then
            plusSign(p9, UDim2.fromOffset(v29 - 15, 189))
        end

        tile(p9, v28, v29)
    end
end

local function textLine(p11, p12, p13, p14, p15, p16, p17) -- line: 150
    -- upvalues: UIKit (copy), Left (copy)
    local v30 = UIKit.text(p11, {
        ZIndex = 16,
        Name = p12,
        Text = p13,
        Size = UDim2.fromOffset(258, p14 + 6),
        Position = UDim2.fromOffset(528, p15),
        XAlign = Left,
        Color = p16,
        Stroke = p17
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = p14
    UITextSizeConstraint.Parent = v30

    return v30
end

return {
    Build = function(p18) -- Build | line: 158
        -- upvalues: Products (copy), Rods (copy), UIKit (copy), fromRGB (copy), Left (copy), v1 (copy), LocalPlayer (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), v9 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), pattern (copy), tileRow (copy), textLine (copy)
        local v31 = false
        local v32

        for _, v33 in Products.Gamepasses do
            if v33.key == "VIP" then
                v32 = v33
                v31 = true
                break
            end
        end

        if not v31 then
            v32 = nil
        end

        if not v32 then
            return nil
        end

        local v34 = Rods.ById[v32.rod or ""]
        local v35 = if v34 then math.floor((v34.strength - 1) * 100 + 0.5) else 0
        local v37 = UIKit.frame(p18.Scroll, {
            Name = "VipCard",
            Corner = 20,
            Stroke = 6,
            ZIndex = 12,
            Size = UDim2.fromOffset(p18.Width, 280),
            Color = v4,
            Color2 = v5
        })

        v37.LayoutOrder = p18.NextOrder()
        pattern(v37)

        local v38 = UIKit.frame(v37, {
            Name = "Rim",
            Transparency = 1,
            Corner = 16,
            ZIndex = 13,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.fromOffset(5, 5)
        })

        UIKit.stroke(v38, 3, v6)
        p18.Gleam(v37, {
            Corner = 20,
            ZIndex = 13,
            Period = 7,
            Sweep = 1.1,
            Strength = 0.22,
            Width = 0.15
        })

        local v39 = p18.Width - 22 - 107

        p18.SparkleBack(v37, 20, Vector2.new(v39, 106), 480, v20, {
            {
                v39 - 128,
                40, 22
            },
            {
                v39 + 100,
                34, 18,
                v13
            },
            { 746, 52, 20 }
        })
        UIKit.text(v37, {
            Name = "Title",
            Text = "VIP",
            TextSize = 68,
            Stroke = 6,
            ZIndex = 16,
            Size = UDim2.fromOffset(126, 76),
            Position = UDim2.fromOffset(26, 8),
            XAlign = Left,
            Color = v3
        })

        local v40 = UIKit.frame(v37, {
            Name = "Permanent",
            Corner = 22,
            Stroke = 4,
            ZIndex = 16,
            Size = UDim2.fromOffset(240, 44),
            Position = UDim2.fromOffset(160, 24),
            Color = v8,
            Color2 = v9
        })

        UIKit.text(v40, {
            Name = "Label",
            Text = "PERMANENT PASS",
            TextSize = 23,
            Stroke = 3,
            ZIndex = 17,
            Color = v3
        })
        tileRow(v37, {
            {
                Header = "CASH BOOST",
                Art = "rbxassetid://82001651296436",
                Text = "All Income",
                HeaderColor = v11,
                Badge = "x" .. tostring(v32.boostValue or 1.5)
            },
            {
                Header = "ROD",
                Art = "rbxassetid://113425379872268",
                HeaderColor = fromRGB(255, 160, 200),
                Text = if v34 then v34.name else "Rod",
                Badge = "+" .. v35 .. "% XP"
            },
            {
                Header = "VIP TAGS",
                Art = "rbxassetid://128234568586401",
                Text = "Chat + Name",
                HeaderColor = fromRGB(205, 165, 255)
            }
        })
        textLine(v37, "Boost", "+" .. math.floor(((v32.boostValue or 1.5) - 1) * 100 + 0.5) .. "% CASH", 40, 128, v11, 5)
        textLine(v37, "Scope", "From every income source!", 23, 182, v3, 4)
        textLine(v37, "Rebirth", "Rod returns after rebirth!", 22, 216, v12, 4)

        local v44 = UIKit.image(v37, "rbxassetid://125732863205647", {
            Rotation = -6,
            ZIndex = 15,
            Size = UDim2.fromOffset(224, 224),
            Position = UDim2.fromOffset(v39, 106),
            AnchorPoint = v1
        })

        v44.Name = "Crown"
        p18.Bob(v44, 3, 2.0943951023931953)
        p18.Sway(v44, 4, 1.3)

        local v45, v46 = p18.RobuxButton(v37, v32, UDim2.fromOffset(214, 74), UDim2.new(1, -22, 1, -18), Vector2.new(1, 1), true)
        local v47 = p18.GlowBehind(v45, fromRGB(255, 250, 200), 1.05)
        local v48

        local function setState(p19, p20, p21, p22) -- line: 192
            -- upvalues: v45 (copy), v46 (copy), v47 (copy), v48 (ref), UIKit (copy)
            if p19 then
                v48 = v48 or v46.Text
                v46.Text = p19
            elseif v48 then
                v46.Text = v48
                v48 = nil
            end

            UIKit.setButtonColor(v45, p20, p21)
            v45.Active = p22
            v47.Visible = p22
        end

        local function refresh() -- line: 204
            -- upvalues: p18 (copy), v32 (ref), v45 (copy), v46 (copy), v47 (copy), v48 (ref), UIKit (copy), LocalPlayer (copy), v2 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy)
            if p18.Gifting() then
                local v49 = p18.GiftTarget and p18.GiftTarget()

                if v49 and v49:GetAttribute("OwnsVIP") == true then
                    v48 = v48 or v46.Text
                    v46.Text = "THEY HAVE IT"
                    UIKit.setButtonColor(v45, v18, v19)
                    v45.Active = false
                    v47.Visible = false
                else
                    local v51 = "GIFT  " .. utf8.char(57346) .. " " .. tostring(v32.robux)

                    if v51 then
                        v48 = v48 or v46.Text
                        v46.Text = v51
                    elseif v48 then
                        v46.Text = v48
                        v48 = nil
                    end

                    UIKit.setButtonColor(v45, v14, v15)
                    v45.Active = true
                    v47.Visible = true
                end
            elseif LocalPlayer:GetAttribute("OwnsVIP") == true then
                local v52 = v2 .. " OWNED"

                if v52 then
                    v48 = v48 or v46.Text
                    v46.Text = v52
                elseif v48 then
                    v46.Text = v48
                    v48 = nil
                end

                UIKit.setButtonColor(v45, v16, v17)
                v45.Active = false
                v47.Visible = false
            else
                if v48 then
                    v46.Text = v48
                    v48 = nil
                end

                UIKit.setButtonColor(v45, v14, v15)
                v45.Active = true
                v47.Visible = true
            end
        end

        table.insert(p18.Refreshers, refresh)

        local connection = LocalPlayer:GetAttributeChangedSignal("OwnsVIP"):Connect(refresh)

        v37.Destroying:Once(function() -- line: 220
            -- upvalues: p18 (copy), refresh (copy), connection (copy)
            connection:Disconnect()

            local v53 = table.find(p18.Refreshers, refresh)

            if v53 then
                table.remove(p18.Refreshers, v53)
            end
        end)
        refresh()

        return v37
    end
}
