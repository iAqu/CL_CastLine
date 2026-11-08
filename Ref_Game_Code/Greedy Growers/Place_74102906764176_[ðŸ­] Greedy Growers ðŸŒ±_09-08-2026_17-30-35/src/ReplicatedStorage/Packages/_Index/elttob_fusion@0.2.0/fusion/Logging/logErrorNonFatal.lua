-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMXBWVycm9yAQoFCiAgICAEZ3N1Yg51bmtub3duTWVzc2FnZQZzdHJpbmcGZm9ybWF0CVtGdXNpb25dIAYKKElEOiABKQ1FUlJPUl9NRVNTQUdFB21lc3NhZ2UYKQotLS0tIFN0YWNrIHRyYWNlIC0tLS0KBXRyYWNlBHRhc2sFc3Bhd24QbG9nRXJyb3JOb25GYXRhbAZzY3JpcHQGUGFyZW50B3JlcXVpcmUFVHlwZXMHTG9nZ2luZwhtZXNzYWdlcwADBQABAQAADKMAAACkAAEAAAAAQPsBAABvAwIAbwQDALwBAcwEAAAAnwEEAowCAACfAAMBggABAAUDAQQAAABAAwIDAwMEAB0AARgAAQAAAAAAAAAAAAEdAAAAAAwCAQEABwQAAAUCAw83owIAAMYCAAD7BAAAhwMEAEcDBAAAAAAA+wMAAIcCAwBlAAMAbwAAAPsDAACHAgMAxgMAAEcBDQAAAACApAQDAAAIEIBvBgQAUgcCAG8IBQBSCQAAbwoGAHMFBgrdBgAAnwQAAlIDBABlABQAbwYHAE0HAZgIAAAAvAQCzAkAAACfBAQCUgIEAKQEAwAACBCAbwYEAFIHAgBvCAUAUgkAAG8KCgBNCwFNCwAAAHMFBgvdBgAAnwQAAlIDBACkBA4AADTAgNkFAAASAQP/3QYAAJ8EAAHBAwAAggABAA8DBQMGAwcEAAgQgAMIAwkDCgMLAwwDBAMNAw4DDwMQBAA0wIABAAsRARgAAQIAAAABAAACAQADAQABAAAAAAAAAAAAAAACAAAAAAAAAQAAAAAAAAAAAAAAAAMAAAAC/gMACwAAAAAEAAABAgAWowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIA7wUAAACfAQICpAIEAAAAMEBNAwB8BgAAAE0DAwIHAAAAnwICAsADCAASAAIAggMCAAkDEgQAAABAAxMDFAQAADBAAxUDFgMXBgEBAQEAARgABgAAAAAAAQAAAAABAAAAAAAAAgAXAQAAAAACNzJ2e9ihe36EYKwR1K9bsUcqYQ8F9hx6

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.Types)

local messages = require(v1.Logging.messages)

return function(p1, p2, ...) --[[ logErrorNonFatal | Line: 11 | Upvalues: messages (copy) ]]
	if messages[p1] == nil then
		p1 = "unknownMessage"
	end

	local v1 = messages[p1]
	local v2 = if p2 == nil then string.format("[Fusion] " .. v1 .. "\n(ID: " .. p1 .. ")", ...) else string.format("[Fusion] " .. v1:gsub("ERROR_MESSAGE", p2.message) .. "\n(ID: " .. p1 .. ")\n---- Stack trace ----\n" .. p2.trace, ...)

	task.spawn(function(...) --[[ Line: 29 | Upvalues: v2 (ref) ]]
		error(v2:gsub("\n", "\n    "), 0)
	end, ...)
end