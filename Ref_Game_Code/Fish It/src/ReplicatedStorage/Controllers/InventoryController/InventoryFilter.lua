-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local t = {}
t.__index = t
function t.new() --[[ new | Line: 13 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2._searchText = ""
	v2._sortCallback = nil
	return v2
end
function t.SetSearchText(p1, p2) --[[ SetSearchText | Line: 22 ]]
	p1._searchText = string.lower(p2)
end
function t.GetSearchText(p1) --[[ GetSearchText | Line: 26 ]]
	return p1._searchText
end
function t.ClearSearch(p1) --[[ ClearSearch | Line: 30 ]]
	p1._searchText = ""
end
function t.SetSortCallback(p1, p2) --[[ SetSortCallback | Line: 34 ]]
	p1._sortCallback = p2
end
function t.GetSortCallback(p1) --[[ GetSortCallback | Line: 38 ]]
	return p1._sortCallback
end
function t.ClearSortCallback(p1) --[[ ClearSortCallback | Line: 42 ]]
	p1._sortCallback = nil
end
function t.ClearAll(p1) --[[ ClearAll | Line: 46 ]]
	p1._searchText = ""
	p1._sortCallback = nil
end
function t._passesSearch(p1, p2, p3) --[[ _passesSearch | Line: 52 | Upvalues: ItemUtility (copy), ReplicatedStorage (copy) ]]
	if p1._searchText == "" then
		return true
	end
	if string.find(if p3 and p3.Data then string.lower(p3.Data.Name or "") else "", p1._searchText, 1, true) then
		return true
	end
	if p2.Metadata and (typeof(p2.Metadata) == "table" and p2.Metadata.VariantId) then
		local v3 = ItemUtility:GetVariantData(p2.Metadata.VariantId)
		if v3 and v3.Data and string.find(string.lower(v3.Data.Name or ""), p1._searchText, 1, true) then
			return true
		end
	end
	if not (p3 and (p3.Data and p3.Data.Tier)) then
		return false
	end
	local v5 = require(ReplicatedStorage.Shared.TierUtility):GetTier(p3.Data.Tier)
	if not v5 then
		return false
	end
	if string.find(string.lower(v5.Name or ""), p1._searchText, 1, true) then
		return true
	else
		return false
	end
end
function t._passesSortCallback(p1, p2, p3) --[[ _passesSortCallback | Line: 94 ]]
	if p1._sortCallback then
		return p1._sortCallback(p2, p3)
	else
		return true
	end
end
function t.Passes(p1, p2, p3) --[[ Passes | Line: 103 ]]
	return p1:_passesSearch(p2, p3) and p1:_passesSortCallback(p2, p3)
end
function t.IsActive(p1) --[[ IsActive | Line: 108 ]]
	return if p1._searchText == "" then p1._sortCallback ~= nil else true
end
return t