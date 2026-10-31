-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent, "celebration-reward-grid").default
local celebrationRewardLoopStartDay = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils").celebrationRewardLoopStartDay
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 221, 110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 185, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 140, 10))
})
local v2 = Color3.fromRGB(255, 220, 130)

return {
    default = function(p1) -- CelebrationEventLoginWindow | line: 23
        -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), celebrationRewardLoopStartDay (copy), useTheme (copy), v1 (copy), v2 (copy)
        local canClaim, claimableDayIndex, claimedDayIndex, claimedRewards = p1.canClaim, p1.claimableDayIndex, p1.claimedDayIndex, p1.claimedRewards
        local onClaim, onClose = p1.onClaim, p1.onClose
        local v3 = useTheme()
        local v4 = if celebrationRewardLoopStartDay <= claimableDayIndex then celebrationRewardLoopStartDay else 1
        local v5, v6 = useState(v4)

        useEffect(function() -- line: 33
            -- upvalues: v4 (copy), v6 (copy)
            v6(v4)
        end, { v4 })

        local v7 = v5 > 1
        local v8 = v5 < celebrationRewardLoopStartDay

        local function v9(p2, p3, p4, p5) -- line: 38
            -- upvalues: v3 (copy), react (copy)
            return react.createElement("imagebutton", {
                BorderSizePixel = 0,
                ZIndex = 30,
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutoButtonColor = p4,
                BackgroundColor3 = if p4 then Color3.fromRGB(32, 32, 38) else Color3.fromRGB(72, 72, 78),
                BackgroundTransparency = p4 and 0.05 or 0.25,
                Event = {
                    Activated = function() -- Activated | line: 46
                        -- upvalues: p4 (copy), p5 (copy)
                        return p4 and p5()
                    end
                },
                Position = p3,
                Size = UDim2.fromScale(0.065, 0.12)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.18, 0)
            }), react.createElement("uistroke", {
                Thickness = 0.04,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = if p4 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(36, 36, 40),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                ZIndex = 31,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v3.textFont,
                Position = UDim2.fromScale(p2 == "<" and 0.47 or 0.53, 0.5),
                Size = UDim2.fromScale(0.85, 0.85),
                Text = p2,
                TextColor3 = if p4 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(150, 150, 155),
                TextStrokeColor3 = if p4 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(48, 48, 52),
                TextStrokeTransparency = p4 and 0 or 0.35
            }))
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.55, 0.55)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.78
        }), react.createElement(default, {
            title = "Event Daily Login!",
            bodyBg = v2,
            headerBg = v1,
            onClose = onClose,
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 1),
            canClaim = canClaim,
            claimableDayIndex = claimableDayIndex,
            claimedDayIndex = claimedDayIndex,
            claimedRewards = claimedRewards,
            onClaim = onClaim,
            position = UDim2.fromScale(0.5, 0.97),
            size = UDim2.fromScale(0.95, 0.82),
            weekStart = v5
        })), v9("<", UDim2.fromScale(0.895, 1.08), v7, function() -- line: 98
            -- upvalues: v6 (copy)
            return v6(1)
        end), v9(">", UDim2.fromScale(0.9675, 1.08), v8, function() -- line: 100
            -- upvalues: v6 (copy), celebrationRewardLoopStartDay (copy)
            return v6(celebrationRewardLoopStartDay)
        end))
    end
}
