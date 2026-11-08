-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHDGRlcGVuZGVudFNldAZ1cGRhdGUJdXBkYXRlQWxsBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQhQdWJUeXBlcwACDgEAAAAAS/8BAAAAAAAA/wIAAAAAAAD/AwAAAAAAAIwEAACMBQEATQYAYQAAAADGBwAAxggAAGQGBACVBAQBagkDBKkLAQBqCwIJbgb7/wEAAAB9BRgABAAAAIcGAwWHBwEGRwcDAAAAAICMCAEAZQABAJUIBwFqCAEGTQgGYQAAAABHCAoAAAAAAE0IBmEAAAAAxgkAAMYKAABkCAIAlQQEAWoLAwRuCP3/AQAAAJUFBQFIAOf/jAUBAH0FHAAEAAAAhwYDBYcIAQZ4BwgBagcBBg0HFAACAACAhwgCBg4IEQC8CAbGAwAAAJ8IAgIOCA0ATQgGYQAAAABHCAoAAAAAAE0IBmEAAAAAxgkAAMYKAABkCAIAqQ0BAGoNAgtuCP3/AQAAAJUFBQFIAOP/ggABAAQDAQIAAAAAAADwPwIAAAAAAAAAAAMCABEDARgAAAEAAQABAQIAAAAAAQEBAP0ABwABAQEAAAAAAAEAAAABAAAAAAEB/gAF9g4BAAEBAAEBAAAAAAAAAAAAAAABAAAAAAEA/wAE9wsSAAAAAAMAAAECAA6jAAAApAABAAAAAEBNAAAkAgAAAE0AACQCAAAApAEEAAAAMEBNAgCnBQAAAJ8BAgLAAgYAggICAAcDBAQAAABAAwUDBgQAADBAAwcGAAEAAQABGAAJAAAAAAABAAAAAAYqAQAAAAABn2nYYeeRZgRw7lFyh5N72+9xzxWtrbJg

-- https://lua.expert/
require(script.Parent.Parent.PubTypes)

return function(p1) --[[ updateAll | Line: 17 ]]
	local count = 0
	local t = {}
	local t2 = {}
	local count2 = 1
	local t3 = {}

	for v1 in p1.dependentSet do
		count = count + 1
		t[count] = v1
		t2[v1] = true
	end

	while count2 <= count do
		local v2 = t[count2]
		local v3 = t3[v2]

		t3[v2] = if v3 == nil then 1 else v3 + 1

		if v2.dependentSet ~= nil then
			for v5 in v2.dependentSet do
				count = count + 1
				t[count] = v5
			end
		end

		count2 = count2 + 1
	end

	local count3 = 1

	while count3 <= count do
		local v6 = t[count3]
		local v7 = t3[v6] - 1

		t3[v6] = v7

		if v7 == 0 and (t2[v6] and (v6:update() and v6.dependentSet ~= nil)) then
			for v8 in v6.dependentSet do
				t2[v8] = true
			end
		end

		count3 = count3 + 1
	end
end