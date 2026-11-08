-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMiDURldGVjdGlvbk1vZGUIUGFydE1vZGUGQnlwYXNzF19SYXljYXN0SGl0Ym94VjRNYW5hZ2VkBkhhc1RhZwtfRmluZEhpdGJveA1SYXljYXN0UGFyYW1zE0hpdGJveFJheWNhc3RQb2ludHMUSGl0Ym94UGVuZGluZ1JlbW92YWwOSGl0Ym94U3RvcFRpbWUMSGl0Ym94T2JqZWN0DUhpdGJveEhpdExpc3QMSGl0Ym94QWN0aXZlClZpc3VhbGl6ZXIIRGVidWdMb2cIT25VcGRhdGUFT25IaXQDVGFnBkNyZWF0ZQxzZXRtZXRhdGFibGUFX0luaXQDbmV3CUdldEhpdGJveARnYW1lEUNvbGxlY3Rpb25TZXJ2aWNlCkdldFNlcnZpY2UHcmVxdWlyZQZzY3JpcHQMSGl0Ym94Q2FzdGVyBlNpZ25hbAdfX2luZGV4E1JheWNhc3RIaXRib3hNb2R1bGUGX190eXBlB0RlZmF1bHQAAwkDBAAACAUAAAUDDwEPQsYDAAD7BAAATQQEkQAAAABNBARKAQAAAEcBBgAAAAAA+wUAAE0FBZEAAAAATQQFTgIAAAAOAA4A+wUBAFIHAABvCAMAvAUF3gQAAACfBQQCDgUHAPsFAgBSBwAAvAUFmAUAAACfBQMCUgMFAIIDAgDiBhUAMAIGSgYAAAAwBAaRAAAAAP8HAAAAAAAAMAcGPgcAAAAwAAamDAAAAP8HAAAAAAAAMAcGlg0AAAD7BwMAvAcHlhYAAACfBwICMAcGzhIAAAD7BwMAvAcHlhYAAACfBwICMAcG5RMAAAD7BwIAnj0GAwcAAACkBRgAAABwQZ8FAwJSAwUAvAUDTBkAAACfBQIBggMCABoDAQMCAwMDBAMFAwYDBwMIAwkBAAMKAgAAAAAAAAAAAwsDDAMNAw4BAQMPAxADEQMSCA0G/////wD/////B/////8ICQAAAAoLAAAADP////8N/////w4JAAAADxAAAAARCQAAABL/////E/////8UAwAAAAMTAxQEAABwQQMVALkBFgEYAAEAAAAAAQABAAAAAAMAAAAAAAAAAQAAAAAAAAIBAAEAAQAAAAMAAQAAAAQAAAAAAAEAAAAAAAIAAPIAAAAQAAADugAAAAAFAgEAAAAIDgEGAPsCAABSBAEAvAICmAAAAACfAgMAggIAAIIAAQABAwYA2wEXARgAAQAAAAAAAtwAAAAABQAAAQIAK6MAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQUAAABAQKQCBwAAAGBATQICdAgAAACfAQICpAIFAAAAQECkAwcAAABgQE0DAx8JAAAAnwICAv8DBAAAAAAAMAMDbgoAAABvBAsAMAQDmQwAAADiBBMAMAQDkRQAAADABBUAEgADABIAAAASAAEAEgACADAEA+8WAAAAwAQXABIAAQAwBAM7GAAAAIIDAgAZAxgEAAAAQAMZAxoDGwQAAEBAAxwEAABgQAMdAx4DHwMgAyEDIgIAAAAAAADwPwMCAgAAAAAAAABAAwMCAAAAAAAACEAIAw0OAAAADxAAAAAREgAAAAMBBgADFgYBAxcCAAEBAAEYAKcAAAAAAAEAAAAAAAABAAAAAAAAAgABAAEAAAMAAAgAAAAAAAAiAAAABgEAAAAAAtnhyJaApf/oEgj99reKOzCp+d/i6yWilw==

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local HitboxCaster = require(script.HitboxCaster)
local Signal = require(script.Signal)
local t = {}

t.__index = t
t.__type = "RaycastHitboxModule"
t.DetectionMode = {
	Default = 1,
	PartMode = 2,
	Bypass = 3
}
function t.new(p1, p2, p3) --[[ new | Line: 185 | Upvalues: t (copy), CollectionService (copy), HitboxCaster (copy), Signal (copy) ]]
	local PartMode = t.DetectionMode.PartMode

	if p2 ~= nil then
		PartMode = t.DetectionMode.Bypass
	end

	if p1 and CollectionService:HasTag(p1, "_RaycastHitboxV4Managed") then
		return HitboxCaster:_FindHitbox(p1)
	end

	local v2 = setmetatable({
		HitboxPendingRemoval = false,
		HitboxStopTime = 0,
		HitboxActive = false,
		Visualizer = true,
		DebugLog = false,
		Tag = "_RaycastHitboxV4Managed",
		RaycastParams = p3,
		DetectionMode = PartMode,
		HitboxRaycastPoints = {},
		HitboxObject = p1,
		HitboxHitList = {},
		OnUpdate = Signal:Create(),
		OnHit = Signal:Create()
	}, HitboxCaster)

	v2:_Init()

	return v2
end
function t.GetHitbox(p1, p2) --[[ GetHitbox | Line: 219 | Upvalues: HitboxCaster (copy) ]]
	if p2 then
		return HitboxCaster:_FindHitbox(p2)
	end
end

return t