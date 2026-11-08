-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

require(script.Types)

local _script = script
local Reference = require(_script.Reference)
local v1 = Reference.getObject()
local v2 = v1 and v1.Value

if v2 and v2 ~= _script then
    return require(v2)
end

if not v1 then
    Reference.addToReplicatedStorage()
end

local GoodSignal = require(_script.Packages.GoodSignal)
local Janitor = require(_script.Packages.Janitor)
local Utility = require(_script.Utility)
local Themes = require(_script.Features.Themes)
local Gamepad = require(_script.Features.Gamepad)
local Overflow = require(_script.Features.Overflow)
local t1 = {}

t1.__index = t1

local LocalPlayer = Players.LocalPlayer
local Themes2 = _script.Features.Themes
local t2 = {}
local v3 = GoodSignal.new()
local Elements = _script.Elements
local n1 = 0
local t3 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
}

t1.baseDisplayOrderChanged = GoodSignal.new()
t1.baseDisplayOrder = 10
t1.baseTheme = require(Themes2.Default)
t1.isOldTopbar = false
t1.iconsDictionary = t2
t1.insetHeightChanged = GoodSignal.new()
t1.container = require(Elements.Container)(t1)
t1.topbarEnabled = true
t1.iconAdded = GoodSignal.new()
t1.iconRemoved = GoodSignal.new()
t1.iconChanged = GoodSignal.new()

function t1.getIcons() -- line: 110
    -- upvalues: t1 (copy)
    return t1.iconsDictionary
end

function t1.getIconByUID(p1) -- line: 114
    -- upvalues: t1 (copy)
    return t1.iconsDictionary[p1] or nil
end

function t1.getIcon(p2) -- line: 122
    -- upvalues: t1 (copy), t2 (copy)
    local v4 = t1.getIconByUID(p2)

    if v4 then
        return v4
    end

    for _, v5 in pairs(t2) do
        if v5.name == p2 then
            return v5
        end
    end

    return nil
end

function t1.setTopbarEnabled(p3, p4) -- line: 135
    -- upvalues: t1 (copy)
    local v6 = if typeof(p3) == "boolean" then p3 else t1.topbarEnabled

    if not p4 then
        t1.topbarEnabled = v6
    end

    for _, v7 in pairs(t1.container) do
        v7.Enabled = v6
    end
end

function t1.modifyBaseTheme(p5) -- line: 147
    -- upvalues: Themes (copy), t1 (copy), t2 (copy)
    local v8 = Themes.getModifications(p5)

    for _, v9 in pairs(v8) do
        for _, v10 in pairs(t1.baseTheme) do
            Themes.merge(v10, v9)
        end
    end

    for _, v11 in pairs(t2) do
        v11:setTheme(t1.baseTheme)
    end
end

function t1.setDisplayOrder(p6) -- line: 159
    -- upvalues: t1 (copy)
    t1.baseDisplayOrder = p6
    t1.baseDisplayOrderChanged:Fire(p6)
end

