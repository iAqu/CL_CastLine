-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
local TweenAsync = require(ReplicatedStorage.Modules.TweenAsync)
local Firefly = require(script:WaitForChild("Firefly"))
local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local v1 = Random.new()
local t = {}
local t2 = {
	Start = function(p1) --[[ Start | Line: 39 | Upvalues: ClientTimeController (copy), t (copy), TweenAsync (copy), CurrentCamera (copy), Firefly (copy), LocalPlayer (copy), v1 (copy), RunService (copy) ]]
		task.wait(4)
		ClientTimeController.NightTimeChanged:Connect(function() --[[ Line: 42 | Upvalues: ClientTimeController (ref), t (ref), TweenAsync (ref) ]]
			if ClientTimeController.NightTime then
				return
			end
			for i, v in ipairs(t) do
				TweenAsync(v.firefly, TweenInfo.new(0.5), {
					Transparency = 1
				}):andThen(function() --[[ Line: 45 | Upvalues: v (copy) ]]
					v.firefly:Destroy()
				end)
			end
			table.clear(t)
		end)
		task.spawn(function() --[[ Line: 53 | Upvalues: ClientTimeController (ref), CurrentCamera (ref), t (ref), Firefly (ref), TweenAsync (ref), LocalPlayer (ref), v1 (ref) ]]
			while true do
				local v12
				repeat
					task.wait(1)
					v12 = ClientTimeController.NightTime
					local v2 = CurrentCamera.CFrame
					for i, v in ipairs(t) do
						if magnitude(v.firefly.Position - v2.Position) >= magnitude(Firefly.Offset) * 1.1 then
							TweenAsync(v.firefly, TweenInfo.new(0.5), {
								Transparency = 1
							}):andThen(function() --[[ Line: 61 | Upvalues: v (copy), t (ref), i (copy) ]]
								v.firefly:Destroy()
								table.remove(t, i)
							end)
						end
					end
				until not LocalPlayer:GetAttribute("Underwater") and (v12 and #t < Firefly.Count)
				local v3 = Firefly.Firefly:Clone()
				v3.CFrame = assignTargetCFrame()
				v3.Transparency = 1
				v3.Parent = Firefly.Container
				local v4 = assignTargetCFrame()
				local v5 = t
				table.insert(v5, {
					firefly = v3,
					duration = magnitude(v4.Position - v3.Position) / Firefly.Velocity,
					startCFrame = v3.CFrame,
					targetCFrame = v4,
					startTime = tick(),
					offsetX = v1:NextNumber(1, 7000),
					offsetY = v1:NextNumber(1, 7000)
				})
				TweenAsync(v3, TweenInfo.new(0.5), {
					Transparency = 0
				})
			end
		end)
		RunService:BindToRenderStep("UpdateFireflies", Enum.RenderPriority.Camera.Value - 1, updateFireflies)
	end
}
function magnitude(p1) --[[ magnitude | Line: 106 ]]
	local X = p1.X
	local Y = p1.Y
	local Z = p1.Z
	return (X * X + Y * Y + Z * Z) ^ 0.5
end
function assignTargetCFrame() --[[ assignTargetCFrame | Line: 115 | Upvalues: Firefly (copy), CurrentCamera (copy), v1 (copy) ]]
	local Offset = Firefly.Offset
	return CFrame.new(CurrentCamera.CFrame.Position) * CFrame.new(v1:NextInteger(-Offset.X / 2, Offset.X / 2), v1:NextInteger(-Offset.Y / 2, Offset.Y / 2), v1:NextInteger(-Offset.Z / 2, Offset.Z / 2))
end
function updateFireflies(p1, p2) --[[ updateFireflies | Line: 124 | Upvalues: t (copy), Firefly (copy) ]]
	local v1 = tick()
	for i, v in ipairs(t) do
		local v2 = (v1 - v.startTime) / v.duration
		local v3 = v.startCFrame:Lerp(v.targetCFrame, v2)
		v.firefly.CFrame = v3 + Vector3.new(0, math.sin(v1 - v.offsetY), 0.5)
		if v2 >= 1 then
			local v6 = assignTargetCFrame()
			v.duration = magnitude(v6.Position - v.firefly.Position) / Firefly.Velocity
			v.startCFrame = v.firefly.CFrame
			v.targetCFrame = v6
			v.startTime = tick()
		end
	end
end
return t2