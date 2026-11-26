local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local SocialService = game:GetService("SocialService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local BackpackConfig = require(ReplicatedStorage.Modules.BackpackConfig)
local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local Icon = require(ReplicatedStorage.Libs.Icon)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local RebirthDataHelper = require(ReplicatedFirst.DataHelpers.RebirthDataHelper)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local HomeGui = PlayerGUI:WaitForChild("HomeGui")
local TopFrame = HomeGui.TopFrame
local BottomFrame = HomeGui.BottomFrame
local LeaderboardButton = TopFrame:WaitForChild("LeaderboardButton") :: TextButton
-- local NotificationLabel = TopFrame.NotificationLabel

-- local EventButton = TopFrame.EventButton -- EventButton 功能已禁用
-- local WeaponButton = BottomFrame.WeaponButton

-- local DashFrame = HomeGui.DashFrame

local LeftFrame = HomeGui.LeftFrame

local RightFrame = HomeGui:FindFirstChild("RightFrame")
if not RightFrame then
    error("HomeGui.RightFrame missing; check Studio UI hierarchy")
end
local HomeButton = RightFrame.HomeButton
-- local CurrencyFrame = LeftFrame.CurrencyFrame


-- local EventButton = RightFrame.EventButton

local CurrencyFrame = BottomFrame:FindFirstChild("CurrencyFrame")
if not CurrencyFrame then
    error("HomeGui.BottomFrame.CurrencyFrame missing; check Studio UI hierarchy")
end

local LeftMenuFrame = LeftFrame:WaitForChild("MenuFrame")
local RightMenuFrame = RightFrame:WaitForChild("MenuFrame")
-- local DoubleSpeedButton = RightFrame.DoubleSpeedButton


-- local ChristmasTokenFrame = CurrencyFrame.ChristmasTokenFrame
local WinsFrame = CurrencyFrame.Wins
local TrophyFrame = CurrencyFrame:FindFirstChild("Trophy")
local WinsShadowLabel = WinsFrame.WinsShadowLabel
local WinsLabel = WinsShadowLabel.WinsLabel
local TrophyShadowLabel = TrophyFrame and TrophyFrame:FindFirstChild("TrophyShadowLabel")
local TrophyLabel = TrophyShadowLabel and TrophyShadowLabel:FindFirstChild("TrophyLabel")
local LuckFrame = CurrencyFrame:FindFirstChild("Luck")
local LuckShadowLabel = LuckFrame and LuckFrame:FindFirstChild("LuckShadowLabel")
local LuckLabel = LuckShadowLabel and LuckShadowLabel:FindFirstChild("LuckLabel")
local StoreButton = LeftMenuFrame.StoreFrame.StoreButton
local StoreDot = StoreButton.Dot
local RebirthButton = RightMenuFrame.RebirthFrame.RebirthButton
local InviteButon = RightMenuFrame.InviteFrame.InviteButton
local AchievementButton = RightMenuFrame.AchievementFrame.AchievementButton

local RebirthDot = RebirthButton.Dot
local AchievementDot = AchievementButton.Dot

-- local RightFrame = HomeGui.RightFrame
-- local RightMenuFrame = RightFrame.MenuFrame
-- local CodeButton = RightMenuFrame.CodeFrame.CodeButton
-- local SettingButton = RightMenuFrame.SettingFrame.SettingButton
-- local LimitedUgcButton = RightFrame.LimitedUgcButton

local IndexFrame = LeftMenuFrame:FindFirstChild("IndexFrame")
local IndexButton = IndexFrame and IndexFrame:FindFirstChild("IndexButton")
local IndexDot = IndexButton and IndexButton:FindFirstChild("Dot")
local PetFrame = LeftMenuFrame:FindFirstChild("PetFrame")
local PetButton = PetFrame and PetFrame:FindFirstChild("PetButton")

if not PetFeatureConfig.Enabled then
    if PetFrame then
        PetFrame.Visible = false
    end
    local menu = RightFrame:FindFirstChild("MenuFrame_b")
    local pets = menu and menu:FindFirstChild("PetsFrame")
    if pets then
        pets.Visible = false
    end
    for _, name in ipairs({ "MyPetButton", "MyEggButton" }) do
        local entry = RightFrame:FindFirstChild(name)
        if entry then
            entry.Visible = false
        end
    end
end

local IndexGui = PlayerGUI:WaitForChild("IndexGui_New")
local SettingsGui = PlayerGUI:WaitForChild("SettingsGui")
local StoreGui = PlayerGUI:WaitForChild("StoreGui")
local currentWinsValue = Instance.new("NumberValue")
local currentTrophyValue = Instance.new("NumberValue")

-- local currentTowerTokenValue = Instance.new("NumberValue")
-- local currentDungeonTokenValue = Instance.new("NumberValue")

local UnstuckButton = BottomFrame:WaitForChild("UnstuckButton") :: TextButton
local PickUpButton = BottomFrame:WaitForChild("PickUpButton") :: TextButton
local PickUpShortcutLabel = PickUpButton:WaitForChild("ShortcutLabel") :: TextLabel
UnstuckButton.Visible = false
PickUpButton.Visible = false

local pickupTargetToken: Instance? = nil
local pickupTargetCallback: (() -> ())? = nil

local GAMEPAD_INPUT_TYPES: { [Enum.UserInputType]: boolean } = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true,
}

