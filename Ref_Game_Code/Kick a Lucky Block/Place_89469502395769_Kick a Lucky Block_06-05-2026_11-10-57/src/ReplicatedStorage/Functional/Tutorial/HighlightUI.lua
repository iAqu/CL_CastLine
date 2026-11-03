-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
local LocalPlayer = game:GetService("Players").LocalPlayer
local ClickTarget = script:WaitForChild("ClickTarget")
local Container = ClickTarget.Container
local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false)
return function(p1) --[[ Line: 19 | Upvalues: v1 (copy), ClickTarget (copy), LocalPlayer (copy), Container (copy), TweenService (copy), v2 (copy) ]]
	v1:Clean()
	if p1 then
		if ClickTarget.Parent ~= LocalPlayer.PlayerGui then
			ClickTarget.Parent = LocalPlayer.PlayerGui
			ClickTarget.Enabled = true
			Container.Size = UDim2.fromScale(0.01, 0.01)
		end
		local function UpdatePosition() --[[ UpdatePosition | Line: 34 | Upvalues: p1 (copy), ClickTarget (ref), TweenService (ref), Container (ref), v2 (ref) ]]
			local AbsoluteSize = p1.AbsoluteSize
			local v1 = p1.AbsolutePosition + AbsoluteSize * 0.5 - ClickTarget.AbsolutePosition
			TweenService:Create(Container, v2, {
				Size = UDim2.fromOffset(AbsoluteSize.X * 1.15, AbsoluteSize.Y * 1.15),
				Position = UDim2.fromOffset(v1.X, v1.Y)
			}):Play()
		end
		UpdatePosition()
		v1:Add(p1:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdatePosition))
		v1:Add(ClickTarget:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdatePosition))
		v1:Add(p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdatePosition))
	else
		ClickTarget.Parent = script
		ClickTarget.Enabled = false
	end
end