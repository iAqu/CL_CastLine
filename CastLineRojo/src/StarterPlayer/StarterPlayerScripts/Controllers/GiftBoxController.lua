local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
-- local DistanceDetectClient = require(ReplicatedStorage.Modules.DistanceDetectClient)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GiftBoxesDataHelper = require(ReplicatedFirst.DataHelpers.GiftBoxesDataHelper)
local PerchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
        
local PickupParticleFolder = ReplicatedStorage.Particle.Pickup
local Animation = ReplicatedStorage:WaitForChild("Animation")
local animation_open = Animation:WaitForChild("GiftBox").GiftBox_Open

local localPlayer = game.Players.LocalPlayer
local character: Model? = localPlayer.Character
localPlayer.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
end)
localPlayer.CharacterRemoving:Connect(function(removingCharacter)
	if character == removingCharacter then
		character = nil
	end
end)
local giftBoxModels = {}

local GiftTemplate = ReplicatedStorage.Items.GiftTemplate

local flyingGifts = {}

local DroppedGiftsFolderName = "DroppedGifts"

local GiftBoxController = Knit.CreateController {
    Name = "GiftBoxController",
}

local function initGiftBoxes(worldIndex: number)

    local palyerData = PlayerDataController:GetData()
    if not palyerData then return end

    AreasWorkspace.forEachAreaContext(function(areaRoot, areaId)
        local items = areaRoot:FindFirstChild("Items")
        if not items then return end

        for _, giftBox in items:GetChildren() do
            if giftBox.Name ~= "GiftBox" then continue end
            LogHelper.Print("InitGiftBoxes", areaId)

            -- local giftBox = area.Items.GiftBox
            if not giftBox.PrimaryPart then warn("GiftBox has no PrimaryPart!", giftBox.Name) continue end

            local giftBoxId = giftBox:GetAttribute("GiftBoxId")
            if not giftBoxId then warn("GiftBoxId not found!", giftBox.Name) continue end

            if palyerData.GiftBoxClaimLog[giftBoxId] == true then
                giftBox:Destroy()
                continue
            end

            giftBoxModels[giftBoxId] = giftBox

            local prompt = Instance.new("ProximityPrompt", giftBox.PrimaryPart)
            local robuxPrice = PurchaseDataHelper.GetPrice(giftBoxId)
            if not robuxPrice then robuxPrice = "Free" end
            prompt.ActionText = "Open (R$ " .. robuxPrice .. ")"
            prompt.MaxActivationDistance = 15
            prompt.ObjectText = "Gift Box"
            prompt.HoldDuration = 2
            prompt.RequiresLineOfSight = false

            local gui = giftBox:FindFirstChild("Gui")
            if not gui then warn("GiftBox has no Gui!", giftBox.Name) continue end
            if gui then gui.Enabled = false end

            local giftItemNum = GiftBoxesDataHelper.GetGiftTypeNum(giftBoxId)
            for index = 1, giftItemNum do
                local itemType = GiftBoxesDataHelper.GetItemType(giftBoxId, index)
                local itemId = GiftBoxesDataHelper.GetItemId(giftBoxId, index)
                local itemCount = GiftBoxesDataHelper.GetItemCount(giftBoxId, index)

                local frameName = "Frame_" .. index
                if not gui.Frame:FindFirstChild(frameName) then warn("GiftBox has no Frame!", giftBox.Name) continue end
                if itemType == "Wins" then
                    gui.Frame[frameName].ImageLabel.Image = Constants.IMAGE.WINS_ICON
                    gui.Frame[frameName].TextLabel.Text = NumberUtil.FormatWinsAmount(itemCount)

                elseif itemType == "Potion" then
                    gui.Frame[frameName].ImageLabel.Image = "rbxassetid://" .. PerchaseDataHelper.GetIconId(itemId)
                    gui.Frame[frameName].TextLabel.Text = PerchaseDataHelper.GetName(itemId)

                end
            end
            

            local openAnimController = giftBox:FindFirstChild("AnimationController")
            if not openAnimController then
                openAnimController = Instance.new("AnimationController", giftBox)
            end
            local openAnimTrack = openAnimController:LoadAnimation(animation_open)

            prompt.PromptShown:Connect(function()
                if gui then gui.Enabled = true end
            end)

            prompt.PromptHidden:Connect(function()
                if gui then gui.Enabled = false end
            end)

            prompt.PromptButtonHoldBegan:Connect(function(player)
                if player == localPlayer then
                    openAnimTrack:Play()
                end
            end)

            prompt.PromptButtonHoldEnded:Connect(function(player)
                openAnimTrack:Stop(0.2)
            end)

            prompt.Triggered:Connect(function(player)
                if player == localPlayer then
                    local GiftBoxService = Knit.GetService("GiftBoxService")
                    GiftBoxService.OpenGiftBox:Fire(giftBoxId)
                end
            end)
        end
    end)
end

