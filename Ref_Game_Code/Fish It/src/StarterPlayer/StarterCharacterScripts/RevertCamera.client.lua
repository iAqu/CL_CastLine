-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local CurrentCamera = workspace.CurrentCamera
function updateCamera() --[[ updateCamera | Line: 6 | Upvalues: Humanoid (copy), CurrentCamera (copy) ]]
	if not Humanoid.SeatPart or CurrentCamera.CameraType ~= Enum.CameraType.Custom then
		return
	end
	CurrentCamera.CameraType = Enum.CameraType.Track
end
Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(updateCamera)
CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(updateCamera)
updateCamera()