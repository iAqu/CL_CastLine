-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useEffect, useState = react.memo, react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local apexSkillCheckAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom").apexSkillCheckAtom
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers
local weathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "weathers").weathers
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = RuntimeLib.import(script, script.Parent.Parent, "offline-earnings", "offline-earnings-banner")
local HIDDEN_Y, VISIBLE_Y, VISIBLE_Y_TRAINING = v1.HIDDEN_Y, v1.VISIBLE_Y, v1.VISIBLE_Y_TRAINING

return {
    default = memo(function(p1) -- WeatherHudBanner | line: 21
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), subscribe (copy), apexSkillCheckAtom (copy), useRootSelector (copy), selectCurrentWeathers (copy), weathers (copy), default (copy), default2 (copy), useTheme (copy), HIDDEN_Y (copy), VISIBLE_Y (copy), VISIBLE_Y_TRAINING (copy)
        local isTraining, visible = p1.isTraining, p1.visible

        if visible == nil then
            visible = true
        end

        local v2 = useTheme()
        local v3 = useRootSelector(selectCurrentWeathers)
        local v4, v5 = useState(function() -- line: 29
            -- upvalues: apexSkillCheckAtom (copy)
            return apexSkillCheckAtom() ~= nil
        end)

        useEffect(function() -- line: 32
            -- upvalues: v5 (copy), subscribe (copy), apexSkillCheckAtom (copy)
            return subscribe(apexSkillCheckAtom, function(p2) -- line: 33
                -- upvalues: v5 (copy)
                v5(p2 ~= nil)
            end)
        end, {})

        local v6, v7

        for v8 in v3 do
            v7 = weathers[v8]

            if v7 ~= nil then
                v7 = v7.hudBuffText
            end

            if v7 ~= nil then
                v6 = v7
                break
            end

            v7 = nil
        end

        local v9, v10 = useMotion(HIDDEN_Y)
        local v11, v12 = useMotion(0)
        local v13, v14 = useState(v7)

        visible = visible and not v4 and v7 ~= nil
        useEffect(function() -- line: 54
            -- upvalues: isTraining (copy), visible (ref), v6 (ref), v10 (copy), v12 (copy), v14 (copy), HIDDEN_Y (copy), VISIBLE_Y (copy), VISIBLE_Y_TRAINING (copy)
            if not visible then
                v10:tween(HIDDEN_Y, {
                    time = 0.25,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.In
                })
                v12:tween(0, {
                    time = 0.2
                })

                return
            end

            v14(v6)
            v10:tween(if isTraining then VISIBLE_Y_TRAINING else VISIBLE_Y, {
                time = 0.35,
                style = Enum.EasingStyle.Back,
                direction = Enum.EasingDirection.Out
            })
            v12:tween(1, {
                time = 0.2
            })
        end, { visible, isTraining, v6 })

        if v13 == nil then
            return nil
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = v9:map(function(p3) -- line: 83
                return UDim2.fromScale(0.5, p3)
            end),
            Size = UDim2.fromScale(0.6, 0.055)
        }, react.createElement(default2, {
            zIndex = 1,
            backgroundTransparency = v11:map(function(p4) -- line: 88
                return 1 - p4 * 0.6
            end),
            cornerRadius = UDim.new(0.35, 0),
            size = UDim2.fromScale(1.2, 1)
        }), react.createElement(default, {
            shadowYScale = 0,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                RichText = true,
                TextScaled = true,
                ZIndex = 2,
                Font = v2.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.07,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = v13,
            textTransparency = v11:map(function(p5) -- line: 110
                return 1 - p5
            end)
        }))
    end)
}
