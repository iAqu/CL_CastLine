-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PolicyInfoService = require(ReplicatedStorage.Modules.ServicesLoader.PolicyInfoService)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	Tag = ({
		Tag = Tags.PaidRandomItem
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 19 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Object = p1,
		Parent = p1.Parent,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.UpdateObject(p1) --[[ UpdateObject | Line: 31 | Upvalues: PolicyInfoService (copy), ReplicatedStorage (copy) ]]
	if PolicyInfoService.PolicyInfo.ArePaidRandomItemsRestricted then
		p1.Object.Parent = ReplicatedStorage
	elseif p1.Object.Parent ~= p1.Parent then
		p1.Object.Parent = p1.Parent
	end
end
function t._init(p1) --[[ _init | Line: 39 | Upvalues: Trove (copy), PolicyInfoService (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1.Trove = Trove.new()
		p1:UpdateObject()
		p1.Trove:Add(PolicyInfoService.PolicyChanged:Connect(function() --[[ Line: 47 | Upvalues: p1 (copy) ]]
			p1:UpdateObject()
		end))
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 52 ]]
	p1.Trove:Destroy()
end
return t