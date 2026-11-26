local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local CollectionService = game:GetService("CollectionService")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)

local Knit = require(ReplicatedStorage.Packages.Knit)

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local AnimationHelper = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AnimationHelper"))
local SoundHelper = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("SoundHelper"))
local AssetIds = require(ReplicatedStorage.Modules.AssetIds)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local RainbowGradientModule = require(ReplicatedStorage.Modules.RainbowGradientModule)
local RotationGradientModule = require(ReplicatedStorage.Modules.RotationGradientModule)
local ParticleEmitter = require(ReplicatedStorage.Libs.ParticleEmitter)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local Timer = require(ReplicatedStorage.Packages.Timer)
local HoverGuiClient = require(ReplicatedStorage.Modules.HoverGuiClient)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
-- local Mouse = localPlayer:GetMouse()
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

-- local TokenQuestGui = PlayerGUI:WaitForChild("TokenQuestGui")

-- local PlayerStateGui = PlayerGUI:WaitForChild("PlayerStateGui")
local HomeGui = PlayerGUI:WaitForChild("HomeGui")
local BottomFrame = HomeGui:WaitForChild("BottomFrame")
local PlayerStateFrame = BottomFrame:WaitForChild("PlayerStateFrame")
local PotionTemplate = PlayerStateFrame.PotionTemplate
local FriendBoostFrame = PlayerStateFrame.FriendBoost
local FriendBoostButton = FriendBoostFrame.FriendBoostButton
local PremiumBoostFrame = PlayerStateFrame.PremiumBoost
local PremiumBoostButton = PremiumBoostFrame.PremiumBoostButton
local TokenFrame = PlayerStateFrame.Tokens
local TokenQuestButton = TokenFrame.TokenQuestButton
local TokenCountdownLabel = TokenFrame.CountdownLabel

local InfoHoverFrame = HomeGui.PlayerStateInfoHover

local isInfoHoverShow = false
-- local setuppedHoverGuiElements = {}

local PlayerStateGuiController = Knit.CreateController {
    Name = "PlayerStateGuiController",
}

function PlayerStateGuiController:Init()
    InfoHoverFrame.Position = UDim2.new(0, 0, 0, 0)
    -- InfoHoverFrame.Visible = false

    PotionTemplate.Visible = false
    local weekendTemplate = PlayerStateFrame:FindFirstChild("WeekendEventTemplate")
    if weekendTemplate and weekendTemplate:IsA("GuiObject") then
        weekendTemplate.Visible = false
    end

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No playerData") return end

	self:SetupInfoHover(FriendBoostButton, "Friends Boost")
    self:SetupInfoHover(TokenQuestButton, "Click to view the quest!")
    self:SetupInfoHover(PremiumBoostButton, "Premium Boost")
end

function PlayerStateGuiController:GeneratePotion(potionId: string)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No playerData") return end

    local potionData = PurchaseDataHelper.GetData(potionId)
    local activePotion = playerData.Potions and playerData.Potions[potionId]
    if not potionData or not potionData.IconId or not potionData.Name or not activePotion then
        return
    end

    local potionClone = PotionTemplate:Clone()
    potionClone.Parent = PlayerStateFrame
    potionClone.Visible = true
    potionClone.Name = potionId
    potionClone.PotionImage.Image = "rbxassetid://" .. potionData.IconId
    potionClone.TimeLabel.Text = NumberUtil.ConvertToMS(activePotion.LastTime - os.time())
    self:SetupInfoHover(potionClone, potionData.Name .. " Boost")
end

function PlayerStateGuiController:UpdatePlayerStateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No playerData") return end

    for _, potionFrame in PlayerStateFrame:GetChildren() do
        if potionFrame:IsA("Frame")
        and potionFrame.Name:match("Potion")
        and not potionFrame.Name:match("Template") then
            local potionId = potionFrame.Name
            local potionData = playerData.Potions and playerData.Potions[potionId]
            if not potionData or potionData.LastTime < os.time() then
                potionFrame:Destroy()
            else
                potionFrame.TimeLabel.Text = NumberUtil.ConvertToMS(potionData.LastTime - os.time())
            end
        end
    end

end

