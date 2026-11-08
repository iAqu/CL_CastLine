-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ConsoleSignals = require(ReplicatedStorage.Client.ConsoleSignals)
local GUI = require(ReplicatedStorage.Client.GUI)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)
local Log = require(ReplicatedStorage.Packages.Log)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local ButtonB = Enum.KeyCode.ButtonB
local t1 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonR3,
    Enum.KeyCode.ButtonSelect,
    Enum.KeyCode.ButtonStart,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadUp
}
local t2 = {
    [Enum.KeyCode.ButtonStart] = true
}
local t3 = {
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true,
    [Enum.KeyCode.DPadUp] = true
}
local t4 = {}
local t5 = {}

for _, v1 in t1 do
    t4[v1.Name] = v1
    t5[v1] = true
end

assert(t5[ButtonB], "the close key has to be a routable key")

local t6 = {
    ActivePets = {
        rank = 900,
        captionedClose = true
    },
    BackpackGui = {
        blocked = true
    },
    BossMastery = {
        captionedClose = true
    },
    BossShop = {
        captionedClose = true
    },
    ButterflyMachine = {
        captionedClose = true
    },
    EnchantedMutationShrine = {
        captionedClose = true
    },
    DogsMemoriesFrame = {
        captionedClose = true
    },
    DropHeldEgg = {
        rank = 200
    },
    FreeGift = {
        captionedClose = true
    },
    GrowingEggs = {
        rank = 900,
        captionedClose = true
    },
    Index = {
        captionedClose = true
    },
    LimitedTimePopupsUI = {
        captionedClose = true
    },
    Message = {
        rank = 1000
    },
    MonsterChestRewards = {
        captionedClose = true
    },
    PetFuse = {
        captionedClose = true
    },
    PhoneVideoUI = {
        blocked = true
    },
    PopupPrompt = {
        captionedClose = true
    },
    RescueDragonFTUEQuest = {
        captionedClose = true
    },
    RiftTradeIn = {
        captionedClose = true
    },
    DrScrambleTradeIn = {
        captionedClose = true
    },
    RobuxShop = {
        captionedClose = true
    },
    RobuxShopOLD = {
        blocked = true
    },
    OldRobuxShop = {
        blocked = true
    },
    RunButton = {
        rank = 100
    },
    ScrambleBossMastery = {
        captionedClose = true
    },
    HalloweenBossMastery = {
        captionedClose = true
    },
    HeadlessHorsemanBattlepass = {
        captionedClose = true
    },
    SellPrompt = {
        captionedClose = true
    },
    Settings = {
        captionedClose = true
    },
    SpeedShop = {
        blocked = true
    },
    TrailShop = {
        captionedClose = true
    },
    Treadmill = {
        blocked = true
    },
    TreadmillScreenButtonSwapLeft = {
        blocked = true
    },
    TreadmillScreenButtonSwapRight = {
        blocked = true
    },
    TreadmillScreenComments = {
        blocked = true
    },
    TreadmillUI = {
        blocked = true
    }
}
local v3 = table.freeze({})
local t7 = {
    microsoft = "B",
    sony = "O"
}
local t8 = {}
local v4 = Log.new()
local v5 = GUI.PlayerGui()
local t9 = {}
local t10 = {}
local t11 = {}
local t12 = {}
local v6, v7, v8
local v9 = true

local function describe(p1) -- line: 144
    if p1 == nil then
        return "none"
    end

    return (p1:GetFullName())
end

local function policyOf(p2) -- line: 148
    -- upvalues: t6 (copy), v3 (copy)
    return t6[p2] or v3
end

local function screenOf(p3) -- line: 152
    if p3:IsA("ScreenGui") then
        return p3
    end

    return (p3:FindFirstAncestorOfClass("ScreenGui"))
end

local function blocked(p4) -- line: 156
    -- upvalues: t6 (copy), v3 (copy)
    local v10 = if p4:IsA("LayerCollector") then p4 else p4:FindFirstAncestorWhichIsA("LayerCollector")

    return v10 ~= nil and (t6[v10.Name] or v3).blocked == true
