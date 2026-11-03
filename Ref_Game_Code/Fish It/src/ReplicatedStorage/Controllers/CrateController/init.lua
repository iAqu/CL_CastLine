-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Net = require(ReplicatedStorage.Packages.Net)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local SkinCrates = require(ReplicatedStorage.SkinCrates)
local EmoteCrates = require(ReplicatedStorage.EmoteCrates)
local PetEggs = require(ReplicatedStorage.PetEggs)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local CrateAnimation = require(script.Modules.CrateAnimation)
local v1 = Net:RemoteEvent("RollSkinCrate")
local v2 = Net:RemoteEvent("RollEmoteCrate")
local t = {
	Name = "CaseOpeningController",
	Priority = 50
}
local t2 = {}
local v3 = 0
local v4 = CrateAnimation.new({
	Assets = Assets,
	Settings = {
		Timings = {
			DelayPerCase = 0.075,
			TrailLifetime = 0.35,
			UpscaleDuration = 0.75,
			MoveDuration = 0.75,
			BounceDuration = 0.55,
			DramaticPauseDuration = 1,
			ShakePreDuration = 1.75,
			ShakePostDuration = 1,
			PauseDuration = 5,
			OpenTime = 0.15,
			LidOpenDegrees = 160,
			ItemLookAtPlayerDuration = 2.5,
			ItemFlyIntoPlayerDuration = 0.7,
			GrowScaleDuration = 0.1,
			ImpactParticleLifetime = 0.5,
			OpenParticleLifetime = 1.5,
			legendaryEffectDuration = { 0.9, 1.3 }
		},
		Other = {
			BounceHeight = 2.25,
			ShakePitchMagnitude = -30,
			ShakePitchA = 1.5,
			ShakePitchB = 7,
			ItemLookAtPlayerFloatRate = 0.5,
			ItemLookAtPlayerFloatHeight = 5,
			GrowScale = 3
		}
	},
	ItemUtility = ItemUtility,
	ModelDownloader = ModelDownloader,
	Debris = Debris,
	activeEggs = t2
})
local function getCrateData(p1) --[[ getCrateData | Line: 111 | Upvalues: SkinCrates (copy), EmoteCrates (copy), PetEggs (copy) ]]
	local v1 = SkinCrates[p1]
	if v1 then
		return v1
	end
	local v2 = EmoteCrates[p1]
	if v2 then
		return v2
	end
	local v3 = PetEggs[p1]
	if v3 then
		return v3
	else
		return nil
	end
end
local function computePositions(p1, p2, p3) --[[ computePositions | Line: 130 | Upvalues: t2 (copy) ]]
	local v1 = p2 or 1
	local v2 = 360 / (v1 * 6)
	local v3, v4
	if typeof(p1) == "Instance" then
		local Character = p1.Character
		if not Character then
			return nil
		end
		assert(Character)
		local PrimaryPart = Character.PrimaryPart
		if not PrimaryPart then
			return nil
		end
		assert(PrimaryPart)
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if not Humanoid then
			return nil
		end
		assert(Humanoid)
		v3 = Character:GetPivot()
		v4 = v3.Position
	else
		v4 = p1.Position
		v3 = p1
	end
	local t = {}
	for k, v in pairs(t2) do
		if not k.completed then
			table.insert(t, k.position)
		end
	end
	if p3 then
		for i, v in ipairs(p3) do
			table.insert(t, v)
		end
	end
	local v5 = RaycastParams.new()
	v5.IgnoreWater = false
	v5.RespectCanCollide = false
	local function locateGround(p1) --[[ locateGround | Line: 181 | Upvalues: v5 (copy) ]]
		local v1 = workspace:Raycast(p1 + Vector3.new(0, 10, 0), Vector3.new(0, -25, 0), v5)
		if not v1 then
			return nil
		end
		assert(v1)
		local v2 = v1.Instance
		if v2 then
			assert(v2)
			return v1
		else
			return nil
		end
	end
	local function isPositionVisible(p1, p2) --[[ isPositionVisible | Line: 196 ]]
		return true
	end
	local function findSuitablePosition() --[[ findSuitablePosition | Line: 200 | Upvalues: v3 (ref), v2 (copy), v4 (ref), v5 (copy), t (copy) ]]
		-- structuring failed for function 3; please report this in our discord https://discord.gg/y63m4zUYa4
	end
	local t3 = {}
	for i = 1, v1 do
		local v6 = findSuitablePosition()
		if not v6 then
			return nil
		end
		assert(v6)
		table.insert(t3, v6)
		table.insert(t, v6)
	end
	return t3
