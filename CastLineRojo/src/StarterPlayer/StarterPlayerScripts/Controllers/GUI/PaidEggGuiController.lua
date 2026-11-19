local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Modules = ReplicatedStorage.Modules
local Config = require(Modules.PaidEggConfig)
local Layout = require(Modules.PaidEggLayout)
local Motion = require(Modules.PaidEggMotion)
local Assets = require(Modules.FishingAssets)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local PurchaseData = require(ReplicatedFirst.Data.PurchaseData)
local GuiAnimation = require(Modules.GuiAnimation)
local InputGate = require(Modules.GameplayInputGate)
local MutationVisualUtil = require(Modules.MutationVisualUtil)
local FishingSequenceInfo = require(Modules.FishingSequenceInfo)
local Effects = require(Modules.PaidEggEffects)
local CommonResult = require(Modules.CommonResultClient)
local UiConfetti = require(Modules.UiConfettiUtil)
local NotificationClient = require(Modules.NotificationClient)

local player = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "PaidEggGuiController" })
local BLOCK_ACTION = "PaidEggPresentation"
local RENDER_STEP = "PaidEggModels"
local EGG_ENTER = 0.18
local SHAKES = {
	{ Start = 0.18, Duration = 0.25, Angle = 12, Pitch = 0.92 },
	{ Start = 0.43, Duration = 0.22, Angle = 20, Pitch = 1.03 },
	{ Start = 0.65, Duration = 0.20, Angle = 28, Pitch = 1.16 },
}
local CONFIRM_TIMEOUT = 8
local OUTLINE_PIXELS = 2
local OUTLINE_SCALE = 1.045
local FISH_DEPTH = 6.6
local CAPTION_FADE = 0.16
local OUTLINE_OFFSETS = {
	Vector2.new(-OUTLINE_PIXELS, 0),
	Vector2.new(OUTLINE_PIXELS, 0),
	Vector2.new(0, -OUTLINE_PIXELS),
	Vector2.new(0, OUTLINE_PIXELS),
}

local function cloneVisual(template, mutation, outlineViewport)
	if not template then
		return nil
	end
	local model = template:Clone()
	if not model then
		return nil
	end
	for _, item in ipairs(model:GetDescendants()) do
		if item:IsA("BaseScript") then
			item:Destroy()
		elseif item:IsA("BasePart") then
			item.Anchored, item.CanCollide, item.CanTouch, item.CanQuery = true, false, false, false
		end
	end
	local bounds, size = model:GetBoundingBox()
	local pivot = model:GetPivot()
	if mutation then
		MutationVisualUtil.ApplyAppearance(model, mutation, template.Name)
	end
	local horizontalRadius, halfHeight = 0.001, 0.001
	local relativeBounds = pivot:ToObjectSpace(bounds)
	for x = -0.5, 0.5, 1 do
		for y = -0.5, 0.5, 1 do
			for z = -0.5, 0.5, 1 do
				local corner = relativeBounds:VectorToWorldSpace(Vector3.new(x * size.X, y * size.Y, z * size.Z))
				horizontalRadius = math.max(horizontalRadius, Vector2.new(corner.X, corner.Z).Magnitude)
				halfHeight = math.max(halfHeight, math.abs(corner.Y))
			end
		end
	end
	-- Each fish has one enlarged silhouette in the shared outline viewport.
	local silhouette = model:Clone()
	for _, item in ipairs(silhouette:GetDescendants()) do
		if
			item:IsA("ParticleEmitter")
			or item:IsA("Trail")
			or item:IsA("Beam")
			or item:IsA("Light")
			or item:IsA("Highlight")
			or item:IsA("LayerCollector")
		then
			item:Destroy()
		end
	end
	silhouette.Name = "PaidEggSilhouette"
	silhouette.Parent = outlineViewport
	return {
		Model = model,
		Outline = silhouette,
		CenterOffset = pivot:PointToObjectSpace(bounds.Position),
		BaseScale = model:GetScale(),
		Radius = math.max(size.Magnitude / 2, 0.001),
		HorizontalRadius = horizontalRadius,
		HalfHeight = halfHeight,
	}
end

