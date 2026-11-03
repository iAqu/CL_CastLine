-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local v1 = require("./PlotHitboxController")
return {
	LoadIcon = function(p1, p2) --[[ LoadIcon | Line: 11 | Upvalues: ReplicatedStorage (copy), TweenService (copy), v1 (copy) ]]
		local v12 = ReplicatedStorage.Objects.GUI.HomeIcon:Clone()
		v12:WaitForChild("ImageLabel")
		v12.Parent = p2.SpawnPart
		local function UpdateIcon(p1) --[[ UpdateIcon | Line: 16 | Upvalues: TweenService (ref), v12 (copy) ]]
			if p1 then
				TweenService:Create(v12.ImageLabel, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0, 0)
				}):Play()
			else
				TweenService:Create(v12.ImageLabel, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(1, 1)
				}):Play()
			end
		end
		UpdateIcon(v1.IsInPlot)
		v1.PlayerInPlot:Connect(UpdateIcon)
	end
}