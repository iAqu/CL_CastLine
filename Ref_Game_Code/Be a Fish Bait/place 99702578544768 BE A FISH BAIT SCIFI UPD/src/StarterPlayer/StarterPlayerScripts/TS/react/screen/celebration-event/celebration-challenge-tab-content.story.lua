-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "celebration-challenge-tab-content").default
local t1 = {
    0, 10, 100, 1000, 10000, 1E+05, 1E+06, 1E+07,
    1E+08, 1E+09
}

local function DigitPresetControl(p1) -- line: 14
    -- upvalues: react (copy), useState (copy)
    local digitCount, isSelected, onChange, onSelect = p1.digitCount, p1.isSelected, p1.onChange, p1.onSelect
    local value = p1.value
    local v1, v2 = useState((tostring(value)))

    local function commit(p2) -- line: 21
        -- upvalues: onChange (copy), value (copy), v2 (copy)
        local v3 = tonumber(p2)

        if v3 ~= nil then
            onChange(v3)
            v2((tostring(v3)))
        else
            v2((tostring(value)))
        end
    end

    return react.createElement("frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 32)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uipadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextSize = 12,
        ZIndex = 1000,
        BackgroundColor3 = if isSelected then Color3.fromRGB(60, 140, 60) else Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = onSelect
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 74, 1, 0),
        Text = ("%* digit%*"):format(digitCount, digitCount == 1 and "" or "s"),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbox", {
        BorderSizePixel = 0,
        TextSize = 12,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Change = {
            Text = function(p3) -- Text | line: 59
                -- upvalues: v2 (copy)
                return v2(p3.Text)
            end
        },
        Event = {
            FocusLost = function(p4) -- FocusLost | line: 64
                -- upvalues: commit (copy)
                return commit(p4.Text)
            end
        },
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -78, 1, 0),
        Text = v1,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

local function CelebrationChallengeTabContentShowcase() -- line: 76
    -- upvalues: react (copy), useState (copy), default2 (copy), t1 (copy), DigitPresetControl (copy)
    local v7, v8 = useState(t1)
    local v9, v10 = useState(8)

    local function v11(p5, p6) -- line: 80
        -- upvalues: v8 (copy)
        v8(function(p7) -- line: 81
            -- upvalues: p5 (copy), p6 (copy)
            local v12 = table.create(#p7)

            for v13, v14 in p7 do
                if v13 - 1 == p5 then
                    v12[v13] = p6
                else
                    v12[v13] = v14
                end
            end

            return v12
        end)
    end

    local v15 = react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.68, 0.9)
    }, react.createElement(default2, {
        currentTicketsOverride = v7[v9 + 1],
        key = tostring(v9)
    }))
    local v16 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 4)
    })
    local v17 = table.create(#t1)

    local function v18(_, p9) -- line: 110
        -- upvalues: v7 (copy), v9 (copy), v10 (copy), v11 (copy), react (copy), DigitPresetControl (copy)
        return react.createElement(DigitPresetControl, {
            digitCount = p9 + 1,
            isSelected = v9 == p9,
            key = tostring(p9),
            onChange = function(p10) -- onChange | line: 115
                -- upvalues: p9 (copy), v11 (copy)
                return v11(p9, p10)
            end,
            onSelect = function() -- onSelect | line: 118
                -- upvalues: p9 (copy), v10 (copy)
                return v10(p9)
            end,
            value = v7[p9 + 1]
        })
    end

    for v19, v20 in t1 do
        v17[v19] = v18(v20, v19 - 1, t1)
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Size = UDim2.fromScale(1, 1)
    }, v15, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.new(0, 260, 0, #t1 * 36)
    }, v16, v17))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CelebrationChallengeTabContentShowcase)))