task.defer(Gamepad.start, t1)
task.defer(Overflow.start, t1)
task.defer(function() -- line: 169
    -- upvalues: _script (copy), t1 (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    for _, v12 in pairs(t1.container) do
        v12.Parent = PlayerGui
    end

    require(_script.Attribute)
end)

function t1.new() -- line: 180
    -- upvalues: UserInputService (copy), StarterGui (copy), _script (copy), GoodSignal (copy), Janitor (copy), Utility (copy), t1 (copy), t2 (copy), v3 (copy), Elements (copy), n1 (ref), t3 (copy)
    local t4 = {}

    setmetatable(t4, t1)

    local v13 = Janitor.new()

    t4.janitor = v13
    t4.themesJanitor = v13:add(Janitor.new())
    t4.singleClickJanitor = v13:add(Janitor.new())
    t4.captionJanitor = v13:add(Janitor.new())
    t4.joinJanitor = v13:add(Janitor.new())
    t4.menuJanitor = v13:add(Janitor.new())
    t4.dropdownJanitor = v13:add(Janitor.new())

    local v14 = Utility.generateUID()

    t2[v14] = t4
    v13:add(function() -- line: 197
        -- upvalues: v14 (copy), t2 (copy)
        t2[v14] = nil
    end)
    t4.selected = v13:add(GoodSignal.new())
    t4.deselected = v13:add(GoodSignal.new())
    t4.toggled = v13:add(GoodSignal.new())
    t4.viewingStarted = v13:add(GoodSignal.new())
    t4.viewingEnded = v13:add(GoodSignal.new())
    t4.stateChanged = v13:add(GoodSignal.new())
    t4.notified = v13:add(GoodSignal.new())
    t4.noticeStarted = v13:add(GoodSignal.new())
    t4.noticeChanged = v13:add(GoodSignal.new())
    t4.endNotices = v13:add(GoodSignal.new())
    t4.toggleKeyAdded = v13:add(GoodSignal.new())
    t4.fakeToggleKeyChanged = v13:add(GoodSignal.new())
    t4.alignmentChanged = v13:add(GoodSignal.new())
    t4.updateSize = v13:add(GoodSignal.new())
    t4.resizingComplete = v13:add(GoodSignal.new())
    t4.joinedParent = v13:add(GoodSignal.new())
    t4.menuSet = v13:add(GoodSignal.new())
    t4.dropdownSet = v13:add(GoodSignal.new())
    t4.updateMenu = v13:add(GoodSignal.new())
    t4.startMenuUpdate = v13:add(GoodSignal.new())
    t4.childThemeModified = v13:add(GoodSignal.new())
    t4.indicatorSet = v13:add(GoodSignal.new())
    t4.dropdownChildAdded = v13:add(GoodSignal.new())
    t4.menuChildAdded = v13:add(GoodSignal.new())
    t4.iconModule = _script
    t4.UID = v14
    t4.isEnabled = true
    t4.enabled = t4.isEnabled
    t4.isSelected = false
    t4.isViewing = false
    t4.joinedFrame = false
    t4.parentIconUID = false
    t4.deselectWhenOtherIconSelected = true
    t4.totalNotices = 0
    t4.activeState = "Deselected"
    t4.alignment = ""
    t4.originalAlignment = ""
    t4.appliedTheme = {}
    t4.appearance = {}
    t4.cachedInstances = {}
    t4.cachedNamesToInstances = {}
    t4.cachedCollectives = {}
    t4.bindedToggleKeys = {}
    t4.customBehaviours = {}
    t4.toggleItems = {}
    t4.bindedEvents = {}
    t4.notices = {}
    t4.menuIcons = {}
    t4.dropdownIcons = {}
    t4.childIconsDict = {}
    t4.creationTime = os.clock()
    t4.widget = v13:add(require(Elements.Widget)(t4, t1))
    t4:setAlignment()
    n1 += 1

    local v15 = n1 * 0.01 + 1

    t4:setOrder(v15, "deselected")
    t4:setOrder(v15, "selected")
    t4:setTheme(t1.baseTheme)

    local ClickRegion = t4:getInstance("ClickRegion")
    local v16 = false
    local n2 = 0

    local function handleToggle() -- line: 277
        -- upvalues: t4 (copy), n2 (ref)
        if not t4.locked then
            local v17 = tick()

            if not (v17 - n2 < 0.1) then
                n2 = v17

                if t4.isSelected then
                    t4:deselect("User", t4)
                else
                    t4:select("User", t4)
                end
            end
        end
    end

    ClickRegion.MouseButton1Click:Connect(function() -- line: 296
        -- upvalues: t4 (copy), v16 (ref), n2 (ref)
        v16 = true

        if not t4.locked then
            local v18 = tick()

            if not (v18 - n2 < 0.1) then
                n2 = v18

                if t4.isSelected then
                    t4:deselect("User", t4)
                else
                    t4:select("User", t4)
                end
            end
        end
    end)
    ClickRegion.TouchTap:Connect(function() -- line: 301
        -- upvalues: t4 (copy), v16 (ref), n2 (ref)
        if v16 or t4.locked then
            return
        end

        local v19 = tick()

        if v19 - n2 < 0.1 then
            return
        end

        n2 = v19

        if t4.isSelected then
            t4:deselect("User", t4)
        else
            t4:select("User", t4)
        end
    end)
    v13:add(UserInputService.InputBegan:Connect(function(p7, p8) -- line: 314
        -- upvalues: t4 (copy), n2 (ref)
        if t4.locked or not t4.bindedToggleKeys[p7.KeyCode] or p8 or t4.locked then
            return
        end

        local v20 = tick()

        if v20 - n2 < 0.1 then
            return
        end

        n2 = v20

        if t4.isSelected then
            t4:deselect("User", t4)
        else
            t4:select("User", t4)
        end
    end))

    local function viewingStarted(p9) -- line: 326
        -- upvalues: t4 (copy)
        if t4.locked then
            return
        end

        t4.isViewing = true
        t4.viewingStarted:Fire(true)

        if not p9 then
            t4:setState("Viewing", "User", t4)
        end
    end

    local function viewingEnded() -- line: 336
        -- upvalues: t4 (copy)
        if t4.locked then
            return
        end

        t4.isViewing = false
        t4.viewingEnded:Fire(true)
        t4:setState(nil, "User", t4)
    end

    t4.joinedParent:Connect(function() -- line: 344
        -- upvalues: t4 (copy)
        if t4.isViewing then
            if t4.locked then
                return
            end

            t4.isViewing = false
            t4.viewingEnded:Fire(true)
            t4:setState(nil, "User", t4)
        end
    end)
    ClickRegion.MouseEnter:Connect(function() -- line: 349
        -- upvalues: t4 (copy), UserInputService (copy), t3 (copy)
        local v21 = UserInputService.PreferredInput ~= t3.desktop

        if t4.locked then
            return
        end

        t4.isViewing = true
        t4.viewingStarted:Fire(true)

        if not v21 then
            t4:setState("Viewing", "User", t4)
        end
    end)

    local n3 = 0

    v13:add(UserInputService.TouchEnded:Connect(viewingEnded))
    ClickRegion.MouseLeave:Connect(viewingEnded)
    ClickRegion.SelectionGained:Connect(viewingStarted)
    ClickRegion.SelectionLost:Connect(viewingEnded)
    ClickRegion.MouseButton1Down:Connect(function() -- line: 358
        -- upvalues: t4 (copy), n3 (ref), UserInputService (copy), t3 (copy)
        if t4.locked or UserInputService.PreferredInput ~= t3.mobile then
            return
        end

        n3 += 1

        local v22 = n3

        task.delay(0.2, function() -- line: 362
            -- upvalues: v22 (copy), t4 (copy), n3 (ref)
            if v22 ~= n3 or t4.locked then
                return
            end

            t4.isViewing = true
            t4.viewingStarted:Fire(true)
            t4:setState("Viewing", "User", t4)
        end)
    end)
    ClickRegion.MouseButton1Up:Connect(function() -- line: 369
        -- upvalues: n3 (ref)
        n3 += 1
    end)

    local IconOverlay = t4:getInstance("IconOverlay")

    t4.viewingStarted:Connect(function() -- line: 375
        -- upvalues: t4 (copy), IconOverlay (copy)
        IconOverlay.Visible = not t4.overlayDisabled
    end)
    t4.viewingEnded:Connect(function() -- line: 378
        -- upvalues: IconOverlay (copy)
        IconOverlay.Visible = false
    end)
    v13:add(v3:Connect(function(p10) -- line: 383
        -- upvalues: t4 (copy)
        if p10 ~= t4 and t4.deselectWhenOtherIconSelected and p10.deselectWhenOtherIconSelected then
            t4:deselect("AutoDeselect", p10)
        end
    end))

    local s = debug.info(2, "s")
    local v23 = string.split(s, ".")
    local _game = game
    local v24 = _game
    local v25

    for _, v26 in pairs(v23) do
        v24 = v24:FindFirstChild(v26)

        if not v24 then
            _game = v24
            break
        end

        _game = v24

        if v24:IsA("ScreenGui") then
            v25 = v24
        end
    end

    if _game and v25 and v25.ResetOnSpawn == true then
        t4.originsScreenGui = v25
        Utility.localPlayerRespawned(function() -- line: 409
            -- upvalues: t4 (copy)
            t4:destroy()
        end)
    end

    t4.toggled:Connect(function(p11) -- line: 415
        -- upvalues: t4 (copy), t1 (copy)
        t4.noticeChanged:Fire(t4.totalNotices)

        for v27, _ in pairs(t4.childIconsDict) do
            local v28 = t1.getIconByUID(v27)

            v28.noticeChanged:Fire(v28.totalNotices)

            if not p11 and v28.isSelected then
                for _, _ in pairs(v28.childIconsDict) do
                    v28:deselect("HideParentFeature", t4)
                end
            end
        end
    end)
    t4.selected:Connect(function() -- line: 438
        -- upvalues: t4 (copy), StarterGui (copy)
        if #t4.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and t4.alignment ~= "Right" then
                t4.chatWasPreviouslyActive = true
                StarterGui:SetCore("ChatActive", false)
            end

            if StarterGui:GetCoreGuiEnabled("PlayerList") and t4.alignment ~= "Left" then
                t4.playerlistWasPreviouslyActive = true
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
            end
        end
    end)
    t4.deselected:Connect(function() -- line: 451
        -- upvalues: t4 (copy), StarterGui (copy)
        if t4.chatWasPreviouslyActive then
            t4.chatWasPreviouslyActive = nil
            StarterGui:SetCore("ChatActive", true)
        end

        if t4.playerlistWasPreviouslyActive then
            t4.playerlistWasPreviouslyActive = nil
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end
    end)
    task.delay(0.1, function() -- line: 465
        -- upvalues: t4 (copy)
        if t4.activeState == "Deselected" then
            t4.stateChanged:Fire("Deselected")
            t4:refresh()
        end
    end)
    t1.iconAdded:Fire(t4)

    return t4
end

function t1.setName(p12, p13) -- line: 481
    p12.widget.Name = p13
    p12.name = p13

    return p12
end

function t1.setState(p14, p15, p16, p17) -- line: 487
    -- upvalues: Utility (copy), v3 (copy)
    p15 = p15 or (if p14.isSelected then "Selected" else "Deselected")

    local v30 = Utility.formatStateName(p15)

    if p14.activeState == v30 then
        return
    end

    local isSelected = p14.isSelected

    p14.activeState = v30

    if v30 == "Deselected" then
        p14.isSelected = false

        if isSelected then
            p14.toggled:Fire(false, p16, p17)
            p14.deselected:Fire(p16, p17)
        end

        p14:_setToggleItemsVisible(false, p16, p17)
    elseif v30 == "Selected" then
        p14.isSelected = true

        if not isSelected then
            p14.toggled:Fire(true, p16, p17)
            p14.selected:Fire(p16, p17)
            v3:Fire(p14, p16, p17)
        end

        p14:_setToggleItemsVisible(true, p16, p17)
    end

    p14.stateChanged:Fire(v30, p16, p17)
end

function t1.getInstance(p18, p19) -- line: 520
    -- upvalues: Themes (copy)
    local v31 = p18.cachedNamesToInstances[p19]

    if v31 then
        return v31
    end

    local function cacheInstance(p20, p21) -- line: 528
        -- upvalues: p18 (copy)
        if p18.cachedInstances[p21] then
            return
        end

        local Collective = p21:GetAttribute("Collective")
        local v32 = Collective and p18.cachedCollectives[Collective]

        if v32 then
            table.insert(v32, p21)
        end

        p18.cachedNamesToInstances[p20] = p21
        p18.cachedInstances[p21] = true
        p21.Destroying:Once(function() -- line: 538
            -- upvalues: p20 (copy), p21 (copy), p18 (copy)
            p18.cachedNamesToInstances[p20] = nil
            p18.cachedInstances[p21] = nil
        end)
    end

    local widget = p18.widget

    cacheInstance("Widget", widget)

    if p19 == "Widget" then
        return widget
    end

    local v33, scanChildren

    local function scanChildren2(p22) -- line: 551
        -- upvalues: p18 (copy), p19 (copy), cacheInstance (copy), v33 (ref), scanChildren (ref), Themes (copy)
        for _, child in pairs(p22:GetChildren()) do
            local WidgetUID = child:GetAttribute("WidgetUID")

            if not WidgetUID or WidgetUID == p18.UID then
                local v35 = Themes.getRealInstance(child) or child
                local scanChildren2 = scanChildren

                scanChildren2(v35)

                if v35:IsA("GuiBase") or v35:IsA("UIBase") or v35:IsA("ValueBase") then
                    local Name = v35.Name

                    cacheInstance(Name, v35)

                    if Name == p19 then
                        v33 = v35
                    end
                end
            end
        end
    end

    scanChildren = scanChildren2
    scanChildren2(widget)

    return v33
end

function t1.getCollective(p23, p24) -- line: 580
    local v36 = p23.cachedCollectives[p24]

    if v36 then
        return v36
    end

    local t5 = {}

    for v37, _ in pairs(p23.cachedInstances) do
        if v37:GetAttribute("Collective") == p24 then
            table.insert(t5, v37)
        end
    end

    p23.cachedCollectives[p24] = t5

    return t5
end

function t1.getInstanceOrCollective(p25, p26) -- line: 601
    local v38 = {}
    local v39 = p25:getInstance(p26)

    if v39 then
        table.insert(v38, v39)
    end

    if #v38 == 0 then
        v38 = p25:getCollective(p26)
    end

    return v38
end

function t1.getStateGroup(p27, p28) -- line: 615
    p28 = p28 or p27.activeState

    local v41 = p27.appearance[p28]

    if not v41 then
        v41 = {}
        p27.appearance[p28] = v41
    end

    return v41
end

function t1.refreshAppearance(p29, p30, p31) -- line: 625
    -- upvalues: Themes (copy)
    Themes.refresh(p29, p30, p31)

    return p29
end

function t1.refresh(p32) -- line: 630
    p32:refreshAppearance(p32.widget)
    p32.updateSize:Fire()

    return p32
end

function t1.updateParent(p33) -- line: 636
    -- upvalues: t1 (copy)
    local v42 = t1.getIconByUID(p33.parentIconUID)

    if v42 then
        v42.updateSize:Fire()
    end
end

function t1.setBehaviour(p34, p35, p36, p37, p38) -- line: 643
    local v43 = p35 .. "-" .. p36

    p34.customBehaviours[v43] = p37

    if p38 then
        local v44 = p34:getInstanceOrCollective(p35)

        for _, v45 in pairs(v44) do
            p34:refreshAppearance(v45, p36)
        end
    end
end

function t1.modifyTheme(p39, p40, p41) -- line: 656
    -- upvalues: Themes (copy)
    return p39, (Themes.modify(p39, p40, p41))
end

function t1.modifyChildTheme(p42, p43, p44) -- line: 661
    -- upvalues: t1 (copy)
    p42.childModifications = p43
    p42.childModificationsUID = p44

    for v46, _ in pairs(p42.childIconsDict) do
        t1.getIconByUID(v46):modifyTheme(p43, p44)
    end

    p42.childThemeModified:Fire()

    return p42
end

function t1.removeModification(p45, p46) -- line: 674
    -- upvalues: Themes (copy)
    Themes.remove(p45, p46)

    return p45
end

function t1.removeModificationWith(p47, p48, p49, p50) -- line: 679
    -- upvalues: Themes (copy)
    Themes.removeWith(p47, p48, p49, p50)

    return p47
end

function t1.setTheme(p51, p52) -- line: 684
    -- upvalues: Themes (copy)
    Themes.set(p51, p52)

    return p51
end

function t1.setEnabled(p53, p54) -- line: 689
    p53.isEnabled = p54
    p53.enabled = p53.isEnabled
    p53.widget.Visible = p54
    p53:updateParent()

    return p53
end

function t1.select(p55, p56, p57) -- line: 697
    p55:setState("Selected", p56, p57)

    return p55
end

function t1.deselect(p58, p59, p60) -- line: 702
    p58:setState("Deselected", p59, p60)

    return p58
end

function t1.notify(p61, p62, p63) -- line: 707
    -- upvalues: t1 (copy), Elements (copy)
    if not p61.notice then
        p61.notice = require(Elements.Notice)(p61, t1)
    end

    p61.noticeStarted:Fire(p62, p63)

    return p61
end

function t1.clearNotices(p64) -- line: 721
    p64.endNotices:Fire()

    return p64
end

function t1.disableOverlay(p65, p66) -- line: 726
    p65.overlayDisabled = p66

    return p65
end

t1.disableStateOverlay = t1.disableOverlay

function t1.setImage(p67, p68, p69) -- line: 732
    -- upvalues: ContentProvider (copy)
    p67:modifyTheme({
        "IconImage",
        "Image",
        p68,
        p69
    })
    task.spawn(function() -- line: 736
        -- upvalues: p68 (copy), ContentProvider (copy)
        local v47 = if tonumber(p68) then ("rbxassetid://%*"):format(p68) else p68

        if ContentProvider:GetAssetFetchStatus(v47) == Enum.AssetFetchStatus.Success then
            return
        end

        local PreloadAsync = ContentProvider.PreloadAsync
        local t6 = {
            v47
        }

        pcall(PreloadAsync, ContentProvider, t6)
    end)

    return p67
end

function t1.setLabel(p70, p71, p72) -- line: 748
    p70:modifyTheme({
        "IconLabel",
        "Text",
        p71,
        p72
    })

    return p70
end

function t1.setOrder(p73, p74, p75) -- line: 753
    local v48 = p74 * 100

    p73:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v48,
        p75
    })
    p73:modifyTheme({
        "Widget",
        "LayoutOrder",
        v48,
        p75
    })

    return p73
