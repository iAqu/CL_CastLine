-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "preview-icon-button").default

local function PreviewIconButtonStory() -- line: 9
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(true)
    local createElement = react.createElement
    local t1 = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(20, 24, 28),
        Size = UDim2.fromScale(1, 1)
    }
    local createElement2 = react.createElement
    local t2 = {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(18, 112, 82),
        Position = UDim2.fromScale(0.35, 0.5),
        Size = UDim2.fromScale(0.28, 0.5)
    }

    v1 = v1 and react.createElement(default2, {
        zIndex = 3,
        onClick = function() -- onClick | line: 22
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        position = UDim2.fromScale(0.78, 0.7),
        size = UDim2.fromScale(0.2, 0.2)
    })

    return createElement("frame", t1, createElement2("frame", t2, v1), react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(246, 194, 40),
        Position = UDim2.fromScale(0.65, 0.5),
        Size = UDim2.fromScale(0.28, 0.5)
    }, react.createElement(default2, {
        zIndex = 3,
        onClick = function() -- onClick | line: 35
            return print("Preview button clicked")
        end,
        position = UDim2.fromScale(0.78, 0.7),
        size = UDim2.fromScale(0.2, 0.2)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "RESET PREVIEW BUTTON",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(55, 65, 72),
        Event = {
            Activated = function() -- Activated | line: 46
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.94),
        Size = UDim2.fromScale(0.24, 0.08),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(PreviewIconButtonStory)))
