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
	local availability = { Allowed = false, Message = "Checking availability..." }
	local image = card:FindFirstChild("Frame") and card.Frame:FindFirstChild("ImageLabel")
	if image then
		image.Image = PurchaseData.Egg_R_1.IconId
	end
	local status = card.Buy1Button.TextLabel:Clone()
	status.Name = "PaidEggAvailability"
	status.AnchorPoint = Vector2.zero
	status.Position = UDim2.fromScale(0.3, 0.74)
	status.Size = UDim2.fromScale(0.65, 0.07)
	status.Text, status.Visible = "Checking availability...", true
	status.Parent = card
	for _, id in ipairs(Config.PurchaseOrder) do
		local count = Config.Purchases[id]
		local button = card:FindFirstChild("Buy" .. count .. "Button")
		local row = Config.GetPurchase(id, PurchaseData)
		if button and row then
			button.TextLabel.Text = tostring(row.Price)
			button.Active = false
			buttons[id] = button
			ButtonAnimation.SetUp(button)
			button.Activated:Connect(function()
				if not availability.Allowed then
					return
				end
				availability.Allowed = false
				for _, current in pairs(buttons) do
					current.Active = false
				end
				purchaseService.PromptPurchase:Fire(id)
			end)
		end
	end
	local view = {}
	function view:Refresh()
		generation += 1
		local request = generation
		paidEggService
			:GetAvailability()
			:andThen(function(result)
				if request ~= generation then
					return
				end
				availability = result
				status.Visible = not result.Allowed
				status.Text = result.Message or "Unavailable"
				for _, button in pairs(buttons) do
					button.Active, button.Selectable = result.Allowed, result.Allowed
					button.TextLabel.TextColor3 = if result.Allowed
						then Color3.new(1, 1, 1)
						else Color3.fromRGB(170, 170, 170)
				end
			end)
			:catch(function()
				if request ~= generation then
					return
				end
				availability = { Allowed = false, Message = "Availability check failed. Please try again." }
				status.Text, status.Visible = availability.Message, true
				for _, button in pairs(buttons) do
					button.Active = false
				end
			end)
	end
	storeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if storeGui.Enabled then
			view:Refresh()
		end
	end)
	purchaseService.PromptPurchaseFail:Connect(function()
		view:Refresh()
	end)
	paidEggService.PurchaseCompleted:Connect(function()
		view:Refresh()
	end)
	task.spawn(function()
		while card.Parent do
			if storeGui.Enabled then
				view:Refresh()
			end
			task.wait(5)
		end
	end)
	view:Refresh()
	return view
end

return View