end

function t1.setCornerRadius(p76, p77, p78) -- line: 762
    p76:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p77,
        p78
    })

    return p76
end

function t1.align(p79, p80, p81) -- line: 767
    -- upvalues: t1 (copy)
    local v49 = tostring(p80):lower()

    if v49 == "mid" or v49 == "centre" then
        v49 = "center"
    end

    if v49 ~= "left" and v49 ~= "center" and v49 ~= "right" then
        v49 = "left"
    end

    local TopbarCentered = v49 == "center" and t1.container.TopbarCentered or t1.container.TopbarStandard
    local Holders = TopbarCentered.Holders
    local v50 = string.upper((string.sub(v49, 1, 1))) .. string.sub(v49, 2)

    if not p81 then
        p79.originalAlignment = v50
    end

    local joinedFrame = p79.joinedFrame
    local v51 = Holders[v50]

    p79.screenGui = TopbarCentered
    p79.alignmentHolder = v51

    if not p79.isDestroyed then
        p79.widget.Parent = joinedFrame or v51
    end

    p79.alignment = v50
    p79.alignmentChanged:Fire(v50)
    t1.iconChanged:Fire(p79)

    return p79
end

t1.setAlignment = t1.align

function t1.setLeft(p82) -- line: 796
    p82:setAlignment("Left")

    return p82
