local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)

local FishTitleUtil = {}

local MUTATION_LABEL_IDS = { "Golden", "Diamond", "Mint", "Rainbow" }

type FishTitleItem = { DisplayName: string, CpsPrice: number }

local function findLabel(frame: Instance, name: string): TextLabel?
	local label = frame:FindFirstChild(name)
	return if label and label:IsA("TextLabel") then label else nil
end

function FishTitleUtil.Create(titleGui: Instance?, item: FishTitleItem, mutationId: unknown): BillboardGui?
	local template = titleGui and titleGui:FindFirstChild("FishTitleTemplate")
	if not template or not template:IsA("BillboardGui") then
		return nil
	end

	local title = template:Clone()
	local frame = title:FindFirstChild("Frame")
	if not frame then
		title:Destroy()
		return nil
	end

	local nameLabel = findLabel(frame, "NameLabel")
	if nameLabel then
		nameLabel.Text = item.DisplayName
	end

	local normalizedId = MutationDataUtil.NormalizeMutationId(mutationId)
	local cpsLabel = findLabel(frame, "CpsLabel")
	if cpsLabel then
		local cpsPrice = PlotFishIncome.GetCpsPrice(item, MutationDataUtil.GetEarnCashRate(normalizedId))
		cpsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(cpsPrice) .. "/s"
		cpsLabel.Visible = true
	end

	for _, id in MUTATION_LABEL_IDS do
		local label = findLabel(frame, "MutationLabel_" .. id)
		if label then
			label.Visible = id == normalizedId
		end
	end
	return title
end

return FishTitleUtil
