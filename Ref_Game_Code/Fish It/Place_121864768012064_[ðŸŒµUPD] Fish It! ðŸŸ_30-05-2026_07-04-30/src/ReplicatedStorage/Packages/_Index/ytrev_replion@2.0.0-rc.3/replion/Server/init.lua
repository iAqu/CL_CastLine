-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Freeze = require(script.Parent.Parent.Freeze)
local Utils = require(script.Parent.Internal.Utils)
local Network = require(script.Parent.Internal.Network)
local ServerReplion = require(script.ServerReplion)
local Signal = require(script.Parent.Parent.Signal)
require(script.Parent.Internal.Types)
local v1 = Signal.new()
local v2 = Signal.new()
local t = {}
local t2 = {}
local t3 = {}
local function getCache(p1, p2) --[[ getCache | Line: 61 ]]
	local v1 = p1[p2]
	if not v1 then
		v1 = {}
		p1[p2] = v1
	end
	return v1
end
local function cancelWait(p1, p2) --[[ cancelWait | Line: 72 | Upvalues: Utils (copy), t3 (copy) ]]
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
local function createTimeout(p1, p2, p3) --[[ createTimeout | Line: 93 | Upvalues: cancelWait (copy) ]]
	return task.delay(p2, cancelWait, p1, p3)
