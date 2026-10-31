-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "circular-progress").default
local t1 = {
    "Up",
    "Down",
    "Left",
    "Right"
}
local t2 = {
    "Left",
    "Middle",
    "Right"
}
local t3 = {
    "Trans",
    "Color",
    "TransAndColor"
}

local function CircularProgressStory() -- line: 15
    -- upvalues: react (copy), useEffect (copy), useState (copy), RunService (copy), default2 (copy), t1 (copy), t2 (copy), t3 (copy)
    local v1, v2 = useState(0)
    local v3, v4 = useState(0)
    local v5, v6 = useState(2)
    local v7, v8 = useState(75)
    local v9, v10 = useState(false)
    local v11, v12 = useState(0)

    useEffect(function() -- line: 22
        -- upvalues: v9 (copy), v10 (copy), v12 (copy), RunService (copy)
        if not v9 then
            return nil
        end

        local v13 = os.clock() * 1000

        v12(0)

        local connection

        connection = RunService.Heartbeat:Connect(function() -- line: 29
            -- upvalues: v13 (copy), connection (ref), v10 (copy), v12 (copy)
            local v15 = math.clamp((os.clock() * 1000 - v13) / 2000, 0, 1)

            v12(v15 * 100)

            if not (v15 >= 1) then
                return
            end

            v10(false)
            connection:Disconnect()
        end)

        return function() -- line: 37
            -- upvalues: connection (ref)
            return connection:Disconnect()
        end
    end, { v9 })

    if not v9 then
        v11 = v7
    end

    local v16 = t1[v1 + 1]
    local v17 = t2[v3 + 1]
    local v18 = t3[v5 + 1]

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        direction = v17,
        missingPartType = v18,
        position = UDim2.fromScale(0.5, 0.45),
        progress = v11,
        size = UDim2.fromOffset(160, 160),
        starterPoint = v16
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromScale(0.5, 0.68),
        Size = UDim2.fromOffset(600, 24),
        Text = ("%*%%  |  starterPoint: %*  |  direction: %*  |  missing: %*"):format(math.floor(v11), v16, v17, v18),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.99),
        Size = UDim2.fromOffset(720, 54)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Run Timer",
        TextScaled = true,
        ZIndex = 10,
        BackgroundColor3 = Color3.fromRGB(50, 160, 50),
        Event = {
            Activated = function() -- Activated | line: 81
                -- upvalues: v10 (copy)
                return v10(true)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(130, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "+10% Static",
        TextScaled = true,
        ZIndex = 10,
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 97
                -- upvalues: v8 (copy)
                return v8(function(p1) -- line: 98
                    local v24 = math.floor(p1 / 10 + 1.5) * 10

                    if v24 > 100 then
                        return 0
                    end

                    return v24
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(130, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "StarterPt",
        TextScaled = true,
        ZIndex = 10,
        BackgroundColor3 = Color3.fromRGB(160, 60, 200),
        Event = {
            Activated = function() -- Activated | line: 116
                -- upvalues: v2 (copy), t1 (copy)
                return v2(function(p2) -- line: 117
                    -- upvalues: t1 (copy)
                    return (p2 + 1) % #t1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(130, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Direction",
        TextScaled = true,
        ZIndex = 10,
        BackgroundColor3 = Color3.fromRGB(180, 100, 30),
        Event = {
            Activated = function() -- Activated | line: 134
                -- upvalues: v4 (copy), t2 (copy)
                return v4(function(p3) -- line: 135
                    -- upvalues: t2 (copy)
                    return (p3 + 1) % #t2
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(120, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Missing",
        TextScaled = true,
        ZIndex = 10,
        BackgroundColor3 = Color3.fromRGB(30, 150, 150),
        Event = {
            Activated = function() -- Activated | line: 152
                -- upvalues: v6 (copy), t3 (copy)
                return v6(function(p4) -- line: 153
                    -- upvalues: t3 (copy)
                    return (p4 + 1) % #t3
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(120, 44),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.3, 0)
    }))))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CircularProgressStory)))
