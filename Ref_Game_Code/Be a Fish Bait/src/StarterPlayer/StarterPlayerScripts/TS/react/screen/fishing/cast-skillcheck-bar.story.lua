-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRef, useState = react.useRef, react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "cast-skillcheck-bar").default
local v1 = RuntimeLib.import(script, script.Parent, "cast-grade-text")
local default3, getGradeFromStrength = v1.default, v1.getGradeFromStrength

local function CastSkillcheckBarStory() -- line: 13
    -- upvalues: react (copy), useRef (copy), useState (copy), default2 (copy), default3 (copy), getGradeFromStrength (copy)
    local v2 = useRef(nil)
    local v3, v4 = useState(false)
    local v5, v6 = useState(nil)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v7 = react.createElement(default2, {
        ref = v2
    })
    local v8 = v5 ~= nil and react.createElement(default3, {
        grade = v5
    })
    local v9 = not v3

    v9 = v9 and react.createElement("textbutton", {
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 100,
        Event = {
            MouseButton1Down = function() -- MouseButton1Down | line: 27
                -- upvalues: v2 (copy), v4 (copy), v6 (copy), getGradeFromStrength (copy)
                local current = v2.current

                if current ~= nil then
                    current:freeze()
                end

                local current2 = v2.current

                if current2 ~= nil then
                    current2 = current2:getStrength()
                end

                if current2 == nil then
                    current2 = 0
                end

                v6(getGradeFromStrength(current2))
                v4(true)
            end
        },
        Size = UDim2.fromScale(1, 1)
    })

    return createElement("frame", t1, v7, v8, v9, react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = "Reset",
        TextScaled = true,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(60, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 54
                -- upvalues: v2 (copy), v4 (copy), v6 (copy)
                v6(nil)
                v4(false)

                local current = v2.current

                if current ~= nil then
                    current:reset()
                end
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0.5, 6, 0.88, 0),
        Size = UDim2.fromOffset(160, 48),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(CastSkillcheckBarStory)))
