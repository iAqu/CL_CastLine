local GuiAnimation = {}

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local FovController = require(ReplicatedStorage.Modules.FovController)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local HomeHudTransition = require(ReplicatedStorage.Modules.HomeHudTransition)
local HoverGuiClient = require(ReplicatedStorage.Modules.HoverGuiClient)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Blur = game.Lighting:WaitForChild("Blur")

local HomeGui = PlayerGui:WaitForChild("HomeGui") :: ScreenGui

local originalSizes: { [ScreenGui]: UDim2 } = {}
local activeTweens: { [ScreenGui]: { Tween } } = {}
local guis: { ScreenGui } = {}
local transitions: { [ScreenGui]: (boolean, boolean) -> () } = {}
local watchedPopups: { [ScreenGui]: { RBXScriptConnection } } = {}
local pendingOpen: ScreenGui? = nil
local openGeneration = 0
local guiOpenSpeed = 0.18
local guiCloseSpeed = 0.1
-- local guiCloseSpeed = 0.3   -- for testing

type NavigationEntry = {
    gui: ScreenGui,
    previousSelection: GuiObject?,
    canGoBack: (() -> boolean)?,
}

local GAMEPAD_BACK_ACTION = "AFPopupBack"
local GAMEPAD_BACK_PRIORITY = Enum.ContextActionPriority.High.Value + 100
local navigationStack: { NavigationEntry } = {}
local rememberedSelections: { [ScreenGui]: GuiObject } = setmetatable({}, { __mode = "kv" })
local initialFocuses: { [ScreenGui]: GuiObject } = setmetatable({}, { __mode = "kv" })
local backHandlers: { [ScreenGui]: () -> () } = setmetatable({}, { __mode = "k" })
local changingSelection = false

local function findMainFrame(gui: ScreenGui): Frame?
    local mainFrame = gui:FindFirstChild("Frame") or gui:FindFirstChild("Main")
    if mainFrame and mainFrame:IsA("Frame") then
        return mainFrame
    end
    return nil
end

local blur_default_size

local function isUsingGamepad(): boolean
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

local function enableGamepadNavigation()
    GuiService.GuiNavigationEnabled = true
    GuiService.AutoSelectGuiEnabled = true
end

local function isVisibleWithin(guiObject: GuiObject, gui: ScreenGui): boolean
    if not gui.Enabled or not guiObject:IsDescendantOf(gui) then
        return false
    end

    local current: Instance? = guiObject
    while current and current ~= gui do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        current = current.Parent
    end
    return current == gui
end

local function isSelectable(guiObject: GuiObject?, gui: ScreenGui): boolean
    return guiObject ~= nil
        and guiObject.Parent ~= nil
        and guiObject.Active
        and guiObject.Selectable
        and guiObject.Interactable
        and isVisibleWithin(guiObject, gui)
end

local function navigationRoot(gui: ScreenGui): GuiObject?
    local frame = findMainFrame(gui)
    if frame and frame:IsA("GuiObject") then
        return frame
    end
    for _, child in gui:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            return child
        end
    end
    return nil
end

local function firstSelectable(gui: ScreenGui): GuiObject?
    local root = navigationRoot(gui)
    if not root then
        return nil
    end

    local fallback: GuiObject? = nil
    for _, descendant in root:GetDescendants() do
        if descendant:IsA("GuiObject") and isSelectable(descendant, gui) then
            fallback = fallback or descendant
            local lowerName = string.lower(descendant.Name)
            if not string.find(lowerName, "close", 1, true)
                and not string.find(lowerName, "exit", 1, true)
                and not string.find(lowerName, "cancel", 1, true)
            then
                return descendant
            end
        end
    end
    return fallback
end

local function revealSelection(guiObject: GuiObject)
    local ancestor = guiObject.Parent
    while ancestor do
        if ancestor:IsA("ScrollingFrame") then
            local relativePosition = guiObject.AbsolutePosition - ancestor.AbsolutePosition + ancestor.CanvasPosition
            local canvasPosition = ancestor.CanvasPosition
            local windowSize = ancestor.AbsoluteWindowSize
            local targetX = canvasPosition.X
            local targetY = canvasPosition.Y

            if relativePosition.X < canvasPosition.X then
                targetX = relativePosition.X
            elseif relativePosition.X + guiObject.AbsoluteSize.X > canvasPosition.X + windowSize.X then
                targetX = relativePosition.X + guiObject.AbsoluteSize.X - windowSize.X
            end
            if relativePosition.Y < canvasPosition.Y then
                targetY = relativePosition.Y
            elseif relativePosition.Y + guiObject.AbsoluteSize.Y > canvasPosition.Y + windowSize.Y then
                targetY = relativePosition.Y + guiObject.AbsoluteSize.Y - windowSize.Y
            end

            ancestor.CanvasPosition = Vector2.new(math.max(0, targetX), math.max(0, targetY))
        end
        ancestor = ancestor.Parent
    end
