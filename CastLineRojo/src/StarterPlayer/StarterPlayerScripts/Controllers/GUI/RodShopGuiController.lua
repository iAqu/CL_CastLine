local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local FishingConfig = require(Modules.FishingConfig)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ButtonAnimation = require(Modules.ButtonAnimation)
local CharacterUtil = require(Modules.CharacterUtil)
local FishingAssets = require(Modules.FishingAssets)
local GameplayInputGate = require(Modules.GameplayInputGate)
local GuiAnimation = require(Modules.GuiAnimation)
local GuiUtil = require(Modules.GuiUtil)
local IndexItemViewport = require(Modules.IndexItemViewport)
local NotificationClient = require(Modules.NotificationClient)
local NumberUtil = require(Modules.NumberUtil)
local WeightFormat = require(Modules.WeightFormat)
local PlotWorkspaceUtil = require(Modules.PlotWorkspaceUtil)
local RodShopZone = require(Modules.RodShopZone)
local RodShopClientState = require(Modules.RodShopClientState)
local RodShopFocus = require(Modules.RodShopFocus)
local Onboarding = require(Modules.FishingOnboarding)
local Promise = require(Knit.Util.Promise)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)
local data = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(data:WaitForChild("RodsData"))

local localPlayer = Players.LocalPlayer
local RodShopGuiController = Knit.CreateController({ Name = "RodShopGuiController" })

function RodShopGuiController:IsReady(): boolean
	return self._isReady ~= nil and self._isReady()
end

function RodShopGuiController:OpenForRod(rodId: string)
	if not self._openForRod then
		NotificationClient.RedNotify("The rod shop is not ready yet")
		return Promise.resolve(false)
	end
	return self._openForRod(rodId)
end

local function getOwnAnchor(): BasePart?
	local slotId = localPlayer:GetAttribute("PlotSlotId")
	local plot = if typeof(slotId) == "number" then PlotWorkspaceUtil.getPlotBySlot(slotId) else nil
	if plot and plot:GetAttribute("OwnerUserId") == localPlayer.UserId then
		return RodShopZone.GetAnchor(plot)
	end
	return nil
end

local function createLocalShop(anchor: BasePart): Model?
	local templates = ReplicatedStorage:FindFirstChild("PlotTemplates")
	local template = templates and templates:FindFirstChild("RodShop")
	local circle = template and template:FindFirstChild("ActivationCircle")
	if not (template and template:IsA("Model") and circle and circle:IsA("BasePart")) then
		return nil
	end

	local shop = template:Clone()
	shop:PivotTo(anchor.CFrame * circle.CFrame:ToObjectSpace(template:GetPivot()))
	local props = Workspace:FindFirstChild("LocalPlotProps")
	if not props then
		props = Instance.new("Folder")
		props.Name = "LocalPlotProps"
		props.Parent = Workspace
	end
	shop.Parent = props
	return shop
end