end

function t1.setMid(p83) -- line: 801
    p83:setAlignment("Center")

    return p83
end

function t1.setRight(p84) -- line: 806
    p84:setAlignment("Right")

    return p84
end

function t1.setWidth(p85, p86, p87) -- line: 811
    p85:modifyTheme({
        "Widget",
        "DesiredWidth",
        p86,
        p87
    })

    return p85
end

function t1.setImageScale(p88, p89, p90) -- line: 819
    p88:modifyTheme({
        "IconImageScale",
        "Value",
        p89,
        p90
    })

    return p88
end

function t1.setImageRatio(p91, p92, p93) -- line: 824
    p91:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p92,
        p93
    })

    return p91
end

function t1.setTextSize(p94, p95, p96) -- line: 829
    p94:modifyTheme({
        "IconLabel",
        "TextSize",
        p95,
        p96
    })

    return p94
end

function t1.setTextFont(p97, p98, p99, p100, p101) -- line: 834
    p99 = p99 or Enum.FontWeight.Regular
    p100 = p100 or Enum.FontStyle.Normal

    local v54 = typeof(p98)
    local v55 = if v54 == "number" then Font.fromId(p98, p99, p100)
        elseif v54 == "EnumItem" then Font.fromEnum(p98)
        elseif v54 == "string" and not p98:match("rbxasset") then Font.fromName(p98, p99, p100)
        else nil

    p97:modifyTheme({
        "IconLabel",
        "FontFace",
        v55 or Font.new(p98, p99, p100),
        p101
    })

    return p97