end
local function getCrateItems(p1) --[[ getCrateItems | Line: 242 | Upvalues: SkinCrates (copy), EmoteCrates (copy), PetEggs (copy), ItemUtility (copy) ]]
	local v1 = SkinCrates[p1]
	local v2
	if v1 then
		v2 = v1
	else
		local v3 = EmoteCrates[p1]
		if v3 then
			v2 = v3
		else
			local v4 = PetEggs[p1]
			v2 = if v4 then v4 else nil
		end
	end
	if not v2 then
		return {}
	end
	local t = {}
	if v2.Rolls then
		local sum = 0
		for i, v in ipairs(v2.Rolls) do
			sum = sum + math.max(v.Weight or 0, 0)
		end
		for i, v in ipairs(v2.Rolls) do
			local v6
			local RewardInfo = v.RewardInfo
			if typeof(RewardInfo) == "table" then
				local v7 = ItemUtility.GetItemDataFromItemType(RewardInfo.Type, RewardInfo.Identifier)
				if v7 then
					v6 = if sum > 0 then math.max(v.Weight or 0, 0) / sum * 100 else 0
					table.insert(t, {
						itemType = RewardInfo.Type,
						itemName = v7.Data.Name,
						chance = v6
					})
				end
			end
		end
	else
		for i, v in ipairs(v2.Items) do
			local CurrencyRewardInfo = v.CurrencyRewardInfo
			local v10 = CurrencyRewardInfo[1]
			local v12 = ItemUtility.GetItemDataFromItemType(v10, CurrencyRewardInfo[2])
			if v12 then
				table.insert(t, {
					itemType = v10,
					itemName = v12.Data.Name,
					chance = v.Chance
				})
			end
		end
	end
	return t
end
local function performOpen(p1, p2, p3, p4, p5, p6, p7) --[[ performOpen | Line: 295 | Upvalues: computePositions (copy), getCrateItems (copy), t2 (copy), v3 (ref), v4 (copy), GuiControl (copy) ]]
	local list = {}
	local v1 = if p7 then computePositions(CFrame.new(p6), 1) else computePositions(p1, 1)
	if not v1 then
		warn("NO POSITIONS TO SPAWN CASES")
		return 0
	end
	local v42 = getCrateItems(p5)
	for i, v in ipairs(v1) do
		local t = {
			priority = 1,
			completed = false,
			player = p1,
			origin = p6,
			position = v,
			partyCount = #v1,
			partyIndex = i,
			itemType = p2,
			itemName = p3,
			itemId = p4,
			caseId = p5,
			crateItems = v42
		}
		table.insert(list, t)
		t2[t] = true
	end
	v3 = v3 + #v1
	for i, v in ipairs(list) do
		task.spawn(function() --[[ Line: 333 | Upvalues: v4 (ref), v (copy), t2 (ref), v3 (ref), GuiControl (ref) ]]
			v4.performAnimation(v)
			v.completed = true
			t2[v] = nil
			v3 = v3 - 1
			if not (v3 <= 0) then
				return
			end
			v3 = 0
			GuiControl:Unlock()
		end)
	end
	return #v1
end
function t.OpenPetEgg(p1, p2, p3, p4) --[[ OpenPetEgg | Line: 348 | Upvalues: Players (copy), GuiControl (copy), ItemUtility (copy), performOpen (copy) ]]
	local v1 = if p2 then p2 else Players.LocalPlayer
	if not v1 then
		return 0
	end
	local Character = v1.Character
	if not (Character and Character.PrimaryPart) then
		return 0
	end
	GuiControl:Lock()
	GuiControl:Close(true)
	GuiControl:Lock()
	local sum = 0
	for i, v in ipairs(p4) do
		local Pet = v.Pet
		local v2 = v.ItemType or (if Pet then "Pets" else nil)
		local v3 = v.ItemId or (if Pet then Pet.Id else nil)
		if v2 and v3 then
			local v4 = ItemUtility.GetItemDataFromItemType(v2, v3)
			if v4 then
				sum = sum + performOpen(v1, v2, v.RewardName or v4.Data.Name, v3, p3, Character:GetPivot().Position, true)
			end
		end
	end
	if sum ~= 0 then
		return sum
	end
	GuiControl:Unlock()
	return sum
end
function t.Start(p1) --[[ Start | Line: 388 | Upvalues: SkinCrates (copy), EmoteCrates (copy), PetEggs (copy), HttpService (copy), ItemUtility (copy), Players (copy), GuiControl (copy), performOpen (copy), v1 (copy), v2 (copy) ]]
	local function onCrateRoll(p1, p2, p3) --[[ onCrateRoll | Line: 389 | Upvalues: SkinCrates (ref), EmoteCrates (ref), PetEggs (ref), HttpService (ref), ItemUtility (ref), Players (ref), GuiControl (ref), performOpen (ref) ]]
		local v1 = SkinCrates[p1]
		local v2
		if v1 then
			v2 = v1
		else
			local v3 = EmoteCrates[p1]
			if v3 then
				v2 = v3
			else
				local v4 = PetEggs[p1]
				v2 = if v4 then v4 else nil
			end
		end
		if not v2 then
			return
		end
		local v6, v7, _, _2 = table.unpack((HttpService:JSONDecode(p2)))
		local v8 = ItemUtility.GetItemDataFromItemType(v6, v7)
		if not v8 then
			return
		end
		local v10 = if p3 then p3 else Players.LocalPlayer
		if not v10 then
			return
		end
		local Character = v10.Character
		if not (Character and Character.PrimaryPart) then
			return
		end
		local v11 = if v10 == Players.LocalPlayer then true else false
		if v11 then
			GuiControl:Lock()
			GuiControl:Close(true)
			GuiControl:Lock()
		end
		if performOpen(v10, v6, v8.Data.Name, v7, p1, Character:GetPivot().Position, true) ~= 0 or not v11 then
			return
		end
		GuiControl:Unlock()
	end
	v1.OnClientEvent:Connect(onCrateRoll)
	v2.OnClientEvent:Connect(onCrateRoll)
end
return t