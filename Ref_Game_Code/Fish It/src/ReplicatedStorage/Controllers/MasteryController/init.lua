-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Shared.Soundbook)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Shared.ItemUtility)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
require(ReplicatedStorage.Shared.WeightRandom)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
local Items = require(ReplicatedStorage.Items)
local Areas = require(ReplicatedStorage.Areas)
local EventTags = require(ReplicatedStorage.Modules.EventTags)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local Device = require(ReplicatedStorage.Modules.Device)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local PresentTracking = require(script:WaitForChild("PresentTracking"))
local AssociatedAreas = require(script:WaitForChild("AssociatedAreas"))
local SpecialData = require(script:WaitForChild("SpecialData"))
require(script:WaitForChild("GlobalFish"))
local v1 = Net:RemoteFunction("ClaimPercentileReward")
local v2 = ItemUtility.GetItemDataFromItemType("Fishing Rods", "Overlord\'s Trident")
local v3 = nil
local LocalPlayer = Players.LocalPlayer
local v4 = RunService:IsStudio()
local v5 = Signal.new()
local v6 = UDim2.new(0, 100, 0, 100)
local v7 = Trove.new()
local v8 = "Mastery"
local v9 = Signal.new()
local v10 = Signal.new()
local v11 = true
local v12 = false
local v13 = false
local v14 = false
local v15 = Signal.new()
local v16 = Signal.new()
local v17 = "Fisherman Island"
local v18 = Signal.new()
local Mastery = LocalPlayer.PlayerGui:WaitForChild("Mastery")
local Left = Mastery.Main.Left
local Right = Mastery.Main.Right
local Areas_2 = Left.Inside.Areas
local Above = Right.Content.LeftContent.Top.Above
local Bar = Above.Progress.Inside.BarContent.Bar
local ItemList = Right.Content.LeftContent.ItemList
local RightContent = Right.Content.RightContent
local Mutations = RightContent.Inside.Mutations
local UndiscoveredMutations = RightContent.Inside.UndiscoveredMutations
local IndexProgressList = Right.Content.LeftContent.IndexProgressList
local AllTile = Left.Frame.AllTile
local SpecialTile = Left.Frame.SpecialTile
local ProgressMenu = Left.Frame.ProgressMenu
local Section = script:WaitForChild("Section")
local Objective = IndexProgressList.Objective
Objective.Parent = nil
local Tile = Areas_2.Tile
Tile.Parent = nil
local Weather = ItemList.Tile.WeatherOptions.Weather
Weather.Parent = nil
local WeatherOptions = ItemList.Tile.WeatherOptions
WeatherOptions.Parent = nil
local Tile_2 = ItemList.Tile
Tile_2.Parent = nil
local Tile_3 = Mutations.Tile
Tile_3.Parent = nil
local t = {}
local t2 = {}
local t3 = {}
local v19 = false
local v20 = nil
local t4 = {}
local t5 = {}
local function getObtainableFish() --[[ getObtainableFish | Line: 141 | Upvalues: AreaUtility (copy), Areas (copy) ]]
	local t = {}
	local v1 = AreaUtility:GetGlobalFish()
	if #v1 > 0 then
		for i, v in ipairs(v1) do
			table.insert(t, v)
		end
	end
	for v2, v3 in Areas do
		if not v3.NoDisplay then
			for v4, v5 in v3.Items do
				if not table.find(t, v5) then
					table.insert(t, v5)
				end
			end
		end
	end
	return t
end
local function getUnobtainableFish() --[[ getUnobtainableFish | Line: 168 | Upvalues: getObtainableFish (copy), ItemUtility (copy), SpecialData (copy) ]]
	local v1 = getObtainableFish()
	local t = {}
	for v2, v3 in ItemUtility:GetFishIdentifiers() do
		if table.find(v1, v3) == nil then
			table.insert(t, v3)
		end
	end
	for v4, v5 in SpecialData do
		for v6, v7 in v5 do
			if table.find(v1, v7) == nil then
				table.insert(t, v7)
			end
		end
	end
	return t
end
local function UpdateTileSize() --[[ UpdateTileSize | Line: 193 | Upvalues: Device (copy), v6 (ref), v5 (copy) ]]
	local ViewportSize = workspace.CurrentCamera.ViewportSize
	if Device:IsMobile() then
		local v2 = math.clamp(ViewportSize.X / 1.7 / 4 - 13, 50, 70)
		v6 = UDim2.fromOffset(v2, v2)
	else
		local v4 = math.clamp(ViewportSize.X / 1.7 / 5 - 13, 60, 130)
		v6 = UDim2.fromOffset(v4, v4)
	end
	v5:Fire()
