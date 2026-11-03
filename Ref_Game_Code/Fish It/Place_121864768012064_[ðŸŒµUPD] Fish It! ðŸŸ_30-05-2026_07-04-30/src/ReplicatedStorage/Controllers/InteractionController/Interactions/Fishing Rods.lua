-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local Constants = require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
local v1 = nil
local CurrentCamera = workspace.CurrentCamera
local Indicator = Players.LocalPlayer.PlayerGui:WaitForChild("Indicator")
local Zones = workspace:WaitForChild("Zones")
local Islands = workspace:WaitForChild("Islands")
local Vehicles = workspace:WaitForChild("Vehicles")
local Map = workspace:WaitForChild("Map")
local t = {}
local t2 = {}
local v2 = RaycastParams.new()
v2.IgnoreWater = true
v2.RespectCanCollide = false
v2.FilterType = Enum.RaycastFilterType.Include
local function redrawInstances() --[[ redrawInstances | Line: 32 | Upvalues: v2 (copy), Zones (copy), Islands (copy), Map (copy), Vehicles (copy) ]]
	v2.FilterDescendantsInstances = { Zones, Islands, Map, Vehicles }
end
local function addInstance(p1) --[[ addInstance | Line: 36 | Upvalues: v2 (copy) ]]
	v2:AddToFilter(p1)
end
Map.ChildAdded:Connect(addInstance)
Map.ChildRemoved:Connect(redrawInstances)
Islands.ChildAdded:Connect(addInstance)
Islands.ChildRemoved:Connect(redrawInstances)
Zones.ChildAdded:Connect(addInstance)
Zones.ChildRemoved:Connect(redrawInstances)
Vehicles.ChildAdded:Connect(addInstance)
Vehicles.ChildRemoved:Connect(redrawInstances)
v2.FilterDescendantsInstances = { Zones, Islands, Map, Vehicles }
local t3 = {
	Priority = 1,
	ShowVisual = false,
	State = {
		Ray = nil,
		RaycastResult = nil
	}
}
function t3.GetState(p1) --[[ GetState | Line: 64 | Upvalues: TableUtil (copy), t3 (copy) ]]
	return TableUtil.Lock(TableUtil.Copy(t3.State))
end
function t3.CanRaycast(p1) --[[ CanRaycast | Line: 68 ]]
	return true
end
function t3.GetParams(p1) --[[ GetParams | Line: 72 | Upvalues: v2 (copy) ]]
	return v2
end
function t3.GetRay(p1, p2, p3) --[[ GetRay | Line: 76 | Upvalues: CurrentCamera (ref), Constants (copy) ]]
	local v1 = CurrentCamera:ViewportPointToRay(p2.X, p2.Y)
	return {
		Origin = v1.Origin,
		Direction = v1.Direction * Constants.FishingDistance
	}
end
function t3.Success(p1, p2, p3) --[[ Success | Line: 85 | Upvalues: t2 (copy) ]]
	for i, v in ipairs(t2) do
		v(p2, p3)
	end
end
function t3.Exception(p1) --[[ Exception | Line: 91 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		v()
	end
end
function t3.AddException(p1, p2) --[[ AddException | Line: 97 | Upvalues: t (copy) ]]
	table.insert(t, p2)
end
function t3.AddSuccess(p1, p2) --[[ AddSuccess | Line: 101 | Upvalues: t2 (copy) ]]
	table.insert(t2, p2)
end
function t3.Start(p1) --[[ Start | Line: 105 | Upvalues: v1 (ref), Replion (copy), CurrentCamera (ref), t3 (copy), Zones (copy), Indicator (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	CurrentCamera = workspace.CurrentCamera
	t3:AddException(function() --[[ Line: 110 | Upvalues: t3 (ref) ]]
		t3.ShowVisual = false
	end)
	t3:AddSuccess(function(p1, p2) --[[ Line: 114 | Upvalues: t3 (ref), Zones (ref), Indicator (ref) ]]
		t3.ShowVisual = p2.Instance:IsDescendantOf(Zones)
		Indicator.Box.Horizontal.Visible = t3.ShowVisual
	end)
end
return t3