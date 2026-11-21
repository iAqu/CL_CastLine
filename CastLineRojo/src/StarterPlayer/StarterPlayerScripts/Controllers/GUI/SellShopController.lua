local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Modules = ReplicatedStorage.Modules
local ButtonAnimation = require(Modules.ButtonAnimation)
local FishIconPresentation = require(Modules.FishIconPresentation)
local FishInventoryData = require(Modules.FishInventoryData)
local GameplayInputGate = require(Modules.GameplayInputGate)
local GuiAnimation = require(Modules.GuiAnimation)
local GuiAnimationUtil = require(Modules.GuiAnimationUtil)
local GuiUtil = require(Modules.GuiUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)
local NotificationClient = require(Modules.NotificationClient)
local NumberUtil = require(Modules.NumberUtil)
local SellShopZone = require(Modules.SellShopZone)
local SoundHelper = require(Modules.SoundHelper)
local localPlayer = Players.LocalPlayer
local SellShopController = Knit.CreateController({ Name = "SellShopController" })

local function createLocalShop(anchor: BasePart): Model?
	local templates = ReplicatedStorage:FindFirstChild("PlotTemplates")
	local template = templates and templates:FindFirstChild("SellShop")
	if not (template and template:IsA("Model") and template.PrimaryPart) then
		return nil
	end

	local shop = template:Clone()
	if not shop then
		return nil
	end
	local primaryPart = shop.PrimaryPart
	if not primaryPart then
		shop:Destroy()
		return nil
	end

	-- SellShopAnchor has local X up, while ActivationCircle has local Y up.
	local anchorFrame = anchor.CFrame
	local target = CFrame.fromMatrix(anchorFrame.Position, anchorFrame.LookVector, anchorFrame.RightVector)
	shop:PivotTo(target * primaryPart.CFrame:ToObjectSpace(shop:GetPivot()))

	local props = Workspace:FindFirstChild("LocalPlotProps")
	if not props then
		props = Instance.new("Folder")
		props.Name = "LocalPlotProps"
		props.Parent = Workspace
	end
	shop.Parent = props
	return shop
end

local function priceText(value: number): string
	return "+$" .. NumberUtil.FormatItemPriceCompact(value)
end

local function applyMutation(label: TextLabel, mutationId: string?, titleFrame: Instance?)
	for _, child in label:GetChildren() do
		if child:IsA("UIGradient") or child:IsA("UIStroke") then
			child:Destroy()
		end
	end
	local source = mutationId and titleFrame and titleFrame:FindFirstChild("MutationLabel_" .. mutationId)
	label.Visible = source ~= nil and source:IsA("TextLabel")
	if not label.Visible then
		return
	end
	label.Text = source.Text
	label.FontFace = source.FontFace
	label.TextColor3 = source.TextColor3
	label.RichText = source.RichText
	label.TextStrokeColor3 = source.TextStrokeColor3
	label.TextStrokeTransparency = source.TextStrokeTransparency
	for _, child in source:GetChildren() do
		if child:IsA("UIGradient") or child:IsA("UIStroke") then
			child:Clone().Parent = label
		end
	end
end

