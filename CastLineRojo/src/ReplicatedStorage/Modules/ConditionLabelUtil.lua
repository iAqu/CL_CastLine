local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)

local ConditionLabelUtil = {}

local CONDITION_LABEL_NAMES = {
	"ConditionLabel_Normal",
	"ConditionLabel_Good",
	"ConditionLabel_Great",
	"ConditionLabel_Perfect",
	"ConditionLabel_Mint",
}
local DEFAULT_CONDITION_NAME = "Normal"
local CONDITION_LABEL_PREFIX = "ConditionLabel_"

local function getConditionLabel(frame: Instance, conditionName: string): GuiObject?
	local label = frame:FindFirstChild(CONDITION_LABEL_PREFIX .. conditionName)
	return if label and label:IsA("GuiObject") then label else nil
end

function ConditionLabelUtil.HideAll(frame: Instance)
	for _, labelName in ipairs(CONDITION_LABEL_NAMES) do
		local label = frame:FindFirstChild(labelName)
		if label and label:IsA("GuiObject") then
			label.Visible = false
		end
	end
end

function ConditionLabelUtil.Show(frame: Instance, conditionId: unknown)
	ConditionLabelUtil.HideAll(frame)

	local condition = if typeof(conditionId) == "string" then ConditionsData[conditionId] else nil
	local conditionName = condition and condition.DisplayName or DEFAULT_CONDITION_NAME
	local label = getConditionLabel(frame, conditionName) or getConditionLabel(frame, DEFAULT_CONDITION_NAME)
	if label then
		label.Visible = true
	end
end

return ConditionLabelUtil
