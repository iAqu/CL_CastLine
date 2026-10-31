-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default

return {
    default = function() -- NibblingText | line: 9
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), default (copy)
        local v1, v2 = useState(0)
        local v3, v4 = useMotion(0)

        useEffect(function() -- line: 12
            -- upvalues: v2 (copy)
            local v5 = task.spawn(function() -- line: 13
                -- upvalues: v2 (copy)
                while true do
                    task.wait(0.5)
                    v2(function(p1) -- line: 16
                        return (p1 + 1) % 4
                    end)
                end
            end)

            return function() -- line: 21
                -- upvalues: v5 (copy)
                return task.cancel(v5)
            end
        end, {})
        useEffect(function() -- line: 25
            -- upvalues: v4 (copy)
            local v6 = true

            local function v7() -- line: 27
                -- upvalues: v6 (ref), v4 (copy)
                v4:linear(v6 and 0 or 0.35, {
                    speed = 0.3
                })
                v6 = not v6
            end

            v4:linear(v6 and 0 or 0.35, {
                speed = 0.3
            })
            v6 = not v6

            local v10 = v4:onComplete(function() -- line: 34
                -- upvalues: v7 (copy)
                return v7()
            end)

            return function() -- line: 37
                -- upvalues: v10 (copy)
                return v10()
            end
        end, { v4 })

        return react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Size = UDim2.fromScale(0.2, 0.03)
            },
            position = UDim2.fromScale(0.5, 0.85),
            text = ("Nibbling%*"):format((string.rep(".", v1))),
            textTransparency = v3
        })
    end
}