end
local function RenderId(p1, p2, p3) --[[ RenderId | Line: 209 | Upvalues: t (copy), ItemUtility (copy), TierUtility (copy), t5 (copy), Tile_2 (copy), v4 (copy), StringLibrary (copy), WeatherOptions (copy), EventUtility (copy), Weather (copy), ToolTip (copy), GuiControl (copy) ]]
	if t[p1] then
		return
	end
	local v1 = ItemUtility:GetItemData(p1)
	if not v1 then
		return
	end
	local v2 = v1.Probability or v1.ForcedProbability
	if not v2 then
		return
	end
	p3.AreaFish = p3.AreaFish + 1
	local Type = v1.Data.Type
	local v42 = TierUtility:GetTierFromRarity(v2.Chance)
	local v5 = v42.TierColor.Keypoints[1].Value
	local v6 = if v1.Weight and v1.Weight.Default then t5:CanFishIt(v1.Weight.Default.Min) else true
	local v8 = Tile_2:Clone()
	v8.Name = p1
	t[p1] = v8
	v8.FishName.TextColor3 = v5
	v8.Vector.Image = v1.Data.Icon or ""
	if v4 then
		if v1.SellPrice then
			v8.FishName.DEV_SellPrice.Text = ("Price: %*"):format((StringLibrary:Shorten(v1.SellPrice)))
		else
			v8.FishName.DEV_SellPrice.Text = "Cannot Sell"
		end
		if v1.Probability then
			v8.FishName.DEV_Chance.Text = ("Chance: 1 / %*"):format((StringLibrary:Shorten(1 / v1.Probability.Chance)))
		else
			v8.FishName.DEV_Chance.Text = "Cannot Fish For"
		end
		v8.FishName.DEV_Chance.Visible = true
		v8.FishName.DEV_SellPrice.Visible = true
	end
	if v1.Events then
		local v9 = WeatherOptions:Clone()
		v9.Parent = v8
		for i, v in ipairs(v1.Events) do
			local v10 = EventUtility:GetEvent(v)
			if v10 then
				local v11 = Weather:Clone()
				v11.Vector.Image = v10.Icon or ""
				local v12 = ToolTip.observe(v11, nil, function() --[[ Line: 276 | Upvalues: v10 (copy) ]]
					return {
						Style = "Label",
						Text = v10.CatchDescription or ("Catch during: %*"):format(v10.Name)
					}
				end)
				v11.Destroying:Once(function() --[[ Line: 290 | Upvalues: v12 (copy) ]]
					v12()
				end)
				v11.Parent = v9
			end
		end
	end
	if p3.CaughtFishMastery[v1.Data.Name] then
		p3.OwnedAreaFish = p3.OwnedAreaFish + 1
		v8.UIStroke.Color = v5
		v8.Gradient.UIGradient.Color = v42.TierColor
		v8.FishName.Text = v1.Data.Name
	else
		if p2 then
			v8.UIStroke.Color = v5
			v8.Gradient.UIGradient.Color = v42.TierColor
			v8.Vector.ImageTransparency = 0.8
		else
			v8.UIStroke.Color = Color3.fromRGB(0, 0, 0)
			v8.Gradient.UIGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
			v8.Vector.ImageColor3 = Color3.fromRGB(0, 0, 0)
		end
		v8.FishName.Text = "???"
		v8.Blank.ImageColor3 = v5
		v8.Blank.Visible = false
	end
	if v1.Hidden then
		v8.Indicator.Visible = false
	else
		v8.Indicator.Visible = not v6
	end
	local v13 = GuiControl:Hook("Hold Button", v8)
	local v14 = v13.Clicked:Connect(function() --[[ Line: 337 | Upvalues: t5 (ref), p3 (copy), v1 (copy), p1 (copy) ]]
		t5:RequestItemInfo(p3.AreaName, v1.Data.Name, p1)
	end)
	v8.Destroying:Once(function() --[[ Line: 341 | Upvalues: v14 (copy), v13 (copy) ]]
		v14:Disconnect()
		v13:Destroy()
	end)
	v8.LayoutOrder = 100000000 - 100000000 * (1 / (1 / v2.Chance))
	v8.Parent = p3.Section.Scroll
end
local function CreateSection(p1, p2) --[[ CreateSection | Line: 351 | Upvalues: v3 (ref), Areas (copy), Section (copy), v6 (ref), v5 (copy), v7 (copy), ItemList (copy), RenderId (copy) ]]
	local v1 = v3:GetExpect("CaughtFishMastery")
	local v2 = Areas[p1]
	local v32 = if p2 then p2.BGColor else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
	local v4 = if p2 then p2.Order elseif v2 then v2.Order else -10
	local v52 = Section:Clone()
	v52.Top.UIGradient.Color = v32
	v52.Top.Title.UIGradient.Color = v32
	v52.Top.Title.Text = p1
	local v62 = v5:Connect(function() --[[ updateTile | Line: 365 | Upvalues: v52 (copy), v6 (ref) ]]
		v52.Scroll.UIGridLayout.CellSize = v6
	end)
	v52.Scroll.UIGridLayout.CellSize = v6
	v7:Add(function() --[[ Line: 372 | Upvalues: v62 (copy), v52 (copy) ]]
		v62:Disconnect()
		v52:Destroy()
	end)
	v52.LayoutOrder = v4
	v52.Parent = ItemList
	local t = {
		AreaFish = 0,
		OwnedAreaFish = 0,
		AreaName = p1,
		CaughtFishMastery = v1,
		Section = v52
	}
	return function(p1, p2) --[[ Line: 392 | Upvalues: RenderId (ref), t (copy) ]]
		RenderId(p1, p2, t)
	end, t
end
local function RenderArea(p1, p2, p3) --[[ RenderArea | Line: 397 | Upvalues: CreateSection (copy), SpecialData (copy) ]]
	local v1, v2 = CreateSection(p1, p3)
	for i, v in ipairs(p2) do
		v1(v, false)
	end
	local v3 = SpecialData[p1]
	if v3 then
		for i, v in ipairs(v3) do
			v1(v, false)
		end
	end
	return v2
