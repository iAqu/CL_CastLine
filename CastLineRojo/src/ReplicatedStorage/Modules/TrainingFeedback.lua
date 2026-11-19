-- Presentation-only deltas. Rewards remain entirely server-owned.
local Feedback = {}

function Feedback.GetChanges(previous, current, levels)
	local result = { xp = 0, levels = 0, weight = 0 }
	if not previous or not current.active or not previous.active or current.revision <= previous.revision then
		return result
	end
	if current.level < previous.level then
		return result
	end
	local earned = current.xp - previous.xp
	for level = previous.level, current.level - 1 do
		local row = levels[tostring(level)] or levels[level]
		if not row then
			return result
		end
		earned += row.XpToNextLevel
	end
	result.xp = math.max(0, earned)
	result.levels = current.level - previous.level
	result.weight = if result.levels > 0 then math.max(0, current.maxCatchWeight - previous.maxCatchWeight) else 0
	return result
end

return Feedback
