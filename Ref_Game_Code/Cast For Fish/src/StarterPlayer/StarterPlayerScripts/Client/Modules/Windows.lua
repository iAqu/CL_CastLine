-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UIKit = require(script.Parent.UIKit)
local t1 = {}

function t1.Init() -- line: 7
    -- upvalues: UIKit (copy), t1 (copy)
    local v1 = UIKit.screenGui("Windows", 10)

    t1.Gui = v1

    local Colors = UIKit.Colors

    UIKit.window(v1, {
        Name = "Index",
        KeepRendered = true,
        Title = "Fish Index",
        GradientRotation = 0,
        Size = UDim2.fromOffset(1340, 830),
        Position = UDim2.new(0.5, 0, 0.5, -24),
        HeaderColor = Color3.fromRGB(70, 200, 255),
        HeaderColor2 = Color3.fromRGB(120, 84, 250)
    })
    UIKit.window(v1, {
        Name = "Shop",
        Title = "Shop",
        GradientRotation = 0,
        Icon = "Shop",
        Size = UDim2.fromOffset(1080, 760),
        HeaderColor = Colors.Orange,
        HeaderColor2 = Colors.Pink
    })
    UIKit.window(v1, {
        Name = "BaitShop",
        Title = "Bait Shop",
        Size = UDim2.fromOffset(1020, 470),
        HeaderColor = Colors.Magenta,
        HeaderColor2 = Colors.MagentaDark
    })
    UIKit.window(v1, {
        Name = "RodShop",
        Title = "Rod Shop",
        Size = UDim2.fromOffset(1020, 470),
        HeaderColor = Colors.Green,
        HeaderColor2 = Colors.GreenDark
    })
    UIKit.window(v1, {
        Name = "Sell",
        Title = "Sell Fish",
        Size = UDim2.fromOffset(900, 760),
        HeaderColor = Colors.Red,
        HeaderColor2 = Colors.RedDark
    })
    UIKit.window(v1, {
        Name = "Settings",
        Title = "Settings",
        Image = "Gear",
        Size = UDim2.fromOffset(640, 600),
        HeaderColor = Colors.Blue,
        HeaderColor2 = Colors.BlueDark
    })
    UIKit.window(v1, {
        Name = "MyFish",
        Title = "My Fish",
        NoBlur = true,
        Icon = "Fish",
        Size = UDim2.fromOffset(680, 760),
        Position = UDim2.new(1, -20, 0.5, -30),
        AnchorPoint = Vector2.new(1, 0.5),
        HeaderColor = Colors.Pink,
        HeaderColor2 = Colors.Magenta
    })
end

return t1
