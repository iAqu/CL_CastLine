-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local RandomBrainrotGui = script:WaitForChild("RandomBrainrotGui")
local Entities = ReplicatedStorage.Objects.Entities
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local t = {
	PoolName = "RandomBrainrot"
}
function CreateCloneForBrainrot(p1) --[[ CreateCloneForBrainrot | Line: 30 | Upvalues: Entities (copy) ]]
	local v1 = Entities[p1]:Clone()
	v1.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	v1:WaitForChild("Root")
	v1.Root.CFrame = CFrame.new(0, 100, 0)
	return v1
end
function GetRewardsTable(p1, p2, p3) --[[ GetRewardsTable | Line: 39 | Upvalues: EntitiesData (copy), Entities (copy) ]]
	local t = {}
	local t2 = {}
	local t3 = {}
	for i, v in ipairs(EntitiesData.LuckyBlocks[p1].Pool) do
		if v.Chance < 5 then
			table.insert(t, v)
		end
	end
	for i = 1, 19 do
		local v1 = t[math.random(1, #t)].Name
		local v2 = Entities:FindFirstChild(v1)
		if v2 then
			table.insert(t2, v1)
			if not t3[v1] then
				t3[v1] = {
					Model = p3:Add(CreateCloneForBrainrot(v1)),
					Scale = v2:GetScale()
				}
			end
		end
	end
	table.insert(t2, p2)
	if not t3[p2] then
		t3[p2] = {
			Model = p3:Add(CreateCloneForBrainrot(p2)),
			Scale = Entities[p2]:GetScale()
		}
	end
	return t3, t2
end
function UpdateLabel(p1, p2) --[[ UpdateLabel | Line: 80 | Upvalues: RandomBrainrotGui (copy) ]]
	RandomBrainrotGui.RollingFrame.Label.Text = p1 .. if p2 then "!" else "?"
	RandomBrainrotGui.RollingFrame.UnlockedLabel.Visible = p2
end
function OnNewRoll(p1) --[[ OnNewRoll | Line: 86 | Upvalues: RandomBrainrotGui (copy), Trove (copy), t (copy), SoundService (copy), TweenService (copy) ]]
	RandomBrainrotGui.Enabled = true
	local v1 = Trove.new()
	local v2, v3 = GetRewardsTable(t.PoolName, p1, v1)
	local BrainrotFrame = RandomBrainrotGui.RollingFrame.BrainrotFrame
	local v4 = v1:Add(Instance.new("Camera"))
	v4.Parent = BrainrotFrame
	BrainrotFrame.CurrentCamera = v4
	for k, v in pairs(v2) do
		v.Model.Parent = BrainrotFrame.WorldModel
	end
	local v5 = v1:Add(Instance.new("NumberValue"))
	v5.Value = 1
	v5.Parent = workspace.Debris
	local v6 = nil
	local v7 = nil
	local function updateModel(p1) --[[ updateModel | Line: 110 | Upvalues: v7 (ref), v2 (copy), v3 (copy) ]]
		if v7 then
			v7.Root.CFrame = CFrame.new(0, 100, 0)
		end
		v7 = v2[v3[p1]].Model
	end
	local v8 = v1:Clone(SoundService.Wheel.Tick)
	v8.Parent = workspace
	local v9 = v1:Clone(SoundService.Wheel.Reward)
	v9.Parent = workspace
	v1:Connect(v5.Changed, function(p1) --[[ Line: 126 | Upvalues: v6 (ref), v7 (ref), v2 (copy), v3 (copy), v9 (copy), v8 (copy), v4 (copy) ]]
		local v1 = math.floor(p1)
		local v22 = math.clamp(p1 - v1, 0, 1)
		if v6 ~= v1 then
			if v7 then
				v7.Root.CFrame = CFrame.new(0, 100, 0)
			end
			v7 = v2[v3[v1]].Model
			UpdateLabel(v3[v1], if v1 == 20 then true else false)
			v6 = v1
			if v1 == 20 then
				v9:Play()
			else
				v8:Play()
			end
		end
		local Scale = v2[v3[v6]].Scale
		v7:ScaleTo((math.lerp(Scale * 0.8, Scale, v22)))
		v7.Root.CFrame = CFrame.new(v4.CFrame.Position + v4.CFrame.LookVector * 7, v4.CFrame.Position)
	end)
	local v10 = TweenService:Create(v5, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Value = 19.99999999
	})
	v10:Play()
	v1:Connect(v10.Completed, function() --[[ Line: 150 | Upvalues: TweenService (ref), v5 (copy), v1 (copy), RandomBrainrotGui (ref) ]]
		task.wait(2)
		TweenService:Create(v5, TweenInfo.new(0.5), {
			Value = 20.9999
		}):Play()
		task.wait(0.5)
		v1:Add(task.delay(2.75, function() --[[ Line: 154 | Upvalues: v1 (ref), RandomBrainrotGui (ref) ]]
			v1:Destroy()
			RandomBrainrotGui.Enabled = false
		end))
	end)
end
function InitGUI() --[[ InitGUI | Line: 161 | Upvalues: RandomBrainrotGui (copy), PlayerGui (copy) ]]
	RandomBrainrotGui.Enabled = false
	RandomBrainrotGui.Parent = PlayerGui
end
function t._init() --[[ _init | Line: 168 | Upvalues: Network (copy) ]]
	InitGUI()
	Network.OnClientEvent("open_random"):Connect(OnNewRoll)
end
return t