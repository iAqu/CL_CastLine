-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("./color/Oklab")
local t = {
	number = function(p1, p2, p3) --[[ number | Line: 7 ]]
		return p1 + (p2 - p1) * p3
	end,
	Vector3 = function(p1, p2, p3) --[[ Vector3 | Line: 11 ]]
		return p1:Lerp(p2, p3)
	end,
	Vector2 = function(p1, p2, p3) --[[ Vector2 | Line: 15 ]]
		return p1:Lerp(p2, p3)
	end,
	CFrame = function(p1, p2, p3) --[[ CFrame | Line: 19 ]]
		return p1:Lerp(p2, p3)
	end,
	UDim2 = function(p1, p2, p3) --[[ UDim2 | Line: 23 ]]
		return p1:Lerp(p2, p3)
	end
}
function t.UDim(p1, p2, p3) --[[ UDim | Line: 27 | Upvalues: t (copy) ]]
	return UDim.new(t.number(p1.Scale, p2.Scale, p3), t.number(p1.Offset, p2.Offset, p3))
end
function t.NumberRange(p1, p2, p3) --[[ NumberRange | Line: 35 | Upvalues: t (copy) ]]
	return NumberRange.new(t.number(p1.Min, p2.Min, p3), t.number(p1.Max, p2.Max, p3))
end
function t.Color3(p1, p2, p3) --[[ Color3 | Line: 43 | Upvalues: v1 (copy) ]]
	return v1.toSRGB(v1.fromSRGB(p1):Lerp(v1.fromSRGB(p2), p3))
end
function t.PhysicalProperties(p1, p2, p3) --[[ PhysicalProperties | Line: 50 | Upvalues: t (copy) ]]
	return PhysicalProperties.new(t.number(p1.Density, p2.Density, p3), t.number(p1.Friction, p2.Friction, p3), t.number(p1.Elasticity, p2.Elasticity, p3), t.number(p1.FrictionWeight, p2.FrictionWeight, p3), t.number(p1.ElasticityWeight, p2.ElasticityWeight, p3))
end
function t.Rect(p1, p2, p3) --[[ Rect | Line: 60 ]]
	return Rect.new(p1.Min:Lerp(p2.Min, p3), p1.Max:Lerp(p2.Max, p3))
end
function t.NumberSequence(p1, p2, p3) --[[ NumberSequence | Line: 65 ]]
	local count = 0
	local t = {}
	local t2 = {}
	for v1, v2 in p1.Keypoints do
		local v3 = nil
		local v4 = nil
		for v5, v6 in p2.Keypoints do
			if v6.Time == v2.Time then
				v3 = v6
				v4 = v6
			else
				if v6.Time < v2.Time and (v4 == nil or v6.Time > v4.Time) then
					v4 = v6
				end
				if v6.Time > v2.Time and (v3 == nil or v6.Time < v3.Time) then
					v3 = v6
				end
				continue
			end
			break
		end
		local v7, v8
		if v3 == v4 then
			v7 = v3.Value
			v8 = v3.Envelope
			count = count + 1
			t[count] = NumberSequenceKeypoint.new(v2.Time, (v7 - v2.Value) * p3 + v2.Value, (v8 - v2.Envelope) * p3 + v2.Envelope)
			t2[v2.Time] = true
		end
		local v9 = (v2.Time - v4.Time) / (v3.Time - v4.Time)
		v7 = (v3.Value - v4.Value) * v9 + v4.Value
		v8 = (v3.Envelope - v4.Envelope) * v9 + v4.Envelope
		count = count + 1
		t[count] = NumberSequenceKeypoint.new(v2.Time, (v7 - v2.Value) * p3 + v2.Value, (v8 - v2.Envelope) * p3 + v2.Envelope)
		t2[v2.Time] = true
	end
	for v10, v11 in p2.Keypoints do
		if not t2[v11.Time] then
			local v12 = nil
			local v13 = nil
			for v14, v15 in p1.Keypoints do
				if v15.Time == v11.Time then
					v12 = v15
					v13 = v15
				else
					if v15.Time < v11.Time and (v13 == nil or v15.Time > v13.Time) then
						v13 = v15
					end
					if v15.Time > v11.Time and (v12 == nil or v15.Time < v12.Time) then
						v12 = v15
					end
					continue
				end
				break
			end
			local v16, v17
			if v12 == v13 then
				v16 = v12.Value
				v17 = v12.Envelope
				count = count + 1
				t[count] = NumberSequenceKeypoint.new(v11.Time, (v11.Value - v16) * p3 + v16, (v11.Envelope - v17) * p3 + v17)
			end
			local v18 = (v11.Time - v13.Time) / (v12.Time - v13.Time)
			v16 = (v12.Value - v13.Value) * v18 + v13.Value
			v17 = (v12.Envelope - v13.Envelope) * v18 + v13.Envelope
			count = count + 1
			t[count] = NumberSequenceKeypoint.new(v11.Time, (v11.Value - v16) * p3 + v16, (v11.Envelope - v17) * p3 + v17)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 136 ]]
		return p1.Time < p2.Time
	end)
	local v19
	if #t > 20 then
		local v20 = (#t - 1) / 19
		v19 = {}
		for i = 0, 19 do
			table.insert(v19, t[math.floor(i * v20 + 1)])
		end
		if v19[#v19].Time < t[#t].Time then
			v19[#v19] = t[#t]
		end
	else
		v19 = t
	end
	return NumberSequence.new(v19)
end
local function getColorAtTime(p1, p2) --[[ getColorAtTime | Line: 161 ]]
	local Keypoints = p1.Keypoints
	if p2 <= Keypoints[1].Time then
		return Keypoints[1].Value
	elseif Keypoints[#Keypoints].Time <= p2 then
		return Keypoints[#Keypoints].Value
	else
		local v1 = nil
		local v2 = nil
		for i = 1, #Keypoints do
			local v3 = Keypoints[i]
			if v3.Time == p2 then
				return v3.Value
			end
			if v3.Time < p2 then
				v1 = v3
			end
			if p2 < v3.Time then
				v2 = v3
				break
			end
		end
		return v1.Value:Lerp(v2.Value, (p2 - v1.Time) / (v2.Time - v1.Time))
	end
end
function t.ColorSequence(p1, p2, p3) --[[ ColorSequence | Line: 192 | Upvalues: getColorAtTime (copy) ]]
	local t = {}
	for i, v in ipairs(p2.Keypoints) do
		local v1 = getColorAtTime(p1, v.Time):Lerp(v.Value, p3)
		local v2 = ColorSequenceKeypoint.new
		table.insert(t, v2(v.Time, v1))
	end
	return ColorSequence.new(t)
end
function t.Other(p1, p2, p3) --[[ Other | Line: 209 ]]
	return if p3 < 0.5 then if p1 then p1 else p2 else p2
end
return t