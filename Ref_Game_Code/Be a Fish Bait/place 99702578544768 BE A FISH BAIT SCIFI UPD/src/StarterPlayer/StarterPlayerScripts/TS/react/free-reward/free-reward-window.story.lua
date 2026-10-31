-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "free-reward-window").default

local function FreeRewardWindowShowcase() -- line: 7
    -- upvalues: react (copy), default2 (copy)
    local v1, v2 = react.useState(true)

    if v1 then
        return react.createElement(default2, {
            isClaimed = true,
            onClaim = function() -- onClaim | line: 35
                -- upvalues: v2 (copy)
                print("Claim button clicked!")
                v2(false)
            end,
            onClose = function() -- onClose | line: 39
                -- upvalues: v2 (copy)
                return v2(false)
            end
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("textbutton", {
        Font = "Arcade",
        Text = "Show Free Reward Window",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 19
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(200, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    })))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(FreeRewardWindowShowcase)))
