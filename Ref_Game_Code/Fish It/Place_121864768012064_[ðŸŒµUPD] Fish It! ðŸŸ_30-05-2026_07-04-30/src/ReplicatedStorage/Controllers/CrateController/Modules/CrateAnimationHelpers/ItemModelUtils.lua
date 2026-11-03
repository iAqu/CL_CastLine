-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
return {
	new = function(p1) --[[ new | Line: 7 | Upvalues: ReplicatedStorage (copy), Players (copy), Workspace (copy) ]]
		local ItemUtility = p1.ItemUtility
		local ModelDownloader = p1.ModelDownloader
		local function getTempItemModel(p1, p2, p3, p4, p5) --[[ getTempItemModel | Line: 11 | Upvalues: ReplicatedStorage (ref), ItemUtility (copy) ]]
			local TempCrateModels = ReplicatedStorage:FindFirstChild("TempCrateModels")
			if not TempCrateModels then
				TempCrateModels = ReplicatedStorage:WaitForChild("TempCrateModels", 1)
			end
			if not TempCrateModels then
				return nil
			end
			local v1 = TempCrateModels:FindFirstChild((tostring(p5)))
			if not v1 then
				v1 = TempCrateModels:WaitForChild(tostring(p5), 1)
			end
			if not v1 then
				return nil
			end
			local v3 = v1:FindFirstChild(p4)
			if not v3 then
				v3 = v1:WaitForChild(p4, 1)
			end
			if not v3 then
				return nil
			end
			local v5 = v3:FindFirstChild(p1)
			if not v5 then
				return nil
			end
			local v6
			if p2 and p2 ~= "" then
			elseif p3 ~= nil then
				local v7 = ItemUtility.GetItemDataFromItemType(p1, p3)
				if v7 then
					v6 = v7.Data.Name
				end
			end
			if not v6 then
				return nil
			end
			local v8 = v5:FindFirstChild(v6)
			if not v8 and p3 ~= nil then
				local v9 = ItemUtility.GetItemDataFromItemType(p1, p3)
				if v9 then
					v8 = v5:FindFirstChild(v9.Data.Name)
				end
			end
			if v8 then
				return v8:Clone()
			else
				return nil
			end
		end
		local function createEmoteRigModel(p1, p2) --[[ createEmoteRigModel | Line: 72 | Upvalues: ItemUtility (copy), ReplicatedStorage (ref), Players (ref), Workspace (ref) ]]
			local v1 = ItemUtility:GetEmoteData(p1)
			if not v1 then
				return nil
			end
			local Assets = ReplicatedStorage:FindFirstChild("Assets")
			if not Assets then
				return nil
			end
			local EmoteHumanoids = Assets:FindFirstChild("EmoteHumanoids")
			if not (EmoteHumanoids and EmoteHumanoids:IsA("Folder")) then
				return nil
			end
			local v2 = v1.Data.Name
			if typeof(v2) ~= "string" or v2 == "" then
				v2 = "Default"
			end
			local v3 = EmoteHumanoids:FindFirstChild(v2)
			if not (v3 and v3:IsA("Model")) then
				v3 = EmoteHumanoids:FindFirstChild("Default")
			end
			if not (v3 and v3:IsA("Model")) then
				return nil
			end
			local v4 = v3:Clone()
			v4.Name = v1.Data.Name
			for i, v in ipairs(v4:GetDescendants()) do
				if v:IsA("Script") or (v:IsA("LocalScript") or v:IsA("ModuleScript")) then
					v:Destroy()
				end
			end
			for v5, v6 in v4:GetDescendants() do
				if v6:IsA("BasePart") then
					v6.CanCollide = false
					v6.CanQuery = false
					v6.CanTouch = false
					v6.CollisionGroup = "Players"
				end
			end
			local v7 = v4:FindFirstChildWhichIsA("Humanoid")
			if not v7 then
				v4:Destroy()
				return nil
			end
			local v8 = Players:GetPlayerByUserId(p2)
			local v9 = nil
			if v8 then
				local Character = v8.Character
				local v10 = Character and Character:FindFirstChildWhichIsA("Humanoid")
				if v10 then
					local v11, v12 = pcall(function() --[[ Line: 132 | Upvalues: v10 (copy) ]]
						return v10:GetAppliedDescription()
					end)
					if v11 then
						v9 = v12
					end
				end
			end
			if not v9 then
				local v13, v14 = pcall(function() --[[ Line: 142 | Upvalues: Players (ref), p2 (copy) ]]
					return Players:GetHumanoidDescriptionFromUserId(p2)
				end)
				if v13 then
					v9 = v14
				end
			end
			if v9 then
				local v15 = v4.Parent
				local v16 = v4:GetPivot()
				v4.Parent = Workspace
				v4:PivotTo(v16 + Vector3.new(0, -3000, 0))
				local v17, v18 = pcall(function() --[[ Line: 156 | Upvalues: v7 (copy), v9 (ref) ]]
					v7:ApplyDescriptionAsync(v9)
				end)
				v4:PivotTo(v16)
				v4.Parent = v15
				if not v17 then
					warn("[ItemModelUtils] Failed to apply emote rig description:", v18)
				end
			end
			if not v4.PrimaryPart then
				local HumanoidRootPart = v4:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
					v4.PrimaryPart = HumanoidRootPart
				else
					local v19 = v4:FindFirstChildWhichIsA("BasePart", true)
					if v19 then
						v4.PrimaryPart = v19
					end
				end
			end
			local Animator = v7:FindFirstChildOfClass("Animator")
			if not Animator then
				Animator = Instance.new("Animator")
				Animator.Parent = v7
			end
			local Animation = Instance.new("Animation")
			Animation.AnimationId = v1.AnimationId
			local v20, v21 = pcall(function() --[[ Line: 189 | Upvalues: Animator (ref), Animation (copy) ]]
				return Animator:LoadAnimation(Animation)
			end)
			Animation:Destroy()
			if v20 and v21 then
				v21.Priority = v1.AnimationPriority or Enum.AnimationPriority.Action2
				v21.Looped = if v1.Looped == true then true else false
				v21:Play(0.1, 1, v1.PlaybackSpeed or 1)
			end
			return v4
		end
		return {
			getItemToShow = function(p1, p2, p3, p4, p5) --[[ getItemToShow | Line: 203 | Upvalues: ItemUtility (copy), ModelDownloader (copy), createEmoteRigModel (copy), getTempItemModel (copy) ]]
				if p1 == "Pets" then
					local v1 = ItemUtility.GetItemDataFromItemType("Pets", p3)
					local v2 = if v1 then v1.ModelName else v1
					if typeof(v2) == "string" and v2 ~= "" then
						local v3 = ModelDownloader:GetModel("Pets", v2, true)
						if v3 then
							return v3:Clone()
						end
					end
				end
				if p1 == "Emotes" then
					local v4 = createEmoteRigModel(p3, p5)
					if not v4 then
						v4 = createEmoteRigModel(p2, p5)
					end
					if v4 then
						return v4
					end
				end
				local v6 = getTempItemModel(p1, p2, p3, p4, p5)
				if v6 then
					return v6
				end
				local v7 = ModelDownloader:GetModel(p1, p2, true)
				if v7 then
					return v7:Clone()
				else
					return nil
				end
			end
		}
	end
}