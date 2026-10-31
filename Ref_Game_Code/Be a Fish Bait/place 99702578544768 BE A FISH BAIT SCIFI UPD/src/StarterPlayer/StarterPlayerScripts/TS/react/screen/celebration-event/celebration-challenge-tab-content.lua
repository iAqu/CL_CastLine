-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useState = react.useCallback, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local commify = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").commify
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers")
local challengeTiers, getChallengeTierDefinition = v1.challengeTiers, v1.getChallengeTierDefinition
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default2 = RuntimeLib.import(script, script.Parent, "challenge-progress-bar").default
local useCountUpBinding = RuntimeLib.import(script, script.Parent, "use-count-up-binding").useCountUpBinding
local default3 = RuntimeLib.import(script, script.Parent, "celebration-event-countdown").default

local function cloneSet(p1) -- line: 17
    local t1 = {}

    for v2 in p1 do
        t1[v2] = true
    end

    return t1
end

local function buildSeedState() -- line: 34
    return {
        currentTickets = 6E+08,
        claimedTierIds = {
            ["challenge-tier-1"] = true
        }
    }
end

local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})

return {
    default = function(p2) -- CelebrationChallengeTabContent | line: 55
        -- upvalues: react (copy), useCallback (copy), useState (copy), default (copy), useTheme (copy), commify (copy), challengeTiers (copy), getChallengeTierDefinition (copy), images (copy), default2 (copy), useCountUpBinding (copy), default3 (copy), cloneSet (copy), buildSeedState (copy), v3 (copy)
        local v4 = if p2 == nil then {} else p2
        local barTicketsOverride, claimedTierIdsOverride, currentTicketsOverride, fillRef = v4.barTicketsOverride, v4.claimedTierIdsOverride, v4.currentTicketsOverride, v4.fillRef
        local isFarewellRewardClaimed, isFarewellRewardLocked, onClaimOverride, onClaimFarewellReward = v4.isFarewellRewardClaimed, v4.isFarewellRewardLocked, v4.onClaimOverride, v4.onClaimFarewellReward
        local v5 = useTheme()
        local v6, v7 = useState(buildSeedState)

        if currentTicketsOverride == nil then
            currentTicketsOverride = v6.currentTickets
        end

        if barTicketsOverride == nil then
            barTicketsOverride = currentTicketsOverride
        end

        local v8 = claimedTierIdsOverride or v6.claimedTierIds
        local v9 = useCountUpBinding(currentTicketsOverride)
        local v10 = useCallback(function(p3) -- line: 81
            -- upvalues: barTicketsOverride (ref), onClaimOverride (copy), v7 (copy), getChallengeTierDefinition (copy), cloneSet (copy)
            if onClaimOverride then
                onClaimOverride(p3)

                return nil
            end

            v7(function(p4) -- line: 86
                -- upvalues: p3 (copy), barTicketsOverride (ref), getChallengeTierDefinition (copy), cloneSet (copy)
                if p4.claimedTierIds[p3] ~= nil then
                    return p4
                end

                local v11 = getChallengeTierDefinition(p3)

                if not v11 or barTicketsOverride < v11.thresholdAmount then
                    return p4
                end

                local v12 = cloneSet(p4.claimedTierIds)

                v12[p3] = true

                return {
                    claimedTierIds = v12,
                    currentTickets = p4.currentTickets
                }
            end)
        end, { barTicketsOverride, onClaimOverride })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.071),
            Size = UDim2.fromScale(0.55, 0.018)
        }, react.createElement(default3, {
            zIndex = 5
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.0085),
            Size = UDim2.fromScale(0.9, 0.034)
        }, react.createElement(default, {
            text = "Tickets community event",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v5.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.045),
            Size = UDim2.fromScale(0.85, 0.017)
        }, react.createElement(default, {
            shadowYScale = 0.05,
            text = "Earn tickets together, fill the bar, get rewards!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v5.textFont,
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.112),
            Size = UDim2.fromScale(0.8, 0.038)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 220, 150),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 5,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 0.8)
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            },
            text = v9:map(function(p5) -- line: 186
                -- upvalues: commify (copy)
                return (("Total Progress: %*"):format((commify(p5))))
            end)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.celebrationTicket,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.08, 1)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.175),
            Size = UDim2.fromScale(1, 0.8240000000000001)
        }, react.createElement(default2, {
            claimedTierIds = v8,
            currentTickets = barTicketsOverride,
            fillRef = fillRef,
            isFarewellRewardClaimed = isFarewellRewardClaimed,
            isFarewellRewardLocked = isFarewellRewardLocked,
            onClaim = v10,
            onClaimFarewellReward = onClaimFarewellReward,
            tiers = challengeTiers
        })))
    end
}
