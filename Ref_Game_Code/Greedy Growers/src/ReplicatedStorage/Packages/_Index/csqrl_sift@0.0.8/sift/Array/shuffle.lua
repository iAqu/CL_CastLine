-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKBlJhbmRvbQNuZXcCb3MEdGltZQtOZXh0SW50ZWdlcgdzaHVmZmxlB3JlcXVpcmUGc2NyaXB0BlBhcmVudARjb3B5AAIKAQEAAAYDAAAFAQQapAECAAAEAICkAwUAABAwgJ8DAQIcBAAACQIDBJ8BAgL7AgAAUgMAAJ8CAgIcBQIAjAMBAIwE//+oAwoAjAgBAFIJBQC8BgGMBgAAAJ8GBAKHBwIFhwgCBmoIAgVqBwIGiwP2/4ICAgAHAwEDAgQABACAAwMDBAQAEDCAAwUAEwYBGAAAAAAAAAAAAQAAAgAAAAEAAAAAAQIAAfsIFAAAAAACAAABAgANowAAAKQAAQAAAABApAEDAAAAIEBNAQEkBAAAAE0BAQkFAAAAnwACAsABBgASAAAAggECAAcDBwQAAABAAwgEAAAgQAMJAwoGAAEAAQABGAABAAAAAAAAAAARAA8BAAAAAAGxLxkBd1RJ+d4xJj5s/6OqwTcOdYPrcwA=

-- https://lua.expert/
local copy = require(script.Parent.copy)

return function(p1) --[[ shuffle | Line: 19 | Upvalues: copy (copy) ]]
	local v1 = Random.new(os.time() * #p1)
	local v2 = copy(p1)

	for i = #v2, 1, -1 do
		local v3 = v1:NextInteger(1, i)
		local v4 = v2[i]

		v2[i] = v2[v3]
		v2[v3] = v4
	end

	return v2
end