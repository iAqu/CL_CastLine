-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	number = function(p1, p2, p3) --[[ number | Line: 3 ]]
		return p1 + (p2 - p1) * p3
	end,
	boolean = function(p1, p2, p3) --[[ boolean | Line: 7 ]]
		return if p3 < 0.5 then if p1 then p1 else p2 else p2
	end,
	string = function(p1, p2, p3) --[[ string | Line: 11 ]]
		local v1 = string.len(p1)
		local v2 = string.len(p2)
		return string.sub(p1, 1, v1 * (1 - p3)) .. string.sub(p2, 1, v2 * p3)
	end,
	Vector3 = function(p1, p2, p3) --[[ Vector3 | Line: 21 ]]
		return p1:Lerp(p2, p3)
	end
}
function t.Vector2(...) --[[ Vector2 | Line: 25 | Upvalues: t (copy) ]]
	return t.Vector3(...)
end
function t.CFrame(...) --[[ CFrame | Line: 29 | Upvalues: t (copy) ]]
	return t.Vector3(...)
end
function t.Color3(...) --[[ Color3 | Line: 33 | Upvalues: t (copy) ]]
	return t.Vector3(...)
end
function t.NumberRange(p1, p2, p3) --[[ NumberRange | Line: 37 | Upvalues: t (copy) ]]
	return NumberRange.new(t.number(p1.Min, p2.Min, p3), t.number(p1.Max, p2.Max, p3))
end
function t.NumberSequence(p1, p2, p3) --[[ NumberSequence | Line: 44 | Upvalues: t (copy) ]]
	assert(if #p1.Keypoints == #p2.Keypoints then true else false, "Number of NumberSequence keypoints must match")
	local t2 = {}
	for k, v in pairs(p1.Keypoints) do
		local v2 = p2.Keypoints[k]
		table.insert(t2, NumberSequenceKeypoint.new(t.number(v.Time, v2.Time, p3), t.number(v.Value, v2.Value, p3), t.number(v.Envelope, v2.Envelope, p3)))
	end
	return NumberSequence.new(t2)
end
function t.ColorSequence(p1, p2, p3) --[[ ColorSequence | Line: 62 | Upvalues: t (copy) ]]
	assert(if #p1.Keypoints == #p2.Keypoints then true else false, "Number of ColorSequence keypoints must match")
	local t2 = {}
	for k, v in pairs(p1.Keypoints) do
		local v2 = p2.Keypoints[k]
		table.insert(t2, ColorSequenceKeypoint.new(t.number(v.Time, v2.Time, p3), t.Color3(v.Value, v2.Value, (math.clamp(p3, 0, 1)))))
	end
	return ColorSequence.new(t2)
end
return t