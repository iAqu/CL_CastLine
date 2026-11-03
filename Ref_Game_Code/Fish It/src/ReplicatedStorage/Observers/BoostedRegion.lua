-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Marker = script:WaitForChild("Marker")
local v1 = Replion.Client:WaitReplion("Data")
local v2 = false
local list = {}
local v3 = Trove.new()
local function EnablePart(p1) --[[ EnablePart | Line: 25 | Upvalues: ItemUtility (copy), Marker (copy), TierUtility (copy), v3 (copy) ]]
	if p1.Name == "TreasureHuntRing" then
		p1.Transparency = 0
		p1.Attachment.Tag.Enabled = true
		return
	end
	local v1 = p1:FindFirstChildWhichIsA("Texture")
	if v1 then
		v1.Transparency = 0
	end
	local v2 = p1:FindFirstChildWhichIsA("SelectionBox")
	if v2 then
		v2.Visible = true
	end
	if p1:FindFirstChild("Marker") then
		return
	end
	local v32 = p1:GetAttribute("LuckyFish")
	if not v32 then
		return
	end
	local v4 = ItemUtility:GetItemData(v32)
	if not v4 then
		return
	end
	local v5 = Marker:Clone()
	v5.Frame.DisplayName.Text = v4.Data.Name
	local v6 = v4.Probability and TierUtility:GetTierFromRarity(v4.Probability.Chance)
	if v6 then
		v5.Frame.DisplayName.UIGradient.Color = v6.TierColor
		v5.Frame.DisplayName.Diamond.UIGradient.Color = v6.TierColor
	end
	v5.Parent = p1
	v3:Add(v5)
end
local function HidePart(p1) --[[ HidePart | Line: 66 ]]
	if p1.Name == "TreasureHuntRing" then
		p1.Transparency = 1
		p1.Attachment.Tag.Enabled = false
		return
	end
	local v1 = p1:FindFirstChildWhichIsA("Texture")
	if v1 then
		v1.Transparency = 1
	end
	local v2 = p1:FindFirstChildWhichIsA("SelectionBox")
	if v2 then
		v2.Visible = false
	end
	local Marker = p1:FindFirstChild("Marker")
	if not Marker then
		return
	end
	Marker:Destroy()
end
local function OnRegionVisibilityChanged(p1) --[[ OnRegionVisibilityChanged | Line: 89 | Upvalues: v2 (ref), EnablePart (copy), HidePart (copy), list (copy), v3 (copy) ]]
	v2 = p1
	local v1 = if p1 then EnablePart else HidePart
	for i, v in ipairs(list) do
		v1(v)
	end
	if p1 then
		return
	end
	v3:Clean()
end
Observers.observeTag("FishingRadarRegion", function(p1) --[[ Line: 102 | Upvalues: v2 (ref), EnablePart (copy), list (copy), HidePart (copy) ]]
	if v2 then
		EnablePart(p1)
		table.insert(list, p1)
	else
		HidePart(p1)
		table.insert(list, p1)
	end
	return function() --[[ Line: 111 | Upvalues: list (ref), p1 (copy) ]]
		local v1 = table.find(list, p1)
		if not v1 then
			return
		end
		table.remove(list, v1)
	end
end)
v1:OnChange("RegionsVisible", OnRegionVisibilityChanged)
v2 = false
local v4 = HidePart
for i, v in ipairs(list) do
	v4(v)
end
v3:Clean()
return {}