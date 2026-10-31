-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "cast-power-cap-bar").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils")
local getRebirthPowerCost, maxRebirthLevel = v1.getRebirthPowerCost, v1.maxRebirthLevel
local t1 = {
    {
        label = "0/4M",
        rawPower = 0,
        powerCap = 4E+06
    },
    {
        label = "1M/4M",
        rawPower = 1E+06,
        powerCap = 4E+06
    },
    {
        label = "2M/4M",
        rawPower = 2040544,
        powerCap = 4E+06
    },
    {
        label = "3M/4M",
        rawPower = 3E+06,
        powerCap = 4E+06
    },
    {
        label = "4M/4M (capped)",
        rawPower = 4E+06,
        powerCap = 4E+06
    },
    {
        label = "0/80M",
        rawPower = 0,
        powerCap = 8E+07
    },
    {
        label = "20M/80M",
        rawPower = 2E+07,
        powerCap = 8E+07
    },
    {
        label = "43M/80M",
        rawPower = 43248000,
        powerCap = 8E+07
    },
    {
        label = "60M/80M",
        rawPower = 6E+07,
        powerCap = 8E+07
    }
}

local function CastPowerCapBarStory() -- line: 52
    -- upvalues: react (copy), useState (copy), default2 (copy), getRebirthPowerCost (copy), maxRebirthLevel (copy), t1 (copy)
    local v2, v3 = useState(0)
    local v4, v5 = useState(0)
    local v6, v7 = useState(0)
    local v8 = t1[v2 + 1]
    local v9 = getRebirthPowerCost(v6)
    local createElement = react.createElement
    local t2 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v10 = react.createElement(default2, {
        forceVisible = true,
        rodImageId = "rbxassetid://107751287391457",
        key = tostring(v4),
        powerCap = v8.powerCap,
        rawPower = v8.rawPower,
        rebirthCount = v6
    })
    local createElement2 = react.createElement
    local t3 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromScale(0.5, 0.82),
        Size = UDim2.fromOffset(500, 28)
    }
    local v11 = "Preset: %* | raw=%* cap=%* | rebirth=%* | next cost=%*"
    local label, rawPower = v8.label, v8.rawPower
    local v12 = if v8.powerCap == 1e999 then "∞" else v8.powerCap

    if v9 == 1e999 then
        v9 = "∞"
    end

    t3.Text = v11:format(label, rawPower, v12, v6, v9)
    t3.TextColor3 = Color3.fromRGB(200, 200, 200)

    return createElement("frame", t2, v10, createElement2("textlabel", t3), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Next Preset",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 84
                -- upvalues: v3 (copy), t1 (copy)
                return v3(function(p1) -- line: 85
                    -- upvalues: t1 (copy)
                    return (p1 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.99),
        Size = UDim2.fromOffset(200, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Replay animateIn",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(60, 160, 60),
        Event = {
            Activated = function() -- Activated | line: 105
                -- upvalues: v5 (copy)
                return v5(function(p2) -- line: 106
                    return p2 + 1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.93),
        Size = UDim2.fromOffset(200, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Rebirth -",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(140, 60, 180),
        Event = {
            Activated = function() -- Activated | line: 126
                -- upvalues: v7 (copy)
                return v7(function(p3) -- line: 127
                    return (math.max(0, p3 - 1))
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.38, 0.87),
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.87),
        Size = UDim2.fromOffset(120, 40),
        Text = ("Rebirth %*"):format(v6),
        TextColor3 = Color3.fromRGB(200, 160, 255)
    }), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Rebirth +",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(140, 60, 180),
        Event = {
            Activated = function() -- Activated | line: 157
                -- upvalues: v7 (copy), maxRebirthLevel (copy)
                return v7(function(p4) -- line: 158
                    -- upvalues: maxRebirthLevel (copy)
                    return (math.min(maxRebirthLevel, p4 + 1))
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.62, 0.87),
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CastPowerCapBarStory)))
