local TutorialConfig = {}

TutorialConfig.VERSION = 2
TutorialConfig.FINAL_ACTION_STEP = 5
TutorialConfig.COMPLETE_STEP = TutorialConfig.FINAL_ACTION_STEP + 1

TutorialConfig.STEP = table.freeze({
	WAIT_FOR_LOW_TIDE = 1,
	DIG_DUCK = 2,
	RETURN_HOME = 3,
	SELL_DUCK = 4,
	BUY_SHOVEL = 5,
})

TutorialConfig.GUIDED_ZONE_ID = "Zone_1"
TutorialConfig.GUIDED_ITEM_ID = "Duck"
TutorialConfig.GUIDED_SHOVEL_ID = "Shovel_102"
TutorialConfig.GUIDED_SHORE_INSET = 50
TutorialConfig.STARTER_CASH = 0

function TutorialConfig.GetCurrentStep(playerData): number
	if not playerData or playerData.TutorialVersion ~= TutorialConfig.VERSION then
		return TutorialConfig.COMPLETE_STEP
	end

	local completed = playerData.TutorialComplete
	if typeof(completed) ~= "table" then
		return TutorialConfig.STEP.WAIT_FOR_LOW_TIDE
	end

	for step = 1, TutorialConfig.FINAL_ACTION_STEP do
		if completed[step] ~= true then
			return step
		end
	end

	return TutorialConfig.COMPLETE_STEP
end

function TutorialConfig.IsComplete(playerData): boolean
	return TutorialConfig.GetCurrentStep(playerData) == TutorialConfig.COMPLETE_STEP
end

function TutorialConfig.TryAdvanceData(playerData, expectedStep: number, context): boolean
	if TutorialConfig.GetCurrentStep(playerData) ~= expectedStep then
		return false
	end
	context = context or {}

	if expectedStep == TutorialConfig.STEP.DIG_DUCK then
		if context.itemId ~= TutorialConfig.GUIDED_ITEM_ID
			or typeof(context.instanceId) ~= "string"
			or context.instanceId == ""
		then
			return false
		end
		playerData.TutorialDuckInstanceId = context.instanceId
	elseif expectedStep == TutorialConfig.STEP.SELL_DUCK then
		if context.instanceId ~= playerData.TutorialDuckInstanceId then
			return false
		end
	elseif expectedStep == TutorialConfig.STEP.BUY_SHOVEL then
		if context.shovelId ~= TutorialConfig.GUIDED_SHOVEL_ID then
			return false
		end
	elseif expectedStep ~= TutorialConfig.STEP.WAIT_FOR_LOW_TIDE
		and expectedStep ~= TutorialConfig.STEP.RETURN_HOME
	then
		return false
	end

	if typeof(playerData.TutorialComplete) ~= "table" then
		playerData.TutorialComplete = {}
	end
	playerData.TutorialComplete[expectedStep] = true
	return true
end

return TutorialConfig
