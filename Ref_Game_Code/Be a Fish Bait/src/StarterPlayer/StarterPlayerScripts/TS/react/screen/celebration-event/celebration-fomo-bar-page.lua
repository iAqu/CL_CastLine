-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate")
local abbreviate2, commify = abbreviate.abbreviate, abbreviate.commify
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers")
local challengeMaxTicketAmount, challengeTiers = v1.challengeMaxTicketAmount, v1.challengeTiers
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useCountUpBinding = RuntimeLib.import(script, script.Parent, "use-count-up-binding").useCountUpBinding
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 185, 10))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 110, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(235, 50, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 20, 10))
})
local v4 = Color3.fromRGB(90, 15, 10)
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})
local _ = {
    milestonesUnlocked = 0.25,
    nextMilestone = 0.25,
    totalProgress = 0.34
}
local _ = {
    milestonesUnlocked = 0.595,
    nextMilestone = 0.845,
    totalProgress = 0.19999999999999998
}

local function MiniChallengeProgressBar(p1) -- line: 72
    -- upvalues: react (copy), default (copy), default2 (copy), abbreviate2 (copy), challengeMaxTicketAmount (copy), images (copy), v5 (copy)
    local currentTickets, tiers = p1.currentTickets, p1.tiers
    local v6 = challengeMaxTicketAmount / 1
    local v9 = math.clamp(math.clamp(currentTickets / v6, 0, 1) + 0.005, 0, 1)
    local v10 = table.create(#tiers)

    for v11, v12 in tiers do
        local _ = v11 - 1

        v10[v11] = 0.9400000000000001 - v12.thresholdAmount / v6 * 0.92
    end

    local v13 = 1.84 / (#tiers + 1)
    local v14 = react.createElement(default, {
        cornerRadius = 0.1,
        isStudded = true,
        isStuddedTransparency = 0.85,
        strokeThickness = 0.06,
        zIndex = 1,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = Color3.fromRGB(60, 45, 20),
        position = UDim2.fromScale(0.5, 0.02),
        size = UDim2.fromScale(0.12, 0.92),
        strokeColor = Color3.fromRGB(20, 20, 20)
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, v9)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }), react.createElement("uigradient", {
        Rotation = 90,
        Color = v5
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = images.ticketBarFillTop,
        Position = UDim2.fromScale(0.5, 1 - v9 - 0.572),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1.15, 1.15)
    }))
    local v15 = table.create(#tiers)

    local function v16(p2, p3) -- line: 146
        -- upvalues: v6 (copy), v10 (copy), v13 (copy), react (copy), default2 (copy), abbreviate2 (copy), images (copy)
        local v17 = if p3 % 2 == 0 then "left" else "right"
        local v18 = 0.9400000000000001 - p2.thresholdAmount / v6 * 0.92
        local v19 = if v17 == "left" then 0.5750000000000001 else 0.425
        local v20 = if v17 == "left" then 0.679 else 0.351
        local v21 = v13

        if p3 - 2 >= 0 then
            v21 = math.min(v13, (math.abs(v10[p3 + 1] - v10[p3 - 1])))
        end

        if p3 + 2 < #v10 then
            v21 = math.min(v21, (math.abs(v10[p3 + 1] - v10[p3 + 3])))
        end

        local v26 = v21 * 0.3

        return react.createElement(react.Fragment, {
            key = p2.tierId
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.triangleIcon,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(v19, v18),
            Rotation = v17 == "left" and 90 or 270,
            Size = UDim2.fromScale(0.03, 0.03)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(v20 - 0.075, v18),
            Size = UDim2.fromScale(0.2, v26 + 0.05)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.065, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                Size = UDim2.fromScale(1, 0.4),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            popoutColor = Color3.fromRGB(0, 0, 0),
            text = abbreviate2(p2.thresholdAmount)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.celebrationTicket,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.2, 1)
        })))
    end

    for v27, v28 in tiers do
        v15[v27] = v16(v28, v27 - 1, tiers)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, v14, v15)
end

return {
    default = function(p4) -- CelebrationFomoBarPage | line: 220
        -- upvalues: react (copy), default2 (copy), default3 (copy), useTheme (copy), commify (copy), challengeTiers (copy), images (copy), useCountUpBinding (copy), v2 (copy), v3 (copy), v4 (copy), MiniChallengeProgressBar (copy)
        local currentTickets, isCelebrationPlace, onViewChallenge = p4.currentTickets, p4.isCelebrationPlace, p4.onViewChallenge
        local v29 = useTheme()
        local v30 = useCountUpBinding(currentTickets)
        local n1 = 0

        for i = 1, #challengeTiers do
            local v32 = challengeTiers[i]
            local _ = i - 1

            if v32.thresholdAmount <= currentTickets then
                n1 += 1
            end
        end

        local v33

        for v34, v35 in challengeTiers do
            local _ = v34 - 1

            if currentTickets < v35.thresholdAmount == true then
                v33 = v35
                break
            end

            v33 = nil
        end

        local t3 = {}

        for v36, v37 in challengeTiers do
            local _ = v36 - 1

            if v37.thresholdAmount <= currentTickets then
                t3[v37.tierId] = true
            end
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Fill the FOMO Bar!",
            anchorPoint = Vector2.new(0.5, 0),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v29.textFont2,
                Size = UDim2.fromScale(0.68, 0.07)
            },
            popoutColor = v4,
            position = UDim2.fromScale(0.5, 0.07),
            strokeProps = {
                Color = v4
            }
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.3, 0.58),
            Size = UDim2.fromScale(0.5, 0.72)
        }, react.createElement(MiniChallengeProgressBar, {
            currentTickets = currentTickets,
            tiers = challengeTiers
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.34, 0.42)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.19999999999999998),
            Size = UDim2.fromScale(1, 0.34)
        }, react.createElement(default2, {
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.fromRGB(255, 220, 150),
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v29.textFont2,
                Size = UDim2.fromScale(0.85, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0, 0.5),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            },
            text = v30:map(function(p5) -- line: 320
                -- upvalues: commify (copy)
                return (("Total Progress: %*"):format((commify(p5))))
            end)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = images.celebrationTicket,
            Position = UDim2.fromScale(0.87, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.12, 1)
        })), react.createElement(default2, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 5,
                Font = v29.textFont,
                Size = UDim2.fromScale(1, 0.25),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.595),
            text = ("%*/%* milestones unlocked"):format(n1, #challengeTiers)
        }), react.createElement(default2, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 5,
                Font = v29.textFont,
                Size = UDim2.fromScale(1, 0.25),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.845),
            text = if v33 == nil then "All milestones unlocked!" else ("%* tickets to next milestone"):format((commify(v33.thresholdAmount - currentTickets)))
        })), isCelebrationPlace and react.createElement(default3, {
            cornerRadius = 0.15,
            label = "View challenge!",
            shadowYScale = 0.06,
            zIndex = 5,
            anchorPoint = Vector2.new(0, 1),
            color = v2,
            frameSize = UDim2.fromScale(0.221, 0.09),
            onClick = onViewChallenge,
            popoutColor = Color3.fromRGB(160, 120, 5),
            position = UDim2.fromScale(0.5, 0.9)
        }))
    end
}
