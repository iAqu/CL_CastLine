-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Bezier = function(...) --[[ Bezier | Line: 1 ]]
		local function factorial(p1) --[[ factorial | Line: 2 ]]
			local v1 = 1
			for i = 2, p1 do
				v1 = v1 * i
			end
			return v1
		end
		local function combinatorics(p1, p2) --[[ combinatorics | Line: 10 ]]
			local v1 = 1
			for i = 2, p1 do
				v1 = v1 * i
			end
			local v2, v3 = 1, v1
			for j = 2, p2 do
				v2 = v2 * j
			end
			local v4, v5 = 1, v2
			for k = 2, p1 - p2 do
				v4 = v4 * k
			end
			return v3 / (v5 * v4)
		end
		local v1 = table.pack(...)
		local v2 = #v1 - 1
		local t = {}
		for i = 0, v2 do
			local v3 = 1
			for j = 2, v2 do
				v3 = v3 * j
			end
			local v4, v5 = 1, v3
			for k = 2, i do
				v4 = v4 * k
			end
			local v6, v7 = 1, v4
			for n = 2, v2 - i do
				v6 = v6 * n
			end
			table.insert(t, v5 / (v7 * v6))
		end
		return function(p1) --[[ Line: 22 | Upvalues: v2 (copy), t (copy), v1 (copy) ]]
			local sum = Vector3.new()
			for i = 0, v2 do
				sum = sum + v1[i + 1] * (t[i + 1] * math.pow(1 - p1, v2 - i) * math.pow(p1, i))
			end
			return sum
		end
	end,
	autoControlPoint = function(p1, p2) --[[ autoControlPoint | Line: 35 ]]
		local v1 = (p1 + p2) / 2
		return Vector3.new(v1.X, math.max(p1.Y, p2.Y) + ((p1 - p2) * Vector3.new(1, 0, 1)).Magnitude, v1.Z)
	end,
	lookAtTarget = function(p1, p2) --[[ lookAtTarget | Line: 43 ]]
		local v1 = Vector3.new(p2.X, p1.Y, p2.Z)
		if (p1.Position - v1).Magnitude < 0.001 then
			return p1
		else
			return CFrame.lookAt(p1.Position, v1)
		end
	end
}