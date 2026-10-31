-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef, useState = react.useBinding, react.useEffect, react.useRef, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local hookCastDistanceAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom").hookCastDistanceAtom
local highScoreConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "high-score-confetti-atom").highScoreConfettiTriggerAtom
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = tostring(Players.LocalPlayer.UserId)
local t1 = {
    Thickness = 0.12,
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
}
local t2 = {
    tension = 280,
    friction = 18
}
local t3 = {
    tension = 300,
    friction = 20
}

return {
    default = function(p1) -- NewHighScorePopup | line: 33
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), useMotion (copy), hookCastDistanceAtom (copy), highScoreConfettiTriggerAtom (copy), useRootSelector (copy), selectPlayerStat (copy), default (copy), useTheme (copy), v1 (copy), t1 (copy), t2 (copy), t3 (copy)
        local storyHighScoreDistance = p1.storyHighScoreDistance
        local v2 = useRootSelector(selectPlayerStat(v1, "highScoreDistance"))

        if v2 == nil then
            v2 = 0
        end

        if storyHighScoreDistance ~= nil then
            v2 = storyHighScoreDistance
        end

        local v3 = useTheme()
        local v4, v5 = useBinding(hookCastDistanceAtom())
        local v6, v7 = useState(false)
        local v8, v9 = useState(false)
        local v10, v11 = useMotion(0)
        local v12, v13 = useMotion(0)
        local v14 = useRef(v2)

        v14.current = v2

        local v15 = useRef(false)
        local v16 = useRef(nil)
        local v17 = useRef(false)

        useEffect(function() -- line: 73
            -- upvalues: v5 (copy), v7 (copy), v9 (copy), v11 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), subscribe (copy), hookCastDistanceAtom (copy), highScoreConfettiTriggerAtom (copy), t2 (copy), t3 (copy)
            return subscribe(hookCastDistanceAtom, function(p2) -- line: 74
                -- upvalues: v5 (copy), v7 (copy), v9 (copy), v11 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), highScoreConfettiTriggerAtom (copy), t2 (copy), t3 (copy)
                v5(p2)

                local current = v14.current
                local v18 = current > 0 and current < p2
                local v19

                if current > 0 then
                    v19 = not v18

                    if v19 then
                        v19 = p2 > 0 and current - p2 <= 65
                    end
                else
                    v19 = false
                end

                if v18 then
                    if not v15.current then
                        v15.current = true
                        v9(true)
                        v11:spring(1, t2)
                    end

                    if v16.current ~= nil then
                        task.cancel(v16.current)
                    end

                    v16.current = task.delay(1, function() -- line: 67
                        -- upvalues: v9 (copy), v11 (copy), v15 (copy), v16 (copy), t3 (copy)
                        v16.current = nil
                        v15.current = false
                        v11:spring(0, t3)
                        task.delay(0.5, function() -- line: 59
                            -- upvalues: v9 (copy)
                            return v9(false)
                        end)
                    end)

                    if not v17.current then
                        v17.current = true
                        highScoreConfettiTriggerAtom(function(p3) -- line: 90
                            return p3 + 1
                        end)
                        v13:spring(0, t3)
                        task.delay(0.15, function() -- line: 94
                            -- upvalues: v7 (copy), v9 (copy), v11 (copy), v13 (copy), v15 (copy), v16 (copy), t2 (copy), t3 (copy)
                            v7(true)
                            v13:spring(1, t2)

                            if v16.current ~= nil then
                                task.cancel(v16.current)
                            end

                            v16.current = task.delay(1, function() -- line: 67
                                -- upvalues: v9 (copy), v11 (copy), v15 (copy), v16 (copy), t3 (copy)
                                v16.current = nil
                                v15.current = false
                                v11:spring(0, t3)
                                task.delay(0.5, function() -- line: 59
                                    -- upvalues: v9 (copy)
                                    return v9(false)
                                end)
                            end)
                        end)
                    end
                elseif v19 then
                    if not v15.current then
                        v15.current = true
                        v9(true)
                        v11:spring(1, t2)
                        v13:spring(1, t2)
                    end

                    if v16.current ~= nil then
                        task.cancel(v16.current)
                    end

                    v16.current = task.delay(1, function() -- line: 67
                        -- upvalues: v9 (copy), v11 (copy), v15 (copy), v16 (copy), t3 (copy)
                        v16.current = nil
                        v15.current = false
                        v11:spring(0, t3)
                        task.delay(0.5, function() -- line: 59
                            -- upvalues: v9 (copy)
                            return v9(false)
                        end)
                    end)

                    if v17.current then
                        v17.current = false
                        v7(false)
                    end
                elseif v15.current then
                    v17.current = false
                    v7(false)
                    v13:spring(0, t3)

                    if v16.current ~= nil then
                        task.cancel(v16.current)
                        v16.current = nil
                    end

                    v15.current = false
                    v11:spring(0, t3)
                    task.delay(0.5, function() -- line: 59
                        -- upvalues: v9 (copy)
                        return v9(false)
                    end)
                end
            end)
        end, {})

        if not v8 then
            return react.createElement(react.Fragment)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.68, 0.48),
            Size = UDim2.fromScale(0.22, 0.12)
        }, react.createElement("uiscale", {
            Scale = v10:map(function(p4) -- line: 133
                return p4
            end)
        }), react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Size = UDim2.fromScale(1, 0.48)
        }, react.createElement("uiscale", {
            Scale = v12:map(function(p5) -- line: 147
                return p5
            end)
        }), react.createElement(default, {
            color = if v6 then Color3.new(1, 0.9, 0) else Color3.new(0.7, 0.7, 0.7),
            overrideProps = {
                TextScaled = true,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t1,
            text = if v6 then "New High Score!" else ("High Score: %* studs"):format((math.floor(v14.current)))
        })), react.createElement(default, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 0.38),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = t1,
            text = v4:map(function(p6) -- line: 170
                -- upvalues: v6 (copy), v14 (copy)
                local current = v14.current
                local v24 = math.floor(p6)

                if not v6 and math.floor(current) <= v24 then
                    v24 = math.floor(current) - 1
                end

                return (("%* studs"):format(v24))
            end)
        }))
    end
}
