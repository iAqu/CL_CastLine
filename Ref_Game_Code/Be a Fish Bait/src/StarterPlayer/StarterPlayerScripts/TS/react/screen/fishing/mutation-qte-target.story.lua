-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "mutation-qte-target").default

local function MutationQteTargetStory() -- line: 9
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(0)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "RESPAWN QTE",
        TextScaled = true,
        ZIndex = 30,
        BackgroundColor3 = Color3.fromRGB(35, 40, 55),
        Event = {
            Activated = function() -- Activated | line: 18
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 19
                    return p1 + 1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.02, 0.03),
        Size = UDim2.fromScale(0.16, 0.06),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("frame", {
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 1,
        BackgroundColor3 = Color3.fromRGB(80, 170, 110),
        Position = UDim2.fromScale(0.15, 0.2),
        Size = UDim2.fromScale(0.2, 0.6)
    }), react.createElement("frame", {
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 1,
        BackgroundColor3 = Color3.fromRGB(80, 170, 110),
        Position = UDim2.fromScale(0.65, 0.2),
        Size = UDim2.fromScale(0.2, 0.6)
    }), react.createElement(default2, {
        mutation = "Gold",
        key = v1,
        onMiss = function() -- onMiss | line: 48
            return print("Mutation QTE missed")
        end,
        onTap = function() -- onTap | line: 51
            return print("Mutation QTE tapped")
        end
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(MutationQteTargetStory)))