end

local function showing(p5) -- line: 165
    -- upvalues: showing (copy)
    if p5:IsA("LayerCollector") then
        return p5.Enabled
    end

    if p5:IsA("GuiObject") and not p5.Visible then
        return false
    end

    local Parent = p5.Parent

    return Parent ~= nil and (showing(Parent))
end

local function ownerAbove(p6) -- line: 178
    -- upvalues: ownerAbove (copy)
    local Parent = p6.Parent

    if Parent == nil or Parent:IsA("ScreenGui") then
        return nil
    end

    if Parent:IsA("GuiButton") then
        return Parent
    end

    return (ownerAbove(Parent))
end

local function rankOf(p7) -- line: 186
    -- upvalues: t6 (copy), v3 (copy)
    return (t6[p7.Name] or v3).rank or p7.DisplayOrder
end

local function keyFrom(p8) -- line: 190
    -- upvalues: t4 (copy), t5 (copy)
    local v11 = if typeof(p8) == "EnumItem" then p8 else t4[p8]

    if v11 == nil or not t5[v11] then
        error(("%* is not a key this router knows"):format((tostring(p8))), 3)
    end

    return v11
end

local function closeCaption() -- line: 200
    -- upvalues: InputIconsConfig (copy), t7 (copy), v8 (ref)
    return t7[v8 or InputIconsConfig.Vendor()]
end

local function artFor(p9) -- line: 204
    -- upvalues: InputIconsConfig (copy), t11 (copy)
    local v13 = t11[p9]

    if v13 ~= nil then
        return v13
    end

    local v14 = InputIconsConfig.Image(p9) or ""

    t11[p9] = v14

    return v14
end

local function applyLook(p10) -- line: 214
    -- upvalues: InputIconsConfig (copy), PlatformController (copy), ButtonB (copy), t7 (copy), t10 (copy), v8 (ref)
    local v15 = t10[p10]

    if v15 == nil then
        return
    end

    local v16 = PlatformController.IsConsole()
    local image, caption = v15.image, v15.caption
    local v17, v18

    if image ~= nil then
        if p10:IsA("ImageLabel") then
            v17 = v16 and InputIconsConfig.Image(ButtonB) or image
            v18 = false
        else
            v18 = true
        end
    else
        v18 = true
    end

    if v18 then
        if caption ~= nil and p10:IsA("TextLabel") then
            local v19 = if v16 then t7[v8 or InputIconsConfig.Vendor()] else caption

            p10.Text = v19
        end
    else
        p10.Image = v17
    end

    p10.Visible = v16 or v15.visible
end

local function remember(p11, p12) -- line: 229
    -- upvalues: t10 (copy), applyLook (copy)
    if t10[p11] == nil then
        t10[p11] = p12
        p11.Destroying:Once(function() -- line: 232
            -- upvalues: p11 (copy), t10 (copy)
            t10[p11] = nil
        end)
    end

    applyLook(p11)
end

local function rememberCaption(p13) -- line: 239
    -- upvalues: t10 (copy), applyLook (copy)
    if p13 ~= nil and p13:IsA("TextLabel") then
        local t13 = {
            visible = p13.Visible,
            caption = p13.Text
        }

        if t10[p13] == nil then
            t10[p13] = t13
            p13.Destroying:Once(function() -- line: 232
                -- upvalues: p13 (copy), t10 (copy)
                t10[p13] = nil
            end)
        end

        applyLook(p13)
    end
end

