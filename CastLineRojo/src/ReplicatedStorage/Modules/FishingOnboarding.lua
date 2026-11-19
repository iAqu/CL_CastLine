local Onboarding = {
	StageAttribute = "FishingOnboardingStage",
	LessonActiveAttribute = "FishingOnboardingLessonActive",
	FishAttribute = "FishingOnboardingFish",
	RewardRodId = "Rod_102",
	TrainingLevel = 2,
}

function Onboarding.IsActiveStage(stage)
	return type(stage) == "string" and stage ~= "Complete"
end

function Onboarding.GetBaitSelectionHint(bait)
	return "Select " .. (bait and bait.DisplayName or "the first bait") .. "."
end

function Onboarding.Publish(player, data)
	local progress = data.FishingOnboarding
	player:SetAttribute(Onboarding.FishAttribute, progress and progress.FishUid)
	player:SetAttribute(Onboarding.StageAttribute, progress and progress.Stage)
end

function Onboarding.Advance(player, data, expected, nextStage, fishUid)
	local progress = data.FishingOnboarding
	if (progress and progress.Stage) ~= expected then
		return
	end
	if not progress then
		progress = {}
		data.FishingOnboarding = progress
	end
	progress.Stage = nextStage
	progress.FishUid = fishUid
	Onboarding.Publish(player, data)
end

return Onboarding
