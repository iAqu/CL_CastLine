-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom")
local rareFishTransitionAtom, rareFishTransitionDurationSec = v1.rareFishTransitionAtom, v1.rareFishTransitionDurationSec
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName

return {
    default = function() -- RareFishTransition | line: 27
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), subscribe (copy), rareFishTransitionAtom (copy), rareFishTransitionDurationSec (copy), default (copy), getExclusiveFishConfigByFishName (copy)
        local v2, v3 = useState(nil)
        local v4, v5 = useMotion(0)
        local v6, v7 = useMotion(0)
        local v8, v9 = useMotion(0)
        local v10 = useRef({})

        useEffect(function() -- line: 33
            -- upvalues: v3 (copy), subscribe (copy), rareFishTransitionAtom (copy)
            return subscribe(rareFishTransitionAtom, function(p1) -- line: 34
                -- upvalues: v3 (copy)
                if p1 ~= nil then
                    v3(p1.fishName)
                end
            end)
        end, {})
        useEffect(function() -- line: 40
            -- upvalues: v2 (copy), v3 (copy), v5 (copy), v9 (copy), v10 (copy), rareFishTransitionAtom (copy), rareFishTransitionDurationSec (copy)
            if v2 == nil then
                return nil
            end

            local current = v10.current

            v5:set(1)
            v9:set(0.85)
            v9:tween(0, {
                time = 0.3,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad
            })
            table.insert(current, (task.delay(rareFishTransitionDurationSec - 0.45, function() -- line: 55
                -- upvalues: v5 (copy)
                v5:tween(0, {
                    time = 0.45,
                    direction = Enum.EasingDirection.In,
                    style = Enum.EasingStyle.Quad
                })
            end)))
            table.insert(current, (task.delay(rareFishTransitionDurationSec, function() -- line: 64
                -- upvalues: v3 (copy), rareFishTransitionAtom (copy)
                v3(nil)
                rareFishTransitionAtom(nil)
            end)))

            return function() -- line: 69
                -- upvalues: current (copy), v10 (copy)
                for _, v13 in current do
                    task.cancel(v13)
                end

                v10.current = {}
            end
        end, { v2 })
        useEffect(function() -- line: 76
            -- upvalues: v2 (copy), v7 (copy), getExclusiveFishConfigByFishName (copy)
            local v14 = v2 == nil

            if not v14 then
                local v15 = getExclusiveFishConfigByFishName(v2)

                if v15 ~= nil then
                    v15 = v15.bossFight
                end

                v14 = not v15
            end

            if v14 then
                return nil
            end

            v7:linear(360, {
                speed = 90
            })

            return (v7:onComplete(function() -- line: 94
                -- upvalues: v7 (copy)
                v7:immediate(0)
                v7:linear(360, {
                    speed = 90
                })
            end))
        end, { v7, v2 })

        if v2 == nil then
            return nil
        end

        local v16 = getExclusiveFishConfigByFishName(v2)

        if v16 ~= nil then
            v16 = v16.bossFight
        end

        local v17 = v16 == true
        local v18 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 80)),
            ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 210, 70)),
            ColorSequenceKeypoint.new(0.36, Color3.fromRGB(90, 255, 110)),
            ColorSequenceKeypoint.new(0.54, Color3.fromRGB(80, 220, 255)),
            ColorSequenceKeypoint.new(0.72, Color3.fromRGB(150, 95, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 220))
        })

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1000,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v4:map(function(p2) -- line: 111
                return 1 - p2
            end),
            Size = UDim2.fromScale(1, 1)
        }, v17 and react.createElement(default, {
            text = "EXCLUSIVE",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v18,
            gradientRotation = v6,
            overrideProps = {
                TextScaled = true,
                ZIndex = 1002,
                Size = UDim2.fromScale(0.58, 0.11),
                TextTransparency = v4:map(function(p3) -- line: 124
                    return 1 - p3
                end)
            },
            position = UDim2.fromScale(0.5, 0.43),
            strokeProps = {
                Thickness = 0.08,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }), react.createElement(default, {
            text = "⚔️ BOSS FIGHT ⚔️",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 235, 100),
            overrideProps = {
                TextScaled = true,
                ZIndex = 1002,
                Size = UDim2.fromScale(0.68, 0.12),
                TextTransparency = v4:map(function(p4) -- line: 141
                    return 1 - p4
                end)
            },
            position = UDim2.fromScale(0.5, v17 and 0.54 or 0.5),
            strokeProps = {
                Thickness = 0.08,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1001,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = v8:map(function(p5) -- line: 154
                return 1 - p5
            end),
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
