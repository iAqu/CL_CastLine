-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Parent.Types)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 24 | Upvalues: t (copy), Signal (copy) ]]
	local v2 = setmetatable({}, t)
	v2._re = p1
	if p3 and #p3 > 0 then
		v2._hasOutbound = true
		v2._outbound = p3
	else
		v2._hasOutbound = false
	end
	if p2 and #p2 > 0 then
		v2._directConnect = false
		v2._signal = Signal.new()
		v2._reConn = v2._re.OnClientEvent:Connect(function(...) --[[ Line: 40 | Upvalues: p2 (copy), v2 (copy) ]]
			local v1 = table.pack(...)
			for v22, v3 in p2 do
				if not table.pack(v3(v1))[1] then
					return
				end
				v1.n = #v1
			end
			v2._signal:Fire(table.unpack(v1, 1, v1.n))
		end)
	else
		v2._directConnect = true
	end
	return v2
end
function t._processOutboundMiddleware(p1, ...) --[[ _processOutboundMiddleware | Line: 57 ]]
	local v1 = table.pack(...)
	for v2, v3 in p1._outbound do
		local v4 = table.pack(v3(v1))
		if not v4[1] then
			return table.unpack(v4, 2, v4.n)
		end
		v1.n = #v1
	end
	return table.unpack(v1, 1, v1.n)
end
function t.Connect(p1, p2) --[[ Connect | Line: 76 ]]
	if p1._directConnect then
		return p1._re.OnClientEvent:Connect(p2)
	else
		return p1._signal:Connect(p2)
	end
end
function t.Fire(p1, ...) --[[ Fire | Line: 92 ]]
	if p1._hasOutbound then
		p1._re:FireServer(p1:_processOutboundMiddleware(...))
	else
		p1._re:FireServer(...)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 103 ]]
	if p1._signal then
		p1._signal:Destroy()
	end
end
return t