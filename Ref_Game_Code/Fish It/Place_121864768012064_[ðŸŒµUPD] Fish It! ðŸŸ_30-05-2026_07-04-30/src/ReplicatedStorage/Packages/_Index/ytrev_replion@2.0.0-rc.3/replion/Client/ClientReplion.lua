-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Freeze = require(script.Parent.Parent.Parent.Freeze)
local Utils = require(script.Parent.Parent.Internal.Utils)
local Signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Parent.Internal.Types)
local Signals = require(script.Parent.Parent.Internal.Signals)
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 99 | Upvalues: Signal (copy), Signals (copy), t (copy) ]]
	return setmetatable({
		Data = p1[3],
		Tags = p1[5],
		ReplicateTo = p1[3],
		_channel = p1[2],
		_beforeDestroy = Signal.new(),
		_signals = Signals.new()
	}, t)
end
function t.__tostring(p1) --[[ __tostring | Line: 114 ]]
	return ("Replion<%*>"):format(p1._channel)
end
function t.BeforeDestroy(p1, p2) --[[ BeforeDestroy | Line: 125 ]]
	return p1._beforeDestroy:Connect(p2)
end
function t.OnDataChange(p1, p2) --[[ OnDataChange | Line: 136 ]]
	return p1._signals:Connect("onDataChange", "__root", p2)
end
function t.OnChange(p1, p2, p3) --[[ OnChange | Line: 154 ]]
	return p1._signals:Connect("onChange", p2, p3)
end
function t.OnDescendantChange(p1, p2, p3) --[[ OnDescendantChange | Line: 177 ]]
	return p1._signals:Connect("onDescendantChange", p2, p3)
end
function t.OnArrayInsert(p1, p2, p3) --[[ OnArrayInsert | Line: 189 ]]
	return p1._signals:Connect("onArrayInsert", p2, p3)
end
function t.OnArrayRemove(p1, p2, p3) --[[ OnArrayRemove | Line: 201 ]]
	return p1._signals:Connect("onArrayRemove", p2, p3)
end
function t._set(p1, p2, p3) --[[ _set | Line: 205 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	if Freeze.Dictionary.getIn(p1.Data, v1) ~= p3 then
		local v2 = Freeze.Dictionary.setIn(p1.Data, v1, p3)
		local Data = p1.Data
		p1.Data = v2
		p1._signals:FireEvent("onDataChange", "__root", v2, v1)
		p1._signals:FireChange(p2, v2, Data)
	end
	return p3
end
function t._update(p1, p2, p3) --[[ _update | Line: 224 | Upvalues: Freeze (copy), Utils (copy) ]]
	local v1 = Freeze.Dictionary.map(p3 or p2, function(p1, p2) --[[ Line: 225 | Upvalues: Utils (ref), Freeze (ref) ]]
		return if p1 == Utils.SerializedNone then Freeze.None else p1, p2
	end)
	local Data = p1.Data
	if p3 == nil then
		local v2 = Freeze.Dictionary.merge(p1.Data, v1)
		p1.Data = v2
		p1._signals:FireEvent("onDataChange", "__root", v2, {})
		for v3, v4 in v1 do
			p1._signals:FireEvent("onChange", v3, Utils.getValue(v4), Data[v3])
		end
	else
		local v5 = Utils.getPathTable(p2)
		local v6 = Freeze.Dictionary.mergeIn(p1.Data, v5, v1)
		p1.Data = v6
		p1._signals:FireEvent("onDataChange", "__root", v6, v5)
		for v7, v8 in v1 do
			local v9 = Freeze.List.push(v5, v7)
			local v10 = Freeze.Dictionary.getIn(Data, v9)
			p1._signals:FireEvent("onChange", v9, Utils.getValue(v8), v10)
		end
		p1._signals:FireChange(p2, v6, Data)
	end
end
function t._increase(p1, p2, p3) --[[ _increase | Line: 260 ]]
	return p1:_set(p2, p1:GetExpect(p2) + p3)
end
function t._decrease(p1, p2, p3) --[[ _decrease | Line: 266 ]]
	return p1:_increase(p2, -p3)
end
function t._insert(p1, p2, p3, p4) --[[ _insert | Line: 270 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	local v4 = assert(Freeze.Dictionary.getIn(p1.Data, v1), (("\"%*\" is not a valid path!"):format((Utils.getPathString(p2)))))
	local v5 = if p4 then p4 else #v4 + 1
	local v6 = Freeze.List.insert(v4, v5, p3)
	local Data = p1.Data
	local v7 = Freeze.Dictionary.setIn(p1.Data, v1, v6)
	p1.Data = v7
	p1._signals:FireEvent("onDataChange", "__root", v7, v1)
	p1._signals:FireEvent("onArrayInsert", v1, v5, p3)
	p1._signals:FireChange(v1, v7, Data)
end
function t._remove(p1, p2, p3) --[[ _remove | Line: 289 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	local v4 = assert(Freeze.Dictionary.getIn(p1.Data, v1), (("\"%*\" is not a valid path!"):format((Utils.getPathString(p2)))))
	local v5 = if p3 then p3 else #v4
	local v6 = v4[v5]
	local v7 = Freeze.List.remove(v4, v5)
	local Data = p1.Data
	local v8 = Freeze.Dictionary.setIn(p1.Data, v1, v7)
	p1.Data = v8
	p1._signals:FireEvent("onDataChange", "__root", v8, v1)
	p1._signals:FireEvent("onArrayRemove", p2, v5, v6)
	p1._signals:FireChange(p2, v8, Data)
	return v6
end
function t._clear(p1, p2) --[[ _clear | Line: 311 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	local Data = p1.Data
	local v2 = Freeze.Dictionary.setIn(p1.Data, v1, {})
	p1.Data = v2
	p1._signals:FireEvent("onDataChange", "__root", v2, v1)
	p1._signals:FireChange(p2, v2, Data)
end
function t.Find(p1, p2, p3) --[[ Find | Line: 336 ]]
	local v1 = p1:Get(p2)
	if not v1 then
		return
	end
	local v2 = table.find(v1, p3)
	if v2 then
		return v2, p3
	end
end
function t.Get(p1, p2) --[[ Get | Line: 360 | Upvalues: Freeze (copy), Utils (copy) ]]
	return Freeze.Dictionary.getIn(p1.Data, Utils.getPathTable(p2))
end
function t.GetExpect(p1, p2, p3) --[[ GetExpect | Line: 378 | Upvalues: Utils (copy) ]]
	assert(p2, "Path is required!")
	if not p3 then
		p3 = ("\"%*\" is not a valid path!"):format((Utils.getPathString(p2)))
	end
	local v2 = p1:Get(p2)
	if v2 ~= nil then
		return v2
	end
	error(p3)
end
function t.Destroy(p1) --[[ Destroy | Line: 391 ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1._beforeDestroy:Fire(p1)
		p1._beforeDestroy:DisconnectAll()
		p1._signals:Destroy()
	end
end
return t