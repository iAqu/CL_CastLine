local EventFishConfig = {
	Interval = 10 * 60,
	Duration = 30,
	StateFolderName = "EventFishState",
	WaitingHeader = "SECRET FISH SPAWN IN:",
	ActiveHeader = "SECRET FISH SPAWN!",
	Shadow = table.freeze({ Length = 100, Clearance = 1.5, Radius = 15, Period = 24 }),
}

function EventFishConfig.GetWindow(now: number)
	local slot = math.floor(now / EventFishConfig.Interval)
	local startsAt = slot * EventFishConfig.Interval
	return {
		SlotId = slot,
		StartsAt = startsAt,
		EndsAt = startsAt + EventFishConfig.Duration,
		NextStartsAt = startsAt + EventFishConfig.Interval,
	}
end

function EventFishConfig.FormatCountdown(seconds: number): string
	local whole = math.max(0, math.ceil(seconds))
	return string.format("%d:%02d", math.floor(whole / 60), whole % 60)
end

return table.freeze(EventFishConfig)
