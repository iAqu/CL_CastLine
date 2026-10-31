-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "fish-nibble-screen").default
local default3 = RuntimeLib.import(script, script.Parent, "bonus-slots-hud").default
local t1 = {
    {
        count = 0,
        label = "No bonus",
        activeColor = Color3.fromRGB(50, 100, 180)
    },
    {
        count = 1,
        label = "×1 bonus",
        activeColor = Color3.fromRGB(70, 140, 60)
    },
    {
        count = 2,
        label = "×2 bonus",
        activeColor = Color3.fromRGB(160, 90, 30)
    },
    {
        count = 3,
        label = "×3 bonus ✦",
        activeColor = Color3.fromRGB(140, 50, 160)
    }
}
local v1 = Color3.fromRGB(40, 40, 55)

local function NibbleScreenStory() -- line: 28
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), t1 (copy), v1 (copy)
    local v2, v3 = useState(0)
    local v4 = react.createElement(default2, {
        bonusComboCount = v2
    })
    local v5 = v2 > 0 and react.createElement(default3, {
        bonusComboCount = v2
    })
    local v6 = react.createElement("uilistlayout", {
        FillDirection = "Horizontal",
        HorizontalAlignment = "Center",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 8)
    })
    local v7 = table.create(#t1)

    local function v8(p1) -- line: 44
        -- upvalues: v2 (copy), v3 (copy), react (copy), v1 (copy)
        local count, label, activeColor = p1.count, p1.label, p1.activeColor

        return react.createElement("textbutton", {
            BorderSizePixel = 0,
            TextScaled = true,
            BackgroundColor3 = if v2 ~= count then v1 else activeColor,
            Event = {
                Activated = function() -- Activated | line: 52
                    -- upvalues: count (copy), v3 (copy)
                    return v3(count)
                end
            },
            Size = UDim2.fromOffset(120, 36),
            Text = label,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            key = label
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        }))
    end

    for v9, v10 in t1 do
        v7[v9] = v8(v10, v9 - 1, t1)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v4, v5, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.new(0, 560, 0, 36)
    }, v6, v7))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(NibbleScreenStory)), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
