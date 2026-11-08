-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNDHNldG1ldGF0YWJsZQdyZXF1aXJlBnNjcmlwdAxDYW1lcmFNb2R1bGUMV2FpdEZvckNoaWxkB2NhbWVyYXMNQ29udHJvbE1vZHVsZQhjb250cm9scwNuZXcKR2V0Q2FtZXJhcwtHZXRDb250cm9scxhHZXRDbGlja1RvTW92ZUNvbnRyb2xsZXIHX19pbmRleAAFBQABAAAAH/8BAgAAAAAA+wIAAJ49AQMCAAAApAABAAAAAECfAAMCpAEDAAAAIECkAgUAAABAQG8EBgC8AgLTBwAAAJ8CAwCfAQACMAEApggAAACkAQMAAAAgQKQCBQAAAEBAbwQJALwCAtMHAAAAnwIDAJ8BAAIwAQBwCgAAAIIAAgALAwEEAAAAQAMCBAAAIEADAwQAAEBAAwQDBQMGAwcDCAAMCQEYAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQ0AAAAAAgEAAAAAA00BAKYAAAAAggECAAEDBgATCgEYAAAAFAAAAAACAQAAAAADTQEAcAAAAACCAQIAAQMIABcLARgAAAAYAAAAAAMBAAAAAAZNAQBwAAAAALwBAW4BAAAAnwECAIIBAAACAwgDDAAbDAEYAAAAAAAAHAAAAAACAAABAgAWowAAAP8ABAAAAAAAMAAAbgAAAADAAQEAEgAAADABAO8CAAAAwAEDADABALAEAAAAwAEFADABAH0GAAAAwAEHADABAG4IAAAATQEA7wIAAACfAQEAggEAAAkDDQYAAwkGAQMKBgIDCwYDAwwEAAECAwEAARgACAABAAIAAAAHAAAEAAAEAAAEAAAAAQAAAAAETs0JTJEt4SDIKkj3b2oTNT7VHjh8CWNN

-- https://lua.expert/
local t = {}

t.__index = t
function t.new() --[[ new | Line: 12 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)

	v2.cameras = require(script:WaitForChild("CameraModule"))
	v2.controls = require(script:WaitForChild("ControlModule"))

	return v2
end
function t.GetCameras(p1) --[[ GetCameras | Line: 19 ]]
	return p1.cameras
end
function t.GetControls(p1) --[[ GetControls | Line: 23 ]]
	return p1.controls
end
function t.GetClickToMoveController(p1) --[[ GetClickToMoveController | Line: 27 ]]
	return p1.controls:GetClickToMoveController()
end

return t.new()