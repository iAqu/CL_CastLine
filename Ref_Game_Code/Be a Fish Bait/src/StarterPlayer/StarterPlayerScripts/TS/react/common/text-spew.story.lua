-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local storyForBillboardGuiWithModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForBillboardGuiWithModel
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "text-spew").default
local t1 = {
    "Hold On Tight..",
    "My Compass Is Curiosity..",
    "Hold On Tight..",
    "Hold On Tight.."
}

local function TextSpewStory(p1) -- line: 11
    -- upvalues: react (copy), useEffect (copy), useState (copy), default2 (copy), t1 (copy)
    local model = p1.model
    local v1, v2 = useState(1)

    useEffect(function() -- line: 14
        -- upvalues: v2 (copy)
        local v3 = task.spawn(function() -- line: 15
            -- upvalues: v2 (copy)
            while true do
                task.wait(2)
                v2(function(p2) -- line: 18
                    return p2 + 1
                end)
            end
        end)

        return function() -- line: 23
            -- upvalues: v3 (copy)
            return task.cancel(v3)
        end
    end, {})

    return react.createElement(default2, {
        count = 1,
        color = Color3.new(1, 1, 1),
        model = model,
        texts = t1,
        trigger = v1
    })
end

return storyForBillboardGuiWithModel(function(p3) -- line: 35
    -- upvalues: react (copy), default (copy), TextSpewStory (copy)
    return react.createElement(default, nil, react.createElement(TextSpewStory, {
        model = p3
    }))
end)
