-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMICHRvbnVtYmVyBG1hdGgFZmxvb3IGc3RyaW5nBmZvcm1hdAIlZAQlLjJmEGZvcm1hdE11bHRpcGxpZXIAAgUBAAAABgMAAAUBAhy7PgADUgIAAKQBAgAAABBAnwECApAAAQBbBAADlQMEBLsMAwKkAgcAABhQgJ8CAgI+AQIDIQIBCA0CBwAAAACApAILAAAokIBvAwwAUgQBAJ8CAwCCAgAApAILAAAokIBvAw0AUgQBAJ8CAwCCAgAADgIAAAAAAAAAAAMBBAAAEEACAAAAAAAAWUACAAAAAAAA4D8DAgMDBAAYUIACAAAAAAAA8D8DBAMFBAAokIADBgMHAAQIARgAAAAAAAABAAAAAAAAAQAAAQAAAAAAAgAAAAAABQAAAAABAAABAgADowAAAMAAAACCAAIAAQYAAQABAAEYAAMJAQAAAAAB+pKEa+Y5JbOlZZXizTlmpYqKkx/IVu5q

-- https://lua.expert/
return function(p1) --[[ formatMultiplier | Line: 4 ]]
	local v2 = math.floor((tonumber(p1) or 0) * 100 + 0.5) / 100

	if v2 % 1 == 0 then
		return string.format("%d", v2)
	end

	return string.format("%.2f", v2)
end