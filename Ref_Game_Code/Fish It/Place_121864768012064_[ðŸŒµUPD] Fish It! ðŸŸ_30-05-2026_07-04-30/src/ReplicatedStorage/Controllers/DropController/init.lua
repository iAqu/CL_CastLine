-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local Spring = require(ReplicatedStorage.Packages.Spring)
require(ReplicatedStorage.Shared.ItemUtility)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Modules.Util.TableUtil)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local PresentTracking = require(script.PresentTracking)
require(ReplicatedStorage.Controllers.VFXController)
local LocalPlayer = Players.LocalPlayer
local v1 = Net:RemoteFunction("GetDrops")
local v2 = Net:RemoteEvent("RenderDrop")
local v3 = Net:RemoteEvent("DestroyDrop")
local v4 = Net:RemoteEvent("DestroyAllDrops")
local v5 = Net:RemoteEvent("ClaimRelic")
local v6 = false
local t = {}
local t2 = {}
local function NavigateEnabled() --[[ NavigateEnabled | Line: 48 | Upvalues: UserPriority (copy), LocalPlayer (copy) ]]
	if UserPriority:IsTradePlaza() then
		return false
	end
	if LocalPlayer:GetAttribute("LeviathanScaleConsumed") then
		return true
	end
	local v1 = LocalPlayer:GetAttribute("LocationName")
	return if v1 == "Secret Passage" or v1 == "Maze Room" then true else v1 == "Pirate Cove"
end
function t2.Start(p1) --[[ Start | Line: 62 | Upvalues: v2 (copy), t2 (copy), v3 (copy), v4 (copy), UserPriority (copy), v1 (copy), t (copy), LocalPlayer (copy), v6 (ref), PresentTracking (copy), Observers (copy) ]]
	v2.OnClientEvent:Connect(t2._renderDrop)
	v3.OnClientEvent:Connect(t2._destroyDrop)
	v4.OnClientEvent:Connect(t2._destroyAllDrops)
	if UserPriority:IsTradePlaza() then
		return
	end
	local v12 = v1:InvokeServer()
	local v22, _
	if typeof(v12) == "table" then
		for k, v in pairs(v12) do
			t2._renderDrop(k, v.ItemType, v.ItemName, v.Location)
		end
	end
	v22 = function() --[[ getRelics | Line: 80 | Upvalues: t (ref) ]]
		for k, v in pairs(t) do
			if v.ItemName:find("Relic") then
				return true
			end
		end
		return false
	end
	_ = function() --[[ resumeTracking | Line: 93 | Upvalues: LocalPlayer (ref), t (ref), v2 (ref), v6 (ref), UserPriority (ref), v22 (copy), PresentTracking (ref) ]]
		return task.spawn(function() --[[ Line: 94 | Upvalues: LocalPlayer (ref), t (ref), v2 (ref), v6 (ref), UserPriority (ref), v22 (ref), PresentTracking (ref) ]]
			while true do
				local v1
				repeat
					local v23, v3
					repeat
						local v4, v5
						repeat
							repeat
								task.wait(0.5)
								v4 = LocalPlayer.Character
							until v4
							v5 = v4:FindFirstChildWhichIsA("Humanoid")
						until v5 and (not (v5.Health <= 0) and v5:GetState() ~= Enum.HumanoidStateType.Dead)
						v23 = v4.PrimaryPart
					until v23
					if next(t) == nil then
						v2.OnClientEvent:Wait()
						task.wait(1)
						if UserPriority:IsTradePlaza() then
							v3 = false
						elseif LocalPlayer:GetAttribute("LeviathanScaleConsumed") then
							v3 = true
						else
							local v62 = LocalPlayer:GetAttribute("LocationName")
							v3 = if v62 == "Secret Passage" or v62 == "Maze Room" then true else v62 == "Pirate Cove"
						end
						v6 = v3
					end
					if not v22() then
						return
					end
					if not v6 then
						return
					end
					local v7 = v23.CFrame
					local t2 = {}
					for k2, v in pairs(t) do
						if v.ItemName:find("Relic") then
							table.insert(t2, {
								Location = v.Location,
								ItemName = v.ItemName
							})
						end
					end
					table.sort(t2, function(p1_2, p2_2) --[[ Line: 140 | Upvalues: v7 (copy) ]]
						return (p1_2.Location.Position - v7.Position).Magnitude < (p2_2.Location.Position - v7.Position).Magnitude
					end)
					PresentTracking:Stop()
					v1 = t2[1]
				until v1
				PresentTracking:Track(v1.ItemName, v1.Location)
				PresentTracking.StopSignal:Wait()
			end
		end)
	end
	Observers.observeCharacter(function(p1, p2) --[[ Line: 155 | Upvalues: LocalPlayer (ref), t (ref), v2 (ref), v6 (ref), UserPriority (ref), v22 (copy), PresentTracking (ref) ]]
		if p1 == LocalPlayer then
			p2:WaitForChild("HumanoidRootPart")
			local v1 = task.spawn(function() --[[ Line: 94 | Upvalues: LocalPlayer (ref), t (ref), v2 (ref), v6 (ref), UserPriority (ref), v22 (ref), PresentTracking (ref) ]]
				while true do
					local v1
					repeat
						local v23, v3
						repeat
							local v4, v5
							repeat
								repeat
									task.wait(0.5)
									v4 = LocalPlayer.Character
								until v4
								v5 = v4:FindFirstChildWhichIsA("Humanoid")
							until v5 and (not (v5.Health <= 0) and v5:GetState() ~= Enum.HumanoidStateType.Dead)
							v23 = v4.PrimaryPart
						until v23
						if next(t) == nil then
							v2.OnClientEvent:Wait()
							task.wait(1)
							if UserPriority:IsTradePlaza() then
								v3 = false
							elseif LocalPlayer:GetAttribute("LeviathanScaleConsumed") then
								v3 = true
							else
								local v62 = LocalPlayer:GetAttribute("LocationName")
								v3 = if v62 == "Secret Passage" or v62 == "Maze Room" then true else v62 == "Pirate Cove"
							end
							v6 = v3
						end
						if not v22() then
							return
						end
						if not v6 then
							return
						end
						local v7 = v23.CFrame
						local t2 = {}
						for k2, v in pairs(t) do
							if v.ItemName:find("Relic") then
								table.insert(t2, {
									Location = v.Location,
									ItemName = v.ItemName
								})
							end
						end
						table.sort(t2, function(p1_2, p2_2) --[[ Line: 140 | Upvalues: v7 (copy) ]]
							return (p1_2.Location.Position - v7.Position).Magnitude < (p2_2.Location.Position - v7.Position).Magnitude
						end)
						PresentTracking:Stop()
						v1 = t2[1]
					until v1
					PresentTracking:Track(v1.ItemName, v1.Location)
					PresentTracking.StopSignal:Wait()
				end
			end)
			return function() --[[ Line: 163 | Upvalues: v1 (copy), PresentTracking (ref) ]]
				pcall(task.cancel, v1)
				PresentTracking:Stop()
			end
		end
	end)