end

local function topNavigationEntry(): NavigationEntry?
    while #navigationStack > 0 do
        local entry = navigationStack[#navigationStack]
        if entry.gui.Parent and entry.gui.Enabled then
            return entry
        end
        GameplayInputGate.SetActive("Popup", entry.gui, false)
        table.remove(navigationStack)
    end
    return nil
end

local function focusTopGui()
    if not isUsingGamepad() or GuiService.MenuIsOpen then
        return
    end

    local entry = topNavigationEntry()
    if not entry then
        return
    end

    local gui = entry.gui
    local target = rememberedSelections[gui]
    if not isSelectable(target, gui) then
        target = initialFocuses[gui]
    end
    if not isSelectable(target, gui) then
        target = firstSelectable(gui)
    end
    if not target then
        return
    end

    changingSelection = true
    enableGamepadNavigation()
    GuiService.SelectedObject = target
    changingSelection = false
    revealSelection(target)
end

local homeSelection: GuiObject? = nil

local function restoreHomeSelection()
    if not isUsingGamepad() or GuiService.MenuIsOpen or topNavigationEntry() then
        return
    end
    local previous = homeSelection
    homeSelection = nil
    local current = GuiService.SelectedObject
    if (not current or current:IsDescendantOf(HomeGui)) and isSelectable(previous, HomeGui) then
        GuiService.SelectedObject = previous
    end
end

local homeHud = HomeHudTransition.new(HomeGui, restoreHomeSelection)

local function updateHomeHud()
    local shouldHide = pendingOpen ~= nil
    if not shouldHide then
        for gui in pairs(watchedPopups) do
            if gui.Enabled and gui:IsDescendantOf(PlayerGui) then
                shouldHide = true
                break
            end
        end
    end
    if shouldHide and homeHud.IsInteractive() then
        local selection = GuiService.SelectedObject
        if selection and selection:IsDescendantOf(HomeGui) then
            homeSelection = selection
            GuiService.SelectedObject = nil
        end
        HoverGuiClient.HideInfoHover()
    end
    homeHud.SetHidden(shouldHide)
end

local function pushNavigation(
    gui: ScreenGui,
    initialFocus: GuiObject?,
    backHandler: (() -> ())?,
    canGoBack: (() -> boolean)?
)
    local previousSelection = GuiService.SelectedObject
    for index = #navigationStack, 1, -1 do
        if navigationStack[index].gui == gui then
            previousSelection = navigationStack[index].previousSelection
            table.remove(navigationStack, index)
        end
    end

    if initialFocus then
        initialFocuses[gui] = initialFocus
    end
    if backHandler then
        backHandlers[gui] = backHandler
    end

    table.insert(navigationStack, {
        gui = gui,
        previousSelection = previousSelection,
        canGoBack = canGoBack,
    })
    GameplayInputGate.SetActive("Popup", gui, true)
    task.defer(focusTopGui)
    task.delay(0.1, focusTopGui)
end

local function popNavigation(gui: ScreenGui)
    local removed: NavigationEntry? = nil
    local topEntry = navigationStack[#navigationStack]
    local wasTop = topEntry ~= nil and topEntry.gui == gui
    for index = #navigationStack, 1, -1 do
        if navigationStack[index].gui == gui then
            removed = table.remove(navigationStack, index)
            break
        end
    end
    GameplayInputGate.SetActive("Popup", gui, false)

    if not wasTop then
        return
    end

    local selectedObject = GuiService.SelectedObject
    if selectedObject and selectedObject:IsDescendantOf(gui) then
        GuiService.SelectedObject = nil
    end

    if topNavigationEntry() then
        task.defer(focusTopGui)
    elseif isUsingGamepad() and not GuiService.MenuIsOpen and removed then
        local previous = removed.previousSelection
        local previousGui = previous and previous:FindFirstAncestorWhichIsA("ScreenGui")
        if previousGui == HomeGui and not homeHud.IsInteractive() then
            homeSelection = homeSelection or previous
        elseif previousGui and previousGui:IsDescendantOf(PlayerGui) and isSelectable(previous, previousGui) then
            GuiService.SelectedObject = previous
        elseif homeHud.IsInteractive() then
            restoreHomeSelection()
        end
    end
end

local function watchPopup(gui: ScreenGui)
    if watchedPopups[gui] then
        return
    end
    watchedPopups[gui] = {
        gui:GetPropertyChangedSignal("Enabled"):Connect(function()
            if not gui.Enabled then
                popNavigation(gui)
            end
            task.defer(updateHomeHud)
        end),
        gui.Destroying:Connect(function()
            for _, connection in watchedPopups[gui] do
                connection:Disconnect()
            end
            watchedPopups[gui] = nil
            popNavigation(gui)
            task.defer(updateHomeHud)
        end),
        gui.AncestryChanged:Connect(function()
            if not gui:IsDescendantOf(PlayerGui) then
                popNavigation(gui)
            end
            task.defer(updateHomeHud)
        end),
    }
    task.defer(updateHomeHud)
end

function GuiAnimation.SetNavigationOptions(
    gui: ScreenGui,
    initialFocus: GuiObject?,
    backHandler: (() -> ())?
)
    if initialFocus then
        initialFocuses[gui] = initialFocus
    end
    if backHandler then
        backHandlers[gui] = backHandler
    end
end

function GuiAnimation.ResetNavigationFocus(gui: ScreenGui, initialFocus: GuiObject)
    rememberedSelections[gui] = nil
    initialFocuses[gui] = initialFocus
end

function GuiAnimation.RefreshNavigationFocus(gui: ScreenGui)
    local entry = topNavigationEntry()
    if entry and entry.gui == gui then
        task.defer(focusTopGui)
    end
end

function GuiAnimation.PushModal(
    gui: ScreenGui,
    initialFocus: GuiObject?,
    backHandler: (() -> ())?,
    canGoBack: (() -> boolean)?
)
    pushNavigation(gui, initialFocus, backHandler, canGoBack)
end

function GuiAnimation.PopModal(gui: ScreenGui)
    popNavigation(gui)
end

local function onGamepadBack(
    _actionName: string,
    inputState: Enum.UserInputState,
    _inputObject: InputObject
): Enum.ContextActionResult
    if inputState ~= Enum.UserInputState.Begin or not isUsingGamepad() or GuiService.MenuIsOpen then
        return Enum.ContextActionResult.Pass
    end

    local entry = topNavigationEntry()
    if not entry or (entry.canGoBack and not entry.canGoBack()) then
        return Enum.ContextActionResult.Pass
    end

    local focusedTextBox = UserInputService:GetFocusedTextBox()
    if focusedTextBox then
        focusedTextBox:ReleaseFocus()
        return Enum.ContextActionResult.Sink
    end

    task.defer(function()
        if GuiService.MenuIsOpen or topNavigationEntry() ~= entry then
            return
        end
        local handler = backHandlers[entry.gui]
        if handler then
            handler()
        else
            GuiAnimation.CloseGui(entry.gui)
        end
    end)
    return Enum.ContextActionResult.Sink
end

ContextActionService:BindActionAtPriority(
    GAMEPAD_BACK_ACTION,
    onGamepadBack,
    false,
    GAMEPAD_BACK_PRIORITY,
    Enum.KeyCode.ButtonB
)

GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
    if changingSelection then
        return
    end
    local entry = topNavigationEntry()
    if not entry or not isUsingGamepad() then
        return
    end

    local selectedObject = GuiService.SelectedObject
    if isSelectable(selectedObject, entry.gui) then
        rememberedSelections[entry.gui] = selectedObject :: GuiObject
        revealSelection(selectedObject :: GuiObject)
        return
    end

    task.defer(focusTopGui)
end)

UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
    if isUsingGamepad() then
        enableGamepadNavigation()
        task.defer(focusTopGui)
        return
    end

    local entry = topNavigationEntry()
    local selectedObject = GuiService.SelectedObject
    if entry and selectedObject and selectedObject:IsDescendantOf(entry.gui) then
        GuiService.SelectedObject = nil
    end
end)

