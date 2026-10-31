-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "celebration-ticket-challenge-window").default
local t1 = {
    0, 1.3E+08, 2.5E+08, 3.8E+08, 5.2E+08, 6.7E+08, 8.3E+08, 1E+09,
    1.18E+09, 1.35E+09, 1.5E+09
}
local t2 = {
    0, 10, 100, 1000, 10000, 1E+05, 1E+06, 1E+07,
    1E+08, 1E+09
}

local function DigitPresetControl(p1) -- line: 19
    -- upvalues: react (copy), useState (copy)
    local digitCount, isSelected, onChange, onSelect = p1.digitCount, p1.isSelected, p1.onChange, p1.onSelect
    local value = p1.value
    local v1, v2 = useState((tostring(value)))

    local function commit(p2) -- line: 26
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
            Text = function(p3) -- Text | line: 64
                -- upvalues: v2 (copy)
                return v2(p3.Text)
            end
        },
        Event = {
            FocusLost = function(p4) -- FocusLost | line: 69
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

local function CelebrationTicketChallengeShowcase() -- line: 81
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy), t1 (copy), t2 (copy), DigitPresetControl (copy)
    local v7, v8 = useState(true)
    local v9, v10 = useState(0)
    local v11, v12 = useState(t2)
    local v13, v14 = useState(nil)

    local function v15(p5, p6) -- line: 87
        -- upvalues: v12 (copy)
        v12(function(p7) -- line: 88
            -- upvalues: p5 (copy), p6 (copy)
            local v16 = table.create(#p7)

            for v17, v18 in p7 do
                if v17 - 1 == p5 then
                    v16[v17] = p6
                else
                    v16[v17] = v18
                end
            end

            return v16
        end)
    end

    local v19 = if v13 == nil then t1[v9 + 1] else v11[v13 + 1]
    local v20 = not v7

    v20 = v20 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Ticket Challenge",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 107
                -- upvalues: v8 (copy)
                return v8(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    local v21 = react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -12, 1, -12),
        Size = UDim2.fromOffset(220, 40)
    }, react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        TextScaled = true,
        ZIndex = 1000,
        BackgroundColor3 = if v13 == nil then Color3.fromRGB(60, 100, 200) else Color3.fromRGB(70, 70, 70),
        Event = {
            Activated = function() -- Activated | line: 130
                -- upvalues: v10 (copy), v14 (copy), t1 (copy)
                v14(nil)
                v10(function(p8) -- line: 132
                    -- upvalues: t1 (copy)
                    return (p8 + 1) % #t1
                end)
            end
        },
        Size = UDim2.fromOffset(220, 40),
        Text = ("Challenge Tickets: %*"):format(t1[v9 + 1]),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    })))
    local v22 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 4)
    })
    local v23 = table.create(#t2)

    local function v24(_, p10) -- line: 152
        -- upvalues: v11 (copy), v13 (copy), v14 (copy), v15 (copy), react (copy), DigitPresetControl (copy)
        return react.createElement(DigitPresetControl, {
            digitCount = p10 + 1,
            isSelected = v13 == p10,
            key = tostring(p10),
            onChange = function(p11) -- onChange | line: 157
                -- upvalues: p10 (copy), v15 (copy)
                return v15(p10, p11)
            end,
            onSelect = function() -- onSelect | line: 160
                -- upvalues: p10 (copy), v14 (copy)
                return v14(p10)
            end,
            value = v11[p10 + 1]
        })
    end

    for v25, v26 in t2 do
        v23[v25] = v24(v26, v25 - 1, t2)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v20, v21, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.new(0, 260, 0, #t2 * 36)
    }, v22, v23), react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v7
    }, react.createElement(default3, {
        currentTickets = v19,
        onClose = function() -- onClose | line: 184
            -- upvalues: v8 (copy)
            return v8(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default2, nil, react.createElement(CelebrationTicketChallengeShowcase)))
