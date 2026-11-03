-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local v1 = Random.new()
local v2 = RaycastParams.new()
v2.FilterType = Enum.RaycastFilterType.Include
return function(p1, p2, p3, p4, p5) --[[ Line: 14 | Upvalues: v2 (copy), CollectionService (copy), Tags (copy), v1 (copy), TweenService (copy) ]]
	v2.FilterDescendantsInstances = CollectionService:GetTagged(Tags.FloorPart)
	local v12 = workspace:Raycast(p1 + Vector3.new(0, 5, 0), Vector3.new(0, -15, 0), v2)
	local v22 = Color3.fromRGB(108, 59, 19)
	if v12 then
		local v3, v4, _ = v12.Instance.Color:ToHSV()
		local v5 = Color3.fromHSV(v3, v4, 0.8)
		p1 = v12.Position
		v22 = v5
	end
	for i = 1, 10 do
		local v6 = v1:NextNumber(-2, 2)
		local v7 = v1:NextNumber(0, 0.75)
		local v8 = v1
		local v9 = Vector3.new(v6, v7, v8:NextNumber(0, 1))
		local v10 = math.cos(0.6283185307179586 * i) * p2
		local v11 = math.sin(0.6283185307179586 * i) * p2
		local v122 = script.Part:Clone()
		local v13 = CFrame.new(p1 + Vector3.new(v10, 0, v11), p1)
		local Angles = CFrame.Angles
		local v14 = v1:NextInteger(-25, 25)
		local v15 = v13 * Angles(-0.3490658503988659, math.rad(v14), 0)
		v122.Size = v122.Size + v9
		v122.Size = v122.Size * (p5 or 1)
		v122.Color = v22
		local v16 = v15 * CFrame.new(0, -v122.Size.Y, 0)
		v122.CFrame = v16
		v122.Parent = workspace.Debris
		if p3 then
			v122.CFrame = v15 * CFrame.new(0, v122.Size.Y / 2, 0)
			v122.CanCollide = true
			v122.Anchored = false
			local v17 = math.cos(0.6283185307179586 * i) * 8
			v122.AssemblyLinearVelocity = Vector3.new(v17, 35, math.sin(0.6283185307179586 * i) * 8)
			task.delay(p4 or 1.5, function() --[[ Line: 59 | Upvalues: v122 (copy), TweenService (ref), v16 (copy) ]]
				v122.Anchored = true
				local v1 = TweenService:Create(v122, TweenInfo.new(0.3333333333333333), {
					Transparency = 1,
					CFrame = CFrame.new(v122.Position.X, v16.Y, v122.Position.Z) * v122.CFrame.Rotation
				})
				v1.Completed:Once(function() --[[ Line: 62 | Upvalues: v122 (ref) ]]
					v122:Destroy()
				end)
				v1:Play()
			end)
		end
		local v19 = TweenService:Create(v122, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			CFrame = v15
		})
		v19.Completed:Once(function() --[[ Line: 69 | Upvalues: v1 (ref), p4 (copy), TweenService (ref), v122 (copy), v16 (copy) ]]
			local v12 = v1:NextNumber(0.75, 1.25)
			if p4 then
				task.wait(p4 * v12)
			else
				task.wait(v12)
			end
			TweenService:Create(v122, TweenInfo.new(0.3333333333333333), {
				Transparency = 1,
				CFrame = v16
			}):Play()
			game.Debris:AddItem(v122, 0.4)
		end)
		v19:Play()
	end
end