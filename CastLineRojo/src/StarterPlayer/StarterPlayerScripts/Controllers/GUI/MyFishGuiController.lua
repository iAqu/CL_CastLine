local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishIconPresentation = require(Modules.FishIconPresentation)
local FishInventoryData = require(Modules.FishInventoryData)
local GuiAnimation = require(Modules.GuiAnimation)
local GuiHelper = require(Modules.GuiHelper)
local GuiUtil = require(Modules.GuiUtil)
local MutationDataUtil = require(Modules.MutationDataUtil)
local NotificationClient = require(Modules.NotificationClient)
local NumberUtil = require(Modules.NumberUtil)
local RarityConfig = require(Modules.RarityConfig)
local WeightFormat = require(Modules.WeightFormat)

local MyFishGuiController = Knit.CreateController({ Name = "MyFishGuiController" })
local SLIDE_IN = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local SLIDE_OUT = TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function offscreenRight(target: GuiObject, homePosition: UDim2, margin: number): UDim2
	local offset = math.ceil(target.AbsoluteSize.X * target.AnchorPoint.X + margin)
	return UDim2.new(1, offset, homePosition.Y.Scale, homePosition.Y.Offset)
end

function MyFishGuiController:KnitStart()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local gui = playerGui:WaitForChild("MyFishGui", 10)
	local home = playerGui:FindFirstChild("HomeGui")
	local right = home and home:FindFirstChild("RightFrame")
	local openButton = right and right:FindFirstChild("MyFishButton")
	local frame = gui and gui:FindFirstChild("Frame")
	local header = frame and frame:FindFirstChild("Header")
	local closeButton = header and header:FindFirstChild("CloseButton")
	local upgradeButton = header and header:FindFirstChild("UpgradeButton")
	local list = frame and frame:FindFirstChild("List")
	local countLabel = list and list:FindFirstChild("PlotHeader")
	local empty = list and list:FindFirstChild("EmptyState")
	local scroll = list and list:FindFirstChild("Rows")
	local template = scroll and scroll:FindFirstChild("Row_1")
	local equipBest = frame and frame:FindFirstChild("EquipBest")
	local equipButton = equipBest and equipBest:FindFirstChild("Button")
	if not (gui and gui:IsA("ScreenGui") and frame and frame:IsA("Frame")
		and right and right:IsA("GuiObject")
		and openButton and openButton:IsA("GuiButton")
		and closeButton and closeButton:IsA("GuiButton") and upgradeButton and upgradeButton:IsA("GuiButton")
		and countLabel and countLabel:IsA("TextLabel") and empty and empty:IsA("TextLabel")
		and scroll and scroll:IsA("ScrollingFrame") and template and template:IsA("Frame")
		and equipButton and equipButton:IsA("GuiButton"))
	then
		warn("MyFishGuiController: missing MyFishGui layout or HomeGui button")
		return
	end

	template.Visible = false
	upgradeButton.Interactable = false
	upgradeButton.Selectable = false
	local service = Knit.GetService("PlotFishService")
	local roster
	local rows = {}
	local missingIcons = {}
	local pending = false
	local loadError = false
	local opening = false
	local isOpen = false
	local panelHome = frame.Position
	local panelTween: Tween? = nil

	local function panelAwayPosition(): UDim2
		return offscreenRight(frame, panelHome, frame.AbsoluteSize.X * 0.3 + 12)
	end

	local function finishClose()
		gui.Enabled = false
		frame.Position = panelHome
	end

	local function setDockOpen(shouldOpen: boolean, immediately: boolean)
		if isOpen == shouldOpen and not immediately then
			return
		end
		isOpen = shouldOpen
		if panelTween then
			local previousTween = panelTween
			panelTween = nil
			previousTween:Cancel()
		end
		if immediately and not shouldOpen then
			finishClose()
			return
		end

		if shouldOpen and not gui.Enabled then
			frame.Position = panelAwayPosition()
			gui.Enabled = true
		end

		local panel = TweenService:Create(frame, if shouldOpen then SLIDE_IN else SLIDE_OUT, {
			Position = if shouldOpen then panelHome else panelAwayPosition(),
		})
		panelTween = panel
		panel.Completed:Once(function(state)
			if state ~= Enum.PlaybackState.Completed or panelTween ~= panel then
				return
			end
			panelTween = nil
			if not shouldOpen then
				finishClose()
			end
		end)
		panel:Play()
	end

	local function resizeRows()
		local height = math.max(1, math.round(list.AbsoluteSize.Y * 0.205))
		for _, row in pairs(rows) do
			row.Size = UDim2.new(template.Size.X.Scale, template.Size.X.Offset, 0, height)
		end
	end

	local function updateButtons()
		equipButton.Interactable = roster ~= nil and not pending
		for _, row in pairs(rows) do
			row.Buttons.UnequipButton.Interactable = not pending
		end
	end

	local function request(callback)
		if pending or not isOpen or not gui.Enabled or not roster then
			return
		end
		pending = true
		updateButtons()
		callback():andThen(function(result)
			if not result or not result.ok then
				NotificationClient.RedNotify((result and result.message) or "Could not update your equipped fish.")
			end
		end):catch(function()
			NotificationClient.RedNotify("Could not update your equipped fish.")
		end):finally(function()
			pending = false
			updateButtons()
		end)
	end

	local function updateRow(row, entry, item)
		row.Info.AnimalName.Text = item.DisplayName
		GuiUtil.SetRarityGradient(row.Info.AnimalName, item.Rarity)
		row.Info.Rarity.Text = RarityConfig.Normalize(item.Rarity)
		GuiUtil.SetRarityGradient(row.Info.Rarity, item.Rarity)
		GuiUtil.SetRarityGradient(row.Preview, item.Rarity)
		row.Preview.Weight.Text = WeightFormat.FormatKg(entry.weight)
		row.Info.Income.Text = "$" .. NumberUtil.FormatItemPriceCompact(entry.income) .. "/s"
		local mutation = MutationDataUtil.GetConfig(entry.mutationId)
		row.Info.Mutation.Text = if mutation then mutation.DisplayName else ""
		row.Info.Mutation.Visible = mutation ~= nil
		local preview = row.Preview.AnimalPreview
		local image = item.Icon
		local validImage = typeof(image) == "string" and image:match("^rbxassetid://[1-9]%d*$") ~= nil
		preview.Image = if validImage then image else ""
		preview.ScaleType = Enum.ScaleType.Fit
		preview.Visible = validImage
		FishIconPresentation.ApplyMutation(preview, if validImage then entry.mutationId else nil)
		if not validImage and not missingIcons[entry.itemId] then
			missingIcons[entry.itemId] = true
			warn("MyFishGuiController: missing fish icon", entry.itemId)
		end
	end

	local function addRow(entry)
		local row = template:Clone()
		row.Name = "Fish_" .. entry.uid
		local button = row.Buttons.UnequipButton
		button.Activated:Connect(function()
			request(function()
				return service:RequestUnequip(entry.uid)
			end)
		end)
		row.Visible = true
		row.Parent = scroll
		rows[entry.uid] = row
		return row
	end

	local function render()
		local entries = if roster then roster.fish else {}
		local shown = 0
		local kept = {}
		local previous = closeButton
		local restoreFocus = false
		for _, entry in entries do
			local item = FishInventoryData[entry.itemId]
			if not item then
				continue
			end
			local row = rows[entry.uid] or addRow(entry)
			updateRow(row, entry, item)
			shown += 1
			kept[entry.uid] = true
			row.LayoutOrder = shown
			local button = row.Buttons.UnequipButton
			button.NextSelectionUp = previous
			previous.NextSelectionDown = button
			previous = button
		end
		previous.NextSelectionDown = equipButton
		equipButton.NextSelectionUp = previous
		equipButton.NextSelectionDown = closeButton
		closeButton.NextSelectionUp = equipButton

		for uid, row in pairs(rows) do
			if not kept[uid] then
				restoreFocus = restoreFocus or GuiService.SelectedObject == row.Buttons.UnequipButton
				row:Destroy()
				rows[uid] = nil
			end
		end
		if restoreFocus and gui.Enabled then
			GuiService.SelectedObject = closeButton
		end

		local capacity = roster and roster.capacity or 0
		local suffix = if shown == capacity then " MAX" else ""
		countLabel.Text = if roster then ` <font color="#75FF26">{shown}/{capacity}</font>{suffix}` else ""
		empty.Text = if roster then "No fish equipped" elseif loadError then "Fish list unavailable" else "Loading..."
		empty.Visible = shown == 0
		resizeRows()
		updateButtons()
	end

	local function accept(snapshot)
		if snapshot and (not roster or snapshot.revision >= roster.revision) then
			roster = snapshot
			if gui.Enabled then
				render()
			end
		end
	end

	local function close()
		GuiAnimation.CloseGui(gui)
	end

	gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not gui.Enabled and (isOpen or panelTween) then
			setDockOpen(false, true)
		end
	end)
	list:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeRows)
	GuiAnimation.SetTransition(gui, setDockOpen)
	GuiAnimation.SetNavigationOptions(gui, closeButton, close)
	closeButton.Activated:Connect(close)
	service.EquippedFishChanged:Connect(accept)
	equipButton.Activated:Connect(function()
		request(function()
			return service:RequestEquipBest()
		end)
	end)
	openButton.Activated:Connect(function()
		if opening or isOpen or not GuiHelper.CanOpenGui() then
			return
		end
		opening = true
		loadError = false
		scroll.CanvasPosition = Vector2.zero
		render()
		GuiAnimation.OpenGui(gui)
		opening = false
		if not isOpen then
			return
		end
		service:GetEquippedFish():andThen(function(snapshot)
			if snapshot then
				accept(snapshot)
			elseif not roster then
				loadError = true
				render()
			end
		end):catch(function()
			if not roster then
				loadError = true
				render()
			end
		end)
	end)
end

return MyFishGuiController
