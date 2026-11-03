-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.quadratic(p1, p2, p3, p4) --[[ quadratic | Line: 7 ]]
	local v1 = 1 - p4
	return v1 * v1 * p1 + v1 * 2 * p4 * p2 + p4 * p4 * p3
end
function t.cubic(p1, p2, p3, p4, p5) --[[ cubic | Line: 12 ]]
	local v1 = 1 - p5
	local v2 = v1 * v1
	local v3 = p5 * p5
	return v2 * v1 * p1 + v2 * 3 * p5 * p2 + v1 * 3 * v3 * p3 + v3 * p5 * p4
end
function t.quadraticTangent(p1, p2, p3, p4) --[[ quadraticTangent | Line: 21 ]]
	return (1 - p4) * 2 * (p2 - p1) + p4 * 2 * (p3 - p2)
end
function t.cubicTangent(p1, p2, p3, p4, p5) --[[ cubicTangent | Line: 26 ]]
	local v1 = 1 - p5
	return v1 * 3 * v1 * (p2 - p1) + v1 * 6 * p5 * (p3 - p2) + p5 * 3 * p5 * (p4 - p3)
end
function t.makeArc(p1, p2, p3, p4) --[[ makeArc | Line: 31 ]]
	local v1 = (math.random() - 0.5) * 2 * p4
	local v2 = p3 + (math.random() - 0.5) * p4
	return p1, (p1 + p2) * 0.5 + Vector3.new(v1, v2, (math.random() - 0.5) * 2 * p4), p2
end
return t