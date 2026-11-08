-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMPA25ldwZfX2NhbGwMc2V0bWV0YXRhYmxlDkNoYXJhY3RlckFkZGVkEUNoYXJhY3RlclJlbW92aW5nFk9uQ2FtZXJhU3ViamVjdENoYW5nZWQEd2FybkRCYXNlT2NjbHVzaW9uIEdldE9jY2x1c2lvbk1vZGUgbXVzdCBiZSBvdmVycmlkZGVuIGJ5IGRlcml2ZWQgY2xhc3NlcxBHZXRPY2NsdXNpb25Nb2RlOkJhc2VPY2NsdXNpb24gRW5hYmxlIG11c3QgYmUgb3ZlcnJpZGRlbiBieSBkZXJpdmVkIGNsYXNzZXMGRW5hYmxlOkJhc2VPY2NsdXNpb24gVXBkYXRlIG11c3QgYmUgb3ZlcnJpZGRlbiBieSBkZXJpdmVkIGNsYXNzZXMGVXBkYXRlB19faW5kZXgGQ0ZyYW1lAQ8ACQMBAQEAAAejAQAA+wEAAE0BAe8AAAAA3QIAAJ8BAACCAQAAAQMBAAoCARgAAQAAAAAACgAAAAADAAEAAAAJ/wEAAAAAAAD7AgAAnj0BAwIAAACkAAEAAAAAQJ8AAwKCAAIAAgMDBAAAAEAADwEBGAAAAAAAAAAAARAAAAAAAwMAAAAIBQAABQMEBwcBggABAAAAFQQBGAAWAAAAAAMDAAAACAUAAAUDBAcHAYIAAQAAABkFARgAGgAAAAACAgAAAAABggABAAAAHAYBGAAdAAAAAAMBAAAAAAakAQEAAAAAQG8CAgCfAQIBxgEAAIIBAgADAwcEAAAAQAMIACAJARgAAAAAAQAiAAAAAAQCAAAABwQAAAUCBAEFpAIBAAAAAEBvAwIAnwICAYIAAQADAwcEAAAAQAMKACYLARgAAAAAAScAAAAABgQAAAAJBgAABQQEAkBABaQEAQAAAABAbwUCAJ8EAgGCAgMAAwMHBAAAAEADDAAqDQEYAAAAAAErAAAAAAUAAAECACejAAAA/wAEAAAAAAAwAABuAAAAAOIDAgDABAMAEgAAADAEA+8BAAAAnj0ABAMAAABSAgAApAEFAAAAQECfAQMBwAEGABIAAAAwAQDvBwAAAMABCAAwAQCXCQAAAMABCgAwAQBQCwAAAMABDAAwAQAfDQAAAMABDgAwAQAnDwAAAMABEAAwAQDEEQAAAMABEgAwAQAmEwAAAIIAAgAUAw4DAgUBAQYAAwMEAABAQAYBAwEGAgMEBgMDBQYEAwYGBQMJBgYDCwYHAw0IAAECAwQFBgcBAAEYAAYAAQABAQAAAAAAAP8AAAYAAAAGAAAEAAADAAAEAAAGAAAEAAAFAQAAAAAIKSH6JJM3lD8zDutaREr2nVk57VAb5ZAl

-- https://lua.expert/
local t = {}

t.__index = t
setmetatable(t, {
	__call = function(p1, ...) --[[ __call | Line: 10 | Upvalues: t (copy) ]]
		return t.new(...)
	end
})
function t.new() --[[ new | Line: 15 | Upvalues: t (copy) ]]
	return setmetatable({}, t)
end
function t.CharacterAdded(p1, p2, p3) --[[ CharacterAdded | Line: 21 ]] end
function t.CharacterRemoving(p1, p2, p3) --[[ CharacterRemoving | Line: 25 ]] end
function t.OnCameraSubjectChanged(p1, p2) --[[ OnCameraSubjectChanged | Line: 28 ]] end
function t.GetOcclusionMode(p1) --[[ GetOcclusionMode | Line: 32 ]]
	warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")

	return nil
end
function t.Enable(p1, p2) --[[ Enable | Line: 38 ]]
	warn("BaseOcclusion Enable must be overridden by derived classes")
end
function t.Update(p1, p2, p3, p4) --[[ Update | Line: 42 ]]
	warn("BaseOcclusion Update must be overridden by derived classes")

	return p3, p4
end

return t