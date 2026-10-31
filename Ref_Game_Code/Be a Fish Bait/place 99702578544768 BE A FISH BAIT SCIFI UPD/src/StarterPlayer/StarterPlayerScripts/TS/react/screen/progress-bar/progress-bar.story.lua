-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "progress-bar").default

local function ProgressBarStory() -- line: 12
    -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default2 (copy)
    local v1, v2 = useState(false)
    local v3, v4 = useMotion(0.5)

    useEffect(function() -- line: 15
        -- upvalues: v1 (copy), v4 (copy)
        if v1 then
            local v5 = false
            local v6 = task.spawn(function() -- line: 21
                -- upvalues: v5 (ref), v4 (copy)
                while not v5 do
                    v4:immediate(0)
                    task.wait(0.05)

                    if v5 then
                        break
                    end

                    v4:tween(1, {
                        time = 5,
                        direction = Enum.EasingDirection.Out,
                        style = Enum.EasingStyle.Linear
                    })
                    task.wait(5.8)
                end
            end)

            return function() -- line: 36
                -- upvalues: v5 (ref), v6 (copy)
                v5 = true
                task.cancel(v6)
            end
        end

        v4:stop()

        return nil
    end, { v1, v4 })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0),
        position = UDim2.fromScale(0.5, 0.1),
        progress = v3
    }), react.createElement("textbutton", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = if v1 then Color3.fromRGB(200, 40, 40) else Color3.fromRGB(40, 180, 60),
        Event = {
            Activated = function() -- Activated | line: 54
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 55
                    return not p1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.88),
        Size = UDim2.fromOffset(180, 48),
        Text = v1 and "Stop" or "Simulate Cast",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(ProgressBarStory)))
