-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local v1 = require(script.Parent)

require(script.Parent.Parent.Types)

local Util = require(script.Parent.Parent.Util)
local t = {}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 44 | Upvalues: Util (copy), t (copy) ]]
	assert(Util.IsServer, "ServerComm must be constructed from the server")
	assert(if typeof(p1) == "Instance" then true else false, "Parent must be of type Instance")

	local DefaultCommFolderName = Util.DefaultCommFolderName

	if p2 then
		DefaultCommFolderName = p2
	end

	assert(not p1:FindFirstChild(DefaultCommFolderName), "Parent already has another ServerComm bound to namespace " .. DefaultCommFolderName)

	local v4 = setmetatable({}, t)

	v4._instancesFolder = Instance.new("Folder")
	v4._instancesFolder.Name = DefaultCommFolderName
	v4._instancesFolder.Parent = p1

	return v4
end
function t.BindFunction(p1, p2, p3, p4, p5) --[[ BindFunction | Line: 76 | Upvalues: v1 (copy) ]]
	return v1.BindFunction(p1._instancesFolder, p2, p3, p4, p5)
end
function t.WrapMethod(p1, p2, p3, p4, p5) --[[ WrapMethod | Line: 108 | Upvalues: v1 (copy) ]]
	return v1.WrapMethod(p1._instancesFolder, p2, p3, p4, p5)
end
function t.CreateSignal(p1, p2, p3, p4, p5) --[[ CreateSignal | Line: 146 | Upvalues: v1 (copy) ]]
	return v1.CreateSignal(p1._instancesFolder, p2, p3, p4, p5)
end
function t.CreateProperty(p1, p2, p3, p4, p5) --[[ CreateProperty | Line: 195 | Upvalues: v1 (copy) ]]
	return v1.CreateProperty(p1._instancesFolder, p2, p3, p4, p5)
end
function t.Destroy(p1) --[[ Destroy | Line: 207 ]]
	p1._instancesFolder:Destroy()
end

return t