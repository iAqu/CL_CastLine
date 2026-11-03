-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Network = require(script.Parent.Parent.Internal.Network)
local Signal = require(script.Parent.Parent.Parent.Signal)
local Utils = require(script.Parent.Parent.Internal.Utils)
local Signals = require(script.Parent.Parent.Internal.Signals)
require(script.Parent.Parent.Internal.Types)
local Freeze = require(script.Parent.Parent.Parent.Freeze)
local v1 = 0
local t = {}
local t2 = {}
t2.__index = t2
function t2.new(p1) --[[ new | Line: 145 | Upvalues: t (copy), v1 (ref), Signal (copy), Signals (copy), t2 (copy), Network (copy) ]]
	assert(type(p1.Channel) == "string", (("\"Channel\" expected string, got %*"):format((type(p1.Channel)))))
	assert(p1.ReplicateTo, "ReplicateTo is required!")
	local ReplicateTo_2 = p1.ReplicateTo
	local v3 = table.remove(t)
	local v4
	if v3 then
		v4 = v3
	else
		v1 = v1 + 1
		v4 = v1
	end
	assert(if v4 <= 1114111 then true else false, (("ID limit reached! You already have %* ServerReplions!"):format(1114111)))
	local t3 = {
		Data = p1.Data,
		Channel = p1.Channel
	}
	t3.Tags = if p1.Tags then p1.Tags else {}
	t3.ReplicateTo = ReplicateTo_2
	t3._id = v4
	t3._packedId = utf8.char(v4)
	t3._beforeDestroy = Signal.new()
	t3._signals = Signals.new()
	local v9 = setmetatable(t3, t2)
	Network.sendTo(ReplicateTo_2, "Added", v9:_serialize())
	return v9
end
function t2.__tostring(p1) --[[ __tostring | Line: 179 ]]
	local ReplicateTo = p1.ReplicateTo
	local v1
	if type(ReplicateTo) == "table" then
		local t = {}
		for v2, v3 in ReplicateTo do
			t[v2] = v3.Name
		end
		v1 = table.concat(t, ", ")
	else
		v1 = if typeof(ReplicateTo) == "Instance" then ReplicateTo.Name else ReplicateTo
	end
	return ("Replion<%*:%*>"):format(p1.Channel, v1)
end
function t2._serialize(p1) --[[ _serialize | Line: 207 ]]
	return {
		p1._packedId,
		p1.Channel,
		p1.Data,
		p1.ReplicateTo,
		p1.Tags
	}
end
function t2.BeforeDestroy(p1, p2) --[[ BeforeDestroy | Line: 221 ]]
	return p1._beforeDestroy:Connect(p2)
end
function t2.OnDataChange(p1, p2) --[[ OnDataChange | Line: 232 ]]
	return p1._signals:Connect("onDataChange", "__root", p2)
end
function t2.OnChange(p1, p2, p3) --[[ OnChange | Line: 244 ]]
	return p1._signals:Connect("onChange", p2, p3)
end
function t2.OnArrayInsert(p1, p2, p3) --[[ OnArrayInsert | Line: 256 ]]
	return p1._signals:Connect("onArrayInsert", p2, p3)
end
function t2.OnArrayRemove(p1, p2, p3) --[[ OnArrayRemove | Line: 268 ]]
	return p1._signals:Connect("onArrayRemove", p2, p3)
end
function t2.OnDescendantChange(p1, p2, p3) --[[ OnDescendantChange | Line: 280 ]]
	return p1._signals:Connect("onDescendantChange", p2, p3)
end
function t2.SetReplicateTo(p1, p2) --[[ SetReplicateTo | Line: 287 | Upvalues: Players (copy), Network (copy) ]]
	assert(if p2 == "All" or type(p2) == "table" then true elseif typeof(p2) == "Instance" then p2:IsA("Player") else false, "ReplicateTo must be a Player, a table of Players or \"All\"")
	local ReplicateTo = p1.ReplicateTo
	if ReplicateTo == p2 then
		return
	end
	local v2 = if ReplicateTo == "All" then Players:GetPlayers() elseif type(ReplicateTo) == "table" then ReplicateTo else { p2 }
	local v3 = if p2 == "All" then Players:GetPlayers() elseif type(p2) == "table" then p2 else { p2 }
	for v4, v5 in v2 do
		if not table.find(v3, v5) then
			Network.sendTo(v5, "Removed", p1._packedId)
		end
	end
	for v6, v7 in v3 do
		if not table.find(v2, v7) then
			Network.sendTo(p2, "Added", p1:_serialize())
		end
	end
	p1.ReplicateTo = p2
	Network.sendTo(p2, "UpdateReplicateTo", p1._packedId, p2)
end
function t2.Set(p1, p2, p3) --[[ Set | Line: 344 | Upvalues: Utils (copy), Freeze (copy), Network (copy) ]]
	local v1 = Utils.getPathTable(p2)
	local v2 = Freeze.Dictionary.getIn(p1.Data, v1)
	if v2 and Freeze.Dictionary.equals(v2, p3) then
		return v2
	end
	local v3 = Freeze.Dictionary.setIn(p1.Data, v1, p3)
	local Data = p1.Data
	p1.Data = v3
	p1._signals:FireEvent("onDataChange", "__root", v3, v1)
	p1._signals:FireChange(p2, v3, Data)
	Network.sendTo(p1.ReplicateTo, "Set", p1._packedId, p2, p3)
	return p3
