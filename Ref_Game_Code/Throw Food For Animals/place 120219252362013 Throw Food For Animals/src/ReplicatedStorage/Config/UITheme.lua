-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Font = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    Colors = {
        Text = Color3.fromRGB(255, 255, 255),
        TextStroke = Color3.fromRGB(0, 0, 0),
        Panel = Color3.fromRGB(48, 48, 55),
        PanelStroke = Color3.fromRGB(26, 26, 32),
        PanelGradientA = Color3.fromRGB(74, 74, 84),
        PanelGradientB = Color3.fromRGB(52, 52, 60),
        HeaderA = Color3.fromRGB(248, 92, 232),
        HeaderB = Color3.fromRGB(200, 68, 222),
        CardA = Color3.fromRGB(210, 210, 215),
        CardB = Color3.fromRGB(160, 160, 170),
        GreenA = Color3.fromRGB(152, 246, 72),
        GreenB = Color3.fromRGB(98, 204, 34),
        RedA = Color3.fromRGB(250, 75, 75),
        RedB = Color3.fromRGB(195, 22, 22),
        BlueA = Color3.fromRGB(96, 205, 255),
        BlueB = Color3.fromRGB(28, 132, 235),
        YellowA = Color3.fromRGB(255, 220, 90),
        YellowB = Color3.fromRGB(240, 160, 20),
        GrayA = Color3.fromRGB(150, 150, 160),
        GrayB = Color3.fromRGB(100, 100, 110),
        Money = Color3.fromRGB(120, 230, 90),
        Power = Color3.fromRGB(80, 200, 255),
        Xp = Color3.fromRGB(96, 205, 255),
        XpTrack = Color3.fromRGB(66, 118, 28),
        XpOuter = Color3.fromRGB(42, 82, 18),
        Dim = Color3.fromRGB(0, 0, 0)
    },
    Stroke = {
        Text = 3,
        TextBig = 4,
        Panel = 5,
        Button = 3,
        Card = 3
    },
    Corner = {
        Panel = 16,
        Card = 12,
        Button = 8,
        Bar = 12
    },
    Icons = {
        Money = "rbxassetid://122634913225226",
        Power = "rbxassetid://17127979242"
    },
    StripeTransparency = function() -- StripeTransparency | line: 63
        local t1 = {}

        for i = 0, 9 do
            local v1 = i / 10
            local v2 = (i + 1) / 10
            local v3 = i % 2 == 0

            table.insert(t1, NumberSequenceKeypoint.new(v1, v3 and 1 or 0))
            table.insert(t1, NumberSequenceKeypoint.new(math.min(v2 - 0.001, 1), v3 and 1 or 0))
        end

        t1[#t1] = NumberSequenceKeypoint.new(1, 0)

        return NumberSequence.new(t1)
    end
}
