local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NumberUtil = require(script.Parent.NumberUtil)
local GuiUtil = require(script.Parent.GuiUtil)
local BaitConfig = require(script.Parent.FishingBaitConfig)

local POPUP_TWEEN_INFO = TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local POPUP_START_SCALE = 0.82
local CANNOT_BUY_GRADIENT = "UIGradient_CannotBuy"

local FishingBaitSelect = {}
local prices = {}
local priceRequests = {}

local function getProductPrice(productId, onPrice)
	local cached = prices[productId]
	if cached and os.clock() < cached.Expires then
		if onPrice then
			onPrice(cached.Value)
		end
		return
	end
	local callbacks = priceRequests[productId]
	if callbacks then
		if onPrice then
			table.insert(callbacks, onPrice)
		end
		return
	end
	callbacks = if onPrice then { onPrice } else {}
	priceRequests[productId] = callbacks
	task.spawn(function()
		local ok, info = pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, productId, Enum.InfoType.Product)
		local price = if ok and info and info.IsForSale and type(info.PriceInRobux) == "number"
			then info.PriceInRobux else nil
		if price then
			prices[productId] = { Value = price, Expires = os.clock() + 60 }
		end
		priceRequests[productId] = nil
		for _, callback in ipairs(callbacks) do
			callback(price)
		end
	end)
end

function FishingBaitSelect.WarmProductPrice(productId)
	if type(productId) == "number" and productId > 0 then
		getProductPrice(productId)
	end
end

local function bindCashPrice(price: TextLabel, amount: number)
	local cannotBuyGradient: UIGradient?
	local normalGradients = {}
	for _, child in ipairs(price:GetChildren()) do
		if child:IsA("UIGradient") then
			if child.Name == CANNOT_BUY_GRADIENT then
				cannotBuyGradient = child
			elseif child.Enabled then
				table.insert(normalGradients, child)
			end
		end
	end
	local normalColor = price.TextColor3

	return function(balance: number)
		local cannotBuy = balance < amount
		if cannotBuy and not cannotBuyGradient then
			local gradient = Instance.new("UIGradient")
			gradient.Name = CANNOT_BUY_GRADIENT
			gradient.Color = ColorSequence.new(Color3.fromRGB(255, 85, 85))
			gradient.Parent = price
			cannotBuyGradient = gradient
		end
		for _, gradient in ipairs(normalGradients) do
			gradient.Enabled = not cannotBuy
		end
		if cannotBuyGradient then
			cannotBuyGradient.Enabled = cannotBuy
		end
		price.TextColor3 = if cannotBuy then Color3.new(1, 1, 1) else normalColor
	end
end