end
function t2.ClaimDrop(p1, p2) --[[ ClaimDrop | Line: 171 | Upvalues: v5 (copy) ]]
	v5:FireServer(p2)
	animateDrop(p2)
	return true
end
function t2._destroyDrop(p1, p2) --[[ _destroyDrop | Line: 178 | Upvalues: t (copy), PresentTracking (copy) ]]
	local v1 = t[p1]
	if v1 then
		if v1.Model then
			v1.Model:Destroy()
		end
		v1.Cleaner:Destroy()
		t[p1] = nil
	end
	if p2 or PresentTracking:GetTrackingId() ~= p1 then
		return
	end
	PresentTracking:Stop()
end
function t2._destroyAllDrops() --[[ _destroyAllDrops | Line: 194 | Upvalues: t (copy), t2 (copy), PresentTracking (copy) ]]
	for v1 in t do
		t2._destroyDrop(v1, true)
	end
	table.clear(t)
	PresentTracking:Stop()
end
function t2._promptActivated(p1, p2, p3) --[[ _promptActivated | Line: 203 | Upvalues: LocalPlayer (copy), t2 (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local PrimaryPart = Character.PrimaryPart
	if not PrimaryPart then
		return
	end
	if not ((PrimaryPart.Position - p2.Position).Magnitude > 50) then
		t2:ClaimDrop(p1)
		p3()
	end
end
function t2._renderDrop(p1, p2, p3, p4) --[[ _renderDrop | Line: 223 | Upvalues: ModelDownloader (copy), Trove (copy), t2 (copy), t (copy) ]]
	local v1 = ModelDownloader:GetModel(p2, p3)
	if not v1 then
		return
	end
	local v2 = Trove.new()
	local v3 = v1:Clone()
	local v4 = script.ProximityPrompt:Clone()
	local Handle = v3:FindFirstChild("Handle")
	if Handle then
		local v5 = script.VFX:FindFirstChild(p3)
		if v5 then
			v5:Clone().Parent = Handle
		end
	end
	local Attachment = Instance.new("Attachment")
	Attachment.Parent = v3
	Attachment.Position = Vector3.new(0, 3, 0)
	for i, v in ipairs(v3:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
		if v:IsA("WeldConstraint") then
			v:Destroy()
		end
	end
	v2:Add(v3)
	v2:Add(v4)
	local v6 = nil
	v6 = v2:Add(v4.Triggered:Connect(function() --[[ Line: 262 | Upvalues: t2 (ref), p1 (copy), p4 (copy), v2 (copy), v6 (ref), v4 (copy) ]]
		t2._promptActivated(p1, p4, function() --[[ Line: 264 | Upvalues: v2 (ref), v6 (ref), v4 (ref) ]]
			v2:Remove(v6)
			v4.Enabled = false
		end)
	end))
	v4.ObjectText = "Leviathan Hunt"
	v4.ActionText = ("Claim %*"):format(p3)
	v4.Parent = Attachment
	v3.Parent = workspace.CurrentCamera
	v3:PivotTo(p4)
	v3:ScaleTo(1.5)
	t[p1] = {
		Cleaner = Trove.new(),
		States = {},
		ItemType = p2,
		ItemName = p3,
		Model = v3,
		Location = p4
	}
	t[p1].States.Idle = startIdle(p1)
end
function startIdle(p1) --[[ startIdle | Line: 296 | Upvalues: t (copy), RunService (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	local Cleaner = v1.Cleaner
	if not Cleaner then
		return
	end
	local Model = v1.Model
	if Model then
		local Location = v1.Location
		local v2 = 0
		local v3 = nil
		v3 = RunService.PostSimulation:Connect(function(p1) --[[ Line: 317 | Upvalues: v2 (ref), v1 (copy), Location (copy), v3 (ref), Model (copy) ]]
			v2 = v2 + p1
			if not (v1 and Location) then
				v3:Disconnect()
				return
			end
			if not Model then
				return
			end
			local v4 = Location + Vector3.new(0, math.cos(v2) + 1, 0)
			Model:PivotTo(v4 * CFrame.Angles(0, math.sin(v2 * 2), 0))
		end)
		return Cleaner:Add(function() --[[ Line: 331 | Upvalues: v3 (ref) ]]
			v3:Disconnect()
		end)
	end
end
function animateDrop(p1) --[[ animateDrop | Line: 336 | Upvalues: t (copy), t2 (copy), Spring (copy), RunService (copy), LocalPlayer (copy), Soundbook (copy) ]]
	local v1 = t[p1]
	if v1 then
		if v1.States.Idle then
			v1.Cleaner:Remove(v1.States.Idle)
		end
		local Model = v1.Model
		local Location = v1.Location
		local v2 = Spring.new(0, 2.2, nil, 0.5)
		local v3 = Spring.new(0, 4, nil, 0.3)
		local v4 = Spring.new(0, 2.4, nil, 0.7)
		v3.goal = 2
		v2.goal = 1
		local v5 = os.clock()
		v1.Cleaner:Add(RunService.PostSimulation:Connect(function(p1) --[[ Line: 360 | Upvalues: v5 (copy), v3 (copy), v4 (copy), v2 (copy), LocalPlayer (ref), Location (copy), Model (copy) ]]
			local v1 = os.clock() - v5
			if math.abs(v3.velocity) <= 4 and v1 > 0.2 then
				v3.dampingRatio = 0.9
			end
			local v22 = Vector3.new(0, 1, 0) * v3:update(p1)
			local v32 = 1 - v4:update(p1)
			local v42
			if v1 >= 0.4 then
				local v52 = v2:update(p1)
				local v6 = LocalPlayer.Character:GetPivot()
				local v7 = CFrame.new(Location.Position) + v22
				v42 = v7 - (v7.Position - v6.Position) * v52
			else
				v42 = CFrame.new(Location.Position) + v22
			end
			if not Model.Parent then
				return
			end
			Model:PivotTo(v42)
			Model:ScaleTo(v32)
		end))
		Soundbook:RenderAt("Leviathan Teleport", v1.Model:GetPivot().Position)
		task.delay(0.3, function() --[[ Line: 398 | Upvalues: v4 (copy) ]]
			v4.goal = 0.4
		end)
		task.wait(0.6)
	end
	t2._destroyDrop(p1)
end
return t2