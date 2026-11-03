-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Trove = require(ReplicatedStorage.Packages.Trove)
return {
	Init = function(p1) --[[ Init | Line: 12 | Upvalues: Players (copy), Trove (copy) ]]
		local Character = Players.LocalPlayer.Character
		if Character then
			local v1 = Trove.new()
			v1:Add(Character.ChildRemoved:Connect(function(p1) --[[ Line: 21 ]]
				if not p1:IsA("Model") then
					return
				end
				local isName = p1.Name == "!!!EQUIPPED_TOOL!!!"
			end))
			v1:Add(Character.ChildAdded:Connect(function(p1) --[[ Line: 27 ]]
				if not p1:IsA("Model") or (p1.Name ~= "!!!EQUIPPED_TOOL!!!" or p1:HasTag("FishingRod")) then
					return
				end
				local Highlight = Instance.new("Highlight")
				Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
				Highlight.FillColor = Color3.fromRGB(0, 0, 0)
				Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
				Highlight.FillTransparency = 1
				Highlight.OutlineTransparency = 0.7
				Highlight.Parent = p1
			end))
			Character.Destroying:Once(function() --[[ Line: 46 | Upvalues: v1 (copy) ]]
				v1:Destroy()
			end)
		end
	end
}