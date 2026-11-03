-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Types.Fishing)
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 16 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = p1
	v2.Destroyed = false
	return v2
end
function t.Play(p1) --[[ Play | Line: 25 ]] end
function t.Destroy(p1) --[[ Destroy | Line: 29 ]]
	if not p1.Destroyed then
		p1.Destroyed = true
		p1.Cleaner:Destroy()
	end
end
return t