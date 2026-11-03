-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local GUI_Effects = PlayerGui:WaitForChild("GUI_Effects", 5)
if GUI_Effects then
	local CurrentCamera_2 = workspace.CurrentCamera
	return function(p1, p2) --[[ Line: 21 | Upvalues: GUI_Effects (copy), TweenService (copy), CurrentCamera_2 (copy) ]]
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.fromScale(1, 1)
		Frame.BackgroundTransparency = 1
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.ZIndex = 99999
		Frame.Parent = GUI_Effects
		if p2 and typeof(p2) == "Color3" then
			Frame.BackgroundColor3 = p2
		end
		local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0)
		local v2 = TweenService:Create(Frame, v1, {
			BackgroundTransparency = 0
		})
		local v3 = TweenService:Create(Frame, v1, {
			BackgroundTransparency = 1
		})
		v2:Play()
		TweenService:Create(CurrentCamera_2, v1, {
			FieldOfView = 120
		}):Play()
		v2.Completed:Once(function() --[[ Line: 39 | Upvalues: p1 (copy), v3 (copy), TweenService (ref), CurrentCamera_2 (ref), v1 (copy), Frame (copy) ]]
			task.wait(p1)
			v3:Play()
			TweenService:Create(CurrentCamera_2, v1, {
				FieldOfView = 70
			}):Play()
			v3.Completed:Once(function() --[[ Line: 43 | Upvalues: Frame (ref) ]]
				Frame:Destroy()
			end)
		end)
	end
else
	warn("NO GUI_EFFECTS FOUND.")
end