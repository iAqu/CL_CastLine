-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    formatPowerFeedback = function(p1) -- formatPowerFeedback | line: 3
        local v1, v2

        if p1 >= 1E+06 then
            v1 = p1 / 1E+06
            v2 = "M"
        elseif p1 >= 1000 then
            v1 = p1 / 1000
            v2 = "K"
        else
            v1 = p1
            v2 = ""
        end

        local v4 = math.round(v1 * 100) / 100
        local v5 = math.floor(v4)

        if v4 == v5 then
            return (("%*%*"):format(tostring(v5), v2))
        end

        return (("%*%*"):format(string.format("%.2f", v4), v2))
    end,
    moneyGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 208, 42)),
        ColorSequenceKeypoint.new(0.393782, Color3.fromRGB(123, 255, 87)),
        ColorSequenceKeypoint.new(0.571675, Color3.fromRGB(148, 255, 152)),
        ColorSequenceKeypoint.new(0.80829, Color3.fromRGB(23, 255, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 255, 0))
    }),
    powerGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 75, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(225, 125, 15)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(240, 155, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 95, 5))
    }),
    ticketsGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 120)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 245, 160)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 250, 190)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 225, 100))
    }),
    rainbowGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromHSV(0.16666666666666666, 1, 1)),
        ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromHSV(0.3333333333333333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromHSV(0.6666666666666666, 1, 1)),
        ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromHSV(0.8333333333333334, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
    }),
    rebirthGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 30)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 110, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 20))
    })
}