function RodShopGuiController:KnitStart()
	local gui = localPlayer:WaitForChild("PlayerGui"):WaitForChild("RodShopGui", 10)
	local main = gui and gui:FindFirstChild("Main")
	local mainFrame = main and main:FindFirstChild("MainFrame")
	local list = mainFrame and mainFrame:FindFirstChild("ScrollingFrame")
	local template = list and list:FindFirstChild("RodTemplate")
	local top = main and main:FindFirstChild("Top")
	local closeButton = top and top:FindFirstChild("CloseButton")
	if
		not (
			gui
			and gui:IsA("ScreenGui")
			and list
			and list:IsA("ScrollingFrame")
			and template
			and template:IsA("Frame")
			and closeButton
			and closeButton:IsA("GuiButton")
		)
	then
		warn("RodShopGuiController: RodShopGui template or close button is missing")
		return
	end

	local service = Knit.GetService("RodShopService")
	local cards = {}
	local inventory
	local cash: NumberValue?
	local snapshots = RodShopClientState.new()
	local actionPending = false
	local closing = false
	local visit
	local currentAnchor
	local currentCharacter
	local localShop
	local warnedMissingTemplate = false
	local requestToken
	local opening = false

	local function isTrainingReward(id)
		return id == Onboarding.RewardRodId and localPlayer:GetAttribute(Onboarding.StageAttribute) == "RodReward"
	end

	local function render()
		if not inventory then
			return
		end
		local balance = cash and cash.Value
		for id, card in cards do
			local owned = inventory.ownedRods[id] == true
			local equipped = inventory.equippedRodId == id
			local canClaim = isTrainingReward(id)
			local trainingLocked = not owned and id == Onboarding.RewardRodId and not canClaim
				and Onboarding.IsActiveStage(localPlayer:GetAttribute(Onboarding.StageAttribute))
			local price = RodsData[id].Price
			local buyButton = card.BuyButton
			local canBuy = not owned and (canClaim or (not trainingLocked and balance ~= nil and balance >= price))
			local canBuyGradient = buyButton:FindFirstChild("Gradient_CanBuy")
			local cannotBuyGradient = buyButton:FindFirstChild("Gradient_CannotBuy")
			if canBuyGradient and canBuyGradient:IsA("UIGradient") and cannotBuyGradient and cannotBuyGradient:IsA("UIGradient") then
				canBuyGradient.Enabled = canBuy
				cannotBuyGradient.Enabled = not canBuy
			end
			buyButton.TextLabel.Text = if canClaim then "CLAIM" elseif trainingLocked then "TRAIN FIRST"
				else "$" .. NumberUtil.FormatNumberStartKWithDecimal(price, 1)
			buyButton.Visible = not owned
			card.EquipButton.Visible = owned and not equipped
			card.EquipedButton.Visible = equipped
			buyButton.Interactable = not actionPending and not trainingLocked
			buyButton.Selectable = not trainingLocked
			card.EquipButton.Interactable = not actionPending
		end
	end
	localPlayer:GetAttributeChangedSignal(Onboarding.StageAttribute):Connect(render)
	task.spawn(function()
		local cashStat = localPlayer:WaitForChild("leaderstats"):WaitForChild("💵Cash")
		if cashStat:IsA("NumberValue") then
			cash = cashStat
			cashStat:GetPropertyChangedSignal("Value"):Connect(render)
			render()
		end
	end)

	self.GetOnboardingTarget = function()
		if not gui.Enabled then
			return nil
		end
		local card = cards[Onboarding.RewardRodId]
		if not card or not isTrainingReward(Onboarding.RewardRodId) then
			return closeButton
		end
		return if card.BuyButton.Visible then card.BuyButton elseif card.EquipButton.Visible then card.EquipButton else closeButton
	end

	-- Subscribe before any GetState request, so late responses cannot replace an event.
	service.InventoryChanged:Connect(function(result)
		if snapshots:ApplyEvent(result) then
			inventory = snapshots.data
			render()
		end
	end)

	local function act(id: string, buy: boolean)
		if actionPending or closing or not gui.Enabled then
			return
		end
		actionPending = true
		render()
		local snapshotToken = snapshots:BeginRequest()
		local request = if buy and isTrainingReward(id) then service:ClaimTrainingRod()
			elseif buy then service:BuyRod(id) else service:EquipRod(id)
		request
			:andThen(function(result)
				if result and result.ok then
					snapshots:ApplyResponse(snapshotToken, result)
					inventory = snapshots.data
					NotificationClient.GreenNotify(result.message)
				else
					NotificationClient.RedNotify((result and result.message) or "Rod shop request failed")
				end
			end)
			:catch(function()
				NotificationClient.RedNotify("Rod shop request failed")
			end)
			:finally(function()
				actionPending = false
				render()
			end)
	end

	local function buildCards()
		-- Keep both same-named rows in the authored template for restoring the limit later.
		if not FishingConfig.RodWeightLimitEnabled then
			for _, row in template.Information:GetChildren() do
				if row.Name == "Weight" then
					row.Visible = false
				end
			end
		end
		for id, rod in RodsData do
			local card = template:Clone()
			card.Name = id
			card.LayoutOrder = rod.LayoutOrder
			GuiUtil.SetRarityGradient(card, rod.Rarity)
			for _, child in card:GetChildren() do
				if child:IsA("UIGradient") then
					child.Rotation = 90
				end
			end
			card.NameLabel.Text = rod.DisplayName
			card.RarityLabel.Text = rod.Rarity
			GuiUtil.SetRarityGradient(card.RarityLabel, rod.Rarity)
			local information = card.Information
			-- The template has a hidden Weight row as well as the displayed one.
			for _, row in information:GetChildren() do
				if row.Name == "Weight" then
					row.Counter.Text = if rod.MaxWeight ~= nil then WeightFormat.FormatKg(rod.MaxWeight) else ""
					if not FishingConfig.RodWeightLimitEnabled then
						row.Visible = false
					end
				elseif row.Name == "Location" or row.Name == "Distance" then
					row.Visible = false
				end
			end
			information.Luck.Counter.Text = tostring(rod.LuckBoost)
			card.BuyButton.TextLabel.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(rod.Price, 1)
			card.EquipedButton.Interactable = false
			card.EquipedButton.Selectable = false
			ButtonAnimation.SetUp(card.BuyButton)
			ButtonAnimation.SetUp(card.EquipButton)
			card.BuyButton.Activated:Connect(function()
				act(id, true)
			end)
			card.EquipButton.Activated:Connect(function()
				act(id, false)
			end)
			if typeof(rod.Icon) == "string" and rod.Icon ~= "" and rod.Icon ~= "nil" then
				card.RodImage.Image = rod.Icon
			else
				local model = FishingAssets.GetRod(rod.Model)
				card.RodImage.Visible = false
				if model then
					IndexItemViewport.ShowModel(card, card.RodImage, model, true)
				end
			end
			cards[id] = card
			card.Visible = true
			card.Parent = list
		end
	end

	local function close()
		requestToken = nil
		opening = false
		if gui.Enabled and not closing then
			closing = true
			GuiAnimation.CloseGui(gui)
		end
	end

	local function refreshContext()
		local anchor = getOwnAnchor()
		local character = localPlayer.Character
		if anchor ~= currentAnchor and localShop then
			localShop:Destroy()
			localShop = nil
		end
		if anchor ~= currentAnchor or character ~= currentCharacter then
			currentAnchor, currentCharacter = anchor, character
			visit = nil
			close()
		end
		if anchor and not localShop then
			localShop = createLocalShop(anchor)
			if not localShop and not warnedMissingTemplate then
				warnedMissingTemplate = true
				warn("RodShopGuiController: PlotTemplates.RodShop or its ActivationCircle is missing")
			end
		end
		return anchor, character
	end

	local function canOpen()
		return localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) == true
			and localPlayer:GetAttribute("EquippedRodId") ~= nil
			and GameplayInputGate.IsWorldActionAllowed()
			and GuiAnimation.IsAllPopupGuisClosed()
	end

	self._isReady = function()
		local anchor, character = refreshContext()
		return localShop ~= nil and anchor ~= nil and RodShopZone.GetEntryCFrame(anchor, character, localShop) ~= nil
	end

	local function open(targetId: string?, teleport: boolean)
		if opening or actionPending or closing or gui.Enabled then
			return Promise.resolve(false)
		end
		local anchor, character = refreshContext()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not anchor or not localShop or not humanoid or humanoid.Health <= 0 or not canOpen() then
			if teleport then
				NotificationClient.RedNotify("The rod shop is not available right now")
			end
			return Promise.resolve(false)
		end
		local token = { anchor = anchor, character = character, teleported = not teleport }
		requestToken = token
		visit = token
		opening = true
		local snapshotToken = snapshots:BeginRequest()
		local function current()
			return requestToken == token
				and localPlayer.Character == character
				and getOwnAnchor() == anchor
				and humanoid.Health > 0
				and (not token.teleported or RodShopZone.Contains(anchor, character, RodShopZone.ExitMargin))
		end
		local function focus()
			local card = targetId and cards[targetId]
			if current() and gui.Enabled and card then
				list.CanvasPosition = Vector2.new(
					RodShopFocus.CanvasOffset(
						list.CanvasPosition.X,
						card.AbsolutePosition.X,
						card.AbsoluteSize.X,
						list.AbsolutePosition.X,
						list.AbsoluteWindowSize.X,
						list.AbsoluteCanvasSize.X
					),
					RodShopFocus.CanvasOffset(
						list.CanvasPosition.Y,
						card.AbsolutePosition.Y,
						card.AbsoluteSize.Y,
						list.AbsolutePosition.Y,
						list.AbsoluteWindowSize.Y,
						list.AbsoluteCanvasSize.Y
					)
				)
			end
		end
		return service
			:GetState()
			:andThen(function(result)
				if not current() or not canOpen() then
					return false
				end
				if not result or not result.ok then
					NotificationClient.RedNotify((result and result.message) or "Could not open rod shop")
					return false
				end
				snapshots:ApplyResponse(snapshotToken, result)
				inventory = snapshots.data
				if teleport then
					local destination = RodShopZone.GetEntryCFrame(anchor, character, localShop)
					local root = character:FindFirstChild("HumanoidRootPart")
					if not destination or not root or not Workspace.CurrentCamera then
						NotificationClient.RedNotify("Could not travel to the rod shop")
						return false
					end
					CharacterUtil.TeleportTo(character, destination * root.CFrame:ToObjectSpace(character:GetPivot()))
					token.teleported = true
				end
				if not current() then
					return false
				end
				if not next(cards) then
					buildCards()
				end
				render()
				local card = targetId and cards[targetId]
				local selected = card
					and (
						if card.BuyButton.Visible
							then card.BuyButton
							elseif card.EquipButton.Visible then card.EquipButton
							else closeButton
					)
				GuiAnimation.SetNavigationOptions(gui, selected, close)
				GuiAnimation.OpenGui(gui)
				if localPlayer:GetAttribute(Onboarding.StageAttribute) == "RodReward" then
					Knit.GetService("OnboardingAnalyticsService").GuidePresentation:Fire("RodShopOpened")
				end
				if not current() then
					return false
				end
				if targetId then
					task.spawn(function()
						RunService.RenderStepped:Wait()
						focus()
					end)
					task.delay(0.2, focus)
				end
				return gui.Enabled
			end)
			:catch(function()
				if current() then
					NotificationClient.RedNotify("Could not open rod shop")
				end
				return false
			end)
			:finally(function()
				if requestToken == token then
					opening = false
				end
			end)
	end

	self._openForRod = function(rodId)
		local rod = if typeof(rodId) == "string" then RodsData[rodId] else nil
		if not rod or not FishingAssets.GetRod(rod.Model) then
			NotificationClient.RedNotify("Fishing rod unavailable")
			return Promise.resolve(false)
		end
		return open(rodId, true)
	end

	template.Visible = false
	template.PriceLabel.Visible = false
	ButtonAnimation.SetUp(closeButton)
	closeButton.Activated:Connect(close)
	GuiAnimation.SetNavigationOptions(gui, nil, close)
	gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not gui.Enabled then
			closing = false
			requestToken = nil
			opening = false
		end
	end)

	local elapsed = 0
	RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		if elapsed < 0.1 then
			return
		end
		elapsed = 0
		local anchor, character = refreshContext()
		if opening and requestToken and not requestToken.teleported then
			if not canOpen() then
				visit = nil
				close()
			end
			return
		end
		if not localShop or not anchor or not RodShopZone.Contains(anchor, character, RodShopZone.ExitMargin) then
			visit = nil
			close()
			return
		end
		if
			visit
			or actionPending
			or opening
			or gui.Enabled
			or not RodShopZone.Contains(anchor, character, 0)
			or not canOpen()
		then
			return
		end

		open(if isTrainingReward(Onboarding.RewardRodId) then Onboarding.RewardRodId else nil, false)
	end)
end

return RodShopGuiController
