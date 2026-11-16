local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PetsData = require(ReplicatedFirst.Data.PetsData)
local EggsData = require(ReplicatedFirst.Data.EggsData)
local PetInventory = require(ReplicatedStorage.Modules.PetInventory)
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)
local ItemBoundsUtil = require(ReplicatedStorage.Modules.ItemBoundsUtil)
local EggToolUtil = require(ReplicatedStorage.Modules.EggToolUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local HoverGuiClient = require(ReplicatedStorage.Modules.HoverGuiClient)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local RarityConfig = require(ReplicatedStorage.Modules.RarityConfig)

local player = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "PetGuiController" })
local SIZE_NAMES = { [0] = "Baby", [1] = "Big", [2] = "Huge" }

local function text(root, name, value)
	local label = root:FindFirstChild(name, true)
	if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
		label.Text = value
	end
end

local function visible(root, name, value)
	local object = root:FindFirstChild(name, true)
	if object and object:IsA("GuiObject") then
		object.Visible = value
	end
end

local function image(root, config, pet)
	local portrait = root:FindFirstChild("PortraitFrame", true)
	local label = portrait and portrait:FindFirstChild("ImageLabel")
	label = label or root:FindFirstChild("PetImage", true)
	if label and label:IsA("ImageLabel") then
		label.Image = string.format("rbxassetid://%.0f", config.IconId)
		label.Visible = true
		if portrait then
			local scale = 1 + PetInventory.GetSize(pet) * 0.5
			label.Size = UDim2.fromScale(scale, scale)
			portrait.Visible = true
			local simple = config.Rarity == "Common" or config.Rarity == "Rare" or config.Rarity == "Epic"
			visible(portrait, "BgImage_1", simple)
			visible(portrait, "BgImage_2", not simple)
			local background = portrait:FindFirstChild(if simple then "BgImage_1" else "BgImage_2")
			if background then
				GuiUtil.SetRarityGradient(background, config.Rarity)
			end
		end
	end
end

local function button(root, name, callback)
	local object = root:FindFirstChild(name, true)
	if object and object:IsA("GuiButton") then
		object.Activated:Connect(callback)
	end
end

local function boost(pet)
	return string.format("+%g%% Luck", PetInventory.GetLuckBoost(pet, PetsData) * 100)
end

local function sizeIcon(root, pet)
	local icon = root:FindFirstChild("SizeImage", true)
	if icon then
		local size = PetInventory.GetSize(pet)
		icon.Image, icon.Visible = PetInventory.SIZE_ICONS[size], size > 0
	end
end

local function canDelete(pet)
	return pet ~= nil and not pet.Locked and not pet.Equipped
end

function Controller:_pruneSelections()
	for uuid in pairs(self._selectedDelete) do
		if not canDelete(self._state.Pets[uuid]) then
			self._selectedDelete[uuid] = nil
		end
	end
	for uuid in pairs(self._draftLocks) do
		if not self._state.Pets[uuid] then
			self._draftLocks[uuid] = nil
		end
	end
	if self._lockMode then
		for uuid, pet in pairs(self._state.Pets) do
			if self._draftLocks[uuid] == nil then
				self._draftLocks[uuid] = pet.Locked == true
			end
		end
	end
end

function Controller:_renderCraftControls()
	local main = self._gui.Frame.PetsFrame
	local hasPets = next(self._state.Pets) ~= nil
	local busy = self._pending ~= nil
	main.EquipBestButton.Visible = hasPets and not self._lockMode
	main.CraftAllButton.Visible = hasPets and not self._lockMode
	main.UnquipAllButton.Visible = hasPets
	main.MultiDeleteButton.Visible = hasPets and not self._deleteMode and not self._lockMode
	main.MultiLockButton.Visible = hasPets and not self._deleteMode
	text(main.EquipBestButton, "NameLabel", if self._deleteMode then "Cancel" else "Equip Best")
	-- Some WR buttons contain both direct text and a NameLabel.
	main.EquipBestButton.Text = ""
	text(main.CraftAllButton, "NameLabel", if self._deleteMode then "Select All" else "Craft All")
	text(
		main.UnquipAllButton,
		"NameLabel",
		if self._deleteMode
			then string.format("Delete! (%d)", PetInventory.Count(self._selectedDelete))
			else if self._lockMode then "Done" else "Unequip ALL"
	)
	visible(main.UnquipAllButton, "Delete", self._deleteMode == true)
	visible(main.UnquipAllButton, "UnquipAll", not self._deleteMode)
	for _, name in ipairs({
		"EquipBestButton",
		"CraftAllButton",
		"UnquipAllButton",
		"MultiDeleteButton",
		"MultiLockButton",
	}) do
		main[name].Interactable = not busy
	end
	self._gui.DeleteConfirmFrame.ConfirmButton.Interactable = not busy
	self._gui.DeleteConfirmFrame.CancelButton.Interactable = not busy
