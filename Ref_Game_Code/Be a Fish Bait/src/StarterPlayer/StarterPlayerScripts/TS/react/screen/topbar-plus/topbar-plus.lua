-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createContext, useContext, useEffect, useMemo = react.createContext, react.useContext, react.useEffect, react.useMemo
local useRef, useState = react.useRef, react.useState
local useTopbarIcon = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-topbar-icon").useTopbarIcon
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelector, reflex.useRootSelectorCreator
local selectPlaytimeRewardEligibilityData = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "topbar.selectors").selectPlaytimeRewardEligibilityData
local selectShouldAutoPromptDailyReward = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectShouldAutoPromptDailyReward
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils")
local getPlaytimeRewardElapsedSeconds, playtimeRewards = v1.getPlaytimeRewardElapsedSeconds, v1.playtimeRewards
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local selectPlayerRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerRewards
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "changelog-utils")
local getChangelogReadRewardId, latestChangelogVersion = v2.getChangelogReadRewardId, v2.latestChangelogVersion
local ChangelogTopbarIcon, SettingsTopbarIcon

local function TopbarPlus() -- line: 47
    -- upvalues: react (copy), ChangelogTopbarIcon (ref), SettingsTopbarIcon (ref)
    return react.createElement(react.Fragment, nil, react.createElement(ChangelogTopbarIcon), react.createElement(SettingsTopbarIcon))
end

local PlaytimeRewardTopbarIcon

local function PlaytimeRewardTopbarIconOrNothing() -- line: 52
    -- upvalues: react (copy), useRootSelector (copy), selectShouldAutoPromptDailyReward (copy), localPlayerUserId (copy), PlaytimeRewardTopbarIcon (ref)
    if useRootSelector(selectShouldAutoPromptDailyReward(localPlayerUserId)) then
        return react.createElement(PlaytimeRewardTopbarIcon)
    end

    return react.createElement(react.Fragment)
end

local TopbarPlusIcon

function PlaytimeRewardTopbarIcon() -- line: 61
    -- upvalues: react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), useRootProducer (copy), useRootSelectorCreator (copy), selectPlaytimeRewardEligibilityData (copy), localPlayerUserId (copy), getPlaytimeRewardElapsedSeconds (copy), playtimeRewards (copy), Workspace (copy), TopbarPlusIcon (ref)
    local v3 = useRootProducer()
    local v4 = useRootSelectorCreator(selectPlaytimeRewardEligibilityData, localPlayerUserId)
    local v5 = useRef(nil)
    local v6, v7 = useState(0)
    local v8 = useMemo(function() -- line: 66
        -- upvalues: v4 (copy), getPlaytimeRewardElapsedSeconds (copy), playtimeRewards (copy), Workspace (copy)
        if v4 == nil then
            return false
        end

        local playTimeRewardStartTime, savedTimeForPlaytimeReward, timeLastSaved, rewards = v4.playTimeRewardStartTime, v4.savedTimeForPlaytimeReward, v4.timeLastSaved, v4.rewards
        local v9 = getPlaytimeRewardElapsedSeconds(Workspace:GetServerTimeNow(), savedTimeForPlaytimeReward, playTimeRewardStartTime, timeLastSaved) / 60

        for _, v10 in playtimeRewards do
            if rewards[v10.rewardId] == true ~= true and v10.timeToClaim <= v9 then
                return true
            end
        end

        return false
    end, { v4 })

    useEffect(function() -- line: 87
        -- upvalues: v5 (copy), v7 (copy), v8 (copy)
        if v5.current == true and v8 == false then
            v7(function(p1) -- line: 89
                return p1 + 1
            end)
        end

        v5.current = v8
    end, { v8 })

    local v11 = useMemo(function() -- line: 95
        -- upvalues: v3 (copy)
        return function() -- line: 96
            -- upvalues: v3 (copy)
            return v3.windowOpened({
                currentWindow = "playtimeRewards"
            })
        end
    end, { v3 })

    return react.createElement(TopbarPlusIcon, {
        label = "🎁",
        name = "PlaytimeRewardIcon",
        oneClick = true,
        notices = v8 and 1 or 0,
        notifyClearNoticeEvent = v6,
        onSelected = v11
    })
end

