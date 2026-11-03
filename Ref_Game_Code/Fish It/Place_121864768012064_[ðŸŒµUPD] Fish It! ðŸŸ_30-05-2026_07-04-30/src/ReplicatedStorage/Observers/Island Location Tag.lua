-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local spr = require(ReplicatedStorage.Packages.spr)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local v1 = Signal.new()
local LocalPlayer = Players.LocalPlayer
local t = { "Lost Isle", "Ancient Ruin", "Crystalline Passage", "Iron Cavern", "Iron Cafe", "Esoteric Depths" }
local v2 = false
LocalPlayer:GetAttributeChangedSignal("Loading"):Once(function() --[[ Line: 40 | Upvalues: v2 (ref) ]]
	v2 = true
end)
local v3 = false
LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 45 | Upvalues: v3 (ref), LocalPlayer (copy), v1 (copy) ]]
	v3 = LocalPlayer:GetAttribute("InCutscene")
	v1:Fire()
end)
local function GetTweenCollection(p1) --[[ GetTweenCollection | Line: 52 ]]
	local t = {
		ImageTransparency = {},
		TextTransparency = {},
		Transparency = {}
	}
	if p1:IsA("TextLabel") then
		table.insert(t.TextTransparency, p1)
	elseif p1:IsA("UIStroke") then
		table.insert(t.Transparency, p1)
	elseif p1:IsA("ImageLabel") then
		table.insert(t.ImageTransparency, p1)
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("TextLabel") then
			table.insert(t.TextTransparency, v)
			continue
		end
		if v:IsA("UIStroke") then
			table.insert(t.Transparency, v)
			continue
		end
		if v:IsA("ImageLabel") then
			table.insert(t.ImageTransparency, v)
		end
	end
	return t
end
local function HideTile(p1) --[[ HideTile | Line: 80 | Upvalues: GetTweenCollection (copy), v2 (ref), spr (copy) ]]
	local v22 = if v2 then function(p1, p2) --[[ Line: 85 | Upvalues: spr (ref) ]]
	spr.target(p2, 1, 2, {
		[p1] = 1
	})
end else function(p1, p2) --[[ Line: 91 ]]
	p2[p1] = 1
end
	for v3, v4 in GetTweenCollection(p1) do
		for i, v in ipairs(v4) do
			local v5 = ("Original%*"):format(v3)
			if not v:GetAttribute(v5) then
				v:SetAttribute(v5, v[v3])
			end
			v22(v3, v)
		end
	end
end
local function ShowTile(p1) --[[ ShowTile | Line: 110 | Upvalues: GetTweenCollection (copy), spr (copy) ]]
	for v1, v2 in GetTweenCollection(p1) do
		for i, v in ipairs(v2) do
			local v3 = v:GetAttribute((("Original%*"):format(v1)))
			if v3 then
				spr.target(v, 1, 2, {
					[v1] = v3
				})
			end
		end
	end
end
local function SetAnimationState(p1, p2) --[[ SetAnimationState | Line: 126 ]]
	if p1:GetAttribute("ClientAnimationState") ~= p2 then
		p1:SetAttribute("ClientAnimationState", p2)
	end
end
local function LocationChanged(p1) --[[ LocationChanged | Line: 135 | Upvalues: LocalPlayer (copy), Replion (copy), v3 (ref), t (copy) ]]
	local v1 = LocalPlayer:GetAttribute("LocationName")
	local v32 = Replion.Client:GetReplion("Data")
	local v4
	if v32 then
		local v5 = v32:GetExpect("CompletedQuests")
		local v6 = v32:GetExpect("Level")
		v4 = if table.find(v5, "Kohana Explorer") == nil and (table.find(v5, "Visit the Kohana Island!") == nil and table.find(v5, "Volcanic Fish") == nil) then v6 >= 10 else true
	else
		v4 = false
	end
	if v4 or (p1.Parent.Name == "Kohana" or p1:HasTag("AlwaysVisible")) then
		if p1:HasTag("AlwaysVisible") then
			if v3 or v1 and table.find(t, v1) then
				if p1:GetAttribute("ClientAnimationState") ~= "Hide" then
					p1:SetAttribute("ClientAnimationState", "Hide")
				end
			elseif p1:GetAttribute("ClientAnimationState") ~= "Show" then
				p1:SetAttribute("ClientAnimationState", "Show")
			end
		elseif v1 == "Ocean" and not v3 then
			if p1:GetAttribute("ClientAnimationState") ~= "Show" then
				p1:SetAttribute("ClientAnimationState", "Show")
			end
		elseif p1:GetAttribute("ClientAnimationState") ~= "Hide" then
			p1:SetAttribute("ClientAnimationState", "Hide")
		end
	elseif p1:GetAttribute("ClientAnimationState") ~= "Hide" then
		p1:SetAttribute("ClientAnimationState", "Hide")
	end
end
Observers.observeTag("Island Location Tag", function(p1) --[[ Line: 177 | Upvalues: LocalPlayer (copy), LocationChanged (copy), ShowTile (copy), HideTile (copy), v1 (copy) ]]
	local v12 = LocalPlayer:GetAttributeChangedSignal("LocationName"):Connect(function() --[[ Line: 178 | Upvalues: LocationChanged (ref), p1 (copy) ]]
		LocationChanged(p1)
	end)
	local v2 = p1:GetAttributeChangedSignal("ClientAnimationState"):Connect(function() --[[ Line: 182 | Upvalues: p1 (copy), ShowTile (ref), HideTile (ref) ]]
		(if p1:GetAttribute("ClientAnimationState") == "Show" then ShowTile else HideTile)(p1)
	end)
	local v3 = v1:Connect(function() --[[ Line: 189 | Upvalues: LocationChanged (ref), p1 (copy) ]]
		LocationChanged(p1)
	end)
	LocationChanged(p1)
	return function() --[[ Line: 195 | Upvalues: v3 (copy), v12 (copy), v2 (copy) ]]
		v3:Disconnect()
		v12:Disconnect()
		v2:Disconnect()
	end
end)
return {}