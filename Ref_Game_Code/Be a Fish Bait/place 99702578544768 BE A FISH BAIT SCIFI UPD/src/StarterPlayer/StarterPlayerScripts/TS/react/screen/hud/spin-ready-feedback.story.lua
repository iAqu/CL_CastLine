-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local SpinReadyText = RuntimeLib.import(script, script.Parent, "spin-ready-feedback").SpinReadyText

local function SpinReadyFeedbackStory() -- line: 12
    -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), SpinReadyText (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useMotion(0)

    useEffect(function() -- line: 16
        -- upvalues: v2 (copy), v4 (copy)
        v4:set(0)

        local v5 = task.delay(2, function() -- line: 18
            -- upvalues: v4 (copy)
            v4:tween(1, {
                time = 1,
                style = Enum.EasingStyle.Quad
            })
        end)
        local v6 = task.delay(3, function() -- line: 24
            -- upvalues: v2 (copy)
            return v2(false)
        end)

        return function() -- line: 27
            -- upvalues: v5 (copy), v6 (copy)
            task.cancel(v5)
            task.cancel(v6)
        end
    end, { v4 })

    if v1 then
        return react.createElement(SpinReadyText, {
            textTransparency = v3
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
end

return storyForScreenGui(react.createElement(SpinReadyFeedbackStory), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
