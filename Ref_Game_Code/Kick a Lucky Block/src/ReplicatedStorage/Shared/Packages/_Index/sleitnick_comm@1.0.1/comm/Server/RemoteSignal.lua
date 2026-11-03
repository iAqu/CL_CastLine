-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Parent.Types)
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 27 | Upvalues: t (copy), Signal (copy) ]]
	local v2 = setmetatable({}, t)
	v2._re = if p3 == true then Instance.new("UnreliableRemoteEvent") else Instance.new("RemoteEvent")
	v2._re.Name = p2
	v2._re.Parent = p1
	if p5 and #p5 > 0 then
		v2._hasOutbound = true
		v2._outbound = p5
	else
		v2._hasOutbound = false
	end
	if p4 and #p4 > 0 then
		v2._directConnect = false
		v2._signal = Signal.new()
		v2._re.OnServerEvent:Connect(function(p1, ...) --[[ Line: 47 | Upvalues: p4 (copy), v2 (copy) ]]
			local v1 = table.pack(...)
			for v22, v3 in p4 do
				if not table.pack(v3(p1, v1))[1] then
					return
				end
				v1.n = #v1
			end
			v2._signal:Fire(p1, table.unpack(v1, 1, v1.n))
		end)
	else
		v2._directConnect = true
	end
	return v2
end
function t.IsUnreliable(p1) --[[ IsUnreliable | Line: 69 ]]
	return p1._re:IsA("UnreliableRemoteEvent")
end
function t.Connect(p1, p2) --[[ Connect | Line: 80 ]]
	if p1._directConnect then
		return p1._re.OnServerEvent:Connect(p2)
	else
		return p1._signal:Connect(p2)
	end
end
function t._processOutboundMiddleware(p1, p2, ...) --[[ _processOutboundMiddleware | Line: 88 ]]
	if p1._hasOutbound then
		local v1 = table.pack(...)
		for v2, v3 in p1._outbound do
			local v4 = table.pack(v3(p2, v1))
			if not v4[1] then
				return table.unpack(v4, 2, v4.n)
			end
			v1.n = #v1
		end
		return table.unpack(v1, 1, v1.n)
	else
		return ...
	end
end
function t.Fire(p1, p2, ...) --[[ Fire | Line: 113 ]]
	p1._re:FireClient(p2, p1:_processOutboundMiddleware(p2, ...))
end
function t.FireAll(p1, ...) --[[ FireAll | Line: 126 ]]
	p1._re:FireAllClients(p1:_processOutboundMiddleware(nil, ...))
end
function t.FireExcept(p1, p2, ...) --[[ FireExcept | Line: 141 ]]
	p1:FireFilter(function(p1) --[[ Line: 142 | Upvalues: p2 (copy) ]]
		return p1 ~= p2
	end, ...)
end
function t.FireFilter(p1, p2, ...) --[[ FireFilter | Line: 171 | Upvalues: Players (copy) ]]
	for v1, v2 in Players:GetPlayers() do
		if p2(v2, ...) then
			p1._re:FireClient(v2, p1:_processOutboundMiddleware(nil, ...))
		end
	end
end
function t.FireFor(p1, p2, ...) --[[ FireFor | Line: 195 ]]
	for v1, v2 in p2 do
		p1._re:FireClient(v2, p1:_processOutboundMiddleware(nil, ...))
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 204 ]]
	p1._re:Destroy()
	if p1._signal then
		p1._signal:Destroy()
	end
end
return t