function PlayerStateGuiController:SetPremiumBoostState()
    local success, ownsPremium = pcall(function()
        return localPlayer.MembershipType == Enum.MembershipType.Premium
    end)

    if success then
        if ownsPremium then
            PremiumBoostFrame.BoostLabel.Text = "+20%"
        else
            PremiumBoostFrame.BoostLabel.Text = "+0%"
        end
    end
end

function PlayerStateGuiController:UpdateTokenCountdownLabel(text: string)
    TokenCountdownLabel.Text = text
end

function PlayerStateGuiController:HideInfoHover()
    isInfoHoverShow = false
    InfoHoverFrame.Visible = false
end

-- function PlayerStateGuiController:ClearHoverConnection(guiElement: GuiObject)
--     if setuppedHoverGuiElements[guiElement] then
--         for _, connection in pairs(setuppedHoverGuiElements[guiElement]) do
--             connection:Disconnect()
--         end
--         setuppedHoverGuiElements[guiElement] = nil
--     end
-- end

function PlayerStateGuiController:SetupInfoHover(guiElement: GuiObject, text: string)
    HoverGuiClient.SetupInfoHover(guiElement, InfoHoverFrame, function()
        InfoHoverFrame.TextLabel.Text = text
        local textSize = InfoHoverFrame.TextLabel.TextBounds
        InfoHoverFrame.Size = UDim2.new(0, textSize.X + 10, InfoHoverFrame.Size.Y.Scale, InfoHoverFrame.Size.Y.Offset)
    end, "left")
    -- self:ClearHoverConnection(guiElement)

    -- local mouseEnterConnection = guiElement.MouseEnter:Connect(function()
    --     isInfoHoverShow = true
    --     InfoHoverFrame.Visible = true
    --     InfoHoverFrame.TextLabel.Text = text
    --     local textSize = InfoHoverFrame.TextLabel.TextBounds
    --     LogHelper.Print("textSize = ", textSize)
        
    --     InfoHoverFrame.Size = UDim2.new(0, textSize.X + 10, InfoHoverFrame.Size.Y.Scale, InfoHoverFrame.Size.Y.Offset)
    -- end)

    -- local mouseLeaveConnection = guiElement.MouseLeave:Connect(function()
    --     self:HideInfoHover()
    -- end)

    -- setuppedHoverGuiElements[guiElement] = {mouseEnterConnection, mouseLeaveConnection}
end

function PlayerStateGuiController:KnitInit()
end

function PlayerStateGuiController:KnitStart()
    FriendBoostButton.Activated:Connect(function()
        if not GuiHelper.CanOpenGui() then return end

        Knit.GetController("HomeGuiController"):InviteFriend()
    end)

    PremiumBoostButton.Activated:Connect(function()
        MarketplaceService:PromptPremiumPurchase(localPlayer)
    end)

    -- TokenQuestButton.Activated:Connect(function()
    --     if not GuiHelper.CanOpenGui() then return end
    --     if TokenQuestGui.Enabled then
    --         GuiAnimation.CloseGui(TokenQuestGui)
    --     else
    --         GuiAnimation.OpenGui(TokenQuestGui)
    --     end
    -- end)

    local PotionService = Knit.GetService("PotionService")
    -- Inivite Service
    local InviteService = Knit.GetService("InviteService")
    InviteService.UpdateFriendBoost:Connect(function(boost)
        -- FriendBoostFrame.BoostLabel.Text = FRIEND_BOOST_TEXT:gsub("PERCENT",  math.round(boost * 100))
        -- FriendBoostFrame.BoostLabel.Text = "+" .. math.round(boost * 100) .. "%"
        local BoostLabel = FriendBoostFrame:WaitForChild("BoostLabel")
        BoostLabel.Text = "+" .. math.round(boost * 100) .. "%"
    end)

    Knit.GetService("PremiumService").UpdatePremiumStatus:Connect(function(isPremium: boolean)
        if isPremium == true then
            self:SetPremiumBoostState()
        end
    end)

    PlayerDataController:GetData()
    self:Init()
    self:SetPremiumBoostState()

    -- update potion cd
    task.spawn(function()
        while true do
            self:UpdatePlayerStateGui()
            task.wait(1)
        end
    end)
end

return PlayerStateGuiController