local function prepareCaptionFade(caption)
	local fade = {}
	local function track(item, property)
		local original = item[property]
		if original < 1 then
			table.insert(fade, { Item = item, Property = property, Original = original })
			item[property] = 1
		end
	end
	track(caption, "BackgroundTransparency")
	for _, item in ipairs(caption:GetDescendants()) do
		if item:IsA("GuiObject") then
			track(item, "BackgroundTransparency")
		end
		if item:IsA("TextLabel") or item:IsA("TextButton") then
			track(item, "TextTransparency")
			track(item, "TextStrokeTransparency")
		elseif item:IsA("ImageLabel") or item:IsA("ImageButton") then
			track(item, "ImageTransparency")
		elseif item:IsA("UIStroke") then
			track(item, "Transparency")
		end
	end
	return fade
end

function Controller:_setVisuals(order, count)
	local scene = self._scene
	for _, entry in ipairs(scene.Entries) do
		if entry.Visual then
			entry.Visual.Model:Destroy()
			entry.Visual.Outline:Destroy()
		end
		entry.Fallback:Destroy()
		if entry.IconOutlines then
			for _, outline in ipairs(entry.IconOutlines) do
				outline:Destroy()
			end
		end
		if entry.Caption then
			entry.Caption:Destroy()
		end
	end
	scene.Entries = {}
	scene.ViewportSize = nil
	if order and not scene.OutlineViewport then
		local outline = Instance.new("ViewportFrame")
		outline.Name = "PaidEggOutlines"
		outline.Size = UDim2.fromScale(1, 1)
		outline.BackgroundTransparency = 1
		outline.ImageColor3 = Color3.new(0, 0, 0)
		outline.ZIndex = 2
		outline.CurrentCamera = scene.Camera
		outline.Parent = scene.Layer
		scene.OutlineViewport = outline
	end
	local revealTemplate = StarterGui.FishingSequenceGui.RevealInfo
	for index = 1, count do
		local reward = order and order.Rewards[index]
		local fish = reward and FishesData[reward.ItemId]
		local template = fish and Assets.GetFish(fish.Model)
		local ok, visual = pcall(cloneVisual, template, reward and reward.MutationId, scene.OutlineViewport)
		local entry =
			{ Visual = if ok then visual else nil, Fish = fish, Style = reward and Effects.GetStyle(reward.ItemId) }
		if entry.Visual then
			entry.Visual.Model.Name = "PaidEggPreview"
		end
		local fallback = Instance.new("ImageLabel")
		fallback.Name = "PreviewIcon"
		fallback.AnchorPoint = Vector2.new(0.5, 0.5)
		fallback.BackgroundTransparency = 1
		fallback.ScaleType = Enum.ScaleType.Fit
		fallback.ZIndex = 3
		fallback.Image = if fish then fish.Icon else scene.EggImage
		fallback.Visible = not entry.Visual
		fallback.Parent = scene.Layer
		entry.Fallback = fallback
		if fish and not entry.Visual then
			entry.IconOutlines = table.create(#OUTLINE_OFFSETS)
			for outlineIndex in ipairs(OUTLINE_OFFSETS) do
				local outline = fallback:Clone()
				outline.Name = "PaidEggIconOutline"
				outline.ImageColor3 = Color3.new(0, 0, 0)
				outline.ZIndex = 2
				outline.Parent = scene.Layer
				entry.IconOutlines[outlineIndex] = outline
			end
		end
		if fish then
			local caption = revealTemplate:Clone()
			caption.AnchorPoint = Vector2.new(0.5, 0)
			caption.ZIndex = 5
			caption.Visible = false
			local isNew = order.NewFish and order.NewFish[index]
			FishingSequenceInfo.FillReveal(caption, fish, reward.Weight, reward.MutationId, isNew)
			local nameRow = caption:FindFirstChild("Name")
			nameRow.Label.TextWrapped = true
			if isNew then
				nameRow.Label.Size = UDim2.fromScale(0.76, 1)
				nameRow.Label.Position = UDim2.fromScale(0.38, nameRow.Label.Position.Y.Scale)
			end
			caption.Parent = scene.Layer
			entry.Caption = caption
			entry.CaptionFade = prepareCaptionFade(caption)
		end
		scene.Entries[index] = entry
	end
end

local function eggMotion(elapsed)
	local progress = math.clamp(elapsed / EGG_ENTER, 0, 1)
	local scale = 0.45 + 0.55 * (1 - (1 - progress) ^ 3)
	for _, shake in ipairs(SHAKES) do
		local phase = (elapsed - shake.Start) / shake.Duration
		if phase >= 0 and phase < 1 then
			return scale, math.sin(phase * 2 * math.pi) * math.rad(shake.Angle), 0
		end
	end
	return scale, 0, 0.035 * (1 - progress) ^ 2
end

function Controller:_render()
	local scene = self._scene
	local viewport = scene.Layer.AbsoluteSize
	if viewport.X < 1 or viewport.Y < 1 then
		return
	end
	if scene.ViewportSize ~= viewport then
		scene.ViewportSize = viewport
		scene.Cells = Layout.Get(#scene.Entries, viewport.X, viewport.Y)
		local focal = viewport.Y / (2 * math.tan(math.rad(scene.Camera.FieldOfView / 2)))
		for index, entry in ipairs(scene.Entries) do
			local cell = scene.Cells[index]
			local width, height = cell.Width * viewport.X, cell.VisualHeight * viewport.Y
			entry.CellCenter = UDim2.fromScale(cell.X, cell.Y + cell.VisualHeight / 2)
			entry.CellSize = Vector2.new(width, height)
			if entry.Caption then
				entry.Caption.Size = UDim2.fromScale(cell.Width, cell.CaptionHeight)
				entry.Caption.Position = UDim2.fromScale(cell.X, cell.Y + cell.VisualHeight)
			end
			local visual = entry.Visual
			if visual then
				local x = (cell.X - 0.5) * viewport.X
				local y = (cell.Y + cell.VisualHeight / 2 - 0.5) * viewport.Y
				visual.Center = CFrame.new(x * FISH_DEPTH / focal, -y * FISH_DEPTH / focal, -FISH_DEPTH)
				visual.SteadyScale, visual.MaximumScale = Layout.GetFishScale(
					FISH_DEPTH,
					focal,
					x,
					y,
					width / 2,
					height / 2,
					visual,
					OUTLINE_PIXELS,
					OUTLINE_SCALE
				)
			end
		end
	end

	local elapsed = os.clock() - scene.PhaseAt
	if not scene.Revealed then
		local scale, tilt, rise = eggMotion(elapsed / Motion.RevealAt)
		local burstScale = Motion.GetBurstScale(elapsed)
		for _, entry in ipairs(scene.Entries) do
			local width, height = entry.CellSize.X, entry.CellSize.Y
			local side = math.min(width / 1.82, height * 0.89) * scale * burstScale
			if elapsed >= Motion.SqueezeAt then
				side = math.min(side, width, height)
			end
			local pivot = 0.38 * side
			local image = entry.Fallback
			image.Size = UDim2.fromOffset(side, side)
			image.Rotation = math.deg(tilt)
			image.Position = entry.CellCenter
				+ UDim2.fromScale(0, rise)
				+ UDim2.fromOffset(pivot * math.sin(tilt), pivot * (1 - math.cos(tilt)))
		end
		return
	end

	local fishScale = Motion.GetFishScale(elapsed)
	local yaw = math.max(0, elapsed - Motion.FishSettledAt) * 2 * math.pi / Motion.TurnDuration
	for _, entry in ipairs(scene.Entries) do
		local visual = entry.Visual
		if visual then
			local ratio = math.max(0.0001, math.min(visual.SteadyScale * fishScale, visual.MaximumScale))
			local silhouetteRatio = ratio * OUTLINE_SCALE
			if ratio ~= visual.LastRatio then
				visual.LastRatio = ratio
				visual.Model:ScaleTo(visual.BaseScale * ratio)
				visual.Outline:ScaleTo(visual.BaseScale * silhouetteRatio)
			end
			local facing = if entry.Fish.DisplayFacing == "Side" then math.pi / 2 else math.pi
			local frame = visual.Center * CFrame.Angles(0, facing + yaw, 0)
			visual.Model:PivotTo(frame * CFrame.new(-visual.CenterOffset * ratio))
			visual.Outline:PivotTo(frame * CFrame.new(-visual.CenterOffset * silhouetteRatio))
			if not visual.Model.Parent then
				visual.Model.Parent = scene.Viewport
			end
		else
			local width, height = entry.CellSize.X, entry.CellSize.Y
			local fitScale = math.max(0, 1 - 2 * OUTLINE_PIXELS / math.min(width, height))
			local ratio = fitScale * math.min(fishScale, 1)
			entry.Fallback.Size = UDim2.fromOffset(width * ratio, height * ratio)
			entry.Fallback.Position = entry.CellCenter
			if entry.IconOutlines then
				for index, outline in ipairs(entry.IconOutlines) do
					local offset = OUTLINE_OFFSETS[index]
					outline.Position = entry.CellCenter + UDim2.fromOffset(offset.X, offset.Y)
					outline.Size = entry.Fallback.Size
				end
			end
		end
		if entry.CaptionFade and elapsed >= Motion.FishSettledAt then
			local progress = math.min(1, (elapsed - Motion.FishSettledAt) / CAPTION_FADE)
			entry.Caption.Visible = true
			for _, field in ipairs(entry.CaptionFade) do
				field.Item[field.Property] = 1 + (field.Original - 1) * progress
			end
			if progress == 1 then
				entry.CaptionFade = nil
			end
		end
	end
end

function Controller:_close()
	local scene = self._scene
	if not scene then
		return
	end
	self._scene = nil
	RunService:UnbindFromRenderStep(RENDER_STEP)
	for _, entry in ipairs(scene.Entries) do
		if entry.Visual then
			entry.Visual.Model:Destroy()
		end
	end
	scene.Layer:Destroy()
	scene.Audio:Destroy()
	self._gui.Enabled = false
	GuiAnimation.PopModal(self._gui)
	ContextActionService:UnbindAction(BLOCK_ACTION)
	if scene.BackpackEnabled ~= nil then
		pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, scene.BackpackEnabled)
	end
	for gui in pairs(scene.Hidden) do
		if gui.Parent then
			gui.Enabled = true
		end
	end
	if scene.Revealed then
		self._seen[scene.Order.OrderId] = true
		self._queued[scene.Order.OrderId] = nil
		self._deliveries[scene.Order.OrderId].Closed = true
		self:_syncDelivery(scene.Order.OrderId)
	end
end

function Controller:_open(order)
	if self._opening then
		return false
	end
	self._opening = true
	local gui = self._gui
	local layer = Instance.new("Frame")
	layer.Name = "PaidEggResults"
	layer.BackgroundTransparency = 1
	layer.Size = UDim2.fromScale(1, 1)
	layer.Parent = gui
	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "PaidEggModels"
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.BackgroundTransparency = 1
	viewport.ZIndex = 3
	viewport.Ambient = Color3.fromRGB(210, 210, 224)
	viewport.LightColor = Color3.fromRGB(255, 250, 239)
	viewport.LightDirection = Vector3.new(-0.45, -0.9, -1)
	viewport.Parent = layer
	local camera = Instance.new("Camera")
	camera.CFrame = CFrame.identity
	camera.FieldOfView = 52
	camera.Parent = viewport
	viewport.CurrentCamera = camera
	local scene = {
		Entries = {},
		Layer = layer,
		Viewport = viewport,
		Camera = camera,
		Hidden = {},
		Order = order,
		EggImage = PurchaseData[order.PurchaseId].IconId,
		Audio = Effects.NewAudio(),
		Turns = 0,
		PhaseAt = os.clock(),
	}
	for _, other in ipairs(gui.Parent:GetChildren()) do
		if other:IsA("ScreenGui") and other ~= gui and other.Enabled then
			scene.Hidden[other] = true
			other.Enabled = false
		end
	end
	local ok, enabled = pcall(StarterGui.GetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack)
	if ok then
		scene.BackpackEnabled = enabled
		pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Backpack, false)
	end
	ContextActionService:BindActionAtPriority(BLOCK_ACTION, function()
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value + 200, table.unpack(Enum.PlayerActions:GetEnumItems()))
	gui.OneHatchResultFrame.Visible, gui.TripleHatchResultFrame.Visible = false, false
	gui.ContinueLabel.Visible = false
	gui.Enabled = true
	self._scene = scene
	self._opening = false
	GuiAnimation.PushModal(gui, gui.CloseButton, function()
		if self._scene and self._scene.Revealed then
			self:_close()
		end
	end)
	self:_setVisuals(nil, #order.Rewards)
	self:_render()
	RunService:BindToRenderStep(RENDER_STEP, Enum.RenderPriority.Camera.Value + 1, function()
		if self._scene then
			self:_render()
		end
	end)
	return true
end

function Controller:_syncDelivery(orderId)
	local delivery = self._deliveries[orderId]
	if not delivery or delivery.Busy or os.clock() < delivery.RetryAt then
		return
	end
	if delivery.Granted and not delivery.Closed then
		return
	end
	delivery.Busy = true
	local request = if delivery.Granted
		then self._service:AcknowledgeResult(orderId)
		else self._service:RevealResult(orderId)
	request
		:andThen(function(success)
			delivery.Busy = false
			if success and delivery.Granted then
				self._deliveries[orderId] = nil
			elseif success then
				delivery.Granted = true
				delivery.RetryAt = 0
				self:_syncDelivery(orderId)
			else
				delivery.RetryAt = os.clock() + 2
			end
		end)
		:catch(function()
			delivery.Busy = false
			delivery.RetryAt = os.clock() + 2
		end)
end

function Controller:_enqueue(order)
	if self._seen[order.OrderId] or self._queued[order.OrderId] then
		return
	end
	if order.ProductId and order.SenderUserId == player.UserId then
		self._waiting[order.ProductId] = nil
	end
	self._queued[order.OrderId] = true
	table.insert(self._queue, order)
	self:_step()
end

function Controller:_closeConfirmation()
	local confirmation = self._confirmation
	if not confirmation then
		return
	end
	self._confirmation = nil
	UiConfetti.clear(confirmation.Gui)
	confirmation.Close()
	confirmation.Audio:Destroy()
end

function Controller:_confirmOrder(confirmation)
	if self._confirmation ~= confirmation then
		return
	end
	self:_closeConfirmation()
	if confirmation.IsGiftNotice then
		table.remove(self._giftNotices, 1)
	else
		self._confirmed[confirmation.Id] = true
	end
	self:_step()
end

function Controller:_showConfirmation(order, isGiftNotice)
	local message, button
	if isGiftNotice then
		message, button = "Gift sent!", "OK"
	else
		local count = #order.Rewards
		message = if order.SenderUserId == player.UserId
			then "Purchase successful!"
			else "Gift from " .. (order.SenderName or "a friend") .. "!"
		button = string.format("Open %d %s", count, if count == 1 then "Egg" else "Eggs")
	end
	local confirmation = { Id = order.OrderId, IsGiftNotice = isGiftNotice, Audio = Effects.NewAudio() }
	confirmation.Gui, confirmation.Close = CommonResult.OpenResultGui(message, function()
		self:_confirmOrder(confirmation)
	end, { ConfirmText = button, RequireConfirm = not isGiftNotice })
	confirmation.Gui.Name = "PaidEggConfirmation"
	confirmation.Gui.ResetOnSpawn = false
	confirmation.Gui.Frame.ResultLabel.RichText = false
	self._confirmation = confirmation
	UiConfetti.play(confirmation.Gui, "celebration")
	Effects.Play(confirmation.Audio, "Success")
end

function Controller:_step()
	if self._opening then
		return
	end
	local scene = self._scene
	if not scene then
		if self._prompt and os.clock() >= self._prompt.Deadline then
			self._prompt = nil
		end
		if self._confirmation and not self._confirmation.Gui.Parent then
			self:_closeConfirmation()
		end
		if
			self._confirmation
			or self._prompt
			or self._respawning
			or InputGate.IsActive("Fishing")
			or InputGate.IsActive("Training")
		then
			return
		end
		local gift = self._giftNotices[1]
		if gift then
			self:_showConfirmation(gift, true)
			return
		end
		local order = self._queue[1]
		if order then
			if self._confirmed[order.OrderId] then
				self:_open(order)
			else
				self:_showConfirmation(order, false)
			end
		end
		return
	end
	if scene.Revealed or not scene.Cells then
		return
	end

	local elapsed = os.clock() - scene.PhaseAt
	local turn = scene.Turns
	for index = turn + 1, #SHAKES do
		local shake = SHAKES[index]
		if elapsed >= (shake.Start + shake.Duration * 0.25) * Motion.RevealAt then
			turn = index
		end
	end
	if turn > scene.Turns then
		scene.Turns = turn
		if elapsed < Motion.SqueezeAt then
			Effects.Play(scene.Audio, "Turn", SHAKES[turn].Pitch)
			Effects.Emit(scene.Layer, scene.Cells, scene.Entries, "TurnStars", turn, Motion.RevealAt)
		end
	end
	if elapsed < Motion.RevealAt then
		return
	end

	local order = table.remove(self._queue, 1)
	self:_setVisuals(order, #order.Rewards)
	scene.Revealed, scene.PhaseAt = true, os.clock()
	self:_render()
	Effects.PlayOpen(scene.Audio)
	if scene.Cells then
		Effects.Emit(scene.Layer, scene.Cells, scene.Entries, "BurstFlash")
		Effects.Emit(scene.Layer, scene.Cells, scene.Entries, "RevealBack")
		Effects.Emit(scene.Layer, scene.Cells, scene.Entries, "RevealStars")
	end
	for _, entry in ipairs(scene.Entries) do
		if entry.Style.Rare then
			task.delay(0.18, function()
				if self._scene == scene then
					Effects.Play(scene.Audio, "Cheer")
				end
			end)
			break
		end
	end

	self._gui.ContinueLabel.Text = "(Click to continue)"
	self._gui.ContinueLabel.Visible = true
	local orderId = order.OrderId
	self._confirmed[orderId] = nil
	self._deliveries[orderId] = { RetryAt = math.huge }
	task.spawn(function()
		-- Allow the revealed result to appear on screen before asking for inventory changes.
		RunService.RenderStepped:Wait()
		RunService.RenderStepped:Wait()
		self._deliveries[orderId].RetryAt = 0
		self:_syncDelivery(orderId)
	end)
end

function Controller:_promptFinished(productId, attempted)
	local prompt = self._prompt
	if not prompt or prompt.ProductId ~= productId then
		return
	end
	self._prompt = nil
	if attempted and prompt.IsSelf then
		local alreadyReady = false
		for _, order in ipairs(self._queue) do
			if order.ProductId == productId and order.SenderUserId == player.UserId then
				alreadyReady = true
				break
			end
		end
		if not alreadyReady then
			self._waiting[productId] = prompt
			task.delay(CONFIRM_TIMEOUT, function()
				if self._waiting[productId] == prompt then
					self._waiting[productId] = nil
					NotificationClient.GreenNotify("Purchase confirmation is pending. Results will appear when ready.")
				end
			end)
		end
	end
	self:_step()
end

function Controller:_fetch()
	self._service
		:GetPendingResults()
		:andThen(function(results)
			for _, order in ipairs(results) do
				self:_enqueue(order)
			end
		end)
		:catch(function(err)
			warn("PaidEggGuiController: could not recover results: " .. tostring(err))
		end)
end

function Controller:KnitStart()
	task.spawn(function()
		local ids = {}
		for _, purchaseId in ipairs(Config.PurchaseOrder) do
			local id = PurchaseData[purchaseId].IconId
			if not table.find(ids, id) then
				table.insert(ids, id)
			end
		end
		Effects.Preload(ids)
	end)
	self._gui = player:WaitForChild("PlayerGui"):WaitForChild("EggHatchResultGui")
	self._gui.Enabled = false
	self._gui.ResetOnSpawn = false
	self._gui.ScreenInsets = Enum.ScreenInsets.None
	self._gui.DisplayOrder = math.max(100, self._gui.DisplayOrder)
	self._queue, self._queued, self._seen, self._deliveries = {}, {}, {}, {}
	self._waiting, self._confirmed = {}, {}
	self._giftNotices, self._seenGiftNotices = {}, {}
	self._service = Knit.GetService("PaidEggService")
	Knit.GetService("PlayerDataService").DataLoaded:Connect(function()
		self:_fetch()
	end)
	Knit.GetService("PurchaseService").PromptPurchaseFail:Connect(function()
		self._prompt = nil
	end)
	self._gui.CloseButton.Activated:Connect(function()
		if self._scene and self._scene.Revealed then
			self:_close()
		end
	end)
	self._gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if self._scene and not self._gui.Enabled then
			self:_close()
		end
	end)
	player.CharacterRemoving:Connect(function()
		self._respawning = true
		self:_closeConfirmation()
		self:_close()
	end)
	player.CharacterAdded:Connect(function()
		self:_closeConfirmation()
		self:_close()
		self._respawning = false
		self:_fetch()
	end)
	self._service.PromptPrepared:Connect(function(productId, count, isSelf)
		self._prompt = { ProductId = productId, Quantity = count, IsSelf = isSelf, Deadline = os.clock() + 120 }
	end)
	MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, attempted)
		if userId == player.UserId and Config.FindProduct(productId, PurchaseData) then
			self:_promptFinished(productId, attempted)
		end
	end)
	self._service.ResultReady:Connect(function(order)
		self:_enqueue(order)
	end)
	self._service.PurchaseCompleted:Connect(function(order)
		if order.IsGift and not self._seenGiftNotices[order.OrderId] then
			self._seenGiftNotices[order.OrderId] = true
			table.insert(self._giftNotices, order)
			self:_step()
		end
	end)
	self:_fetch()
	local recoveryElapsed = 0
	RunService.Heartbeat:Connect(function(dt)
		self:_step()
		for orderId in pairs(self._deliveries) do
			self:_syncDelivery(orderId)
		end
		recoveryElapsed += dt
		if recoveryElapsed >= 15 then
			recoveryElapsed = 0
			self:_fetch()
		end
	end)
end

return Controller