end

function Controller:_setMode(mode)
	if self._pending then
		return
	end
	self._deleteMode, self._lockMode = mode == "delete", mode == "lock"
	self._selectedDelete, self._draftLocks = {}, {}
	self._gui.DeleteConfirmFrame.Visible = false
	HoverGuiClient.HideInfoHover()
	self:_pruneSelections()
	self:_renderPets()
end

function Controller:_craft(all)
	if self._pending or (all and (self._deleteMode or self._lockMode)) then
		return
	end
	local pet = self._state.Pets[self._selected]
	if not all and not pet then
		return
	end
	if self._deleteMode then
		self:_setMode("normal")
	end
	self._craftBusy = true
	local request = if all
		then self._service:CraftAllPets()
		else self._service:CraftPet(pet.UUID, PetInventory.GetSize(pet))
	self:_request(request, function()
		NotificationClient.GreenNotify(if all then "Craft All success!" else "Craft success!")
	end)
end

local function makeViewport(parent)
	local viewport = Instance.new("ViewportFrame")
	viewport.Name, viewport.BackgroundTransparency = "HatchViewport", 1
	viewport.AnchorPoint, viewport.Position, viewport.Size =
		Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.4), UDim2.fromScale(0.55, 0.65)
	viewport.Ambient, viewport.LightColor = Color3.new(1, 1, 1), Color3.new(1, 1, 1)
	viewport.LightDirection = Vector3.new(-1, -1, -1)
	local world = Instance.new("WorldModel")
	world.Parent = viewport
	local camera = Instance.new("Camera")
	camera.FieldOfView, camera.Parent = 40, viewport
	viewport.CurrentCamera, viewport.Parent = camera, parent
	return viewport, world, camera
end

local function preview(world, camera, template)
	world:ClearAllChildren()
	local model = template:Clone()
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BaseScript") then
			part:Destroy()
		elseif part:IsA("BasePart") then
			part.Anchored, part.CanCollide = true, false
		end
	end
	model:PivotTo(model.PrimaryPart.CFrame:ToObjectSpace(model:GetPivot()))
	model.Parent = world
	local frame, size = ItemBoundsUtil.GetWorldAxisBounds(model)
	local distance = math.max(size.X, size.Y, size.Z) * 1.8
	camera.CFrame =
		CFrame.lookAt(frame.Position + Vector3.new(distance * 0.3, distance * 0.15, -distance), frame.Position)
	return model
end

function Controller:_request(promise, onSuccess)
	local token = { session = self._session }
	self._pending = token
	self:_renderCraftControls()
	self:_renderDetail()
	promise
		:andThen(function(result)
			if token.session ~= self._session or not self._gui.Enabled then
				return
			end
			if result == false or (type(result) == "table" and result.ok == false) then
				NotificationClient.RedNotify(
					if type(result) == "table" then result.message or "Request failed" else "Request failed"
				)
				self:_pruneSelections()
			elseif onSuccess then
				onSuccess(result)
			end
		end)
		:catch(function(err)
			warn("PetGuiController: " .. tostring(err))
			if token.session == self._session and self._gui.Enabled then
				NotificationClient.RedNotify("Request failed. Please try again.")
			end
		end)
		:finally(function()
			if self._pending == token then
				self._pending, self._craftBusy = nil, false
				self:_renderPets()
			end
		end)
end

function Controller:_cancelDetailTweens()
	for _, tween in ipairs(self._detailTweens or {}) do
		tween:Cancel()
		tween:Destroy()
	end
	self._detailTweens = {}
end

