-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme

return {
    default = function() -- FishCaughtText | line: 11
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), useTheme (copy)
        local v1 = useTheme()
        local v2, v3 = useMotion(0)

        useEffect(function() -- line: 14
            -- upvalues: v3 (copy)
            local v4 = true
            local v5 = task.spawn(function() -- line: 16
                -- upvalues: v4 (ref), v3 (copy)
                v3:tween(1.3, {
                    time = 0.22,
                    style = Enum.EasingStyle.Back,
                    direction = Enum.EasingDirection.Out
                })
                task.wait(0.22)
                v3:tween(1, {
                    time = 0.14,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.Out
                })
                task.wait(0.55)

                while v4 do
                    v3:tween(1.06, {
                        time = 0.3,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                    task.wait(0.3)

                    if v4 then
                        v3:tween(1, {
                            time = 0.5,
                            style = Enum.EasingStyle.Quad,
                            direction = Enum.EasingDirection.Out
                        })
                        task.wait(0.85)
                        continue
                    end

                    break
                end
            end)

            return function() -- line: 48
                -- upvalues: v4 (ref), v5 (copy)
                v4 = false
                task.cancel(v5)
            end
        end, { v3 })

        local v6 = v2:map(function(p1) -- line: 53
            return UDim2.fromScale(0.24 * p1, 0.05 * p1)
        end)

        return react.createElement(default, {
            text = "🐟 FISH CAUGHT! 🐟",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v1.colorSequences.greenGradient,
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v1.textFont,
                Size = v6
            },
            position = UDim2.fromScale(0.5, 0.85)
        })
    end
}
