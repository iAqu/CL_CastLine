-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local joinBindings, useEffect, useRef, useState = react.joinBindings, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local SoundService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").SoundService
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "fish-roll-item").default
local events = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").events

local function AnimatedSlot(p1) -- line: 30
    -- upvalues: react (copy), joinBindings (copy), useEffect (copy), useMotion (copy), default2 (copy)
    local isJackpot, targetX = p1.isJackpot, p1.targetX
    local v1, v2 = useMotion(0.5)
    local v3, v4 = useMotion(targetX)

    useEffect(function() -- line: 35
        -- upvalues: v2 (copy)
        v2:tween(0.08499999999999999, {
            time = 0.2,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })
    end, { v2 })
    useEffect(function() -- line: 42
        -- upvalues: targetX (copy), v4 (copy)
        v4:tween(targetX, {
            time = 0.15,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })
    end, { targetX, v4 })

    local v5 = joinBindings({
        x = v3,
        y = v1
    }):map(function(p2) -- line: 52
        local x, y = p2.x, p2.y

        return UDim2.fromScale(x, y)
    end)

    return react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        finalIsBonus = not isJackpot,
        finalIsJackpot = isJackpot,
        key = isJackpot and "j" or "b",
        position = v5
    })
end

return {
    jackpotRevealDelay = 0.2,
    jackpotRevealStagger = 0.1,
    default = function(p3) -- BonusSlotsHud | line: 65
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), SoundService (copy), useConfig (copy), useTheme (copy), default (copy), events (copy), AnimatedSlot (copy)
        local bonusComboCount = p3.bonusComboCount
        local getSound = useConfig().getSound
        local v6 = useTheme()
        local v7 = math.clamp(bonusComboCount, 0, 3)
        local v8, v9 = useState(0)
        local v10 = useRef(0)
        local v11 = useRef(false)

        local function v12(p4) -- line: 74
            -- upvalues: getSound (copy), SoundService (copy)
            local clone = getSound("BonusUpgrade"):Clone()

            clone.PlaybackSpeed = p4
            clone.TimePosition = 0
            clone.Parent = SoundService

            local connection

            connection = clone.Ended:Connect(function() -- line: 81
                -- upvalues: clone (copy), connection (ref)
                connection:Disconnect()
                clone:Destroy()
            end)
            clone:Play()
            task.delay(3, function() -- line: 86
                -- upvalues: clone (copy), connection (ref)
                if clone.Parent == nil then
                    return
                end

                connection:Disconnect()
                clone:Destroy()
            end)
        end

        useEffect(function() -- line: 93
            -- upvalues: bonusComboCount (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), events (copy)
            local current = v10.current

            v10.current = bonusComboCount

            if bonusComboCount < 3 then
                v9(0)
                v11.current = false

                return nil
            end

            if current >= 3 then
                return nil
            end

            events.analyticsJackpotCutsceneStarted:fire()

            local t2 = {
                1.4400000000000002, 1.7280000000000002, 2.0736000000000003
            }
            local t3 = {}

            table.insert(t3, (task.delay(0.2, function() -- line: 108
                -- upvalues: t2 (copy), t3 (copy), v9 (copy), v11 (copy), v12 (copy)
                v9(3)

                if v11.current then
                    return nil
                end

                v11.current = true

                for i = 0, #t2 - 1 do
                    table.insert(t3, (task.delay(i * 0.11, function() -- line: 115
                        -- upvalues: i (copy), t2 (copy), v12 (copy)
                        v12(t2[i + 1])
                    end)))
                    table.insert(t3, (task.delay(i * 0.07 + 0.42, function() -- line: 119
                        -- upvalues: i (copy), t2 (copy), v12 (copy)
                        v12(t2[i + 1])
                    end)))
                end
            end)))

            return function() -- line: 126
                -- upvalues: t3 (copy)
                for _, v16 in t3 do
                    task.cancel(v16)
                end
            end
        end, { bonusComboCount, getSound })

        if v7 == 0 then
            return react.createElement(react.Fragment)
        end

        local v17 = 0.5 - (v7 * 0.075 + (v7 - 1) * 0.025) / 2 + 0.0375
        local t4 = {}
        local n1 = 0
        local v18 = false

        while true do
            if v18 then
                n1 += 1
            else
                v18 = true
            end

            if n1 < v7 then
                table.insert(t4, n1)
                continue
            end

            break
        end

        local v19 = table.create(#t4)

        for v20, v21 in t4 do
            local _ = v20 - 1
            local v22 = v21 < v8

            v19[v20] = react.createElement(AnimatedSlot, {
                isJackpot = v22,
                key = v21,
                targetX = v17 + v21 * 0.1
            })
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v19, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 11,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.17999999999999997),
            Size = UDim2.fromScale(0.6, 0.055)
        }, react.createElement(default, {
            shadowYScale = 0,
            text = "X3 BONUS = <font color=\"rgb(255,220,0)\">JACKPOT!</font>",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                RichText = true,
                TextScaled = true,
                Font = v6.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.07,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }
        })))
    end
}
