-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = NumberRange.new(60, 120)
local LocalPlayer = Players.LocalPlayer
local WorldSetup = workspace:WaitForChild("WorldSetup")
local SearchItems = ReplicatedStorage:WaitForChild("Assets").SearchItems
local v2 = Net:RemoteFunction("SearchItemPickedUp")
local t = {}
local function UserError(p1) --[[ UserError | Line: 35 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
local function HideModel(p1) --[[ HideModel | Line: 43 | Upvalues: TweenUtil (copy) ]]
	TweenUtil.TweenModelTransparency(p1, 1, TweenInfo.new(0.3))
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") or (v:IsA("Light") or (v:IsA("Beam") or v:IsA("Trail"))) then
			v.Enabled = false
		end
	end
end
local function ShowModel(p1) --[[ ShowModel | Line: 53 | Upvalues: TweenUtil (copy) ]]
	TweenUtil.TweenModelTransparency(p1, 0, TweenInfo.new(0.2))
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") or (v:IsA("Light") or (v:IsA("Beam") or v:IsA("Trail"))) then
			v.Enabled = true
		end
	end
end
local function InitSearchItems(p1) --[[ InitSearchItems | Line: 63 | Upvalues: WorldSetup (copy), SearchItems (copy), t (copy), LocalPlayer (copy), UserError (copy), StarterPlayer (copy), Soundbook (copy), v2 (copy), ShowModel (copy), HideModel (copy), v1 (copy) ]]
	local v12 = WorldSetup:WaitForChild("!!! SEARCH ITEM SPAWNS")
	if not v12 then
		return
	end
	for i, v in ipairs(v12:GetChildren()) do
		if SearchItems:FindFirstChild(v.Name) then
			local v22 = v:GetAttribute("QuestId")
			if not (v22 and p1:Find("CompletedQuests", v22)) then
				local v3 = SearchItems[v.Name]:GetChildren()
				task.spawn(function() --[[ Line: 82 | Upvalues: v (copy), t (ref), p1 (copy), v3 (copy), LocalPlayer (ref), v22 (copy), UserError (ref), StarterPlayer (ref), Soundbook (ref), v2 (ref), ShowModel (ref), HideModel (ref), v1 (ref) ]]
					local v12 = v:GetAttribute("AnimationId")
					if v12 then
						local Animation = Instance.new("Animation")
						Animation.AnimationId = ("rbxassetid://%*"):format(v12)
						t[v.Name] = Animation
					end
					if v:GetAttribute("Delay") then
						task.wait(v:GetAttribute("Delay"))
					end
					for i, v4 in ipairs(v:GetChildren()) do
						local v23, v32, Model, v42
						if v:GetAttribute("UUID") then
							local v5 = v4:GetAttribute("ModelId")
							local v6 = ("Unable to spawn %*! Missing attribute \"ModelId\" despite \"UUID\" being enabled under Spawn folder!"):format(v.Name)
							v23 = assert(v5, v6)
							if not p1:Find("ClaimedSearchIds", v23) then
								v32 = v4.CFrame
								Model = v3[math.random(1, #v3)]:Clone()
								Model.Name = "Model"
								Model:PivotTo(v32)
								v42 = script.ProximityPrompt:Clone()
								v42.ObjectText = v.Name:gsub("(%u)", " %1"):gsub("^ ", "")
								v42.Parent = v4
								v42.Triggered:Connect(function(p12_2) --[[ Line: 115 | Upvalues: LocalPlayer (ref), v42 (copy), p1 (ref), v22 (ref), UserError (ref), v23 (ref), t (ref), v (ref), StarterPlayer (ref), Soundbook (ref), v32 (copy), v2 (ref), v4 (copy), ShowModel (ref), Model (copy), HideModel (ref), v1 (ref) ]]
									if p12_2 ~= LocalPlayer then
										return
									end
									if not v42.Enabled then
										return
									end
									if p1:Find("CompletedQuests", v22) then
										UserError("You have already completed this quest, you don\'t need the item!")
										return
									end
									local v12 = p1:GetExpect("Quests")
									if not (v12 and (v12.Event[v22] or v12.Mainline[v22])) then
										UserError("This is a quest item, speak with the appropriate NPC to get the quest!")
										return
									end
									if v23 and table.find(p1:GetExpect("ClaimedSearchIds"), v23) then
										UserError("You already claimed this!")
										return
									end
									local v3 = t[v.Name]
									if v3 then
										local Character = LocalPlayer.Character
										local v43 = Character and Character:FindFirstChild("Humanoid")
										if v43 and v43.Health > 0 then
											v43.WalkSpeed = 0
											local v5 = Character.Humanoid.Animator:LoadAnimation(v3)
											local v6 = nil
											v6 = v5.Stopped:Connect(function() --[[ Line: 150 | Upvalues: v5 (copy), v6 (ref), v43 (copy), StarterPlayer (ref) ]]
												v5:Destroy()
												v6:Disconnect()
												v43.WalkSpeed = StarterPlayer.CharacterWalkSpeed
											end)
											v5:Play()
										end
									end
									local v7 = v:GetAttribute("SFX")
									if v7 then
										Soundbook:RenderAt(v7, v32.Position)
									end
									v42.Enabled = false
									if not v2:InvokeServer(v4.Name, v23) then
										v42.Enabled = true
										ShowModel(Model)
										return
									end
									HideModel(Model)
									if not v:GetAttribute("Respawn") then
										return
									end
									task.delay(v:GetAttribute("RespawnTime") or math.random(v1.Min, v1.Max), function() --[[ Line: 183 | Upvalues: ShowModel (ref), Model (ref), v42 (ref) ]]
										ShowModel(Model)
										v42.Enabled = true
									end)
								end)
								Model.Parent = v4
							end
						else
							v23 = nil
							v32 = v4.CFrame
							Model = v3[math.random(1, #v3)]:Clone()
							Model.Name = "Model"
							Model:PivotTo(v32)
							v42 = script.ProximityPrompt:Clone()
							v42.ObjectText = v.Name:gsub("(%u)", " %1"):gsub("^ ", "")
							v42.Parent = v4
							v42.Triggered:Connect(function(p12_2) --[[ Line: 115 | Upvalues: LocalPlayer (ref), v42 (copy), p1 (ref), v22 (ref), UserError (ref), v23 (ref), t (ref), v (ref), StarterPlayer (ref), Soundbook (ref), v32 (copy), v2 (ref), v4 (copy), ShowModel (ref), Model (copy), HideModel (ref), v1 (ref) ]]
								if p12_2 ~= LocalPlayer then
									return
								end
								if not v42.Enabled then
									return
								end
								if p1:Find("CompletedQuests", v22) then
									UserError("You have already completed this quest, you don\'t need the item!")
									return
								end
								local v12 = p1:GetExpect("Quests")
								if not (v12 and (v12.Event[v22] or v12.Mainline[v22])) then
									UserError("This is a quest item, speak with the appropriate NPC to get the quest!")
									return
								end
								if v23 and table.find(p1:GetExpect("ClaimedSearchIds"), v23) then
									UserError("You already claimed this!")
									return
								end
								local v3 = t[v.Name]
								if v3 then
									local Character = LocalPlayer.Character
									local v43 = Character and Character:FindFirstChild("Humanoid")
									if v43 and v43.Health > 0 then
										v43.WalkSpeed = 0
										local v5 = Character.Humanoid.Animator:LoadAnimation(v3)
										local v6 = nil
										v6 = v5.Stopped:Connect(function() --[[ Line: 150 | Upvalues: v5 (copy), v6 (ref), v43 (copy), StarterPlayer (ref) ]]
											v5:Destroy()
											v6:Disconnect()
											v43.WalkSpeed = StarterPlayer.CharacterWalkSpeed
										end)
										v5:Play()
									end
								end
								local v7 = v:GetAttribute("SFX")
								if v7 then
									Soundbook:RenderAt(v7, v32.Position)
								end
								v42.Enabled = false
								if not v2:InvokeServer(v4.Name, v23) then
									v42.Enabled = true
									ShowModel(Model)
									return
								end
								HideModel(Model)
								if not v:GetAttribute("Respawn") then
									return
								end
								task.delay(v:GetAttribute("RespawnTime") or math.random(v1.Min, v1.Max), function() --[[ Line: 183 | Upvalues: ShowModel (ref), Model (ref), v42 (ref) ]]
									ShowModel(Model)
									v42.Enabled = true
								end)
							end)
							Model.Parent = v4
						end
					end
				end)
			end
			continue
		end
		warn("Failed to find a templates storage for:", v.Name)
	end
end
return {
	Init = function(p1) --[[ Init | Line: 199 | Upvalues: Replion (copy), InitSearchItems (copy) ]]
		Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 200 | Upvalues: InitSearchItems (ref) ]]
			InitSearchItems(p1)
		end)
	end
}