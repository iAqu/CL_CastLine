-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local exp = math.exp
local sin = math.sin
local cos = math.cos
local min = math.min
local sqrt = math.sqrt
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 13 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2.position = p3 or 0
	v2.velocity = p3 * 0 or 0
	v2.target = p3 or 0
	v2.dampingRatio = p2 or 0.4
	v2.frequency = p1 or 1
	return v2
end
function t.destroy(p1) --[[ destroy | Line: 25 ]] end
function t.getPosition(p1) --[[ getPosition | Line: 28 ]]
	return p1.position
end
function t.getTarget(p1) --[[ getTarget | Line: 32 ]]
	return p1.target
end
function t.getVelocity(p1) --[[ getVelocity | Line: 36 ]]
	return p1.velocity
end
function t.getFrequency(p1) --[[ getFrequency | Line: 40 ]]
	return p1.frequency
end
function t.getDampingRatio(p1) --[[ getDampingRatio | Line: 44 ]]
	return p1.dampingRatio
end
function t.setPosition(p1, p2) --[[ setPosition | Line: 48 ]]
	p1.position = p2
end
function t.setVelocity(p1, p2) --[[ setVelocity | Line: 52 ]]
	p1.velocity = p2
end
function t.setTarget(p1, p2) --[[ setTarget | Line: 56 ]]
	p1.target = p2
end
function t.addVelocity(p1, p2) --[[ addVelocity | Line: 60 ]]
	p1.velocity = p1.velocity + p2
end
function t.setDampingRatio(p1, p2) --[[ setDampingRatio | Line: 64 ]]
	p1.dampingRatio = p2
end
function t.setFrequency(p1, p2) --[[ setFrequency | Line: 68 ]]
	p1.frequency = p2
end
function t.rest(p1) --[[ rest | Line: 72 ]]
	p1.velocity = p1.target
	p1.position = p1.target
end
function t.update(p1, p2) --[[ update | Line: 77 | Upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy) ]]
	local dampingRatio = p1.dampingRatio
	local v1 = p1.frequency * 2 * math.pi
	local target = p1.target
	local position = p1.position
	local velocity = p1.velocity
	if dampingRatio == 1 then
		local v2 = exp(-v1 * p2)
		local v3 = p2 * v2
		local v4 = position - target
		p1.position = v4 * (v2 + v3 * v1) + velocity * v3 + target
		p1.velocity = velocity * (v2 - v3 * v1) - v4 * (v3 * v1 * v1)
		return
	end
	if not (dampingRatio < 1) then
		local v5 = sqrt(dampingRatio * dampingRatio - 1)
		local v6 = -v1 * (dampingRatio - v5)
		local v7 = -v1 * (dampingRatio + v5)
		local v8 = exp(v6 * p2)
		local v9 = exp(v7 * p2)
		local v10 = position - target
		local v11 = (velocity - v10 * v6) / (2 * v1 * v5)
		local v12 = v8 * (v10 - v11)
		p1.position = v12 + v11 * v9 + target
		p1.velocity = v12 * v6 + v11 * v9 * v7
		return
	end
	local v13 = exp(-dampingRatio * v1 * p2)
	local v14 = sqrt(1 - dampingRatio * dampingRatio)
	local v15 = cos(p2 * v1 * v14)
	local v16 = sin(p2 * v1 * v14)
	local v17
	if v14 > 0.00001 then
		v17 = v16 / v14
	else
		local v18 = p2 * v1
		v17 = v18 + (v18 * v18 * (v14 * v14) * (v14 * v14) / 20 - v14 * v14) * (v18 * v18 * v18) / 6
	end
	local v19
	if v1 * v14 > 0.00001 then
		v19 = v16 / (v1 * v14)
	else
		local v20 = v1 * v14
		v19 = p2 + (p2 * p2 * (v20 * v20) * (v20 * v20) / 20 - v20 * v20) * (p2 * p2 * p2) / 6
	end
	local v21 = position - target
	p1.position = (v21 * (v15 + v17 * dampingRatio) + velocity * v19) * v13 + target
	p1.velocity = (velocity * (v15 - v17 * dampingRatio) - v21 * (v17 * v1)) * v13
end
return t