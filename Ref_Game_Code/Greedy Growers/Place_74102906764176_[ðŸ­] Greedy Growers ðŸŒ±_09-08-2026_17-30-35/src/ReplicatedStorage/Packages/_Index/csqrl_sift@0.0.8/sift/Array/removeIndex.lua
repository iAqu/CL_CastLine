-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQLcmVtb3ZlSW5kZXgAAgwCAAAABwQAAAUCBAIYHAIAAP8DAAAAAAAAjAQBAGABAgAEAAAAQwEBAqQEAQAAAABAUgUAAJ8EAgRRBAkA8QcIAAEAAACeNAMFCAAAAFIKAwBSCwgApAkEAAAMIICfCQMBbgT2/wIAAICCAwIABQMBBAAAAEADAgMDBAAMIIAAEwQBGAABAAIAAAEDAAAAAAEAAQAAAAAAAP4ABhQAAAAAAQAAAQIAA6MAAADAAAAAggACAAEGAAEAAQABGAASEQEAAAAAAQ==

-- https://lua.expert/
return function(p1, p2) --[[ removeIndex | Line: 19 ]]
	local t = {}

	if p2 < 1 then
		p2 = p2 + #p1
	end

	for i, v in ipairs(p1) do
		if i ~= p2 then
			table.insert(t, v)
		end
	end

	return t
end