local function decorateClose(p14, p15) -- line: 247
    -- upvalues: t10 (copy), applyLook (copy)
    local TextButton = if p15 then nil else p14:FindFirstChild("TextButton")
    local v21 = true

    if TextButton ~= nil then
        if TextButton:IsA("ImageLabel") then
            local t14 = {
                visible = TextButton.Visible,
                image = TextButton.Image
            }

            if t10[TextButton] == nil then
                t10[TextButton] = t14
                TextButton.Destroying:Once(function() -- line: 232
                    -- upvalues: TextButton (copy), t10 (copy)
                    t10[TextButton] = nil
                end)
            end

            v21 = false
        end
    end

    if not v21 then
        applyLook(TextButton)
    else
        local TextLabel = p14:FindFirstChild("TextLabel")

        if TextLabel ~= nil and TextLabel:IsA("TextLabel") then
            local t15 = {
                visible = TextLabel.Visible,
                caption = TextLabel.Text
            }

            if t10[TextLabel] == nil then
                t10[TextLabel] = t15
                TextLabel.Destroying:Once(function() -- line: 232
                    -- upvalues: TextLabel (copy), t10 (copy)
                    t10[TextLabel] = nil
                end)
            end

            applyLook(TextLabel)
        end

        if p15 and TextLabel ~= nil then
            local TextLabel2 = TextLabel:FindFirstChild("TextLabel")

            if TextLabel2 ~= nil and TextLabel2:IsA("TextLabel") then
                local t16 = {
                    visible = TextLabel2.Visible,
                    caption = TextLabel2.Text
                }

                if t10[TextLabel2] == nil then
                    t10[TextLabel2] = t16

                    local Destroying = TextLabel2.Destroying

                    Destroying:Once(function() -- line: 232
                        -- upvalues: TextLabel2 (copy), t10 (copy)
                        t10[TextLabel2] = nil
                    end)
                end

                applyLook(TextLabel2)
            end
        end
    end
end

local function paintGlyph(p16, p17) -- line: 260
    -- upvalues: InputIconsConfig (copy), PlatformController (copy), t11 (copy)
    local v22 = PlatformController.IsConsole()

    p16.Visible = v22 and p16:GetAttribute("ManualVisibility") ~= true

    if v22 and (p16:IsA("ImageLabel") or p16:IsA("ImageButton")) then
        local v23 = t11[p17]

        if v23 == nil then
            v23 = InputIconsConfig.Image(p17) or ""
            t11[p17] = v23
        end

        p16.Image = v23
    end
end

local function releaseClaimsOn(p18) -- line: 270
    -- upvalues: t12 (copy)
    for v24, v25 in t12 do
        if v25 == p18 then
            t12[v24] = nil
        end
    end
end

local function bind(p19, p20, p21, p22) -- line: 278
    -- upvalues: t9 (copy), t12 (copy)
    local v28 = assert(if p19:IsA("ScreenGui") then p19 else p19:FindFirstAncestorOfClass("ScreenGui"), (("%* needs a ScreenGui above it to take gamepad input"):format(if p19 == nil then "none" else p19:GetFullName())))

    if t9[p19] == nil then
        p19.Destroying:Once(function() -- line: 284
            -- upvalues: p19 (copy), t9 (copy), t12 (copy)
            t9[p19] = nil

            for v29, v30 in t12 do
                if v30 == p19 then
                    t12[v29] = nil
                end
            end
        end)
    end

    t9[p19] = {
        key = p20,
        closes = p22,
        glyph = p21,
        owner = p19,
        screen = v28
    }
end

local function adoptGlyph(p23) -- line: 298
    -- upvalues: t4 (copy), ownerAbove (copy), paintGlyph (copy), bind (copy)
    local GamepadKey = p23:GetAttribute("GamepadKey")

    assert(typeof(GamepadKey) == "string", (("%* needs a string GamepadKey attribute"):format(if p23 == nil then "none" else p23:GetFullName())))

    local v33 = t4[GamepadKey]

    assert(v33 ~= nil, (("%*: %* is not a key this router knows"):format(if p23 == nil then "none" else p23:GetFullName(), GamepadKey)))

    local Parent = p23.Parent

    if Parent == nil or Parent:IsA("ScreenGui") then
        Parent = nil
    elseif not Parent:IsA("GuiButton") then
        Parent = ownerAbove(Parent)
    end

    bind(assert(Parent, (("%* has to sit under a GuiButton"):format(if p23 == nil then "none" else p23:GetFullName()))), v33, p23, false)
    paintGlyph(p23, v33)
end