local function CodesTopbarIcon() -- line: 112
    -- upvalues: react (copy), useMemo (copy), useRootProducer (copy), TopbarPlusIcon (ref)
    local v12 = useRootProducer()
    local v13 = useMemo(function() -- line: 114
        -- upvalues: v12 (copy)
        return function() -- line: 115
            -- upvalues: v12 (copy)
            return v12.windowOpened({
                currentWindow = "claimCode"
            })
        end
    end, { v12 })

    return react.createElement(TopbarPlusIcon, {
        label = "Codes",
        name = "CodesIcon",
        oneClick = true,
        onSelected = v13
    })
end

function ChangelogTopbarIcon() -- line: 129
    -- upvalues: react (copy), useMemo (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), images (copy), functions (copy), selectPlayerRewards (copy), getChangelogReadRewardId (copy), latestChangelogVersion (copy), TopbarPlusIcon (ref)
    local v14 = useRootProducer()
    local v15 = useRootSelector(selectPlayerRewards(localPlayerUserId))
    local v16 = latestChangelogVersion ~= nil

    v16 = v16 and (if v15 == nil then v15 else v15[getChangelogReadRewardId(latestChangelogVersion)]) ~= true

    local v17 = useMemo(function() -- line: 142
        -- upvalues: v14 (copy), functions (copy), latestChangelogVersion (copy)
        return function() -- line: 143
            -- upvalues: v14 (copy), functions (copy), latestChangelogVersion (copy)
            v14.windowOpened({
                currentWindow = "changelog"
            })

            if latestChangelogVersion ~= nil then
                functions.markChangelogRead(latestChangelogVersion)
            end
        end
    end, { v14 })

    return react.createElement(TopbarPlusIcon, {
        alignment = "Right",
        name = "ChangelogIcon",
        oneClick = true,
        image = images.changelogIcon,
        notices = v16 and 1 or 0,
        onSelected = v17,
        theme = {
            {
                "Notice",
                "BackgroundColor3",
                Color3.fromRGB(235, 38, 38)
            },
            {
                "NoticeLabel",
                "TextColor3",
                Color3.fromRGB(255, 255, 255)
            }
        }
    })
end

function SettingsTopbarIcon() -- line: 162
    -- upvalues: react (copy), useMemo (copy), useRootProducer (copy), images (copy), TopbarPlusIcon (ref)
    local v18 = useRootProducer()
    local v19 = useMemo(function() -- line: 164
        -- upvalues: v18 (copy)
        return function() -- line: 165
            -- upvalues: v18 (copy)
            return v18.windowOpened({
                currentWindow = "settings"
            })
        end
    end, { v18 })

    return react.createElement(TopbarPlusIcon, {
        alignment = "Right",
        name = "SettingsIcon",
        oneClick = true,
        image = images.settingsIcon,
        onSelected = v19
    })
end

local v20 = createContext({
    joinType = nil,
    parentIcon = nil
})

local function useParentIcon() -- line: 199
    -- upvalues: useContext (copy), v20 (copy)
    return useContext(v20)
end

