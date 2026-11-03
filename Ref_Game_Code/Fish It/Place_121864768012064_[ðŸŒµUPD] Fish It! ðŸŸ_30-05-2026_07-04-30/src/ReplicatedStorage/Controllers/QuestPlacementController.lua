-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Quests = require(ReplicatedStorage.Modules.Quests)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = nil
local v2 = Net:RemoteEvent("PlacedItem")
local function ChangeState(p1, p2) --[[ ChangeState | Line: 17 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2.Name ~= "Handle" then
			if v2:IsA("BasePart") or v2:IsA("Decal") then
				v2.Transparency = if p2 then 0 else 1
				continue
			end
			if v2:IsA("ParticleEmitter") or v2:IsA("Beam") then
				v2.Enabled = p2
			end
		end
	end
end
local function LoadCompeletedQuest(p1) --[[ LoadCompeletedQuest | Line: 29 | Upvalues: v1 (ref), ChangeState (copy) ]]
	local v12 = v1:FindFirstChild(p1)
	if not v12 then
		return
	end
	for v2, v3 in v12:GetChildren() do
		ChangeState(v3.MANIFEST, true)
	end
end
local function LoadItem(p1) --[[ LoadItem | Line: 38 | Upvalues: Replion (copy), ChangeState (copy), Quests (copy) ]]
	local v1 = Replion.Client:GetReplion("Data")
	if not v1 or v1.Destroyed then
		return
	end
	if v1:Find("CompletedQuests", p1.Parent.Name) ~= nil then
		ChangeState(p1.MANIFEST, true)
		return
	end
	local v3 = Quests.Mainline[p1.Parent.Name]
	local v4 = v1:Get({ "Quests", "Mainline", p1.Parent.Name })
	if v3 and v4 then
		for i, v in ipairs(v4.Objectives) do
			if v3.Objectives[i].Type == "PlaceItem" then
				ChangeState(p1.MANIFEST, v.Progress >= v3.Objectives[i].Goal)
			end
		end
	else
		warn("Failed to load item state for Quest:", v3, v4)
	end
end
return {
	Start = function(p1) --[[ Start | Line: 63 | Upvalues: Replion (copy), LoadCompeletedQuest (copy), v1 (ref), Quests (copy), ChangeState (copy), v2 (copy), LoadItem (copy) ]]
		task.defer(function() --[[ Line: 64 | Upvalues: Replion (ref), LoadCompeletedQuest (ref), v1 (ref), Quests (ref), ChangeState (ref) ]]
			Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 65 | Upvalues: LoadCompeletedQuest (ref), v1 (ref), Quests (ref), ChangeState (ref) ]]
				for i, v in ipairs(p1:Get("CompletedQuests")) do
					LoadCompeletedQuest(v)
				end
				for v12, v2 in p1:Get({ "Quests", "Mainline" }) do
					local v3 = v1:FindFirstChild(v12)
					if v3 then
						local v4 = Quests.Mainline[v12]
						for v5, v6 in v2.Objectives do
							if v4.Objectives[v5].Type == "PlaceItem" then
								local v7 = v3:FindFirstChild(v4.Objectives[v5].Requirements.Id)
								if v7 then
									ChangeState(v7.MANIFEST, v6.Progress >= v4.Objectives[v5].Goal)
								end
							end
						end
					end
				end
				p1:OnArrayInsert("CompletedQuests", function(p1, p2) --[[ Line: 88 | Upvalues: LoadCompeletedQuest (ref) ]]
					LoadCompeletedQuest(p2)
				end)
			end)
		end)
		v2.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 94 | Upvalues: v1 (ref), ChangeState (ref) ]]
			local v12 = v1:FindFirstChild(p1)
			if not v12 then
				return
			end
			for v2, v3 in v12:GetChildren() do
				if v3.Name == tostring(p2) and v3.CFrame == p3 then
					ChangeState(v3.MANIFEST, true)
				end
			end
		end)
		v1 = workspace:WaitForChild("WorldSetup"):WaitForChild("!!! PLACE ITEM LOCATIONS")
		for v12, v22 in v1:GetChildren() do
			v22.ChildAdded:Connect(LoadItem)
		end
	end
}