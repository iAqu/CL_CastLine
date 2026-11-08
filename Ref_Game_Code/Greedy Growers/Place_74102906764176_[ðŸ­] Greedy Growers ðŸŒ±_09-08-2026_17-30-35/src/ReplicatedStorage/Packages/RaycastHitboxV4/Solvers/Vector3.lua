-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMMCUluc3RhbmNlcwhQb3NpdGlvbgZDRnJhbWUSVmVjdG9yVG9Xb3JsZFNwYWNlDExhc3RQb3NpdGlvbgpXb3JsZFNwYWNlBVNvbHZlFFVwZGF0ZVRvTmV4dFBvc2l0aW9uBmxvb2tBdAlWaXN1YWxpemUHVmVjdG9yMwNuZXcABAkCAQAABwQAAAUCBAQeTQMB5wAAAAATAgMATQQB5wAAAAATAwQBTQUCOwEAAABNBgKFAgAAAFIIAwC8BgauAwAAAJ8GAwJDBAUGTQUBSQQAAAArBQIAMAQBSQQAAABNBQFJBAAAAE0HAUkEAAAAKwcBAPsHAAAmBgQHMAQBWQUAAACCBQMABgMBAwIDAwMEAwUDBgALBwEYAAAAAQAAAQAAAAAAAAAAAwAAAQADAAEAAAAAAgACDQAAAAADAgAAAAcEAAAFAgQEA00CAVkAAAAAggICAAEDBgAeCAEYAAAAHwAAAAAFAgAAAAcEAAAFAgQECKQCAgAABACATQMBWQMAAABNBAFJBAAAAJ8CAwCCAgAABQMDAwkEAAQAgAMGAwUAIgoBGAAAAAAAAAAAIwAAAAADAAABAgASowAAAP8AAwAAAAAATDYAAqQBAgAABACAnwEBAsACAwASAAEAMAIAtAQAAADAAgUAMAIAdwYAAADAAgcAMAIAgggAAACCAAIACQMLAwwEAAQAgAYAAwcGAQMIBgIDCgMAAQIBAAEYAAQAAgAAAAQAAAATAAAEAAAEAQAAAAAD0O7fhEgEvyeyAUdM/pRxz6D2yPDiKrWF

-- https://lua.expert/
local t = {}
local v1 = Vector3.new()

function t.Solve(p1, p2) --[[ Solve | Line: 11 | Upvalues: v1 (copy) ]]
	local v12 = p2.Instances[1]
	local v3 = v12.Position + v12.CFrame:VectorToWorldSpace(p2.Instances[2])

	if not p2.LastPosition then
		p2.LastPosition = v3
	end

	local LastPosition = p2.LastPosition
	local v4 = p2.LastPosition or v1

	p2.WorldSpace = v3

	return LastPosition, v3 - v4
end
function t.UpdateToNextPosition(p1, p2) --[[ UpdateToNextPosition | Line: 30 ]]
	return p2.WorldSpace
end
function t.Visualize(p1, p2) --[[ Visualize | Line: 34 ]]
	return CFrame.lookAt(p2.WorldSpace, p2.LastPosition)
end

return t