local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishIconPresentation = require(ReplicatedStorage.Modules.FishIconPresentation)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)

local BackpackSlotPresentation = {}
function BackpackSlotPresentation.Apply(slot: TextButton, tool: Tool?, owner: Player)
	slot:SetAttribute("MinimalSlotLabels", true)
	local cpsLabel = slot:FindFirstChild("CpsLabel")
	local numberLabel = slot:FindFirstChild("Number")
	for _, label in ipairs(slot:GetDescendants()) do
		if label:IsA("TextLabel") and label ~= cpsLabel and label ~= numberLabel then
			label.Visible = false
		end
	end
	local oldPreview = slot:FindFirstChild("ItemModelPreview")
	if oldPreview then
		oldPreview:Destroy()
	end
	local itemId = tool and tool:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)
	local item = if ItemToolUtil.IsItemTool(tool) and typeof(itemId) == "string" then FishInventoryData[itemId] else nil
	local mutationId = if item then MutationDataUtil.NormalizeMutationId(tool:GetAttribute(ItemToolUtil.MUTATION_ID_ATTRIBUTE)) else nil
	local icon = slot:FindFirstChild("Icon")
	if icon and icon:IsA("ImageLabel") then
		icon.Image = if tool then tool.TextureId else ""
		icon.ScaleType = Enum.ScaleType.Fit
		icon.Visible = icon.Image ~= ""
		FishIconPresentation.ApplyMutation(icon, if icon.Visible then mutationId else nil)
	end
	if cpsLabel and cpsLabel:IsA("TextLabel") then
		cpsLabel.Visible = item ~= nil
		if item then
			local cps = PlotFishIncome.GetCpsPrice(
				item,
				MutationDataUtil.GetEarnCashRate(mutationId),
				owner:GetAttribute(PlotFishIncome.BEST_CPS_ATTRIBUTE),
				tool:GetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE)
			)
			cpsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(cps) .. "/s"
		else
			cpsLabel.Text = ""
		end
	end
end

return BackpackSlotPresentation
