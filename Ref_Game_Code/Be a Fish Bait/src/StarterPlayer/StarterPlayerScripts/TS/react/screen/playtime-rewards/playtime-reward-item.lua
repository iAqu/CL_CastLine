-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils")
local getBorderThickness, getTextSize, getMaxTextSize, getTextStrokeThickness = v1.getBorderThickness, v1.getTextSize, v1.getMaxTextSize, v1.getTextStrokeThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getPlaytimeRewardDisplayText = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils").getPlaytimeRewardDisplayText
local useRainbowGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-rainbow-gradient").useRainbowGradient
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local formatDuration = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").formatDuration
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace

return {
    default = function(p1) -- PlaytimeRewardItem | line: 19
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), getTextSize (copy), getMaxTextSize (copy), getTextStrokeThickness (copy), useScreenSizeState (copy), getPlaytimeRewardDisplayText (copy), useRainbowGradient (copy), default4 (copy), formatDuration (copy), Workspace (copy)
        local secondsLeft = default4(p1.canClaimTimestamp).secondsLeft
        local v2 = useScreenSizeState()
        local v3 = getPlaytimeRewardDisplayText(p1.playtimeReward)
        local isRainbowItem = p1.playtimeReward.isRainbowItem
        local v4 = useRainbowGradient({
            speed = 0.3,
            keypointCount = 16
        })
        local v5 = Workspace:GetServerTimeNow() >= p1.canClaimTimestamp
        local v6, v7

        if v5 then
            v6 = ""
            v7 = not p1.isClaimed and p1.onClaim
        else
            v7 = v5
            v6 = secondsLeft:map(function(p2) -- line: 31
                -- upvalues: formatDuration (copy)
                return formatDuration(p2)
            end)
        end

        local v8 = react.createElement(react.Fragment, nil, react.createElement(default, {
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(40, 40, 40),
            backgroundColorSequence = if not isRainbowItem then nil else v4,
            backgroundTransparency = isRainbowItem and 0.1 or 0.2,
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, not p1.isClaimed and react.createElement(default2, {
            overrideProps = {
                TextScaled = false,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.015),
                Size = UDim2.fromScale(1, 0.25),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextSize = getTextSize(v2, "sm")
            },
            text = v6
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Fit",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.playtimeReward.rewardIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 0.5)
        }), react.createElement(default2, {
            overrideProps = {
                TextScaled = true,
                RichText = true,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromScale(1, 0.25),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextSize = getTextSize(v2, "md")
            },
            text = v3,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }))), v5 and not p1.isClaimed and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Claim!",
            overrideProps = {
                BackgroundTransparency = 1,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            textColor3 = Color3.fromRGB(100, 255, 100)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "md")
        }))), p1.isClaimed and react.createElement("frame", {
            BackgroundTransparency = 0.7,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Claimed",
            overrideProps = {
                BackgroundTransparency = 1,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v2, "sm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v2, "md")
        }))))
        local createElement3 = react.createElement
        local t2 = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.9, 0.9)
        }

        if v7 then
            v8 = react.createElement(default3, {
                onClick = function() -- onClick | line: 128
                    -- upvalues: p1 (copy)
                    local onClaim = p1.onClaim

                    if onClaim ~= nil then
                        onClaim = onClaim(p1.playtimeReward.rewardId)
                    end

                    return onClaim
                end,
                size = UDim2.fromScale(1, 1)
            }, v8)
        end

        return createElement3("frame", t2, v8)
    end
}
