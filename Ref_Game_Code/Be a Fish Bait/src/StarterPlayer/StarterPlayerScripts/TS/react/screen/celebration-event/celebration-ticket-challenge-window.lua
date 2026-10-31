-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local default3 = RuntimeLib.import(script, script.Parent, "celebration-challenge-tab-content").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 221, 110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 185, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 140, 10))
})
local v2 = Color3.fromRGB(255, 220, 130)
local v3 = UDim2.fromScale(0.65, 0.65)

return {
    default = function(p1) -- CelebrationTicketChallengeWindow | line: 36
        -- upvalues: react (copy), useEffect (copy), useRef (copy), TweenService (copy), default (copy), default2 (copy), default3 (copy), v1 (copy), v2 (copy), v3 (copy)
        local barTickets, claimedTierIds, currentTickets, isFarewellRewardClaimed = p1.barTickets, p1.claimedTierIds, p1.currentTickets, p1.isFarewellRewardClaimed
        local isFarewellRewardLocked, onClaim, onClaimFarewellReward, onClose = p1.isFarewellRewardLocked, p1.onClaim, p1.onClaimFarewellReward, p1.onClose
        local v4 = useRef(nil)
        local v5 = useRef(nil)

        useEffect(function() -- line: 51
            -- upvalues: v4 (copy), v5 (copy), TweenService (copy)
            local v6 = task.delay(1, function() -- line: 52
                -- upvalues: v4 (copy), v5 (copy), TweenService (copy)
                local current = v4.current
                local current2 = v5.current

                if current == nil or current2 == nil then
                    return nil
                end

                local v7 = current.AbsoluteWindowSize.Y * 0.5
                local v11 = math.clamp(current2.AbsolutePosition.Y - current.AbsolutePosition.Y + current.CanvasPosition.Y - v7, 0, (math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)))

                TweenService:Create(current, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CanvasPosition = Vector2.new(0, v11)
                }):Play()
            end)

            return function() -- line: 67
                -- upvalues: v6 (copy)
                return task.cancel(v6)
            end
        end, {})

        return react.createElement(default, {
            aspectRatio = 1.4833333333333334,
            title = "Ticket Challenge",
            bodyBg = v2,
            headerBg = v1,
            onClose = onClose,
            size = v3
        }, react.createElement(default2, {
            canvasHeightScale = 3.445,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            position = UDim2.fromScale(0.5, 0.97),
            scrollFrameRef = v4,
            size = UDim2.fromScale(0.97, 0.87)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 2.65)
        }, react.createElement("uiscale", {
            Scale = 1.3
        }), react.createElement(default3, {
            barTicketsOverride = barTickets,
            claimedTierIdsOverride = claimedTierIds,
            currentTicketsOverride = currentTickets,
            fillRef = v5,
            isFarewellRewardClaimed = isFarewellRewardClaimed,
            isFarewellRewardLocked = isFarewellRewardLocked,
            onClaimFarewellReward = onClaimFarewellReward,
            onClaimOverride = onClaim
        }))))
    end
}
