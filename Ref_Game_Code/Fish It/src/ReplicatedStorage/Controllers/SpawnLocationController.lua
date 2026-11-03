-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local DialogueController = require(ReplicatedStorage.Controllers.DialogueController)
local v1 = nil
local Areas = require(ReplicatedStorage.Areas)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
require(ReplicatedStorage.Shared.Soundbook)
local PlayerGui = Players.LocalPlayer.PlayerGui
local v2 = nil
local SpawnLocations = PlayerGui:WaitForChild("SpawnLocations")
local v3 = PlayerGui:WaitForChild("Archaeologist Quest")
local Areas_2 = SpawnLocations.Main.Inside.Areas
local Tile = Areas_2.Tile
Tile.Parent = nil
local v4 = Net:RemoteEvent("SetSpawn")
local v5 = Signal.new()
local t = {}
function t.Start(p1) --[[ Start | Line: 42 | Upvalues: v2 (ref), Replion (copy), v1 (ref), ReplicatedStorage (copy), GuiControl (copy), SpawnLocations (copy), t (copy), v3 (copy), v5 (copy), TableUtil (copy), DialogueController (copy), AreaUtility (copy) ]]
	v2 = Replion.Client:WaitReplion("Data")
	v1 = require(ReplicatedStorage.Controllers.TextNotificationController)
	local v12 = nil
	v12 = GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 49 | Upvalues: SpawnLocations (ref), v12 (ref), t (ref) ]]
		if p1 ~= SpawnLocations then
			return
		end
		v12:Disconnect()
		t:_build()
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 57 | Upvalues: v3 (ref), t (ref) ]]
		if p1 ~= v3 then
			return
		end
		t:Update()
	end)
	v5:Connect(function() --[[ Line: 62 | Upvalues: t (ref) ]]
		t:Update()
	end)
	v2:OnChange("CaughtFishMastery", function(p1, p2) --[[ Line: 66 | Upvalues: TableUtil (ref), v5 (ref) ]]
		if not (TableUtil.Count(p1) > TableUtil.Count(p2)) then
			return
		end
		v5:Fire()
	end)
	DialogueController:ObservePath("Archaeologist", 1, function(p1) --[[ Line: 75 | Upvalues: AreaUtility (ref), v2 (ref), GuiControl (ref) ]]
		if p1 ~= 2 then
			return
		end
		if AreaUtility:AreaUnlocked(v2, "Pirate Cove") then
			return
		end
		GuiControl:Open("Archaeologist Quest")
	end)
end
function t._build(p1) --[[ _build | Line: 87 | Upvalues: Areas (copy), Tile (copy), GuiControl (copy), AreaUtility (copy), v2 (ref), v4 (copy), v1 (ref), v5 (copy), Areas_2 (copy), t (copy) ]]
	for k, v in pairs(Areas) do
		if not v.Hidden and (not v.NoDisplay and v.SpawnLocation) then
			local v12 = Tile:Clone()
			local Info = v12.Info
			local Spawn = v12.Spawn
			local BarFrame = v12.Info.BarFrame
			Info.DefaultIsland.Visible = v.DefaultLocation
			v12.Vector.Image = v.Cover or ""
			Info.Island.Text = k
			Spawn.Island.Text = k
			GuiControl:Hook("Hold Button", v12).Clicked:Connect(function() --[[ Line: 112 | Upvalues: AreaUtility (ref), v2 (ref), k (copy), v4 (ref), v1 (ref) ]]
				if AreaUtility:AreaUnlocked(v2, k) then
					v4:FireServer(k)
				else
					v1:DeliverNotification({
						Type = "Text",
						Text = "You must complete the index for this area first!",
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
				end
			end)
			local function refreshOrder() --[[ refreshOrder | Line: 127 | Upvalues: v2 (ref), Info (copy), v (copy), k (copy), Spawn (copy), v12 (copy) ]]
				local v1 = v2:GetExpect("SavedLocation")
				Info.DefaultIsland.Visible = v.DefaultLocation
				Info.Visible = v1 ~= k
				Spawn.Visible = v1 == k
				v12.LayoutOrder = if v1 == k then -100000 else v.Order
			end
			local function refreshTile() --[[ refreshTile | Line: 136 | Upvalues: AreaUtility (ref), v2 (ref), k (copy), v (copy), BarFrame (copy) ]]
				local v1 = AreaUtility:GetAreaCompletion(v2, k)
				local v22 = if v1.Min > 0 and v1.Max > 0 then v1.Min / v1.Max else 0
				local v3 = if v.DefaultLocation then "Default Location" else "%d%% (%d / %d)"
				if v.DefaultLocation then
					BarFrame.Visible = false
				else
					BarFrame.Progress.Text = v3:format(v22 * 100, v1.Min, v1.Max)
					BarFrame.Bar.Size = UDim2.fromScale(v22, 0.8)
					BarFrame.Visible = true
				end
			end
			v5:Connect(refreshTile)
			refreshTile()
			v2:OnChange("SavedLocation", refreshOrder)
			local v22 = v2:GetExpect("SavedLocation")
			Info.DefaultIsland.Visible = v.DefaultLocation
			Info.Visible = v22 ~= k
			Spawn.Visible = if v22 == k then true else false
			v12.LayoutOrder = if v22 == k then -100000 else v.Order
			v12.Parent = Areas_2
		end
	end
	t:Update()
end
function t.Update(p1) --[[ Update | Line: 173 | Upvalues: v3 (copy), AreaUtility (copy), v2 (ref) ]]
	local Tile = v3.Main.Inside.Areas.Tile
	local Info = Tile.Info
	local Spawn = Tile.Spawn
	local BarFrame = Tile.Info.BarFrame;
	(function() --[[ refreshTile | Line: 179 | Upvalues: AreaUtility (ref), v2 (ref), BarFrame (copy) ]]
		local v1 = AreaUtility:GetAreaCompletion(v2, "Pirate Cove")
		local v22 = if v1.Min > 0 and v1.Max > 0 then v1.Min / v1.Max else 0
		BarFrame.Progress.Text = ("%d%% (%d / %d)"):format(v22 * 100, v1.Min, v1.Max)
		BarFrame.Bar.Size = UDim2.fromScale(v22, 0.8)
	end)()
end
return t