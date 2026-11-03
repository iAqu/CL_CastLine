-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Shared.ItemUtility)
local ModelProvider = require(ReplicatedStorage.ModelProvider)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Types.Modifiers)
local Handle = script:WaitForChild("Handle")
local t = { 15, 5 }
return {
	placeModel = function(p1, p2) --[[ placeModel | Line: 36 | Upvalues: ModelProvider (copy), Handle (copy), Trove (copy), t (copy), Players (copy) ]]
		local v1 = nil
		local v2 = nil
		local v3 = nil
		local v4 = nil
		if p2.character then
			local Head = p2.character:FindFirstChild("Head")
			local v5 = p2.character:FindFirstChild("Right Arm")
			local HumanoidRootPart = p2.character:FindFirstChild("HumanoidRootPart")
			local Torso = p2.character:FindFirstChild("Torso")
			if not (HumanoidRootPart and (v5 and (Head and Torso))) then
				return
			end
			v1 = v5
			v2 = HumanoidRootPart
			v4 = Head
			v3 = Torso
		elseif p2.attachTo then
			v1 = p2.attachTo
			v2 = p2.attachTo
		end
		if not (v1 and v2) then
			return
		end
		local v6 = ModelProvider:GetModel(nil, p1.Data.Type, p2.selectedItem, true)
		if not v6 then
			return
		end
		local Handle_2 = v6:FindFirstChild("Handle")
		local v7 = v6:FindFirstChild("MainBody") or Handle_2
		if not (Handle_2 and v7) then
			return
		end
		for i, v in ipairs(v6:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.Massless = true
				v.Anchored = false
			end
		end
		local v8 = "!!!EQUIPPED_TOOL!!!"
		if p1.Data.Type == "Fishing Rods" then
			if p2.backGrip then
				local v10 = p1.OverrideROT or CFrame.fromOrientation(0, math.pi, -0.7853981633974483)
				local Weld = Instance.new("Weld")
				Weld.Parent = Handle_2
				Weld.Part0 = Handle_2
				Weld.Part1 = v2
				Weld.C0 = CFrame.new(p1.OverrideC0 or Vector3.new(0.5, 1.3, 1)) * v10
				Weld.C1 = if p2.addRotation then CFrame.fromOrientation(1.5707963267948966, math.pi, 0) else CFrame.identity
				v8 = "!!!FISHING_VIEW_MODEL!!!"
			else
				local v12 = Handle:Clone()
				v12.Parent = v1
				v12.Part0 = v1
				v12.Part1 = Handle_2
				if p1.UseNewRodGrip then
					v12.C0 = p1.GripC0 or CFrame.new(Vector3.new(-0, -1, -0))
					v12.C1 = p1.GripC1 or CFrame.identity
				else
					local v15 = v6:GetAttribute("YRotation")
					if v15 then
						v12.C1 = CFrame.new(v12.C1.Position) * CFrame.fromOrientation(0, math.rad(v15), 0)
					end
				end
				local v16
				if p2.applyCharacterEffects then
					local v17 = Trove.new()
					if p1.ModelAttachment then
						local v18 = p1.ModelAttachment:Clone()
						local Motor6D = v18:FindFirstChildOfClass("Motor6D")
						if Motor6D then
							Motor6D.Part0 = v3
							Motor6D.Parent = v3
							v17:Add(Motor6D)
						end
						v18.CanCollide = false
						v18.CanTouch = false
						v18.CanQuery = false
						v18.Massless = true
						v18.Parent = p2.character
						v17:Add(v18)
					end
					if p2.humanoid and p1.HipHeight then
						p2.humanoid.HipHeight = p1.HipHeight
						v17:Add(function() --[[ Line: 140 | Upvalues: p2 (copy) ]]
							if p2.humanoid then
								p2.humanoid.HipHeight = 0
							end
						end)
					end
					v16 = v17
				else
					v16 = nil
				end
				v6.Destroying:Once(function() --[[ Line: 152 | Upvalues: v12 (copy), v16 (ref) ]]
					v12:Destroy()
					if not v16 then
						return
					end
					v16:Destroy()
					v16 = nil
				end)
				v6:AddTag("FishingRod")
			end
		else
			local v19 = v6:GetScale()
			local v20 = v6:GetAttribute("XRotation") or 0
			local v21 = v6:GetAttribute("YRotation") or 0
			local v22 = v6:GetAttribute("ZRotation") or 0
			local v23 = (v6:GetAttribute("XDirection") or 0) * v19
			local v24 = (v6:GetAttribute("YDirection") or 0) * v19
			local v25 = (v6:GetAttribute("ZDirection") or 0) * v19
			local Size = v7.Size
			local v26 = 1
			if p1.GripVersion and (p1.GripVersion >= 1 and p1.GripVersion <= 3) then
				v26 = p1.GripVersion
			elseif p2.weight then
				for i, v in ipairs(t) do
					if v <= p2.weight then
						v26 = 3 - (i - 1)
						break
					end
				end
			end
			local v27 = nil
			local v28 = nil
			local v29, v30
			if p1.GripC0 then
				v27 = p1.GripC0
				v29, v30, v28 = v1, Handle_2, p1.GripC1 or CFrame.identity
			elseif v26 == 3 then
				local v32 = if v4 and v2 then -1 * (v4.Position.Y + v4.Size.Y / 2 - v2.Position.Y + Size.Y / 2) else 0
				v28 = CFrame.new((Vector3.new(v23, v32 + v24, v25))) * CFrame.fromOrientation(math.rad(v20), math.rad(v21 + -90), (math.rad(v22)))
				v29 = v2
				v30 = Handle_2
			elseif v26 == 2 then
				local v33 = CFrame.new
				v28 = v33((Vector3.new(-1 * (1 + Size.Y / 4) + v23, v24, v25))) * CFrame.fromOrientation(math.rad(v20), math.rad(v21 + -90), (math.rad(v22)))
				v29 = v2
				v30 = Handle_2
			else
				local v35 = CFrame.new
				v27 = v35((Vector3.new(v23, -1 * (v1.Size.Y / 2 + v7.Size.Y / 4) + v24, v25))) * CFrame.fromOrientation(math.rad(v20), math.rad(v21 + 90), (math.rad(v22 + -80)))
				v29 = v1
				v30 = Handle_2
			end
			local RightArmGrip = Instance.new("Motor6D")
			RightArmGrip.Name = "RightArmGrip"
			RightArmGrip.Parent = Handle_2
			RightArmGrip.Part0 = v29
			RightArmGrip.Part1 = v30
			if v27 then
				RightArmGrip.C0 = v27
			end
			if v28 then
				RightArmGrip.C1 = v28
			end
		end
		local v37 = p2.character and Players:GetPlayerFromCharacter(p2.character)
		if v37 then
			v6:SetAttribute("Owner", v37.Name)
		end
		v6.Name = v8
		v6.Parent = p2.parent
		return v6
	end
}