local function adoptClose(p24) -- line: 311
    -- upvalues: ButtonB (copy), t6 (copy), v3 (copy), decorateClose (copy), bind (copy)
    decorateClose(p24, (t6[assert(if p24:IsA("ScreenGui") then p24 else p24:FindFirstAncestorOfClass("ScreenGui"), (("close button %* needs a ScreenGui above it"):format(if p24 == nil then "none" else p24:GetFullName()))).Name] or v3).captionedClose == true)
    bind(p24, ButtonB, nil, true)
end

local function eligible(p25, p26) -- line: 320
    -- upvalues: v6 (ref), v7 (ref), showing (copy)
    if p25.key ~= p26 then
        return false
    end

    local owner = p25.owner
    local v40 = false

    if owner:IsA("LayerCollector") then
        v40 = owner.Enabled
    elseif not owner:IsA("GuiObject") or owner.Visible then
        local ownerParent = owner.Parent

        v40 = ownerParent ~= nil and showing(ownerParent)
    end

    if v40 then
        local glyph = p25.glyph

        if glyph ~= nil and not glyph.Visible or v6 ~= nil and p25.screen ~= v6 then
            return false
        end

        if v7 == nil then
            return true
        end

        return (p25.owner:IsDescendantOf(v7))
    end

    return false
end

local function score(p27) -- line: 335
    -- upvalues: t6 (copy), v3 (copy)
    local screen = p27.screen

    return ((t6[screen.Name] or v3).rank or screen.DisplayOrder) * 2 + (if p27.closes then 0 else 1)
end

local function claimantFor(p28) -- line: 339
    -- upvalues: t6 (copy), v3 (copy), t9 (copy), eligible (copy)
    local n1 = (-1e999)
    local v41

    for v42, v43 in t9 do
        if eligible(v43, p28) then
            local screen = v43.screen
            local v44 = ((t6[screen.Name] or v3).rank or screen.DisplayOrder) * 2 + (if v43.closes then 0 else 1)

            if n1 < v44 then
                n1 = v44
                v41 = v42
            end
        end
    end

    return v41
end

local function selectionTakesA() -- line: 353
    -- upvalues: GuiService (copy), showing (copy)
    local SelectedObject = GuiService.SelectedObject

    if SelectedObject == nil then
        return false
    end

    if SelectedObject:IsA("LayerCollector") then
        return SelectedObject.Enabled
    end

    if SelectedObject:IsA("GuiObject") and not SelectedObject.Visible then
        return false
    end

    local SelectedObjectParent = SelectedObject.Parent

    return SelectedObjectParent ~= nil and (showing(SelectedObjectParent))
end

local function routes(p29) -- line: 358
    -- upvalues: GuiService (copy), MenuNavigation (copy), PlatformController (copy), t5 (copy), v9 (ref), showing (copy)
    if not t5[p29] or not v9 or not PlatformController.IsConsole() or MenuNavigation.IsSuspended() then
        return false
    end

    if p29 == Enum.KeyCode.ButtonA then
        local SelectedObject = GuiService.SelectedObject
        local v45 = false

        if SelectedObject ~= nil then
            if SelectedObject:IsA("LayerCollector") then
                v45 = SelectedObject.Enabled
            elseif not SelectedObject:IsA("GuiObject") or SelectedObject.Visible then
                local SelectedObjectParent = SelectedObject.Parent

                v45 = SelectedObjectParent ~= nil and showing(SelectedObjectParent)
            end
        end

        if v45 or MenuNavigation.IsCursorActive() then
            return false
        end
    end

    return true
end

local function press(p30) -- line: 374
    -- upvalues: GuiService (copy), ConsoleSignals (copy), v4 (copy), t12 (copy), v6 (ref), claimantFor (copy), routes (copy)
    if t12[p30] ~= nil then
        return true
    end

    if not routes(p30) then
        return false
    end

    local v46 = claimantFor(p30)

    if v46 == nil then
        local v47 = v4:AtDebug()
        local Name = p30.Name
        local v48 = v6
        local v49 = if v48 == nil then "none" else v48:GetFullName()
        local SelectedObject = GuiService.SelectedObject

        v47:Log((("%*: no button answered (focus %*, selection %*)"):format(Name, v49, if SelectedObject == nil then "none" else SelectedObject:GetFullName())))

        return false
    end

    t12[p30] = v46
    ConsoleSignals.ButtonDown:Fire(v46, p30)

    return true
