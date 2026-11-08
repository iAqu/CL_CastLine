-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
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

function t1.getIcons() -- line: 90
    -- upvalues: t1 (copy)
    return t1.iconsDictionary
end

function t1.getIconByUID(p1) -- line: 94
    -- upvalues: t1 (copy)
    return t1.iconsDictionary[p1] or nil
end

function t1.getIcon(p2) -- line: 102
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

function t1.setTopbarEnabled(p3, p4) -- line: 115
    -- upvalues: t1 (copy)
    local v6 = if typeof(p3) == "boolean" then p3 else t1.topbarEnabled

    if not p4 then
        t1.topbarEnabled = v6
    end

    for _, v7 in pairs(t1.container) do
        v7.Enabled = v6
    end
end

function t1.modifyBaseTheme(p5) -- line: 127
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

function t1.setDisplayOrder(p6) -- line: 139
    -- upvalues: t1 (copy)
    t1.baseDisplayOrder = p6
    t1.baseDisplayOrderChanged:Fire(p6)
end

task.defer(Gamepad.start, t1)
task.defer(Overflow.start, t1)
task.defer(function() -- line: 147
    -- upvalues: _script (copy), t1 (copy), LocalPlayer (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    for _, v12 in pairs(t1.container) do
        v12.Parent = PlayerGui
    end

    require(_script.Attribute)
end)

function t1.new() -- line: 156
    -- upvalues: UserInputService (copy), StarterGui (copy), _script (copy), GoodSignal (copy), Janitor (copy), Utility (copy), t1 (copy), t2 (copy), v3 (copy), Elements (copy), n1 (ref)
    local t3 = {}

    setmetatable(t3, t1)

    local v13 = Janitor.new()

    t3.janitor = v13
    t3.themesJanitor = v13:add(Janitor.new())
    t3.singleClickJanitor = v13:add(Janitor.new())
    t3.captionJanitor = v13:add(Janitor.new())
    t3.joinJanitor = v13:add(Janitor.new())
    t3.menuJanitor = v13:add(Janitor.new())
    t3.dropdownJanitor = v13:add(Janitor.new())

    local v14 = Utility.generateUID()

    t2[v14] = t3
    v13:add(function() -- line: 173
        -- upvalues: v14 (copy), t2 (copy)
        t2[v14] = nil
    end)
    t3.selected = v13:add(GoodSignal.new())
    t3.deselected = v13:add(GoodSignal.new())
    t3.toggled = v13:add(GoodSignal.new())
    t3.viewingStarted = v13:add(GoodSignal.new())
    t3.viewingEnded = v13:add(GoodSignal.new())
    t3.stateChanged = v13:add(GoodSignal.new())
    t3.notified = v13:add(GoodSignal.new())
    t3.noticeStarted = v13:add(GoodSignal.new())
    t3.noticeChanged = v13:add(GoodSignal.new())
    t3.endNotices = v13:add(GoodSignal.new())
    t3.toggleKeyAdded = v13:add(GoodSignal.new())
    t3.fakeToggleKeyChanged = v13:add(GoodSignal.new())
    t3.alignmentChanged = v13:add(GoodSignal.new())
    t3.updateSize = v13:add(GoodSignal.new())
    t3.resizingComplete = v13:add(GoodSignal.new())
    t3.joinedParent = v13:add(GoodSignal.new())
    t3.menuSet = v13:add(GoodSignal.new())
    t3.dropdownSet = v13:add(GoodSignal.new())
    t3.updateMenu = v13:add(GoodSignal.new())
    t3.startMenuUpdate = v13:add(GoodSignal.new())
    t3.childThemeModified = v13:add(GoodSignal.new())
    t3.indicatorSet = v13:add(GoodSignal.new())
    t3.dropdownChildAdded = v13:add(GoodSignal.new())
    t3.menuChildAdded = v13:add(GoodSignal.new())
    t3.iconModule = _script
    t3.UID = v14
    t3.isEnabled = true
    t3.enabled = t3.isEnabled
    t3.isSelected = false
    t3.isViewing = false
    t3.joinedFrame = false
    t3.parentIconUID = false
    t3.deselectWhenOtherIconSelected = true
    t3.totalNotices = 0
    t3.activeState = "Deselected"
    t3.alignment = ""
    t3.originalAlignment = ""
    t3.appliedTheme = {}
    t3.appearance = {}
    t3.cachedInstances = {}
    t3.cachedNamesToInstances = {}
    t3.cachedCollectives = {}
    t3.bindedToggleKeys = {}
    t3.customBehaviours = {}
    t3.toggleItems = {}
    t3.bindedEvents = {}
    t3.notices = {}
    t3.menuIcons = {}
    t3.dropdownIcons = {}
    t3.childIconsDict = {}
    t3.creationTime = os.clock()
    t3.widget = v13:add(require(Elements.Widget)(t3, t1))
    t3:setAlignment()
    n1 += 1

    local v15 = n1 * 0.01 + 1

    t3:setOrder(v15, "deselected")
    t3:setOrder(v15, "selected")
    t3:setTheme(t1.baseTheme)

    local ClickRegion = t3:getInstance("ClickRegion")

    local function handleToggle() -- line: 249
        -- upvalues: t3 (copy)
        if not t3.locked then
            if t3.isSelected then
                t3:deselect("User", t3)
            else
                t3:select("User", t3)
            end
        end
    end

    local v16 = false
    local v17 = false

    ClickRegion.MouseButton1Click:Connect(function() -- line: 261
        -- upvalues: t3 (copy), v16 (ref), v17 (ref)
        if v16 then
            return
        end

        v17 = true
        task.delay(0.01, function() -- line: 266
            -- upvalues: v17 (ref)
            v17 = false
        end)

        if not t3.locked then
            if t3.isSelected then
                t3:deselect("User", t3)
            else
                t3:select("User", t3)
            end
        end
    end)
    ClickRegion.TouchTap:Connect(function() -- line: 271
        -- upvalues: t3 (copy), v16 (ref), v17 (ref)
        if v17 then
            return
        end

        v16 = true
        task.delay(0.01, function() -- line: 278
            -- upvalues: v16 (ref)
            v16 = false
        end)

        if not t3.locked then
            if t3.isSelected then
                t3:deselect("User", t3)
            else
                t3:select("User", t3)
            end
        end
    end)
    v13:add(UserInputService.InputBegan:Connect(function(p7, p8) -- line: 285
        -- upvalues: t3 (copy)
        if t3.locked or not t3.bindedToggleKeys[p7.KeyCode] or p8 or t3.locked then
            return
        end

        if t3.isSelected then
            t3:deselect("User", t3)
        else
            t3:select("User", t3)
        end
    end))

    local function viewingStarted(p9) -- line: 297
        -- upvalues: t3 (copy)
        if t3.locked then
            return
        end

        t3.isViewing = true
        t3.viewingStarted:Fire(true)

        if not p9 then
            t3:setState("Viewing", "User", t3)
        end
    end

    local function viewingEnded() -- line: 307
        -- upvalues: t3 (copy)
        if t3.locked then
            return
        end

        t3.isViewing = false
        t3.viewingEnded:Fire(true)
        t3:setState(nil, "User", t3)
    end

    t3.joinedParent:Connect(function() -- line: 315
        -- upvalues: t3 (copy)
        if t3.isViewing then
            if t3.locked then
                return
            end

            t3.isViewing = false
            t3.viewingEnded:Fire(true)
            t3:setState(nil, "User", t3)
        end
    end)
    ClickRegion.MouseEnter:Connect(function() -- line: 320
        -- upvalues: t3 (copy), UserInputService (copy)
        local v18 = not UserInputService.KeyboardEnabled

        if t3.locked then
            return
        end

        t3.isViewing = true
        t3.viewingStarted:Fire(true)

        if not v18 then
            t3:setState("Viewing", "User", t3)
        end
    end)

    local n2 = 0

    v13:add(UserInputService.TouchEnded:Connect(viewingEnded))
    ClickRegion.MouseLeave:Connect(viewingEnded)
    ClickRegion.SelectionGained:Connect(viewingStarted)
    ClickRegion.SelectionLost:Connect(viewingEnded)
    ClickRegion.MouseButton1Down:Connect(function() -- line: 329
        -- upvalues: t3 (copy), n2 (ref), UserInputService (copy)
        if t3.locked or not UserInputService.TouchEnabled then
            return
        end

        n2 += 1

        local v19 = n2

        task.delay(0.2, function() -- line: 333
            -- upvalues: v19 (copy), t3 (copy), n2 (ref)
            if v19 ~= n2 or t3.locked then
                return
            end

            t3.isViewing = true
            t3.viewingStarted:Fire(true)
            t3:setState("Viewing", "User", t3)
        end)
    end)
    ClickRegion.MouseButton1Up:Connect(function() -- line: 340
        -- upvalues: n2 (ref)
        n2 += 1
    end)

    local IconOverlay = t3:getInstance("IconOverlay")

    t3.viewingStarted:Connect(function() -- line: 346
        -- upvalues: t3 (copy), IconOverlay (copy)
        IconOverlay.Visible = not t3.overlayDisabled
    end)
    t3.viewingEnded:Connect(function() -- line: 349
        -- upvalues: IconOverlay (copy)
        IconOverlay.Visible = false
    end)
    v13:add(v3:Connect(function(p10) -- line: 354
        -- upvalues: t3 (copy)
        if p10 ~= t3 and t3.deselectWhenOtherIconSelected and p10.deselectWhenOtherIconSelected then
            t3:deselect("AutoDeselect", p10)
        end
    end))

    local s = debug.info(2, "s")
    local v20 = string.split(s, ".")
    local _game = game
    local v21 = _game
    local v22

    for _, v23 in pairs(v20) do
        v21 = v21:FindFirstChild(v23)

        if not v21 then
            _game = v21
            break
        end

        _game = v21

        if v21:IsA("ScreenGui") then
            v22 = v21
        end
    end

    if _game and v22 and v22.ResetOnSpawn == true then
        Utility.localPlayerRespawned(function() -- line: 383
            -- upvalues: t3 (copy)
            t3:destroy()
        end)
    end

    t3.toggled:Connect(function(p11) -- line: 389
        -- upvalues: t3 (copy), t1 (copy)
        t3.noticeChanged:Fire(t3.totalNotices)

        for v24, _ in pairs(t3.childIconsDict) do
            local v25 = t1.getIconByUID(v24)

            v25.noticeChanged:Fire(v25.totalNotices)

            if not p11 and v25.isSelected then
                for _, _ in pairs(v25.childIconsDict) do
                    v25:deselect("HideParentFeature", t3)
                end
            end
        end
    end)
    t3.selected:Connect(function() -- line: 412
        -- upvalues: t3 (copy), StarterGui (copy)
        if #t3.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and t3.alignment ~= "Right" then
                t3.chatWasPreviouslyActive = true
                StarterGui:SetCore("ChatActive", false)
            end

            if StarterGui:GetCoreGuiEnabled("PlayerList") and t3.alignment ~= "Left" then
                t3.playerlistWasPreviouslyActive = true
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
            end
        end
    end)
    t3.deselected:Connect(function() -- line: 425
        -- upvalues: t3 (copy), StarterGui (copy)
        if t3.chatWasPreviouslyActive then
            t3.chatWasPreviouslyActive = nil
            StarterGui:SetCore("ChatActive", true)
        end

        if t3.playerlistWasPreviouslyActive then
            t3.playerlistWasPreviouslyActive = nil
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end
    end)
    task.delay(0.1, function() -- line: 439
        -- upvalues: t3 (copy)
        if t3.activeState == "Deselected" then
            t3.stateChanged:Fire("Deselected")
            t3:refresh()
        end
    end)
    t1.iconAdded:Fire(t3)

    return t3
end

function t1.setName(p12, p13) -- line: 453
    p12.widget.Name = p13
    p12.name = p13

    return p12
end

function t1.setState(p14, p15, p16, p17) -- line: 459
    -- upvalues: Utility (copy), v3 (copy)
    p15 = p15 or (if p14.isSelected then "Selected" else "Deselected")

    local v27 = Utility.formatStateName(p15)

    if p14.activeState == v27 then
        return
    end

    local isSelected = p14.isSelected

    p14.activeState = v27

    if v27 == "Deselected" then
        p14.isSelected = false

        if isSelected then
            p14.toggled:Fire(false, p16, p17)
            p14.deselected:Fire(p16, p17)
        end

        p14:_setToggleItemsVisible(false, p16, p17)
    elseif v27 == "Selected" then
        p14.isSelected = true

        if not isSelected then
            p14.toggled:Fire(true, p16, p17)
            p14.selected:Fire(p16, p17)
            v3:Fire(p14, p16, p17)
        end

        p14:_setToggleItemsVisible(true, p16, p17)
    end

    p14.stateChanged:Fire(v27, p16, p17)
end

function t1.getInstance(p18, p19) -- line: 492
    -- upvalues: Themes (copy)
    local v28 = p18.cachedNamesToInstances[p19]

    if v28 then
        return v28
    end

    local function cacheInstance(p20, p21) -- line: 500
        -- upvalues: p18 (copy)
        if p18.cachedInstances[p21] then
            return
        end

        local Collective = p21:GetAttribute("Collective")
        local v29 = Collective and p18.cachedCollectives[Collective]

        if v29 then
            table.insert(v29, p21)
        end

        p18.cachedNamesToInstances[p20] = p21
        p18.cachedInstances[p21] = true
        p21.Destroying:Once(function() -- line: 510
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

    local v30, scanChildren

    local function scanChildren2(p22) -- line: 523
        -- upvalues: p18 (copy), p19 (copy), cacheInstance (copy), v30 (ref), scanChildren (ref), Themes (copy)
        for _, child in pairs(p22:GetChildren()) do
            local WidgetUID = child:GetAttribute("WidgetUID")

            if not WidgetUID or WidgetUID == p18.UID then
                local v32 = Themes.getRealInstance(child) or child
                local scanChildren2 = scanChildren

                scanChildren2(v32)

                if v32:IsA("GuiBase") or v32:IsA("UIBase") or v32:IsA("ValueBase") then
                    local Name = v32.Name

                    cacheInstance(Name, v32)

                    if Name == p19 then
                        v30 = v32
                    end
                end
            end
        end
    end

    scanChildren = scanChildren2
    scanChildren2(widget)

    return v30
end

function t1.getCollective(p23, p24) -- line: 552
    local v33 = p23.cachedCollectives[p24]

    if v33 then
        return v33
    end

    local t4 = {}

    for v34, _ in pairs(p23.cachedInstances) do
        if v34:GetAttribute("Collective") == p24 then
            table.insert(t4, v34)
        end
    end

    p23.cachedCollectives[p24] = t4

    return t4
end

function t1.getInstanceOrCollective(p25, p26) -- line: 573
    local v35 = {}
    local v36 = p25:getInstance(p26)

    if v36 then
        table.insert(v35, v36)
    end

    if #v35 == 0 then
        v35 = p25:getCollective(p26)
    end

    return v35
end

function t1.getStateGroup(p27, p28) -- line: 587
    p28 = p28 or p27.activeState

    local v38 = p27.appearance[p28]

    if not v38 then
        v38 = {}
        p27.appearance[p28] = v38
    end

    return v38
end

function t1.refreshAppearance(p29, p30, p31) -- line: 597
    -- upvalues: Themes (copy)
    Themes.refresh(p29, p30, p31)

    return p29
end

function t1.refresh(p32) -- line: 602
    p32:refreshAppearance(p32.widget)
    p32.updateSize:Fire()

    return p32
end

function t1.updateParent(p33) -- line: 608
    -- upvalues: t1 (copy)
    local v39 = t1.getIconByUID(p33.parentIconUID)

    if v39 then
        v39.updateSize:Fire()
    end
end

function t1.setBehaviour(p34, p35, p36, p37, p38) -- line: 615
    local v40 = p35 .. "-" .. p36

    p34.customBehaviours[v40] = p37

    if p38 then
        local v41 = p34:getInstanceOrCollective(p35)

        for _, v42 in pairs(v41) do
            p34:refreshAppearance(v42, p36)
        end
    end
end

function t1.modifyTheme(p39, p40, p41) -- line: 628
    -- upvalues: Themes (copy)
    return p39, (Themes.modify(p39, p40, p41))
end

function t1.modifyChildTheme(p42, p43, p44) -- line: 633
    -- upvalues: t1 (copy)
    p42.childModifications = p43
    p42.childModificationsUID = p44

    for v43, _ in pairs(p42.childIconsDict) do
        t1.getIconByUID(v43):modifyTheme(p43, p44)
    end

    p42.childThemeModified:Fire()

    return p42
end

function t1.removeModification(p45, p46) -- line: 646
    -- upvalues: Themes (copy)
    Themes.remove(p45, p46)

    return p45
end

function t1.removeModificationWith(p47, p48, p49, p50) -- line: 651
    -- upvalues: Themes (copy)
    Themes.removeWith(p47, p48, p49, p50)

    return p47
end

function t1.setTheme(p51, p52) -- line: 656
    -- upvalues: Themes (copy)
    Themes.set(p51, p52)

    return p51
end

function t1.setEnabled(p53, p54) -- line: 661
    p53.isEnabled = p54
    p53.enabled = p53.isEnabled
    p53.widget.Visible = p54
    p53:updateParent()

    return p53
end

function t1.select(p55, p56, p57) -- line: 669
    p55:setState("Selected", p56, p57)

    return p55
end

function t1.deselect(p58, p59, p60) -- line: 674
    p58:setState("Deselected", p59, p60)

    return p58
end

function t1.notify(p61, p62, p63) -- line: 679
    -- upvalues: t1 (copy), Elements (copy)
    if not p61.notice then
        p61.notice = require(Elements.Notice)(p61, t1)
    end

    p61.noticeStarted:Fire(p62, p63)

    return p61
end

function t1.clearNotices(p64) -- line: 693
    p64.endNotices:Fire()

    return p64
end

function t1.disableOverlay(p65, p66) -- line: 698
    p65.overlayDisabled = p66

    return p65
end

t1.disableStateOverlay = t1.disableOverlay

function t1.setImage(p67, p68, p69) -- line: 704
    p67:modifyTheme({
        "IconImage",
        "Image",
        p68,
        p69
    })

    return p67
end

function t1.setLabel(p70, p71, p72) -- line: 709
    p70:modifyTheme({
        "IconLabel",
        "Text",
        p71,
        p72
    })

    return p70
end

function t1.setOrder(p73, p74, p75) -- line: 714
    local v44 = p74 * 100

    p73:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v44,
        p75
    })
    p73:modifyTheme({
        "Widget",
        "LayoutOrder",
        v44,
        p75
    })

    return p73
