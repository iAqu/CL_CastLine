-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "celebration-farewell-cutscene").default

local function Showcase() -- line: 9
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(true)

    if v1 then
        return (react.createElement(default2, {
            onDone = function() -- onDone | line: 12
                -- upvalues: v2 (copy)
                return v2(false)
            end
        }))
    end

    return (react.createElement("textbutton", {
        Text = "Replay Farewell",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Event = {
            Activated = function() -- Activated | line: 18
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.25, 0.08)
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(Showcase)))
