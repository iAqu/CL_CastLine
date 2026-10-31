-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate")
local commify, formatCountdownClock = abbreviate.commify, abbreviate.formatCountdownClock
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = Color3.fromRGB(235, 245, 255)
local v2 = Color3.fromRGB(20, 20, 20)
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})

local function getProgressText(p1, p2) -- line: 19
    -- upvalues: commify (copy), formatCountdownClock (copy)
    local v4 = math.min(p2, p1.targetAmount)

    if p1.type == "playtimeInGame" or p1.type == "playtimeInArea" then
        return (("%* / %*"):format(formatCountdownClock(v4), (formatCountdownClock(p1.targetAmount))))
    end

    if p1.type == "minigameScore" then
        return (("%* / %* pts"):format(commify(v4), (commify(p1.targetAmount))))
    end

    return (("%* / %*"):format(v4, p1.targetAmount))
end

return {
    default = function(p3) -- QuestCard | line: 29
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), commify (copy), images (copy), v1 (copy), v2 (copy), v3 (copy), getProgressText (copy)
        local definition, isClaimed, onClaim, progress = p3.definition, p3.isClaimed, p3.onClaim, p3.progress
        local v5 = useTheme()
        local v6 = definition.targetAmount <= progress
        local v8 = math.clamp(progress / definition.targetAmount, 0, 1)
        local createElement = react.createElement
        local t1 = {
            cornerRadius = 0.1,
            strokeThickness = 0.045,
            zIndex = 1,
            backgroundColor = v1,
            size = UDim2.fromScale(1, 1),
            strokeColor = v2
        }
        local v9 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.06, 0.08),
            Size = UDim2.fromScale(0.68, 0.4)
        }, react.createElement(default2, {
            shadowYScale = 0,
            color = Color3.new(0.1, 0.1, 0.1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 2,
                Font = v5.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 0.03
            },
            text = definition.title
        }))
        local v10 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(0.96, 0.08),
            Size = UDim2.fromScale(0.32, 0.4)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Image = images.celebrationTicket,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.5, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default2, {
            shadowYScale = 0,
            color = Color3.new(0.1, 0.1, 0.1),
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                ZIndex = 2,
                Font = v5.textFont,
                Size = UDim2.fromScale(0.6, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            strokeProps = {
                Thickness = 0.03
            },
            text = ("+%*"):format((commify(definition.rewardAmount)))
        }))
        local createElement2 = react.createElement
        local t2 = {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.94),
            Size = UDim2.fromScale(0.88, 0.32)
        }
        local v11 = if isClaimed then react.createElement(default, {
            cornerRadius = 0.3,
            transparency = 0.3,
            zIndex = 2,
            backgroundColor = Color3.fromRGB(60, 60, 60),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            shadowYScale = 0,
            text = "Claimed",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v5.textFont,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.04
            }
        }))
            elseif v6 then react.createElement(default3, {
                cornerRadius = 0.3,
                label = "Claim!",
                shadowYScale = 0.06,
                zIndex = 2,
                color = v3,
                frameSize = UDim2.fromScale(1, 1),
                onClick = function() -- onClick | line: 135
                    -- upvalues: definition (copy), onClaim (copy)
                    return onClaim(definition.questId)
                end,
                popoutColor = Color3.fromRGB(10, 120, 10)
            })
            else react.createElement(default, {
                cornerRadius = 0.3,
                strokeThickness = 0.03,
                zIndex = 2,
                backgroundColor = Color3.fromRGB(255, 255, 255),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(40, 40, 40)
            }, react.createElement(default, {
                cornerRadius = 0.3,
                zIndex = 3,
                backgroundColor = Color3.fromRGB(255, 190, 60),
                size = UDim2.fromScale(v8, 1)
            }), react.createElement(default2, {
                shadowYScale = 0,
                anchorPoint = Vector2.new(0.5, 0.5),
                color = Color3.new(0.1, 0.1, 0.1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 4,
                    Font = v5.textFont,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.9, 0.8)
                },
                position = UDim2.fromScale(0.5, 0.5),
                strokeProps = {
                    Thickness = 0.03
                },
                text = getProgressText(definition, progress)
            }))

        return createElement(default, t1, v9, v10, createElement2("frame", t2, v11))
    end
}
