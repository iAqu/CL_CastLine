-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
return function(p1) --[[ Line: 14 | Upvalues: v1 (copy), RunService (copy), LocalPlayer (copy) ]]
	v1:Clean()
	if p1 then
		local v12 = v1:Clone(script.Arrow)
		v12.Parent = workspace.Debris
		v1:Add(RunService.PreRender:Connect(function() --[[ Line: 23 | Upvalues: LocalPlayer (ref), p1 (copy), v12 (copy) ]]
			if LocalPlayer.Character then
				local Position = LocalPlayer.Character:GetPivot().Position
				local v2 = p1.Position * Vector3.new(1, 0, 1) + Vector3.new(0, Position.Y, 0)
				v12:PivotTo((CFrame.new(Position + (v2 - Position).Unit * 6, v2)))
			end
		end))
	end
end