local TOP_BAR_ICON = {
    SETTINGS = "rbxassetid://16865671638",
}

local settingsTopBarIcon = nil

local HomeGuiController = Knit.CreateController {
    Name = "HomeGuiController",
}

local backpackInventory: GuiObject? = nil
local backpackTabConnections: { RBXScriptConnection } = {}
local BACKPACK_TAB_BAR_NAME = "AnimalFarmBackpackTabs"

local function clearBackpackTabConnections()
	for _, connection in ipairs(backpackTabConnections) do
		connection:Disconnect()
	end
	table.clear(backpackTabConnections)
end

local function hideBackpackTabBar(instance: Instance)
    if BackpackConfig.CategoriesEnabled then
        return
    end
    if instance.Name ~= BACKPACK_TAB_BAR_NAME or not instance:IsA("GuiObject") then
        return
    end

    instance.Visible = false
    table.insert(backpackTabConnections, instance:GetPropertyChangedSignal("Visible"):Connect(function()
        if instance.Visible then
            instance.Visible = false
        end
    end))
end

local function bindBackpackInventory(backpackGui: Instance)
    task.spawn(function()
        local mainFrame = backpackGui:WaitForChild("Backpack", 30)
        if not mainFrame then
            return
        end

        local inventory = mainFrame:WaitForChild("Inventory", 30)
        if not inventory or not inventory:IsA("GuiObject") or backpackInventory == inventory then
            return
        end

        clearBackpackTabConnections()

        backpackInventory = inventory
        local tabBar = inventory:FindFirstChild(BACKPACK_TAB_BAR_NAME)
        if tabBar then
            hideBackpackTabBar(tabBar)
        end
        table.insert(backpackTabConnections, inventory.ChildAdded:Connect(hideBackpackTabBar))
    end)
end

function HomeGuiController:SetUnstuckButtonVisible(isVisible: boolean)
    UnstuckButton.Visible = isVisible
end

function HomeGuiController:SetPickUpButtonTarget(token: Instance, callback: () -> ())
    pickupTargetToken = token
    pickupTargetCallback = callback
    PickUpButton.Visible = true
end

function HomeGuiController:ClearPickUpButtonTarget(token: Instance?)
    if token ~= nil and pickupTargetToken ~= token then
        return
    end

    pickupTargetToken = nil
    pickupTargetCallback = nil
    PickUpButton.Visible = false
end