function SellShopController:KnitStart()
	local playerGui = localPlayer:WaitForChild("PlayerGui")
	local gui = playerGui:WaitForChild("SellGui", 10)
	local frame = gui and gui:FindFirstChild("Frame")
	local list = frame and frame:FindFirstChild("ScrollingFrame")
	local template = list and list:FindFirstChild("Template")
	local sellAll = list and list:FindFirstChild("SellAll")
	local closeButton = frame and frame:FindFirstChild("CloseButton")
	if not (gui and gui:IsA("ScreenGui") and template and sellAll and closeButton) then
		warn("SellShopController: SellGui template is missing")
		return
	end
	local confirmFrame = gui:FindFirstChild("SellConfirmFrame")
	local confirmLabel = confirmFrame and confirmFrame:FindFirstChild("ConfirmTextLabel")
	local confirmButton = confirmFrame and confirmFrame:FindFirstChild("ConfirmButton")
	local cancelButton = confirmFrame and confirmFrame:FindFirstChild("CancelButton")
	local canConfirm = confirmFrame ~= nil
		and confirmFrame:IsA("Frame")
		and confirmLabel ~= nil
		and confirmLabel:IsA("TextLabel")
		and confirmButton ~= nil
		and confirmButton:IsA("GuiButton")
		and cancelButton ~= nil
		and cancelButton:IsA("GuiButton")
	if confirmFrame and confirmFrame:IsA("GuiObject") then
		confirmFrame.Visible = false
	end
	local titleGui = playerGui:WaitForChild("TitleGui")
	local titleTemplate = titleGui:FindFirstChild("FishTitleTemplate")
	local titleFrame = titleTemplate and titleTemplate:FindFirstChild("Frame")
	local service = Knit.GetService("SellService")
	local rows = {}
	local inventory, visit, currentAnchor, currentCharacter
	local localShop
	local warnedMissingShop = false
	local requestPending, loading, closing, refreshQueued = false, false, false, false
	local fetchSerial = 0
	local pendingSale

	local function updateButtons()
		local available = inventory ~= nil
			and not loading
			and not requestPending
			and pendingSale == nil
			and not closing
		sellAll.SellButton.Interactable = canConfirm and available and #inventory.items > 0
		for _, row in rows do
			row.frame.SellButton.Interactable = available
		end
	end
	local function setNavigationFocus(button: GuiButton, selectNow: boolean)
		GuiAnimation.ResetNavigationFocus(gui, button)
		if
			selectNow
			and gui.Enabled
			and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
			and not GuiService.MenuIsOpen
		then
			GuiService.SelectedObject = button
		end
	end
	local function clearConfirmation(restoreFocus: boolean)
		local sale = pendingSale
		if not sale then
			return
		end
		pendingSale = nil
		confirmFrame.Visible = false
		list.ScrollingEnabled = sale.scrollingEnabled
		updateButtons()
		setNavigationFocus(sellAll.SellButton, restoreFocus)
	end
	local function close()
		clearConfirmation(false)
		fetchSerial += 1
		loading = false
		if gui.Enabled and not closing then
			closing = true
			updateButtons()
			GuiAnimation.CloseGui(gui)
		end
	end
	local function stillHere(ticket): boolean
		return visit == ticket
			and ticket ~= nil
			and localPlayer.Character == currentCharacter
			and SellShopZone.GetOwnedAnchor(localPlayer) == currentAnchor
			and SellShopZone.CanSell(localPlayer)
	end
	local refresh
	local function queueRefresh()
		if refreshQueued or not gui.Enabled or closing then
			return
		end
		refreshQueued = true
		task.defer(function()
			refreshQueued = false
			if gui.Enabled and not closing and not requestPending then
				refresh(false)
			end
		end)
	end
	local function requestSale(ids, total)
		if requestPending or closing or not gui.Enabled or not SellShopZone.CanSell(localPlayer) then
			return
		end
		requestPending = true
		loading = false
		fetchSerial += 1
		updateButtons()
		service
			:RequestSellItems(ids, total)
			:andThen(function(result)
				if not result or not result.success then
					NotificationClient.RedNotify((result and result.errorMessage) or "Could not complete the sale.")
					return
				end
				local sounds = ReplicatedStorage:FindFirstChild("Sound")
				local cashSounds = sounds and sounds:FindFirstChild("CollectCash")
				local sound = cashSounds and cashSounds:FindFirstChild("CashRegister")
				if sound and sound:IsA("Sound") then
					SoundHelper.PlaySound(sound)
				end
				NotificationClient.GreenNotify(
					string.format(
						"Sold %d fish for $%s!",
						result.soldCount,
						NumberUtil.FormatItemPriceCompact(result.earnedCash)
					)
				)
				GuiAnimationUtil.PlayCharacterCashGain(localPlayer.Character, result.earnedCash)
			end)
			:catch(function(err)
				warn("SellShopController: sale request failed", err)
				NotificationClient.RedNotify("Could not complete the sale. Please try again.")
			end)
			:finally(function()
				requestPending = false
				updateButtons()
				queueRefresh()
			end)
	end
	local function render(result)
		inventory = result
		local kept = {}
		for index, entry in result.items do
			local id = entry.instanceId
			local row = rows[id]
			if not row then
				local clone = template:Clone()
				clone.Name = "Fish_" .. id
				clone.Visible = true
				clone.Parent = list
				row = { frame = clone }
				rows[id] = row
				ButtonAnimation.SetUp(clone.SellButton)
				row.connection = clone.SellButton.Activated:Connect(function()
					if pendingSale == nil and row.entry then
						requestSale({ id }, row.entry.price)
					end
				end)
			end
			row.entry = entry
			kept[id] = true
			local card = row.frame
			local fish = FishInventoryData[entry.itemId]
			card.LayoutOrder = index
			card.NameLabel.Text = fish.DisplayName
			GuiUtil.SetRarityGradient(card.NameLabel, fish.Rarity)
			card.PriceLabel.Text = priceText(entry.price)
			card.CpsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(entry.income) .. "/s"
			card.SellButton.NumberLabel.Text = "SELL"
			card.DisplayImage.ICON.Image = fish.Icon or ""
			FishIconPresentation.ApplyMutation(card.DisplayImage.ICON, entry.mutationId)
			applyMutation(card.MutationLabel, entry.mutationId, titleFrame)
		end
		for id, row in rows do
			if not kept[id] then
				row.connection:Disconnect()
				row.frame:Destroy()
				rows[id] = nil
			end
		end
		sellAll.SellButton.NumberLabel.Text = string.format("SELL ALL (%d)", #result.items)
		sellAll.PriceLabel.Text = priceText(result.totalPrice)
		updateButtons()
	end
	refresh = function(openAfter: boolean)
		fetchSerial += 1
		local serial, ticket = fetchSerial, visit
		loading = true
		updateButtons()
		service
			:GetSellInventory()
			:andThen(function(result)
				if serial ~= fetchSerial or not stillHere(ticket) or closing then
					return
				end
				loading = false
				if not result or not result.success then
					NotificationClient.RedNotify((result and result.errorMessage) or "Could not load the sell shop.")
					updateButtons()
					return
				end
				if
					openAfter
					and (not GameplayInputGate.IsWorldActionAllowed() or not GuiAnimation.IsAllPopupGuisClosed())
				then
					visit = nil
					return
				end
				render(result)
				if openAfter then
					GuiAnimation.OpenGui(gui)
				end
			end)
			:catch(function(err)
				if serial == fetchSerial and stillHere(ticket) then
					loading = false
					updateButtons()
					warn("SellShopController: inventory request failed", err)
					NotificationClient.RedNotify("Could not load the sell shop. Please try again.")
				end
			end)
	end

	gui.Enabled = false
	template.Visible = false
	sellAll.LayoutOrder = 0
	sellAll.SellButton.NumberLabel.Text = "SELL ALL (0)"
	sellAll.PriceLabel.Text = priceText(0)
	ButtonAnimation.SetUp(closeButton)
	ButtonAnimation.SetUp(sellAll.SellButton)
	closeButton.Activated:Connect(close)
	GuiAnimation.SetNavigationOptions(gui, sellAll.SellButton, function()
		if pendingSale then
			clearConfirmation(true)
		else
			close()
		end
	end)
	GuiUtil.AutoResizeScrollingFrame(gui)
	gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not gui.Enabled then
			clearConfirmation(false)
			fetchSerial += 1
			loading, closing, inventory = false, false, nil
			updateButtons()
		end
	end)
	if canConfirm then
		confirmLabel.RichText = true
		confirmFrame.SelectionGroup = true
		confirmFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		confirmFrame.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		confirmFrame.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
		confirmFrame.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		confirmButton.NextSelectionRight = cancelButton
		cancelButton.NextSelectionLeft = confirmButton
		ButtonAnimation.SetUp(confirmButton)
		ButtonAnimation.SetUp(cancelButton)
		cancelButton.Activated:Connect(function()
			clearConfirmation(true)
		end)
		confirmButton.Activated:Connect(function()
			local sale = pendingSale
			if not sale then
				return
			end
			clearConfirmation(true)
			if stillHere(sale.ticket) then
				requestSale(sale.ids, sale.total)
			end
		end)
		sellAll.SellButton.Activated:Connect(function()
			if
				requestPending
				or loading
				or closing
				or pendingSale
				or not gui.Enabled
				or not inventory
				or #inventory.items == 0
				or not stillHere(visit)
			then
				return
			end
			local ids = {}
			for _, entry in inventory.items do
				table.insert(ids, entry.instanceId)
			end
			local total = inventory.totalPrice
			pendingSale = { ids = ids, total = total, ticket = visit, scrollingEnabled = list.ScrollingEnabled }
			confirmLabel.Text = string.format(
				'Sell <font color="#FFD83D">%d</font> fish for <font color="#8FFF2A">$%s</font>?',
				#ids,
				NumberUtil.FormatItemPriceCompact(total)
			)
			confirmFrame.Visible = true
			list.ScrollingEnabled = false
			updateButtons()
			setNavigationFocus(cancelButton, true)
		end)
	else
		warn("SellShopController: SellConfirmFrame template is missing or incomplete")
	end
	Knit.GetService("PlotFishService").EquippedFishChanged:Connect(queueRefresh)
	Knit.GetService("GamePassService").GiveGamePass:Connect(queueRefresh)
	local elapsed = 0
	RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		if elapsed < 0.1 then
			return
		end
		elapsed = 0
		local anchor, character = SellShopZone.GetOwnedAnchor(localPlayer), localPlayer.Character
		if anchor ~= currentAnchor and localShop then
			localShop:Destroy()
			localShop = nil
		end
		if anchor ~= currentAnchor or character ~= currentCharacter then
			currentAnchor, currentCharacter, visit = anchor, character, nil
			close()
		end
		if anchor and not localShop then
			localShop = createLocalShop(anchor)
			if not localShop and not warnedMissingShop then
				warnedMissingShop = true
				warn("SellShopController: PlotTemplates.SellShop or its cloneable PrimaryPart is missing")
			end
		end
		if not anchor or not SellShopZone.Contains(anchor, character, SellShopZone.ExitMargin) then
			visit = nil
			close()
			return
		end
		if
			visit
			or gui.Enabled
			or closing
			or requestPending
			or loading
			or not SellShopZone.Contains(anchor, character, 0)
			or localPlayer:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) ~= true
			or not GameplayInputGate.IsWorldActionAllowed()
			or not GuiAnimation.IsAllPopupGuisClosed()
		then
			return
		end
		visit = {}
		refresh(true)
	end)
	localPlayer.CharacterRemoving:Connect(function()
		visit = nil
		close()
	end)
	updateButtons()
end

return SellShopController
