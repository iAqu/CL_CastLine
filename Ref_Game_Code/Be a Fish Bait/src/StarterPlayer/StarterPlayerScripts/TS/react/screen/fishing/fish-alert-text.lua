-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme

return {
    default = function(p1) -- FishAlertText | line: 17
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), useTheme (copy)
        local speed = p1.speed
        local v1 = speed

        if speed == nil then
            v1 = 1
        end

        local v2 = useTheme()
        local v3, v4 = useMotion(1)

        useEffect(function() -- line: 24
            -- upvalues: v1 (ref), v4 (copy)
            local v5 = true
            local v6 = task.spawn(function() -- line: 26
                -- upvalues: v5 (ref), v1 (ref), v4 (copy)
                while v5 do
                    local v7, v8

                    if math.random() < 0.2 then
                        v8 = 1.2
                        v7 = 0.45
                    else
                        v8 = 1.06
                        v7 = 1
                    end

                    local v9 = v7 / v1
                    local v10 = v9 * 0.3
                    local v11 = v9 * 0.7

                    v4:tween(v8, {
                        time = v10,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                    task.wait(v10)
                    v4:tween(1, {
                        time = v11,
                        style = Enum.EasingStyle.Quad,
                        direction = Enum.EasingDirection.Out
                    })
                    task.wait(v11 + 0.6 / v1)
                end
            end)

            return function() -- line: 47
                -- upvalues: v5 (ref), v6 (copy)
                v5 = false
                task.cancel(v6)
            end
        end, { v4, v1 })

        local v12 = v3:map(function(p2) -- line: 52
            return UDim2.fromScale(0.4 * p2, 0.08 * p2)
        end)

        return react.createElement(default, {
            text = "Nearby fishes alerted!  👀",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v2.textFont2,
                Size = v12
            },
            position = UDim2.fromScale(0.5, 0.14)
        })
    end
}