end

local function release(p31, p32) -- line: 397
    -- upvalues: ConsoleSignals (copy), PlatformController (copy), t5 (copy), t12 (copy), showing (copy)
    local v50 = t12[p31]

    t12[p31] = nil

    if v50 == nil then
        return false
    end

    if p32 and t5[p31] and PlatformController.IsConsole() and v50.Active then
        local v51 = false

        if v50:IsA("LayerCollector") then
            v51 = v50.Enabled
        elseif not v50:IsA("GuiObject") or v50.Visible then
            local Parent = v50.Parent

            v51 = Parent ~= nil and showing(Parent)
        end

        if v51 then
            ConsoleSignals.ButtonUp:Fire(v50, p31)
        end
    end

    return true
end

local function onRoutedKey(_, p34, p35) -- line: 418
    -- upvalues: ConsoleSignals (copy), PlatformController (copy), t5 (copy), t12 (copy), showing (copy), press (copy)
    local KeyCode = p35.KeyCode

    if p34 == Enum.UserInputState.Cancel and not t5[KeyCode] then
        local v52 = next(t12) ~= nil

        table.clear(t12)

        if v52 then
            return Enum.ContextActionResult.Sink
        end

        return Enum.ContextActionResult.Pass
    end

    local v53

    if p34 == Enum.UserInputState.Begin then
        v53 = press(KeyCode)
    elseif p34 == Enum.UserInputState.Change then
        v53 = t12[KeyCode] ~= nil
    else
        local v54 = p34 ~= Enum.UserInputState.Cancel
        local v55 = t12[KeyCode]

        t12[KeyCode] = nil

        local v56 = true

        if v55 ~= nil then
            if v54 and t5[KeyCode] and PlatformController.IsConsole() and v55.Active then
                if v55:IsA("LayerCollector") then
                    if v55.Enabled then
                        ConsoleSignals.ButtonUp:Fire(v55, KeyCode)
                    end
                elseif not v55:IsA("GuiObject") or v55.Visible then
                    local Parent = v55.Parent

                    if Parent ~= nil and showing(Parent) then
                        ConsoleSignals.ButtonUp:Fire(v55, KeyCode)
                    end
                end
            end

            v56 = false
        end

        v53 = not v56
    end

    if v53 then
        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end

local function repaint() -- line: 437
    -- upvalues: t9 (copy), t10 (copy), applyLook (copy), paintGlyph (copy)
    for v57 in t10 do
        if v57.Parent ~= nil then
            applyLook(v57)
        end
    end

    for _, v58 in t9 do
        local glyph = v58.glyph

        if glyph ~= nil then
            paintGlyph(glyph, v58.key)
        end
    end
end

function t8.GlyphFor(p36) -- line: 453
    -- upvalues: InputIconsConfig (copy), t4 (copy), t5 (copy), t11 (copy)
    local v59 = if typeof(p36) == "EnumItem" then p36 else t4[p36]

    if v59 == nil or not t5[v59] then
        error(("%* is not a key this router knows"):format((tostring(p36))), 3)
    end

    local v60 = t11[v59]

    if v60 ~= nil then
        return v60
    end

    local v61 = InputIconsConfig.Image(v59) or ""

    t11[v59] = v61

    return v61
end

function t8.IsOnScreen(p37) -- line: 457
    -- upvalues: showing (copy)
    if p37:IsA("LayerCollector") then
        return p37.Enabled
    end

    if p37:IsA("GuiObject") and not p37.Visible then
        return false
    end

    local Parent = p37.Parent

    return Parent ~= nil and (showing(Parent))
end

