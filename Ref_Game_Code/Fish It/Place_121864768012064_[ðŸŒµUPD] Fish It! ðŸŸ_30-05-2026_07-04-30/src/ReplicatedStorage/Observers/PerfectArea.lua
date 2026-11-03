-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local HandGuide = require(ReplicatedStorage.Modules.HandGuide)
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = Trove.new()
local t = {}
local t2 = {}
local function DestroyPerfectArea() --[[ DestroyPerfectArea | Line: 27 | Upvalues: CollectionService (copy) ]]
	for i, v in ipairs((CollectionService:GetTagged("PerfectArea"))) do
		v:Destroy()
	end
end
local function OnboardingStepChanged(p1) --[[ OnboardingStepChanged | Line: 33 | Upvalues: v3 (ref), CollectionService (copy), t2 (copy) ]]
	if p1 >= 5 then
		v3:Disconnect()
		for i, v in ipairs((CollectionService:GetTagged("PerfectArea"))) do
			v:Destroy()
		end
	end
	if not (p1 >= 3) then
		return
	end
	for v1, v2 in t2 do
		v2:Stop()
	end
	table.clear(t2)
end
local function SetBountyBoard(p1, p2) --[[ SetBountyBoard | Line: 49 | Upvalues: ReplicatedStorage (copy) ]]
	local v1 = if p1 then workspace:WaitForChild("Map") else ReplicatedStorage:WaitForChild("Assets")
	if not v1 then
		return
	end
	if not p2 then
		return
	end
	p2.Parent = v1
end
local function ShowBountyBoard(p1) --[[ ShowBountyBoard | Line: 60 ]]
	local Map = workspace:WaitForChild("Map")
	if not Map then
		return
	end
	if not p1 then
		return
	end
	p1.Parent = Map
end
local function HideBountyBoard(p1) --[[ HideBountyBoard | Line: 64 | Upvalues: ReplicatedStorage (copy) ]]
	local Assets = ReplicatedStorage:WaitForChild("Assets")
	if not Assets then
		return
	end
	if not p1 then
		return
	end
	p1.Parent = Assets
end
local function NewPlayerChanged(p1) --[[ NewPlayerChanged | Line: 69 | Upvalues: v2 (ref), UserPriority (copy), ReplicatedStorage (copy), v4 (copy), t (copy) ]]
	local v1 = v2:GetExpect("Level")
	local v22 = v2:GetExpect("OnboardingStep")
	local v3 = v2:GetExpect("CompletedQuests")
	local v5 = if (table.find(v3, "Volcanic Fish") or table.find(v3, "Getting Familiar")) == nil then false else true
	if UserPriority:IsTradePlaza() then
		local Assets = ReplicatedStorage:WaitForChild("Assets")
		if not Assets then
			return
		end
		if not p1 then
			return
		end
		p1.Parent = Assets
	elseif v22 >= 6 or (v1 >= 15 or v5) then
		v4:Destroy()
		local Map = workspace:WaitForChild("Map")
		if Map and p1 then
			p1.Parent = Map
		end
		for i, v in ipairs(t) do
			v()
		end
		table.clear(t)
	else
		local Assets = ReplicatedStorage:WaitForChild("Assets")
		if not Assets then
			return
		end
		if not p1 then
			return
		end
		p1.Parent = Assets
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 95 | Upvalues: v2 (ref), v3 (ref), OnboardingStepChanged (copy), v1 (ref), ReplicatedStorage (copy), Observers (copy), t (copy), NewPlayerChanged (copy), v4 (copy), CollectionService (copy), UserPriority (copy), HandGuide (copy), t2 (copy) ]]
	v2 = p1
	v3 = v2:OnChange("OnboardingStep", OnboardingStepChanged)
	OnboardingStepChanged(v2:GetExpect("OnboardingStep"))
	v1 = require(ReplicatedStorage.Controllers.BountyController)
	Observers.observeTag("BountyBoard", function(p1) --[[ Line: 105 | Upvalues: t (ref), v1 (ref) ]]
		local function f2() --[[ Line: 106 | Upvalues: p1 (copy), v1 (ref) ]]
			local v12 = p1:GetAttribute("Slot")
			if v12 then
				v1:SetupBountyBoard(v12, p1)
			end
		end
		table.insert(t, f2)
		local Gui = p1:WaitForChild("Gui")
		if Gui then
			Gui.Enabled = false
		end
		local Decal = p1:WaitForChild("Decal")
		if not Decal then
			return
		end
		Decal.Transparency = 1
	end)
	Observers.observeTag("Bounty", function(p1) --[[ Line: 126 | Upvalues: NewPlayerChanged (ref), v4 (ref), v2 (ref) ]]
		local function redirectCallback() --[[ redirectCallback | Line: 127 | Upvalues: NewPlayerChanged (ref), p1 (copy) ]]
			NewPlayerChanged(p1)
		end
		v4:Add(v2:OnChange("Level", redirectCallback))
		v4:Add(v2:OnChange("OnboardingStep", redirectCallback))
		v4:Add(v2:OnArrayInsert("CompletedQuests", redirectCallback))
		NewPlayerChanged(p1)
	end)
	local HandTemplate = script:WaitForChild("HandTemplate")
	if not (v2:GetExpect("OnboardingStep") < 3) then
		return
	end
	for v12, v22 in CollectionService:GetTagged("PerfectArea") do
		if v22.Name == "Perfect Area Highlight" then
			if UserPriority:IsTradePlaza() then
				break
			end
			local v32 = HandGuide.new({
				Template = HandTemplate,
				PivotCFrame = v22:GetPivot() + Vector3.new(0, 3.75, 0)
			})
			table.insert(t2, v32)
			v32:Start()
		end
	end
end)
return {}