if isUsingGamepad() then
    enableGamepadNavigation()
end

local POPUP_GUI_NAMES = {
    "RebirthGui",
    "StoreGui",
    "SettingsGui",
    "RodShopGui",
    "SellGui",
    "MyFishGui",
    "UpdateLogGui",
    "OnlineRewardGui",
    "DailyRewardGui",
    "IndexGui_New",
    "PetGui",
    "StarterPackGui",
    "SpinningWheelGui",
    "TradeGui",
    "TradeMenuGui",
    "UgcListGui",
    "AchievementGui",
    "SeasonGui",
    "DiamondBuyGui",
    "StoreGiftMenuGui",
    "SuperRebirthGui",
    "LongDailyRewardGui",
    "LimitedPackListGui",
    "LimitedPackDetailGui",
    "OnlineQuestGui",
    "LimitedStarterPackGui",
    "LimitedAdvancedPackGui",
    "LimitedChristmasPackGui",
    "ChristmasDailyRewardGui",
    "LimitedSquidPackGui",
    "HareDailyRewardGui",
    "GroupRewardGui",
}

-- 已移除模板的弹窗不参与启动等待。
local POPUP_GUI_WAIT_SECONDS = 10

local PopupGuis: { ScreenGui } = {}
for _, guiName in ipairs(POPUP_GUI_NAMES) do
    local gui = PlayerGui:FindFirstChild(guiName)
    if not gui then
        if not StarterGui:FindFirstChild(guiName) then
            continue
        end
        gui = PlayerGui:WaitForChild(guiName, POPUP_GUI_WAIT_SECONDS)
    end
    if gui and gui:IsA("ScreenGui") then
        table.insert(PopupGuis, gui)
    else
        warn("GuiAnimation: popup gui missing or not a ScreenGui:", guiName)
    end