end
function t2.Update(p1, p2, p3) --[[ Update | Line: 396 | Upvalues: Utils (copy), Freeze (copy), Network (copy) ]]
	local v1 = if p3 then Utils.getPathTable(p2) else nil
	local v2 = Freeze.Dictionary.filter(p3 or p2, function(p12, p2) --[[ Line: 398 | Upvalues: v1 (copy), Freeze (ref), p1 (copy) ]]
		return not Freeze.Dictionary.equals(if v1 then Freeze.Dictionary.getIn(p1.Data, v1) else p1.Data[p2], p12)
	end)
	if Freeze.isEmpty(v2) then
		return
	end
	local Data = p1.Data
	if v1 then
		local v3 = Freeze.Dictionary.mergeIn(p1.Data, v1, v2)
		p1.Data = v3
		p1._signals:FireEvent("onDataChange", "__root", v3, v1)
		for v4, v5 in v2 do
			local v6 = Freeze.List.push(v1, v4)
			local v7 = Freeze.Dictionary.getIn(Data, v6)
			p1._signals:FireEvent("onChange", v6, Utils.getValue(v5), v7)
		end
		p1._signals:FireChange(p2, v3, Data)
	else
		local v8 = Freeze.Dictionary.merge(p1.Data, v2)
		p1.Data = v8
		p1._signals:FireEvent("onDataChange", "__root", v8, {})
		for v9, v10 in v2 do
			p1._signals:FireEvent("onChange", v9, Utils.getValue(v10), Data[v9])
		end
	end
	local v11 = Freeze.Dictionary.map(v2, function(p1, p2) --[[ Line: 436 | Upvalues: Freeze (ref), Utils (ref) ]]
		return if p1 == Freeze.None then Utils.SerializedNone else p1, p2
	end)
	if v1 then
		Network.sendTo(p1.ReplicateTo, "Update", p1._packedId, p2, v11)
	else
		Network.sendTo(p1.ReplicateTo, "Update", p1._packedId, v11)
	end
end
function t2.Increase(p1, p2, p3) --[[ Increase | Line: 457 | Upvalues: Utils (copy) ]]
	local v1 = if type(p3) == "number" then true else false
	assert(v1, (("\"amount\" expected number, got %*"):format((type(p3)))))
	return p1:Set(p2, p1:GetExpect(p2, (("\"%*\" is not a valid path!"):format((Utils.getPathString(p2))))) + p3)
end
function t2.Decrease(p1, p2, p3) --[[ Decrease | Line: 475 ]]
	return p1:Increase(p2, -p3)
end
function t2.Insert(p1, p2, p3, p4) --[[ Insert | Line: 505 | Upvalues: Utils (copy), Freeze (copy), Network (copy) ]]
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
	Network.sendTo(p1.ReplicateTo, "ArrayUpdate", p1._packedId, "i", p2, p3, p4)
end
function t2.InsertEntry(p1, p2, p3, p4) --[[ InsertEntry | Line: 527 | Upvalues: Utils (copy), Freeze (copy) ]]
	local v1 = Utils.getPathTable(p2)
	local v4 = assert(Freeze.Dictionary.getIn(p1.Data, v1), (("\"%*\" is not a valid path!"):format((Utils.getPathString(p2)))))
	v4[p3] = p4
	local Data = p1.Data
	local v5 = Freeze.Dictionary.setIn(p1.Data, v1, v4)
	p1.Data = v5
	p1._signals:FireEvent("onDataChange", "__root", v5, v1)
	p1._signals:FireChange(v1, v5, Data)
end
function t2.Remove(p1, p2, p3) --[[ Remove | Line: 568 | Upvalues: Utils (copy), Freeze (copy), Network (copy) ]]
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
	Network.sendTo(p1.ReplicateTo, "ArrayUpdate", p1._packedId, "r", p2, p3)
	return v6
end
function t2.Clear(p1, p2) --[[ Clear | Line: 617 | Upvalues: Utils (copy), Freeze (copy), Network (copy) ]]
	if not Freeze.isEmpty((p1:GetExpect(p2, (("\"%*\" is not a valid path!"):format((Utils.getPathString(p2))))))) then
		local v2 = Utils.getPathTable(p2)
		local Data = p1.Data
		local v3 = Freeze.Dictionary.setIn(p1.Data, v2, {})
		p1.Data = v3
		p1._signals:FireEvent("onDataChange", "__root", v3, v2)
		p1._signals:FireChange(p2, v3, Data)
		Network.sendTo(p1.ReplicateTo, "ArrayUpdate", p1._packedId, "c", p2)
	end
end
function t2.Find(p1, p2, p3) --[[ Find | Line: 661 ]]
	local v1 = p1:Get(p2)
	if not v1 then
		return
	end
	local v2 = table.find(v1, p3)
	if v2 then
		return v2, p3
	end
end
function t2.Get(p1, p2) --[[ Get | Line: 684 | Upvalues: Freeze (copy), Utils (copy) ]]
	assert(p2, "Path is required!")
	return Freeze.Dictionary.getIn(p1.Data, Utils.getPathTable(p2))
end
function t2.GetExpect(p1, p2, p3) --[[ GetExpect | Line: 704 | Upvalues: Utils (copy) ]]
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
function t2.Destroy(p1) --[[ Destroy | Line: 721 | Upvalues: Network (copy), t (copy) ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1._beforeDestroy:Fire(p1)
		p1._beforeDestroy:DisconnectAll()
		p1._signals:Destroy()
		Network.sendTo(p1.ReplicateTo, "Removed", p1._packedId)
		table.insert(t, p1._id)
	end
end
return t2