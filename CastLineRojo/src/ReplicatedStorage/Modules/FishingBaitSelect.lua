local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local NumberUtil = require(script.Parent.NumberUtil)
local GuiUtil = require(script.Parent.GuiUtil)

local POPUP_TWEEN_INFO = TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local POPUP_START_SCALE = 0.82

local FishingBaitSelect = {}

function FishingBaitSelect.Bind(gui: ScreenGui, rod, baits, choose, close, quotes, allowUnavailableClick: boolean?)
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
	local unavailable, destroyed = {}, false
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
		if name and name:IsA("TextLabel") then
			name.Text = bait.DisplayName
			name.TextColor3 = Color3.new(1, 1, 1)
		end
		if price and price:IsA("TextLabel") then
			if quote and quote.tier == 4 then
				price.Text = if quote.credits > 0 then "OWNED" elseif quote.available then "R$" else "UNAVAILABLE"
				if quote.productId and quote.credits <= 0 then
					task.spawn(function()
						local ok, info = pcall(
							MarketplaceService.GetProductInfoAsync,
							MarketplaceService,
							quote.productId,
							Enum.InfoType.Product
						)
						if ok and info.PriceInRobux and not destroyed then
							price.Text = "R$" .. tostring(info.PriceInRobux)
						end
					end)
				end
			else
				price.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(if quote then quote.price else 0, 2)
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

	local popupScale = Instance.new("UIScale")
	popupScale.Scale = POPUP_START_SCALE
	popupScale.Parent = frame
	local popupTween = TweenService:Create(popupScale, POPUP_TWEEN_INFO, { Scale = 1 })

	local function setBusy(busy: boolean)
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