local function activatePickUpTarget(playShortcutSound: boolean?)
    if not PickUpButton.Visible then
        return
    end

    local callback = pickupTargetCallback
    if not callback then
        return
    end

    if playShortcutSound then
        SoundHelper.PlaySound(Constants.SoundRes.GUI_BUTTON_CLICK)
    end

    HomeGuiController:ClearPickUpButtonTarget(nil)
    callback()
end

local function updatePickUpShortcutLabel(inputType: Enum.UserInputType)
    if inputType == Enum.UserInputType.Touch then
        PickUpShortcutLabel.Visible = false
        return
    end

    local isGamepadInput = GAMEPAD_INPUT_TYPES[inputType] == true
    local isKnownKeyboardMouseInput = inputType == Enum.UserInputType.Keyboard
        or inputType == Enum.UserInputType.MouseButton1
        or inputType == Enum.UserInputType.MouseButton2
        or inputType == Enum.UserInputType.MouseButton3
        or inputType == Enum.UserInputType.MouseMovement
        or inputType == Enum.UserInputType.MouseWheel

    -- GetLastInputType 在客户端刚启动时可能是 Focus/None；此时用设备能力避免主机短暂显示 F、移动端短暂显示标签。
    if not isGamepadInput and not isKnownKeyboardMouseInput then
        if UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
            isGamepadInput = true
        elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            PickUpShortcutLabel.Visible = false
            return
        end
    end

    PickUpShortcutLabel.Visible = true
    PickUpShortcutLabel.Text = if isGamepadInput then "Y" else "F"
end

local function setWinsAmountText(text: string)
    WinsShadowLabel.Text = text
    WinsLabel.Text = text
end

local function formatWinsAmountText(amount: number): string
    return "$" .. NumberUtil.FormatNumberStartKWithDecimal(amount, 2)
end

local function setTrophyAmountText(text: string)
    if not TrophyShadowLabel or not TrophyLabel then
        return
    end
    TrophyShadowLabel.Text = text
    TrophyLabel.Text = text
end

local function formatTrophyAmountText(amount: number): string
    return NumberUtil.FormatNumberStartKWithDecimal(amount, 2)
end

local function setLuckAmountText(luck: number)
    if not LuckShadowLabel or not LuckShadowLabel:IsA("TextLabel") or not LuckLabel or not LuckLabel:IsA("TextLabel") then
        return
    end
    local text = "Luck: " .. ItemStatUtil.FormatLuckPercent(luck)
    LuckShadowLabel.Text = text
    LuckLabel.Text = text
end

function HomeGuiController:Init()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    -- NotificationLabel.Visible = false
    HomeGui.Enabled = true
    TopFrame.Visible = true
    BottomFrame.Visible = true
    UnstuckButton.Visible = false
    -- TowerTokenFrame.Visible = false
    -- DungeonTokenFrame.Visible = false
    -- EventButton.Visible = true
    local secondaryMenu = RightFrame:FindFirstChild("MenuFrame_b")
    for _, entry in {
        LeftMenuFrame:FindFirstChild("OnlineRewardFrame"),
        secondaryMenu and secondaryMenu:FindFirstChild("OnlineRewardFrame"),
        RightMenuFrame:FindFirstChild("TradeFrame"),
        secondaryMenu and secondaryMenu:FindFirstChild("TradeFrame"),
        RightMenuFrame:FindFirstChild("SeasonFrame"),
        RightFrame:FindFirstChild("OnlineQuestButton"),
        RightFrame:FindFirstChild("HalloweenDailyButton"),
        TopFrame:FindFirstChild("StarterPackButton"),
        TopFrame:FindFirstChild("LimitedDailyPotionButton"),
    } do
        if entry:IsA("GuiObject") then
            entry.Visible = false
        end
    end

    -- OtherPositionTemplate.Visible = false

    -- 必须先连接 NumberValue，再 UpdateCurrency；否则首次 tween 的 PropertyChanged 会丢失。
    -- 且当目标值与当前 NumberValue 相同（例如 Block=0）时，Tween 可能不触发 PropertyChanged，需在 UpdateCurrency 内直接刷新文案。
    currentWinsValue:GetPropertyChangedSignal("Value"):Connect(function()
        setWinsAmountText(formatWinsAmountText(math.floor(currentWinsValue.Value)))
    end)

    if TrophyFrame then
        currentTrophyValue:GetPropertyChangedSignal("Value"):Connect(function()
            setTrophyAmountText(formatTrophyAmountText(math.floor(currentTrophyValue.Value)))
        end)
    end

    local currentWins = tonumber(playerData.Wins) or 0
    currentWinsValue.Value = currentWins
    setWinsAmountText(formatWinsAmountText(currentWins))
    if TrophyFrame then
        local currentTrophy = tonumber(playerData.Trophy) or 0
        currentTrophyValue.Value = currentTrophy
        setTrophyAmountText(formatTrophyAmountText(currentTrophy))
    end
    settingsTopBarIcon = self:AddTopBarIcon(SettingsGui, TOP_BAR_ICON.SETTINGS, 2, 1.5)

    -- currentTowerTokenValue:GetPropertyChangedSignal("Value"):Connect(function()
    --     TowerTokenLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(math.floor(currentTowerTokenValue.Value), 2)
    -- end)

    -- currentDungeonTokenValue:GetPropertyChangedSignal("Value"):Connect(function()
    --     DungeonTokenLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(math.floor(currentDungeonTokenValue.Value), 2)
    -- end)
