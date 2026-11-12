local TweenService = game:GetService("TweenService")

local NumberUtil = require(script.Parent.NumberUtil)
local RarityConfig = require(script.Parent.RarityConfig)

local POPUP_TWEEN_INFO = TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local POPUP_START_SCALE = 0.82

local FishingBaitSelect = {}

function FishingBaitSelect.Bind(gui: ScreenGui, rod, baits, choose, close)
	local frame = gui:FindFirstChild("Frame")
	local content = frame and frame:FindFirstChild("Content")
	local list = content and content:FindFirstChild("BaitsFrame")
	local template = list and list:FindFirstChild("Template")
	local none = list and list:FindFirstChild("None")
	local noneButton = none and none:FindFirstChild("Button")
	local top = frame and frame:FindFirstChild("Top")
	local exit = top and top:FindFirstChild("Exit")
	assert(template and template:IsA("GuiObject"), "BaitSelectGui template missing")
	assert(noneButton and noneButton:IsA("GuiButton") and exit and exit:IsA("GuiButton"), "BaitSelectGui buttons missing")

	local rows, connections, buttons = {}, {}, { noneButton, exit }
	template.Visible = false
	local noneLabel = noneButton:FindFirstChild("Seed")
	if noneLabel and noneLabel:IsA("TextLabel") then
		noneLabel.Text = "NONE"
	end
	table.insert(connections, noneButton.Activated:Connect(function()
		choose("NONE")
	end))
	table.insert(connections, exit.Activated:Connect(close))
	for index, id in ipairs(rod.BaitsSelect) do
		local bait = baits[id]
		if not bait then
			continue
		end
		local row = template:Clone()
		row.Name, row.LayoutOrder, row.Visible = id, none.LayoutOrder + index, true
		table.insert(rows, row)
		local button = row:FindFirstChild("Button")
		assert(button and button:IsA("GuiButton"), "BaitSelectGui item button missing")
		button.BackgroundColor3 = RarityConfig.Get(bait.Rarity).Color
		local name, price, icon = button:FindFirstChild("Name"), button:FindFirstChild("Price"), button:FindFirstChild("ImageLabel")
		if name and name:IsA("TextLabel") then
			name.Text = bait.DisplayName
		end
		if price and price:IsA("TextLabel") then
			price.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(bait.Price, 2)
		end
		if icon and icon:IsA("ImageLabel") then
			local assetId = tonumber(bait.Icon)
			icon.Visible = assetId ~= nil or string.sub(bait.Icon, 1, 13) == "rbxassetid://"
			if icon.Visible then
				icon.Image = if assetId then "rbxassetid://" .. tostring(assetId) else bait.Icon
			end
		end
		table.insert(connections, button.Activated:Connect(function()
			choose(id)
		end))
		table.insert(buttons, button)
		row.Parent = list
	end

	local popupScale = Instance.new("UIScale")
	popupScale.Scale = POPUP_START_SCALE
	popupScale.Parent = frame
	local popupTween = TweenService:Create(popupScale, POPUP_TWEEN_INFO, { Scale = 1 })

	return {
		Show = function()
			gui.Enabled = true
			popupTween:Play()
		end,
		SetBusy = function(busy: boolean)
			for _, button in ipairs(buttons) do
				button.Interactable = not busy
			end
		end,
		Destroy = function()
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
