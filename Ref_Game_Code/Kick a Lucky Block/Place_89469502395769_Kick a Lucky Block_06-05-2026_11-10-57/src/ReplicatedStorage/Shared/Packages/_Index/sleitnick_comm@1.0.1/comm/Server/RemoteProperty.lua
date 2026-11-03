-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RemoteSignal = require(script.Parent.RemoteSignal)
require(script.Parent.Parent.Types)
local None = require(script.Parent.Parent.Util).None
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 53 | Upvalues: t (copy), RemoteSignal (copy), Players (copy), None (copy) ]]
	local v2 = setmetatable({}, t)
	v2._rs = RemoteSignal.new(p1, p2, false, p4, p5)
	v2._value = p3
	v2._perPlayer = {}
	v2._playerRemoving = Players.PlayerRemoving:Connect(function(p1) --[[ Line: 64 | Upvalues: v2 (copy) ]]
		v2._perPlayer[p1] = nil
	end)
	v2._rs:Connect(function(p1) --[[ Line: 67 | Upvalues: v2 (copy), None (ref) ]]
		local v1 = v2._perPlayer[p1]
		v2._rs:Fire(p1, if v1 == nil then v2._value elseif v1 == None then nil else v1)
	end)
	return v2
end
function t.Set(p1, p2) --[[ Set | Line: 91 ]]
	p1._value = p2
	table.clear(p1._perPlayer)
	p1._rs:FireAll(p2)
end
function t.SetTop(p1, p2) --[[ SetTop | Line: 118 | Upvalues: Players (copy) ]]
	p1._value = p2
	for i, v in ipairs(Players:GetPlayers()) do
		if p1._perPlayer[v] == nil then
			p1._rs:Fire(v, p2)
		end
	end
end
function t.SetFilter(p1, p2, p3) --[[ SetFilter | Line: 141 | Upvalues: Players (copy) ]]
	for i, v in ipairs(Players:GetPlayers()) do
		if p2(v, p3) then
			p1:SetFor(v, p3)
		end
	end
end
function t.SetFor(p1, p2, p3) --[[ SetFor | Line: 163 | Upvalues: None (copy) ]]
	if p2.Parent then
		p1._perPlayer[p2] = if p3 == nil then None else p3
	end
	p1._rs:Fire(p2, p3)
end
function t.SetForList(p1, p2, p3) --[[ SetForList | Line: 179 ]]
	for i, v in ipairs(p2) do
		p1:SetFor(v, p3)
	end
end
function t.ClearFor(p1, p2) --[[ ClearFor | Line: 206 ]]
	if p1._perPlayer[p2] ~= nil then
		p1._perPlayer[p2] = nil
		p1._rs:Fire(p2, p1._value)
	end
end
function t.ClearForList(p1, p2) --[[ ClearForList | Line: 219 ]]
	for i, v in ipairs(p2) do
		p1:ClearFor(v)
	end
end
function t.ClearFilter(p1, p2) --[[ ClearFilter | Line: 229 | Upvalues: Players (copy) ]]
	for i, v in ipairs(Players:GetPlayers()) do
		if p2(v) then
			p1:ClearFor(v)
		end
	end
end
function t.Get(p1) --[[ Get | Line: 247 ]]
	return p1._value
end
function t.GetFor(p1, p2) --[[ GetFor | Line: 281 | Upvalues: None (copy) ]]
	local v1 = p1._perPlayer[p2]
	if v1 == nil then
		return p1._value
	elseif v1 == None then
		return nil
	else
		return v1
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 290 ]]
	p1._rs:Destroy()
	p1._playerRemoving:Disconnect()
end
return t