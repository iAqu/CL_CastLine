-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local v1 = RuntimeLib.import(script, script.Parent, "mount-fish-preview-overlay")
local MountFishPreviewBuyButton, MountFishPreviewCloseButton = v1.MountFishPreviewBuyButton, v1.MountFishPreviewCloseButton

local function MountFishPreviewOverlayShowcase() -- line: 12
    -- upvalues: react (copy), useState (copy), default (copy), MountFishPreviewBuyButton (copy), MountFishPreviewCloseButton (copy)
    local v2, v3 = useState(true)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, if v2 then react.createElement(react.Fragment, nil, react.createElement(MountFishPreviewCloseButton, {
        onClose = function() -- onClose | line: 18
            -- upvalues: v3 (copy)
            return v3(false)
        end
    }), react.createElement(MountFishPreviewBuyButton, {
        price = 899,
        productId = 3611261222,
        onClick = function() -- onClick | line: 22
            return print("buy mount")
        end
    })) else react.createElement(default, {
        label = "REOPEN PREVIEW",
        zIndex = 10,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(65, 205, 92),
        frameSize = UDim2.fromScale(0.2, 0.1),
        onClick = function() -- onClick | line: 32
            -- upvalues: v3 (copy)
            return v3(true)
        end,
        popoutColor = Color3.fromRGB(22, 105, 42),
        position = UDim2.fromScale(0.5, 0.5)
    }))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(MountFishPreviewOverlayShowcase)))
