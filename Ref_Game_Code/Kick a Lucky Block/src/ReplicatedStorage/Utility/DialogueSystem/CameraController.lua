-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local CurrentCamera = workspace.CurrentCamera
local v1 = nil
return {
	TweenCameraIn = function() --[[ TweenCameraIn | Line: 10 | Upvalues: v1 (ref), TweenService (copy), CurrentCamera (copy) ]]
		if v1 then
			v1:Cancel()
		end
		v1 = TweenService:Create(CurrentCamera, TweenInfo.new(0.4), {
			FieldOfView = 60
		})
		v1:Play()
	end,
	TweenCameraOut = function() --[[ TweenCameraOut | Line: 20 | Upvalues: v1 (ref), TweenService (copy), CurrentCamera (copy) ]]
		if v1 then
			v1:Cancel()
		end
		v1 = TweenService:Create(CurrentCamera, TweenInfo.new(0.2), {
			FieldOfView = 70
		})
		v1:Play()
	end
}