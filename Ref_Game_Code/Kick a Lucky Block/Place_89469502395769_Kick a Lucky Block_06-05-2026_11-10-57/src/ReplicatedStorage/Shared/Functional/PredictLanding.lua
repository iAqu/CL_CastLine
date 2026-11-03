-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, p3, p4) --[[ predictLanding | Line: 1 ]]
	local v1 = p3 or Vector3.new(0, -196.2, 0)
	local v2 = p4 or 0
	local v3 = 0.5 * v1.Y
	local Y = p2.Y
	local v4 = Y * Y - 4 * v3 * (p1.Y - v2)
	if v4 < 0 then
		return nil
	else
		local v5 = math.sqrt(v4)
		local v6 = (-Y + v5) / (2 * v3)
		local v7 = (-Y - v5) / (2 * v3)
		local v8 = v6 > 0 and v7 > 0 and math.min(v6, v7) or math.max(v6, v7)
		if v8 < 0 then
			return nil
		else
			local v9 = p1 + p2 * v8 + 0.5 * v1 * v8 * v8
			return Vector3.new(v9.X, v2, v9.Z), v8
		end
	end
end