end

-- function HomeGuiController:SwitchFightMode()
--     FightBottomFrame.Visible = true
-- end

-- function HomeGuiController:SwitcNormalMode()
    
-- end

function HomeGuiController:HideHomeGui()
    HomeGui.Enabled = false
end

function HomeGuiController:ShowHomeGui()
    HomeGui.Enabled = true
end

-- function HomeGuiController:AddTopBarIcon(labelName, gui)
--     local icon = Icon.new()
--     icon:setLabel(labelName)
--     icon.selected:Connect(function()
--         if not GuiHelper.CanOpenGui() then
--             icon:deselect()
--             return
--         end
--         if not gui.Enabled then
--             GuiAnimation.OpenGui(gui)
--         end
--     end)

--     icon.deselected:Connect(function()
--         if gui.Enabled then
--             GuiAnimation.CloseGui(gui)
--         end
--     end)

--     gui:GetPropertyChangedSignal("Enabled"):Connect(function()
--         if gui.Enabled then
--             icon:select()
--         else
--             icon:deselect()
--         end
--     end)
-- end

function HomeGuiController:AddTopBarIcon(gui, image: string, order: number, imageScale: number?)
    local icon = Icon.new()
    icon:setRight()
    icon:setImage(image)
    if imageScale then
        if type(icon.setImageYScale) == "function" then
            icon:setImageYScale(0.5454 * imageScale)
        elseif type(icon.setImageScale) == "function" then
            icon:setImageScale(0.5 * imageScale)
        end
    end
    icon:setOrder(order)
    icon.selected:Connect(function()
        if not GuiHelper.CanOpenGui() then
            icon:deselect()
            return
        end
        if not gui.Enabled then
            GuiAnimation.OpenGui(gui)
        end
    end)

    icon.deselected:Connect(function()
        if gui.Enabled then
            GuiAnimation.CloseGui(gui)
        end
    end)

    gui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if gui.Enabled then
            icon:select()
        else
            icon:deselect()
        end
    end)

    return icon
end

local function showHomeGui(isShow: boolean)
    if isShow then
        LeftFrame.Visible = true
        RightFrame.Visible = true
        TopFrame.Visible = true
        BottomFrame.Visible = true
        -- DashFrame.Visible = true
    else
        LeftFrame.Visible = false
        RightFrame.Visible = false
        TopFrame.Visible = false
        BottomFrame.Visible = false
        -- DashFrame.Visible = false
    end
end

function HomeGuiController:AddHideGuiIcon(labelName)
    local icon = Icon.new()
    icon:setLabel(labelName)
    icon.selected:Connect(function()
        showHomeGui(false)
    end)

    icon.deselected:Connect(function()
        showHomeGui(true)
    end)
