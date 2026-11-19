local Onboarding = require(script.Parent.FishingOnboarding)

local EventPresentationGate = {
	Attributes = { "FishingIntroActive", Onboarding.StageAttribute, Onboarding.LessonActiveAttribute },
}

function EventPresentationGate.IsSuppressed(player)
	local stage = player:GetAttribute(Onboarding.StageAttribute)
	return player:GetAttribute("FishingIntroActive") == true
		or (type(stage) == "string" and stage ~= "" and stage ~= "Complete")
		or player:GetAttribute(Onboarding.LessonActiveAttribute) == true
end

return EventPresentationGate
