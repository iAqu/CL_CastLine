-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local LocalPlayer = game:GetService("Players").LocalPlayer
return {
	TransformToBrainrot = function(p1, p2, p3) --[[ TransformToBrainrot | Line: 14 | Upvalues: ReplicatedStorage (copy), Trove (copy) ]]
		if p2 and (p2.PrimaryPart and p2:FindFirstChild("Humanoid")) then
			local v1 = ReplicatedStorage.Objects.Entities:FindFirstChild(p3.Name)
			if v1 then
				local v2 = Trove.new()
				local v3 = v2:Clone(v1)
				v3:SetAttribute("Mutation", p3.Mutation)
				v3:AddTag(p3.Mutation)
				v3:WaitForChild("Root")
				v3.Root.Anchored = false
				for i, v in ipairs(v3:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then
						v.Massless = true
						v.Anchored = false
						v.CanCollide = false
						v.CanQuery = false
						v.CollisionGroup = "Player"
					end
				end
				local Humanoid = p2.Humanoid
				local DisplayDistanceType = Humanoid.DisplayDistanceType
				Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				local v6 = v2:Add(Instance.new("Weld"))
				v6.C0 = CFrame.new(0, v3.Root.Size.Y / 2 - (Humanoid.HipHeight + p2.PrimaryPart.Size.Y / 2), 0)
				v6.Part0 = p2.PrimaryPart
				v6.Part1 = v3.Root
				v6.Parent = p2.PrimaryPart
				for i, v in ipairs(p2:GetDescendants()) do
					if v:IsA("BasePart") or (v:IsA("Decal") or v:IsA("Texture")) then
						v.LocalTransparencyModifier = 1
						v2:Connect(v:GetPropertyChangedSignal("LocalTransparencyModifier"), function() --[[ Line: 65 | Upvalues: v (copy) ]]
							v.LocalTransparencyModifier = 1
						end)
					end
				end
				v3.Parent = workspace.Debris
				return function() --[[ Line: 73 | Upvalues: v2 (copy), Humanoid (copy), DisplayDistanceType (copy), p2 (copy) ]]
					v2:Destroy()
					if Humanoid then
						Humanoid.DisplayDistanceType = DisplayDistanceType
					end
					for i, v in ipairs(p2:GetDescendants()) do
						if v:IsA("BasePart") or (v:IsA("Decal") or (v:IsA("Texture") or v:IsA("MeshPart"))) then
							v.LocalTransparencyModifier = 0
						end
					end
				end
			end
		end
	end
}