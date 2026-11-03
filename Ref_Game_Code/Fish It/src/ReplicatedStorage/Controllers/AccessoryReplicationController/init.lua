-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Shared.ItemUtility)
local v1 = Net:RemoteEvent("CaughtFishVisual")
local Characters = workspace:WaitForChild("Characters")
local Accessory = script:WaitForChild("Accessory")
local v2 = nil
local t = {}
local function intersect(p1, p2) --[[ intersect | Line: 37 ]]
	local v1 = {}
	if #p1 < #p2 then
		for i, v in ipairs(p1) do
			v1[v] = true
		end
	else
		for i, v in ipairs(p2) do
			v1[v] = true
		end
	end
	local t = {}
	for i, v in ipairs(if #p1 < #p2 then p2 else p1) do
		if v1[v] then
			table.insert(t, v)
		end
	end
	return t
end
function t.Start(p1) --[[ Start | Line: 62 | Upvalues: v2 (ref), Replion (copy), Observers (copy), Trove (copy), t (copy), intersect (copy) ]]
	v2 = Replion.Client:WaitReplion("ReplicatedPlayerData")
	Observers.observeCharacter(function(p1, p2) --[[ Line: 65 | Upvalues: Trove (ref), t (ref), intersect (ref) ]]
		local Humanoid = p2:WaitForChild("Humanoid")
		if not Humanoid then
			return
		end
		if p2:WaitForChild("HumanoidRootPart") then
			local v1 = Trove.new()
			local t2 = {}
			local function destroyAll() --[[ destroyAll | Line: 79 | Upvalues: v1 (copy), t2 (ref) ]]
				v1:Destroy()
				table.clear(t2)
			end
			local function refreshEquipped(p12) --[[ refreshEquipped | Line: 84 | Upvalues: t (ref), p1 (copy), intersect (ref), t2 (ref), v1 (copy), p2 (copy) ]]
				local v12 = t:GetAccessoryNames(p1)
				if if #intersect(v12, t2) == 0 then true elseif #v12 == #t2 then true else false then
					t2 = v12
					v1:Clean()
					t:Refresh(p2, v12, v1)
				end
			end
			local v2 = Humanoid.Died:Connect(destroyAll)
			local v3 = p1:GetAttributeChangedSignal("FishingRodSkin"):Connect(function() --[[ Line: 101 | Upvalues: refreshEquipped (copy) ]]
				refreshEquipped()
			end)
			refreshEquipped()
			return function() --[[ Line: 106 | Upvalues: v2 (copy), v3 (copy), v1 (copy), t2 (ref) ]]
				v2:Disconnect()
				v3:Disconnect()
				v1:Destroy()
				table.clear(t2)
			end
		end
	end)
	local Characters = workspace:WaitForChild("Characters")
	Observers.observeTag("EquipAccessory", function(p1) --[[ Line: 115 | Upvalues: Characters (copy), Trove (ref), t (ref) ]]
		if p1:IsDescendantOf(Characters) then
			return
		end
		local v1 = p1:GetAttribute("AccessoryName")
		if not v1 then
			return
		end
		if p1:FindFirstChildWhichIsA("Humanoid") then
			local v2 = Trove.new()
			t:Refresh(p1, { v1 }, v2)
			return function() --[[ Line: 133 | Upvalues: v2 (copy) ]]
				v2:Destroy()
			end
		end
	end, { workspace })
end
function t.GetAccessory(p1, p2) --[[ GetAccessory | Line: 139 | Upvalues: Accessory (copy) ]]
	local v1 = Accessory:FindFirstChild(p2)
	if v1 then
		return require(v1)
	end
end
function t.GetAccessoryNames(p1, p2) --[[ GetAccessoryNames | Line: 148 ]]
	local t = {}
	local v1 = p2:GetAttribute("FishingRodSkin")
	if v1 then
		table.insert(t, v1)
	end
	return t
end
function t.Refresh(p1, p2, p3, p4) --[[ Refresh | Line: 159 | Upvalues: t (copy) ]]
	for i, v in ipairs(p3) do
		local v1 = t:GetAccessory(v)
		if v1 then
			if v1.AttachLimb then
				t:WeldTo(v1, p2, p4)
			end
			if v1.CustomAttach then
				v1:CustomAttach(p2, p4)
			end
		end
	end
end
function t.WeldTo(p1, p2, p3, p4) --[[ WeldTo | Line: 176 | Upvalues: Characters (copy), v1 (copy) ]]
	assert(p2.AccessoryModel, "Accessory has no model!")
	assert(p2.C0, "Accessory missing value \"C0\" during attachment process!")
	assert(p2.C1, "Accessory missing value \"C1\" during attachment process!")
	local v12 = p3:FindFirstChild(p2.AttachLimb)
	if not v12 then
		return
	end
	if not v12:IsA("BasePart") then
		return
	end
	local v2 = p4:Clone(p2.AccessoryModel)
	local v3 = if v2:IsA("Model") then v2.PrimaryPart else v2
	local v4 = nil
	if p2.Animations then
		local v5 = v2:FindFirstChildWhichIsA("AnimationController")
		local v6 = if v5 then v5:FindFirstChildWhichIsA("Animator") else nil
		if v6 then
			local t = {}
			local t2 = {}
			v4 = function(p1) --[[ Line: 198 | Upvalues: p2 (copy), t (copy), t2 (copy), v6 (copy), p4 (copy), v4 (ref) ]]
				local v1 = p2.Animations[p1]
				if not v1 then
					return
				end
				local v2 = t[p1]
				if not v2 then
					local Animation = Instance.new("Animation")
					Animation.AnimationId = v1.AnimationId
					Animation.Parent = script
					t[p1] = Animation
					v2 = Animation
				end
				local v3 = t2[p1]
				if not v3 then
					local v42 = v6:LoadAnimation(v2)
					v42.Looped = v1.Looped
					if not v1.Looped and p2.DefaultAnimation ~= p1 then
						local v5 = nil
						v5 = p4:Add(v42.Stopped:Once(function() --[[ Line: 221 | Upvalues: p4 (ref), v5 (ref), p2 (ref), v4 (ref) ]]
							p4:Remove(v5)
							if not p2.DefaultAnimation then
								return
							end
							v4(p2.DefaultAnimation)
						end))
					end
					t2[p1] = v42
					v3 = v42
				end
				if not v3 then
					return
				end
				for i, v in ipairs(v6:GetPlayingAnimationTracks()) do
					v:Stop()
				end
				v3:Play(0.1)
			end
			p4:Add(function() --[[ Line: 243 | Upvalues: t2 (copy), t (copy) ]]
				for k, v in pairs(t2) do
					v:Destroy()
				end
				for k, v in pairs(t) do
					v:Destroy()
				end
				table.clear(t)
				table.clear(t2)
			end)
		end
	end
	local v7 = v2:GetDescendants()
	if v2:IsA("BasePart") then
		table.insert(v7, v2)
	end
	for i, v in ipairs(v7) do
		if v:IsA("BasePart") then
			v.Anchored = false
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true
		end
	end
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Parent = v3
	Motor6D.Part0 = v3
	Motor6D.Part1 = v12
	Motor6D.C0 = p2.C0
	Motor6D.C1 = p2.C1
	v2.Parent = p3
	if p2.DefaultAnimation and v4 then
		task.spawn(v4, p2.DefaultAnimation)
	end
	if not (p2.FishingAnimation and p3:IsDescendantOf(Characters)) then
		return
	end
	p4:Add(v1.OnClientEvent:Connect(function(p1) --[[ Line: 291 | Upvalues: p3 (copy), v4 (ref), p2 (copy) ]]
		if p1.Character ~= p3 then
			return
		end
		task.spawn(v4, p2.FishingAnimation)
	end))
end
function _getPath(p1) --[[ _getPath | Line: 299 ]]
	return ("User_%*"):format(p1.UserId)
end
function _getReplicatedData(p1) --[[ _getReplicatedData | Line: 303 | Upvalues: v2 (ref) ]]
	return v2:Get((_getPath(p1)))
end
return t