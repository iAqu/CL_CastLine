-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DisplayedTimerController = require(ReplicatedStorage.Modules.ControllerLoader.DisplayedTimerController)
local TimedUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TimedUpgradesServiceClient)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local WeightServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WeightServiceClient)
local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local TimedUpgradesData = require(ReplicatedStorage.Shared.Data.TimedUpgradesData)
local t = {}
function InitWeight() --[[ InitWeight | Line: 21 | Upvalues: WeightServiceClient (copy), DisplayedTimerController (copy) ]]
	local Multipliers = WeightServiceClient.Multipliers
	local EndTimes = WeightServiceClient.EndTimes
	local t = {
		Weight = {
			Name = "Weight Power",
			ImageId = "rbxassetid://84098473968775",
			Description = function(p1) --[[ Description | Line: 28 ]]
				return ("x%* Lift Power Multiplier"):format(p1)
			end
		},
		Speed = {
			Name = "Weight Speed",
			ImageId = "rbxassetid://92261796402719",
			Description = function(p1) --[[ Description | Line: 36 ]]
				return ("x%* Lift Speed Multiplier"):format(p1)
			end
		}
	}
	local function OnMultiUpdate() --[[ OnMultiUpdate | Line: 43 | Upvalues: WeightServiceClient (ref), t (copy), DisplayedTimerController (ref), Multipliers (ref), EndTimes (ref) ]]
		local Multipliers_2 = WeightServiceClient.Multipliers
		for k, v in pairs(Multipliers_2) do
			if t[k] then
				local v1 = WeightServiceClient.EndTimes[k]
				local v2 = t[k].Name
				if v == 1 then
					DisplayedTimerController:RemoveTimer(v2)
				end
				if v ~= Multipliers[k] or v1 ~= EndTimes[k] then
					DisplayedTimerController:AddTimer({
						Name = v2,
						EndTime = v1,
						ImageId = t[k].ImageId,
						Description = t[k].Description(v)
					})
				end
			end
		end
		Multipliers = Multipliers_2
		EndTimes = WeightServiceClient.EndTimes
	end
	WeightServiceClient.MultiplierChanged:Connect(OnMultiUpdate)
end
function InitSpeed() --[[ InitSpeed | Line: 77 | Upvalues: SpeedServiceClient (copy), DisplayedTimerController (copy) ]]
	local Multiplier = SpeedServiceClient.Multiplier
	local EndTime = SpeedServiceClient.EndTime
	local function OnMultiUpdate() --[[ OnMultiUpdate | Line: 81 | Upvalues: SpeedServiceClient (ref), DisplayedTimerController (ref), Multiplier (ref), EndTime (ref) ]]
		local Multiplier_2 = SpeedServiceClient.Multiplier
		local EndTime_2 = SpeedServiceClient.EndTime
		if Multiplier_2 == 1 then
			DisplayedTimerController:RemoveTimer("Run Speed")
		elseif Multiplier_2 ~= Multiplier or EndTime_2 ~= EndTime then
			DisplayedTimerController:AddTimer({
				Name = "Run Speed",
				ImageId = "rbxassetid://86964499984867",
				EndTime = EndTime_2,
				Description = ("x%* Run Speed Multiplier"):format(Multiplier_2)
			})
		end
		Multiplier = Multiplier_2
		EndTime = EndTime_2
	end
	SpeedServiceClient.MultiplierChanged:Connect(OnMultiUpdate)
