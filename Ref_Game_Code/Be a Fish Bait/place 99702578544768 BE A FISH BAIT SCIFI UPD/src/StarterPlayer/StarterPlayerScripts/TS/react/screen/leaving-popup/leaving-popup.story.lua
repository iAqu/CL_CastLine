-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "leaving-popup").default

local function LeavingPopupShowcase() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(true)

    return react.createElement("frame", {
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.12),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.6, 0.55)
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "GothamMedium",
        Text = "Are you sure you want to leave the experience?",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.35),
        Size = UDim2.fromScale(0.8, 0.1),
        TextColor3 = Color3.new(0.9, 0.9, 0.9)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Toggle Leaving Popup",
        TextScaled = true,
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.new(0.2, 0.5, 0.9),
        Event = {
            Activated = function() -- Activated | line: 38
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 39
                    return not p1
                end)
            end
        },
        Position = UDim2.fromScale(0.48, 0.98),
        Size = UDim2.fromOffset(260, 44),
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        TextScaled = true,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = if v3 then Color3.fromRGB(80, 190, 70) else Color3.fromRGB(120, 90, 220),
        Event = {
            Activated = function() -- Activated | line: 55
                -- upvalues: v4 (copy)
                return v4(function(p2) -- line: 56
                    return not p2
                end)
            end
        },
        Position = UDim2.fromScale(0.52, 0.98),
        Size = UDim2.fromOffset(320, 44),
        Text = v3 and "Mode: First Daily Claim" or "Mode: Subsequent Leave",
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        buffKind = "mutationLuck",
        forecastEarnings = 12345678,
        showBanners = true,
        canClaimBuff = v3,
        onDismiss = function() -- onDismiss | line: 74
            -- upvalues: v2 (copy)
            return v2(false)
        end
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(LeavingPopupShowcase)))
