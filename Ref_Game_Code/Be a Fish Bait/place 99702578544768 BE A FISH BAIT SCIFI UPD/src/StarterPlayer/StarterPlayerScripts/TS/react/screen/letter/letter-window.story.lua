-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local lettersData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "letters").lettersData
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "letter-window").default
local v1 = Color3.fromRGB(168, 133, 82)
local v2 = Color3.fromRGB(74, 48, 23)

local function StoryButton(p1) -- line: 13
    -- upvalues: react (copy), v1 (copy), v2 (copy)
    local label, layoutOrder, onClick = p1.label, p1.layoutOrder, p1.onClick

    return react.createElement("textbutton", {
        AutoButtonColor = true,
        BorderSizePixel = 0,
        TextSize = 16,
        ZIndex = 101,
        BackgroundColor3 = v1,
        Event = {
            Activated = onClick
        },
        Font = Enum.Font.GothamBold,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromOffset(120, 36),
        Text = label,
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Color = v2
    }))
end

local function LetterWindowShowcase() -- line: 38
    -- upvalues: react (copy), useState (copy), default (copy), lettersData (copy), default3 (copy), StoryButton (copy)
    local v3, v4 = useState(true)
    local v5, v6 = useState(0)
    local v7 = #lettersData
    local v8 = lettersData[v5 + 1]

    local function v9(p2) -- line: 43
        -- upvalues: v4 (copy), v5 (copy), v6 (copy), v7 (copy)
        v6((v5 + p2 + v7) % v7)
        v4(true)
    end

    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v13 = react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 100,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.025),
        Size = UDim2.fromOffset(470, 36)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(StoryButton, {
        label = "Previous",
        layoutOrder = 1,
        onClick = function() -- onClick | line: 65
            -- upvalues: v9 (copy)
            return v9(-1)
        end
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        TextScaled = true,
        ZIndex = 101,
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(190, 36),
        Text = ("%* (%*/%*)"):format(v8.recipientName, v5 + 1, v7),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.new()
    }), react.createElement("uitextsizeconstraint", {
        MaxTextSize = 20
    })), react.createElement(StoryButton, {
        label = "Next",
        layoutOrder = 3,
        onClick = function() -- onClick | line: 85
            -- upvalues: v9 (copy)
            return v9(1)
        end
    }))
    local v14 = not v3

    v14 = v14 and react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(120, 36)
    }, react.createElement(StoryButton, {
        label = "Open Letter",
        onClick = function() -- onClick | line: 95
            -- upvalues: v4 (copy)
            return v4(true)
        end
    }))

    return createElement("frame", t1, v13, v14, react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v3
    }, react.createElement(default3, {
        bodyRichText = v8.bodyRichText,
        onClose = function() -- onClose | line: 103
            -- upvalues: v4 (copy)
            return v4(false)
        end,
        recipientColor = v8.recipientColor,
        recipientName = v8.recipientName
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(LetterWindowShowcase)))
