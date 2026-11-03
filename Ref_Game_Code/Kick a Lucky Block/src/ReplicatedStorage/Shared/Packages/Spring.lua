-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	_type = "Spring"
}
function t.new(p1, p2, p3, p4) --[[ new | Line: 117 | Upvalues: t (copy) ]]
	local v3 = if p4 then p4 else os.clock
	return setmetatable({
		_clock = v3,
		_time = v3(),
		_position = p1,
		_velocity = p1 * 0,
		_target = p1,
		_damping = p2 or 1,
		_speed = p3 or 1,
		_initial = p1
	}, t)
end
function t.Reset(p1, p2) --[[ Reset | Line: 144 ]]
	local v1 = p1._clock()
	local v2 = if p2 then p2 else p1._initial
	p1._position = v2
	p1._target = v2
	p1._velocity = 0 * v2
	p1._time = v1
end
function t.Impulse(p1, p2) --[[ Impulse | Line: 162 ]]
	p1.Velocity = p1.Velocity + p2
end
local function _positionVelocity(p1, p2) --[[ _positionVelocity | Line: 168 ]]
	local _position = p1._position
	local _velocity = p1._velocity
	local _damping = p1._damping
	local _speed = p1._speed
	local v1 = _speed * (p2 - p1._time)
	local v2 = _damping * _damping
	local v3, v4, v5
	if v2 < 1 then
		local v6 = math.sqrt(1 - v2)
		local v7 = math.exp(-_damping * v1) / v6
		v3 = v7 * math.cos(v6 * v1)
		v4 = v7 * math.sin(v6 * v1)
		v5 = v6
	elseif v2 == 1 then
		v5 = 1
		local v8 = math.exp(-_damping * v1) / v5
		v3 = v8
		v4 = v8 * v1
	else
		local v9 = math.sqrt(v2 - 1)
		local v10 = 2 * v9
		local v11 = math.exp((-_damping + v9) * v1) / v10
		local v12 = math.exp((-_damping - v9) * v1) / v10
		v5 = v9
		v3 = v11 + v12
		v4 = v11 - v12
	end
	local v13 = p1._target - _position
	return _position + v13 * (1 - (v5 * v3 + _damping * v4)) + _velocity * (v4 / _speed), v13 * (_speed * v4) + _velocity * (v5 * v3 - _damping * v4)
end
function t.TimeSkip(p1, p2) --[[ TimeSkip | Line: 221 | Upvalues: _positionVelocity (copy) ]]
	local v1 = p1._clock()
	local v2, v3 = _positionVelocity(p1, v1 + p2)
	p1._position = v2
	p1._velocity = v3
	p1._time = v1
end
function t.__index(p1, p2) --[[ __index | Line: 232 | Upvalues: t (copy), _positionVelocity (copy) ]]
	if t[p2] then
		return t[p2]
	elseif p2 == "Position" or p2 == "p" then
		local v1, _ = _positionVelocity(p1, p1._clock())
		return v1
	elseif p2 == "Velocity" or p2 == "v" then
		local _, v2 = _positionVelocity(p1, p1._clock())
		return v2
	elseif p2 == "Target" or p2 == "t" then
		return p1._target
	elseif p2 == "Damping" or p2 == "d" then
		return p1._damping
	elseif p2 == "Speed" or p2 == "s" then
		return p1._speed
	elseif p2 == "Clock" then
		return p1._clock
	else
		error(string.format("%q is not a valid member of Spring.", (tostring(p2))), 2)
	end
end
function t.__newindex(p1, p2, p3) --[[ __newindex | Line: 253 | Upvalues: _positionVelocity (copy) ]]
	local v1 = p1._clock()
	if p2 == "Position" or p2 == "p" then
		local _, v2 = _positionVelocity(p1, v1)
		p1._position = p3
		p1._velocity = v2
		p1._time = v1
	elseif p2 == "Velocity" or p2 == "v" then
		local v3, _ = _positionVelocity(p1, v1)
		p1._position = v3
		p1._velocity = p3
		p1._time = v1
	elseif p2 == "Target" or p2 == "t" then
		local v4, v5 = _positionVelocity(p1, v1)
		p1._position = v4
		p1._velocity = v5
		p1._target = p3
		p1._time = v1
	elseif p2 == "Damping" or p2 == "d" then
		local v6, v7 = _positionVelocity(p1, v1)
		p1._position = v6
		p1._velocity = v7
		p1._damping = p3
		p1._time = v1
	elseif p2 == "Speed" or p2 == "s" then
		local v8, v9 = _positionVelocity(p1, v1)
		p1._position = v8
		p1._velocity = v9
		p1._speed = if p3 < 0 then 0 else p3
		p1._time = v1
	elseif p2 == "Clock" then
		local v11, v12 = _positionVelocity(p1, v1)
		p1._position = v11
		p1._velocity = v12
		p1._clock = p3
		p1._time = p3()
	else
		error(string.format("%q is not a valid member of Spring.", (tostring(p2))), 2)
	end
end
return t