-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Teardown"))
return {
	findChildren = function(p1, p2) --[[ findChildren | Line: 9 ]]
		local t = {}
		for v2, v3 in if typeof(p2) == "table" and p2 then p2 else { p2 } do
			local v4 = p1:FindFirstChild(v3)
			if not v4 then
				break
			end
			table.insert(t, v4)
		end
		return unpack(t)
	end,
	findDescendants = function(p1, p2) --[[ findDescendants | Line: 26 ]]
		local t = {}
		for v2, v3 in if typeof(p2) == "table" and p2 then p2 else { p2 } do
			local v4 = p1:FindFirstChild(v3, true)
			if not v4 then
				break
			end
			table.insert(t, v4)
		end
		return unpack(t)
	end,
	setAttributeOnTaggedDescendants = function(p1, p2, p3, p4) --[[ setAttributeOnTaggedDescendants | Line: 43 | Upvalues: CollectionService (copy) ]]
		if CollectionService:HasTag(p1, p2) then
			p1:SetAttribute(p3, p4)
		end
		for v1, v2 in p1:GetDescendants() do
			if CollectionService:HasTag(v2, p2) then
				v2:SetAttribute(p3, p4)
			end
		end
	end,
	setAttributeOnDescendants = function(p1, p2, p3) --[[ setAttributeOnDescendants | Line: 55 ]]
		if p1:GetAttribute(p2) ~= nil then
			p1:SetAttribute(p2, p3)
		end
		for v1, v2 in p1:GetDescendants() do
			if v2:GetAttribute(p2) ~= nil then
				v2:SetAttribute(p2, p3)
			end
		end
	end
}