end

function t1.setTextColor(p102, p103, p104) -- line: 855
    local v56, v57

    if p103 == nil or p103 == "" then
        v57 = false
    elseif type(p103) == "userdata" and typeof(p103) == "Color3" then
        v56 = p103
        v57 = true
    else
        v57 = false
    end

    if not v57 then
        if p103 ~= nil and p103 ~= "" then
            warn("setTextColor item must be a Color3 value! Changed the color to white.")
        end

        v56 = Color3.fromRGB(255, 255, 255)
    end

    p102:modifyTheme({
        "IconLabel",
        "TextColor3",
        v56,
        p104
    })

    return p102
end

function t1.bindToggleItem(p105, p106) -- line: 867
    if not p106:IsA("GuiObject") and not p106:IsA("LayerCollector") then
        error("Toggle item must be a GuiObject or LayerCollector!")
    end

    p105.toggleItems[p106] = true
    p105:_updateSelectionInstances()

    return p105
end

function t1.unbindToggleItem(p107, p108) -- line: 876
    p107.toggleItems[p108] = nil
    p107:_updateSelectionInstances()

    return p107
end

function t1._updateSelectionInstances(p109) -- line: 882
    for v58, _ in pairs(p109.toggleItems) do
        local t7 = {}

        for _, descendant in pairs(v58:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(t7, descendant)
            end
        end

        p109.toggleItems[v58] = t7
    end
end

function t1._setToggleItemsVisible(p110, p111, _, p113) -- line: 896
    for v59, _ in pairs(p110.toggleItems) do
        if not p113 or p113 == p110 or p113.toggleItems[v59] == nil then
            v59[v59:IsA("LayerCollector") and "Enabled" or "Visible"] = p111
        end
    end
end

function t1.bindEvent(p114, p115, p116) -- line: 908
    local v60 = p114[p115]

    assert(v60 and typeof(v60) == "table" and v60.Connect, "argument[1] must be a valid topbarplus icon event name!")
    assert(typeof(p116) == "function", "argument[2] must be a function!")
    p114.bindedEvents[p115] = v60:Connect(function(...) -- line: 912
        -- upvalues: p114 (copy), p116 (copy)
        p116(p114, ...)
    end)

    return p114
end

function t1.unbindEvent(p117, p118) -- line: 918
    local v63 = p117.bindedEvents[p118]

    if v63 then
        v63:Disconnect()
        p117.bindedEvents[p118] = nil
    end

    return p117
end

function t1.bindToggleKey(p119, p120) -- line: 927
    assert(typeof(p120) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p119.bindedToggleKeys[p120] = true
    p119.toggleKeyAdded:Fire(p120)
    p119:setCaption("_hotkey_")

    return p119
end

function t1.unbindToggleKey(p121, p122) -- line: 935
    assert(typeof(p122) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p121.bindedToggleKeys[p122] = nil

    return p121
end

function t1.call(p123, p124, ...) -- line: 941
    local v66 = table.pack(...)

    task.spawn(function() -- line: 943
        -- upvalues: p123 (copy), p124 (copy), v66 (copy)
        p124(p123, table.unpack(v66))
    end)

    return p123
end

function t1.addToJanitor(p125, p126, p127, p128) -- line: 949
    p125.janitor:add(p126, p127, p128)

    return p125
end

function t1.lock(p129) -- line: 954
    p129:getInstance("ClickRegion").Visible = false
    p129.locked = true

    return p129
end

function t1.unlock(p130) -- line: 962
    p130:getInstance("ClickRegion").Visible = true
    p130.locked = false

    return p130
end

function t1.debounce(p131, p132) -- line: 969
    p131:lock()
    task.wait(p132)
    p131:unlock()

    return p131
end

function t1.autoDeselect(p133, p134) -- line: 976
    if p134 ~= nil then
        p133.deselectWhenOtherIconSelected = p134
    else
        p133.deselectWhenOtherIconSelected = true
    end

    return p133
end

function t1.oneClick(p135, p136) -- line: 986
    local singleClickJanitor = p135.singleClickJanitor

    singleClickJanitor:clean()

    if p136 or p136 == nil then
        singleClickJanitor:add(p135.selected:Connect(function() -- line: 992
            -- upvalues: p135 (copy)
            p135:deselect("OneClick", p135)
        end))
    end

    p135.oneClickEnabled = true

    return p135
end

function t1.setCaption(p137, p138) -- line: 1000
    -- upvalues: Elements (copy)
    if p138 == "_hotkey_" and p137.captionText then
        return p137
    end

    local captionJanitor = p137.captionJanitor

    p137.captionJanitor:clean()

    local v67 = if p138 then p138 == "" else nil

    if not p138 or v67 then
        p137.caption = nil
        p137.captionText = nil
    else
        local v68 = captionJanitor:add(require(Elements.Caption)(p137))

        v68:SetAttribute("CaptionText", p138)
        p137.caption = v68
        p137.captionText = p138
    end

    return p137
end

function t1.setCaptionHint(p139, p140) -- line: 1018
    assert(typeof(p140) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p139.fakeToggleKey = p140
    p139.fakeToggleKeyChanged:Fire(p140)
    p139:setCaption("_hotkey_")

    return p139
end

function t1.leave(p141) -- line: 1026
    p141.joinJanitor:clean()

    return p141
end

function t1.joinMenu(p142, p143) -- line: 1032
    -- upvalues: Utility (copy)
    Utility.joinFeature(p142, p143, p143.menuIcons, p143:getInstance("Menu"))
    p143.menuChildAdded:Fire(p142)

    return p142
end

function t1.setMenu(p144, p145) -- line: 1038
    p144.menuSet:Fire(p145)

    return p144
end

function t1.setFixedMenu(p146, p147) -- line: 1043
    p146:freezeMenu(p147)
    p146:setMenu(p147)
end

t1.setFrozenMenu = t1.setFixedMenu

function t1.freezeMenu(p148) -- line: 1049
    p148:select("FrozenMenu", p148)
    p148:bindEvent("deselected", function(p149) -- line: 1053
        -- upvalues: p148 (copy)
        p149:select("FrozenMenu", p148)
    end)
    p148:modifyTheme({
        "IconSpot",
        "Visible",
        false
    })
end

function t1.joinDropdown(p150, p151) -- line: 1059
    -- upvalues: Utility (copy)
    p151:getDropdown()
    Utility.joinFeature(p150, p151, p151.dropdownIcons, p151:getInstance("DropdownScroller"))
    p151.dropdownChildAdded:Fire(p150)

    return p150
end

function t1.getDropdown(p152) -- line: 1066
    -- upvalues: Elements (copy)
    local dropdown = p152.dropdown

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p152)
        p152.dropdown = dropdown
        p152:clipOutside(dropdown)
    end

    return dropdown
end

function t1.setDropdown(p153, p154) -- line: 1076
    p153:getDropdown()
    p153.dropdownSet:Fire(p154)

    return p153
end

function t1.clipOutside(p155, p156) -- line: 1082
    -- upvalues: Utility (copy)
    local v70 = Utility.clipOutside(p155, p156)

    p155:refreshAppearance(p156)

    return p155, v70
end

function t1.setIndicator(p157, p158) -- line: 1093
    -- upvalues: t1 (copy), Elements (copy)
    if not p157.indicator then
        p157.indicator = p157.janitor:add(require(Elements.Indicator)(p157, t1))
    end

    p157.indicatorSet:Fire(p158)
end

function t1.convertLabelToNumberSpinner(p159, p160, p161) -- line: 1105
    task.defer(function() -- line: 1106
        -- upvalues: p159 (copy), p160 (copy), p161 (copy)
        local IconLabel = p159:getInstance("IconLabel")

        IconLabel.Transparency = 1
        p160.Parent = IconLabel.Parent
        p160.Size = UDim2.fromScale(1, 1)
        p160.AnchorPoint = Vector2.new(0.5, 0.5)
        p160.Position = UDim2.new(0.5, 0, 0.5, 0)
        p160.TextXAlignment = Enum.TextXAlignment.Center
        p160.ClipsDescendants = false

        local t8 = {
            "FontFace",
            "BorderSizePixel",
            "BorderColor3",
            "Rotation",
            "TextStrokeTransparency",
            "TextStrokeColor3",
            "TextStrokeTransparency",
            "TextColor3"
        }

        for _, v71 in ipairs(t8) do
            p160[v71] = IconLabel[v71]
            p159:addToJanitor(IconLabel:GetPropertyChangedSignal(v71):Connect(function() -- line: 1129
                -- upvalues: IconLabel (copy), v71 (copy), p160 (copy)
                p160[v71] = IconLabel[v71]
            end))
        end

        local function getSpinnerSizeAndDigitCount() -- line: 1136
            -- upvalues: p160 (copy)
            local n4 = 0
            local n5 = 0

            for _, child in p160.Frame:GetChildren() do
                local v72 = string.lower(child.Name)

                if v72 == "digit" or (v72 == "prefix" or v72 == "suffix" or v72 == "comma") and child.Text ~= "" then
                    n4 += child.AbsoluteSize.X
                    n5 += 1
                end
            end

            return n4, n5
        end

        local function getLabelParentContainerXSize() -- line: 1154
            -- upvalues: IconLabel (copy), p160 (copy)
            local IconLabelParent = IconLabel.Parent
            local v73 = IconLabelParent and IconLabelParent.Parent

            if v73 == nil then
                return 0
            end

            if v73.IconImage.Visible == true then
                return p160.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
            end

            return v73.AbsoluteSize.X
        end

        local function getNumberSpinnerXSize() -- line: 1166
            -- upvalues: p160 (copy)
            return p160.Frame.AbsoluteSize.X
        end

        local function adjustSize() -- line: 1170
            -- upvalues: IconLabel (copy), getSpinnerSizeAndDigitCount (copy), p159 (copy), p160 (copy)
            local v74, v75 = getSpinnerSizeAndDigitCount()

            if v75 < 18 then
                p159:setLabel(p160.Value)
            end

            local X = p160.Frame.AbsoluteSize.X

            while v74 < X do
                if p159.isDestroyed ~= true then
                    task.wait(0.05)

                    if not (v75 > 0 and v75 < 8) then
                        p160.TextSize += 1
                        X = p160.Frame.AbsoluteSize.X
                        v74, v75 = getSpinnerSizeAndDigitCount()
                        continue
                    end

                    p160.TextSize = IconLabel.TextSize
                end

                break
            end

            local IconLabelParent = IconLabel.Parent
            local v76 = IconLabelParent and IconLabelParent.Parent
            local v77 = if v76 == nil then 0 elseif v76.IconImage.Visible == true then p160.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else v76.AbsoluteSize.X

            while true do
                if v77 < v74 then
                    if p159.isDestroyed == true then
                        return
                    end

                    task.wait(0.05)

                    if v75 < 8 and v75 > 0 then
                        break
                    end

                    p160.TextSize -= 1

                    local IconLabelParent = IconLabel.Parent

                    IconLabelParent = IconLabelParent and IconLabelParent.Parent
                    v77 = if IconLabelParent == nil then 0 elseif IconLabelParent.IconImage.Visible == true then p160.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else IconLabelParent.AbsoluteSize.X
                    v74, v75 = getSpinnerSizeAndDigitCount()
                    continue
                end

                return
            end

            p160.TextSize = IconLabel.TextSize
        end

        p159:addToJanitor(p160.Frame.ChildAdded:Connect(adjustSize))
        p159:addToJanitor(p160.Frame.ChildRemoved:Connect(adjustSize))
        p159:addToJanitor(p159.iconAdded:Connect(function() -- line: 1208
            -- upvalues: adjustSize (copy)
            task.wait(1)
            adjustSize()
        end))
        p159:updateParent()
        p160.Name = "LabelSpinner"
        p160.Prefix = "$"
        p160.Commas = true
        p160.Decimals = 0
        p160.Duration = 0.25
        p160.Value = 10
        task.wait(0.2)

        if typeof(p161) == "function" then
            p161()
        end
    end)

    return p159
end

function t1.destroy(p162) -- line: 1235
    -- upvalues: t1 (copy)
    if p162.isDestroyed then
        return
    end

    p162:clearNotices()

    if p162.parentIconUID then
        p162:leave()
    end

    p162.isDestroyed = true
    p162.janitor:clean()
    t1.iconRemoved:Fire(p162)
end

t1.Destroy = t1.destroy

return t1
