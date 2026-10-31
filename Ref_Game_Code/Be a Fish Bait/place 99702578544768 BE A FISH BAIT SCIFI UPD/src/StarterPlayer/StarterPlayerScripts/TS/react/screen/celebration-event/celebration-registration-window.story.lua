-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "celebration-registration-window").default

local function CelebrationRegistrationWindowShowcase() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(false)
    local v5, v6 = useState(false)
    local v7, v8 = useState(1234)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v9 = not v1

    v9 = v9 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Celebration Registration",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 23
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

    return createElement("frame", t1, v9, react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v1
    }, react.createElement(default3, {
        isRegistered = v3,
        justRegistered = v5,
        onClose = function() -- onClose | line: 41
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onRegister = function() -- onRegister | line: 44
            -- upvalues: v4 (copy), v6 (copy), v8 (copy)
            v4(true)
            v6(true)
            v8(function(p1) -- line: 47
                return p1 + 1
            end)
        end,
        registeredCount = v7
    })))
end

return storyForScreenGui(react.createElement(default2, nil, react.createElement(CelebrationRegistrationWindowShowcase)))
