-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local sin = math.sin
local cos = math.cos
local abs = math.abs
local max = math.max
local pow = math.pow
function t.Circle(p1) --[[ Circle | Line: 17 | Upvalues: sin (copy), cos (copy) ]]
	return p1.CFrame * CFrame.new(sin(p1.Time) * p1.Radius, 0, cos(p1.Time) * p1.Radius)
end
function t.Heart(p1) --[[ Heart | Line: 27 | Upvalues: sin (copy), pow (copy), cos (copy) ]]
	return p1.CFrame * CFrame.new(pow(sin(p1.Time), 3) * 16 * p1.Radius / 17, 0, (cos(p1.Time) * 13 - cos(p1.Time * 2) * 5 - cos(p1.Time * 3) * 2 - cos(p1.Time * 4)) * p1.Radius / 17)
end
function t.Star(p1) --[[ Star | Line: 41 | Upvalues: cos (copy), sin (copy) ]]
	local Time = p1.Time
	local v1 = p1.Radius * (cos(Time * 5) * 0.35 + 0.65)
	return p1.CFrame * CFrame.new(sin(Time) * v1, 0, cos(Time) * v1)
end
function t.Triangle(p1) --[[ Triangle | Line: 48 | Upvalues: cos (copy), sin (copy) ]]
	local Time = p1.Time
	local v1 = p1.Radius * (cos(Time * 3) * 0.25 + 0.75)
	return p1.CFrame * CFrame.new(sin(Time) * v1, 0, cos(Time) * v1)
end
function t.Square(p1) --[[ Square | Line: 55 | Upvalues: sin (copy), cos (copy), abs (copy), max (copy) ]]
	local Time = p1.Time
	local v1 = sin(Time)
	local v2 = cos(Time)
	local v3 = max(abs(v1), (abs(v2)))
	if v3 == 0 then
		return p1.CFrame
	else
		return p1.CFrame * CFrame.new(v1 / v3 * p1.Radius, 0, v2 / v3 * p1.Radius)
	end
end
function t.Diamond(p1) --[[ Diamond | Line: 73 | Upvalues: sin (copy), cos (copy), abs (copy) ]]
	local Time = p1.Time
	local v1 = sin(Time)
	local v2 = cos(Time)
	local v3 = abs(v1) + abs(v2)
	if v3 == 0 then
		return p1.CFrame
	else
		return p1.CFrame * CFrame.new(v1 / v3 * p1.Radius, 0, v2 / v3 * p1.Radius)
	end
end
function t.Infinity(p1) --[[ Infinity | Line: 91 | Upvalues: sin (copy), cos (copy) ]]
	local Time = p1.Time
	local v1 = sin(Time)
	return p1.CFrame * CFrame.new(v1 * p1.Radius, 0, sin(Time) * cos(Time) * p1.Radius)
end
return t