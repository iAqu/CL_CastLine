-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig)
local FertilizerConfig = require(ReplicatedStorage.Shared.Info.FertilizerConfig)
local RebirthConfig = require(ReplicatedStorage.Shared.Info.RebirthConfig)
local FarmersMarketConfig = require(ReplicatedStorage.Shared.Info.FarmersMarketConfig)
local FurnitureShopConfig = require(ReplicatedStorage.Shared.Info.FurnitureShopConfig)
local v1 = Knit.CreateController({
	Name = "RemoteConfigController"
})

local function apply(p1) --[[ apply | Line: 22 | Upvalues: HttpService (copy), SeedConfig (copy), FertilizerConfig (copy), RebirthConfig (copy), FurnitureShopConfig (copy), FarmersMarketConfig (copy) ]]
	if not p1 or p1 == "" then
		return
	end

	local ok, result = pcall(function() --[[ Line: 24 | Upvalues: HttpService (ref), p1 (copy) ]]
		return HttpService:JSONDecode(p1)
	end)

	if ok and type(result) == "table" then
		SeedConfig.ApplyCostOverrides(result.seeds)
		FertilizerConfig.ApplyOverrides(result.fertilizers)
		RebirthConfig.ApplyOverrides(result.rebirth)
		SeedConfig.ApplyWeightOverrides(result.weights)
		FurnitureShopConfig.ApplyPriceOverrides(result.furniture)
		FarmersMarketConfig.ApplyOverrides(result.market)
	end
end

function v1.KnitStart(p1) --[[ KnitStart | Line: 36 | Upvalues: ReplicatedStorage (copy), apply (copy) ]]
	local RemoteConfig = ReplicatedStorage:WaitForChild("RemoteConfig", 30)

	if RemoteConfig then
		apply(RemoteConfig.Value)
		RemoteConfig:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 40 | Upvalues: apply (ref), RemoteConfig (copy) ]]
			apply(RemoteConfig.Value)
		end)
	end
end

return v1