end
local t4 = {
	new = function(p1) --[[ new | Line: 111 | Upvalues: t (copy), ServerReplion (copy), v2 (copy), v1 (copy), t2 (copy), t3 (copy), Utils (copy) ]]
		local v12 = assert(p1.Channel, "Channel is required!")
		local v22 = t
		local v3 = v22[v12]
		if not v3 then
			v3 = {}
			v22[v12] = v3
		end
		local v4 = v3
		local ReplicateTo = p1.ReplicateTo
		for v5, v6 in v4 do
			local ReplicateTo_2 = v6.ReplicateTo
			local v7 = if ReplicateTo_2 == ReplicateTo then true else false
			if not v7 and (type(ReplicateTo_2) == "table" and type(ReplicateTo) == "table") then
				for v8, v9 in ReplicateTo_2 do
					v7 = if table.find(ReplicateTo, v9) == nil then false else true
					if v7 then
						break
					end
				end
			end
			if v7 then
				local v10 = nil
				if typeof(ReplicateTo_2) == "Instance" then
					v10 = tostring(ReplicateTo_2)
				elseif type(ReplicateTo_2) == "string" then
					v10 = ReplicateTo_2
				elseif type(ReplicateTo_2) == "table" then
					for v122, v13 in ReplicateTo_2 do
						v10 = (if v10 then v10 .. ", " else "") .. tostring(v13)
					end
				end
				error((("Channel \"%*\" already exists! for \"%*\""):format(v12, v10)))
			end
		end
		local v15 = ServerReplion.new(p1)
		v15:BeforeDestroy(function() --[[ Line: 150 | Upvalues: v4 (copy), v15 (copy), t (ref), v12 (copy), v2 (ref) ]]
			local v1 = table.find(v4, v15)
			if v1 then
				table.remove(v4, v1)
			end
			if #v4 ~= 0 then
				v2:Fire(v12, v15)
				return
			end
			t[v12] = nil
			v2:Fire(v12, v15)
		end)
		table.insert(v4, v15)
		v1:Fire(v12, v15)
		local v16 = t2[v12]
		if v16 then
			for i = #v16, 1, -1 do
				local v17 = v16[i]
				local thread = v17.thread
				local player = v17.player
				local ReplicateTo_2 = v15.ReplicateTo
				local v18
				if player then
					local v19 = false
					if typeof(ReplicateTo_2) == "Instance" then
						v19 = ReplicateTo_2 == player
					elseif type(ReplicateTo_2) == "table" then
						v19 = if table.find(ReplicateTo_2, player) == nil then false else true
					end
					if v19 then
						v18 = t3[thread]
						if v18 then
							Utils.safeCancelThread(v18)
							t3[thread] = nil
						end
						task.spawn(thread, v15)
						table.remove(v16, i)
					end
				else
					v18 = t3[thread]
					if v18 then
						Utils.safeCancelThread(v18)
						t3[thread] = nil
					end
					task.spawn(thread, v15)
					table.remove(v16, i)
				end
			end
		end
		return v15
	end,
	GetReplion = function(p1, p2) --[[ GetReplion | Line: 212 | Upvalues: t (copy) ]]
		local v1 = t[p2]
		if not v1 then
			return nil
		end
		assert(#v1 == 1, (("There are multiple replions with the channel \"%*\". Did you mean to use GetReplionFor?"):format(p2)))
		return v1[1]
	end,
	GetReplionFor = function(p1, p2, p3) --[[ GetReplionFor | Line: 232 | Upvalues: t (copy) ]]
		local v1 = t[p3]
		if not v1 then
			return nil
		end
		for v2, v3 in v1 do
			if v3.ReplicateTo == p2 and v3.Channel == p3 then
				return v3
			end
		end
		return nil
	end,
	GetReplionsFor = function(p1, p2) --[[ GetReplionsFor | Line: 250 | Upvalues: t (copy) ]]
		local t2 = {}
		for v1, v2 in t do
			for v3, v4 in v2 do
				local ReplicateTo = v4.ReplicateTo
				local v5 = if ReplicateTo == "All" then true else false
				if not v5 and type(ReplicateTo) == "table" then
					v5 = table.find(ReplicateTo, p2) ~= nil
				elseif not v5 and ReplicateTo == p2 then
					v5 = true
				end
				if v5 then
					table.insert(t2, v4)
				end
			end
		end
		return t2
	end,
	WaitReplion = function(p1, p2, p3) --[[ WaitReplion | Line: 283 | Upvalues: t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = p1:GetReplion(p2)
		if v1 then
			return v1
		end
		local v2 = coroutine.running()
		local v3 = t2
		local v4 = v3[p2]
		if not v4 then
			v4 = {}
			v3[p2] = v4
		end
		if p3 then
			t3[v2] = task.delay(p3, cancelWait, v4, v2)
		end
		table.insert(v4, {
			thread = v2
		})
		return coroutine.yield()
	end,
	WaitReplionFor = function(p1, p2, p3, p4) --[[ WaitReplionFor | Line: 310 | Upvalues: t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = p1:GetReplionFor(p2, p3)
		if v1 then
			return v1
		end
		local v2 = coroutine.running()
		local v3 = t2
		local v4 = v3[p3]
		if not v4 then
			v4 = {}
			v3[p3] = v4
		end
		if p4 then
			t3[v2] = task.delay(p4, cancelWait, v4, v2)
		end
		table.insert(v4, {
			thread = v2,
			player = p2
		})
		return coroutine.yield()
	end,
	AwaitReplion = function(p1, p2, p3, p4) --[[ AwaitReplion | Line: 338 | Upvalues: t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = p1:GetReplion(p2)
		if v1 then
			return p3(v1)
		end
		local v2 = t2
		local v3 = v2[p2]
		if not v3 then
			v3 = {}
			v2[p2] = v3
		end
		local v4 = v3
		local v5 = coroutine.create(p3)
		if p4 then
			t3[v5] = task.delay(p4, cancelWait, v4, v5)
		end
		table.insert(v4, {
			async = true,
			thread = v5
		})
		return function() --[[ Line: 353 | Upvalues: cancelWait (ref), v4 (copy), v5 (copy) ]]
			cancelWait(v4, v5)
		end
	end,
	AwaitReplionFor = function(p1, p2, p3, p4, p5) --[[ AwaitReplionFor | Line: 369 | Upvalues: t2 (copy), t3 (copy), cancelWait (copy) ]]
		local v1 = p1:GetReplionFor(p2, p3)
		if v1 then
			return p4(v1)
		end
		local v2 = t2
		local v3 = v2[p3]
		if not v3 then
			v3 = {}
			v2[p3] = v3
		end
		local v4 = v3
		local v5 = coroutine.create(p4)
		if p5 then
			t3[v5] = task.delay(p5, cancelWait, v4, v5)
		end
		table.insert(v4, {
			async = true,
			thread = v5,
			player = p2
		})
		return function() --[[ Line: 384 | Upvalues: cancelWait (ref), v4 (copy), v5 (copy) ]]
			cancelWait(v4, v5)
		end
	end,
	OnReplionAdded = function(p1, p2) --[[ OnReplionAdded | Line: 396 | Upvalues: v1 (copy) ]]
		return v1:Connect(p2)
	end,
	OnReplionRemoved = function(p1, p2) --[[ OnReplionRemoved | Line: 407 | Upvalues: v2 (copy) ]]
		return v2:Connect(p2)
	end
}
if not Utils.ShouldMock and RunService:IsServer() then
	Network.create({ "Added", "Removed", "Update", "UpdateReplicateTo", "Set", "ArrayUpdate" })
	local function onPlayerAdded(p1) --[[ onPlayerAdded | Line: 422 | Upvalues: t4 (copy), Network (copy) ]]
		local t = {}
		for v1, v2 in t4:GetReplionsFor(p1) do
			table.insert(t, v2:_serialize())
		end
		if not (#t > 0) then
			return
		end
		Network.sendTo(p1, "Added", t)
	end
	for v3, v4 in Players:GetPlayers() do
		task.spawn(onPlayerAdded, v4)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 441 | Upvalues: t (copy), Freeze (copy), t2 (copy), Utils (copy), t3 (copy) ]]
		for v1, v2 in t do
			for v3, v4 in v2 do
				local ReplicateTo = v4.ReplicateTo
				if ReplicateTo ~= "All" then
					if type(ReplicateTo) == "table" then
						v4:SetReplicateTo((Freeze.List.removeValue(ReplicateTo, p1)))
						continue
					end
					if ReplicateTo == p1 then
						v4:Destroy()
					end
				end
			end
		end
		for v5, v6 in t2 do
			for i = #v6, 1, -1 do
				local v7 = v6[i]
				local thread = v7.thread
				if v7.player == p1 then
					if v7.async then
						Utils.safeCancelThread(thread)
					else
						task.spawn(thread)
					end
					t3[thread] = nil
					table.remove(v6, i)
				end
			end
		end
	end)
end
return t4