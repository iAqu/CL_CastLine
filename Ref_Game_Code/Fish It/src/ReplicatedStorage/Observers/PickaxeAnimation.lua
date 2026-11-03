-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local v1 = Net:RemoteEvent("PickaxeMining")
local LocalPlayer = Players.LocalPlayer
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://132127568585411"
local Animation_2 = Instance.new("Animation")
Animation_2.AnimationId = "rbxassetid://127791492757405"
ContentProvider:PreloadAsync({ Animation, Animation_2 })
local v2 = nil
local v3 = nil
local v4 = nil
local function getAnimator() --[[ getAnimator | Line: 32 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return nil
	end
	local v1 = Character:FindFirstChildWhichIsA("Humanoid")
	if v1 then
		return v1:FindFirstChildWhichIsA("Animator")
	else
		return nil
	end
end
local function loadAnimations() --[[ loadAnimations | Line: 46 | Upvalues: LocalPlayer (copy), v4 (ref), v2 (ref), v3 (ref), Animation (copy), Animation_2 (copy) ]]
	local Character = LocalPlayer.Character
	local v1
	if Character then
		local v22 = Character:FindFirstChildWhichIsA("Humanoid")
		v1 = if v22 then v22:FindFirstChildWhichIsA("Animator") else nil
	else
		v1 = nil
	end
	if not v1 or v1 == v4 then
		return
	end
	v4 = v1
	if v2 then
		v2:Destroy()
		v2 = nil
	end
	if v3 then
		v3:Destroy()
		v3 = nil
	end
	local v32, v42 = pcall(function() --[[ Line: 63 | Upvalues: v1 (copy), Animation (ref) ]]
		return v1:LoadAnimation(Animation)
	end)
	if v32 and v42 then
		v42.Looped = true
		v42.Priority = Enum.AnimationPriority.Idle
		v2 = v42
	end
	local v5, v6 = pcall(function() --[[ Line: 73 | Upvalues: v1 (copy), Animation_2 (ref) ]]
		return v1:LoadAnimation(Animation_2)
	end)
	if not (v5 and v6) then
		return
	end
	v6.Looped = false
	v6.Priority = Enum.AnimationPriority.Action
	v3 = v6
end
local function stopIdleAnimation() --[[ stopIdleAnimation | Line: 84 | Upvalues: v2 (ref) ]]
	if not (v2 and v2.IsPlaying) then
		return
	end
	v2:Stop()
end
local function stopMiningAnimation() --[[ stopMiningAnimation | Line: 90 | Upvalues: v3 (ref) ]]
	if not (v3 and v3.IsPlaying) then
		return
	end
	v3:Stop()
end
local function playIdleAnimation() --[[ playIdleAnimation | Line: 96 | Upvalues: loadAnimations (copy), v2 (ref) ]]
	loadAnimations()
	if not v2 or v2.IsPlaying then
		return
	end
	v2:Play()
end
local function playMiningAnimation() --[[ playMiningAnimation | Line: 104 | Upvalues: loadAnimations (copy), v2 (ref), v3 (ref) ]]
	loadAnimations()
	if v2 and v2.IsPlaying then
		v2:Stop()
	end
	if not v3 then
		return
	end
	v3:Play()
	v3.Stopped:Once(function() --[[ Line: 111 | Upvalues: loadAnimations (ref), v2 (ref) ]]
		loadAnimations()
		if not v2 or v2.IsPlaying then
			return
		end
		v2:Play()
	end)
end
local function isPickaxeEquipped(p1) --[[ isPickaxeEquipped | Line: 117 | Upvalues: PlayerStatsUtility (copy) ]]
	local v1 = p1:Get("EquippedId")
	if v1 and v1 ~= "" then
		local v2 = PlayerStatsUtility:GetItemFromInventory(p1, function(p1) --[[ Line: 123 | Upvalues: v1 (copy) ]]
			return p1.UUID == v1
		end, "Items")
		return v2 and v2.Id == 20220 and true or false
	else
		return false
	end
end
local function updatePickaxeAnimation(p1) --[[ updatePickaxeAnimation | Line: 134 | Upvalues: isPickaxeEquipped (copy), loadAnimations (copy), v2 (ref), v3 (ref) ]]
	if isPickaxeEquipped(p1) then
		loadAnimations()
		if v2 and not v2.IsPlaying then
			v2:Play()
		end
	else
		if v2 and v2.IsPlaying then
			v2:Stop()
		end
		if not (v3 and v3.IsPlaying) then
			return
		end
		v3:Stop()
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 143 | Upvalues: isPickaxeEquipped (copy), loadAnimations (copy), v2 (ref), v3 (ref), LocalPlayer (copy), v4 (ref) ]]
	p1:OnChange("EquippedId", function() --[[ Line: 144 | Upvalues: p1 (copy), isPickaxeEquipped (ref), loadAnimations (ref), v2 (ref), v3 (ref) ]]
		if isPickaxeEquipped(p1) then
			loadAnimations()
			if v2 and not v2.IsPlaying then
				v2:Play()
			end
		else
			if v2 and v2.IsPlaying then
				v2:Stop()
			end
			if not (v3 and v3.IsPlaying) then
				return
			end
			v3:Stop()
		end
	end)
	LocalPlayer.CharacterAdded:Connect(function() --[[ Line: 148 | Upvalues: v4 (ref), p1 (copy), isPickaxeEquipped (ref), loadAnimations (ref), v2 (ref), v3 (ref) ]]
		v4 = nil
		task.wait(0.5)
		if isPickaxeEquipped(p1) then
			loadAnimations()
			if v2 and not v2.IsPlaying then
				v2:Play()
			end
		else
			if v2 and v2.IsPlaying then
				v2:Stop()
			end
			if not (v3 and v3.IsPlaying) then
				return
			end
			v3:Stop()
		end
	end)
	if isPickaxeEquipped(p1) then
		loadAnimations()
		if v2 and not v2.IsPlaying then
			v2:Play()
		end
	else
		if v2 and v2.IsPlaying then
			v2:Stop()
		end
		if not (v3 and v3.IsPlaying) then
			return
		end
		v3:Stop()
	end
end)
v1.OnClientEvent:Connect(function() --[[ Line: 157 | Upvalues: loadAnimations (copy), v2 (ref), v3 (ref) ]]
	loadAnimations()
	if v2 and v2.IsPlaying then
		v2:Stop()
	end
	if not v3 then
		return
	end
	v3:Play()
	v3.Stopped:Once(function() --[[ Line: 111 | Upvalues: loadAnimations (ref), v2 (ref) ]]
		loadAnimations()
		if not v2 or v2.IsPlaying then
			return
		end
		v2:Play()
	end)
end)
return {}