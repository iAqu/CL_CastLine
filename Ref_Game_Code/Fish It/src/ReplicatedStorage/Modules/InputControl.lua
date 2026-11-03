-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
require(ReplicatedStorage.Packages.Net)
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {
	_disconnect = function(p1, p2) --[[ _disconnect | Line: 38 | Upvalues: t (copy) ]]
		return {
			Disconnect = function(p1) --[[ Disconnect | Line: 40 | Upvalues: t (ref), p2 (copy) ]]
				local v1 = table.find(t, p2)
				if not v1 then
					return
				end
				table.remove(t, v1)
			end
		}
	end
}
function t5.RegisterInput(p1, p2, p3, p4, p5) --[[ RegisterInput | Line: 49 | Upvalues: t (copy), t5 (copy) ]]
	local t2 = {
		keyCodes = p2,
		conditions = p3,
		callback = p4,
		tag = p5
	}
	table.insert(t, t2)
	return t5:_disconnect(t2)
end
function t5.RegisterRelease(p1, p2, p3, p4, p5) --[[ RegisterRelease | Line: 62 | Upvalues: t2 (copy), t5 (copy) ]]
	local t = {
		keyCodes = p2,
		conditions = p3,
		callback = p4,
		tag = p5
	}
	table.insert(t2, t)
	return t5:_disconnect(t)
end
function t5.RegisterMouseInput(p1, p2, p3) --[[ RegisterMouseInput | Line: 75 | Upvalues: t3 (copy), t5 (copy) ]]
	table.insert(t3, p3)
	return t5:_disconnect(p3)
end
function t5.RegisterMouseReleased(p1, p2, p3) --[[ RegisterMouseReleased | Line: 81 | Upvalues: t4 (copy), t5 (copy) ]]
	table.insert(t4, p3)
	return t5:_disconnect(p3)
end
function t5._isMouseInput(p1, p2) --[[ _isMouseInput | Line: 87 ]]
	return p2.UserInputType == Enum.UserInputType.MouseButton1
end
function t5._processStruct(p1, p2, p3) --[[ _processStruct | Line: 91 ]]
	if table.find(p3.keyCodes, p2.KeyCode) == nil then
		return
	end
	if p3.conditions then
		for i, v in ipairs(p3.conditions) do
			if v(p2) == false then
				return false
			end
		end
	end
	task.spawn(p3.callback, p2)
end
function t5._inputBegan(p1, p2, p3) --[[ _inputBegan | Line: 107 | Upvalues: t5 (copy), t3 (copy), t (copy) ]]
	if t5:_isMouseInput(p2) then
		for i, v in ipairs(t3) do
			task.spawn(v, p2)
		end
	else
		for i, v in ipairs(t) do
			t5:_processStruct(p2, v)
		end
	end
end
function t5._inputEnded(p1, p2, p3) --[[ _inputEnded | Line: 121 | Upvalues: t5 (copy), t4 (copy), t2 (copy) ]]
	if t5:_isMouseInput(p2) then
		for i, v in ipairs(t4) do
			task.spawn(v, p2)
		end
	else
		for i, v in ipairs(t2) do
			t5:_processStruct(p2, v)
		end
	end
end
UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 136 | Upvalues: t5 (copy) ]]
	if not p2 then
		t5:_inputBegan(p1, p2)
	end
end)
UserInputService.InputEnded:Connect(function(p1, p2) --[[ Line: 144 | Upvalues: t5 (copy) ]]
	if not p2 then
		t5:_inputEnded(p1, p2)
	end
end)
UserInputService.TouchEnded:Connect(function(p1, p2) --[[ Line: 152 | Upvalues: t5 (copy) ]]
	t5:_inputEnded(p1, p2)
end)
return t5