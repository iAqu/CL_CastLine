-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local getMutationColorGradient = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColorGradient
local t1 = {
    tension = 280,
    friction = 18
}

return {
    default = function(p1) -- MutationLuckBoostText | line: 16
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useMotion (copy), default (copy), useTheme (copy), getMutationColorGradient (copy), t1 (copy)
        local mutationName = p1.mutationName
        local v1 = useTheme()
        local v2, v3 = useMotion(0)
        local v4, v5 = useBinding(0)

        useEffect(function() -- line: 21
            -- upvalues: v3 (copy), t1 (copy)
            v3:spring(1, t1)
        end, {})
        useEffect(function() -- line: 24
            -- upvalues: v5 (copy)
            local n1 = 0
            local v6 = true
            local v7 = task.spawn(function() -- line: 27
                -- upvalues: n1 (ref), v6 (ref), v5 (copy)
                while v6 do
                    local v8 = task.wait()

                    n1 = (n1 + 90 * v8) % 360
                    v5(n1)
                end
            end)

            return function() -- line: 34
                -- upvalues: v6 (ref), v7 (copy)
                v6 = false
                task.cancel(v7)
            end
        end, {})

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 18,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.92),
            Size = UDim2.fromScale(0.6, 0.055)
        }, react.createElement("uiscale", {
            Scale = v2:map(function(p2) -- line: 47
                return p2
            end)
        }), react.createElement(default, {
            shadowYScale = 0,
            color = getMutationColorGradient(mutationName),
            gradientRotation = v4,
            overrideProps = {
                RichText = true,
                TextScaled = true,
                ZIndex = 18,
                Font = v1.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.07,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = ("%* MUTATION LUCK BOOST!"):format((string.upper(mutationName)))
        }))
    end
}
