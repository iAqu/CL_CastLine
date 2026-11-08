-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMIBXRhYmxlBWNsb25lBnR5cGVvZhNkaWZmZXJlbmNlU3ltbWV0cmljB3JlcXVpcmUGc2NyaXB0BlBhcmVudAVUeXBlcwACDgEAAQAAL6MBAACkAQIAAAQAgFICAACfAQIC/wIAAAAAAADdBQAAxQIFAAEAAADGAwAAxgQAAGQCFAC7LAYDUggGAKQHBAAAADBAnwcCAvAHDgAAAACAUgcGAMYIAADGCQAAZAcHAIcNAQpHDQMAAAAAgKkMAQBlAAEAqQwAAGoMAQpuB/j/AQAAAG4C6/8CAAAAUgIBAMYDAADGBAAAZAIFAA4GAgCpBwEAZQABAMYHAABqBwEFbgL6/wIAAACCAQIABQMBAwIEAAQAgAMDBAAAMEAAFQQBGAABAAAAAgAAAAAAAAABAAAAAAAABAAAAAEAAAAAAAD/APsACgAAAAEAAAAA/wAEFQAAAAACAAABAgAOowAAAKQAAQAAAABApAEDAAAAIEBNAQEkBAAAAE0BASQEAAAATQEB7wUAAACfAAICwAEGAIIBAgAHAwUEAAAAQAMGBAAAIEADBwMIBgABAAEAARgAAQAAAAAAAAAAAAATFAEAAAAAAfrnipmFVJ2/8hgLizichx2K/53tyCPgmA==

-- https://lua.expert/
require(script.Parent.Parent.Types)

return function(p1, ...) --[[ differenceSymmetric | Line: 21 ]]
	local v1 = table.clone(p1)

	for v2, v3 in { ... } do
		if typeof(v3) == "table" then
			for v4 in v3 do
				v1[v4] = v1[v4] == nil
			end
		end
	end

	for v6, v7 in v1 do
		v1[v6] = if v7 then true else nil
	end

	return v1
end