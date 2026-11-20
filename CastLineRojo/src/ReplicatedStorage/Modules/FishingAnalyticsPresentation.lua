local Presentation = {}

function Presentation.Report(state, detail)
	if state.preview or not state.token then
		return
	end
	state.reportedAnalytics = state.reportedAnalytics or {}
	if not state.reportedAnalytics[detail] then
		state.reportedAnalytics[detail] = true
		state.service.AnalyticsPresentation:Fire(state.token, detail)
	end
end

local visiblePhases = {
	Casting = "Casting",
	Flying = "Flying",
	Approaching = "Approaching",
	Struggling = "Struggling",
	Lifting = "Lifting",
	Caught = "Reveal",
}

function Presentation.ObserveSequence(state)
	local sequence = state.sequence
	local phase = sequence.phase
	local detail = visiblePhases[phase]
	if phase == "Nibbling" and sequence.bite then
		local index = sequence.bite.timeline.nibbleIndex
		detail = if index == 1 then "Nibble1" elseif index == 2 then "Nibble2" else nil
	end
	if detail then
		Presentation.Report(state, detail)
	end
end

return Presentation
