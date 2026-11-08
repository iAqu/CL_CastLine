-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMFDHNldG1ldGF0YWJsZQREYXRhA25ldwdEZXN0cm95B19faW5kZXgAAwQBAQAAAAv/AgAAAAAAAPsDAACePQIDAwAAAKQBAQAAAABAnwEDAjAAAcYCAAAAggECAAMDAQQAAABAAwIAEgMBGAAAAAAAAAAAAgACEwAAAAACAQAAAAAExgEAADABAMYAAAAAggABAAEDAgAaBAEYAAAAARsAAAAAAgAAAQIADaMAAAD/AAMAAAAAADAAAG4AAAAAwAEBABIAAAAwAQDvAgAAAMABAwAwAQBQBAAAAIIAAgAFAwUGAAMDBgEDBAIAAQEAARgADQABAAMAAAAIAAAEAQAAAAACTlfuP6u81NR7NwqlKd5dNj5P+Ut8k4Q+

-- https://lua.expert/
local t = {}

t.__index = t
function t.new(p1) --[[ new | Line: 18 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)

	v2.Data = p1

	return v2
end
function t.Destroy(p1) --[[ Destroy | Line: 26 ]]
	p1.Data = nil
end

return t