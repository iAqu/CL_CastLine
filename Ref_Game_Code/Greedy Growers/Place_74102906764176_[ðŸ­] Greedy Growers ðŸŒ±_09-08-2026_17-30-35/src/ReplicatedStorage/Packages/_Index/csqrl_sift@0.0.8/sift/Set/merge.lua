-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGASMGc2VsZWN0BHR5cGUFdGFibGUFcGFpcnMFbWVyZ2UAAgsAAAEAACWjAAAA/wAAAAAAAACMAwEAbwUAALs5BQOkBAIAAAAQQN0GAACfBAACUgEEAIwCAQCoARcAuzkDBKQEAgAAABBAUgUDAN0GAACfBAACuygEA1IGBACkBQQAAAAwQJ8FAgLwBQoABQAAgKQFBwAAAGBAUgYEAJ8FAgQXBQIAqQoBAGoKAAhuBf3/AgAAAIsB6f+CAAIACAMBAwIEAAAQQAMDBAAAMEADBAMFBAAAYEAAFAYBGAABAAIAAAAAAAAAAAABAAAAAAACAAAAAAAABAAAAAABAP8A+QwUAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAExIBAAAAAAFQNIX+UnS3K+R6DssT1VdpICySimLw7/8=

-- https://lua.expert/
return function(...) --[[ merge | Line: 20 ]]
	local t = {}

	for i = 1, select("#", ...) do
		local v1 = select(i, ...)

		if type(v1) == "table" then
			for k, v in pairs(v1) do
				t[k] = true
			end
		end
	end

	return t
end