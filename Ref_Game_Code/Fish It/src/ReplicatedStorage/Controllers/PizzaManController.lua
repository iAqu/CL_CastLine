-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local v1 = Net:RemoteEvent("PlacePizzaSlice")
local v2 = Net:RemoteEvent("PlacePizzaSlice2")
local v3 = nil
local v4 = 0
local t = {}
local function PlaceSlice() --[[ PlaceSlice | Line: 18 | Upvalues: CollectionService (copy), v3 (ref), v4 (ref), v2 (copy) ]]
	local v1 = CollectionService:GetTagged("PizzaBox")[1]
	if not v1 then
		return
	end
	local v22 = v1:FindFirstAncestor("Container")
	local v32 = if v22 then v22.Parent and v22.Parent:FindFirstChild("Main") else v22
	if not v32 then
		return
	end
	local v42 = v3:Get({ "Quests", "Mainline", "Catch the Slices" })
	local v5 = if v42 then v42.Objectives[1] else v42
	if not v5 then
		return
	end
	if not (v4 < v5.Progress and v4 < 8) then
		return
	end
	v4 = v4 + 1
	local v7 = v32:FindFirstChild((tostring(v4)))
	if not v7 then
		return
	end
	local v8 = false
	for v9, v10 in v7:GetChildren() do
		if v10:IsA("BasePart") then
			v10.Transparency = 0
			if not v8 then
				local t = { 89201451721361, 79016201125893, 119315782119429 }
				local v11 = t[math.random(1, #t)]
				local Sound = Instance.new("Sound")
				Sound.SoundId = ("rbxassetid://%*"):format(v11)
				Sound.Parent = v10
				Sound:Play()
				v8 = true
			end
		end
	end
	if not (v4 >= 8) then
		return
	end
	local v12 = script.NPCs:Clone()
	v12.Parent = workspace
	for v13, v14 in v12:GetChildren() do
		local Animator = v14:FindFirstChild("Humanoid"):FindFirstChild("Animator")
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://78087615433339"
		Animator:LoadAnimation(Animation):Play()
	end
	local Cheering = v1.Parent:FindFirstChild("Cheering")
	local Poof = v1.Parent:FindFirstChild("Poof")
	v2:FireServer()
	Cheering:Play()
	task.delay(15, function() --[[ Line: 84 | Upvalues: v12 (copy), Poof (copy) ]]
		v12:Destroy()
		Poof:Play()
	end)
end
local function OnInstanceAdded(p1) --[[ OnInstanceAdded | Line: 92 | Upvalues: v4 (ref), v3 (ref) ]]
	local v1 = p1:FindFirstAncestor("Container")
	local v2 = if v1 then v1.Parent and v1.Parent:FindFirstChild("Main") else v1
	if not v2 then
		return
	end
	if v4 ~= 0 then
		return
	end
	local v32 = v3:Find("CompletedQuests", "Catch the Slices")
	for v42, v5 in v2:GetDescendants() do
		if v5:IsA("BasePart") then
			v5.Transparency = if v32 then 0 else 1
		end
	end
end
function t.Start(p1) --[[ Start | Line: 110 | Upvalues: v3 (ref), Replion (copy), Observers (copy), OnInstanceAdded (copy), v1 (copy), PlaceSlice (copy) ]]
	v3 = Replion.Client:WaitReplion("Data")
	Observers.observeTag("PizzaBox", OnInstanceAdded)
	v1.OnClientEvent:Connect(PlaceSlice)
end
return t