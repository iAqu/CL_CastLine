-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMDBmlwYWlycwV0YWJsZQZpbnNlcnQAAg8CAAEABwQAAAUCBAIyowIAABwCAACMAwEAYAEDAAMAAACVAwIAQwEBA2ACBwABAAAAlQMCAGADAgABAAAAggACAJUBAgCVAgIA/wMAAAAAAACMBgEAUgQCAIwFAQCoBBwAmgYTAAEAAACkBwIAAAAQQP8IAAAAAAAA3QoAAMUICgABAAAAnwcCBFEHBwCeNAMFCwAAAFINAwBSDgsApAwFAAAQMICfDAMBbgf4/wIAAICHCQAGnjQDBAkAAABSCAMApAcFAAAQMICfBwMBiwTk/4IDAgAGAgAAAAAAAPA/AwEEAAAQQAMCAwMEABAwgAAVAwEYAAECAAABAAMAAQAAAQMBAwACAAAAAQABAAAAAAAAAAABAAAAAAAA/wAFAAAAAAAA+QoVAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFB8BAAAAAAEXUT2Gnlj6dlyChBHLaOKWZ0kq8iWVV4c=

-- https://lua.expert/
return function(p1, p2, ...) --[[ insert | Line: 21 ]]
	local count = #p1

	if p2 < 1 then
		p2 = p2 + (count + 1)
	end

	if count < p2 then
		if count + 1 < p2 then
			return p1
		end

		count = count + 1
		p2 = count + 1
	end

	local t = {}

	for i = 1, count do
		if i == p2 then
			for i2, v in ipairs({ ... }) do
				table.insert(t, v)
			end
		end

		table.insert(t, p1[i])
	end

	return t
end