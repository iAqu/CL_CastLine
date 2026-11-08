-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMPCm9iamVjdE5hbWUORmluZEZpcnN0Q2hpbGQISW5zdGFuY2UDbmV3C09iamVjdFZhbHVlBE5hbWUGc2NyaXB0BlBhcmVudAVWYWx1ZRZhZGRUb1JlcGxpY2F0ZWRTdG9yYWdlCWdldE9iamVjdARnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UTVG9wYmFyUGx1c1JlZmVyZW5jZQADAwACAAAAHfsAAAD7AgEATQIC5AAAAAC8AAADAQAAAJ8AAwIOAAIAqQEAAIIBAgCkAQQAAAwggG8CBQCfAQIC+wIBAE0CAuQAAAAAMAIBugYAAACkAggAAABwQE0CAiQJAAAAMAIB7AoAAAD7AgAAMAIBJAkAAACCAQIACwMBAwIDAwMEBAAMIIADBQMGAwcEAABwQAMIAwkACgoBGAAAAAAAAAABAQACAAAAAQAAAAABAAAAAAABAAABCwAAAAADAAIAAAAL+wAAAPsCAQBNAgLkAAAAALwAAAMBAAAAnwADAg4AAQCCAAIAqQEAAIIBAgACAwEDAgAWCwEYAAAAAAAAAAEBAgAXAAAAAAMAAAECABejAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMC/wEDAAAAAABvAgQAMAIB5AUAAADAAgYAEgAAABIAAQAwAgF7BwAAAMACCAASAAAAEgABADACARkJAAAAggECAAoDDAQAAABAAw0DDgMPAwEGAAMKBgEDCwIAAQEAARgABQAAAAAAAQABAAACAAAAAAwAAAAACAEAAAAAAiZLSFkjeLtj2E5Dv3loZHRWU18tFI8iWA==

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {
	objectName = "TopbarPlusReference"
}

function t.addToReplicatedStorage() --[[ addToReplicatedStorage | Line: 10 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	if ReplicatedStorage:FindFirstChild(t.objectName) then
		return false
	end

	local v1 = Instance.new("ObjectValue")

	v1.Name = t.objectName
	v1.Value = script.Parent
	v1.Parent = ReplicatedStorage

	return v1
end
function t.getObject() --[[ getObject | Line: 22 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	local v1 = ReplicatedStorage:FindFirstChild(t.objectName)

	if v1 then
		return v1
	end

	return false
end

return t