end
local function modifyImageLabel(p1, p2) --[[ modifyImageLabel | Line: 414 ]]
	if p1 == "Fishing Rods" then
		p2.Position = UDim2.fromScale(0.5, 1)
		p2.AnchorPoint = Vector2.new(0.5, 1)
		p2.Size = UDim2.fromScale(2, 2)
	else
		p2.Position = UDim2.fromScale(0, 0)
		p2.AnchorPoint = Vector2.new(0, 0)
		p2.Size = UDim2.fromScale(1, 1)
	end
end
local function postMessage(p1, p2, p3) --[[ postMessage | Line: 426 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		TextColor = p2,
		Text = p1,
		CustomDuration = p3
	})
end
local function userSuccess(p1) --[[ userSuccess | Line: 435 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = nil,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		},
		Text = p1
	})
end
local function userError(p1) --[[ userError | Line: 439 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = nil,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		},
		Text = p1
	})
end
local function userWarn(p1) --[[ userWarn | Line: 443 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = nil,
		TextColor = {
			R = 255,
			G = 255,
			B = 0
		},
		Text = p1
	})
end
function t5.SetPage(p1, p2) --[[ SetPage | Line: 449 | Upvalues: v8 (ref), v9 (copy) ]]
	if v8 ~= p2 then
		v8 = p2
		v9:Fire()
	end
end
function t5.TogglePage(p1) --[[ TogglePage | Line: 458 | Upvalues: v8 (ref), t5 (copy) ]]
	t5:SetPage(if v8 == "Mastery" then "IndexProgress" else "Mastery")
end
function t5.UpdateCurrentArea(p1) --[[ UpdateCurrentArea | Line: 463 | Upvalues: LocalPlayer (copy), AssociatedAreas (copy), Areas (copy), v20 (ref), v17 (ref) ]]
	local v1 = LocalPlayer:GetAttribute("LocationName") or "Fisherman Island"
	local v2 = AssociatedAreas[v1]
	if v2 then
		v1 = v2
	end
	if Areas[v1] then
		v20 = v1
		v17 = v1
	else
		v17 = v20 or "Fisherman Island"
	end
end
function t5.Init(p1) --[[ Init | Line: 478 | Upvalues: t4 (ref), getUnobtainableFish (copy) ]]
	t4 = getUnobtainableFish()
