-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Util = require(script.Parent.Util)
require(script.Parent.Types)
local Promise = require(script.Parent.Parent.Promise)
local ClientRemoteSignal = require(script.ClientRemoteSignal)
local ClientRemoteProperty = require(script.ClientRemoteProperty)
return {
	GetFunction = function(p1, p2, p3, p4, p5) --[[ GetFunction | Line: 9 | Upvalues: Util (copy), Promise (copy) ]]
		assert(not Util.IsServer, "GetFunction must be called from the client")
		local v2 = Util.GetCommSubFolder(p1, "RF"):Expect("Failed to get Comm RF folder"):WaitForChild(p2, Util.WaitForChildTimeout)
		assert(if v2 == nil then false else true, "Failed to find RemoteFunction: " .. p2)
		local v4 = if type(p4) == "table" then if #p4 > 0 then true else false else false
		local v5 = if type(p5) == "table" then if #p5 > 0 then true else false else false
		local function ProcessOutbound(p1) --[[ ProcessOutbound | Line: 22 | Upvalues: p5 (copy) ]]
			for i, v in ipairs(p5) do
				local v1 = table.pack(v(p1))
				if not v1[1] then
					return table.unpack(v1, 2, v1.n)
				end
				p1.n = #p1
			end
			return table.unpack(p1, 1, p1.n)
		end
		if v4 then
			if p3 then
				return function(...) --[[ Line: 34 | Upvalues: Promise (ref), v5 (copy), v2 (copy), ProcessOutbound (copy), p4 (copy) ]]
					local v1 = table.pack(...)
					return Promise.new(function(p1, p2) --[[ Line: 36 | Upvalues: v5 (ref), v2 (ref), ProcessOutbound (ref), v1 (copy), p4 (ref) ]]
						local v12, v22 = pcall(function() --[[ Line: 37 | Upvalues: v5 (ref), v2 (ref), ProcessOutbound (ref), v1 (ref) ]]
							if v5 then
								return table.pack(v2:InvokeServer(ProcessOutbound(v1)))
							else
								return table.pack(v2:InvokeServer(table.unpack(v1, 1, v1.n)))
							end
						end)
						if v12 then
							for i, v in ipairs(p4) do
								local v3 = table.pack(v(v22))
								if not v3[1] then
									return table.unpack(v3, 2, v3.n)
								end
								v22.n = #v22
							end
							p1(table.unpack(v22, 1, v22.n))
						else
							p2(v22)
						end
					end)
				end
			else
				return function(...) --[[ Line: 59 | Upvalues: v5 (copy), v2 (copy), ProcessOutbound (copy), p4 (copy) ]]
					local v1 = if v5 then table.pack(v2:InvokeServer(ProcessOutbound(table.pack(...)))) else table.pack(v2:InvokeServer(...))
					for i, v in ipairs(p4) do
						local v4 = table.pack(v(v1))
						if not v4[1] then
							return table.unpack(v4, 2, v4.n)
						end
						v1.n = #v1
					end
					return table.unpack(v1, 1, v1.n)
				end
			end
		elseif p3 then
			return function(...) --[[ Line: 78 | Upvalues: Promise (ref), v5 (copy), v2 (copy), ProcessOutbound (copy) ]]
				local v1 = table.pack(...)
				return Promise.new(function(p1, p2) --[[ Line: 80 | Upvalues: v5 (ref), v2 (ref), ProcessOutbound (ref), v1 (copy) ]]
					local v12, v22 = pcall(function() --[[ Line: 81 | Upvalues: v5 (ref), v2 (ref), ProcessOutbound (ref), v1 (ref) ]]
						if v5 then
							return table.pack(v2:InvokeServer(ProcessOutbound(v1)))
						else
							return table.pack(v2:InvokeServer(table.unpack(v1, 1, v1.n)))
						end
					end)
					if v12 then
						p1(table.unpack(v22, 1, v22.n))
					else
						p2(v22)
					end
				end)
			end
		elseif v5 then
			return function(...) --[[ Line: 97 | Upvalues: v2 (copy), ProcessOutbound (copy) ]]
				return v2:InvokeServer(ProcessOutbound(table.pack(...)))
			end
		else
			return function(...) --[[ Line: 101 | Upvalues: v2 (copy) ]]
				return v2:InvokeServer(...)
			end
		end
	end,
	GetSignal = function(p1, p2, p3, p4) --[[ GetSignal | Line: 109 | Upvalues: Util (copy), ClientRemoteSignal (copy) ]]
		assert(not Util.IsServer, "GetSignal must be called from the client")
		local v2 = Util.GetCommSubFolder(p1, "RE"):Expect("Failed to get Comm RE folder"):WaitForChild(p2, Util.WaitForChildTimeout)
		assert(if v2 == nil then false else true, "Failed to find RemoteEvent: " .. p2)
		return ClientRemoteSignal.new(v2, p3, p4)
	end,
	GetProperty = function(p1, p2, p3, p4) --[[ GetProperty | Line: 122 | Upvalues: Util (copy), ClientRemoteProperty (copy) ]]
		assert(not Util.IsServer, "GetProperty must be called from the client")
		local v2 = Util.GetCommSubFolder(p1, "RP"):Expect("Failed to get Comm RP folder"):WaitForChild(p2, Util.WaitForChildTimeout)
		assert(if v2 == nil then false else true, "Failed to find RemoteEvent for RemoteProperty: " .. p2)
		return ClientRemoteProperty.new(v2, p3, p4)
	end
}