end

function GuiAnimation.IsPopupGui(gui: ScreenGui): boolean
    for _, popupGui in pairs(PopupGuis) do
        if gui == popupGui then return true end
    end
    return false
end

local function cancelGuiTweens(gui: ScreenGui)
    local tweens = activeTweens[gui]
    if not tweens then
        return
    end

    for _, tween in tweens do
        tween:Cancel()
    end
    table.clear(tweens)
end

local function trackTween(gui: ScreenGui, tween: Tween)
    local tweens = activeTweens[gui]
    if not tweens then
        tweens = {}
        activeTweens[gui] = tweens
    end
    table.insert(tweens, tween)

    tween.Completed:Connect(function()
        local currentTweens = activeTweens[gui]
        if not currentTweens then
            return
        end
        local index = table.find(currentTweens, tween)
        if index then
            table.remove(currentTweens, index)
        end
    end)
end

local function isValidOriginalSize(size: UDim2?): boolean
    return size ~= nil and size.X.Scale >= 0.15 and size.Y.Scale >= 0.15
end

local function getOriginalSize(gui: ScreenGui, mainFrame: Frame): UDim2
    local size = originalSizes[gui]
    if isValidOriginalSize(size) then
        return size :: UDim2
    end

    if isValidOriginalSize(mainFrame.Size) then
        size = mainFrame.Size
    else
        warn("GuiAnimation: invalid original size for", gui.Name, "- using fallback")
        size = UDim2.fromScale(0.6, 0.8)
    end

    originalSizes[gui] = size
    return size
end

function GuiAnimation.Setup(gui: ScreenGui)
    if not gui:IsA("ScreenGui") then
        warn("Not ScreenGui:", gui.Name)
        return
    end
    local mainFrame = findMainFrame(gui)
    if not mainFrame then
        warn("Gui frame not found:", gui.Name)
        return
    end

    local size = mainFrame.Size
    local existing = originalSizes[gui]
    if not isValidOriginalSize(existing) and isValidOriginalSize(size) then
        originalSizes[gui] = size
    end

    if not table.find(guis, gui) then
        table.insert(guis, gui)
    end

    gui.Enabled = false
    mainFrame.Visible = true
    blur_default_size = Blur.Size
    watchPopup(gui)
end

function GuiAnimation.SetTransition(gui: ScreenGui, transition: (boolean, boolean) -> ())
    transitions[gui] = transition
    watchPopup(gui)
end

function GuiAnimation.CloseGui(gui: ScreenGui, immediately: boolean?)
    if pendingOpen == gui then
        openGeneration += 1
        pendingOpen = nil
        task.defer(updateHomeHud)
    end
    local transition = transitions[gui]
    if transition then
        transition(false, immediately == true)
        if not gui.Enabled then
            popNavigation(gui)
        end
        return
    end

    if not gui.Enabled then
        return
    end
    local mainFrame = findMainFrame(gui)
    if not mainFrame then
        warn("Gui frame not found:", gui.Name)
        return
    end

    cancelGuiTweens(gui)
    popNavigation(gui)

    local originalSize = getOriginalSize(gui, mainFrame)
    local tweenInfo = TweenInfo.new(guiCloseSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.fromScale(0.1, 0.1)})
    local blurTween = TweenService:Create(Blur, tweenInfo, {Size = 0})
    trackTween(gui, closeTween)
    trackTween(gui, blurTween)
    blurTween:Play()
    closeTween:Play()
    FovController.SetBaseFOV(FovController.DEFAULT_BASE_FOV)
    closeTween.Completed:Connect(function(playbackState)
        if playbackState ~= Enum.PlaybackState.Completed then
            return
        end
        gui.Enabled = false
        mainFrame.Size = originalSize
        Blur.Enabled = false
    end)
