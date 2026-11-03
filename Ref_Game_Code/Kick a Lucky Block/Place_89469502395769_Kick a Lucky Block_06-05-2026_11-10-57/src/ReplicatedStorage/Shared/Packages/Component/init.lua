-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local CollectionService = game:GetService("CollectionService")
local t2 = {}
local function load(p1) --[[ load | Line: 26 | Upvalues: t2 (copy), CollectionService (copy) ]]
	local v1
	for v2, v3 in p1 do
		if v3:IsA("ModuleScript") then
			v1 = require(v3)
			local Tag = v1.Tag
			assert(Tag ~= nil, ("[ComponentManager] Module \'%s\' does not have a tag."):format(v3.Name))
			assert(if t2[Tag] == nil then true else false, ("[ComponentManager] Overlapping tag: \'%s\'"):format(Tag))
			local t = {}
			t2[Tag] = t
			local function component_added(p1) --[[ component_added | Line: 43 | Upvalues: v1 (ref), t (copy) ]]
				if not (p1:IsDescendantOf(game.StarterPack) or p1:IsDescendantOf(game.ReplicatedStorage)) then
					t[p1] = v1.new(p1)
				end
			end
			local function component_removed(p1) --[[ component_removed | Line: 51 | Upvalues: t (copy) ]]
				local v1 = t[p1]
				if v1 ~= nil then
					if v1.Destroy ~= nil then
						v1:Destroy()
					end
					t[p1] = nil
				end
			end
			CollectionService:GetInstanceAddedSignal(Tag):Connect(component_added)
			for i, v in ipairs(CollectionService:GetTagged(Tag)) do
				if not (v:IsDescendantOf(game.StarterPack) or v:IsDescendantOf(game.ReplicatedStorage)) then
					t[v] = v1.new(v)
				end
			end
			CollectionService:GetInstanceRemovedSignal(Tag):Connect(component_removed)
		end
	end
end
function t.Load(p1) --[[ Load | Line: 71 | Upvalues: load (copy) ]]
	if type(p1) ~= "table" then
		p1 = p1:GetDescendants()
	end
	load(p1)
end
return t