-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMIBXRhYmxlBWNsb25lBnR5cGVvZgpkaWZmZXJlbmNlB3JlcXVpcmUGc2NyaXB0BlBhcmVudAVUeXBlcwACDQEAAQAAH6MBAACkAQIAAAQAgFICAACfAQIC/wIAAAAAAADdBQAAxQIFAAEAAADGAwAAxgQAAGQCDwC7LAYDUggGAKQHBAAAADBAnwcCAvAHCQAAAACAUgcGAMYIAADGCQAAZAcCAMYMAABqDAEKbgf9/wEAAABuAvD/AgAAAIIBAgAFAwEDAgQABACAAwMEAAAwQAAVBAEYAAEAAAACAAAAAAAAAAEAAAAAAAAEAAAAAQD/APsAChUAAAAAAgAAAQIADqMAAACkAAEAAAAAQKQBAwAAACBATQEBJAQAAABNAQEkBAAAAE0BAe8FAAAAnwACAsABBgCCAQIABwMFBAAAAEADBgQAACBAAwcDCAYAAQABAAEYAAEAAAAAAAAAAAAAExABAAAAAAECqquyz42Eyc1p8TBbE3xjcrK8xjBuwbM=

-- https://lua.expert/
require(script.Parent.Parent.Types)

return function(p1, ...) --[[ difference | Line: 21 ]]
	local v1 = table.clone(p1)

	for v2, v3 in { ... } do
		if typeof(v3) == "table" then
			for v4 in v3 do
				v1[v4] = nil
			end
		end
	end

	return v1
end