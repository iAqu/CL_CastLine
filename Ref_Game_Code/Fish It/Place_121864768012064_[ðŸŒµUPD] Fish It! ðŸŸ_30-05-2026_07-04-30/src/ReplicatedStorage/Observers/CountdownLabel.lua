-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Observers)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Constants = require(ReplicatedStorage.Shared.Constants)
local function GetDHMS(p1) --[[ GetDHMS | Line: 9 ]]
	local v1 = p1 % 86400
	return math.floor(p1 / 86400), math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), math.floor(p1 % 60)
end
Thread:Execute(2, function() --[[ Line: 20 | Upvalues: CollectionService (copy), Constants (copy) ]]
	local v1 = workspace:GetServerTimeNow()
	for i, v in ipairs((CollectionService:GetTagged("DHMSLabel"))) do
		local v3
		local v4 = v:GetAttribute("LinkedFlag")
		local v5 = v:GetAttribute("MarkOffsale")
		local v6 = if v4 then Constants.Flags[v4] else nil
		if not v6 then
			v6 = v:GetAttribute("Expires")
		end
		if v6 then
			local v8 = math.max(v6 - v1, 0)
			if v5 and v8 == 0 then
				v3 = "OFFSALE!"
			else
				local v9 = v8 % 86400
				local v10 = math.floor(v8 / 86400)
				local v11 = math.floor(v9 / 3600)
				local v12 = math.floor(v9 % 3600 / 60)
				local v13 = math.floor(v8 % 60)
				local v14 = math.floor(v10)
				v3 = if v14 == 0 then ("%dH %dM %dS"):format(v11, v12, v13) else ("%dD %dH %dM %dS"):format(v14, v11, v12, v13)
			end
			v.Text = v3
		end
	end
	for i, v in ipairs((CollectionService:GetTagged("TimeLabel"))) do
		local v19 = math.max((v:GetAttribute("Expires") or 0) - v1, 0)
		local v20 = v19 % 86400
		v.Text = ("%d:%d:%d:%d"):format(math.floor(v19 / 86400), math.floor(v20 / 3600), math.floor(v20 % 3600 / 60), (math.floor(v19 % 60)))
	end
end)
return {}