function GiftBoxController:DropGift(giftBoxId: string, dropGifts: {GiftBoxesDataHelper.GiftInstance})
    local giftBoxModel = giftBoxModels[giftBoxId]
    local particlePart = Instance.new("Part", workspace)
    particlePart.Transparency = 1
    particlePart.CanCollide = false
    particlePart.Anchored = true
    particlePart.Position = giftBoxModel.PrimaryPart.Position

    SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_OPEN)
    SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER)
    
    local openParticle = ReplicatedStorage.Particle.GiftBox.OpenStar:Clone()
    local attachment = Instance.new("Attachment", particlePart)
    openParticle.Parent = attachment
    openParticle:Emit(openParticle:GetAttribute("EmitCount"))

    for _, gift in ipairs(dropGifts) do
        local clone = GiftTemplate:Clone()
        if gift.ItemType == "Wins" then
            clone.BillboardGui.ImageLabel.Image = Constants.IMAGE.WINS_ICON

        elseif gift.ItemType == "Diamond" then
            clone.BillboardGui.ImageLabel.Image = Constants.IMAGE.DIAMOND_ICON

        elseif gift.ItemType == "Potion" then
            local iconId = PerchaseDataHelper.GetIconId(gift.ItemId)
            clone.BillboardGui.ImageLabel.Image = "rbxassetid://" .. iconId

        else
            warn("Unknown gift type: " .. gift.ItemType)
        end
        clone.Name = gift.ItemType
        clone:SetAttribute("UUID", gift.UUID)
        
        clone.CFrame = giftBoxModel.PrimaryPart.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
        if not Workspace:FindFirstChild(DroppedGiftsFolderName) then
            local giftsFolder = Instance.new("Folder", Workspace)
            giftsFolder.Name = DroppedGiftsFolderName
        end
        clone.Parent = Workspace[DroppedGiftsFolderName]

        local randomX = {math.random(-15, -7), math.random(7, 15)}
        local randomZ = {math.random(-15, -7), math.random(7, 15)}

        local velocity = Vector3.new(randomX[math.random(1, 2)], math.random(50, 80), randomZ[math.random(1, 2)])
        clone.AssemblyLinearVelocity = velocity
    end

    giftBoxModel:Destroy()
    game.Debris:AddItem(particlePart, 3)
end

function GiftBoxController:DetectGift()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

	local activeCharacter = character
	local rootPart = activeCharacter and activeCharacter:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then return end
    if not Workspace:FindFirstChild(DroppedGiftsFolderName) then return end
    for i, droppedGift in pairs(Workspace[DroppedGiftsFolderName]:GetChildren()) do
        if not droppedGift:IsA("Part") then continue end
        if flyingGifts[droppedGift.Name] then continue end
        if #droppedGift:GetTouchingParts() == 0 then continue end

        local isTouchOtherBesideCharacter = false
        for _, part in ipairs(droppedGift:GetTouchingParts()) do
			if part.Parent ~= activeCharacter and part.Parent.Name ~= "GiftBox" then
                isTouchOtherBesideCharacter = true
                break
            end
        end
        if not isTouchOtherBesideCharacter then continue end

		local distance = (droppedGift.Position - rootPart.Position).Magnitude
        local pickDistance = Constants.DETECT_RANGE.DIAMOND
        if playerData.GamePasses[Constants.GAMEPASS.MAGNET] then
            pickDistance *= 2.5
        end
        if distance <= pickDistance then
            if flyingGifts[droppedGift:GetAttribute("UUID")] then continue end
            flyingGifts[droppedGift:GetAttribute("UUID")] = droppedGift
            droppedGift.CanCollide = false
			local tween = TweenService:Create(droppedGift, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = rootPart.Position})
            tween:Play()
            tween.Completed:Connect(function()
                local GiftBoxService = Knit.GetService("GiftBoxService")
                -- TODO: 可优化成批量处理
                GiftBoxService.PickGift:Fire(droppedGift:GetAttribute("UUID"))
                flyingGifts[droppedGift:GetAttribute("UUID")] = nil
                droppedGift:Destroy()
            end)
        end
    end
end

function GiftBoxController:KnitInit()
    -- Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(function()
    --     initGiftBoxes()
    -- end)
end

function GiftBoxController:KnitStart()
    -- local GiftBoxService = Knit.GetService("GiftBoxService")
    -- GiftBoxService.DropGifts:Connect(function(giftBoxId, dropGifts: {GiftBoxesDataHelper.GiftInstance})
    --     self:DropGift(giftBoxId, dropGifts)
    -- end)

    -- GiftBoxService.PickGift:Connect(function(giftInstance: GiftBoxesDataHelper.GiftInstance)
    --     if giftInstance.ItemType == "Wins" then
    --         local formatedNumber = NumberUtil.FormatNumberStartMWithDecimal(giftInstance.Value)
    --         NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_WINS:gsub("#NUM", formatedNumber))

    --     elseif giftInstance.ItemType == "Diamond" then
    --         NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_DIAMOND:gsub("#NUM", giftInstance.Value))

    --     elseif giftInstance.ItemType == "Potion" then
    --         local potionName = PerchaseDataHelper.GetName(giftInstance.ItemId)
    --         NotificationClient.GreenNotify(Constants.NOTIFICATION.GOT_POTION:gsub("#POTION", potionName))

    --     else
    --         warn("Unknown gift type: " .. giftInstance.ItemType)
    --     end

    --     SoundHelper.PlaySound(Constants.SoundRes.DIAMOND_PICKUP)
    --     local pickupEffectAttachment = PickupParticleFolder.Part.Attachment:Clone()
    --     pickupEffectAttachment.Parent = character.HumanoidRootPart
    --     for _, particle in pairs(pickupEffectAttachment:GetChildren()) do
    --         if particle:IsA("ParticleEmitter") then
    --             particle:Emit(particle:GetAttribute("EmitCount"))
    --         end
    --     end
    --     game:GetService("Debris"):AddItem(pickupEffectAttachment, 0.3)
    -- end)

    -- initGiftBoxes()

    -- RunService.Heartbeat:Connect(function()
    --     self:DetectGift()
    -- end)
end

return GiftBoxController