function Controller:_toggleDetail(show, immediately)
	self:_cancelDetailTweens()
	self._showDetail = show
	local gridSize = if show
		then UDim2.new(
			self._gridSize.X.Scale * 4 / 7,
			self._gridSize.X.Offset,
			self._gridSize.Y.Scale,
			self._gridSize.Y.Offset
		)
		else self._gridSize
	local function scaled(value)
		return if show then UDim2.new(value.X.Scale * 7 / 4, value.X.Offset, value.Y.Scale, value.Y.Offset) else value
	end
	local layout = self._grid.UIGridLayout
	layout.CellSize, layout.CellPadding = scaled(self._cellSize), scaled(self._cellPadding)
	local position = UDim2.fromScale(if show then 0.99 else 1.44, 0.5)
	if immediately or not self._gui.Enabled then
		self._grid.Size, self._detail.Position, self._detail.Visible = gridSize, position, show
		return
	end
	if show then
		self._detail.Visible = true
	end
	local gridTween = TweenService:Create(
		self._grid,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = gridSize }
	)
	local detailTween = TweenService:Create(
		self._detail,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = position }
	)
	detailTween.Completed:Once(function(state)
		if state == Enum.PlaybackState.Completed and not self._showDetail then
			self._detail.Visible = false
		end
	end)
	self._detailTweens = { gridTween, detailTween }
	gridTween:Play()
	detailTween:Play()
end

function Controller:_selectPet(uuid)
	local show = self._selected ~= uuid or not self._showDetail
	self._selected = uuid
	self:_renderDetail()
	self:_toggleDetail(show)
end

function Controller:_renderDetail()
	local detail = self._detail
	local pet = self._state.Pets[self._selected]
	if not pet then
		if self._selected then
			self._selected = nil
			self:_toggleDetail(false)
		end
		return
	end
	local config = PetsData[pet.PetID]
	text(detail, "NameLabel", SIZE_NAMES[PetInventory.GetSize(pet)] .. " " .. config.Name)
	text(detail, "RarityLabel", config.Rarity)
	text(detail, "BoostLabel", boost(pet))
	visible(detail, "Equip", not pet.Equipped)
	visible(detail, "Unequip", pet.Equipped)
	image(detail, config, pet)
	local rarity = RarityConfig.Get(config.Rarity)
	detail.RarityLabel.BackgroundColor3 = rarity.Color
	detail.PetViewFrame.BackgroundColor3 = rarity.Color
	detail.EquipButton.Interactable = self._pending == nil
	sizeIcon(detail, pet)
	local size = PetInventory.GetSize(pet)
	local count = PetInventory.GetCraftCount(self._state, pet)
	local craft = detail.CraftButton
	craft.Visible = true
	craft.Interactable = self._pending == nil and not pet.Locked and size < 2 and count >= 3
	text(
		craft,
		"NameLabel",
		if size == 2
			then "Max Size reached!"
			else string.format("Craft into %s! %d/3", if size == 0 then "Big" else "Huge", count)
	)
	craft.PetSizeImage.Image = if size < 2 then PetInventory.SIZE_ICONS[size + 1] else ""
	for _, name in ipairs({
		"LevelLabel",
		"EvolutionLabel",
		"EvolutionImage",
		"LevelUpButton",
	}) do
		visible(detail, name, false)
	end
end

function Controller:_renderHover(frame, uuid)
	local pet = self._state.Pets[uuid]
	if not pet then
		HoverGuiClient.HideInfoHover()
		return
	end
	local config = PetsData[pet.PetID]
	text(frame, "NameLabel", SIZE_NAMES[PetInventory.GetSize(pet)] .. " " .. config.Name)
	text(frame, "RarityLabel", config.Rarity)
	frame.Container.RarityLabel.TextColor3 = RarityConfig.Get(config.Rarity).Color
	GuiUtil.SetRarityGradient(frame, config.Rarity)
	text(frame, "BoostLabel", boost(pet))
	visible(frame, "RevolutionLabel", false)
	visible(frame, "InfoLabel", false)
	for _, icon in ipairs(frame.Container.PetSizeFrame:GetChildren()) do
		if icon:IsA("ImageLabel") then
			local size = tonumber(icon.Name)
			icon.Visible = size ~= nil and size <= 2
			local selected = size == PetInventory.GetSize(pet)
			icon.ImageColor3 = if selected then Color3.fromRGB(33, 33, 33) else Color3.fromRGB(152, 152, 152)
			icon.TextLabel.TextColor3 = if selected then Color3.fromRGB(18, 195, 252) else Color3.new(1, 1, 1)
		end
	end
end