function t8.TrackCloseButton(p38) -- line: 461
    -- upvalues: t6 (copy), v3 (copy), adoptClose (copy)
    local v62 = if p38:IsA("LayerCollector") then p38 else p38:FindFirstAncestorWhichIsA("LayerCollector")

    if not (v62 ~= nil and (t6[v62.Name] or v3).blocked == true) then
        adoptClose(p38)
    end
end

function t8.Inspect(p39) -- line: 467
    -- upvalues: t6 (copy), v3 (copy), adoptGlyph (copy), adoptClose (copy)
    local v64 = if p39:IsA("LayerCollector") then p39 else p39:FindFirstAncestorWhichIsA("LayerCollector")

    if not (v64 ~= nil and (t6[v64.Name] or v3).blocked == true) then
        if p39.Name ~= "GamepadGlyph" or not p39:IsA("GuiObject") then
            if p39.Name == "Close" and p39:IsA("GuiButton") and (if p39:IsA("ScreenGui") then p39 else p39:FindFirstAncestorOfClass("ScreenGui")) ~= nil then
                adoptClose(p39)
            end
        else
            adoptGlyph(p39)
        end
    end
end

function t8.FocusScreen(p40, p41) -- line: 478
    -- upvalues: v5 (copy), t12 (copy), v6 (ref), v7 (ref)
    assert(p40 == nil or p40:IsDescendantOf(v5), "only a screen inside the local PlayerGui can take focus")

    if v6 == p40 and v7 == p41 then
        return
    end

    v6 = p40
    v7 = p41
    table.clear(t12)
end

function t8.EnableMarkers(p42) -- line: 490
    -- upvalues: t12 (copy), v9 (ref)
    v9 = p42

    if not p42 then
        table.clear(t12)
    end
end

function t8.Rescan(p43) -- line: 497
    -- upvalues: InputIconsConfig (copy), PlatformController (copy), t8 (copy), v5 (copy), t11 (copy), v8 (ref), repaint (copy)
    v8 = if (p43 or PlatformController.Platform()) == "Console" then InputIconsConfig.Vendor() else nil
    table.clear(t11)

    for _, descendant in v5:GetDescendants() do
        t8.Inspect(descendant)
    end

    repaint()
end

MenuNavigation.CursorChanged:Connect(function() -- line: 510
    -- upvalues: t12 (copy)
    table.clear(t12)
end)
PlatformController.Changed:Connect(function(p44) -- line: 513
    -- upvalues: t8 (copy), t12 (copy)
    table.clear(t12)
    t8.Rescan(p44)
end)
InputIconsConfig.Changed:Connect(function() -- line: 517
    -- upvalues: t8 (copy)
    t8.Rescan()
end)

local t17 = {}

for _, v67 in t1 do
    if not t2[v67] then
        table.insert(t17, v67)
    end
end

ContextActionService:BindActionAtPriority("GamepadGlyphRouting", onRoutedKey, false, Enum.ContextActionPriority.High.Value, table.unpack(t17))
UserInputService.InputBegan:Connect(function(p45) -- line: 535
    -- upvalues: t3 (copy), v6 (ref), press (copy)
    if v6 ~= nil and t3[p45.KeyCode] then
        press(p45.KeyCode)
    end
end)
UserInputService.InputEnded:Connect(function(p46) -- line: 540
    -- upvalues: ConsoleSignals (copy), PlatformController (copy), t3 (copy), t5 (copy), t12 (copy), v6 (ref), showing (copy)
    if v6 == nil or not t3[p46.KeyCode] then
        return
    end

    local KeyCode = p46.KeyCode
    local v68 = t12[KeyCode]

    t12[KeyCode] = nil

    if v68 ~= nil and t5[KeyCode] and PlatformController.IsConsole() and v68.Active then
        local v69 = false

        if v68:IsA("LayerCollector") then
            v69 = v68.Enabled
        elseif not v68:IsA("GuiObject") or v68.Visible then
            local Parent = v68.Parent

            v69 = Parent ~= nil and showing(Parent)
        end

        if v69 then
            ConsoleSignals.ButtonUp:Fire(v68, KeyCode)
        end
    end
end)
v4:AtInfo():Log("gamepad routing online")

return t8
