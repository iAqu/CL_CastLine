-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "rainbow-text-label", "rainbow-text-label").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local t1 = {
    TextScaled = true,
    TextWrapped = true,
    ZIndex = 2,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
}

return {
    default = function(p1) -- LeavingPopup | line: 31
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), default (copy), default2 (copy), useTheme (copy), useScreenSizeState (copy), RunService (copy), abbreviate (copy), images (copy), v1 (copy), t1 (copy)
        local v2 = useTheme()
        local v3 = useScreenSizeState() == "lg"
        local message = p1.message

        if message == nil then
            message = "Your Aquarium Earns Offline"
        end

        local speed = p1.speed

        if speed == nil then
            speed = 0.4
        end

        local showBanners = p1.showBanners

        if showBanners == nil then
            showBanners = true
        end

        local v4 = if not p1.canClaimBuff then images.cashPile
            elseif p1.buffKind == "mutationLuck" then images.serverLuckCloverIcon
            elseif p1.buffKind == "power" then images.strongArmIcon
            else images.cash2stack
        local v5, v6 = useBinding(0)
        local v7, v8 = useBinding(0)

        useEffect(function() -- line: 53
            -- upvalues: v5 (copy), v6 (copy), v7 (copy), v8 (copy), RunService (copy)
            local connection = RunService.Heartbeat:Connect(function(p2) -- line: 54
                -- upvalues: v5 (copy), v6 (copy), v7 (copy), v8 (copy)
                v6(v5:getValue() + p2 * 0.45 % 1)
                v8(v7:getValue() + p2 * 1.8 % 1)
            end)

            return function() -- line: 58
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v5, v6, v8, v7 })

        local v9 = if p1.buffKind == "mutationLuck" then "2x Mutation Luck for next 5mins!" elseif p1.buffKind == "power" then "2x Power for next 5mins!" else "2x Money for next 5mins!"
        local v10

        if showBanners then
            local t2 = {
                font = v2.textFont2
            }
            local v11 = table.clone(t1)

            setmetatable(v11, nil)
            v11.AnchorPoint = Vector2.new(0.5, 0)
            v11.Position = UDim2.fromScale(0.5, 0.04)
            t2.overrideProps = v11
            t2.size = UDim2.fromScale(0.9, 0.12)
            t2.speed = speed
            t2.strokeThickness = 4
            t2.text = message
            v10 = react.createElement(default, t2)
        else
            v10 = showBanners
        end

        local v12 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 14)
        })
        local v13 = react.createElement("uistroke", {
            Thickness = 3,
            Transparency = 0.15,
            Color = Color3.fromRGB(120, 130, 150)
        })
        local v14 = if p1.canClaimBuff then react.createElement(react.Fragment, nil, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "WAIT!",
            TextScaled = true,
            ZIndex = 8,
            Font = v2.textFont2,
            Position = UDim2.fromScale(0.05, 0.025),
            Size = UDim2.fromScale(0.9, 0.18),
            TextColor3 = v7:map(function(p3) -- line: 93
                return Color3.fromRGB(255, 20 + p3 * 70, 35)
            end)
        }, react.createElement("uistroke", {
            Thickness = 5,
            Transparency = 0.05,
            Color = v7:map(function(p4) -- line: 99
                return Color3.fromRGB(90 + p4 * 120, 0, 0)
            end)
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "DON'T LEAVE!",
            TextScaled = true,
            ZIndex = 7,
            Font = v2.textFont2,
            Position = UDim2.fromScale(0.08, 0.18),
            Size = UDim2.fromScale(0.84, 0.13),
            TextColor3 = Color3.fromRGB(255, 68, 68)
        }, react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.fromRGB(0, 0, 0)
        }))) else react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "SEE YOU TOMORROW :)",
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 6,
            Font = v2.textFont2,
            Position = UDim2.fromScale(0.05, 0.04),
            Size = UDim2.fromScale(0.9, 0.2),
            TextColor3 = Color3.fromRGB(125, 255, 45)
        }, react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.fromRGB(0, 0, 0)
        }))
        local createElement = react.createElement
        local t5 = {
            BackgroundTransparency = 1,
            ZIndex = 6,
            Font = v2.textFont,
            Position = UDim2.fromScale(p1.canClaimBuff and 0.03 or 0.06, p1.canClaimBuff and 0.31 or 0.2),
            Size = UDim2.fromScale(p1.canClaimBuff and 0.94 or 0.84, p1.canClaimBuff and 0.09 or 0.14),
            Text = p1.canClaimBuff and "Take this free reward to help you progress!" or "Come back tomorrow to claim your rewards!",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = not v3,
            TextSize = p1.canClaimBuff and 38 or 34,
            TextWrapped = not p1.canClaimBuff,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }
        local v15 = not v3

        v15 = v15 and react.createElement("uitextsizeconstraint", {
            MinTextSize = 14,
            MaxTextSize = p1.canClaimBuff and 30 or 28
        })

        local v16 = createElement("textlabel", t5, v15, react.createElement("uistroke", {
            Thickness = 2,
            Color = Color3.fromRGB(0, 0, 0)
        }))
        local v17 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v4,
            Position = UDim2.fromScale(0.5, p1.canClaimBuff and 0.64 or 0.55),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(p1.canClaimBuff and 0.4 or 0.44, p1.canClaimBuff and 0.4 or 0.44)
        })
        local v18

        if p1.canClaimBuff then
            v18 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 8,
                Font = v2.textFont2,
                Position = UDim2.fromScale(0.08, 0.71),
                Size = UDim2.fromScale(0.84, 0.12),
                Text = v9,
                TextColor3 = v5:map(function(p5) -- line: 167
                    return Color3.fromHSV(p5, 0.85, 1)
                end)
            }, react.createElement("uistroke", {
                Thickness = 3,
                Color = Color3.fromRGB(0, 0, 0)
            }))
        else
            local t9 = {
                BackgroundTransparency = 1,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1)
            }
            local forecastEarnings = p1.forecastEarnings

            if forecastEarnings == nil then
                forecastEarnings = 0
            end

            t9.Text = ("$%*"):format((abbreviate(forecastEarnings)))
            t9.TextColor3 = v5:map(function(p6) -- line: 188
                return Color3.fromHSV(p6, 0.85, 1)
            end)
            t9.TextScaled = true
            t9.ZIndex = 8
            v18 = react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.69),
                Size = UDim2.fromScale(0.52, 0.15)
            }, react.createElement("textlabel", t9, react.createElement("uistroke", {
                Thickness = 3,
                Color = Color3.fromRGB(0, 0, 0)
            })))
        end

        local v19 = react.createElement("frame", {
            BackgroundTransparency = 0.12,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(24, 28, 36),
            Position = UDim2.fromScale(0.5, 0.48),
            Size = UDim2.fromScale(p1.canClaimBuff and 0.58 or 0.46, p1.canClaimBuff and 0.62 or 0.5)
        }, v12, v13, v14, v16, v17, v18, react.createElement(default2, {
            cornerRadius = 0.1,
            zIndex = 7,
            anchorPoint = Vector2.new(0.5, 1),
            color = v1,
            font = v2.textFont2,
            frameSize = UDim2.fromScale(p1.canClaimBuff and 0.4 or 0.76, p1.canClaimBuff and 0.14 or 0.16),
            label = p1.canClaimBuff and "Claim!" or "I'll be back tomorrow!",
            onClick = function() -- onClick | line: 219
                -- upvalues: p1 (copy)
                if p1.canClaimBuff then
                    local onClaimBuff = p1.onClaimBuff

                    if onClaimBuff ~= nil then
                        onClaimBuff()
                    end
                else
                    local onDismiss = p1.onDismiss

                    if onDismiss ~= nil then
                        onDismiss()
                    end
                end
            end,
            popoutColor = Color3.fromRGB(10, 120, 10),
            position = UDim2.fromScale(0.5, p1.canClaimBuff and 0.99 or 0.96)
        }))

        if showBanners then
            local t12 = {
                font = v2.textFont2
            }
            local v20 = table.clone(t1)

            setmetatable(v20, nil)
            v20.AnchorPoint = Vector2.new(0.5, 1)
            v20.Position = UDim2.fromScale(0.5, 0.96)
            t12.overrideProps = v20
            t12.size = UDim2.fromScale(0.9, 0.12)
            t12.speed = speed
            t12.strokeThickness = 4
            t12.text = message
            showBanners = react.createElement(default, t12)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 1)
        }, v10, v19, showBanners)
    end
}
