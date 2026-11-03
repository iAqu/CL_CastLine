-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local clock = os.clock
function DiscretePulse(p1, p2, p3, p4, p5, p6, p7) --[[ DiscretePulse | Line: 11 ]]
	return math.clamp(p3 / (2 * p4) - math.abs((p1 - p5 * p2 + 0.5 * p3) / p4), p6, p7)
end
function NoiseBetween(p1, p2, p3, p4, p5) --[[ NoiseBetween | Line: 15 ]]
	return p4 + (p5 - p4) * (math.noise(p1, p2, p3) + 0.5)
end
function CubicBezier(p1, p2, p3, p4, p5) --[[ CubicBezier | Line: 19 ]]
	return p1 * (1 - p5) ^ 3 + p2 * 3 * p5 * (1 - p5) ^ 2 + p3 * 3 * (1 - p5) * p5 ^ 2 + p4 * p5 ^ 3
end
local BoltPart = Instance.new("Part")
BoltPart.TopSurface = 0
BoltPart.BottomSurface = 0
BoltPart.Anchored = true
BoltPart.CanCollide = false
BoltPart.Shape = "Cylinder"
BoltPart.Name = "BoltPart"
BoltPart.Material = Enum.Material.Neon
BoltPart.Color = Color3.new(255/255, 255/255, 255/255)
BoltPart.Transparency = 1
Random.new()
local v1 = CFrame.lookAt(Vector3.new(), Vector3.new(1, 0, 0)):Inverse()
local t = {}
local t2 = {}
t2.__index = t2
function t2.new(p1, p2, p3) --[[ new | Line: 48 | Upvalues: t2 (copy), BoltPart (copy), v1 (copy), clock (copy), t (copy) ]]
	local v2 = setmetatable({}, t2)
	v2.Enabled = true
	v2.Attachment0 = p1
	v2.Attachment1 = p2
	v2.CurveSize0 = 0
	v2.CurveSize1 = 0
	v2.MinRadius = 0
	v2.MaxRadius = 2.4
	v2.Frequency = 1
	v2.AnimationSpeed = 7
	v2.Thickness = 1
	v2.MinThicknessMultiplier = 0.2
	v2.MaxThicknessMultiplier = 1
	v2.MinTransparency = 0
	v2.MaxTransparency = 1
	v2.PulseSpeed = 2
	v2.PulseLength = 1000000
	v2.FadeLength = 0.2
	v2.ContractFrom = 0.5
	v2.Color = Color3.new(255/255, 255/255, 255/255)
	v2.ColorOffsetSpeed = 3
	v2.Parts = {}
	local VFX = workspace:WaitForChild("VFX")
	local WorldPosition = p1.WorldPosition
	local v3 = p1.WorldPosition + p1.WorldAxis * v2.CurveSize0
	local v4 = p2.WorldPosition - p2.WorldAxis * v2.CurveSize1
	local WorldPosition_2 = p2.WorldPosition
	local v5 = p3 or 30
	local v6, v7 = WorldPosition, WorldPosition
	for i = 1, v5 do
		local v8 = CubicBezier(WorldPosition, v3, v4, WorldPosition_2, i / v5)
		local v9 = i ~= v5 and CFrame.lookAt(v6, v8).Position or v8
		local v10 = BoltPart:Clone()
		v10.Size = Vector3.new((v9 - v7).Magnitude, 0, 0)
		v10.CFrame = CFrame.lookAt(0.5 * (v7 + v9), v9) * v1
		v10.Parent = VFX
		v10.Locked = true
		v10.CastShadow = false
		v2.Parts[i] = v10
		v6, v7 = v8, v9
	end
	v2.PartsHidden = false
	v2.DisabledTransparency = 1
	v2.StartT = clock()
	v2.RanNum = math.random() * 100
	v2.RefIndex = #t + 1
	t[v2.RefIndex] = v2
	return v2
end
function t2.Destroy(p1) --[[ Destroy | Line: 113 | Upvalues: t (copy) ]]
	t[p1.RefIndex] = nil
	for i = 1, #p1.Parts do
		p1.Parts[i]:Destroy()
		if i % 100 == 0 then
			wait()
		end
	end
