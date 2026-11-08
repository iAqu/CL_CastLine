-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GUI = require(ReplicatedStorage.Client.GUI)
local Lanes = require(script.Parent.Lanes)
local NotificationItem = require(ReplicatedStorage.Shared.NotificationItem)
local NotificationItemCard = require(ReplicatedStorage.Client.UI.NotificationItemCard)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local t1 = {
    Bloom = "Bloom",
    Halo = "Halo",
    Placeholder = "Placeholder",
    Portrait = "coreImage",
    Card = Assets.UI.Notifs.MainItem,
    HolderPath = { "Frame", "CardSlot" },
    Slot = Assets.UI.Notifs.MainItem.Slot
}
local NewItem = Assets.UI.Items.NewItem
local t2 = {
    {
        Sound = "rbxassetid://73352992887992",
        Rank = Rarity.Rarities.Cosmic.Rank
    },
    {
        Gain = 1.6,
        Rank = (-1e999),
        Sound = "rbxassetid://103957546380416"
    }
}
local v1 = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(1.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(1.05, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local v5 = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 1)
local t3 = {
    CanvasGroup = { "BackgroundTransparency", "GroupTransparency" },
    Frame = { "BackgroundTransparency" },
    ImageButton = { "BackgroundTransparency", "ImageTransparency" },
    ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
    TextButton = { "BackgroundTransparency", "TextStrokeTransparency", "TextTransparency" },
    TextLabel = { "BackgroundTransparency", "TextStrokeTransparency", "TextTransparency" },
    UIStroke = { "Transparency" }
}

local function isFlag(p1) -- line: 140
    return typeof(p1) == "boolean"
end

local function isLabel(p2) -- line: 144
    if typeof(p2) == "string" then
        return p2 ~= ""
    end

    return false
end

local function isSpan(p3) -- line: 148
    if typeof(p3) == "number" and p3 > 0 then
        return p3 < 1e999
    end

    return false
end

local function anyRaised(p4, p5) -- line: 152
    if p4 == true then
        return true
    end

    return p5 == true
end

local function firstNamed(p6, p7) -- line: 156
    if p6 == nil then
        return p7
    end

    return p6
end

local function soonest(p8, p9) -- line: 160
    if p8 == nil then
        return p9
    end

    return (math.min(p8, p9))
end

local t4 = {
    {
        key = "DelayInRound",
        accepts = isFlag,
        fold = anyRaised
    },
    {
        key = "Seconds",
        accepts = isSpan,
        fold = soonest
    },
    {
        key = "UniqueKey",
        accepts = isLabel,
        fold = firstNamed
    }
}
local n1 = 0

local function cueFor(p10) -- line: 172
    -- upvalues: t2 (copy)
    for _, v6 in t2 do
        if p10.Rank >= v6.Rank then
            return v6
        end
    end

    return t2[#t2]
end

local function playCue(p11) -- line: 181
    -- upvalues: Audio (copy), t2 (copy), n1 (ref)
    local elapsed = os.clock()

    if elapsed < n1 then
        return
    end

    n1 = elapsed + 0.2

    local v7 = false
    local v8

    for _, v9 in t2 do
        if p11.Rank >= v9.Rank then
            v8 = v9
            v7 = true
            break
        end
    end

    if not v7 then
        v8 = t2[#t2]
    end

    Audio.Play(v8.Sound, script, if v8.Gain then {
        Volume = v8.Gain
    } else nil)
end

local function descend(p12, p13) -- line: 192
    for _, v11 in p13 do
        p12 = assert(p12:FindFirstChild(v11), (("reward card template lacks %*"):format(v11)))
    end

    return p12
end

local function paintTier(p14, p15) -- line: 200
    -- upvalues: SwapGradient (copy)
    SwapGradient(p14, p15)
end

local function headline(p16) -- line: 204
    if p16 > 1 then
        return "Rewards claimed!"
    end

    return "Reward claimed!"
end

local function cardOptions(p17) -- line: 208
    return {
        Sparkle = false,
        ShowCount = p17.Kind == "Currency" or p17.Amount > 1
    }
end

local function mountSquare(p18, p19) -- line: 215
    p18.Size = UDim2.fromScale(1, 1)
    p18.Parent = p19

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 1
    UIAspectRatioConstraint.Parent = p18
end

local function collectFades(p20, p21, p22) -- line: 224
    -- upvalues: t3 (copy), collectFades (copy)
    if p20 == p21 or p20:IsA("GuiObject") and not p20.Visible or p20:IsA("UIStroke") and not p20.Enabled then
        return
    end

    local v14 = t3[p20.ClassName]

    if v14 then
        for _, v15 in v14 do
            local v16 = p20[v15]

            if v16 < 1 then
                table.insert(p22, {
                    instance = p20,
                    property = v15,
                    resting = v16
                })
            end
        end
    end

    if not p20:IsA("CanvasGroup") then
        for _, child in p20:GetChildren() do
            collectFades(child, p21, p22)
        end
    end
end

local function conceal(p23, p24, p25, p26) -- line: 257
    p23.Size = p24:Lerp(UDim2.new(), 0.44999999999999996)

    for _, v17 in p25 do
        v17.instance[v17.property] = 1
    end

    if p26 then
        p26.ImageTransparency = 1
    end
end

local function reveal(p27, p28, p29) -- line: 268
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    TweenService:Create(p27, v1, {
        Size = p28
    }):Play()

    for _, v18 in p29 do
        TweenService:Create(v18.instance, v2, {
            [v18.property] = v18.resting
        }):Play()
    end
end

local function bloomOut(p30, p31) -- line: 275
    -- upvalues: TweenService (copy), v3 (copy), v4 (copy)
    p30.ImageTransparency = p31
    TweenService:Create(p30, v4, {
        ImageTransparency = 1
    }):Play()

    local UIScale = p30:FindFirstChildOfClass("UIScale")

    if UIScale then
        UIScale.Scale = 0.4
        TweenService:Create(UIScale, v3, {
            Scale = 1.45
        }):Play()
    end
end

local function pulseRing(p32, p33) -- line: 286
    -- upvalues: TweenService (copy), v5 (copy)
    local UIStroke = p32:FindFirstChildOfClass("UIStroke")
    local v19 = UIStroke or Instance.new("UIStroke")
    local t7 = {
        Color = v19.Color,
        Enabled = v19.Enabled,
        Thickness = v19.Thickness,
        Transparency = v19.Transparency
    }
    local v20 = math.max(v19.Thickness, 3) * 2.5

    v19.Color = p33
    v19.Enabled = true
    v19.Thickness = 0
    v19.Transparency = 0.1
    v19.Parent = p32

    local tween = TweenService:Create(v19, v5, {
        Transparency = 1,
        Thickness = v20
    })

    tween.Completed:Once(function() -- line: 304
        -- upvalues: UIStroke (copy), t7 (copy), v19 (copy)
        if UIStroke ~= nil then
            v19.Color = t7.Color
            v19.Enabled = t7.Enabled
            v19.Thickness = t7.Thickness
            v19.Transparency = t7.Transparency
        else
            v19:Destroy()
        end
    end)
    tween:Play()
end

local function createSlot(p34, p35) -- line: 317
    -- upvalues: NotificationItem (copy), NotificationItemCard (copy), SwapGradient (copy), NewItem (copy), descend (copy), collectFades (copy), reveal (copy), bloomOut (copy), pulseRing (copy)
    local Rarity = NotificationItem.Describe(p35).Rarity
    local RarityGradient = Rarity.RarityGradient
    local clone = p34.Slot:Clone()
    local v21 = descend(clone, p34.HolderPath)
    local v22 = clone:FindFirstChild(p34.Bloom)
    local v23 = v21:FindFirstChild(p34.Placeholder)

    if v23 then
        v23:Destroy()
    end

    SwapGradient(v21, RarityGradient)

    for _, v24 in {
            p34.Halo,
            p34.Portrait
        } do
        local v25 = v21:FindFirstChild(v24)

        if v25 then
            SwapGradient(v25, RarityGradient)
        end
    end

    local TextLabel = clone:FindFirstChild("TextLabel")

    if TextLabel and TextLabel:IsA("TextLabel") then
        NewItem:Clone().Parent = TextLabel
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.Text = p35.Amount > 1 and "Rewards claimed!" or "Reward claimed!"
    end

    local v26 = NotificationItemCard.Build(p35, {
        Sparkle = false,
        ShowCount = p35.Kind == "Currency" or p35.Amount > 1
    })

    v26.Size = UDim2.fromScale(1, 1)
    v26.Parent = v21

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 1
    UIAspectRatioConstraint.Parent = v26

    local t9 = {}

    collectFades(clone, v22, t9)

    local Size = clone.Size
    local v27 = if v22 then v22.ImageTransparency else 1

    clone.Size = Size:Lerp(UDim2.new(), 0.44999999999999996)

    for _, v28 in t9 do
        v28.instance[v28.property] = 1
    end

    if v22 then
        v22.ImageTransparency = 1
    end

    return {
        frame = clone,
        play = function() -- play | line: 356
            -- upvalues: Rarity (copy), clone (copy), v21 (copy), v22 (copy), t9 (copy), Size (copy), v27 (copy), reveal (copy), bloomOut (copy), pulseRing (copy)
            reveal(clone, Size, t9)

            if v22 then
                bloomOut(v22, v27)
            end

            pulseRing(v21, Rarity.Color)
        end,
        rarity = Rarity
    }
end

local function laneArea() -- line: 367
    -- upvalues: GUI (copy)
    local Notifications = GUI.Get("Notifications")
    local Feed = if Notifications then Notifications:FindFirstChild("Feed") else nil

    return if Feed and Feed:IsA("GuiObject") then Feed.AbsoluteSize else nil
end

local function slotCapacity(p36) -- line: 374
    -- upvalues: GUI (copy)
    local Notifications = GUI.Get("Notifications")
    local Feed = if Notifications then Notifications:FindFirstChild("Feed") else nil
    local AbsoluteSize = if not (Feed and Feed:IsA("GuiObject")) then nil else Feed.AbsoluteSize

    if AbsoluteSize == nil then
        return 6
    end

    local Size = p36.Card.Size
    local v29 = AbsoluteSize.X * Size.X.Scale + Size.X.Offset
    local v30 = AbsoluteSize.Y * Size.Y.Scale + Size.Y.Offset
    local UIListLayout = p36.Card:FindFirstChildOfClass("UIListLayout")
    local v31 = if UIListLayout then UIListLayout.Padding.Scale * v29 + UIListLayout.Padding.Offset else 0
    local UIAspectRatioConstraint = p36.Slot:FindFirstChildOfClass("UIAspectRatioConstraint")
    local v33 = math.min(v29, v30 * (if UIAspectRatioConstraint then UIAspectRatioConstraint.AspectRatio else 1))

    if v33 <= 0 then
        return 1
    end

    return (math.clamp(math.floor((v29 + v31) / (v33 + v31)), 1, 6))
end

local function liveCards(p37) -- line: 394
    local elapsed = os.clock()
    local t11 = {}

    for _, v36 in p37.cards do
        local shownAt = v36.shownAt
        local v37 = if shownAt == nil then elapsed - v36.queuedAt >= 12 else elapsed - shownAt > v36.lifetime + 2

        if not v36.closed and not v37 then
            table.insert(t11, v36)
        end
    end

    p37.cards = t11

    return t11
end

local function openCard(p38) -- line: 412
    -- upvalues: liveCards (copy)
    local v38 = liveCards(p38)
    local v39 = v38[#v38]

    if v39 ~= nil and not (v39.filled >= v39.capacity) then
        local shownAt = v39.shownAt

        if shownAt == nil or v39.lifetime - (os.clock() - shownAt) >= 1.3 then
            return v39
        end
    end

    return nil
end

local function placeSlot(p39, p40) -- line: 427
    -- upvalues: playCue (copy)
    p39.filled += 1
    p40.frame.LayoutOrder = p39.filled
    p40.frame.Parent = p39.frame

    if p39.shownAt ~= nil then
        playCue(p40.rarity)
        p40.play()

        return
    end

    table.insert(p39.deferredPlays, p40.play)

    local loudest = p39.loudest

    if loudest == nil or p40.rarity.Rank > loudest.Rank then
        p39.loudest = p40.rarity
    end
end

local function resolvePolicy(p41) -- line: 445
    -- upvalues: t4 (copy)
    local t12 = {}

    for _, v40 in p41 do
        for _, v41 in v40.hints do
            for _, v42 in t4 do
                local v43 = v41[v42.key]

                if v42.accepts(v43) then
                    t12[v42.key] = v42.fold(t12[v42.key], v43)
                end
            end
        end
    end

    if t12.Seconds == nil then
        t12.Seconds = 3.4
    end

    return t12
end

local function buildCard(p42, p43, p44) -- line: 463
    -- upvalues: Lanes (copy), playCue (copy), createSlot (copy), placeSlot (copy), resolvePolicy (copy)
    local v44 = resolvePolicy(p43)
    local clone = p42.layout.Card:Clone()

    for _, child in clone:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local t13 = {
        closed = false,
        filled = 0,
        loudest = nil,
        shownAt = nil,
        capacity = p44,
        deferredPlays = {},
        frame = clone,
        lifetime = v44.Seconds or 3.4,
        queuedAt = os.clock()
    }

    clone.Destroying:Once(function() -- line: 483
        -- upvalues: t13 (copy)
        t13.closed = true
    end)
    table.insert(p42.cards, t13)

    for _, v45 in p43 do
        placeSlot(t13, (createSlot(p42.layout, v45.item)))
    end

    Lanes.Schedule({
        Lane = "Feed",
        Frame = clone,
        Seconds = v44.Seconds,
        UniqueKey = v44.UniqueKey,
        DelayInRound = v44.DelayInRound,
        OnShown = function() -- OnShown | line: 498
            -- upvalues: t13 (copy), playCue (copy)
            t13.shownAt = os.clock()

            local loudest = t13.loudest

            if loudest then
                playCue(loudest)
            end

            local deferredPlays = t13.deferredPlays

            t13.deferredPlays = {}

            for v46, v47 in deferredPlays do
                if v46 > 1 then
                    task.wait(0.07)
                end

                if t13.closed then
                    break
                end

                v47()
            end
        end
    })
end

local function flush(p45) -- line: 520
    -- upvalues: slotCapacity (copy), buildCard (copy)
    p45.flushScheduled = false

    local v48 = slotCapacity(p45.layout)

    while #p45.inbox > 0 do
        local v50 = math.min(v48, #p45.inbox)
        local v51 = table.move(p45.inbox, 1, v50, 1, {})

        p45.inbox = table.move(p45.inbox, v50 + 1, #p45.inbox, 1, {})
        buildCard(p45, v51, v48)
    end
end

local function stackKey(p46) -- line: 532
    return (("%*/%*/%*"):format(p46.Kind, p46.Id or "", p46.Mutation or ""))
end

local function stage(p47, p48, p49) -- line: 537
    -- upvalues: flush (copy)
    local v52 = ("%*/%*/%*"):format(p48.Kind, p48.Id or "", p48.Mutation or "")

    for _, v53 in p47.inbox do
        if v53.stack == v52 then
            local v54 = table.clone(v53.item)

            v54.Amount += p48.Amount
            v53.item = v54

            if p49 then
                table.insert(v53.hints, p49)
            end

            return
        end
    end

    if #p47.inbox >= 18 then
        return
    end

    table.insert(p47.inbox, {
        hints = if p49 then { p49 } else {},
        item = p48,
        stack = v52
    })

    if not p47.flushScheduled then
        p47.flushScheduled = true
        task.delay(0.12, flush, p47)
    end
end

local function acceptItem(p50) -- line: 566
    -- upvalues: NotificationItem (copy)
    local Item = if typeof(p50) == "table" then p50.Item else nil
    local v55, v56 = NotificationItem.Schema(Item)

    assert(v55, (("reward notification rejected: %*"):format(v56 or "malformed payload")))

    return Item
end

local function hintFrom(p51) -- line: 574
    -- upvalues: t4 (copy)
    local t16 = {}
    local v58 = false

    for _, v59 in t4 do
        local v60 = p51[v59.key]

        if v60 ~= nil then
            v58 = true
            t16[v59.key] = v60
        end
    end

    return if v58 then t16 else nil
end

local function createChannel(p52) -- line: 587
    -- upvalues: NotificationItem (copy), createSlot (copy), liveCards (copy), placeSlot (copy), stage (copy), hintFrom (copy)
    local t18 = {
        flushScheduled = false,
        cards = {},
        inbox = {},
        layout = p52
    }

    return {
        Show = function(p53) -- Show | line: 596
            -- upvalues: p52 (copy), t18 (copy), NotificationItem (copy), createSlot (copy), liveCards (copy), placeSlot (copy), stage (copy), hintFrom (copy)
            local Item = if typeof(p53) == "table" then p53.Item else nil
            local v61, v62 = NotificationItem.Schema(Item)

            assert(v61, (("reward notification rejected: %*"):format(v62 or "malformed payload")))

            local v64 = liveCards(t18)
            local v65 = v64[#v64]

            if v65 == nil or v65.filled >= v65.capacity then
                v65 = nil
            else
                local shownAt = v65.shownAt

                if shownAt ~= nil and not (v65.lifetime - (os.clock() - shownAt) >= 1.3) then
                    v65 = nil
                end
            end

            if v65 then
                placeSlot(v65, (createSlot(p52, Item)))
            else
                stage(t18, Item, (hintFrom(p53)))
            end
        end
    }
end

return {
    Show = createChannel(t1).Show,
    CreateChannel = function(p54) -- CreateChannel | line: 612
        -- upvalues: t1 (copy), createChannel (copy)
        return (createChannel(p54 or t1))
    end
}
