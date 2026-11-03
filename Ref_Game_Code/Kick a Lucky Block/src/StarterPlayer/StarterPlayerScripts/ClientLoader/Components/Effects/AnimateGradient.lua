-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIGradientController = require(ReplicatedStorage.Modules.ControllerLoader.UIGradientController)
require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	Tag = ({
		Tag = "AnimateGradient"
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 20 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Gradient = p1,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t._init(p1) --[[ _init | Line: 31 | Upvalues: UIGradientController (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		UIGradientController.Add(p1.Gradient)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 40 | Upvalues: UIGradientController (copy) ]]
	UIGradientController.Remove(p1.Gradient)
end
return t