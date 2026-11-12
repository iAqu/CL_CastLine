local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local ButtonAnimation = require(Modules.ButtonAnimation)
local FishingAssets = require(Modules.FishingAssets)
local GameplayInputGate = require(Modules.GameplayInputGate)
local GuiAnimation = require(Modules.GuiAnimation)
local GuiUtil = require(Modules.GuiUtil)
local IndexItemViewport = require(Modules.IndexItemViewport)
local NotificationClient = require(Modules.NotificationClient)
local NumberUtil = require(Modules.NumberUtil)
local PlotWorkspaceUtil = require(Modules.PlotWorkspaceUtil)
local RodShopZone = require(Modules.RodShopZone)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)
local data = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(data:WaitForChild("RodsData"))

local localPlayer = Players.LocalPlayer
local RodShopGuiController = Knit.CreateController({ Name = "RodShopGuiController" })

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
	if not (gui and gui:IsA("ScreenGui") and list and list:IsA("ScrollingFrame")
		and template and template:IsA("Frame") and closeButton and closeButton:IsA("GuiButton"))
	then
		warn("RodShopGuiController: RodShopGui template or close button is missing")
		return
	end

	local service = Knit.GetService("RodShopService")
	local cards = {}
	local inventory
	local actionPending = false
	local closing = false
	local visit
	local currentAnchor
	local currentCharacter
	local localShop
	local warnedMissingTemplate = false

	local function render()
		for id, card in cards do
			local owned = inventory.ownedRods[id] == true
			local equipped = inventory.equippedRodId == id
			card.BuyButton.Visible = not owned
			card.EquipButton.Visible = owned and not equipped
			card.EquipedButton.Visible = equipped
			card.BuyButton.Interactable = not actionPending
			card.EquipButton.Interactable = not actionPending
		end
	end

	local function act(id: string, buy: boolean)
		if actionPending or closing or not gui.Enabled then
			return
		end
		actionPending = true
		render()
		local request = if buy then service:BuyRod(id) else service:EquipRod(id)
		request:andThen(function(result)
			if result and result.ok then
				inventory = result
				NotificationClient.GreenNotify(result.message)
			else
				NotificationClient.RedNotify((result and result.message) or "Rod shop request failed")
			end
		end):catch(function()
			NotificationClient.RedNotify("Rod shop request failed")
		end):finally(function()
			actionPending = false
			render()
		end)
	end

	local function buildCards()
		for id, rod in RodsData do
			local card = template:Clone()
			card.Name = id
			card.LayoutOrder = rod.LayoutOrder
			card.NameLabel.Text = rod.DisplayName
			card.RarityLabel.Text = rod.Rarity
			GuiUtil.SetRarityGradient(card.RarityLabel, rod.Rarity)
			local information = card.Information
			-- The template has a hidden Weight row as well as the displayed one.
			for _, row in information:GetChildren() do
				if row.Name == "Weight" then
					row.Counter.Text = tostring(rod.MaxWeight) .. "kg"
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
		if gui.Enabled and not closing then
			closing = true
			GuiAnimation.CloseGui(gui)
		end
	end

	template.Visible = false
	template.PriceLabel.Visible = false
	ButtonAnimation.SetUp(closeButton)
	closeButton.Activated:Connect(close)
	GuiAnimation.SetNavigationOptions(gui, nil, close)
	gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not gui.Enabled then
			closing = false
		end
	end)

	local elapsed = 0
	RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		if elapsed < 0.1 then
			return
		end
		elapsed = 0
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
		if not localShop or not anchor or not RodShopZone.Contains(anchor, character, RodShopZone.ExitMargin) then
			visit = nil
			close()
			return
		end
		if visit or actionPending or gui.Enabled or not RodShopZone.Contains(anchor, character, 0)
			or localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) ~= true
			or localPlayer:GetAttribute("EquippedRodId") == nil
			or not GameplayInputGate.IsWorldActionAllowed() or not GuiAnimation.IsAllPopupGuisClosed()
		then
			return
		end

		local thisVisit = {}
		visit = thisVisit
		local function stillHere()
			return visit == thisVisit and localPlayer.Character == character
				and getOwnAnchor() == anchor and RodShopZone.Contains(anchor, character, RodShopZone.ExitMargin)
		end
		service:GetState():andThen(function(result)
			if not stillHere() then
				return
			end
			if not result or not result.ok then
				NotificationClient.RedNotify((result and result.message) or "Could not open rod shop")
				return
			end
			if not GameplayInputGate.IsWorldActionAllowed() or not GuiAnimation.IsAllPopupGuisClosed() then
				visit = nil
				return
			end
			inventory = result
			if not next(cards) then
				buildCards()
			end
			render()
			GuiAnimation.OpenGui(gui)
		end):catch(function()
			if stillHere() then
				NotificationClient.RedNotify("Could not open rod shop")
			end
		end)
	end)
end

return RodShopGuiController
