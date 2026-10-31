-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "sun-burst-background").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local challengeMaxTicketAmount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers").challengeMaxTicketAmount
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins")
local fishingRodSkinsData, fomoRodSkinId = v1.fishingRodSkinsData, v1.fomoRodSkinId
local default5 = RuntimeLib.import(script, script.Parent, "challenge-reward-slot").default
local v2 = fishingRodSkinsData[fomoRodSkinId]
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})

local function ChallengeProgressBar(p1) -- line: 53
    -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), images (copy), abbreviate (copy), challengeMaxTicketAmount (copy), default5 (copy), v2 (copy), v3 (copy), v4 (copy)
    local claimedTierIds, currentTickets, fillRef, isFarewellRewardClaimed = p1.claimedTierIds, p1.currentTickets, p1.fillRef, p1.isFarewellRewardClaimed
    local v5 = isFarewellRewardClaimed

    if isFarewellRewardClaimed == nil then
        v5 = false
    end

    local isFarewellRewardLocked = p1.isFarewellRewardLocked
    local v6 = isFarewellRewardLocked

    if isFarewellRewardLocked == nil then
        v6 = true
    end

    local onClaim, onClaimFarewellReward, tiers = p1.onClaim, p1.onClaimFarewellReward, p1.tiers
    local v7 = challengeMaxTicketAmount / 1
    local v10 = math.clamp(math.clamp(currentTickets / v7, 0, 1) + 0.005, 0, 1)
    local v11 = table.create(#tiers)

    for v12, v13 in tiers do
        local _ = v12 - 1

        v11[v12] = 0.9400000000000001 - v13.thresholdAmount / v7 * 0.92
    end

    local v14 = 1.84 / (#tiers + 1)
    local v15 = react.createElement(default, {
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
        Size = UDim2.fromScale(1, v10),
        ref = fillRef
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }), react.createElement("uigradient", {
        Rotation = 90,
        Color = v4
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = images.ticketBarFillTop,
        Position = UDim2.fromScale(0.5, 1 - v10 - 0.572),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1.15, 1.15)
    }))
    local v16 = table.create(#tiers)

    local function v17(p2, p3) -- line: 140
        -- upvalues: claimedTierIds (copy), currentTickets (copy), v5 (ref), v6 (ref), onClaim (copy), onClaimFarewellReward (copy), tiers (copy), v7 (copy), v11 (copy), v14 (copy), react (copy), default2 (copy), default3 (copy), default4 (copy), images (copy), abbreviate (copy), default5 (copy), v2 (copy), v3 (copy)
        local v18 = if p3 % 2 == 0 then "left" else "right"
        local v19 = p3 == #tiers - 1
        local v20 = if v19 then 0.9400000000000001 - p2.thresholdAmount / v7 * 0.92 + 0.015 else 0.9400000000000001 - p2.thresholdAmount / v7 * 0.92
        local v21 = currentTickets < p2.thresholdAmount
        local v22 = claimedTierIds[p2.tierId] ~= nil
        local v23 = not v21 and not v22
        local v24 = if v18 == "left" then 0.351 else 0.649
        local v25 = if v18 == "left" then 0.425 else 0.5750000000000001
        local v26 = if v18 == "left" then 0.649 else 0.351
        local v27 = v14

        if p3 - 2 >= 0 then
            v27 = math.min(v14, (math.abs(v11[p3 + 1] - v11[p3 - 1])))
        end

        if p3 + 2 < #v11 then
            v27 = math.min(v27, (math.abs(v11[p3 + 1] - v11[p3 + 3])))
        end

        local v32 = v27 * 0.8
        local v33 = v27 * 0.3
        local v34 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.triangleIcon,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(v25, v20),
            Rotation = v18 == "left" and 270 or 90,
            Size = UDim2.fromScale(0.03, 0.03)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v35 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(v26 - 0.075, v20),
            Size = UDim2.fromScale(0.2, v33)
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
            text = abbreviate(p2.thresholdAmount)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.celebrationTicket,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.2, 1)
        }))
        local v36 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.06, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v37

        if v19 then
            local v38 = react.createElement(default4, {
                doRotate = true,
                uiAspectRatio = 1,
                zIndex = 0,
                anchorPoint = Vector2.new(0.5, 0.5),
                image = images.shineBackground,
                imageColor3 = Color3.fromRGB(255, 220, 60),
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1.8, 1.8)
            })
            local v39 = v2

            if v2 ~= nil then
                v39 = v2.imageId
            end

            if v39 == nil then
                v39 = images.questionMarksIcon
            end

            local t3 = {
                icon = v39,
                isClaimed = v5,
                isLocked = v6,
                size = UDim2.fromScale(1, 1),
                zIndex = 1
            }
            local v40 = react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 3,
                Size = UDim2.fromScale(0.5, 0.5)
            }, v38, react.createElement(default5, t3))
            local t4 = {
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    TextWrapped = true,
                    Size = UDim2.fromScale(0.7, 0.16)
                },
                popoutColor = Color3.fromRGB(0, 0, 0)
            }
            local v41 = v2

            if v2 ~= nil then
                v41 = v2.name
            end

            t4.text = if v41 == nil then "MYSTERY GIFT" else v41
            v37 = react.createElement(react.Fragment, nil, v40, react.createElement(default2, t4), not v6 and not v5 and react.createElement(default3, {
                cornerRadius = 0.25,
                label = "Claim",
                shadowYScale = 0.06,
                zIndex = 2,
                color = v3,
                frameSize = UDim2.fromScale(0.4, 0.2),
                onClick = function() -- onClick | line: 262
                    -- upvalues: onClaimFarewellReward (copy)
                    local v42 = onClaimFarewellReward

                    if onClaimFarewellReward ~= nil then
                        v42 = onClaimFarewellReward()
                    end

                    return v42
                end,
                popoutColor = Color3.fromRGB(10, 120, 10),
                position = UDim2.fromScale(0.5, 1)
            }))
        else
            local createElement, Fragment = react.createElement, react.Fragment
            local v43 = react.createElement(default5, {
                icon = p2.rewardIcon,
                isClaimed = v22,
                isLocked = v21,
                quantity = p2.rewardQuantity,
                size = UDim2.fromScale(0.5, 0.5)
            })

            v23 = v23 and react.createElement(default3, {
                cornerRadius = 0.25,
                label = "Claim",
                shadowYScale = 0.06,
                zIndex = 2,
                color = v3,
                frameSize = UDim2.fromScale(0.4, 0.2),
                onClick = function() -- onClick | line: 286
                    -- upvalues: p2 (copy), onClaim (copy)
                    return onClaim(p2.tierId)
                end,
                popoutColor = Color3.fromRGB(10, 120, 10),
                position = UDim2.fromScale(0.5, 1)
            })
            v37 = createElement(Fragment, nil, v43, v23)
        end

        return react.createElement(react.Fragment, {
            key = p2.tierId
        }, v34, v35, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(v24, v20 - 0.005),
            Size = UDim2.fromScale(0.2, v32)
        }, v36, v37))
    end

    for v44, v45 in tiers do
        v16[v44] = v17(v45, v44 - 1, tiers)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, v15, v16)
end

return {
    default = react.memo(ChallengeProgressBar)
}
