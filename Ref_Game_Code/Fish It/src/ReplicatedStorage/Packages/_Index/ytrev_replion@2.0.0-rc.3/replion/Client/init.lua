-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local Utils = require(script.Parent.Internal.Utils)
local Signal = require(script.Parent.Parent.Signal)
local Network = require(script.Parent.Internal.Network)
local ClientReplion = require(script.ClientReplion)
require(script.Parent.Internal.Types)
local t = {}
local t2 = {}
local t3 = {}
local v1 = Signal.new()
local v2 = Signal.new()
local function getWaitList(p1) --[[ getWaitList | Line: 48 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if not v1 then
		v1 = {}
		t2[p1] = v1
	end
	return v1
end
local function cancelWait(p1, p2) --[[ cancelWait | Line: 58 | Upvalues: Utils (copy), t3 (copy) ]]
	for v1, v2 in p1 do
		if v2.thread == p2 then
			table.remove(p1, v1)
			if v2.async then
				Utils.safeCancelThread(p2)
			else
				task.spawn(p2)
			end
			t3[p2] = nil
			return
		end
	end
end
local function createTimeout(p1, p2, p3) --[[ createTimeout | Line: 79 | Upvalues: cancelWait (copy) ]]
	return task.delay(p2, cancelWait, p1, p3)
end
local function createReplion(p1) --[[ createReplion | Line: 83 | Upvalues: t (copy), ClientReplion (copy), v1 (copy), t2 (copy) ]]
	local v12 = p1[2]
	if t[v12] then
		return
	end
	local v2 = ClientReplion.new(p1)
	t[v12] = v2
	t[p1[1]] = v2
	v1:Fire(v2)
	local v3 = t2[v12]
	if not v3 then
		return
	end
	for v4, v5 in v3 do
		task.spawn(v5.thread, v2)
	end
	t2[v12] = nil
end
local t4 = {
	OnReplionAdded = function(p1, p2) --[[ OnReplionAdded | Line: 120 | Upvalues: v1 (copy) ]]
		return v1:Connect(p2)
	end,
	OnReplionRemoved = function(p1, p2) --[[ OnReplionRemoved | Line: 131 | Upvalues: v2 (copy) ]]
		return v2:Connect(p2)
	end,
	OnReplionAddedWithTag = function(p1, p2, p3) --[[ OnReplionAddedWithTag | Line: 143 ]]
		return p1:OnReplionAdded(function(p1) --[[ Line: 144 | Upvalues: p2 (copy), p3 (copy) ]]
			local Tags = p1.Tags
			if not Tags or table.find(Tags, p2) == nil then
				return
			end
			p3(p1)
		end)
	end,
	OnReplionRemovedWithTag = function(p1, p2, p3) --[[ OnReplionRemovedWithTag | Line: 161 ]]
		return p1:OnReplionRemoved(function(p1) --[[ Line: 162 | Upvalues: p2 (copy), p3 (copy) ]]
			local Tags = p1.Tags
			if not Tags or table.find(Tags, p2) == nil then
				return
			end
			p3(p1)
		end)
	end,
	GetReplion = function(p1, p2) --[[ GetReplion | Line: 176 | Upvalues: t (copy) ]]
		return t[p2]
	end,
	WaitReplion = function(p1, p2, p3) --[[ WaitReplion | Line: 188 | Upvalues: t (copy), t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = t[p2]
		if v1 then
			return v1
		end
		local v2 = coroutine.running()
		local v3 = t2[p2]
		if not v3 then
			v3 = {}
			t2[p2] = v3
		end
		if p3 then
			t3[v2] = task.delay(p3, cancelWait, v3, v2)
		end
		table.insert(v3, {
			thread = v2
		})
		return coroutine.yield()
	end,
	AwaitReplion = function(p1, p2, p3, p4) --[[ AwaitReplion | Line: 216 | Upvalues: t (copy), t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = t[p2]
		if v1 then
			return p3(v1)
		end
		local v2 = t2[p2]
		if not v2 then
			v2 = {}
			t2[p2] = v2
		end
		local v3 = v2
		local v4 = coroutine.create(p3)
		if p4 then
			t3[v4] = task.delay(p4, cancelWait, v3, v4)
		end
		table.insert(v3, {
			async = true,
			thread = v4
		})
		return function() --[[ Line: 231 | Upvalues: cancelWait (ref), v3 (copy), v4 (copy) ]]
			cancelWait(v3, v4)
		end
	end
}
if Utils.ShouldMock or not RunService:IsClient() then
	return table.freeze(t4)
end
local v3 = Network.get("Added")
local v4 = Network.get("Removed")
local v5 = Network.get("Update")
local v6 = Network.get("Set")
local v7 = Network.get("UpdateReplicateTo")
local v8 = Network.get("ArrayUpdate")
v3.OnClientEvent:Connect(function(p1) --[[ Line: 244 | Upvalues: createReplion (copy) ]]
	if type(p1[1]) ~= "table" then
		createReplion(p1)
		return
	end
	for v2, v3 in p1 do
		createReplion(v3)
	end
end)
v4.OnClientEvent:Connect(function(p1) --[[ Line: 254 | Upvalues: t (copy), v2 (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	t[p1] = nil
	t[v1._channel] = nil
	v2:Fire(v1)
	v1:Destroy()
end)
v5.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 266 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	v1:_update(p2, p3)
end)
v7.OnClientEvent:Connect(function(p1, p2) --[[ Line: 274 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	v1.ReplicateTo = p2
end)
v6.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 282 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	v1:_set(p2, p3)
end)
v8.OnClientEvent:Connect(function(p1, p2, ...) --[[ Line: 290 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	if p2 == "i" then
		v1:_insert(...)
		return
	end
	if p2 == "r" then
		v1:_remove(...)
		return
	end
	if p2 ~= "c" then
		return
	end
	v1:_clear(...)
end)
return table.freeze(t4)