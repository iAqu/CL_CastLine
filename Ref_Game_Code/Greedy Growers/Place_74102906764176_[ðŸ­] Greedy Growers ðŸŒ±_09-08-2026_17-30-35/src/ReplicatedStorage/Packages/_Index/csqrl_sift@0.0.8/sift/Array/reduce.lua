-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMBBnJlZHVjZQACDQMAAAAIBQAABQMEBQ8TUgMCAIwEAQBHAwMAAAAAgBMDAACMBAIAUgcEABwFAACMBgEAqAUIAFIIAQBSCQMAhwoAB1ILBwBSDAAAnwgFAlIDCACLBfj/ggMCAAAAGwEBGAABAgABAQMAAAABAAAAAAAA/wQgAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAGhQBAAAAAAE=

-- https://lua.expert/
return function(p1, p2, p3) --[[ reduce | Line: 27 ]]
	local v1, v2

	if p3 == nil then
		v1 = p1[1]
		v2 = 2
	else
		v2 = 1
		v1 = p3
	end

	for i = v2, #p1 do
		v1 = p2(v1, p1[i], i, p1)
	end

	return v1
end