end
function InitKick() --[[ InitKick | Line: 103 | Upvalues: KickServiceClient (copy), DisplayedTimerController (copy) ]]
	local Multipliers = KickServiceClient.Multipliers
	local EndTimes = KickServiceClient.EndTimes
	local t = {
		Power = {
			Name = "Kick Power",
			ImageId = "rbxassetid://135296567981241",
			Description = function(p1) --[[ Description | Line: 110 ]]
				return ("x%* Kick Power Multiplier"):format(p1)
			end
		},
		Speed = {
			Name = "Kick Speed",
			ImageId = "rbxassetid://101802765774081",
			Description = function(p1) --[[ Description | Line: 118 ]]
				return ("x%* Kick Speed Multiplier"):format(p1)
			end
		}
	}
	local function OnMultiUpdate() --[[ OnMultiUpdate | Line: 125 | Upvalues: KickServiceClient (ref), t (copy), DisplayedTimerController (ref), Multipliers (ref), EndTimes (ref) ]]
		local Multipliers_2 = KickServiceClient.Multipliers
		for k, v in pairs(Multipliers_2) do
			if t[k] then
				local v1 = KickServiceClient.EndTimes[k]
				local v2 = t[k].Name
				if v == 1 then
					DisplayedTimerController:RemoveTimer(v2)
				end
				if v ~= Multipliers[k] or v1 ~= EndTimes[k] then
					DisplayedTimerController:AddTimer({
						Name = v2,
						EndTime = v1,
						ImageId = t[k].ImageId,
						Description = t[k].Description(v)
					})
				end
			end
		end
		Multipliers = Multipliers_2
		EndTimes = KickServiceClient.EndTimes
	end
	KickServiceClient.MultiplierChanged:Connect(OnMultiUpdate)
end
function InitCash() --[[ InitCash | Line: 159 | Upvalues: ClientBalanceService (copy), DisplayedTimerController (copy) ]]
	local Multiplier = ClientBalanceService.Multiplier
	local EndTime = ClientBalanceService.EndTime
	local function OnMultiUpdate() --[[ OnMultiUpdate | Line: 163 | Upvalues: ClientBalanceService (ref), DisplayedTimerController (ref), Multiplier (ref), EndTime (ref) ]]
		local Multiplier_2 = ClientBalanceService.Multiplier
		local EndTime_2 = ClientBalanceService.EndTime
		if Multiplier_2 == 1 then
			DisplayedTimerController:RemoveTimer("Cash")
		elseif Multiplier_2 ~= Multiplier or EndTime_2 ~= EndTime then
			DisplayedTimerController:AddTimer({
				Name = "Cash",
				ImageId = "rbxassetid://106254793390209",
				EndTime = EndTime_2,
				Description = ("x%* Cash Multiplier"):format(Multiplier_2)
			})
		end
		Multiplier = Multiplier_2
		EndTime = EndTime_2
	end
	ClientBalanceService.MultiplierChanged:Connect(OnMultiUpdate)
end
function InitTimedUpgrades() --[[ InitTimedUpgrades | Line: 185 | Upvalues: TimedUpgradesData (copy), TimedUpgradesServiceClient (copy), DisplayedTimerController (copy) ]]
	local function OnNewTable(p1) --[[ OnNewTable | Line: 186 | Upvalues: TimedUpgradesData (ref), TimedUpgradesServiceClient (ref), DisplayedTimerController (ref) ]]
		for k, v in pairs(p1) do
			local v1 = TimedUpgradesData.Index[k]
			if v1 then
				local v2 = TimedUpgradesServiceClient:GetMultiplierForType(k)
				local v3 = 0
				for k2, v4 in pairs(v) do
					if v3 < v4 then
						v3 = v4
					end
				end
				local MultiplierName = v1.MultiplierName
				if v2 == 1 then
					DisplayedTimerController:RemoveTimer(MultiplierName)
				end
				DisplayedTimerController:AddTimer({
					Name = ("x%* %*"):format(v2, MultiplierName),
					EndTime = v3,
					ImageId = v1.Image,
					Description = v1.Description
				})
			end
		end
	end
	OnNewTable(TimedUpgradesServiceClient.Multipliers)
	TimedUpgradesServiceClient.NewTable:Connect(OnNewTable)
end
function Initialize() --[[ Initialize | Line: 220 ]]
	InitTimedUpgrades()
	InitWeight()
	InitKick()
	InitSpeed()
	InitCash()
end
function t._init(p1) --[[ _init | Line: 229 ]]
	Initialize()
end
return t