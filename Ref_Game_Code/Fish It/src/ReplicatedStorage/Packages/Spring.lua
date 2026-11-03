-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
function t.new(p1, p2, p3, p4) --[[ new | Line: 16 | Upvalues: t (copy) ]]
	if p2 == nil then
		p2 = 10
	end
	if p4 == nil then
		p4 = 1
	end
	if not (p4 * p2 < 0) then
		local v1
		v1 = t
		return setmetatable({
			goal = p3 or p1,
			dampingRatio = p4,
			angularFrequency = p2
		}, t):resetToPosition(p1)
	end
	error("Spring does not converge", 2)
end
function t.resetToPosition(p1, p2) --[[ resetToPosition | Line: 31 ]]
	p1.position = p2
	p1.velocity = p2 * 0
	return p1
end
function t.update(p1, p2) --[[ update | Line: 37 | Upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy) ]]
	local dampingRatio = p1.dampingRatio
	local v1 = p1.angularFrequency * 6.283185307179586
	local goal = p1.goal
	local velocity = p1.velocity
	local v2 = p1.position - goal
	local v3 = exp(-dampingRatio * v1 * p2)
	local v4
	if dampingRatio == 1 then
		p1.velocity = (velocity * (1 - v1 * p2) - v2 * (v1 * v1 * p2)) * v3
		v4 = (v2 * (1 + v1 * p2) + velocity * p2) * v3 + goal
	elseif dampingRatio < 1 then
		local v5 = 1 - dampingRatio * dampingRatio
		local v6 = sqrt(v5)
		local v7 = v1 * v6
		local v8 = cos(v7 * p2)
		local v9 = sin(v7 * p2)
		local v10
		if v6 > 0.0001 then
			v10 = v9 / v6
		else
			local v11 = p2 * v1
			local v12 = v11 * v11
			v10 = v11 * ((v5 * v5 * v12 - 20 * v5) / 120 * v12 + 1)
		end
		local v13
		if v7 > 0.0001 then
			v13 = v9 / v7
		else
			local v14 = v7 * v7
			local v15 = p2 * p2
			v13 = p2 * (v15 * (v14 * v14 * v15 / 20 - v14) / 6 + 1)
		end
		local v16 = v10 * dampingRatio
		p1.velocity = (velocity * (v8 - v16) - v2 * (v10 * v1)) * v3
		v4 = (v2 * (v8 + v16) + velocity * v13) * v3 + goal
	else
		local v17 = -v1 * dampingRatio
		local v18 = v1 * sqrt(dampingRatio * dampingRatio - 1)
		local v19 = v17 + v18
		local v20 = v17 - v18
		local v21 = (velocity - v2 * v19) / (2 * v18)
		local v22 = (v2 - v21) * exp(v19 * p2)
		local v23 = v21 * exp(v20 * p2)
		p1.velocity = v22 * v19 + v23 * v20
		v4 = v22 + v23 + goal
	end
	p1.position = v4
	return v4
end
return t