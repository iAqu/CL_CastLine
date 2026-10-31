-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local createContext = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").createContext
local t1 = {
    colorSequences = {
        gold = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0.980392, 0.980392, 0.176471)),
            ColorSequenceKeypoint.new(0.9965457916259766, Color3.new(0.996078, 0.819608, 0.105882)),
            ColorSequenceKeypoint.new(1, Color3.new(0.945098, 1, 0.333333))
        }),
        purpleGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0.392157, 0, 0.980392)),
            ColorSequenceKeypoint.new(0.8739205598831177, Color3.new(0.337255, 0, 0.847059)),
            ColorSequenceKeypoint.new(1, Color3.new(0.219608, 0, 0.545098))
        }),
        white = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }),
        lightBlue = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0.32, 0.84, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(0.392157, 0.588235, 0.980392))
        }),
        yellowGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 254, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 5))
        }),
        greenGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 254, 86)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 186, 13))
        }),
        orangeGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 165, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))
        }),
        blueGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 207, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 115, 255))
        }),
        redGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 40, 40))
        }),
        blackGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(94, 94, 94)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 46, 46))
        }),
        whiteGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 189, 189))
        }),
        veryBlackGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 74, 74)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        CYTGreenGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 255, 19)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 250, 29))
        }),
        CYTBlueGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 207, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 115, 255))
        }),
        CYTPurpleGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(189, 105, 252)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(112, 36, 201))
        }),
        CYTDarkGreenGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 242, 176)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 212, 95))
        }),
        pinkGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 153, 204)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 105, 168))
        })
    },
    textFont = Enum.Font.FredokaOne,
    textFont2 = Enum.Font.GothamBlack,
    textFont3 = Enum.Font.Highway,
    textFont4 = Enum.Font.GothamBold
}

return {
    defaultTheme = t1,
    ThemeContext = createContext(t1)
}
