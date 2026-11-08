-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMTBmlwYWlycw5HZXREZXNjZW5kYW50cwNJc0EETmFtZSdGaW5kRmlyc3REZXNjZW5kYW50V2l0aE5hbWVBbmRDbGFzc05hbWUGc2NyaXB0BlBsdWdpbhhGaW5kRmlyc3RBbmNlc3Rvck9mQ2xhc3MHUHJvbWlzZQxNb2R1bGVTY3JpcHQHcmVxdWlyZRFHZXRQcm9taXNlTGlicmFyeQRnYW1lD1JlcGxpY2F0ZWRGaXJzdApHZXRTZXJ2aWNlEVJlcGxpY2F0ZWRTdG9yYWdlE1NlcnZlclNjcmlwdFNlcnZpY2UNU2VydmVyU3RvcmFnZQZQYXJlbnQAAwsDAAAACAUAAAUDBwMDFaQDAQAAAABAvAQARwIAAACfBAIAnwMABFEDCgBSCgIAvAgH/gMAAACfCAMCDggFAE0IB7oEAAAAmggCAAEAAACCBwIAbgP1/wIAAIDGAwAAggMCAAUDAQQAAABAAwIDAwMEAAkFARgAAAAAAAAAAQAAAAAAAAAAAf4ABgAKAAAAAAsAAgAAAC2kAAEAAAAAQG8CAgC8AABJAwAAAJ8AAwIOAA4A+wEAAFICAABvAwQAbwQFAJ8BBAIOAQYAqQIBAKQDBwAAAGBAUgQBAJ8DAgCCAgAAqQIAAIICAgDGAQAApAIJAAAAgED7AwEAnwICBFECBwD7BwAAUggGAG8JBABvCgUAnwcEAlIBBwArAQIAbgL4/wIAAIAOAQYAqQIBAKQDBwAAAGBAUgQBAJ8DAgCCAgAAqQIAAIICAgAKAwYEAAAAQAMHAwgDCQMKAwsEAABgQAMBBAAAgEAAEwwBGAAAAAAAAAEBAAAAAAEBAAAAAAACAAQBAAAAAAEAAAAAAAH+AAcBAAAAAAACABYAAAAACgAAAQIALKMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQEAAAAAQG8DBAC8AQEWAwAAAJ8BAwKkAgEAAAAAQG8EBQC8AgIWAwAAAJ8CAwKkAwEAAAAAQG8FBgC8AwMWAwAAAJ8DAwL/BAAABQAAAKQFCAAAAHBATQUFJAkAAABNBQUkCQAAAFIGAABSBwEAUggCAFIJAwDFBAUGAQAAAMAFCgDABgsAEgAFABIABACCBgIADAMNBAAAAEADDgMPAxADEQMSAwYEAABwQAMTBgAGAQIAAQEAARgAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAgAAAAAAAAAAAAAAAAACCgAAHAEAAAAAAo6o2OBmtg5vFcvTr0iTaBP+sM+UvGyy4Q==

-- https://lua.expert/
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local t = {
	script.Parent.Parent,
	ReplicatedFirst,
	ReplicatedStorage,
	ServerScriptService,
	ServerStorage
}

local function FindFirstDescendantWithNameAndClassName(p1, p2, p3) --[[ FindFirstDescendantWithNameAndClassName | Line: 9 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA(p3) and v.Name == p2 then
			return v
		end
	end

	return nil
end

return function() --[[ GetPromiseLibrary | Line: 19 | Upvalues: FindFirstDescendantWithNameAndClassName (copy), t (copy) ]]
	local v1 = script:FindFirstAncestorOfClass("Plugin")

	if v1 then
		local v2 = FindFirstDescendantWithNameAndClassName(v1, "Promise", "ModuleScript")

		if v2 then
			return true, require(v2)
		end

		return false
	end

	local v3 = nil

	for i, v in ipairs(t) do
		local v4 = FindFirstDescendantWithNameAndClassName(v, "Promise", "ModuleScript")

		v3 = v4

		if v4 then
			break
		end
	end

	if v3 then
		return true, require(v3)
	end

	return false
end