end

-- -- Top Gui
-- function HomeGuiController:UpdateSpinButton(text: string)
--     SpinLabel.Text = text
-- end

function HomeGuiController:UpdateCurrency(currency: "Wins" | "Trophy", amount: number)
    if amount == nil then return end

    if currency == "Wins" then
        local targetRounded = math.floor(amount + 0.5)
        local valueRounded = math.floor(currentWinsValue.Value + 0.5)
        if valueRounded == targetRounded then
            currentWinsValue.Value = amount
            setWinsAmountText(formatWinsAmountText(targetRounded))
        else
            local numberTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local numberTween = TweenService:Create(currentWinsValue, numberTweenInfo, {Value = amount})
            numberTween:Play()
        end

    elseif currency == "Trophy" then
        if TrophyFrame then
            local targetRounded = math.floor(amount + 0.5)
            local valueRounded = math.floor(currentTrophyValue.Value + 0.5)
            if valueRounded == targetRounded then
                currentTrophyValue.Value = amount
                setTrophyAmountText(formatTrophyAmountText(targetRounded))
            else
                local numberTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local numberTween = TweenService:Create(currentTrophyValue, numberTweenInfo, {Value = amount})
                numberTween:Play()
            end
        end

    end
end

function HomeGuiController:ShowTopGui(isShow: boolean)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    if isShow then
        TweenService:Create(TopFrame, tweenInfo, {Position = UDim2.fromScale(0.5, 0)}):Play()
    else
        TweenService:Create(TopFrame, tweenInfo, {Position = UDim2.fromScale(0.5, -0.2)}):Play()
    end
end

function HomeGuiController:ShowRebirthNotif(enable: boolean)
    RebirthDot.Visible = enable
end

function HomeGuiController:ShowEventNotif(rewardAmount: number)
    -- EventButton.ItemImage.CountLabel.Visible = rewardAmount > 0
    -- EventButton.ItemImage.CountLabel.Text = rewardAmount
    -- EventButton.Dot.Visible = rewardAmount > 0
    -- EventButton.Dot.TextLabel.Text = rewardAmount
    -- isEventReady = rewardAmount > 0
end

function HomeGuiController:ShowSpinNotif(_enable: boolean)
    -- Kept as a no-op for callers after the Spin topbar entry was removed.
end

function HomeGuiController:ShowStoreNotif(enable: boolean)
    StoreDot.Visible = enable
end

function HomeGuiController:ShowAchievementNotif(enable: boolean)
    AchievementDot.Visible = enable
end

function HomeGuiController:ShowIndexNotif(enable: boolean)
    if IndexDot then
        IndexDot.Visible = enable
    end
end

function HomeGuiController:ShowPetNotif(enable: boolean)
    if not PetFeatureConfig.Enabled then return end
    local rightMenu = RightFrame:FindFirstChild("MenuFrame_b")
    local rightPets = rightMenu and rightMenu:FindFirstChild("PetsFrame")
    local rightButton = rightPets and rightPets:FindFirstChild("PetsButton")
    for _, entry in pairs({ PetButton, rightButton }) do
        local dot = entry:FindFirstChild("Dot")
        if dot then
            dot.Visible = enable
        end
    end
end

function HomeGuiController:InviteFriend()
    local inviteOptions = Instance.new("ExperienceInviteOptions")
    inviteOptions.PromptMessage = "⚡ +10% Power Per Online Friend!"
    -- inviteOptions.PromptMessage = "Invite friends to move faster! (+10% ⚡ per friend)"

    local Success, result = pcall(function()
        return SocialService:CanSendGameInviteAsync(localPlayer)
    end)

    if result == true then
        SocialService:PromptGameInvite(localPlayer, inviteOptions)
    else
        NotificationClient.Notify(Constants.NOTIFICATION.CANNOT_INVITE_FRIEND)
    end
end