end
game:GetService("RunService").Heartbeat:Connect(function() --[[ Line: 127 | Upvalues: t (copy), clock (copy), v1 (copy) ]]
	for k, v in pairs(t) do
		if v.Enabled == true then
			v.PartsHidden = false
			local v12 = 1 - v.MaxTransparency
			local v2 = 1 - v.MinTransparency
			local MinRadius = v.MinRadius
			local MaxRadius = v.MaxRadius
			local Thickness = v.Thickness
			local Parts = v.Parts
			local v3 = #Parts
			local RanNum = v.RanNum
			local AnimationSpeed = v.AnimationSpeed
			local Frequency = v.Frequency
			local MinThicknessMultiplier = v.MinThicknessMultiplier
			local MaxThicknessMultiplier = v.MaxThicknessMultiplier
			local Attachment0 = v.Attachment0
			local Attachment1 = v.Attachment1
			local WorldPosition = Attachment0.WorldPosition
			local v4 = Attachment0.WorldPosition + Attachment0.WorldAxis * v.CurveSize0
			local v5 = Attachment1.WorldPosition - Attachment1.WorldAxis * v.CurveSize1
			local WorldPosition_2 = Attachment1.WorldPosition
			local v6 = clock() - v.StartT
			local PulseLength = v.PulseLength
			local PulseSpeed = v.PulseSpeed
			local FadeLength = v.FadeLength
			local Color = v.Color
			local ColorOffsetSpeed = v.ColorOffsetSpeed
			local v7 = 1 - v.ContractFrom
			if v6 < (PulseLength + 1) / PulseSpeed then
				v8 = WorldPosition
				v9 = WorldPosition
				for i = 1, v3 do
					local v10
					local v11 = Parts[i]
					local v122 = i / v3
					local v13 = DiscretePulse(v122, PulseSpeed, PulseLength, FadeLength, v6, v12, v2)
					local v14 = CubicBezier(WorldPosition, v4, v5, WorldPosition_2, v122)
					local v15 = -v6
					local v16 = AnimationSpeed * v15 + Frequency * 10 * v122 - 0.2 + RanNum * 4
					local v17 = 5 * (AnimationSpeed * 0.01 * v15 / 10 + Frequency * v122) + RanNum * 4
					local v18 = NoiseBetween(5 * v16, 1.5, 1 * v17, 0, 0.6283185307179586) + NoiseBetween(0.5 * v16, 1.5, 0.1 * v17, 0, 5.654866776461628)
					local v19 = NoiseBetween(3.4, v17, v16, MinRadius, MaxRadius) * math.exp((v122 - 0.5) ^ 10 * -5000)
					local v20 = NoiseBetween(2.3, v17, v16, MinThicknessMultiplier, MaxThicknessMultiplier)
					if i == v3 then
						v10 = v14
					else
						local v21 = CFrame.new(v8, v14) * CFrame.Angles(0, 0, v18)
						local Angles = CFrame.Angles
						local v23 = math.clamp(NoiseBetween(v17, v16, 2.7, 6.123233995736766e-17, 1), -1, 1)
						v10 = (v21 * Angles(math.acos(v23), 0, 0) * CFrame.new(0, 0, -v19)).Position or v14
					end
					if v7 < v13 then
						v11.Size = Vector3.new((v10 - v9).Magnitude, Thickness * v20 * v13, Thickness * v20 * v13)
						v11.CFrame = CFrame.lookAt(0.5 * (v9 + v10), v10) * v1
						v11.Transparency = 1 - v13
					elseif v7 - 1 / (v3 * FadeLength) < v13 then
						local v26 = (1 - (v13 - (v7 - 1 / (v3 * FadeLength))) * v3 * FadeLength) * (if v122 < v6 * PulseSpeed - 0.5 * PulseLength then 1 else -1)
						v11.Size = Vector3.new((1 - math.abs(v26)) * (v10 - v9).Magnitude, Thickness * v20 * v13, Thickness * v20 * v13)
						v11.CFrame = CFrame.lookAt(v9 + (v10 - v9) * (math.max(0, v26) + (1 - math.abs(v26)) * 0.5), v10) * v1
						v11.Transparency = 1 - v13
					else
						v11.Transparency = 1
					end
					if typeof(Color) == "Color3" then
						v11.Color = Color
					else
						local Keypoints = Color.Keypoints
						local v28 = (RanNum + v122 - v6 * ColorOffsetSpeed) % 1
						for j = 1, #Keypoints - 1 do
							if Keypoints[j].Time < v28 and v28 < Keypoints[j + 1].Time then
								v11.Color = Keypoints[j].Value:lerp(Keypoints[j + 1].Value, (v28 - Keypoints[j].Time) / (Keypoints[j + 1].Time - Keypoints[j].Time))
								break
							end
						end
					end
					v8, v9 = v14, v10
				end
				continue
			end
			v:Destroy()
			continue
		end
		if v.PartsHidden == false then
			v.PartsHidden = true
			local DisabledTransparency = v.DisabledTransparency
			for k2 = 1, #v.Parts do
				v.Parts[k2].Transparency = DisabledTransparency
			end
		end
	end
end)
return t2