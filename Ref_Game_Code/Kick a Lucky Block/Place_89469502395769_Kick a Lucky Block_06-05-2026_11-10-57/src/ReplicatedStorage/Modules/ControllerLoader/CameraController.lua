-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CurrentCamera = workspace.CurrentCamera
return {
	GetDistanceFromObject = function(p1, p2, p3) --[[ GetDistanceFromObject | Line: 11 | Upvalues: CurrentCamera (copy) ]]
		if p2 then
			assert(if typeof(p2) == "Instance" then true else false, "Provided object is not an instance.")
			local v2 = nil
			if p2:IsA("Model") then
				v2 = select(2, p2:GetBoundingBox())
			elseif p2:IsA("BasePart") then
				v2 = p2.Size
			end
			if v2 then
				local v4 = v2 / p3
				local v6 = math.rad(CurrentCamera.FieldOfView / 2)
				local v9 = math.atan(math.tan(v6) * (CurrentCamera.ViewportSize.X / CurrentCamera.ViewportSize.Y))
				return math.max(v4.Y / 2 / math.tan(v6), v4.X / 2 / math.tan(v9)) + v4.Z / 2
			end
		end
	end,
	LerpToSubject = function(p1, p2, p3) --[[ LerpToSubject | Line: 47 | Upvalues: CurrentCamera (copy), RunService (copy), TweenService (copy) ]]
		if p2:IsA("BasePart") then
			local Magnitude = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude
			CFrame.new(0, 0, Magnitude)
			local v1 = CurrentCamera.CFrame
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local v2 = 0
			local v3 = nil
			v3 = RunService.PreRender:Connect(function(p1) --[[ Line: 64 | Upvalues: v2 (ref), p2 (copy), p3 (copy), Magnitude (copy), TweenService (ref), CurrentCamera (ref), v1 (copy), v3 (ref) ]]
				v2 = v2 + p1
				local v22 = CFrame.lookAt(p2.Position + p3 * Magnitude, p2.Position)
				local v4 = math.clamp(v2 / 0.4, 0, 1)
				CurrentCamera.CFrame = v1:Lerp(v22, (TweenService:GetValue(v4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)))
				if v4 == 1 then
					CurrentCamera.CameraType = Enum.CameraType.Custom
					CurrentCamera.CameraSubject = p2
					v3:Disconnect()
				end
			end)
			return v3
		else
			warn("Only base part for now.")
		end
	end
}