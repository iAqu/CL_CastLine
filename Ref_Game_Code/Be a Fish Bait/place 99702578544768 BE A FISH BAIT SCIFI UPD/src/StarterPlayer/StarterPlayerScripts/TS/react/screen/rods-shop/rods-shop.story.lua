-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "rod-shop-story-showcase").default

local function RodsShopShowcase() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v3 = not v1

    v3 = v3 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Rods Shop",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.8, 0.1, 0.1),
        Event = {
            Activated = function() -- Activated | line: 20
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    return createElement("frame", t1, v3, react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        initialTab = "rods",
        onClose = function() -- onClose | line: 37
            -- upvalues: v2 (copy)
            return v2(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(RodsShopShowcase)))