end

function t1.setCornerRadius(p76, p77, p78) -- line: 723
    p76:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p77,
        p78
    })

    return p76
end

function t1.align(p79, p80, p81) -- line: 728
    -- upvalues: t1 (copy)
    local v45 = tostring(p80):lower()

    if v45 == "mid" or v45 == "centre" then
        v45 = "center"
    end

    if v45 ~= "left" and v45 ~= "center" and v45 ~= "right" then
        v45 = "left"
    end

    local TopbarCentered = v45 == "center" and t1.container.TopbarCentered or t1.container.TopbarStandard
    local Holders = TopbarCentered.Holders
    local v46 = string.upper((string.sub(v45, 1, 1))) .. string.sub(v45, 2)

    if not p81 then
        p79.originalAlignment = v46
    end

    local joinedFrame = p79.joinedFrame
    local v47 = Holders[v46]

    p79.screenGui = TopbarCentered
    p79.alignmentHolder = v47

    if not p79.isDestroyed then
        p79.widget.Parent = joinedFrame or v47
    end

    p79.alignment = v46
    p79.alignmentChanged:Fire(v46)
    t1.iconChanged:Fire(p79)

    return p79
end

t1.setAlignment = t1.align

function t1.setLeft(p82) -- line: 757
    p82:setAlignment("Left")

    return p82
