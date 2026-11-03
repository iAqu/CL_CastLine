-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teardown = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Teardown"))
return function(p1, p2) --[[ createTagEffect | Line: 8 | Upvalues: Teardown (copy), CollectionService (copy) ]]
	local t = {}
	local function onTagAdded(p12) --[[ onTagAdded | Line: 11 | Upvalues: p1 (copy), t (ref), Teardown (ref), p2 (copy) ]]
		if _G.DEBUG_TAG_EFFECT then
			local v1 = print
			local v2 = ("new instance \'%*\' tagged %*"):format(p12.Name, p1)
			v1(v2 .. (if p12.Parent then (" (%*)"):format((p12.Parent:GetFullName())) else ""))
		end
		local v5 = t[p1]
		if v5 == nil then
			v5 = {}
			t[p1] = v5
		end
		if v5[p12] ~= nil then
			Teardown.teardown(v5[p12])
			v5[p12] = nil
		end
		v5[p12] = p2(p12)
	end
	local v1 = CollectionService:GetInstanceAddedSignal(p1):Connect(onTagAdded)
	local v2 = CollectionService:GetInstanceRemovedSignal(p1):Connect(function(p12) --[[ Line: 35 | Upvalues: p1 (copy), t (ref), Teardown (ref) ]]
		if _G.DEBUG_TAG_EFFECT then
			print((("cleanup \'%*\' tagged %*"):format(p12.Name, p1)))
		end
		local v1 = t[p1]
		if not (v1 and v1[p12]) then
			return
		end
		Teardown.teardown(v1[p12])
		v1[p12] = nil
	end)
	for v3, v4 in CollectionService:GetTagged(p1) do
		xpcall(onTagAdded, function(p12) --[[ Line: 48 | Upvalues: p1 (copy), v4 (copy) ]]
			warn((("unable to apply tag \'%*\' on %* (%*): %*"):format(p1, v4.Name, v4:GetFullName(), p12)))
		end, v4)
	end
	return function() --[[ cleanEffect | Line: 55 | Upvalues: Teardown (ref), v1 (copy), v2 (copy), t (ref) ]]
		Teardown.teardown(v1, v2)
		for v12, v22 in t do
			Teardown.teardown(v22)
		end
		t = {}
	end
end