local HttpService = game:GetService("HttpService")

local FishingObserverState = {
	Attribute = "FishingObserverState",
	EmptyReelDuration = 0.95,
}

local phases = {
	Selecting = true,
	Preparing = true,
	Cast = true,
	Catch = true,
	EmptyReel = true,
}

function FishingObserverState.Encode(state): string
	return HttpService:JSONEncode(state)
end

function FishingObserverState.Decode(value: unknown)
	if type(value) ~= "string" then
		return nil
	end
	local ok, state = pcall(HttpService.JSONDecode, HttpService, value)
	if ok and type(state) == "table" and type(state.id) == "number" and phases[state.phase] then
		return state
	end
	return nil
end

return FishingObserverState