end
function t5.Start(p1) --[[ Start | Line: 482 | Upvalues: v3 (ref), Replion (copy), v16 (copy), v18 (copy), v8 (ref), AreaUtility (copy), v10 (copy), GuiControl (copy), Mastery (copy), Device (copy), UpdateTileSize (copy), t2 (copy), Areas (copy), TextNotificationController (copy), Tile (copy), t5 (copy), Areas_2 (copy), AllTile (copy), SpecialTile (copy), ProgressMenu (copy), v17 (ref), Left (copy), spr (copy), v9 (copy), IndexProgressList (copy), ItemList (copy), Above (copy), v11 (ref) ]]
	v3 = Replion.Client:WaitReplion("Data")
	v3:OnArrayInsert("Locations", function(p1, p2) --[[ Line: 486 | Upvalues: v16 (ref) ]]
		v16:Fire(p2)
	end)
	v18:Connect(function() --[[ Line: 491 | Upvalues: p1 (copy) ]]
		p1:_destroyTiles()
		p1:_refreshMastery()
	end)
	v3:OnChange({ "Statistics", "FishCaught" }, function() --[[ Line: 496 | Upvalues: v8 (ref), AreaUtility (ref), v3 (ref), v10 (ref) ]]
		if v8 ~= "IndexProgress" then
			return
		end
		v10:Fire((AreaUtility:GetTotalAreaCompletion(v3)))
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p12) --[[ Line: 503 | Upvalues: Mastery (ref), p1 (copy), v8 (ref) ]]
		if p12 ~= Mastery then
			return
		end
		p1:UpdateCurrentArea()
		if v8 == "IndexProgress" then
			return
		end
		p1:_refreshMastery()
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p12) --[[ Line: 513 | Upvalues: Mastery (ref), v8 (ref), p1 (copy) ]]
		if p12 ~= Mastery or v8 == "IndexProgress" then
			return
		end
		p1:_destroyTiles()
	end)
	print("Device", Device:_getDevice())
	Device:RegisterDeviceChanged(UpdateTileSize)
	UpdateTileSize()
	local function discoverArea(p1) --[[ discoverArea | Line: 527 | Upvalues: t2 (ref), Areas (ref) ]]
		local v1 = t2[p1]
		if p1 == "Sisyphus Statue" or p1 == "Treasure Room" then
			v1.Label.Text = ("%* - Lost Isle"):format(p1)
		else
			v1.Label.Text = p1
		end
		v1.Vector.ImageColor3 = Color3.fromRGB(255, 255, 255)
		v1.Vector.Image = Areas[p1].Cover
	end
	local function hideArea(p1) --[[ hideArea | Line: 541 | Upvalues: t2 (ref), Areas (ref) ]]
		local v1 = t2[p1]
		local v2 = Areas[p1]
		if v2.ComingSoon then
			v1.Label.Text = "COMING SOON"
		elseif p1 == "Sisyphus Statue" or p1 == "Treasure Room" then
			v1.Label.Text = "??? - Lost Isle"
		else
			v1.Label.Text = "???"
		end
		v1.Vector.ImageColor3 = Color3.fromRGB(25, 25, 25)
		v1.Vector.Image = v2.Cover
	end
	v16:Connect(function(p1) --[[ Line: 559 | Upvalues: Areas (ref), TextNotificationController (ref) ]]
		if not Areas[p1] then
			return
		end
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Discovered new location!",
			TextColor = {
				R = 0,
				G = 255,
				B = 255
			}
		})
	end)
	for v1, v2 in Areas do
		if not (v2.Hidden or v2.NoDisplay) then
			local v32 = Tile:Clone()
			t2[v1] = v32
			v32.Label.TextColor3 = if v1 == "Winter Fest" then Color3.fromRGB(255, 76, 79) else Color3.fromRGB(255, 255, 255)
			GuiControl:Hook("Hold Button", v32, v32.Vector, -1).Clicked:Connect(function() --[[ Line: 586 | Upvalues: v2 (copy), t5 (ref), v1 (copy) ]]
				if v2.ComingSoon then
					return
				end
				if not t5:LocationUnlocked(v1) then
					return
				end
				t5:ChangeView(v1)
			end)
			if t5:LocationUnlocked(v1) then
				local v5 = t2[v1]
				if v1 == "Sisyphus Statue" or v1 == "Treasure Room" then
					v5.Label.Text = ("%* - Lost Isle"):format(v1)
				else
					v5.Label.Text = v1
				end
				v5.Vector.ImageColor3 = Color3.fromRGB(255, 255, 255)
				v5.Vector.Image = Areas[v1].Cover
			else
				local v7 = nil
				v7 = v16:Connect(function(p1) --[[ Line: 601 | Upvalues: v1 (copy), t5 (ref), v7 (ref), t2 (ref), Areas (ref) ]]
					if p1 ~= v1 or not t5:LocationUnlocked(p1) then
						return
					end
					v7:Disconnect()
					local v12 = t2[p1]
					if p1 == "Sisyphus Statue" or p1 == "Treasure Room" then
						v12.Label.Text = ("%* - Lost Isle"):format(p1)
					else
						v12.Label.Text = p1
					end
					v12.Vector.ImageColor3 = Color3.fromRGB(255, 255, 255)
					v12.Vector.Image = Areas[p1].Cover
				end)
				hideArea(v1)
			end
			v32.LayoutOrder = v2.Order
			v32.Parent = Areas_2
		end
	end
	GuiControl:Hook("Hold Button", AllTile, AllTile.Vector, -1).Clicked:Connect(function() --[[ Line: 615 | Upvalues: t5 (ref) ]]
		t5:ChangeView("All")
	end)
	GuiControl:Hook("Hold Button", SpecialTile, SpecialTile.Vector, -1).Clicked:Connect(function() --[[ Line: 619 | Upvalues: t5 (ref) ]]
		t5:ChangeView("Special")
	end)
	GuiControl:Hook("Hold Button", ProgressMenu, ProgressMenu.Vector, -1).Clicked:Connect(function() --[[ Line: 623 | Upvalues: t5 (ref) ]]
		t5:TogglePage()
	end)
	v18:Connect(function() --[[ Line: 627 | Upvalues: v17 (ref), Left (ref), AllTile (ref), spr (ref) ]]
		local v1 = v17
		local v2 = if v1 == "Special" then true else v1 == "All"
		local v3 = if v2 then 3 else 2
		local v4 = UDim2.new(math.floor(1 / v3 * 1000) / 1000, 0, 1, 0)
		local v5 = UDim2.new(v3 / 3, 0, 0.12, 0)
		Left.Frame.UIGridLayout.CellSize = v4
		AllTile.Visible = v2
		spr.stop(Left.Frame)
		spr.target(Left.Frame, 1, 3, {
			Size = v5
		})
	end)
	v9:Connect(function() --[[ Line: 652 | Upvalues: v8 (ref), IndexProgressList (ref), ItemList (ref), Above (ref) ]]
		local v1 = v8
		IndexProgressList.Visible = v1 == "IndexProgress"
		ItemList.Visible = v1 == "Mastery"
		Above.Progress.Visible = v1 == "Mastery"
	end)
	task.delay(3, function() --[[ Line: 660 | Upvalues: v11 (ref), p1 (copy) ]]
		if not v11 then
			return
		end
		v11 = false
		p1:_renderMasteryRewards()
	end)
end
function t5.LocationUnlocked(p1, p2) --[[ LocationUnlocked | Line: 669 | Upvalues: v4 (copy), v3 (ref) ]]
	if v4 then
		return true
	end
	return v3:Find("Locations", p2) ~= nil
end
function t5.ChangeView(p1, p2) --[[ ChangeView | Line: 677 | Upvalues: v17 (ref), v13 (ref), v18 (copy) ]]
	if p2 == v17 then
		return
	end
	if not v13 then
		v13 = true
		v17 = p2
		v18:Fire()
	end
end
function t5.CanFishIt(p1, p2) --[[ CanFishIt | Line: 692 | Upvalues: v3 (ref), PlayerStatsUtility (copy), ItemUtility (copy) ]]
	local v1 = v3:Get("EquippedItems")[1]
	if not v1 then
		return
	end
	local v2 = PlayerStatsUtility:GetItemFromInventory(v3, function(p1) --[[ Line: 700 | Upvalues: v1 (copy) ]]
		return p1.UUID == v1
	end)
	if not v2 then
		return
	end
	local v32 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v2.Id)
	if not v32 then
		return
	end
	if not v32.MaxWeight then
		return
	end
	local Metadata = v2.Metadata
	return p2 <= v32.MaxWeight + (Metadata and Metadata.Modifiers and Metadata.Modifiers.MaxWeight or 0 or 0)