-- local function updateDoubleSpeedButton()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then return end
--     if playerData.GamePasses[Constants.GAMEPASS.DOUBLE_SPEED] then
--         DoubleSpeedButton.Visible = false
--     else
--         DoubleSpeedButton.Visible = true
--     end
-- end

local function updateGamepassPurchaseFrame()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end
    
    for _, child in BottomFrame.GamepassPurchaseFrame:GetChildren() do
        if child:IsA("ImageButton") then
            child.Visible = not playerData.GamePasses[child.Name]
        end
    end
end

-- local function updateJurassicButton()
    -- local currentAreaId = Knit.GetController("AreaController"):GetCurrentArea()
    -- if currentAreaId == Constants.AREA_NAME.Area_Jurassic then
    --     JurassicEventButton.Visible = false
    --     HomeButton.Visible = true
    -- else
    --     JurassicEventButton.Visible = true
    --     HomeButton.Visible = false
    -- end
-- end

-- function HomeGuiController:PlayEventAnimation()
--     local originalSize = EventButton.ItemImage.Size

--     local rotateTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
--     local scaleTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
--     local rotate1Tween = TweenService:Create(EventButton.ItemImage, rotateTweenInfo, {Rotation = 20})
--     local rotate2Tween = TweenService:Create(EventButton.ItemImage, rotateTweenInfo, {Rotation = -20})
--     local rotateBackTween = TweenService:Create(EventButton.ItemImage, rotateTweenInfo, {Rotation = 0})
--     local scale1Tween = TweenService:Create(EventButton.ItemImage, scaleTweenInfo, {Size = UDim2.new(originalSize.X.Scale * 1.1, 0, originalSize.Y.Scale * 1.1, 0)})
--     local scaleBackTween = TweenService:Create(EventButton.ItemImage, scaleTweenInfo, {Size = originalSize})

--     scale1Tween:Play()
--     rotate1Tween:Play()
--     rotate1Tween.Completed:Wait()

--     rotate2Tween:Play()
--     rotate2Tween.Completed:Wait()

--     rotate1Tween:Play()
--     rotate1Tween.Completed:Wait()

--     rotate2Tween:Play()
--     rotate2Tween.Completed:Wait()

--     rotate1Tween:Play()
--     rotate1Tween.Completed:Wait()

--     scaleBackTween:Play()
--     rotateBackTween:Play()
-- end

local function promptExperienceNotification()
    local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
    local success, canPromptOptIn = pcall(ExperienceNotificationService.CanPromptOptInAsync, ExperienceNotificationService)
    if not success then warn("No result found!"); return end

    if canPromptOptIn then
        ExperienceNotificationService:PromptOptIn()
    end
end

function HomeGuiController:KnitInit()
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId: string)
        task.delay(0, function()
            -- updateDoubleSpeedButton()
            updateGamepassPurchaseFrame()
        end)
    end)
end

