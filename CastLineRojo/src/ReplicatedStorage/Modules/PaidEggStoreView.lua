local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Config = require(script.Parent.PaidEggConfig)
local PurchaseData = require(ReplicatedFirst.Data.PurchaseData)
local ButtonAnimation = require(script.Parent.ButtonAnimation)
local View = {}

function View.Bind(storeGui, purchaseService, paidEggService)
	local root = storeGui.Frame.MainFrame.ScrollingFrame:FindFirstChild("LimitedEggFrame")
	local card = root and root:FindFirstChild("Egg_R_1")
	if not card then
		return nil
	end
	root.Visible, card.Visible = true, true
	local second = root:FindFirstChild("Egg_R_2")
	if second then
		second.Visible = false
	end
	local buttons = {}
	local generation = 0
	local availability
	local pending
	local image = card:FindFirstChild("Frame") and card.Frame:FindFirstChild("ImageLabel")
	if image then
		image.Image = PurchaseData.Egg_R_1.IconId
	end
	local status = card.Buy1Button.TextLabel:Clone()
	status.Name = "PaidEggAvailability"
	status.AnchorPoint = Vector2.zero
	status.Position = UDim2.fromScale(0.3, 0.74)
	status.Size = UDim2.fromScale(0.65, 0.07)
	status.Visible = false
	status.Parent = card
	local function update()
		local denied = availability and not availability.Allowed and availability.Message and not availability.Retryable
		status.Visible = denied and not pending or false
		if denied then
			status.Text = availability.Message
		end
		local enabled = not denied and not pending
		for _, button in pairs(buttons) do
			button.Active, button.Interactable, button.Selectable = enabled, enabled, enabled
			button.TextLabel.TextColor3 = if denied then Color3.fromRGB(170, 170, 170) else Color3.new(1, 1, 1)
		end
	end
	local function clearPending(request)
		if pending == request then
			pending = nil
			update()
		end
	end
	for _, id in ipairs(Config.PurchaseOrder) do
		local count = Config.Purchases[id]
		local button = card:FindFirstChild("Buy" .. count .. "Button")
		local row = Config.GetPurchase(id, PurchaseData)
		if button and row then
			button.TextLabel.Text = tostring(row.Price)
			buttons[id] = button
			ButtonAnimation.SetUp(button)
			button.Activated:Connect(function()
				if pending then
					return
				end
				local request = { PurchaseId = id, ProductId = row.ProductId }
				pending = request
				update()
				task.delay(120, clearPending, request)
				purchaseService.PromptPurchase:Fire(id)
			end)
		end
	end
	local view = {}
	function view:Refresh()
		generation += 1
		local request = generation
		availability = nil
		update()
		paidEggService
			:GetAvailability()
			:andThen(function(result)
				if request ~= generation then
					return
				end
				availability = result
				update()
			end)
			:catch(function()
				if request ~= generation then
					return
				end
				availability = nil
				update()
			end)
	end
	storeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if storeGui.Enabled then
			view:Refresh()
		end
	end)
	local player = Players.LocalPlayer
	player:GetAttributeChangedSignal("PlayerProfileReady"):Connect(function()
		if player:GetAttribute("PlayerProfileReady") then
			view:Refresh()
		end
	end)
	purchaseService.PromptPurchaseFail:Connect(function(_, purchaseId)
		if pending and pending.PurchaseId == purchaseId then
			clearPending(pending)
			view:Refresh()
		end
	end)
	paidEggService.PurchaseCompleted:Connect(function(result)
		if pending and result.ProductId == pending.ProductId then
			clearPending(pending)
		end
	end)
	MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, purchased)
		if pending and userId == player.UserId and productId == pending.ProductId and not purchased then
			clearPending(pending)
		end
	end)
	view:Refresh()
	return view
end

return View
