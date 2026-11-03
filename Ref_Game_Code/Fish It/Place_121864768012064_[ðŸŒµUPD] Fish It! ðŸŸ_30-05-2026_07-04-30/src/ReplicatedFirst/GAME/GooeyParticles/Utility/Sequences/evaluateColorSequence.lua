-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ evaluateColorSequence | Line: 1 ]]
	assert(if typeof(p1) == "ColorSequence" then true else false, "Must pass a valid ColorSequence.")
	assert(if typeof(p2) == "number" then true else false, "Must pass a valid number.")
	local v3 = math.clamp(p2, 0, 1)
	if v3 == 0 then
		return p1.Keypoints[1].Value
	end
	if v3 == 1 then
		return p1.Keypoints[#p1.Keypoints].Value
	end
	local v4 = v3
	for i = 1, #p1.Keypoints do
		local v5 = p1.Keypoints[i]
		local v6 = p1.Keypoints[i + 1]
		if v5.Time <= v4 and v4 < v6.Time then
			local v7 = (v4 - v5.Time) / (v6.Time - v5.Time)
			return Color3.new((v6.Value.R - v5.Value.R) * v7 + v5.Value.R, (v6.Value.G - v5.Value.G) * v7 + v5.Value.G, (v6.Value.B - v5.Value.B) * v7 + v5.Value.B)
		end
	end
end