-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local t = {}
local t2 = {
	Start = function(p1) --[[ Start | Line: 18 | Upvalues: CollectionService (copy), RunService (copy), CurrentCamera (copy), t (copy) ]]
		CollectionService:GetInstanceAddedSignal("Spinning"):Connect(AddDirectionalMover)
		CollectionService:GetInstanceRemovedSignal("Spinning"):Connect(RemoveDirectionalMover)
		for i, v in ipairs(CollectionService:GetTagged("Spinning")) do
			AddDirectionalMover(v)
		end
		RunService.Heartbeat:Connect(function(p1) --[[ Line: 25 | Upvalues: CurrentCamera (ref), t (ref) ]]
			local Position = CurrentCamera.CFrame.Position
			for i, v in ipairs(t) do
				local Mover = v.Mover
				if Mover then
					local v1 = Mover:GetPivot()
					if v1 and (v.RenderDistance >= 999 or (Position - v1.Position).Magnitude <= v.RenderDistance) then
						local ExactRotation = v.ExactRotation
						local v2 = v.Speed * p1
						Mover:PivotTo(v1 * CFrame.Angles(ExactRotation.X * v2, ExactRotation.Y * v2, ExactRotation.Z * v2))
					end
				end
			end
		end)
	end
}
function GetMoverInfo(p1) --[[ GetMoverInfo | Line: 50 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		if v.Mover == p1 then
			return i, v
		end
	end
end
function RemoveDirectionalMover(p1) --[[ RemoveDirectionalMover | Line: 58 | Upvalues: t (copy) ]]
	local v1, _ = GetMoverInfo(p1)
	if not v1 then
		return
	end
	table.remove(t, v1)
end
function AddDirectionalMover(p1) --[[ AddDirectionalMover | Line: 65 | Upvalues: t (copy) ]]
	local v1 = p1:FindFirstChild("RotationSpeed") and p1.RotationSpeed.Value or 0.1
	local v2 = p1:FindFirstChild("RenderDistance") and p1.RenderDistance.Value or 200
	local v3 = p1:FindFirstChild("Direction") and math.clamp(p1.Direction.Value, -1, 1) or 1
	table.insert(t, {
		ExactRotation = p1:FindFirstChild("ExactRotation") and p1.ExactRotation.Value or Vector3.new(0, 0, 1),
		RenderDistance = v2,
		Speed = 6.283185307179586 * v1 * v3,
		Mover = p1
	})
end
return t2