end
function t5.PopulateItemInfo(p1, p2, p3) --[[ PopulateItemInfo | Line: 720 | Upvalues: ItemUtility (copy), v3 (ref), StringLibrary (copy), RightContent (copy), t4 (ref), TierUtility (copy), spr (copy), Tile_3 (copy), Mutations (copy), t3 (copy), UndiscoveredMutations (copy) ]]
	local v1 = ItemUtility:GetItemData(p3)
	if not v1 then
		return
	end
	local v2 = v1.Probability or v1.ForcedProbability
	if not v2 then
		return
	end
	local v32 = v3:GetExpect("CaughtFishMastery")
	local v4 = if v1.Data.Type == "Enchant Stones" then {
	Count = 1,
	Obtained = DateTime.now().UnixTimestamp,
	Mutations = {}
} else v32[v1.Data.Name]
	if v4 then
		RightContent.Inside.FishData.Rarity.Text = if v1.ForcedProbability then "1 in ??" else ("1 in %*"):format((StringLibrary:Shorten(math.round(1 / v2.Chance * 10) / 10)))
	else
		RightContent.Inside.FishData.Rarity.Text = "??"
	end
	local v8 = if table.find(t4, p3) then true else false
	local TimeOfDay = v1.TimeOfDay
	local Events = v1.Events
	RightContent.Inside.TimeCatch.Text = if TimeOfDay then ("Time: %02i:%02i -> %02i:%02i"):format(TimeOfDay.Min % 60, (TimeOfDay.Min - math.floor(TimeOfDay.Min)) * 100, TimeOfDay.Max % 60, (TimeOfDay.Max - math.floor(TimeOfDay.Max)) * 100) else "Any Time"
	RightContent.Inside.WeatherCatch.Text = if Events then ("Weather: %*"):format((table.concat(Events, ", "))) elseif v8 then "Unobtainable" else "Any Weather"
	local v15 = TierUtility:GetTierFromRarity(v2.Chance)
	local v16 = v15.TierColor.Keypoints[1].Value
	spr.stop(RightContent.Inside.FishData.UIStroke)
	spr.stop(RightContent.Inside.FishData.TierName)
	spr.stop(RightContent.Inside.FishData.Glow.UIGradient)
	spr.stop(RightContent.Inside.FishData.Gradient.UIGradient)
	RightContent.Inside.FishData.TierName.Text = v15.Name
	spr.target(RightContent.Inside.FishData.UIStroke, 1, 3, {
		Color = v16
	})
	spr.target(RightContent.Inside.FishData.TierName, 1, 3, {
		TextColor3 = v16
	})
	spr.target(RightContent.Inside.FishData.Glow.UIGradient, 1, 3, {
		Color = v15.TierColor
	})
	spr.target(RightContent.Inside.FishData.Gradient.UIGradient, 1, 3, {
		Color = v15.TierColor
	})
	local Weight = v1.Weight
	if Weight then
		local v17 = StringLibrary:AddWeight(Weight.Default.Min)
		local v18 = StringLibrary:AddWeight(Weight.Default.Max)
		local v19 = StringLibrary:AddWeight(Weight.Big.Min)
		RightContent.Inside.BigLabel.Text = ("Big: %* - %*"):format(v19, (StringLibrary:AddWeight(Weight.Big.Max)))
		RightContent.Inside.WeightLabel.Text = ("Weight: %* - %*"):format(v17, v18)
		RightContent.Inside.BigLabel.Visible = true
		RightContent.Inside.WeightLabel.Visible = true
	else
		RightContent.Inside.BigLabel.Visible = false
		RightContent.Inside.WeightLabel.Visible = false
	end
	if v4 then
		local v21 = if v4.Obtained then DateTime.fromUnixTimestamp(v4.Obtained):FormatLocalTime("L", "en-us") else "Not tracked!"
		RightContent.Inside.CountLabel.Text = ("%* Caught"):format(if v4.Count then v4.Count + 1 else 1)
		RightContent.Inside.CaughtLabel.Text = ("First Caught: %*"):format(v21)
	else
		RightContent.Inside.CountLabel.Text = "Not tracked!"
		RightContent.Inside.CaughtLabel.Text = "Not tracked!"
	end
	RightContent.Inside.FishData.Vector.Image = v1.Data.Icon or ""
	RightContent.Inside.FishData.Vector.ImageColor3 = if v4 then Color3.new(255/255, 255/255, 255/255) else Color3.new(0/255, 0/255, 0/255)
	if v4 then
		RightContent.Inside.FishName.Text = v1.Data.Name
	else
		RightContent.Inside.FishName.Text = "???"
	end
	if v4 then
		local v24 = v1.Variants or {}
		local v25 = v32[v1.Data.Name]
		if v25 and v25.Mutations then
			for v26, v27 in ItemUtility:CreateWeightedVariantTable(p2, v24, nil, nil, nil) do
				local v28 = ItemUtility:GetVariantData(v26)
				if v28 then
					local Probability = v28.Probability
					if Probability and v25.Mutations[v26] ~= nil then
						local _ = v28.Data.TierColor.Keypoints[1].Value
						local v29 = Tile_3:Clone()
						v29.ItemName.Text = v28.Data.Name
						v29.ItemName.UIGradient.Color = v28.Data.TierColor
						v29.UIGradient.Color = v28.Data.TierColor
						v29.LayoutOrder = 100000000 - 100000000 * (1 / (1 / Probability.Chance))
						v29.Parent = Mutations
						t3[v26] = v29
					end
				end
			end
		end
		UndiscoveredMutations.Visible = false
		Mutations.Visible = true
	elseif not v4 then
		UndiscoveredMutations.Visible = true
		Mutations.Visible = false
	end
	RightContent.Visible = true
