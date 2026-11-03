-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Freeze = require(script.Parent.Parent.Parent.Freeze)
local Signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Types)
local Utils = require(script.Parent.Utils)
local t = {}
t.__index = t
function t.new() --[[ new | Line: 19 | Upvalues: t (copy) ]]
	return setmetatable({
		_containers = {}
	}, t)
end
function t._getContainer(p1, p2) --[[ _getContainer | Line: 25 ]]
	assert(p1._containers, "You\'re trying to use a Replion that has been destroyed!")
	local v1 = p1._containers[p2]
	if not v1 then
		v1 = {}
		p1._containers[p2] = v1
	end
	return v1
end
function t.Connect(p1, p2, p3, p4) --[[ Connect | Line: 38 ]]
	return assert(p1:Get(p2, p3), "Signal does not exist!"):Connect(p4)
end
function t.Get(p1, p2, p3, p4) --[[ Get | Line: 44 | Upvalues: Utils (copy), Signal (copy) ]]
	local v1 = p1:_getContainer(p2)
	local v2 = nil
	for v3, v4 in Utils.getPathTable(p3) do
		local v5 = v1[v4]
		if not v5 then
			v5 = {}
			v1[v4] = v5
		end
		v2 = v5.__signal
		v1 = v5
	end
	if not v2 and (p4 == nil or p4) then
		local v6 = Signal.new()
		v1.__signal = v6
		v2 = v6
	end
	return v2
end
function t.FireEvent(p1, p2, p3, ...) --[[ FireEvent | Line: 71 ]]
	local v1 = p1:Get(p2, p3)
	if not v1 then
		return
	end
	v1:Fire(...)
end
function t.FireChange(p1, p2, p3, p4) --[[ FireChange | Line: 78 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	for i = #v1, 1, -1 do
		local v2 = Freeze.List.slice(v1, 1, i)
		local v3 = p1:Get("onChange", v2, false)
		local v4 = Freeze.Dictionary.getIn(p3, v2)
		local v5 = Freeze.Dictionary.getIn(p4, v2)
		if v3 then
			v3:Fire(v4, v5)
		end
		if i > 1 then
			local v6 = p1:Get("onDescendantChange", Freeze.List.slice(v1, 1, i - 1), false)
			if v6 then
				v6:Fire(v2, v4, v5)
			end
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 102 ]]
	assert(p1._containers, "This Replion has already been destroyed!")
	local function v1(p1) --[[ destroySignals | Line: 105 | Upvalues: v1 (copy) ]]
		if p1.__signal then
			p1.__signal:Destroy()
			p1.__signal = nil
		end
		for v12, v2 in p1 do
			v1(v2)
		end
	end
	for v2, v3 in p1._containers do
		if v3.__signal then
			v3.__signal:Destroy()
			v3.__signal = nil
		end
		for v4, v5 in v3 do
			v1(v5)
		end
	end
	p1._containers = nil
end
return t