-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent)
require(script.Parent.Parent.Types)
local Util = require(script.Parent.Parent.Util)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 46 | Upvalues: Util (copy), t (copy) ]]
	assert(not Util.IsServer, "ClientComm must be constructed from the client")
	assert(if typeof(p1) == "Instance" then true else false, "Parent must be of type Instance")
	local DefaultCommFolderName = Util.DefaultCommFolderName
	if p3 then
		DefaultCommFolderName = p3
	end
	local v3 = p1:WaitForChild(DefaultCommFolderName, Util.WaitForChildTimeout)
	assert(if v3 == nil then false else true, "Could not find namespace for ClientComm in parent: " .. DefaultCommFolderName)
	local v6 = setmetatable({}, t)
	v6._instancesFolder = v3
	v6._usePromise = p2
	return v6
end
function t.GetFunction(p1, p2, p3, p4) --[[ GetFunction | Line: 95 | Upvalues: v1 (copy) ]]
	return v1.GetFunction(p1._instancesFolder, p2, p1._usePromise, p3, p4)
end
function t.GetSignal(p1, p2, p3, p4) --[[ GetSignal | Line: 123 | Upvalues: v1 (copy) ]]
	return v1.GetSignal(p1._instancesFolder, p2, p3, p4)
end
function t.GetProperty(p1, p2, p3, p4) --[[ GetProperty | Line: 165 | Upvalues: v1 (copy) ]]
	return v1.GetProperty(p1._instancesFolder, p2, p3, p4)
end
function t.BuildObject(p1, p2, p3) --[[ BuildObject | Line: 192 ]]
	local t = {}
	local RF = p1._instancesFolder:FindFirstChild("RF")
	local RE = p1._instancesFolder:FindFirstChild("RE")
	local RP = p1._instancesFolder:FindFirstChild("RP")
	if RF then
		for v1, v2 in RF:GetChildren() do
			if v2:IsA("RemoteFunction") then
				local v3 = p1:GetFunction(v2.Name, p2, p3)
				t[v2.Name] = function(p1, ...) --[[ Line: 203 | Upvalues: v3 (copy) ]]
					return v3(...)
				end
			end
		end
	end
	if RE then
		for v4, v5 in RE:GetChildren() do
			if v5:IsA("RemoteEvent") or v5:IsA("UnreliableRemoteEvent") then
				t[v5.Name] = p1:GetSignal(v5.Name, p2, p3)
			end
		end
	end
	if RP then
		for v6, v7 in RP:GetChildren() do
			if v7:IsA("RemoteEvent") then
				t[v7.Name] = p1:GetProperty(v7.Name, p2, p3)
			end
		end
	end
	return t
end
function t.Destroy(p1) --[[ Destroy | Line: 230 ]] end
return t