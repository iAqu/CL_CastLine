-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMEBmlwYWlycwV0YWJsZQZpbnNlcnQEcHVzaAACCgEAAQAGAwAABQEEJKMBAAD/AQAAAAAAAKQCAQAAAABAUgMAAJ8CAgRRAgcAnjQBBQYAAABSCAEAUgkGAKQHBAAADCCAnwcDAW4C+P8CAACApAIBAAAAAED/AwAAAAAAAN0FAADFAwUAAQAAAJ8CAgRRAgcAnjQBBQYAAABSCAEAUgkGAKQHBAAADCCAnwcDAW4C+P8CAACAggECAAUDAQQAAABAAwIDAwQADCCAABYEARgAAQACAAAAAAEAAAAAAAD/AAQAAAAAAAAAAAEAAAAAAAD/AAQWAAAAAAEAAAECAAOjAAAAwAAAAIIAAgABBgABAAEAARgAFQ4BAAAAAAEus+bqK9zJnnbRr3yglA2LXqvxnhx3jOs=

-- https://lua.expert/
return function(p1, ...) --[[ push | Line: 22 ]]
	local t = {}

	for i, v in ipairs(p1) do
		table.insert(t, v)
	end

	for i, v in ipairs({ ... }) do
		table.insert(t, v)
	end

	return t
end