function Controller:_clickPet(uuid)
	if self._pending or self._gui.DeleteConfirmFrame.Visible then
		return
	end
	local pet = self._state.Pets[uuid]
	if not pet then
		return
	end
	if self._deleteMode then
		if canDelete(pet) then
			self._selectedDelete[uuid] = if self._selectedDelete[uuid] then nil else true
		end
	elseif self._lockMode then
		self._draftLocks[uuid] = not self._draftLocks[uuid]
	else
		self:_selectPet(uuid)
		return
	end
	self:_renderPets()
end

function Controller:_renderPets()
	if not self._ready then
		return
	end
	self:_pruneSelections()
	for _, child in ipairs(self._grid:GetChildren()) do
		if child:GetAttribute("PetEntry") and not self._state.Pets[child.Name] then
			HoverGuiClient.HideInfoHover()
			HoverGuiClient.RemoveHoverConnection(child)
			child:Destroy()
		end
	end
	local pets = {}
	for _, pet in pairs(self._state.Pets) do
		table.insert(pets, pet)
	end
	table.sort(pets, function(a, b)
		if a.Equipped ~= b.Equipped then
			return a.Equipped
		end
		local left, right = PetInventory.GetLuckBoost(a, PetsData), PetInventory.GetLuckBoost(b, PetsData)
		return if left == right then a.UUID < b.UUID else left > right
	end)
	for order, pet in ipairs(pets) do
		local config = PetsData[pet.PetID]
		local row = self._grid:FindFirstChild(pet.UUID)
		if not row then
			row = self._template:Clone()
			row.Name, row.Visible = pet.UUID, true
			row:SetAttribute("PetEntry", true)
			button(row, "PetButton", function()
				self:_clickPet(pet.UUID)
			end)
			ButtonAnimation.SetUp(row.PetButton, 1.1)
			local frame = if config.Rarity == "Secret" or config.Rarity == "Exclusive"
				then self._gui.HoverInfo_Exclusive
				else self._gui.HoverInfo
			HoverGuiClient.SetupInfoHover(row, frame, function()
				self:_renderHover(frame, pet.UUID)
			end)
			row.Parent = self._grid
		end
		row.LayoutOrder = order
		row.PetButton.Interactable = self._pending == nil and not self._gui.DeleteConfirmFrame.Visible
		text(row, "BoostLabel", string.format("+%g%%", PetInventory.GetLuckBoost(pet, PetsData) * 100))
		visible(row, "EquippedImage", pet.Equipped)
		visible(row, "LockImage", if self._lockMode then self._draftLocks[pet.UUID] == true else pet.Locked)
		visible(row, "DeleteLabel", self._selectedDelete[pet.UUID] == true)
		sizeIcon(row, pet)
		visible(row, "LevelLabel", false)
		image(row, config, pet)
	end
	local maxEquip = self._state.MaxEquipped or PetInventory.MAX_EQUIPPED
	local equipped = #PetInventory.GetEquipped(self._state)
	text(self._gui, "MaxStoreLabel", #pets .. "/" .. (self._state.MaxStored or PetInventory.MAX_STORED))
	text(self._gui, "MaxEquipLabel", equipped .. "/" .. maxEquip)
	Knit.GetController("HomeGuiController"):ShowPetNotif(equipped < math.min(#pets, maxEquip))
	self:_renderDetail()
	self:_renderCraftControls()
end

function Controller:_selectAllForDelete()
	if self._pending or not self._deleteMode then
		return
	end
	for uuid, pet in pairs(self._state.Pets) do
		if canDelete(pet) then
			self._selectedDelete[uuid] = true
		end
	end
	self:_renderPets()
end

function Controller:_confirmDelete()
	if self._pending or not self._deleteMode then
		return
	end
	self:_pruneSelections()
	local count = PetInventory.Count(self._selectedDelete)
	if count == 0 then
		self:_setMode("normal")
		return
	end
	text(self._gui.DeleteConfirmFrame, "SubtitleLabel", "Delete " .. count .. " selected pets?")
	self._gui.DeleteConfirmFrame.Visible = true
	HoverGuiClient.HideInfoHover()
	self:_renderPets()
end

function Controller:_deleteSelected()
	if self._pending or not self._deleteMode or not self._gui.DeleteConfirmFrame.Visible then
		return
	end
	self:_pruneSelections()
	local ids = {}
	for uuid in pairs(self._selectedDelete) do
		table.insert(ids, uuid)
	end
	if #ids == 0 then
		self:_setMode("normal")
		return
	end
	self:_request(self._service:DeletePets(ids), function()
		self._deleteMode, self._selectedDelete = false, {}
		self._gui.DeleteConfirmFrame.Visible = false
	end)
end

function Controller:_saveLocks()
	if self._pending or not self._lockMode then
		return
	end
	self:_pruneSelections()
	local ids = {}
	for uuid, locked in pairs(self._draftLocks) do
		if locked then
			table.insert(ids, uuid)
		end
	end
	self:_request(self._service:LockPets(ids), function()
		self._lockMode, self._draftLocks = false, {}
	end)
end

function Controller:_showNextHatch()
	if not self._ready or self._showingHatch or #self._hatchQueue == 0 then
		return
	end
	local result = table.remove(self._hatchQueue, 1)
	self._showingHatch = true
	local token = {}
	self._hatchToken = token
	local gui = self._resultGui
	local frame = gui.OneHatchResultFrame
	frame.Visible = false
	visible(gui, "TripleHatchResultFrame", false)
	visible(frame, "AutoDeleteLabel", false)
	visible(gui, "ContinueLabel", false)
	local viewport, world, camera = makeViewport(gui)
	self._hatchViewport = viewport
	GuiAnimation.OpenGui(gui)
	task.spawn(function()
		local eggConfig = EggsData[result.EggId]
		local eggTemplate = EggToolUtil.GetTemplate(eggConfig.Model)
		if eggTemplate then
			local model = preview(world, camera, eggTemplate)
			local pivot = model:GetPivot()
			for step = 1, 8 do
				if self._hatchToken ~= token then
					return
				end
				model:PivotTo(pivot * CFrame.Angles(0, 0, (if step % 2 == 0 then -1 else 1) * math.rad(8 + step)))
				task.wait(0.12)
			end
		end
		if self._hatchToken ~= token then
			return
		end
		local config = PetsData[result.Pet.PetID]
		local template = ReplicatedStorage.Models.Pets:FindFirstChild(config.Model)
		if template then
			preview(world, camera, template)
		end
		text(frame, "NameLabel", config.Name)
		text(frame, "RarityLabel", config.Rarity)
		frame.Visible = true
		visible(gui, "ContinueLabel", true)
	end)
end

function Controller:_closeHatch()
	GuiAnimation.CloseGui(self._resultGui)
end

function Controller:ResetGui()
	self._session = (self._session or 0) + 1
	self._deleteMode, self._lockMode, self._selected, self._selectedDelete, self._draftLocks = false, false, nil, {}, {}
	self._gui.DeleteConfirmFrame.Visible = false
	HoverGuiClient.HideInfoHover()
	self:_toggleDetail(false, true)
	self:_renderPets()
end

function Controller:OpenGui()
	if not PetFeatureConfig.Enabled or not self._ready or not GuiHelper.CanOpenGui() then
		return
	end
	self:ResetGui()
	GuiAnimation.OpenGui(self._gui)
end

function Controller:CloseGui()
	if not self._ready then
		return
	end
	self:ResetGui()
	GuiAnimation.CloseGui(self._gui)
end

function Controller:ToggleGui()
	if not PetFeatureConfig.Enabled or not self._ready then
		return
	end
	if self._gui.Enabled then
		self:CloseGui()
	else
		self:OpenGui()
	end
end

function Controller:_setup()
	if not PetFeatureConfig.Enabled then return end
	local playerGui = player:WaitForChild("PlayerGui")
	self._gui = playerGui:WaitForChild("PetGui", 60)
	self._resultGui = playerGui:WaitForChild("EggHatchResultGui", 60)
	if not self._gui or not self._resultGui then
		warn("PetGuiController: WR pet UI is missing")
		return
	end
	self._gui.Enabled, self._resultGui.Enabled = false, false
	local main = self._gui.Frame.PetsFrame
	self._grid = main.ContainerFrame.PetsFrame
	self._gridSize, self._cellSize, self._cellPadding =
		self._grid.Size, self._grid.UIGridLayout.CellSize, self._grid.UIGridLayout.CellPadding
	self._template = self._grid.PetTemplate
	self._template.Visible = false
	self._grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
	self._detail = main.ContainerFrame.DetailFrame
	self._detail.Visible = false
	self._gui.DeleteConfirmFrame.Visible = false
	for _, name in ipairs({
		"FruitFrame",
		"HoverInfo",
		"HoverInfo_Exclusive",
		"GuideButton",
		"AddMaxEquipButton",
		"AddMaxStoreButton",
	}) do
		visible(self._gui, name, false)
	end
	button(self._gui.Frame, "CloseButton", function()
		self:CloseGui()
	end)
	self._gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not self._gui.Enabled then
			self:ResetGui()
		end
	end)
	GuiAnimation.SetNavigationOptions(self._gui, main.EquipBestButton, function()
		self:CloseGui()
	end)
	button(main, "EquipBestButton", function()
		if self._pending or self._gui.DeleteConfirmFrame.Visible then
			return
		end
		if self._deleteMode then
			self:_setMode("normal")
		else
			self:_request(self._service:EquipBest())
		end
	end)
	button(main, "UnquipAllButton", function()
		if self._pending or self._gui.DeleteConfirmFrame.Visible then
			return
		end
		if self._deleteMode then
			self:_confirmDelete()
		elseif self._lockMode then
			self:_saveLocks()
		else
			self:_request(self._service:UnequipAll())
		end
	end)
	button(self._detail, "EquipButton", function()
		if self._pending or self._gui.DeleteConfirmFrame.Visible then
			return
		end
		local pet = self._state.Pets[self._selected]
		if pet then
			if self._deleteMode then
				self:_setMode("normal")
			end
			self:_request(self._service:EquipPet(pet.UUID, not pet.Equipped))
		end
	end)
	button(self._detail, "CraftButton", function()
		if not self._gui.DeleteConfirmFrame.Visible then
			self:_craft(false)
		end
	end)
	button(main, "CraftAllButton", function()
		if self._pending or self._gui.DeleteConfirmFrame.Visible then
			return
		end
		if self._deleteMode then
			self:_selectAllForDelete()
		else
			self:_craft(true)
		end
	end)
	button(main, "MultiDeleteButton", function()
		if not self._gui.DeleteConfirmFrame.Visible then
			self:_setMode("delete")
		end
	end)
	button(main, "MultiLockButton", function()
		if self._gui.DeleteConfirmFrame.Visible then
			return
		end
		if self._lockMode then
			self:_saveLocks()
		else
			self:_setMode("lock")
		end
	end)
	button(self._gui.DeleteConfirmFrame, "CancelButton", function()
		if not self._pending then
			self._gui.DeleteConfirmFrame.Visible = false
			self:_renderPets()
		end
	end)
	button(self._gui.DeleteConfirmFrame, "ConfirmButton", function()
		self:_deleteSelected()
	end)

	local home = playerGui:WaitForChild("HomeGui")
	button(home.RightFrame.MenuFrame_b.PetsFrame, "PetsButton", function()
		self:ToggleGui()
	end)
	GuiAnimation.SetTransition(self._resultGui, function(open)
		self._resultGui.Enabled = open
		if not open then
			self._hatchToken = nil
			if self._hatchViewport then
				self._hatchViewport:Destroy()
				self._hatchViewport = nil
			end
			self._showingHatch = false
			task.defer(function()
				self:_showNextHatch()
			end)
		end
	end)
	button(self._resultGui, "CloseButton", function()
		self:_closeHatch()
	end)
	self._ready = true
	self:ResetGui()
	self:_showNextHatch()
end

function Controller:KnitStart()
	if not PetFeatureConfig.Enabled then
		local playerGui = player:WaitForChild("PlayerGui")
		local function hidePanel(gui)
			if (gui.Name == "PetGui" or gui.Name == "EggHatchResultGui") and gui:IsA("ScreenGui") then
				gui.Enabled = false
			end
		end
		playerGui.ChildAdded:Connect(hidePanel)
		for _, gui in ipairs(playerGui:GetChildren()) do
			hidePanel(gui)
		end
		return
	end
	self._state = { Pets = {}, PetIndex = {}, LuckMultiplier = 1 }
	self._selectedDelete, self._draftLocks, self._hatchQueue = {}, {}, {}
	self._session = 0
	self._service = Knit.GetService("PetService")
	local received = false
	self._service.InventoryChanged:Connect(function(state)
		received = true
		self._state = state
		self:_renderPets()
	end)
	self._service
		:GetState()
		:andThen(function(state)
			if state and not received then
				self._state = state
				self:_renderPets()
			end
		end)
		:catch(function(err)
			warn("PetGuiController: " .. tostring(err))
		end)
	Knit.GetService("EggService").Hatched:Connect(function(result)
		table.insert(self._hatchQueue, result)
		self:_showNextHatch()
	end)
	task.spawn(function()
		self:_setup()
	end)
end

return Controller
