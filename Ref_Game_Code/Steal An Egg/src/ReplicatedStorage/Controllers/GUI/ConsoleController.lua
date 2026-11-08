-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)
local GUI = require(ReplicatedStorage.Client.GUI)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Hud = require(ReplicatedStorage.Client.Hud)
local Log = require(ReplicatedStorage.Packages.Log)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)
local v1 = table.freeze({ "Message", "ActivePets", "GrowingEggs" })
local v2 = table.freeze({
    BackpackGui = true,
    Treadmill = true,
    TreadmillScreenButtonSwapLeft = true,
    TreadmillScreenButtonSwapRight = true,
    TreadmillScreenComments = true,
    TreadmillUI = true
})
local ButtonL3, ButtonB = Enum.KeyCode.ButtonL3, Enum.KeyCode.ButtonB
local v3 = table.freeze({
    BackpackGui = true,
    TopbarCentered = true,
    TopbarCenteredClipped = true,
    TopbarStandard = true,
    TopbarStandardClipped = true
})

return {
    Start = function() -- Start | line: 53
        -- upvalues: GuiService (copy), ContextActionService (copy), UserInputService (copy), ButtonHintStrip (copy), GUI (copy), GamepadBindings (copy), Hud (copy), Log (copy), PlatformController (copy), Tabs (copy), MenuNavigation (copy), Preferences (copy), Toast (copy), InputIconsConfig (copy), v1 (copy), v2 (copy), ButtonL3 (copy), ButtonB (copy), v3 (copy)
        local v4 = Log.new()
        local v5 = GUI.PlayerGui()
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local t5 = {}
        local v6, v7, v8, v9
        local t6 = {}
        local v10 = false
        local v11 = false
        local v12 = false
        local v13 = false

        local function isVisible(p1) -- line: 76
            -- upvalues: GamepadBindings (copy)
            return GamepadBindings.IsOnScreen(p1)
        end

        local function isModalDialog(p2) -- line: 78
            return p2 ~= nil and p2:GetAttribute("ModalDialog") == true
        end

        local function settleSelection(p3) -- line: 82
            -- upvalues: GuiService (copy)
            if GuiService.SelectedObject ~= p3 then
                GuiService.SelectedObject = p3
            end

            GuiService.GuiNavigationEnabled = p3 ~= nil
        end

        local function priorityScreen() -- line: 89
            -- upvalues: v13 (ref), GUI (copy), Tabs (copy), v1 (copy)
            for _, v14 in v1 do
                local v15 = GUI.Get(v14)

                assert(v15:IsA("ScreenGui"), (("%* must be a ScreenGui"):format(v14)))

                if v15.Enabled then
                    return v15
                end
            end

            local v17 = Tabs.Active()
            local v18 = v17 == nil
            local v19, Enabled

            if not v18 then
                v19 = GUI.Get(v17)
                assert(v19:IsA("ScreenGui"), (("Tab %* must be a ScreenGui"):format(v17)))
                Enabled = v19.Enabled
            end

            if not v18 and Enabled then
                return v19
            end

            local v21 = v13
            local v22, Enabled2

            if v21 then
                v22 = GUI.HUD()
                assert(v22:IsA("ScreenGui"), "HUD must be a ScreenGui")
                Enabled2 = v22.Enabled
            end

            return if v21 and Enabled2 then v22 else nil
        end

        local function setHudNavigation(p4, p5) -- line: 118
            -- upvalues: v4 (copy), v13 (ref), GamepadBindings (copy), ButtonL3 (copy)
            if v13 == p4 then
                return
            end

            v13 = p4
            GamepadBindings.EnableMarkers(not p4)
            v4:AtDebug():Log((("HUD navigation %* (%*); toggle key is %*"):format(p4 and "ON" or "OFF", p5, ButtonL3.Name)))
        end

        local function isCursorScopeMember(p6, p7) -- line: 129
            -- upvalues: v5 (copy), v6 (ref), v9 (ref), v3 (copy)
            if p6 == p7 or p6:IsDescendantOf(p7) then
                return true
            end

            local v23 = v6

            if v23 ~= nil and v23:GetAttribute("ModalDialog") == true or v9 and v9.Modal then
                return false
            end

            local v24 = if p6:IsA("ScreenGui") then p6 else p6:FindFirstAncestorOfClass("ScreenGui")
            local v25

            if v24 ~= nil then
                v25 = v24:IsDescendantOf(v5)

                if v25 then
                    v25 = v24.Name == "HUD" or v3[v24.Name] == true
                end
            else
                v25 = false
            end

            return v25
        end

        local function restoreSelectableButtons(p8, p9) -- line: 137
            -- upvalues: t2 (copy), t3 (copy), isCursorScopeMember (copy)
            for v26 in t3 do
                if p8 then
                    if v26 ~= p8 and not v26:IsDescendantOf(p8) and (not p9 or not isCursorScopeMember(v26, p8)) then
                        if v26.Parent ~= nil then
                            v26.Selectable = t2[v26]
                        end

                        t3[v26] = nil
                        t2[v26] = nil
                    end
                else
                    if v26.Parent ~= nil then
                        v26.Selectable = t2[v26]
                    end

                    t3[v26] = nil
                    t2[v26] = nil
                end
            end
        end

        local function focusRank(p10) -- line: 153
            local v27 = if p10:GetAttribute("DefaultFocus") == true then 0 else 2
            local v28 = if p10.Name == "Close" then 1 else 0
            local AbsolutePosition = p10.AbsolutePosition

            return v27 + v28, p10.LayoutOrder, AbsolutePosition.Y, AbsolutePosition.X
        end

        local function outranks(p11, p12) -- line: 160
            local v29 = if p11:GetAttribute("DefaultFocus") == true then 0 else 2
            local v30 = if p11.Name == "Close" then 1 else 0
            local AbsolutePosition = p11.AbsolutePosition
            local v31 = v29 + v30
            local LayoutOrder = p11.LayoutOrder
            local Y, X = AbsolutePosition.Y, AbsolutePosition.X
            local v32 = if p12:GetAttribute("DefaultFocus") == true then 0 else 2
            local v33 = if p12.Name == "Close" then 1 else 0
            local AbsolutePosition2 = p12.AbsolutePosition
            local v34 = v32 + v33
            local LayoutOrder2 = p12.LayoutOrder
            local Y2, X2 = AbsolutePosition2.Y, AbsolutePosition2.X

            if v31 ~= v34 then
                return v31 < v34
            end

            if LayoutOrder ~= LayoutOrder2 then
                return LayoutOrder < LayoutOrder2
            end

            if Y == Y2 then
                return X < X2
            end

            return Y < Y2
        end

        local function projectSelectableButtons(p13) -- line: 169
            -- upvalues: t2 (copy), t3 (copy), GamepadBindings (copy)
            local descendant

            for _, descendant2 in p13:GetDescendants() do
                if descendant2:IsA("GuiButton") then
                    local Active = descendant2.Active and descendant2.Interactable and GamepadBindings.IsOnScreen(descendant2) and descendant2:GetAttribute("ConsoleNavigationDisabled") ~= true

                    if t2[descendant2] == nil then
                        t2[descendant2] = descendant2.Selectable
                    end

                    if descendant2.Selectable ~= Active then
                        descendant2.Selectable = Active
                    end

                    t3[descendant2] = true

                    if Active then
                        if descendant ~= nil then
                            local v35 = if descendant2:GetAttribute("DefaultFocus") == true then 0 else 2
                            local v36 = if descendant2.Name == "Close" then 1 else 0
                            local AbsolutePosition = descendant2.AbsolutePosition
                            local v37 = v35 + v36
                            local LayoutOrder = descendant2.LayoutOrder
                            local Y, X = AbsolutePosition.Y, AbsolutePosition.X
                            local v38 = if descendant:GetAttribute("DefaultFocus") == true then 0 else 2
                            local v39 = if descendant.Name == "Close" then 1 else 0
                            local AbsolutePosition2 = descendant.AbsolutePosition
                            local v40 = v38 + v39
                            local LayoutOrder2 = descendant.LayoutOrder
                            local Y2, X2 = AbsolutePosition2.Y, AbsolutePosition2.X

                            if if v37 ~= v40 then v37 < v40
                                elseif LayoutOrder ~= LayoutOrder2 then LayoutOrder < LayoutOrder2
                                elseif Y == Y2 then X < X2
                                else Y < Y2 then
                                descendant = descendant2
                            end
                        else
                            descendant = descendant2
                        end
                    end
                end
            end

            return descendant
        end

        local function projectSelectionContainers(p14, p15) -- line: 191
            -- upvalues: t2 (copy), t3 (copy)
            local function project(p16) -- line: 192
                -- upvalues: p15 (copy), t2 (copy), t3 (copy)
                if not p16:IsA("GuiObject") or p16:IsA("GuiButton") or p16:IsA("TextBox") then
                    return
                end

                if t2[p16] == nil then
                    if not p16.Selectable then
                        return
                    end

                    t2[p16] = p16.Selectable
                end

                local v41 = not p15 and t2[p16]

                if p16.Selectable ~= v41 then
                    p16.Selectable = v41
                end

                t3[p16] = true
            end

            project(p14)

            for _, descendant in p14:GetDescendants() do
                project(descendant)
            end
        end

        local function isEligibleSelection(p17, p18) -- line: 209
            -- upvalues: GamepadBindings (copy)
            local Selectable, v42

            if p18 ~= nil then
                local v43 = p18:IsDescendantOf(p17)

                if v43 then
                    if p18:IsA("GuiButton") then
                        v42 = false
                    else
                        local TextBox = p18:IsA("TextBox")

                        if TextBox then
                            v42 = false
                        else
                            Selectable = TextBox
                            v42 = true
                        end
                    end
                else
                    Selectable = v43
                    v42 = true
                end
            else
                Selectable = false
                v42 = true
            end

            if not v42 then
                Selectable = p18.Selectable

                if Selectable then
                    Selectable = p18.Active

                    if Selectable then
                        Selectable = p18.Interactable

                        if Selectable then
                            Selectable = p18:GetAttribute("ConsoleNavigationDisabled") ~= true and GamepadBindings.IsOnScreen(p18)
                        end
                    end
                end
            end

            return Selectable
        end

        local function scrollTarget(p19, p20, p21, p22, p23) -- line: 224
            local v44 = p19 + p20 + p21 - p22
            local v45 = p19 + p20

            if not (v45 < v44) then
                v45 = math.clamp(p19, v44, v45)
            end

            return (math.clamp(v45, 0, (math.max(p23, 0))))
        end

        local function revealSelection(p24) -- line: 231
            local Parent = p24.Parent

            while Parent do
                if Parent:IsA("ScrollingFrame") and Parent.ScrollingEnabled then
                    local v47 = p24.AbsolutePosition - Parent.AbsolutePosition
                    local AbsoluteSize = p24.AbsoluteSize
                    local AbsoluteWindowSize, CanvasPosition = Parent.AbsoluteWindowSize, Parent.CanvasPosition
                    local v48 = Parent.AbsoluteCanvasSize - AbsoluteWindowSize
                    local ScrollingDirection = Parent.ScrollingDirection
                    local new = Vector2.new
                    local v49

                    if ScrollingDirection == Enum.ScrollingDirection.Y then
                        v49 = CanvasPosition.X
                    else
                        local X = CanvasPosition.X
                        local X2 = v47.X
                        local X3 = AbsoluteSize.X
                        local X4 = AbsoluteWindowSize.X
                        local X5 = v48.X
                        local v50 = X + X2 + X3 - X4
                        local v51 = X + X2

                        if not (v51 < v50) then
                            v51 = math.clamp(X, v50, v51)
                        end

                        v49 = math.clamp(v51, 0, (math.max(X5, 0)))
                    end

                    local v53

                    if ScrollingDirection == Enum.ScrollingDirection.X then
                        v53 = CanvasPosition.Y
                    else
                        local Y = CanvasPosition.Y
                        local Y2 = v47.Y
                        local Y3 = AbsoluteSize.Y
                        local Y4 = AbsoluteWindowSize.Y
                        local Y5 = v48.Y
                        local v54 = Y + Y2 + Y3 - Y4
                        local v55 = Y + Y2

                        if not (v55 < v54) then
                            v55 = math.clamp(Y, v54, v55)
                        end

                        v53 = math.clamp(v55, 0, (math.max(Y5, 0)))
                    end

                    local v57 = new(v49, v53)

                    if v57 ~= CanvasPosition then
                        Parent.CanvasPosition = v57
                    end
                end

                Parent = Parent.Parent
            end
        end

        local function isExternalNavigationSelection(p25) -- line: 251
            -- upvalues: v3 (copy)
            if p25 == nil then
                return false
            end

            local LayerCollector = p25:FindFirstAncestorWhichIsA("LayerCollector")

            return LayerCollector ~= nil and v3[LayerCollector.Name] == true
        end

        local function restorePointerButtons(p26) -- line: 259
            -- upvalues: t6 (copy), isCursorScopeMember (copy)
            for v58, v59 in t6 do
                if not p26 or not v58.Parent or isCursorScopeMember(v58, p26) then
                    if v58.Parent and v58.Interactable ~= v59 then
                        v58.Interactable = v59
                    end

                    t6[v58] = nil
                end
            end
        end

        local function scopePointerButtons(p27) -- line: 267
            -- upvalues: v5 (copy), t6 (copy), isCursorScopeMember (copy)
            for _, descendant in v5:GetDescendants() do
                if descendant:IsA("GuiButton") and not isCursorScopeMember(descendant, p27) and descendant.Interactable then
                    t6[descendant] = true
                    descendant.Interactable = false
                end
            end
        end

        local function updateNavigationHints(p28) -- line: 276
            -- upvalues: v10 (ref), ButtonHintStrip (copy), MenuNavigation (copy), Preferences (copy), Toast (copy), InputIconsConfig (copy)
            if p28 ~= nil then
                local v60 = MenuNavigation.IsCursorActive()

                ButtonHintStrip.SetNavigationLayer(if p28:IsA("ScreenGui") then p28.DisplayOrder else 50)
                ButtonHintStrip.PresentStatus("NavigationMode", v60 and "Navigation: Cursor" or "Navigation: Buttons")
                ButtonHintStrip.Present("NavigationSwitch", MenuNavigation.SwitchKey, v60 and "Use Button Navigation" or "Use Cursor")

                if not v10 and not Preferences.IsOn("SeenNavigationHint") then
                    v10 = true
                    Toast.Show({
                        Text = "Prefer a cursor in menus? Press the right stick to switch. Your choice is saved.",
                        Seconds = 12,
                        WrapText = true,
                        Image = InputIconsConfig.Image(MenuNavigation.SwitchKey)
                    })
                    task.delay(12, function() -- line: 295
                        -- upvalues: Preferences (copy)
                        Preferences.Set("SeenNavigationHint", true)
                    end)
                end
            else
                ButtonHintStrip.Retract("NavigationSwitch")
                ButtonHintStrip.Retract("NavigationMode")
                ButtonHintStrip.SetNavigationLayer(nil)
            end
        end

        local function reconcile() -- line: 299
            -- upvalues: v4 (copy), v5 (copy), t2 (copy), t3 (copy), t4 (copy), v6 (ref), v7 (ref), v8 (ref), v9 (ref), t6 (copy), v12 (ref), v13 (ref), priorityScreen (copy), isCursorScopeMember (copy), restoreSelectableButtons (copy), projectSelectableButtons (copy), projectSelectionContainers (copy), isEligibleSelection (copy), revealSelection (copy), restorePointerButtons (copy), scopePointerButtons (copy), updateNavigationHints (copy), GuiService (copy), UserInputService (copy), ButtonHintStrip (copy), GamepadBindings (copy), PlatformController (copy), MenuNavigation (copy), ButtonL3 (copy), v3 (copy)
            if not v12 then
                v12 = true

                local v61 = v8

                v8 = nil

                if MenuNavigation.IsSuspended() then
                    for v62 in t3 do
                        if v62.Parent ~= nil then
                            v62.Selectable = t2[v62]
                        end

                        t3[v62] = nil
                        t2[v62] = nil
                    end

                    for v63, v64 in t6 do
                        if v63.Parent and v63.Interactable ~= v64 then
                            v63.Interactable = v64
                        end

                        t6[v63] = nil
                    end

                    MenuNavigation.Release()
                    ButtonHintStrip.Retract("NavigationSwitch")
                    ButtonHintStrip.Retract("NavigationMode")
                    ButtonHintStrip.SetNavigationLayer(nil)
                    ButtonHintStrip.Retract("HudNavigation")

                    if not (PlatformController.IsConsole() and UserInputService.GamepadEnabled) and v13 ~= false then
                        v13 = false
                        GamepadBindings.EnableMarkers(true)
                        v4:AtDebug():Log((("HUD navigation OFF (left console platform); toggle key is %*"):format(ButtonL3.Name)))
                    end

                    v6 = nil
                    v7 = nil
                    v9 = nil
                    GamepadBindings.FocusScreen(nil)

                    if not GuiService.MenuIsOpen then
                        if GuiService.SelectedObject ~= nil then
                            GuiService.SelectedObject = nil
                        end

                        GuiService.GuiNavigationEnabled = false
                    end
                else
                    local v65 = priorityScreen()
                    local v66 = MenuNavigation.TopOverride()
                    local v67 = false
                    local v68 = false
                    local v69 = false
                    local v70 = false
                    local v71 = false

                    if v66 then
                        v67 = true
                    end

                    if v67 then
                        if v65 ~= nil then
                            v68 = true
                        else
                            v69 = true
                        end
                    end

                    v67 = false

                    if v68 then
                        if v65.Name == "HUD" then
                            v69 = true
                        else
                            v67 = true
                        end
                    end

                    v68 = false

                    if v67 then
                        if v66.Priority >= 1000 then
                            v69 = true
                        else
                            v71 = false
                        end
                    end

                    v67 = false

                    if v69 then
                        if v65 ~= nil then
                            v67 = true
                        else
                            v71 = true
                        end
                    end

                    v69 = false

                    local v72

                    if v67 then
                        if v65 ~= nil then
                            v69 = true
                        else
                            v72 = false
                            v68 = true
                        end
                    end

                    v67 = false

                    if v69 then
                        if v65:GetAttribute("ModalDialog") == true then
                            v70 = true
                        else
                            v67 = true
                        end
                    end

                    if v67 then
                        v72 = false
                        v68 = true
                    end

                    if v70 then
                        v72 = true
                        v68 = true
                    end

                    v70 = false

                    if v68 then
                        if v72 then
                            v70 = true
                        else
                            v71 = true
                        end
                    end

                    if v70 then
                        v71 = v66.Priority >= 2000
                    end

                    if v71 then
                        v65 = v66.Root:FindFirstAncestorWhichIsA("LayerCollector")
                    else
                        v66 = nil
                    end

                    local v73 = if v66 then v66.Root else v65

                    v9 = v66
                    v7 = v73
                    v6 = v65
                    restoreSelectableButtons(v73, MenuNavigation.PrefersCursor())
                    restorePointerButtons(if MenuNavigation.PrefersCursor() then v73 else nil)

                    if v65 ~= nil and v65.Name ~= "HUD" then
                        local v75 = ("%* took focus"):format(v65.Name)

                        if v13 ~= false then
                            v13 = false
                            GamepadBindings.EnableMarkers(true)
                            v4:AtDebug():Log((("HUD navigation OFF (%*); toggle key is %*"):format(v75, ButtonL3.Name)))
                        end
                    end

                    if v65 == nil or v65.Name == "HUD" then
                        ButtonHintStrip.Present("HudNavigation", ButtonL3, v13 and "Close Menus" or "Menus")
                    else
                        ButtonHintStrip.Retract("HudNavigation")
                    end

                    v6 = v65
                    GamepadBindings.FocusScreen(v65, v73)

                    if v65 ~= nil then
                        assert(v73)

                        local v77 = projectSelectableButtons(v73)
                        local v78 = if v61 then t4[v73] else GuiService.SelectedObject

                        if not isEligibleSelection(v73, v78) then
                            v78 = t4[v73]

                            if not isEligibleSelection(v73, v78) then
                                local v79 = if v66 then isEligibleSelection(v73, v66.Initial) else nil

                                v78 = if not v66 or not v79 then v77 else v66.Initial
                            end
                        end

                        if MenuNavigation.PrefersCursor() then
                            if v61 ~= v73 then
                                if v78 then
                                    t4[v73] = v78
                                end

                                GuiService.SelectedObject = nil
                            end

                            GuiService.GuiNavigationEnabled = true
                        end

                        if MenuNavigation.SetContext(v73, v78) then
                            v8 = v73
                            projectSelectionContainers(v73, false)

                            for _, child in v5:GetChildren() do
                                if child:IsA("ScreenGui") and child.Enabled and child ~= v73 and isCursorScopeMember(child, v73) then
                                    projectSelectableButtons(child)
                                end
                            end

                            scopePointerButtons(v73)
                            updateNavigationHints(v65)
                        else
                            for v80, v81 in t6 do
                                if v80.Parent and v80.Interactable ~= v81 then
                                    v80.Interactable = v81
                                end

                                t6[v80] = nil
                            end

                            for v82 in t3 do
                                if not v73 or v82 ~= v73 and not v82:IsDescendantOf(v73) then
                                    if v82.Parent ~= nil then
                                        v82.Selectable = t2[v82]
                                    end

                                    t3[v82] = nil
                                    t2[v82] = nil
                                end
                            end

                            projectSelectionContainers(v73, true)
                            updateNavigationHints(v65)

                            if v65 ~= nil and v65:GetAttribute("ModalDialog") == true then
                                v78 = nil
                            end

                            if v78 then
                                t4[v73] = v78
                                revealSelection(v78)
                            end

                            if GuiService.SelectedObject ~= v78 then
                                GuiService.SelectedObject = v78
                            end

                            GuiService.GuiNavigationEnabled = v78 ~= nil
                        end
                    else
                        MenuNavigation.SetContext(nil, nil)
                        ButtonHintStrip.Retract("NavigationSwitch")
                        ButtonHintStrip.Retract("NavigationMode")
                        ButtonHintStrip.SetNavigationLayer(nil)

                        local SelectedObject = GuiService.SelectedObject
                        local v76 = false

                        if SelectedObject ~= nil then
                            local LayerCollector = SelectedObject:FindFirstAncestorWhichIsA("LayerCollector")

                            v76 = LayerCollector ~= nil and v3[LayerCollector.Name] == true
                        end

                        if v76 then
                            GuiService.GuiNavigationEnabled = true
                        else
                            if GuiService.SelectedObject ~= nil then
                                GuiService.SelectedObject = nil
                            end

                            GuiService.GuiNavigationEnabled = false
                        end
                    end
                end

                v12 = false
            end
        end

        local function requestReconcile() -- line: 417
            -- upvalues: v11 (ref), reconcile (copy)
            if not v11 then
                v11 = true
                task.defer(function() -- line: 420
                    -- upvalues: v11 (ref), reconcile (copy)
                    v11 = false
                    reconcile()
                end)
            end
        end

        local function observe(p29) -- line: 426
            -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), v11 (ref), v12 (ref), reconcile (copy), requestReconcile (copy), GuiService (copy), GamepadBindings (copy), MenuNavigation (copy), v2 (copy)
            if t5[p29] then
                return
            end

            t5[p29] = true

            local v83 = if p29:IsA("ScreenGui") then p29 else p29:FindFirstAncestorOfClass("ScreenGui")

            if v83 == nil or not v2[v83.Name] then
                GamepadBindings.Inspect(p29)
            end

            if p29:IsA("LayerCollector") then
                p29:GetPropertyChangedSignal("Enabled"):Connect(requestReconcile)

                if p29.Name == "PendingPurchase" then
                    local function purchaseChanged() -- line: 440
                        -- upvalues: p29 (copy), MenuNavigation (copy)
                        MenuNavigation.Suspend("Purchase", p29.Enabled)
                    end

                    p29:GetPropertyChangedSignal("Enabled"):Connect(purchaseChanged)
                    MenuNavigation.Suspend("Purchase", p29.Enabled)
                end
            elseif p29:IsA("GuiObject") then
                p29:GetPropertyChangedSignal("Visible"):Connect(requestReconcile)

                if p29:IsA("GuiButton") or p29:IsA("TextBox") then
                    p29:GetPropertyChangedSignal("Active"):Connect(requestReconcile)
                    p29:GetPropertyChangedSignal("Interactable"):Connect(function() -- line: 448
                        -- upvalues: v11 (ref), v12 (ref), reconcile (copy)
                        if v12 or v11 then
                            return
                        end

                        v11 = true
                        task.defer(function() -- line: 420
                            -- upvalues: v11 (ref), reconcile (copy)
                            v11 = false
                            reconcile()
                        end)
                    end)
                    p29:GetAttributeChangedSignal("ConsoleNavigationDisabled"):Connect(requestReconcile)
                end

                p29:GetPropertyChangedSignal("Selectable"):Connect(function() -- line: 454
                    -- upvalues: v11 (ref), v12 (ref), reconcile (copy)
                    if v12 or v11 then
                        return
                    end

                    v11 = true
                    task.defer(function() -- line: 420
                        -- upvalues: v11 (ref), reconcile (copy)
                        v11 = false
                        reconcile()
                    end)
                end)
                p29:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 457
                    -- upvalues: p29 (copy), v11 (ref), reconcile (copy), GuiService (copy), MenuNavigation (copy)
                    if GuiService.SelectedObject ~= p29 or MenuNavigation.IsCursorActive() or v11 then
                        return
                    end

                    v11 = true
                    task.defer(function() -- line: 420
                        -- upvalues: v11 (ref), reconcile (copy)
                        v11 = false
                        reconcile()
                    end)
                end)
            end

            p29.Destroying:Once(function() -- line: 461
                -- upvalues: p29 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), v11 (ref), reconcile (copy)
                t5[p29] = nil

                if p29:IsA("ScreenGui") then
                    t4[p29] = nil
                elseif p29:IsA("GuiObject") then
                    t2[p29] = nil
                    t3[p29] = nil

                    if p29:IsA("GuiButton") then
                        t6[p29] = nil
                    end
                end

                if p29:IsA("GuiObject") then
                    for v84, v85 in t4 do
                        if v85 == p29 then
                            t4[v84] = nil
                        end
                    end
                end

                if not v11 then
                    v11 = true
                    task.defer(function() -- line: 420
                        -- upvalues: v11 (ref), reconcile (copy)
                        v11 = false
                        reconcile()
                    end)
                end
            end)
        end

        for _, v86 in { "ShopButton", "IndexButton", "EggsButton", "PetsButton" } do
            local Game = Hud.Find(v86, "Game")
            local Treadmill = Hud.Find(v86, "Treadmill")
            local GamepadGlyph = if Game then Game:FindFirstChild("GamepadGlyph") else nil

            if GamepadGlyph and Treadmill and not Treadmill:FindFirstChild("GamepadGlyph") then
                GamepadGlyph:Clone().Parent = Treadmill
            end
        end

        for _, descendant in v5:GetDescendants() do
            observe(descendant)
        end

        for _, child in v5:GetChildren() do
            observe(child)
        end

        v5.DescendantAdded:Connect(function(p30) -- line: 503
            -- upvalues: v11 (ref), reconcile (copy), observe (copy)
            observe(p30)

            if not v11 then
                v11 = true
                task.defer(function() -- line: 420
                    -- upvalues: v11 (ref), reconcile (copy)
                    v11 = false
                    reconcile()
                end)
            end
        end)
        v5.DescendantRemoving:Connect(requestReconcile)
        GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 508
            -- upvalues: t4 (copy), v6 (ref), v7 (ref), v11 (ref), v12 (ref), isCursorScopeMember (copy), isEligibleSelection (copy), revealSelection (copy), reconcile (copy), GuiService (copy), GamepadBindings (copy), PlatformController (copy), MenuNavigation (copy), v3 (copy)
            if v12 or MenuNavigation.IsSuspended() then
                return
            end

            local v87 = v7
            local SelectedObject = GuiService.SelectedObject

            if MenuNavigation.IsCursorActive() then
                if not (not SelectedObject or v87 ~= nil and isCursorScopeMember(SelectedObject, v87) and SelectedObject.Selectable and SelectedObject.Interactable and GamepadBindings.IsOnScreen(SelectedObject) and SelectedObject:GetAttribute("ConsoleNavigationDisabled") ~= true and (not SelectedObject:IsA("GuiButton") or SelectedObject.Active)) then
                    GuiService.SelectedObject = nil
                end

                GuiService.GuiNavigationEnabled = true
            elseif v87 == nil or not isEligibleSelection(v87, SelectedObject) then
                if v87 ~= nil then
                    local v88 = v6

                    if v88 == nil or v88:GetAttribute("ModalDialog") ~= true then
                        if not v11 then
                            v11 = true
                            task.defer(function() -- line: 420
                                -- upvalues: v11 (ref), reconcile (copy)
                                v11 = false
                                reconcile()
                            end)
                        end

                        return
                    end
                end

                if PlatformController.IsConsole() and v87 == nil then
                    local v89 = false

                    if SelectedObject ~= nil then
                        local LayerCollector = SelectedObject:FindFirstAncestorWhichIsA("LayerCollector")

                        v89 = LayerCollector ~= nil and v3[LayerCollector.Name] == true
                    end

                    GuiService.GuiNavigationEnabled = v89
                end
            else
                t4[v87] = SelectedObject
                revealSelection(SelectedObject)
            end
        end)
        MenuNavigation.Changed:Connect(requestReconcile)
        MenuNavigation.SaveFailed:Connect(function() -- line: 534
            -- upvalues: Toast (copy)
            Toast.Show({
                Text = "Navigation changed for this session, but could not be saved. Please try again in Settings.",
                Seconds = 6,
                WrapText = true
            })
        end)
        MenuNavigation.CursorFailed:Connect(function() -- line: 537
            -- upvalues: Toast (copy)
            Toast.Show({
                Text = "Cursor unavailable. Button navigation is still available.",
                Seconds = 5
            })
        end)
        PlatformController.Changed:Connect(requestReconcile)
        Tabs.Activated:Connect(requestReconcile)
        Tabs.Deactivated:Connect(requestReconcile)
        UserInputService.InputBegan:Connect(function(p31, p32) -- line: 544
            -- upvalues: v4 (copy), v11 (ref), v13 (ref), reconcile (copy), GamepadBindings (copy), MenuNavigation (copy), ButtonL3 (copy), ButtonB (copy)
            if MenuNavigation.IsSuspended() or p32 then
                return
            end

            if p31.KeyCode == ButtonL3 then
                local v90 = not v13
                local v91 = ("pressed %*"):format(p31.KeyCode.Name)

                if v13 ~= v90 then
                    v13 = v90
                    GamepadBindings.EnableMarkers(not v90)
                    v4:AtDebug():Log((("HUD navigation %* (%*); toggle key is %*"):format(v90 and "ON" or "OFF", v91, ButtonL3.Name)))
                end

                if not v11 then
                    v11 = true
                    task.defer(function() -- line: 420
                        -- upvalues: v11 (ref), reconcile (copy)
                        v11 = false
                        reconcile()
                    end)
                end
            elseif p31.KeyCode == ButtonB and v13 then
                local v92 = ("pressed %*"):format(p31.KeyCode.Name)

                if v13 ~= false then
                    v13 = false
                    GamepadBindings.EnableMarkers(true)
                    v4:AtDebug():Log((("HUD navigation OFF (%*); toggle key is %*"):format(v92, ButtonL3.Name)))
                end

                if v11 then
                    return
                end

                v11 = true
                task.defer(function() -- line: 420
                    -- upvalues: v11 (ref), reconcile (copy)
                    v11 = false
                    reconcile()
                end)
            end
        end)

        local t7 = {}
        local t8 = {}

        local function switchNavigation(p33) -- line: 564
            -- upvalues: v7 (ref), t8 (copy), MenuNavigation (copy)
            local v93

            if p33.KeyCode ~= MenuNavigation.SwitchKey then
                v93 = true

                return not v93
            end

            if v7 == nil or MenuNavigation.IsSuspended() then
                v93 = true
            else
                local UserInputType = p33.UserInputType

                if not t8[UserInputType] then
                    t8[UserInputType] = true
                    MenuNavigation.Toggle()
                end

                v93 = false
            end

            return not v93
        end

        UserInputService.InputBegan:Connect(function(p34) -- line: 577
            -- upvalues: v7 (ref), t8 (copy), MenuNavigation (copy)
            if p34.KeyCode ~= MenuNavigation.SwitchKey or v7 == nil or MenuNavigation.IsSuspended() then
                return
            end

            local UserInputType = p34.UserInputType

            if not t8[UserInputType] then
                t8[UserInputType] = true
                MenuNavigation.Toggle()
            end
        end)
        UserInputService.InputEnded:Connect(function(p35) -- line: 581
            -- upvalues: t8 (copy), MenuNavigation (copy)
            if p35.KeyCode == MenuNavigation.SwitchKey then
                t8[p35.UserInputType] = nil
            end
        end)
        UserInputService.GamepadDisconnected:Connect(function(p36) -- line: 586
            -- upvalues: t8 (copy)
            t8[p36] = nil
        end)
        UserInputService.WindowFocusReleased:Connect(function() -- line: 589
            -- upvalues: t7 (copy), t8 (copy)
            table.clear(t8)
            table.clear(t7)
        end)
        ContextActionService:BindActionAtPriority("MenuNavigationSwitch", function(_, p38, p39) -- line: 596
            -- upvalues: v4 (copy), v7 (ref), v9 (ref), v11 (ref), v13 (ref), reconcile (copy), t7 (copy), t8 (copy), GamepadBindings (copy), MenuNavigation (copy), ButtonL3 (copy)
            local KeyCode = p39.KeyCode

            if p38 == Enum.UserInputState.Cancel then
                local v94 = next(t7) ~= nil

                table.clear(t7)
                table.clear(t8)

                if v94 then
                    return Enum.ContextActionResult.Sink
                end
            elseif p38 == Enum.UserInputState.Begin then
                if v7 ~= nil and not MenuNavigation.IsSuspended() then
                    if KeyCode == MenuNavigation.SwitchKey then
                        t7[KeyCode] = true

                        if p39.KeyCode == MenuNavigation.SwitchKey and v7 ~= nil and not MenuNavigation.IsSuspended() then
                            local UserInputType = p39.UserInputType

                            if not t8[UserInputType] then
                                t8[UserInputType] = true
                                MenuNavigation.Toggle()
                            end
                        end

                        return Enum.ContextActionResult.Sink
                    end

                    if KeyCode == Enum.KeyCode.ButtonB then
                        if v9 and v9.Back and (MenuNavigation.IsCursorActive() or v9.BackInButtons) then
                            t7[KeyCode] = true
                            v9.Back()

                            return Enum.ContextActionResult.Sink
                        end

                        if v13 then
                            t7[KeyCode] = true

                            if v13 ~= false then
                                v13 = false
                                GamepadBindings.EnableMarkers(true)
                                v4:AtDebug():Log((("HUD navigation OFF (Back); toggle key is %*"):format(ButtonL3.Name)))
                            end

                            if not v11 then
                                v11 = true
                                task.defer(function() -- line: 420
                                    -- upvalues: v11 (ref), reconcile (copy)
                                    v11 = false
                                    reconcile()
                                end)
                            end

                            return Enum.ContextActionResult.Sink
                        end
                    end
                end
            else
                local v95 = t7[KeyCode]

                if p38 == Enum.UserInputState.End then
                    t7[KeyCode] = nil

                    if KeyCode == MenuNavigation.SwitchKey then
                        t8[p39.UserInputType] = nil
                    end
                end

                if v95 then
                    return Enum.ContextActionResult.Sink
                end
            end

            return Enum.ContextActionResult.Pass
        end, false, Enum.ContextActionPriority.High.Value + 250, MenuNavigation.SwitchKey, Enum.KeyCode.ButtonB)
        GuiService.AutoSelectGuiEnabled = false
        GamepadBindings.Rescan(PlatformController.Platform())
        reconcile()
        v4:AtInfo():Log("Console navigation initialized")
    end
}
