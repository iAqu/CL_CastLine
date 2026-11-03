-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("Lighting")
game:GetService("SoundService")
game:GetService("RunService")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local EnvironmentController = require(ReplicatedStorage.Modules.ControllerLoader.EnvironmentController)
local v1 = Trove.new()
local t = {
	Active = false,
	Info = {
		Description = "10% chance to transform lucky block into a <font color =\"#af10ff\">Virus</font> lucky block!",
		Image = "rbxassetid://119973872961637"
	}
}
function Initialize(p1, p2) --[[ Initialize | Line: 31 | Upvalues: v1 (copy), VFXService (copy), EnvironmentController (copy) ]]
	v1:Add(ReturnToDefault)
	if p2 then
		VFXService.PlayVFX("HackGlitch", 3, 2)
		task.delay(2.5, function() --[[ Line: 36 | Upvalues: EnvironmentController (ref) ]]
			EnvironmentController:ChangeEnvironment("Virus")
		end)
	else
		EnvironmentController:ChangeEnvironment("Virus")
	end
	script["Void Ambience"]:Play()
end
function ReturnToDefault() --[[ ReturnToDefault | Line: 46 | Upvalues: EnvironmentController (copy), VFXService (copy) ]]
	script["Void Ambience"]:Stop()
	if EnvironmentController.Environment == "Virus" then
		VFXService.PlayVFX("Whitescreen", 2)
		task.delay(1, function() --[[ Line: 51 | Upvalues: EnvironmentController (ref) ]]
			EnvironmentController:Reset()
		end)
	end
end
function t.Initialize(p1, p2, p3) --[[ Initialize | Line: 58 ]]
	if not p1.Active then
		p1.Active = true
		Initialize(p2, p3)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 66 | Upvalues: v1 (copy) ]]
	if p1.Active then
		v1:Clean()
		p1.Active = false
	end
end
return t