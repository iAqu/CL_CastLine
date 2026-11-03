-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Modules.Util.TableUtil)
local GamePass = require(ReplicatedStorage.Shared.GamePass)
require(ReplicatedStorage.Shared.GiftProducts)
local ItemProducts = require(ReplicatedStorage.Shared.Products.ItemProducts)
local Constants = require(ReplicatedStorage.Shared.Constants)
local WeeklyLimitedSetup = require(script.WeeklyLimitedSetup)
local function SoftError(p1, p2) --[[ SoftError | Line: 18 ]]
	if p1 then
		return
	end
	task.spawn(error, p2)
end
local function StudioWarn(p1) --[[ StudioWarn | Line: 24 | Upvalues: RunService (copy) ]]
	if not RunService:IsStudio() then
		return
	end
	warn((("[Studio Warning]: %*"):format(p1)))
end
print("=== Automatic Limited Setup ==")
local UnixTimestamp = DateTime.now().UnixTimestamp
for k, v in pairs(WeeklyLimitedSetup) do
	if v.currency == "gamePass" then
		if not (if v.attributes.GamePassId == nil then false else true) then
			task.spawn(error, "[Critical Error] Missing value: \"GamePassId\"")
		end
		local v2 = if GamePass[v.attributes.GamePassId] == nil then false else true
		local v3 = ("[Critical Error] Unable to register %* (%*) due to GamePassId missing!"):format(v.currency, k)
		if not v2 then
			task.spawn(error, v3)
		end
	end
	if v.currency == "product" then
		if not (if v.attributes.DevProductId == nil then false else true) then
			task.spawn(error, "[Critical Error] Missing value: \"DevProductId\"")
		end
		local v5 = if ItemProducts.Limiteds[v.attributes.DevProductId] == nil then false else true
		local v6 = ("[Critical Error] Unable to register %* (%*) due to DevProductId missing!"):format(v.currency, k)
		if not v5 then
			task.spawn(error, v6)
		end
	end
	local linkedFlag = v.linkedFlag
	local v7 = if linkedFlag then Constants.Flags[linkedFlag] else linkedFlag
	if v7 then
		WeeklyLimitedSetup[k].attributes.Expires = v7
	end
	if v7 then
		if v7 <= UnixTimestamp then
			task.spawn(error, (("[Critical Error] This product has expired!\nName: %*\nType: %*\nId:%*"):format(k, v.currency, v.attributes.GamePassId or v.attributes.ProductId or -1)))
			continue
		end
		if v7 - 86400 <= UnixTimestamp then
			local v11 = ("This product expires soon (%*)\nName: %*\nType: %*"):format(DateTime.fromUnixTimestamp(v7):FormatLocalTime("llll", "en-us"), k, v.currency)
			if RunService:IsStudio() then
				warn((("[Studio Warning]: %*"):format(v11)))
			end
		end
	end
	Observers.observeTag(k, function(p1) --[[ Line: 62 | Upvalues: v (copy) ]]
		for k, v2 in pairs(v.attributes) do
			p1:SetAttribute(k, v2)
		end
		for v1, v2 in v.tags do
			p1:AddTag(v2)
		end
		local v3 = if p1:IsA("ImageButton") then p1 else p1:WaitForChild("Buy")
		if not v3 then
			return
		end
		local v4 = if v.currency == "product" then "DevProductId" else "GamePassId"
		local v5 = if v.currency == "product" then "DevProductPrice" else "GamePassPrice"
		local v6 = v.attributes[v4]
		if not v6 then
			return
		end
		v3:SetAttribute(v4, v6)
		v3:AddTag(v5)
	end)
	Observers.observeTag(("%*Timer"):format(k), function(p1) --[[ Line: 87 | Upvalues: linkedFlag (copy) ]]
		p1:SetAttribute("MarkOffsale", true)
		if linkedFlag then
			p1:SetAttribute("LinkedFlag", linkedFlag)
		else
			p1:SetAttribute("Expires", 0)
		end
		p1:AddTag("DHMSLabel")
	end)
end
return {}