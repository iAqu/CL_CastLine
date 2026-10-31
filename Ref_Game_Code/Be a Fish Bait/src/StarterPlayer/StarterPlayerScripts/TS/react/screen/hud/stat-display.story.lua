-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = RuntimeLib.import(script, script.Parent, "stat-display")
local default2, PowerFlyItem = v1.default, v1.PowerFlyItem
local n1 = 0
local t1 = {
    {
        label = "No cap (∞)",
        cap = 1e999
    },
    {
        label = "Capped at 100",
        cap = 100
    },
    {
        label = "Capped at 50k",
        cap = 50000
    },
    {
        label = "Capped at 1M",
        cap = 1E+06
    }
}

local function StatDisplayStory() -- line: 26
    -- upvalues: react (copy), useState (copy), abbreviate (copy), default2 (copy), PowerFlyItem (copy), n1 (ref), t1 (copy)
    local v2, v3 = useState(7500000)
    local v4, v5 = useState(1100)
    local v6, v7 = useState({})
    local v8, v9 = useState(0)
    local v10, v11 = useState(0)
    local v12 = t1[v10 + 1]

    local function v13(p1) -- line: 33
        -- upvalues: v7 (copy), n1 (ref)
        local v14 = n1

        n1 += 1
        v7(function(p2) -- line: 37
            -- upvalues: p1 (copy), v14 (copy)
            local t2 = {}
            local v15 = #t2
            local v16 = #p2

            table.move(p2, 1, v16, v15 + 1, t2)
            t2[v15 + v16 + 1] = {
                amount = p1,
                id = v14
            }

            return t2
        end)
    end

    local function v17(p3) -- line: 50
        -- upvalues: v7 (copy)
        v7(function(p4) -- line: 51
            -- upvalues: p3 (copy)
            local t3 = {}
            local n2 = 0

            for v18, v19 in p4 do
                local _ = v18 - 1

                if v19.id ~= p3 == true then
                    n2 += 1
                    t3[n2] = v19
                end
            end

            return t3
        end)
    end

    local v20 = react.createElement(default2, {
        money = v2,
        onPowerAdded = v13,
        power = v4,
        powerBounceTrigger = v8,
        powerCap = v12.cap
    })
    local v21 = table.create(#v6)

    local function v22(p5) -- line: 77
        -- upvalues: v9 (copy), v17 (copy), react (copy), PowerFlyItem (copy)
        return react.createElement(PowerFlyItem, {
            amount = p5.amount,
            key = tostring(p5.id),
            onArrive = function() -- onArrive | line: 81
                -- upvalues: v9 (copy)
                return v9(function(p6) -- line: 82
                    return p6 + 1
                end)
            end,
            onRemove = function() -- onRemove | line: 86
                -- upvalues: p5 (copy), v17 (copy)
                return v17(p5.id)
            end
        })
    end

    for v23, v24 in v6 do
        v21[v23] = v22(v24, v23 - 1, v6)
    end

    local v25 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    })
    local v26 = react.createElement("uilistlayout", {
        FillDirection = "Vertical",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 6)
    })
    local v29 = react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    }, react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 8)
    }), react.createElement("textbutton", {
        Text = "+500K Money",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(30, 180, 60),
        Event = {
            Activated = function() -- Activated | line: 115
                -- upvalues: v3 (copy)
                return v3(function(p7) -- line: 116
                    return p7 + 5E+05
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(145, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })), react.createElement("textbutton", {
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(160, 100, 20),
        Event = {
            Activated = function() -- Activated | line: 131
                -- upvalues: v11 (copy), t1 (copy)
                return v11(function(p8) -- line: 132
                    -- upvalues: t1 (copy)
                    return (p8 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(175, 40),
        Text = ("Cap: %*"):format(v12.label),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
    local v30 = react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 6)
    })
    local t10 = {
        {
            amount = 3,
            label = "Steel"
        },
        {
            amount = 100,
            label = "Puffer"
        },
        {
            amount = 3000,
            label = "Anchor"
        },
        {
            amount = 30000,
            label = "Shipwreck"
        },
        {
            amount = 1E+05,
            label = "Cards"
        },
        {
            amount = 1E+06,
            label = "Kraken"
        },
        {
            amount = 3E+06,
            label = "Poseidon"
        },
        {
            amount = 5E+06,
            label = "Diamond"
        },
        {
            amount = 3E+07,
            label = "Blackhole"
        },
        {
            amount = 1E+08,
            label = "Judgement"
        }
    }
    local v31 = table.create(#t10)

    local function v32(p9) -- line: 184
        -- upvalues: v5 (copy), react (copy), abbreviate (copy)
        local amount, label = p9.amount, p9.label

        return react.createElement("textbutton", {
            TextScaled = true,
            BackgroundColor3 = Color3.fromRGB(0, 140, 210),
            Event = {
                Activated = function() -- Activated | line: 190
                    -- upvalues: amount (copy), v5 (copy)
                    return v5(function(p10) -- line: 191
                        -- upvalues: amount (copy)
                        return p10 + amount
                    end)
                end
            },
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromOffset(95, 40),
            Text = ("%*\n+%*"):format(label, (abbreviate(amount))),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            key = label
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.25, 0)
        }))
    end

    for v33, v34 in t10 do
        v31[v33] = v32(v34, v33 - 1, t10)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v20, v21, react.createElement("frame", {
        BackgroundTransparency = 0.4,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Position = UDim2.fromScale(0.5, 0.95),
        Size = UDim2.fromOffset(1020, 110)
    }, v25, v26, v29, react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    }, v30, v31)))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(StatDisplayStory)))