end

local function closeGuis(except: ScreenGui?): boolean
    local needsWait = false
    for _, gui in pairs(guis) do
        if not gui:IsA("ScreenGui") then
            warn("Not ScreenGui:", gui.Name)
            continue
        end
        if not gui.Enabled or gui == except then continue end
        if transitions[gui] then
            GuiAnimation.CloseGui(gui, true)
        else
            needsWait = true
            coroutine.wrap(GuiAnimation.CloseGui)(gui)
        end
    end
    return needsWait
end

function GuiAnimation.CloseAllGuis()
    openGeneration += 1
    pendingOpen = nil
    closeGuis(nil)
    task.defer(updateHomeHud)
end

function GuiAnimation.OpenGui(gui: ScreenGui)
    local transition = transitions[gui]
    local mainFrame = findMainFrame(gui)
    if not transition and not mainFrame then
        warn("Gui frame not found:", gui.Name)
        return
    end
    if not gui:IsDescendantOf(PlayerGui) then
        return
    end

    openGeneration += 1
    local generation = openGeneration
    pendingOpen = gui
    watchPopup(gui)
    updateHomeHud()
    if closeGuis(gui) then
        task.wait(guiCloseSpeed + 0.01)
    end
    if generation ~= openGeneration then
        return
    end
    pendingOpen = nil
    if not gui:IsDescendantOf(PlayerGui) then
        task.defer(updateHomeHud)
        return
    end

    if transition then
        transition(true, false)
        if gui.Enabled then
            pushNavigation(gui, initialFocuses[gui], backHandlers[gui])
        end
        task.defer(updateHomeHud)
        return
    end

    local frame = mainFrame :: Frame

    if not isValidOriginalSize(originalSizes[gui]) then
        GuiAnimation.Setup(gui)
    end

    cancelGuiTweens(gui)

    local originalSize = getOriginalSize(gui, frame)
    frame.Size = UDim2.fromScale(0.5, 0.5)

    gui.Enabled = true
    gui.DisplayOrder = 100
    Blur.Enabled = true
    Blur.Size = 0

    local tweenInfo = TweenInfo.new(guiOpenSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local openTween = TweenService:Create(frame, tweenInfo, {Size = originalSize})
    local blurTween = TweenService:Create(Blur, tweenInfo, {Size = blur_default_size})
    trackTween(gui, openTween)
    trackTween(gui, blurTween)

    openTween:Play()
    blurTween:Play()
    FovController.SetBaseFOV(FovController.GUI_BASE_FOV)
    pushNavigation(gui, initialFocuses[gui], backHandlers[gui])
end

function GuiAnimation.IsAllPopupGuisClosed(): boolean
    for _, popupGui in pairs(PopupGuis) do
        if popupGui.Enabled == true then
            return false
        end
    end
    return true
end

-- Init
for _, gui in pairs(PopupGuis) do
    GuiAnimation.Setup(gui)

    gui:GetPropertyChangedSignal("Enabled"):Connect(function()
        -- check if all popup guis are closed, then reset blur
        local isAllPopupGuisClosed = GuiAnimation.IsAllPopupGuisClosed()
        if isAllPopupGuisClosed then
            Blur.Enabled = false
            FovController.SetBaseFOV(FovController.DEFAULT_BASE_FOV)
        end
    end)
end

GuiService.MenuOpened:Connect(function()
    local entry = topNavigationEntry()
    local selectedObject = GuiService.SelectedObject
    if entry and selectedObject and selectedObject:IsDescendantOf(entry.gui) then
        GuiService.SelectedObject = nil
    end
end)

GuiService.MenuClosed:Connect(function()
    task.defer(focusTopGui)
    if homeHud.IsInteractive() then
        task.defer(restoreHomeSelection)
    end
end)

GuiAnimation.PopupGuis = PopupGuis

return GuiAnimation
