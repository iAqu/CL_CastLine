-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default

return {
    default = function(p1) -- CatchSticksCountdown | line: 10
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy)
        local label, uiScale = p1.label, p1.uiScale
        local v1, v2 = useMotion(0.4)

        useEffect(function() -- line: 14
            -- upvalues: v2 (copy)
            v2:spring(1, {
                frequency = 5,
                damping = 0.55
            })
        end, { v2 })

        local v3 = if label == "START!" then Color3.fromRGB(96, 235, 120) else Color3.fromRGB(255, 226, 120)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 958,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.42),
            Size = UDim2.fromOffset(420 * uiScale, 220 * uiScale)
        }, react.createElement("uiscale", {
            Scale = v1
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 959,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.12,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = label
        }))
    end
}
