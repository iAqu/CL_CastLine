-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMVDHNldG1ldGF0YWJsZQdlbmFibGVkCm1vdmVWZWN0b3IabW92ZVZlY3RvcklzQ2FtZXJhUmVsYXRpdmUJaXNKdW1waW5nA25ldw9fY29ubmVjdGlvblV0aWwNR2V0TW92ZVZlY3RvchpJc01vdmVWZWN0b3JDYW1lcmFSZWxhdGl2ZQxHZXRJc0p1bXBpbmcFZXJyb3JeQmFzZUNoYXJhY3RlckNvbnRyb2xsZXI6RW5hYmxlIG11c3QgYmUgb3ZlcnJpZGRlbiBpbiBkZXJpdmVkIGNsYXNzZXMgYW5kIHNob3VsZCBub3QgYmUgY2FsbGVkLgZFbmFibGUGc2NyaXB0BlBhcmVudAtDb21tb25VdGlscwxXYWl0Rm9yQ2hpbGQHcmVxdWlyZQ5Db25uZWN0aW9uVXRpbAdWZWN0b3IzB19faW5kZXgABgMAAwAAABv/AQQAAAAAAPsCAACePQEDAgAAAKQAAQAAAABAnwADAqkBAAAwAQCQAgAAAPsBAQAwAQBHAwAAAKkBAQAwAQA8BAAAAKkBAAAwAQAnBQAAAPsBAgBNAQHvBgAAAJ8BAQIwAQDQBwAAAIIAAgAIAwEEAAAAQAMCAwMDBAMFAwYDBwAhBgEYAAAAAAAAAAACAAABAAABAAABAAABAAAAAAACIgAAAAACAQAAAAADTQEARwAAAACCAQIAAQMDAC0IARgAAAAuAAAAAAIBAAAAAANNAQA8AAAAAIIBAgABAwQAMQkBGAAAADIAAAAAAgEAAAAAA00BACcAAAAAggECAAEDBQA1CgEYAAAANgAAAAAEAgAAAAcEAAAFAgQBBqQCAQAAAABAbwMCAJ8CAgGpAgAAggICAAMDCwQAAABAAwwAOw0BGAAAAAABADwAAAAABQAAAQIALaMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAABvAgMAvAAA0wQAAACfAAMCpAEGAAAAUEBvBAcAvAIA0wQAAACfAgMAnwEAAkw2AAKkAgoAACSAgJ8CAQL/AwAAAAAAADADA24LAAAAwAQMABIAAwASAAIAEgABADAEA+8JAAAAwAQNADAEA/0OAAAAwAQPADAEA80QAAAAwAQRADAEA+0SAAAAwAQTADAEA8QUAAAAggMCABUDDgQAAABAAw8DEAMRAxIEAABQQAMTAxQDBgQAJICAAxUGAAYBAwgGAgMJBgMDCgYEAw0FAAECAwQBAAEYAAgAAAAAAAAAAAABAAAAAAAAEgAAAAIAAQACAAAAAAAMAAAEAAAEAAAGAAAFAQAAAAAFExxFGQajqmrKuKB6KFu2uGMEUm0h2C8Y

-- https://lua.expert/
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local v1 = Vector3.new()
local t = {}

t.__index = t
function t.new() --[[ new | Line: 33 | Upvalues: t (copy), v1 (copy), ConnectionUtil (copy) ]]
	local v2 = setmetatable({}, t)

	v2.enabled = false
	v2.moveVector = v1
	v2.moveVectorIsCameraRelative = true
	v2.isJumping = false
	v2._connectionUtil = ConnectionUtil.new()

	return v2
end
function t.GetMoveVector(p1) --[[ GetMoveVector | Line: 45 ]]
	return p1.moveVector
end
function t.IsMoveVectorCameraRelative(p1) --[[ IsMoveVectorCameraRelative | Line: 49 ]]
	return p1.moveVectorIsCameraRelative
end
function t.GetIsJumping(p1) --[[ GetIsJumping | Line: 53 ]]
	return p1.isJumping
end
function t.Enable(p1, p2) --[[ Enable | Line: 59 ]]
	error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
end

return t