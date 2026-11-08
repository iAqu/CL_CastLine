-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBG1hdGgEc3FydANleHADc2luA2NvcxJzcHJpbmdDb2VmZmljaWVudHMAAhMDAAAACAUAAAUDAgICag0AAwAAAAAADQIGAAAAAICMAwEAjAQAAIwFAACMBgEAggMFAMYDAADGBAAAxgUAAMYGAACMBwEAYAclAAEAAAAJBwACBAoBAngJCgG7GQkCpAgFAAAQMICfCAIC2AkGCDkLCAAmCgsB2AsBCgkNBwq7Cw0CpAwIAAAcMICfDAICCQ4HC7sLDgKkDQgAABwwgJ8NAgIJDw0KCRAMCyYODxAJAw4JJg8MDQkODwnsBA4CJg8NDAkODwkJBQ4CCQ8MCgkQDQsmDg8QCQYOCYIDBQANARAAAQAAgAkHAAI5CQcAuwsJAqQICAAAHDCAnwgCApUJBwEJAwgJCQQIADkKBwAJCQoCCQUICfUJAQcJBggJggMFAAkHAAIECgEC9QkBCrsZCQKkCAUAABAwgJ8IAgLYCQEICQoIBzkNBwAJDA0BuwsMAqQLCAAAHDCAnwsCArsYCgNSDgoApA0KAAAkMICfDQICCQwLDbsJCgNSDwoApA4MAAAsMICfDgICCQ0LDgkODAkJDw4BQwMPDVIEDgAJEQ8BCRIMCEMQERI5BRAAJgYND4IDBQANAgAAAAAAAAAAAgAAAAAAAPA/AgAAAAAAAABAAwEDAgQAEDCAAgAAAAAAAOC/AwMEABwwgAMEBAAkMIADBQQALDCAAA4GARgAAAAAAQAAAAACAAAAAgAACQEAAAAAAAEBAAEBAAAAAAEAAAAAAgAAAAEAAAEAAAEAAAAAAgAFAQAAAAACAAEBAAABAAALAQAAAAAAAQEBAAAAAAABAAAAAAABAAAAAAABAQIBAQAAAAEDEAAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYAA1GAQAAAAABtvPZF4HTiU+vX8MofihEPcbrzmOEN7MW

-- https://lua.expert/
return function(p1, p2, p3) --[[ springCoefficients | Line: 14 ]]
	if p1 == 0 or p3 == 0 then
		return 1, 0, 0, 1
	end

	if p2 > 1 then
		local v1 = p1 * p3
		local v2 = math.sqrt(p2 ^ 2 - 1)
		local v3 = -0.5 / v2
		local v4 = -v2 - p2
		local v5 = 1 / v4
		local v6 = math.exp(v1 * v4)
		local v7 = math.exp(v1 * v5)

		return (v7 * v4 - v6 * v5) * v3, (v6 - v7) * v3 / p3, (v7 - v6) * v3 * p3, (v6 * v4 - v7 * v5) * v3
	end

	if p2 == 1 then
		local v8 = p1 * p3
		local v9 = math.exp(-v8)

		return v9 * (v8 + 1), v9 * p1, v9 * (-v8 * p3), v9 * (1 - v8)
	end

	local v10 = p1 * p3
	local v11 = math.sqrt(1 - p2 ^ 2)
	local v12 = v11 * v10
	local v13 = math.exp(-v10 * p2)
	local v14 = v13 * math.sin(v12)
	local v15 = v13 * math.cos(v12)
	local v16 = v14 * (1 / v11)
	local v17 = v16 * p2

	return v17 + v15, v16, -(v17 * p2 + v14 * v11), v15 - v17
end