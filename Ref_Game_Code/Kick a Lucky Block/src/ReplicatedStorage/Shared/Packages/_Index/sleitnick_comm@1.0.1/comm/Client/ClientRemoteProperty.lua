-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Promise = require(script.Parent.Parent.Parent.Promise)
local Signal = require(script.Parent.Parent.Parent.Signal)
local ClientRemoteSignal = require(script.Parent.ClientRemoteSignal)
require(script.Parent.Parent.Types)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 32 | Upvalues: t (copy), ClientRemoteSignal (copy), Signal (copy), Promise (copy) ]]
	local v2 = setmetatable({}, t)
	v2._rs = ClientRemoteSignal.new(p1, p2, p3)
	v2._ready = false
	v2._value = nil
	v2.Changed = Signal.new()
	v2._rs:Fire()
	local v3 = nil
	v2._readyPromise = Promise.new(function(p1) --[[ Line: 45 | Upvalues: v3 (ref) ]]
		v3 = p1
	end)
	v2._changed = v2._rs:Connect(function(p1) --[[ Line: 48 | Upvalues: v2 (copy), v3 (ref) ]]
		local isNot_value = p1 ~= v2._value
		v2._value = p1
		if not v2._ready then
			v2._ready = true
			v3(p1)
		end
		if isNot_value then
			v2.Changed:Fire(p1)
		end
	end)
	return v2
end
function t.Get(p1) --[[ Get | Line: 71 ]]
	return p1._value
end
function t.OnReady(p1) --[[ OnReady | Line: 94 ]]
	return p1._readyPromise
end
function t.IsReady(p1) --[[ IsReady | Line: 110 ]]
	return p1._ready
end
function t.Observe(p1, p2) --[[ Observe | Line: 135 ]]
	if p1._ready then
		task.defer(p2, p1._value)
	end
	return p1.Changed:Connect(p2)
end
function t.Destroy(p1) --[[ Destroy | Line: 145 ]]
	p1._rs:Destroy()
	if p1._readyPromise then
		p1._readyPromise:cancel()
	end
	if p1._changed then
		p1._changed:Disconnect()
	end
	p1.Changed:Destroy()
end
return t