end
function t5.RequestItemInfo(p1, p2, p3, p4) --[[ RequestItemInfo | Line: 887 ]]
	p1:_destroyItemInfo()
	p1:PopulateItemInfo(p2, p4)
end
function t5._renderMasteryRewards(p1) --[[ _renderMasteryRewards | Line: 892 | Upvalues: AreaUtility (copy), Objective (copy), GuiControl (copy), v3 (ref), TextNotificationController (copy), v1 (copy), CurrencyUtility (copy), StringLibrary (copy), ItemUtility (copy), TierUtility (copy), ReplicatedStorage (copy), modifyImageLabel (copy), v12 (ref), t5 (copy), v10 (copy), IndexProgressList (copy), UserPriority (copy), LocalPlayer (copy), Trove (copy), v2 (copy), PlayerStatsUtility (copy), PresentTracking (copy), v19 (ref) ]]
	for i = 1, 4 do
		local v13
		local v22 = AreaUtility:GetGlobalMilestoneRewards(i)
		if v22 then
			local v32 = ("Tile%*"):format(i)
			if not Objective:FindFirstChild(v32) then
				local v6 = ("Complete <b><font color=\"#%*\">%*%%</font></b> of the Index"):format(Color3.fromRGB(0, 255, 124):ToHex(), (math.ceil(v22.Percentile * 100)))
				v13 = if typeof(v22.Reward) == "table" and #v22.Reward >= 1 then v22.Reward else { v22.Reward }
				v7 = v32
				v8 = v6
				local v9 = Objective:Clone()
				local BottomFrame = v9.BottomFrame
				local ClaimButton = BottomFrame.ClaimButton
				if ClaimButton then
					GuiControl:Hook("Hold Button", ClaimButton).Clicked:Connect(function() --[[ Line: 918 | Upvalues: v3 (ref), i (copy), TextNotificationController (ref), v1 (ref) ]]
						if v3:Find("PercentileRewards", i) then
							TextNotificationController:DeliverNotification({
								Type = "Text",
								Text = "You already claimed this reward!",
								CustomDuration = nil,
								TextColor = {
									R = 255,
									G = 255,
									B = 0
								}
							})
							return
						end
						if v1:InvokeServer(i) then
							TextNotificationController:DeliverNotification({
								Type = "Text",
								Text = "Redeemed rewards!",
								CustomDuration = nil,
								TextColor = {
									R = 0,
									G = 255,
									B = 0
								}
							})
						else
							TextNotificationController:DeliverNotification({
								Type = "Text",
								Text = "Unable to claim reward!",
								CustomDuration = nil,
								TextColor = {
									R = 255,
									G = 0,
									B = 0
								}
							})
						end
					end)
				end
				for k, v in pairs(v13) do
					local v102
					local v11 = nil
					local v122 = nil
					local v132 = nil
					local v14 = nil
					local v15, v16, v17, v18, v192, v20, v21, v222
					if v.Type == "Currency" then
						local v23 = CurrencyUtility:GetCurrency(v.Name)
						if v23 then
							local v24 = StringLibrary:Shorten(v.Amount)
							v122 = v23.TextColor
							v132 = v23.Icon
							v14 = 5
							v11 = v24
						end
						v15 = ReplicatedStorage.Assets.UITemplates.RewardTemplate:Clone()
						v16 = nil
						if v.Quantity and v.Quantity > 1 then
							v17 = ("x%*"):format((StringLibrary:AddCommas(v.Quantity)))
							v16 = v17
						elseif v.Amount then
							v18 = StringLibrary:Shorten(v.Amount)
							v16 = v18
						end
						if v16 then
							v15.Quantity.Text = v16
							v15.Quantity.Visible = true
						end
						v192 = v15.UIStroke.UIGradient
						v20 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
						v192.Color = v20
						v21 = v15.Gradient.UIGradient
						v222 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
						v21.Color = v222
						v15.Box.ItemName.Text = v11 or "???"
						v15.Vector.Image = v132 or ""
						modifyImageLabel(v.Type, v15.Vector)
						v15.LayoutOrder = v14
						v15.Parent = v9.RewardFrame
					else
						local v25 = ItemUtility.GetItemDataFromItemType(v.Type, v.Identifier)
						if v25 then
							v102 = if v25.Probability then TierUtility:GetTierFromRarity(v25.Probability.Chance) else TierUtility:GetTier(v25.Data.Tier or 1)
							v132 = v25.Data.Icon
							v122 = v102.TierColor
							v11 = v25.Data.Name
							v14 = v102.Tier
							v15 = ReplicatedStorage.Assets.UITemplates.RewardTemplate:Clone()
							v16 = nil
							if v.Quantity and v.Quantity > 1 then
								v17 = ("x%*"):format((StringLibrary:AddCommas(v.Quantity)))
								v16 = v17
							elseif v.Amount then
								v18 = StringLibrary:Shorten(v.Amount)
								v16 = v18
							end
							if v16 then
								v15.Quantity.Text = v16
								v15.Quantity.Visible = true
							end
							v192 = v15.UIStroke.UIGradient
							v20 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
							v192.Color = v20
							v21 = v15.Gradient.UIGradient
							v222 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
							v21.Color = v222
							v15.Box.ItemName.Text = v11 or "???"
							v15.Vector.Image = v132 or ""
							modifyImageLabel(v.Type, v15.Vector)
							v15.LayoutOrder = v14
							v15.Parent = v9.RewardFrame
						end
					end
				end
				v9.Content.Prefix.Text = v8
				local function updateFrame(p1) --[[ updateFrame | Line: 997 | Upvalues: AreaUtility (ref), v3 (ref), i (copy), v22 (copy), ClaimButton (copy), BottomFrame (copy), v12 (ref), t5 (ref), v9 (copy) ]]
					local v1 = if p1 then p1 else AreaUtility:GetTotalAreaCompletion(v3)
					local v2 = if v3:Find("PercentileRewards", i) == nil then false else true
					if v2 then
						v1 = NumberRange.new(v1.Max, v1.Max)
					end
					local v5 = math.floor(v1.Max * v22.Percentile)
					local v6 = math.min(v1.Min, v5)
					if ClaimButton and v2 then
						BottomFrame.Visible = false
						ClaimButton.Visible = false
					elseif ClaimButton then
						local v8 = v5 <= v6
						BottomFrame.Visible = v8
						ClaimButton.Visible = v8
						if v12 and (v8 and i == 4) then
							t5:RefreshRewards(false)
						end
					end
					v9.BarFrame.Progress.Text = if v2 then ("CLAIMED! (%* / %*)"):format(v6, v5) else ("%* / %*"):format(v6, v5)
					v9.BarFrame.Bar.Size = UDim2.fromScale(v6 / v5 / 1, 0.8)
				end
				v10:Connect(updateFrame)
				TextNotificationController.NewlyIndexed:Connect(function() --[[ Line: 1039 | Upvalues: updateFrame (copy) ]]
					updateFrame()
				end)
				v3:OnArrayInsert("PercentileRewards", function() --[[ Line: 1042 | Upvalues: updateFrame (copy) ]]
					updateFrame()
				end)
				v3:OnArrayRemove("PercentileRewards", function() --[[ Line: 1045 | Upvalues: updateFrame (copy) ]]
					updateFrame()
				end)
				v9.Name = v7
				v9.LayoutOrder = i
				v9.Parent = IndexProgressList
			end
		end
	end
	task.defer(function() --[[ Line: 1056 | Upvalues: UserPriority (ref), LocalPlayer (ref), v12 (ref), t5 (ref), Trove (ref), v2 (ref), PlayerStatsUtility (ref), v3 (ref), PresentTracking (ref), v19 (ref) ]]
		if UserPriority:IsTradePlaza() then
			return
		end
		local v1, v22, v32, v4, v5
		if LocalPlayer:GetAttribute("Loading") then
			LocalPlayer:GetAttributeChangedSignal("Loading"):Wait()
		end
		game.UserInputService.InputEnded:Wait()
		v12 = true
		t5:RefreshRewards(true)
		v1 = Trove.new()
		v22 = function() --[[ CheckTracking | Line: 1072 | Upvalues: v2 (ref), PlayerStatsUtility (ref), v3 (ref), PresentTracking (ref), v1 (copy), v19 (ref), t5 (ref) ]]
			local v12 = if v2 then PlayerStatsUtility:GetItemFromInventory(v3, function(p1) --[[ Line: 1075 | Upvalues: v2 (ref) ]]
	return p1.Id == v2.Data.Id
end, "Fishing Rods") else nil
			if v12 then
				PresentTracking:Stop()
				v1:Clean()
				return
			end
			if not v19 then
				return
			end
			t5:RefreshRewards(false)
		end
		v32 = LocalPlayer:GetAttributeChangedSignal("LocationName"):Connect(function() --[[ Line: 1089 | Upvalues: v19 (ref), v22 (copy) ]]
			if not v19 then
				return
			end
			v22()
		end)
		v4 = v3:OnChange({ "Inventory", "Fishing Rods" }, function() --[[ Line: 1095 | Upvalues: v22 (copy) ]]
			v22()
		end)
		v5 = v3:OnChange("PercentileRewards", function() --[[ Line: 1099 | Upvalues: v22 (copy) ]]
			v22()
		end)
		v1:Add(function() --[[ Line: 1103 | Upvalues: v32 (copy), v4 (copy), v5 (copy) ]]
			v32:Disconnect()
			v4:Disconnect()
			v5:Disconnect()
		end)
	end)
	v10:Fire((AreaUtility:GetTotalAreaCompletion(v3)))
