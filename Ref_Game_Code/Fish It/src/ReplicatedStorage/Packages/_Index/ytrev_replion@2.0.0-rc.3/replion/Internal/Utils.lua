-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local Freeze = require(script.Parent.Parent.Parent.Freeze)
require(script.Parent.Types)
local function getPathTable(p1) --[[ getPathTable | Line: 9 ]]
	if type(p1) == "table" then
		return p1
	end
	if type(p1) == "string" then
		return string.split(p1, ".")
	else
		return { p1 }
	end
end
local function getPathString(p1) --[[ getPathString | Line: 19 ]]
	if type(p1) == "string" then
		return p1
	end
	if type(p1) == "table" then
		return table.concat(p1, ".")
	else
		return tostring(p1)
	end
end
local function getValue(p1) --[[ getValue | Line: 29 | Upvalues: Freeze (copy) ]]
	if p1 == Freeze.None or p1 == "\0" then
		return nil
	else
		return p1
	end
end
local function safeCancelThread(p1) --[[ safeCancelThread | Line: 33 ]]
	if coroutine.status(p1) == "dead" then
		return
	end
	task.cancel(p1)
end
local freeze = table.freeze
local t = {
	SerializedNone = "\0"
}
t.ShouldMock = RunService:IsStudio() and not RunService:IsRunning()
t.getValue = getValue
t.getPathTable = getPathTable
t.getPathString = getPathString
t.safeCancelThread = safeCancelThread
return freeze(t)