function HomeGuiController:KnitStart()
    LogHelper.Print("HomeGuiController started")

    local playerLuckService = Knit.GetService("PlayerLuckService")
    playerLuckService.LuckChanged:Connect(setLuckAmountText)

    PlayerGUI.ChildAdded:Connect(function(child)
        if child.Name == "BackpackGui" then
            bindBackpackInventory(child)
        end
    end)
    local existingBackpackGui = PlayerGUI:FindFirstChild("BackpackGui")
    if existingBackpackGui then
        bindBackpackInventory(existingBackpackGui)
    end

    for _, name in { "TradeMenuGui", "TradeRequestGui" } do
        local retiredGui = PlayerGUI:FindFirstChild(name)
        if retiredGui and retiredGui:IsA("ScreenGui") then
            retiredGui.Enabled = false
        end
    end

    PickUpButton.Activated:Connect(activatePickUpTarget)

    updatePickUpShortcutLabel(UserInputService:GetLastInputType())
    UserInputService.LastInputTypeChanged:Connect(updatePickUpShortcutLabel)
    UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
        if UserInputService:GetFocusedTextBox() ~= nil then
            return
        end

        local isPickUpKey = input.KeyCode == Enum.KeyCode.F or input.KeyCode == Enum.KeyCode.ButtonY
        if not isPickUpKey then
            return
        end

        if not GameplayInputGate.IsWorldActionAllowed() then
            return
        end

        -- 隐藏的 ProximityPrompt 也会占用 F/Y；Pick up 实际走当前按钮目标，
        -- 所以目标可见时即使输入已被 Prompt 标记为 processed，也必须继续触发。
        if processed and not PickUpButton.Visible then
            return
        end

        activatePickUpTarget(true)
    end)

    -- AddJurassicTokenButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end

    --     Knit.GetController("JurassicShopGuiController"):OpenGui()
    -- end)

    -- DashFrame.DashButton.Activated:Connect(function()
    --     LogHelper.Print("DashButton clicked")
    --     Knit.GetController("DashController"):Dash(nil, true)
    -- end)

    -- SettingButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     if not SettingsGui.Enabled then
    --         GuiAnimation.OpenGui(SettingsGui)
    --     else
    --         GuiAnimation.CloseGui(SettingsGui)
    --     end
    -- end)

    -- TeleportButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     if not TeleportGui.Enabled then
    --         GuiAnimation.OpenGui(TeleportGui)
    --     else
    --         GuiAnimation.CloseGui(TeleportGui)
    --     end
    -- end)

    -- FriendButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     self:InviteFriend()
    -- end)

    InviteButon.Activated:Connect(function()
        if not GuiHelper.CanOpenGui() then return end
        self:InviteFriend()
    end)

    if IndexButton then
        IndexButton.Activated:Connect(function()
            if not GuiHelper.CanOpenGui() then return end
            if IndexGui.Enabled then
                GuiAnimation.CloseGui(IndexGui)
            else
                GuiAnimation.OpenGui(IndexGui)
            end
        end)
    end

    if PetFeatureConfig.Enabled and PetButton then
        PetButton.Activated:Connect(function()
            Knit.GetController("PetGuiController"):ToggleGui()
        end)
    end

    -- EventButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     local EventGuiController = Knit.GetController("EventGuiController")
    --     if EventGuiController:IsOpen() then
    --         EventGuiController:CloseGui()
    --     else
    --         EventGuiController:OpenGui()
    --     end
    -- end)

    -- WeaponButton.Activated:Connect(function()
    --     Knit.GetController("RideController"):HandleInput()
    -- end)

    StoreButton.Activated:Connect(function()
        if not GuiHelper.CanOpenGui() then return end
        if not StoreGui.Enabled then
            Knit.GetController("StoreGuiController"):OpenGui()
        else
            GuiAnimation.CloseGui(StoreGui)
        end
    end)

    RebirthButton.Activated:Connect(function()
        local RebirthGui = PlayerGUI:FindFirstChild("RebirthGui")
        if not RebirthGui then return end
        if not GuiHelper.CanOpenGui() then return end

        if not RebirthGui.Enabled then
            GuiAnimation.OpenGui(RebirthGui)
        else
            GuiAnimation.CloseGui(RebirthGui)
        end
    end)

    -- HatButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     local HatGuiController = Knit.GetController("HatGuiController")
    --     if HatGuiController:IsOpen() then
    --         HatGuiController:CloseGui()
    --     else
    --         HatGuiController:OpenGui()
    --     end
    -- end)

    AchievementButton.Activated:Connect(function()
        if not StarterGui:FindFirstChild("AchievementGui") then return end
        if not GuiHelper.CanOpenGui() then return end
        local AchievementGuiController = Knit.GetController("AchievementGuiController")
        if AchievementGuiController:IsOpen() then
            AchievementGuiController:CloseGui()
        else
            AchievementGuiController:OpenGui()
        end
    end)

    HomeButton.Activated:Connect(function()
        if not GuiHelper.CanWorkInFight() then return end
        if not GuiHelper.CanOpenGui() then return end

        local AreaController = Knit.GetController("AreaController")
        AreaController:TeleportToArea(Constants.AREA_NAME.Area_1)
    end)

    LeaderboardButton.Activated:Connect(function()
        if not GuiHelper.CanOpenGui() then return end

        local areas = Workspace:FindFirstChild("Areas")
        local destination = areas and areas:FindFirstChild("TeleportPart_Leaderboard")
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not destination or not destination:IsA("BasePart") then return end
        if not character or not rootPart or not rootPart:IsA("BasePart") then return end
        if not Workspace.CurrentCamera then return end

        CharacterUtil.TeleportTo(character, destination.CFrame)
    end)

    BottomFrame.GamepassPurchaseFrame.DoubleWins.Activated:Connect(function()
        MarketplaceService:PromptGamePassPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.GAMEPASS.DOUBLE_WINS))
    end)

    local PlayerDataService = Knit.GetService("PlayerDataService")

    PlayerDataService.WinsChanged:Connect(function(result)
        task.delay(0, function()
            self:UpdateCurrency("Wins", result)
        end)
    end)

    PlayerDataService.TrophyChanged:Connect(function(result)
        task.delay(0, function()
            self:UpdateCurrency("Trophy", result)
        end)
    end)

    -- PlayerDataService.DiamondsChanged:Connect(function(result)
    -- end)

    -- Knit.GetService("GameOperationService").ShowNotification:Connect(function(notification)
    --     if notifTimer then notifTimer:Destroy() end

    --     if notification.Active then
    --         if notification.Type == "Countdown" then
    --             NotificationLabel.Text = notification.Text
                
    --             notifTimer = Timer.new(1)
    --             notifTimer.Tick:Connect(function()
    --                 local timeLeft = notification.TargetDate - DateTime.now().UnixTimestamp
    --                 if timeLeft <= 0 then
    --                     NotificationLabel.Text = notification.Text .. NumberUtil.ConvertToHMS_Unit(0)
    --                     notifTimer:Destroy()
    --                 else
    --                     NotificationLabel.Text = notification.Text .. NumberUtil.ConvertToHMS_Unit(timeLeft)
    --                 end
    --             end)
    --             notifTimer:StartNow()
    --         else
    --             -- if notifTimer then notifTimer:Destroy() end
    --             NotificationLabel.Text = notification.Text
    --         end
    --         NotificationLabel.Visible = true
    --     else
    --         -- if notifTimer then notifTimer:Destroy() end
    --         NotificationLabel.Visible = false
    --     end
    -- end)

    -- Knit.GetController("AreaController").ChangeAreaEvent:Connect(function(areaName)
    --     if areaName == Constants.AREA_NAME.TOWER then
    --         TowerTokenFrame.Visible = true
    --     else
    --         TowerTokenFrame.Visible = false
    --     end
    --     if areaName == Constants.AREA_NAME.DUNGEON then
    --         DungeonTokenFrame.Visible = true
    --         EventButton.Visible = false
    --     else
    --         DungeonTokenFrame.Visible = false
    --         EventButton.Visible = true
    --     end
    -- end)

    local playerData = PlayerDataController:GetData()   -- just to make sure it's loaded
    self:Init()
    playerLuckService:GetPlayerRollLuck():andThen(function(luck: number?)
        if typeof(luck) == "number" then
            setLuckAmountText(luck)
        end
    end):catch(function(err)
        warn("HomeGuiController: failed to get player Luck", err)
    end)

    -- DoubleSpeedButton.Activated:Connect(function()
    --     if not playerData.GamePasses[Constants.GAMEPASS.DOUBLE_SPEED] then
    --         MarketplaceService:PromptGamePassPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.GAMEPASS.DOUBLE_SPEED))
    --     else
    --         NotificationClient.GreenNotify("Already Owned!")
    --     end
    -- end)

    updateGamepassPurchaseFrame()

    task.delay(5, function()
        promptExperienceNotification()
    end)
end

return HomeGuiController