end
function t5.RefreshRewards(p1, p2) --[[ RefreshRewards | Line: 1115 | Upvalues: v3 (ref), AreaUtility (copy), LocalPlayer (copy), v2 (copy), PlayerStatsUtility (copy), PresentTracking (copy), v19 (ref), TextNotificationController (copy) ]]
	local v1 = v3:GetExpect("PercentileRewards")
	local v22 = AreaUtility:GetTotalAreaCompletion(v3)
	local v32 = false
	local v4 = false
	for i = 1, 4 do
		local v5 = AreaUtility:GetGlobalMilestoneRewards(i)
		if v5 and (i == 4 or not table.find(v1, i)) then
			if v22.Min < math.floor(v22.Max * v5.Percentile) then
				break
			end
			v4 = true
			v32 = if i >= 4 then true else false
		end
	end
	if v32 then
		local v7 = LocalPlayer:GetAttribute("LocationName")
		local v8 = if v7 == "Esoteric Depths" then "EsotericPath" else "OtherPath"
		local v9 = if v7 == "Esoteric Depths" then Vector3.new(3330.479, -1300.809, 1355.502) else Vector3.new(2073.353, -29.879, 1369.396)
		local v10 = if v2 then PlayerStatsUtility:GetItemFromInventory(v3, function(p1) --[[ Line: 1157 | Upvalues: v2 (ref) ]]
	return p1.Id == v2.Data.Id
end, "Fishing Rods") else nil
		if v10 then
			PresentTracking:Stop()
			v19 = false
		else
			PresentTracking:Stop()
			PresentTracking:Track(v8, CFrame.new(v9))
			v19 = true
		end
	else
		PresentTracking:Stop()
		v19 = false
	end
	if not (p2 and v4) then
		return
	end
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "You have pending rewards in the item mastery!",
		CustomDuration = 12,
		TextColor = {
			R = 0,
			G = 255,
			B = 255
		}
	})
