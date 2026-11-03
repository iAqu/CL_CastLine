-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local GUI_Effects = PlayerGui:WaitForChild("GUI_Effects", 5)
if GUI_Effects then
	return function(p1, p2) --[[ Line: 18 | Upvalues: GUI_Effects (copy), TweenService (copy), CurrentCamera (copy) ]]
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.fromScale(1, 1)
		Frame.BackgroundTransparency = 0
		Frame.BackgroundColor3 = if p1 then p1 else Color3.fromRGB(255, 255, 255)
		Frame.Parent = GUI_Effects
		local v2 = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		v2.Completed:Once(function() --[[ Line: 26 | Upvalues: Frame (copy) ]]
			Frame:Destroy()
		end)
		if p2 then
			local v3 = TweenService:Create(CurrentCamera, TweenInfo.new(0.25), {
				FieldOfView = 100
			})
			local v4 = TweenService:Create(CurrentCamera, TweenInfo.new(1), {
				FieldOfView = 70
			})
			v3.Completed:Once(function() --[[ Line: 34 | Upvalues: v4 (copy) ]]
				v4:Play()
			end)
			v3:Play()
		end
		v2:Play()
	end
else
	warn("NO GUI_EFFECTS FOUND.")
end