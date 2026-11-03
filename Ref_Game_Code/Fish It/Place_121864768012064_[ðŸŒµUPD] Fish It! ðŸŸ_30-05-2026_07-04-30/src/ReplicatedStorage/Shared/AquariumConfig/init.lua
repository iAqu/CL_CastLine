-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	AssetName = "Aquarium",
	DefaultZoneId = "Base",
	DefaultFishSize = "Medium",
	VisitLoadTimeout = 20,
	VisitSpawnCFrame = CFrame.new(0, 10000, 0),
	VisitPlotSpacing = 2500,
	VisitPlotColumns = 16,
	SizeRank = {
		Small = 1,
		Medium = 2,
		Large = 3,
		Huge = 4
	},
	Zones = require(script.Zones),
	Tanks = require(script.Tanks),
	TankOrder = {
		"Tank One",
		"Tank Two",
		"Tank Three",
		"Tank Four",
		"Tank Five",
		"Tank Six",
		"Tank Seven",
		"Tank Eight",
		"Tank Nine",
		"Tank Ten",
		"Tank Eleven",
		"Tank Twelve",
		"Tank Thirteen"
	},
	ZoneOrder = { "Area 1", "Area 2", "Area 3", "Area 4" }
}
local function getDefaultWeight(p1) --[[ getDefaultWeight | Line: 48 ]]
	local v1 = if p1 then p1.Weight else p1
	local v2 = if v1 then v1.Default else v1
	if v2 then
		return (v2.Min + v2.Max) * 0.5
	else
		return 0
	end
end
function t.GetFishSize(p1, p2) --[[ GetFishSize | Line: 58 ]]
	local v1
	if p2 and typeof(p2.Weight) == "number" then
		v1 = p2.Weight
	else
		local v2, v3
		v2 = if p1 then p1.Weight else p1
		v3 = if v2 then v2.Default else v2
		v1 = if v3 then (v3.Min + v3.Max) * 0.5 else 0
	end
	local v4 = if p1 and p1.Data then if typeof(p1.Data.Tier) == "number" then p1.Data.Tier else 1 else 1
	if v1 >= 1000 or v4 >= 7 and v1 >= 100 then
		return "Huge"
	end
	if v1 >= 30 or (v4 >= 7 or v4 >= 6 and v1 >= 10) then
		return "Large"
	end
	if v1 >= 5 or v4 >= 3 then
		return "Medium"
	else
		return "Small"
	end
end
function t.TankSupportsSize(p1, p2) --[[ TankSupportsSize | Line: 77 ]]
	for i, v in ipairs(p1.SupportedSizes) do
		if v == p2 then
			return true
		end
	end
	return false
end
function t.TankRequiredZonesUnlocked(p1, p2) --[[ TankRequiredZonesUnlocked | Line: 87 | Upvalues: t (copy) ]]
	local RequiredZones = p1.RequiredZones
	if not RequiredZones then
		return true
	end
	for i, v in ipairs(RequiredZones) do
		if v ~= t.DefaultZoneId and (not p2 or (not p2.UnlockedZones or p2.UnlockedZones[v] ~= true)) then
			return false
		end
	end
	return true
end
function t.IsDefaultTank(p1) --[[ IsDefaultTank | Line: 102 ]]
	return p1.UnlockCost <= 0
end
function t.GetDefaultTankIds() --[[ GetDefaultTankIds | Line: 106 | Upvalues: t (copy) ]]
	local t2 = {}
	local t3 = {}
	for i, v in ipairs(t.TankOrder) do
		local v1 = t.Tanks[v]
		if v1 and t.IsDefaultTank(v1) then
			table.insert(t2, v)
			t3[v] = true
		end
	end
	for k, v in pairs(t.Tanks) do
		if not t3[k] and t.IsDefaultTank(v) then
			table.insert(t2, k)
		end
	end
	return t2
end
return t