end
function t5._refreshMastery(p1) --[[ _refreshMastery | Line: 1181 | Upvalues: v14 (ref), v15 (copy), t5 (copy), GuiControl (copy), ItemList (copy), v17 (ref), Areas (copy), RenderArea (copy), CreateSection (copy), TierUtility (copy), t4 (ref), EventTags (copy), Items (copy), AreaUtility (copy), spr (copy), Bar (copy), Above (copy), v13 (ref) ]]
	if v14 then
		v15:Wait()
	end
	t5:SetPage("Mastery")
	local v1 = GuiControl:Hook("Loading Spinner", ItemList)
	if v1 then
		ItemList.Visible = false
		v1:Init()
	end
	local v2 = v17
	local sum = 0
	local sum_2 = 0
	if v2 == "All" then
		for v3, v4 in Areas do
			if not (v4.ComingSoon or (v4.Hidden or v4.NoDisplay)) then
				local v5 = RenderArea(v3, v4.Items)
				sum = sum + v5.OwnedAreaFish
				sum_2 = sum_2 + v5.AreaFish
			end
		end
		local v6, _ = CreateSection("Special Fish", {
			Order = -800,
			BGColor = TierUtility:GetTier("SECRET").TierColor
		})
		for i, v in ipairs(t4) do
			v6(v, true)
		end
	else
		local v7 = Areas[v2]
		if v7 then
			local v8 = RenderArea(v2, v7.Items)
			sum = sum + v8.OwnedAreaFish
			sum_2 = sum_2 + v8.AreaFish
		end
	end
	if v2 == "Special" then
		for k, v in pairs(EventTags) do
			local t = {}
			for k2, v3 in pairs(Items) do
				if v3.EventTag == k then
					table.insert(t, v3.Data.Name)
				end
			end
			if #t > 0 then
				local v10 = RenderArea(v.Name, t, {
					Order = -(v.ObtainDates.Max // 86400),
					BGColor = v.TierColor
				})
				sum = sum + v10.OwnedAreaFish
				sum_2 = sum_2 + v10.AreaFish
			end
		end
	end
	local v11 = AreaUtility:GetGlobalFish()
	if #v11 > 0 then
		local v12, v132 = CreateSection("Global Limited Fish", {
			Order = -1000,
			BGColor = TierUtility:GetTier("Exclusive").TierColor
		})
		for i, v in ipairs(v11) do
			v12(v, true)
		end
		sum = sum + v132.OwnedAreaFish
		sum_2 = sum_2 + v132.AreaFish
	end
	spr.stop(Bar)
	Bar.Size = UDim2.fromScale(0, 1)
	spr.target(Bar, 50, 150, {
		Size = UDim2.fromScale(math.clamp(sum / sum_2, 0, 1), 1)
	})
	Above.Progress.Counter.Text = ("%* Fish: %*/%*"):format(v2, sum, sum_2)
	if v1 then
		v1:Destroy()
	end
	ItemList.Visible = true
	task.wait(0.5)
	v13 = false
end
function t5._destroyItemInfo(p1) --[[ _destroyItemInfo | Line: 1280 | Upvalues: t3 (copy) ]]
	for v1, v2 in t3 do
		v2:Destroy()
	end
	table.clear(t3)
end
function t5._destroyMasteryTiles(p1) --[[ _destroyMasteryTiles | Line: 1287 | Upvalues: t (copy) ]]
	for v1, v2 in t do
		v2:Destroy()
	end
	table.clear(t)
end
function t5._destroyTiles(p1) --[[ _destroyTiles | Line: 1294 | Upvalues: v14 (ref), v15 (copy), RightContent (copy), v7 (copy), v13 (ref) ]]
	if v14 then
		v15:Wait()
	end
	v14 = true
	RightContent.Visible = false
	p1:_destroyMasteryTiles()
	p1:_destroyItemInfo()
	v7:Clean()
	v15:Fire()
	v14 = false
	v13 = false
end
return t5