function TopbarPlusIcon(p2) -- line: 228
    -- upvalues: react (copy), useContext (copy), useEffect (copy), useRef (copy), useTopbarIcon (copy), v20 (copy)
    local alignment, autoDeselect, caption, captionHint = p2.alignment, p2.autoDeselect, p2.caption, p2.captionHint
    local children, childTheme, cornerRadius, cornerRadiusIconState = p2.children, p2.childTheme, p2.cornerRadius, p2.cornerRadiusIconState
    local disableOverlay, enabled, iconRef, image = p2.disableOverlay, p2.enabled, p2.iconRef, p2.image
    local imageIconState, imageRatio, imageRatioIconState, imageScale = p2.imageIconState, p2.imageRatio, p2.imageRatioIconState, p2.imageScale
    local imageScaleIconState, label, labelIconState, locked = p2.imageScaleIconState, p2.label, p2.labelIconState, p2.locked
    local name, onDeselected, onNotified, onSelected = p2.name, p2.onDeselected, p2.onNotified, p2.onSelected
    local onToggled, onViewingEnded, onViewingStarted, oneClick = p2.onToggled, p2.onViewingEnded, p2.onViewingStarted, p2.oneClick
    local order, orderIconState, textFont, textFontIconState = p2.order, p2.orderIconState, p2.textFont, p2.textFontIconState
    local textSize, textSizeIconState, theme, toggleKey = p2.textSize, p2.textSizeIconState, p2.theme, p2.toggleKey
    local width, widthIconState, notifyClearNoticeEvent, notices = p2.width, p2.widthIconState, p2.notifyClearNoticeEvent, p2.notices
    local v21 = useTopbarIcon()
    local v22 = useContext(v20)
    local parentIcon, joinType = v22.parentIcon, v22.joinType

    useEffect(function() -- line: 275
        -- upvalues: iconRef (copy), v21 (copy)
        if iconRef and v21 ~= nil then
            iconRef(v21)
        end
    end, { iconRef, v21 })
    useEffect(function() -- line: 281
        -- upvalues: v21 (copy), parentIcon (copy), joinType (copy)
        if v21 == nil then
            return nil
        end

        if parentIcon and joinType then
            if joinType == "dropdown" then
                v21:joinDropdown(parentIcon)
            elseif joinType == "menu" then
                v21:joinMenu(parentIcon)
            end
        end

        return function() -- line: 292
            -- upvalues: v21 (copy), parentIcon (copy), joinType (copy)
            if parentIcon and joinType then
                v21:leave()
            end
        end
    end, { parentIcon, joinType, v21 })

    local v23 = useRef(0)
    local v24 = useRef(nil)
    local v25 = useRef({})

    useEffect(function() -- line: 303
        -- upvalues: notifyClearNoticeEvent (copy), notices (copy), v21 (copy), v23 (copy), v24 (copy), v25 (copy)
        if v21 == nil then
            return nil
        end

        local v26 = notices

        if notices == nil then
            v26 = 0
        end

        local current = v23.current

        local function v27() -- line: 313
            -- upvalues: v21 (copy), v25 (copy)
            v21:clearNotices()

            for _, v28 in v25.current do
                v28:Destroy()
            end

            v25.current = {}
        end

        local function v29(p3) -- line: 320
            -- upvalues: v21 (copy), v25 (copy)
            local n1 = 0
            local v30 = false

            while true do
                if v30 then
                    n1 += 1
                else
                    v30 = true
                end

                if n1 < p3 then
                    local BindableEvent = Instance.new("BindableEvent")

                    table.insert(v25.current, BindableEvent)
                    v21:notify(BindableEvent.Event)
                    continue
                end

                break
            end
        end

        if notifyClearNoticeEvent ~= nil and notifyClearNoticeEvent ~= v24.current then
            v24.current = notifyClearNoticeEvent
            v27()
            v29(v26)
            v23.current = v26

            return nil
        end

        if v26 == 0 and current > 0 then
            v27()
        elseif current < v26 then
            v29(v26 - current)
        elseif v26 < current then
            v27()
            v29(v26)
        end

        v23.current = v26

        return function() -- line: 358
            -- upvalues: v27 (copy)
            v27()
        end
    end, { notices, v21, notifyClearNoticeEvent })
    useEffect(function() -- line: 363
        -- upvalues: name (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if name ~= nil then
            v21:setName(name)
        end
    end, { name, v21 })
    useEffect(function() -- line: 371
        -- upvalues: enabled (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        local v31 = enabled

        if enabled == nil then
            v31 = true
        end

        v21:setEnabled(v31)
    end, { enabled, v21 })
    useEffect(function() -- line: 382
        -- upvalues: image (copy), imageIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if image ~= nil then
            v21:setImage(image, imageIconState)
        end
    end, { image, imageIconState, v21 })
    useEffect(function() -- line: 390
        -- upvalues: label (copy), labelIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if label ~= nil then
            v21:setLabel(label, labelIconState)
        end
    end, { label, labelIconState, v21 })
    useEffect(function() -- line: 398
        -- upvalues: alignment (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if alignment ~= nil then
            v21:align(alignment)
        end
    end, { alignment, v21 })
    useEffect(function() -- line: 406
        -- upvalues: order (copy), orderIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if order ~= nil then
            v21:setOrder(order, orderIconState)
        end
    end, { order, orderIconState, v21 })
    useEffect(function() -- line: 414
        -- upvalues: width (copy), widthIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if width ~= nil then
            v21:setWidth(width, widthIconState)
        end
    end, { width, widthIconState, v21 })
    useEffect(function() -- line: 422
        -- upvalues: caption (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if caption ~= nil then
            v21:setCaption(caption)
        else
            v21:setCaption(nil)
        end
    end, { caption, v21 })
    useEffect(function() -- line: 432
        -- upvalues: captionHint (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if captionHint ~= nil then
            v21:setCaptionHint(captionHint)
        end
    end, { captionHint, v21 })
    useEffect(function() -- line: 441
        -- upvalues: cornerRadius (copy), cornerRadiusIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if cornerRadius == nil then
            return
        end

        v21:setCornerRadius(cornerRadius.scale, cornerRadius.offset, cornerRadiusIconState)
    end, { cornerRadius, cornerRadiusIconState, v21 })
    useEffect(function() -- line: 449
        -- upvalues: imageScale (copy), imageScaleIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if imageScale ~= nil then
            v21:setImageScale(imageScale, imageScaleIconState)
        end
    end, { imageScale, imageScaleIconState, v21 })
    useEffect(function() -- line: 457
        -- upvalues: imageRatio (copy), imageRatioIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if imageRatio ~= nil then
            v21:setImageRatio(imageRatio, imageRatioIconState)
        end
    end, { imageRatio, imageRatioIconState, v21 })
    useEffect(function() -- line: 465
        -- upvalues: textSize (copy), textSizeIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if textSize ~= nil then
            v21:setTextSize(textSize, textSizeIconState)
        end
    end, { textSize, textSizeIconState, v21 })
    useEffect(function() -- line: 473
        -- upvalues: textFont (copy), textFontIconState (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if textFont == nil then
            return
        end

        v21:setTextFont(textFont.font, textFont.weight or Enum.FontWeight.Regular, textFont.style or Enum.FontStyle.Normal, textFontIconState)
    end, { textFont, textFontIconState, v21 })
    useEffect(function() -- line: 482
        -- upvalues: oneClick (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if oneClick ~= nil then
            v21:oneClick(oneClick)
        end
    end, { oneClick, v21 })
    useEffect(function() -- line: 490
        -- upvalues: autoDeselect (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if autoDeselect ~= nil then
            v21:autoDeselect(autoDeselect)
        end
    end, { autoDeselect, v21 })
    useEffect(function() -- line: 498
        -- upvalues: locked (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if locked ~= nil then
            if locked then
                v21:lock()
            else
                v21:unlock()
            end
        end
    end, { locked, v21 })
    useEffect(function() -- line: 510
        -- upvalues: disableOverlay (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if disableOverlay ~= nil then
            v21:disableOverlay(disableOverlay)
        end
    end, { disableOverlay, v21 })
    useEffect(function() -- line: 518
        -- upvalues: toggleKey (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if toggleKey ~= nil then
            v21:bindToggleKey(toggleKey)
        end

        return function() -- line: 525
            -- upvalues: toggleKey (copy), v21 (copy)
            if toggleKey ~= nil then
                v21:unbindToggleKey(toggleKey)
            end
        end
    end, { toggleKey, v21 })

    local v34 = useRef(onSelected)
    local v35 = useRef(onDeselected)
    local v36 = useRef(onToggled)
    local v37 = useRef(onViewingStarted)
    local v38 = useRef(onViewingEnded)
    local v39 = useRef(onNotified)

    useEffect(function() -- line: 540
        -- upvalues: onSelected (copy), v34 (copy)
        v34.current = onSelected
    end, { onSelected })
    useEffect(function() -- line: 543
        -- upvalues: onDeselected (copy), v35 (copy)
        v35.current = onDeselected
    end, { onDeselected })
    useEffect(function() -- line: 546
        -- upvalues: onToggled (copy), v36 (copy)
        v36.current = onToggled
    end, { onToggled })
    useEffect(function() -- line: 549
        -- upvalues: onViewingStarted (copy), v37 (copy)
        v37.current = onViewingStarted
    end, { onViewingStarted })
    useEffect(function() -- line: 552
        -- upvalues: onViewingEnded (copy), v38 (copy)
        v38.current = onViewingEnded
    end, { onViewingEnded })
    useEffect(function() -- line: 555
        -- upvalues: onNotified (copy), v39 (copy)
        v39.current = onNotified
    end, { onNotified })
    useEffect(function() -- line: 560
        -- upvalues: v21 (copy), v34 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("selected", function(_, p5, p6) -- line: 564
            -- upvalues: v34 (copy)
            local current = v34.current

            if current ~= nil then
                current(p5, p6)
            end
        end)

        return function() -- line: 570
            -- upvalues: v21 (copy)
            v21:unbindEvent("selected")
        end
    end, { v21 })
    useEffect(function() -- line: 574
        -- upvalues: v21 (copy), v35 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("deselected", function(_, p8, p9) -- line: 578
            -- upvalues: v35 (copy)
            local current = v35.current

            if current ~= nil then
                current(p8, p9)
            end
        end)

        return function() -- line: 584
            -- upvalues: v21 (copy)
            v21:unbindEvent("deselected")
        end
    end, { v21 })
    useEffect(function() -- line: 588
        -- upvalues: v21 (copy), v36 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("toggled", function(_, p11, p12, p13) -- line: 592
            -- upvalues: v36 (copy)
            local current = v36.current

            if current ~= nil then
                current(p11, p12, p13)
            end
        end)

        return function() -- line: 598
            -- upvalues: v21 (copy)
            v21:unbindEvent("toggled")
        end
    end, { v21 })
    useEffect(function() -- line: 602
        -- upvalues: v21 (copy), v37 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("viewingStarted", function() -- line: 606
            -- upvalues: v37 (copy)
            local current = v37.current

            if current ~= nil then
                current()
            end
        end)

        return function() -- line: 612
            -- upvalues: v21 (copy)
            v21:unbindEvent("viewingStarted")
        end
    end, { v21 })
    useEffect(function() -- line: 616
        -- upvalues: v21 (copy), v38 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("viewingEnded", function() -- line: 620
            -- upvalues: v38 (copy)
            local current = v38.current

            if current ~= nil then
                current()
            end
        end)

        return function() -- line: 626
            -- upvalues: v21 (copy)
            v21:unbindEvent("viewingEnded")
        end
    end, { v21 })
    useEffect(function() -- line: 630
        -- upvalues: v21 (copy), v39 (copy)
        if v21 == nil then
            return nil
        end

        v21:bindEvent("notified", function() -- line: 634
            -- upvalues: v39 (copy)
            local current = v39.current

            if current ~= nil then
                current()
            end
        end)

        return function() -- line: 640
            -- upvalues: v21 (copy)
            v21:unbindEvent("notified")
        end
    end, { v21 })
    useEffect(function() -- line: 645
        -- upvalues: theme (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if theme ~= nil and #theme > 0 then
            for _, v40 in theme do
                v21:modifyTheme(v40)
            end
        end
    end, { theme, v21 })
    useEffect(function() -- line: 655
        -- upvalues: childTheme (copy), v21 (copy)
        if v21 == nil then
            return nil
        end

        if childTheme ~= nil and #childTheme > 0 then
            for _, v41 in childTheme do
                v21:modifyChildTheme(v41)
            end
        end
    end, { childTheme, v21 })

    if children == nil then
        return react.createElement(react.Fragment)
    end

    return react.createElement(v20.Provider, {
        value = {
            joinType = "dropdown",
            parentIcon = v21
        }
    }, children)
end

local function TopbarPlusDropdown(p14) -- line: 701
    -- upvalues: react (copy), v20 (copy)
    return react.createElement(v20.Provider, {
        value = {
            joinType = "dropdown",
            parentIcon = p14.icon
        }
    }, p14.children)
end

local function TopbarPlusMenu(p15) -- line: 733
    -- upvalues: react (copy), v20 (copy)
    return react.createElement(v20.Provider, {
        value = {
            joinType = "menu",
            parentIcon = p15.icon
        }
    }, p15.children)
end

return {
    default = TopbarPlus,
    useParentIcon = useParentIcon,
    TopbarPlusIcon = TopbarPlusIcon,
    TopbarPlusDropdown = TopbarPlusDropdown,
    TopbarPlusMenu = TopbarPlusMenu
}
