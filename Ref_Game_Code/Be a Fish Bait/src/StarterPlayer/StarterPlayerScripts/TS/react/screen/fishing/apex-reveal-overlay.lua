-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useState = react.useBinding, react.useEffect, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local apexDropAtom, apexRevealAtom = v1.apexDropAtom, v1.apexRevealAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "side-confetti").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-incrementing-value").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useLoopingGradientRotation = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "use-exclusive-gradient-rotation").useLoopingGradientRotation
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils")
local getMutationColorGradient, getMutationsPlainText, getMutationsRichText, getMutationsShadowText = v2.getMutationColorGradient, v2.getMutationsPlainText, v2.getMutationsRichText, v2.getMutationsShadowText
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 120, 0))
})

return {
    default = function() -- ApexRevealOverlay | line: 28
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useState (copy), RunService (copy), subscribe (copy), useMotion (copy), apexDropAtom (copy), apexRevealAtom (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), useLoopingGradientRotation (copy), getMutationColorGradient (copy), getMutationsPlainText (copy), getMutationsRichText (copy), getMutationsShadowText (copy), v3 (copy)
        local v4 = useTheme()
        local v5, v6 = useState(apexDropAtom())
        local v7, v8 = useState(apexRevealAtom())
        local v9, v10 = useMotion(0)
        local v11, v12 = useMotion(1)
        local v13, v14 = useBinding(UDim2.fromOffset(0, 0))
        local v15 = v5 ~= nil

        useEffect(function() -- line: 36
            -- upvalues: v6 (copy), v12 (copy), subscribe (copy), apexDropAtom (copy)
            return subscribe(apexDropAtom, function(p1) -- line: 37
                -- upvalues: v6 (copy), v12 (copy)
                v6(p1)
                v12:immediate(1)

                if p1 ~= nil then
                    v12:linear(1.7, {
                        speed = 0.2333333333333333
                    })
                end
            end)
        end, { v12 })
        useEffect(function() -- line: 50
            -- upvalues: v8 (copy), v10 (copy), subscribe (copy), apexRevealAtom (copy)
            return subscribe(apexRevealAtom, function(p2) -- line: 51
                -- upvalues: v8 (copy), v10 (copy)
                v8(p2)

                if p2 ~= nil then
                    v10:tween(1.15, {
                        time = 0.2,
                        style = Enum.EasingStyle.Back,
                        direction = Enum.EasingDirection.Out
                    })
                    task.delay(0.2, function() -- line: 59
                        -- upvalues: v10 (copy)
                        v10:tween(1, {
                            time = 0.12,
                            style = Enum.EasingStyle.Quad,
                            direction = Enum.EasingDirection.Out
                        })
                    end)
                else
                    v10:immediate(0)
                end
            end)
        end, { v10 })
        useEffect(function() -- line: 73
            -- upvalues: v14 (copy), v15 (copy), RunService (copy)
            if v15 then
                local connection = RunService.RenderStepped:Connect(function() -- line: 78
                    -- upvalues: v14 (copy)
                    v14(UDim2.fromOffset(math.random(-6, 6), math.random(-6, 6)))
                end)

                return function() -- line: 81
                    -- upvalues: connection (copy), v14 (copy)
                    connection:Disconnect()
                    v14(UDim2.fromOffset(0, 0))
                end
            end

            v14(UDim2.fromOffset(0, 0))

            return nil
        end, { v15, v14 })

        local v16 = if v5 == nil then v5 else v5.fishMoneyPerSecond

        if v16 == nil then
            v16 = 0
        end

        local v17 = default3(v16, 3, v5 ~= nil)
        local v18 = if v7 == nil then v7 else v7.fishMoneyPerSecond

        if v18 == nil then
            v18 = 0
        end

        local v19 = default3(v18, 0.8, v7 ~= nil)
        local v20 = if v7 == nil then v7 else v7.mutations

        if v20 == nil then
            v20 = {}
        end

        local v22 = useLoopingGradientRotation(#v20 == 1 and v20[1] == "hoola3")

        if v5 == nil and v7 == nil then
            return react.createElement(react.Fragment)
        end

        local v23 = #v20 > 0
        local v24 = #v20 > 1
        local v25 = getMutationsPlainText(v20)
        local v26 = getMutationsShadowText(v20)

        if v23 then
            if v24 then
                v25 = getMutationsRichText(v20)
            end
        else
            v25 = nil
        end

        local v27 = v9:map(function(p3) -- line: 123
            return UDim2.fromScale(0.55 * p3, 0.1 * p3)
        end)
        local v28 = v9:map(function(p4) -- line: 126
            return UDim2.fromScale(0.48 * p4, 0.07 * p4)
        end)
        local v29 = v9:map(function(p5) -- line: 129
            return UDim2.fromScale(0.4 * p5, 0.07 * p5)
        end)
        local v30 = v11:map(function(p6) -- line: 132
            return UDim2.fromScale(0.55 * p6, 0.12 * p6)
        end)
        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            ZIndex = 60,
            Size = UDim2.fromScale(1, 1)
        }
        local v31 = v5 ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 61,
            Position = v13,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 1),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 61,
                Font = v4.textFont,
                Size = v30
            },
            position = UDim2.fromScale(0.5, 0.92),
            text = v17
        }))
        local v32 = react.createElement(default2, {
            zIndex = 62,
            active = v7 ~= nil
        })
        local v33 = false

        if v7 ~= nil then
            local createElement, Fragment = react.createElement, react.Fragment
            local v34 = false

            if v25 ~= nil then
                local createElement = react.createElement
                local t2 = {
                    anchorPoint = Vector2.new(0.5, 0.5)
                }

                if v24 then
                    t2.color = Color3.fromRGB(255, 255, 255)
                    t2.gradientRotation = nil
                    t2.overrideProps = {
                        TextScaled = true,
                        ZIndex = 61,
                        Font = v4.textFont,
                        Size = v28,
                        RichText = v24
                    }
                else
                    t2.color = getMutationColorGradient(v20[1])

                    if v20[1] ~= "hoola3" then
                        v22 = nil
                    end

                    t2.gradientRotation = v22
                    t2.overrideProps = {
                        TextScaled = true,
                        ZIndex = 61,
                        Font = v4.textFont,
                        Size = v28,
                        RichText = v24
                    }
                    v26 = nil
                end

                t2.position = UDim2.fromScale(0.5, 0.77)
                t2.shadowText = v26
                t2.strokeProps = {
                    Color = Color3.fromRGB(0, 0, 0)
                }
                t2.text = v25
                v34 = createElement(default, t2)
            end

            v33 = createElement(Fragment, nil, v34, react.createElement(default, {
                anchorPoint = Vector2.new(0.5, 0.5),
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 61,
                    Font = v4.textFont,
                    Size = v27
                },
                position = UDim2.fromScale(0.5, v25 == nil and 0.85 or 0.83),
                text = v7.fishName
            }), react.createElement(default, {
                anchorPoint = Vector2.new(0.5, 0),
                color = v3,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 61,
                    Font = v4.textFont2,
                    Size = v29
                },
                position = UDim2.fromScale(0.5, v25 == nil and 0.89 or 0.9),
                text = v19
            }))
        end

        return createElement("frame", t1, v31, v32, v33)
    end
}
