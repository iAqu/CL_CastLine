-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Base = require(script.Parent.Parent.Internal.Base)
local t = {}
t.__index = t
setmetatable(t, Base)
function t.new() --[[ new | Line: 12 | Upvalues: Base (copy), Players (copy), t (copy) ]]
	local v1 = Base.new("Radiant", script.Parent.Parent.Assets.Radiant, Players.LocalPlayer.Character, Vector3.new(-0, -5, -0))
	setmetatable(v1, t)
	return v1
end
return t