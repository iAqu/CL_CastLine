-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local v1 = Color3.fromRGB(120, 200, 255)
local v2 = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local t = {}
local t2 = {}
local t3 = {}
local v3 = nil
local function isPickaxeEquipped() --[[ isPickaxeEquipped | Line: 22 | Upvalues: v3 (ref), PlayerStatsUtility (copy) ]]
	if not v3 then
		return false
	end
	local v1 = v3:Get("EquippedId")
	if v1 and v1 ~= "" then
		local v2 = PlayerStatsUtility:GetItemFromInventory(v3, function(p1) --[[ Line: 32 | Upvalues: v1 (copy) ]]
			return p1.UUID == v1
		end, "Items")
		return v2 and v2.Id == 20220 and true or false
	else
		return false
	end
end
local function addCrystalEffects(p1) --[[ addCrystalEffects | Line: 43 | Upvalues: t2 (copy), Trove (copy), v1 (copy), TweenService (copy), v2 (copy), t (copy) ]]
	if t2[p1] then
		return
	end
	local v12 = Trove.new()
	t2[p1] = v12
	if not p1 then
		v12:Destroy()
		t2[p1] = nil
		return
	end
	local Highlight = Instance.new("Highlight")
	Highlight.FillColor = v1
	Highlight.OutlineColor = Color3.fromRGB(180, 140, 255)
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	Highlight.Parent = p1
	v12:Add(Highlight)
	local v22 = TweenService:Create(Highlight, v2, {
		FillTransparency = 0.8
	})
	v22:Play()
	v12:Add(function() --[[ Line: 72 | Upvalues: v22 (copy) ]]
		v22:Cancel()
	end)
	local PointLight = Instance.new("PointLight")
	PointLight.Color = v1
	PointLight.Brightness = 2
	PointLight.Range = 12
	PointLight.Parent = p1
	v12:Add(PointLight)
	local v3 = TweenService:Create(PointLight, v2, {
		Brightness = 0.8
	})
	v3:Play()
	v12:Add(function() --[[ Line: 88 | Upvalues: v3 (copy) ]]
		v3:Cancel()
	end)
	local v4 = p1:FindFirstChildWhichIsA("ProximityPrompt")
	if not v4 then
		return
	end
	local v5 = t
	table.insert(v5, v4)
	v4.Enabled = true
	v12:Add(function() --[[ Line: 97 | Upvalues: t (ref), v4 (copy) ]]
		local v1 = table.find(t, v4)
		if not v1 then
			return
		end
		table.remove(t, v1)
	end)
end
local function removeCrystalEffects(p1) --[[ removeCrystalEffects | Line: 106 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if not v1 then
		return
	end
	v1:Destroy()
	t2[p1] = nil
end
local function updateAllCrystalEffects() --[[ updateAllCrystalEffects | Line: 114 | Upvalues: isPickaxeEquipped (copy), t3 (copy), addCrystalEffects (copy), t2 (copy) ]]
	if isPickaxeEquipped() then
		for v1, v2 in t3 do
			addCrystalEffects(v1)
		end
	else
		for v3, v4 in t2 do
			local v5 = t2[v3]
			if v5 then
				v5:Destroy()
				t2[v3] = nil
			end
		end
	end
end
Observers.observeTag("GlowingCrystal", function(p1) --[[ Line: 128 | Upvalues: t3 (copy), isPickaxeEquipped (copy), addCrystalEffects (copy), t2 (copy) ]]
	t3[p1] = function() --[[ Line: 129 ]] end
	if isPickaxeEquipped() then
		addCrystalEffects(p1)
	end
	return function() --[[ Line: 135 | Upvalues: t3 (ref), p1 (copy), t2 (ref) ]]
		t3[p1] = nil
		local v1 = p1
		local v2 = t2[v1]
		if not v2 then
			return
		end
		v2:Destroy()
		t2[v1] = nil
	end
end, { workspace })
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 141 | Upvalues: v3 (ref), updateAllCrystalEffects (copy) ]]
	v3 = p1
	p1:OnChange("EquippedId", function() --[[ Line: 144 | Upvalues: updateAllCrystalEffects (ref) ]]
		updateAllCrystalEffects()
	end)
	p1:OnChange("Inventory", function() --[[ Line: 148 | Upvalues: updateAllCrystalEffects (ref) ]]
		updateAllCrystalEffects()
	end)
	updateAllCrystalEffects()
end)
return {}