end

function t1.setMid(p83) -- line: 762
    p83:setAlignment("Center")

    return p83
end

function t1.setRight(p84) -- line: 767
    p84:setAlignment("Right")

    return p84
end

function t1.setWidth(p85, p86, p87) -- line: 772
    p85:modifyTheme({
        "Widget",
        "DesiredWidth",
        p86,
        p87
    })

    return p85
end

function t1.setImageScale(p88, p89, p90) -- line: 780
    p88:modifyTheme({
        "IconImageScale",
        "Value",
        p89,
        p90
    })

    return p88
end

function t1.setImageRatio(p91, p92, p93) -- line: 785
    p91:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p92,
        p93
    })

    return p91
end

function t1.setTextSize(p94, p95, p96) -- line: 790
    p94:modifyTheme({
        "IconLabel",
        "TextSize",
        p95,
        p96
    })

    return p94
end

function t1.setTextFont(p97, p98, p99, p100, p101) -- line: 795
    p99 = p99 or Enum.FontWeight.Regular
    p100 = p100 or Enum.FontStyle.Normal

    local v50 = typeof(p98)
    local v51 = if v50 == "number" then Font.fromId(p98, p99, p100)
        elseif v50 == "EnumItem" then Font.fromEnum(p98)
        elseif v50 == "string" and not p98:match("rbxasset") then Font.fromName(p98, p99, p100)
        else nil

    p97:modifyTheme({
        "IconLabel",
        "FontFace",
        v51 or Font.new(p98, p99, p100),
        p101
    })

    return p97
