-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local BindToRenderStep = require(script.Parent:WaitForChild("BindToRenderStep"))
local t = {}
local v1 = 0
local function generateKey(p1) --[[ generateKey | Line: 6 ]]
	return ("__internal_rs_%d"):format(p1)
end
function t.Disconnect(p1) --[[ Disconnect | Line: 10 ]]
	if p1._bound then
		p1._bound()
		p1._bound = nil
	end
	if not (#p1._callbacks > 0) then
		return
	end
	for i, v in ipairs(p1._callbacks) do
		v()
	end
	p1._callbacks = {}
end
function t.IsConnected(p1) --[[ IsConnected | Line: 25 ]]
	return p1._bound ~= nil
end
function t.Then(p1, p2) --[[ Then | Line: 29 ]]
	assert(if type(p2) == "function" then true else false, "Expected a function")
	if p1._bound then
		table.insert(p1._callbacks, p2)
	else
		p2()
	end
	return p1
end
function t.Wait(p1) --[[ Wait | Line: 41 ]]
	while p1:IsConnected() do
		task.wait()
	end
end
function t._Step(p1, p2) --[[ _Step | Line: 47 ]]
	local _elapsedTime = p1._elapsedTime
	local _duration = p1._duration
	local _unrestrictedTime = p1._unrestrictedTime
	if not _unrestrictedTime then
		p2 = math.min(p2, _duration - _elapsedTime)
	end
	local v2 = _elapsedTime + p2
	if not _unrestrictedTime then
		v2 = math.min(v2, _duration)
	end
	p1._elapsedTime = v2
	local v4, v5
	if p1._scaledTime and _duration ~= (1 / 0) then
		v4 = p2 / _duration
		v5 = v2 / _duration
		if not _unrestrictedTime then
			local v6 = math.min(v4, 1 - v5)
			v4, v5 = v6, math.min(v5, 1)
		end
	else
		v4 = p2
		v5 = v2
	end
	if not (p1._callback(v4, v5) or _duration <= v2) then
		return
	end
	p1:Disconnect()
end
return function(p1, p2, p3, p4, p5) --[[ Line: 81 | Upvalues: v1 (ref), t (copy), BindToRenderStep (copy) ]]
	assert(if type(p1) == "function" then true else false, "Callback must be a function")
	if p2 ~= nil then
		assert(if type(p2) == "number" and p2 >= 0 then if p2 == p2 then true else false else false, "Invalid duration")
	end
	if p5 ~= nil then
		assert(if type(p5) == "number" and p5 >= 0 then if p5 == p5 then true else false else false, "Invalid priority")
	end
	local v4 = if p5 then p5 else Enum.RenderPriority.Last.Value
	v1 = v1 + 1
	local v8 = setmetatable({
		_bound = nil,
		_elapsedTime = 0,
		_connection = nil,
		_callback = p1,
		_duration = p2 or (1 / 0),
		_scaledTime = if p3 == true then true else false,
		_unrestrictedTime = if p4 == true then true else false,
		_key = ("__internal_rs_%d"):format(v1),
		_id = v1,
		_priority = v4,
		_callbacks = {}
	}, {
		__index = t
	})
	v8._bound = BindToRenderStep(v8._key, v8._priority, function(p1) --[[ Line: 114 | Upvalues: v8 (copy) ]]
		v8:_Step(p1)
	end)
	return v8
end