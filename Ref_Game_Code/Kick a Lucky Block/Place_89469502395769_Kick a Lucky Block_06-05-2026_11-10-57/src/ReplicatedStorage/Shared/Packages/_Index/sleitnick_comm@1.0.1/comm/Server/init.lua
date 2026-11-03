-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RemoteProperty = require(script.RemoteProperty)
local RemoteSignal = require(script.RemoteSignal)
require(script.Parent.Types)
local Util = require(script.Parent.Util)
local t = {
	BindFunction = function(p1, p2, p3, p4, p5) --[[ BindFunction | Line: 37 | Upvalues: Util (copy) ]]
		assert(Util.IsServer, "BindFunction must be called from the server")
		local v1 = Util.GetCommSubFolder(p1, "RF"):Expect("Failed to get Comm RF folder")
		local v2 = Instance.new("RemoteFunction")
		v2.Name = p2
		local v3 = if type(p4) == "table" then if #p4 > 0 then true else false else false
		local v4 = if type(p5) == "table" then if #p5 > 0 then true else false else false
		local function ProcessOutbound(p1, ...) --[[ ProcessOutbound | Line: 50 | Upvalues: p5 (copy) ]]
			local v1 = table.pack(...)
			for i, v in ipairs(p5) do
				local v2 = table.pack(v(p1, v1))
				if not v2[1] then
					return table.unpack(v2, 2, v2.n)
				end
				v1.n = #v1
			end
			return table.unpack(v1, 1, v1.n)
		end
		if v3 and v4 then
			function v2.OnServerInvoke(p1, ...) --[[ OnServerInvoke | Line: 62 | Upvalues: p4 (copy), ProcessOutbound (copy), p3 (copy) ]]
				local v1 = table.pack(...)
				for i, v in ipairs(p4) do
					local v2 = table.pack(v(p1, v1))
					if not v2[1] then
						return table.unpack(v2, 2, v2.n)
					end
					v1.n = #v1
				end
				return ProcessOutbound(p1, p3(p1, table.unpack(v1, 1, v1.n)))
			end
		elseif v3 then
			function v2.OnServerInvoke(p1, ...) --[[ OnServerInvoke | Line: 75 | Upvalues: p4 (copy), p3 (copy) ]]
				local v1 = table.pack(...)
				for i, v in ipairs(p4) do
					local v2 = table.pack(v(p1, v1))
					if not v2[1] then
						return table.unpack(v2, 2, v2.n)
					end
					v1.n = #v1
				end
				return p3(p1, table.unpack(v1, 1, v1.n))
			end
		elseif v4 then
			function v2.OnServerInvoke(p1, ...) --[[ OnServerInvoke | Line: 88 | Upvalues: ProcessOutbound (copy), p3 (copy) ]]
				return ProcessOutbound(p1, p3(p1, ...))
			end
		else
			v2.OnServerInvoke = p3
		end
		v2.Parent = v1
		return v2
	end
}
function t.WrapMethod(p1, p2, p3, p4, p5) --[[ WrapMethod | Line: 99 | Upvalues: Util (copy), t (copy) ]]
	assert(Util.IsServer, "WrapMethod must be called from the server")
	local v1 = p2[p3]
	local v2 = if type(v1) == "function" then true else false
	assert(v2, "Value at index " .. p3 .. " must be a function; got " .. type(v1))
	return t.BindFunction(p1, p3, function(...) --[[ Line: 109 | Upvalues: v1 (copy), p2 (copy) ]]
		return v1(p2, ...)
	end, p4, p5)
end
function t.CreateSignal(p1, p2, p3, p4, p5) --[[ CreateSignal | Line: 114 | Upvalues: Util (copy), RemoteSignal (copy) ]]
	assert(Util.IsServer, "CreateSignal must be called from the server")
	return RemoteSignal.new(Util.GetCommSubFolder(p1, "RE"):Expect("Failed to get Comm RE folder"), p2, p3, p4, p5)
end
function t.CreateProperty(p1, p2, p3, p4, p5) --[[ CreateProperty | Line: 127 | Upvalues: Util (copy), RemoteProperty (copy) ]]
	assert(Util.IsServer, "CreateProperty must be called from the server")
	return RemoteProperty.new(Util.GetCommSubFolder(p1, "RP"):Expect("Failed to get Comm RP folder"), p2, p3, p4, p5)
end
return t