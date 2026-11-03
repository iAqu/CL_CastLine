-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ZoneController = require(ReplicatedStorage.Modules.ControllerLoader.ZoneController)
local t = {}
local v1 = 0
function OnPreRender() --[[ OnPreRender | Line: 17 | Upvalues: v1 (ref), ZoneController (copy) ]]
	local v12 = tick()
	if v12 - v1 > 0.1 then
		v1 = v12
		ZoneController:UpdateZone()
	end
end
function t._init(p1) --[[ _init | Line: 27 | Upvalues: RunService (copy) ]]
	RunService.PreRender:Connect(OnPreRender)
end
return t