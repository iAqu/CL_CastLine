-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, MarketplaceService, SocialService, UserInputService = services.Players, services.MarketplaceService, services.SocialService, services.UserInputService
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useDiscordLinkAllowed = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-local-player-policy-info").useDiscordLinkAllowed
local useFriendsInServerCount = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-friends-in-server-count").useFriendsInServerCount
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "money-gain-utils")
local premiumMoneyBonusPercent, friendMoneyBonusPerFriend = v1.premiumMoneyBonusPercent, v1.friendMoneyBonusPerFriend
local default = RuntimeLib.import(script, script.Parent, "bottom-bar-item").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-manager").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "celebration-toolbar-manager").default
local getToolbarMetrics = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-metrics").getToolbarMetrics

return {
    toolbarRowPositionXScale = 0.33,
    default = function(p1) -- BottomBar | line: 36
        -- upvalues: react (copy), Players (copy), MarketplaceService (copy), SocialService (copy), UserInputService (copy), images (copy), useScreenSizeState (copy), useDiscordLinkAllowed (copy), useFriendsInServerCount (copy), premiumMoneyBonusPercent (copy), friendMoneyBonusPerFriend (copy), default (copy), default2 (copy), default3 (copy), getToolbarMetrics (copy)
        local forceDiscordVisible, isCelebrationPlace, onBackpackClick, onDailyRewardsPress = p1.forceDiscordVisible, p1.isCelebrationPlace, p1.onBackpackClick, p1.onDailyRewardsPress
        local onDiscordPress, onPlaytimeWheelPress, showDailyReward = p1.onDiscordPress, p1.onPlaytimeWheelPress, p1.showDailyReward

        if showDailyReward == nil then
            showDailyReward = true
        end

        local showDailyRewardNotification, spinCount = p1.showDailyRewardNotification, p1.spinCount

        if spinCount == nil then
            spinCount = 0
        end

        local v2 = useScreenSizeState() == "lg"
        local v3 = useDiscordLinkAllowed()

        if forceDiscordVisible ~= nil then
            v3 = forceDiscordVisible
        end

        local v4 = useFriendsInServerCount()
        local v5 = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
        local v6 = premiumMoneyBonusPercent
        local v7 = v4 * friendMoneyBonusPerFriend
        local v8 = getToolbarMetrics(not v2)
        local toolbarHeight, toolbarWidth, unitHeight = v8.toolbarHeight, v8.toolbarWidth, v8.unitHeight
        local v9 = if v2 then 0.68 else 0.56
        local v10 = toolbarHeight * v9
        local v11 = v9 * 0.04
        local v12 = (if showDailyReward then 1 else 0) + 4 + (if v3 == true then 1 else 0)
        local v13 = v10 * v12 + v11 * (v12 - 1)
        local createElement, Fragment, createElement2 = react.createElement, react.Fragment, react.createElement
        local t1 = {
            name = "Roblox Plus Money Boost",
            imageId = images.premiumIcon,
            isEdge = v2
        }

        if v5 then
            t1.onClick = nil
        else
            v6 = 0

            t1.onClick = function() -- line: 77
                -- upvalues: Players (copy), MarketplaceService (copy)
                return MarketplaceService:PromptPremiumPurchase(Players.LocalPlayer)
            end
        end

        t1.statIncrease = v6
        t1.subtitle = v5 and "Active!" or "Tap to Purchase!"

        local v18 = createElement(Fragment, nil, createElement2(default, t1), react.createElement(default, {
            imageSize = 1.3,
            name = "Friend Money Boost",
            subtitle = "Tap to invite Friends!",
            imageId = images.addFriendIcon,
            onClick = function() -- onClick | line: 86
                -- upvalues: Players (copy), SocialService (copy)
                return SocialService:PromptGameInvite(Players.LocalPlayer)
            end,
            statIncrease = v7
        }), v3 == true and react.createElement(default, {
            name = "Discord",
            promoBadgeText = "FREE",
            subtitle = "Tap to claim rewards!",
            imageId = images.discordIcon,
            onClick = onDiscordPress,
            titleSize = UDim2.fromScale(0.5, 0.6)
        }), showDailyReward and react.createElement(default, {
            name = "Daily Rewards",
            subtitle = "Tap to Open!",
            imageId = images.calendarIcon,
            onClick = onDailyRewardsPress,
            shake = showDailyRewardNotification,
            showNotification = showDailyRewardNotification
        }), react.createElement(default, {
            name = "Playtime Rewards",
            subtitle = "Tap to open!",
            imageId = images.wheelIcon,
            notificationBadgeText = if spinCount > 0 then tostring(spinCount) else nil,
            onClick = onPlaytimeWheelPress,
            shake = spinCount > 0
        }), react.createElement(default, {
            imageId = "rbxassetid://98670520495608",
            name = "Feedback",
            subtitle = "Tap to send feedback!",
            onClick = function() -- onClick | line: 115
                -- upvalues: SocialService (copy)
                return SocialService:PromptFeedbackSubmissionAsync()
            end
        }))

        if v2 then
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 10,
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0.01, 0, 0.98, 0),
                Size = UDim2.new(v13, 0, v10, 0)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(v11, 0),
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), v18)
        end

        local v19 = toolbarWidth + 0 + v13

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0.33, 0, 0.97, 0),
            Size = UDim2.new(v19, UserInputService.TouchEnabled and -96 or 0, unitHeight, 0)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }), if isCelebrationPlace then react.createElement(default3, {
            layoutOrder = 1,
            anchorPoint = Vector2.new(0, 0),
            onBackpackClick = onBackpackClick,
            position = UDim2.fromScale(0, 0),
            size = UDim2.fromScale(0.3, 1)
        }) else react.createElement(default2, {
            layoutOrder = 1,
            anchorPoint = Vector2.new(0, 0),
            onBackpackClick = onBackpackClick,
            position = UDim2.fromScale(0, 0),
            size = UDim2.fromScale(0.3, 1)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(v13 / v19, 0.32)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(v11, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), v18))
    end
}