function FishingBaitSelect.Bind(
	gui: ScreenGui,
	rod,
	baits,
	choose,
	close,
	quotes,
	allowUnavailableClick: boolean?,
	cash: NumberValue?
)
	local frame = gui:FindFirstChild("Frame")
	local content = frame and frame:FindFirstChild("Content")
	local list = content and content:FindFirstChild("BaitsFrame")
	local template = list and list:FindFirstChild("Template")
	local none = list and list:FindFirstChild("None")
	local noneButton = none and none:FindFirstChild("Button")
	local top = frame and frame:FindFirstChild("Top")
	local exit = top and top:FindFirstChild("Exit")
	assert(template and template:IsA("GuiObject"), "BaitSelectGui template missing")
	assert(
		noneButton and noneButton:IsA("GuiButton") and exit and exit:IsA("GuiButton"),
		"BaitSelectGui buttons missing"
	)

	local rows, connections, buttons = {}, {}, { noneButton, exit }
	local baitButtons = {}
	local cashPriceUpdates = {}
	local unavailable, destroyed, busy = {}, false, false
	template.Visible = false
	local noneLabel = noneButton:FindFirstChild("Seed")
	if noneLabel and noneLabel:IsA("TextLabel") then
		noneLabel.Text = "NONE"
	end
	table.insert(
		connections,
		noneButton.Activated:Connect(function()
			choose("NONE")
		end)
	)
	table.insert(connections, exit.Activated:Connect(close))
	for index, id in ipairs(rod.BaitsSelect) do
		local bait = baits[id]
		local quote = quotes and quotes[id]
		if not bait then
			continue
		end
		local row = template:Clone()
		row.Name, row.LayoutOrder, row.Visible = id, none.LayoutOrder + index, true
		table.insert(rows, row)
		local button = row:FindFirstChild("Button")
		assert(button and button:IsA("GuiButton"), "BaitSelectGui item button missing")
		if quote and not quote.available and not allowUnavailableClick then
			unavailable[button] = true
		end
		GuiUtil.SetRarityGradient(button, bait.Rarity)
		local name, price, icon =
			button:FindFirstChild("Name"), button:FindFirstChild("Price"), button:FindFirstChild("ImageLabel")
		local isPaid = quote and quote.tier == BaitConfig.PaidTier
		if name and name:IsA("TextLabel") then
			name.Text = if isPaid then "100% Rainbow" else bait.DisplayName
			name.TextColor3 = Color3.new(1, 1, 1)
			if isPaid then
				name.Visible = true
				local assets = ReplicatedStorage:FindFirstChild("Gui")
				local gradients = assets and assets:FindFirstChild("UIGradient")
				local rainbow = gradients and gradients:FindFirstChild("UIGradient_Mutation_Rainbow")
				if rainbow and rainbow:IsA("UIGradient") then
					local gradient = rainbow:Clone()
					gradient.Enabled = true
					gradient.Parent = name
				end
			end
		end
		if price and price:IsA("TextLabel") then
			if isPaid then
				price.Text = if quote.credits > 0 then "OWNED" elseif quote.productId then "…" else "UNAVAILABLE"
				if quote.productId and quote.credits <= 0 then
					if not allowUnavailableClick then
						unavailable[button] = true
						button.Interactable = false
					end
					getProductPrice(quote.productId, function(robux)
						if destroyed then
							return
						end
						if robux then
							price.Text = "\u{E002} " .. tostring(robux)
							unavailable[button] = nil
							button.Interactable = not busy
						else
							price.Text = "UNAVAILABLE"
						end
					end)
				end
			else
				price.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(if quote then quote.price else 0, 2)
				if cash and quote then
					table.insert(cashPriceUpdates, bindCashPrice(price, quote.price))
				end
			end
		end
		if icon and icon:IsA("ImageLabel") then
			local assetId = tonumber(bait.Icon)
			icon.Visible = assetId ~= nil or string.sub(bait.Icon, 1, 13) == "rbxassetid://"
			if icon.Visible then
				icon.Image = if assetId then "rbxassetid://" .. tostring(assetId) else bait.Icon
			end
		end
		table.insert(
			connections,
			button.Activated:Connect(function()
				choose(id)
			end)
		)
		table.insert(buttons, button)
		baitButtons[id] = button
		row.Parent = list
	end

	if cash and #cashPriceUpdates > 0 then
		local function updateCashPrices()
			local balance = cash.Value
			for _, update in ipairs(cashPriceUpdates) do
				update(balance)
			end
		end
		table.insert(connections, cash:GetPropertyChangedSignal("Value"):Connect(updateCashPrices))
		updateCashPrices()
	end

	local popupScale = Instance.new("UIScale")
	popupScale.Scale = POPUP_START_SCALE
	popupScale.Parent = frame
	local popupTween = TweenService:Create(popupScale, POPUP_TWEEN_INFO, { Scale = 1 })

	local function setBusy(isBusy: boolean)
		busy = isBusy
		for _, button in ipairs(buttons) do
			button.Interactable = not busy and not unavailable[button]
		end
	end

	return {
		GetButton = function(baitId)
			return if gui.Enabled and not destroyed then baitButtons[baitId] else nil
		end,
		Show = function()
			setBusy(false)
			gui.Enabled = true
			popupTween:Play()
		end,
		SetBusy = setBusy,
		Destroy = function()
			destroyed = true
			gui.Enabled = false
			popupTween:Cancel()
			popupTween:Destroy()
			popupScale:Destroy()
			noneButton.Interactable, exit.Interactable = true, true
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			for _, row in ipairs(rows) do
				row:Destroy()
			end
		end,
	}
end

return FishingBaitSelect