end

function t1.bindToggleItem(p102, p103) -- line: 816
    if not p103:IsA("GuiObject") and not p103:IsA("LayerCollector") then
        error("Toggle item must be a GuiObject or LayerCollector!")
    end

    p102.toggleItems[p103] = true
    p102:_updateSelectionInstances()

    return p102
end

function t1.unbindToggleItem(p104, p105) -- line: 825
    p104.toggleItems[p105] = nil
    p104:_updateSelectionInstances()

    return p104
end

function t1._updateSelectionInstances(p106) -- line: 831
    for v52, _ in pairs(p106.toggleItems) do
        local t5 = {}

        for _, descendant in pairs(v52:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(t5, descendant)
            end
        end

        p106.toggleItems[v52] = t5
    end
end

function t1._setToggleItemsVisible(p107, p108, _, p110) -- line: 845
    for v53, _ in pairs(p107.toggleItems) do
        if not p110 or p110 == p107 or p110.toggleItems[v53] == nil then
            v53[v53:IsA("LayerCollector") and "Enabled" or "Visible"] = p108
        end
    end
end

function t1.bindEvent(p111, p112, p113) -- line: 857
    local v54 = p111[p112]

    assert(v54 and typeof(v54) == "table" and v54.Connect, "argument[1] must be a valid topbarplus icon event name!")
    assert(typeof(p113) == "function", "argument[2] must be a function!")
    p111.bindedEvents[p112] = v54:Connect(function(...) -- line: 864
        -- upvalues: p111 (copy), p113 (copy)
        p113(p111, ...)
    end)

    return p111
end

function t1.unbindEvent(p114, p115) -- line: 870
    local v57 = p114.bindedEvents[p115]

    if v57 then
        v57:Disconnect()
        p114.bindedEvents[p115] = nil
    end

    return p114
end

function t1.bindToggleKey(p116, p117) -- line: 879
    assert(typeof(p117) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p116.bindedToggleKeys[p117] = true
    p116.toggleKeyAdded:Fire(p117)
    p116:setCaption("_hotkey_")

    return p116
end

function t1.unbindToggleKey(p118, p119) -- line: 887
    assert(typeof(p119) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p118.bindedToggleKeys[p119] = nil

    return p118
end

function t1.call(p120, p121, ...) -- line: 893
    local v60 = table.pack(...)

    task.spawn(function() -- line: 895
        -- upvalues: p120 (copy), p121 (copy), v60 (copy)
        p121(p120, table.unpack(v60))
    end)

    return p120
end

function t1.addToJanitor(p122, p123, p124, p125) -- line: 901
    p122.janitor:add(p123, p124, p125)

    return p122
end

function t1.lock(p126) -- line: 906
    p126:getInstance("ClickRegion").Visible = false
    p126.locked = true

    return p126
end

function t1.unlock(p127) -- line: 914
    p127:getInstance("ClickRegion").Visible = true
    p127.locked = false

    return p127
end

function t1.debounce(p128, p129) -- line: 921
    p128:lock()
    task.wait(p129)
    p128:unlock()

    return p128
end

function t1.autoDeselect(p130, p131) -- line: 928
    if p131 ~= nil then
        p130.deselectWhenOtherIconSelected = p131
    else
        p130.deselectWhenOtherIconSelected = true
    end

    return p130
end

function t1.oneClick(p132, p133) -- line: 938
    local singleClickJanitor = p132.singleClickJanitor

    singleClickJanitor:clean()

    if p133 or p133 == nil then
        singleClickJanitor:add(p132.selected:Connect(function() -- line: 944
            -- upvalues: p132 (copy)
            p132:deselect("OneClick", p132)
        end))
    end

    p132.oneClickEnabled = true

    return p132
end

function t1.setCaption(p134, p135) -- line: 952
    -- upvalues: Elements (copy)
    if p135 == "_hotkey_" and p134.captionText then
        return p134
    end

    local captionJanitor = p134.captionJanitor

    p134.captionJanitor:clean()

    local v61 = if p135 then p135 == "" else nil

    if not p135 or v61 then
        p134.caption = nil
        p134.captionText = nil
    else
        local v62 = captionJanitor:add(require(Elements.Caption)(p134))

        v62:SetAttribute("CaptionText", p135)
        p134.caption = v62
        p134.captionText = p135
    end

    return p134
end

function t1.setCaptionHint(p136, p137) -- line: 970
    assert(typeof(p137) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    p136.fakeToggleKey = p137
    p136.fakeToggleKeyChanged:Fire(p137)
    p136:setCaption("_hotkey_")

    return p136
end

function t1.leave(p138) -- line: 978
    p138.joinJanitor:clean()

    return p138
end

function t1.joinMenu(p139, p140) -- line: 984
    -- upvalues: Utility (copy)
    Utility.joinFeature(p139, p140, p140.menuIcons, p140:getInstance("Menu"))
    p140.menuChildAdded:Fire(p139)

    return p139
end

function t1.setMenu(p141, p142) -- line: 990
    p141.menuSet:Fire(p142)

    return p141
end

function t1.setFrozenMenu(p143, p144) -- line: 995
    p143:freezeMenu(p144)
    p143:setMenu(p144)
end

function t1.freezeMenu(p145) -- line: 1000
    p145:select("FrozenMenu", p145)
    p145:bindEvent("deselected", function(p146) -- line: 1004
        -- upvalues: p145 (copy)
        p146:select("FrozenMenu", p145)
    end)
    p145:modifyTheme({
        "IconSpot",
        "Visible",
        false
    })
end

function t1.joinDropdown(p147, p148) -- line: 1010
    -- upvalues: Utility (copy)
    p148:getDropdown()
    Utility.joinFeature(p147, p148, p148.dropdownIcons, p148:getInstance("DropdownScroller"))
    p148.dropdownChildAdded:Fire(p147)

    return p147
end

function t1.getDropdown(p149) -- line: 1017
    -- upvalues: Elements (copy)
    local dropdown = p149.dropdown

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p149)
        p149.dropdown = dropdown
        p149:clipOutside(dropdown)
    end

    return dropdown
end

function t1.setDropdown(p150, p151) -- line: 1027
    p150:getDropdown()
    p150.dropdownSet:Fire(p151)

    return p150
end

function t1.clipOutside(p152, p153) -- line: 1033
    -- upvalues: Utility (copy)
    local v64 = Utility.clipOutside(p152, p153)

    p152:refreshAppearance(p153)

    return p152, v64
end

function t1.setIndicator(p154, p155) -- line: 1044
    -- upvalues: t1 (copy), Elements (copy)
    if not p154.indicator then
        p154.indicator = p154.janitor:add(require(Elements.Indicator)(p154, t1))
    end

    p154.indicatorSet:Fire(p155)
end

function t1.convertLabelToNumberSpinner(p156, p157) -- line: 1056
    local IconLabel = p156:getInstance("IconLabel")

    IconLabel.Transparency = 1
    p157.Parent = IconLabel.Parent
    p157.Size = UDim2.fromScale(1, 1)
    p157.AnchorPoint = Vector2.new(0.5, 0.5)
    p157.Position = UDim2.new(0.5, 0, 0.5, 0)
    p157.TextXAlignment = Enum.TextXAlignment.Center
    p157.ClipsDescendants = false

    local t6 = {
        "FontFace",
        "BorderSizePixel",
        "BorderColor3",
        "Rotation",
        "TextStrokeTransparency",
        "TextStrokeColor3",
        "TextStrokeTransparency",
        "TextColor3"
    }

    for _, v65 in ipairs(t6) do
        p157[v65] = IconLabel[v65]
        p156:addToJanitor(IconLabel:GetPropertyChangedSignal(v65):Connect(function() -- line: 1078
            -- upvalues: p157 (copy), IconLabel (copy), v65 (copy)
            p157[v65] = IconLabel[v65]
        end))
    end

    local function getSpinnerSizeAndDigitCount() -- line: 1085
        -- upvalues: p157 (copy)
        local n3 = 0
        local n4 = 0

        for _, child in p157.Frame:GetChildren() do
            local v66 = string.lower(child.Name)

            if v66 == "digit" or (v66 == "prefix" or v66 == "suffix" or v66 == "comma") and child.Text ~= "" then
                n3 += child.AbsoluteSize.X
                n4 += 1
            end
        end

        return n3, n4
    end

    local function getLabelParentContainerXSize() -- line: 1103
        -- upvalues: p157 (copy), IconLabel (copy)
        local ParentParent = IconLabel.Parent.Parent

        if ParentParent == nil then
            return 0
        end

        if ParentParent.IconImage.Visible == true then
            return p157.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X
        end

        return ParentParent.AbsoluteSize.X
    end

    local function getNumberSpinnerXSize() -- line: 1114
        -- upvalues: p157 (copy)
        return p157.Frame.AbsoluteSize.X
    end

    local function adjustSize() -- line: 1118
        -- upvalues: p156 (copy), p157 (copy), IconLabel (copy), getSpinnerSizeAndDigitCount (copy)
        local v67, v68 = getSpinnerSizeAndDigitCount()

        if v68 < 18 then
            p156:setLabel(p157.Value)
        end

        local X = p157.Frame.AbsoluteSize.X

        while v67 < X do
            if p156.isDestroyed ~= true then
                task.wait(0.05)

                if not (v68 > 0 and v68 < 8) then
                    p157.TextSize += 1
                    X = p157.Frame.AbsoluteSize.X
                    v67, v68 = getSpinnerSizeAndDigitCount()
                    continue
                end

                p157.TextSize = IconLabel.TextSize
            end

            break
        end

        local ParentParent = IconLabel.Parent.Parent
        local v69 = if ParentParent == nil then 0 elseif ParentParent.IconImage.Visible == true then p157.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else ParentParent.AbsoluteSize.X

        while true do
            if v69 < v67 then
                if p156.isDestroyed == true then
                    return
                end

                task.wait(0.05)

                if v68 < 8 and v68 > 0 then
                    break
                end

                p157.TextSize -= 1

                local ParentParent = IconLabel.Parent.Parent
                local v70 = if ParentParent == nil then 0 elseif ParentParent.IconImage.Visible == true then p157.Frame.AbsoluteSize.X + IconLabel.Parent.Parent.IconImage.AbsoluteSize.X else ParentParent.AbsoluteSize.X

                v67, v68 = getSpinnerSizeAndDigitCount()
                v69 = v70
                continue
            end

            return
        end

        p157.TextSize = IconLabel.TextSize
    end

    p156:addToJanitor(p157.Frame.ChildAdded:Connect(adjustSize))
    p156:addToJanitor(p157.Frame.ChildRemoved:Connect(adjustSize))
    p156:addToJanitor(p156.iconAdded:Connect(function() -- line: 1156
        -- upvalues: adjustSize (copy)
        task.wait(1)
        adjustSize()
    end))
    p156:updateParent()
    p157.Name = "LabelSpinner"
    p157.Prefix = "$"
    p157.Commas = true
    p157.Decimals = 0
    p157.Duration = 0.25
    p157.Value = 10
    task.wait(0.2)

    return p156
end

function t1.destroy(p158) -- line: 1176
    -- upvalues: t1 (copy)
    if p158.isDestroyed then
        return
    end

    p158:clearNotices()

    if p158.parentIconUID then
        p158:leave()
    end

    p158.isDestroyed = true
    p158.janitor:clean()
    t1.iconRemoved:Fire(p158)
end

t1.Destroy = t1.destroy

return t1
