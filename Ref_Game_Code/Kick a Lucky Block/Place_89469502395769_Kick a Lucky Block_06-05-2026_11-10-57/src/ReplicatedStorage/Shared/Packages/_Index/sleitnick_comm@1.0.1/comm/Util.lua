-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local Option = require(script.Parent.Parent.Option)
local t = {
	IsServer = RunService:IsServer(),
	WaitForChildTimeout = 60,
	DefaultCommFolderName = "__comm__",
	None = newproxy()
}
function t.GetCommSubFolder(p1, p2) --[[ GetCommSubFolder | Line: 12 | Upvalues: t (copy), Option (copy) ]]
	local v1
	if t.IsServer then
		local v2 = p1:FindFirstChild(p2)
		if v2 then
			v1 = v2
		else
			local v3 = Instance.new("Folder")
			v3.Name = p2
			v3.Parent = p1
			v1 = v3
		end
	else
		v1 = p1:WaitForChild(p2, t.WaitForChildTimeout)
	end
	return Option.Wrap(v1)
end
return t