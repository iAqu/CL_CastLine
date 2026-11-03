-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
local v1 = nil
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Signal = require(ReplicatedStorage.Packages.Signal)
local Net = require(ReplicatedStorage.Packages.Net)
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local Settings = require(ReplicatedStorage.Shared.Settings)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ColorPicker = require(ReplicatedStorage.Modules.ColorPicker)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local SettingsListener = require(script:WaitForChild("SettingsListener"))
local v2 = Net:RemoteEvent("ChangeSetting")
local v3 = Net:RemoteEvent("ChangeHaloColor")
local v4 = Net:RemoteEvent("EquipHalo")
local v5 = Net:RemoteEvent("UnequipHalo")
local Settings_2 = PlayerGui:WaitForChild("Settings")
local ScrollingFrame = Settings_2.Main.Bottom.ScrollingFrame
local HaloSkins = Settings_2.Main.Bottom.ScrollingFrame.HaloSkins
local Scrolling = HaloSkins.Box.Inputs.Scrolling
local Tile = Scrolling.Tile
Tile.Parent = nil
local Tile_2 = ScrollingFrame.Tile
Tile_2.Parent = nil
local Stat = ScrollingFrame.StatTile.Stat
Stat.Parent = nil
local SpacerTile = ScrollingFrame.SpacerTile
SpacerTile.Parent = nil
local LargeTile = ScrollingFrame.LargeTile
LargeTile.Parent = nil
local t = {}
local t2 = {}
local t3 = {}
local v6 = false
local v7 = false
local v8 = Signal.new()
local v9 = Signal.new()
local v10 = false
local v11 = Signal.new()
local v12 = Trove.new()
local v13 = GamePassUtility:GetGamePassIdFromName("VIP")
local Characters = workspace:WaitForChild("Characters")
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
local t4 = {}
local function AddCharacterTrove(p1) --[[ AddCharacterTrove | Line: 87 | Upvalues: Players (copy), t3 (copy), Trove (copy), LocalPlayer (copy), v1 (ref) ]]
	local v12 = Players:GetPlayerFromCharacter(p1)
	if not v12 then
		return
	end
	if t3[p1] then
		t3[p1]:Destroy()
		t3[p1] = nil
	end
	local v2 = Trove.new()
	t3[p1] = v2
	local v3 = p1:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") or p1:FindFirstChild("!!!EQUIPPED_TOOL!!!")
	if not v3 then
		return
	end
	local function Check(p1) --[[ Check | Line: 106 | Upvalues: v3 (copy), v12 (copy), LocalPlayer (ref), v1 (ref) ]]
		if not (p1:IsDescendantOf(v3) and table.find({ "ParticleEmitter", "Beam", "Trail" }, p1.ClassName) or p1:HasTag("RodAura")) then
			return
		end
		if v12 == LocalPlayer and v1:Get({ "Settings", "Self Rod VFX" }) then
			p1.Enabled = true
			return
		end
		if v12 ~= LocalPlayer and v1:Get({ "Settings", "Others Rod VFX" }) then
			p1.Enabled = true
			return
		end
		p1.Enabled = false
	end
	for v4, v5 in p1:GetDescendants() do
		Check(v5)
	end
	v2:Add(p1.DescendantAdded:Connect(Check))
	v2:Add(p1.AncestryChanged:Connect(function(p12, p2) --[[ Line: 123 | Upvalues: v2 (copy), t3 (ref), p1 (copy) ]]
		if p2 then
			return
		end
		v2:Destroy()
		t3[p1] = nil
	end))
end
local function UpdateRodVFX() --[[ UpdateRodVFX | Line: 131 | Upvalues: Characters (copy), AddCharacterTrove (copy) ]]
	for v1, v2 in Characters:GetChildren() do
		AddCharacterTrove(v2)
	end
end
local function ScanFishModel(p1, p2) --[[ ScanFishModel | Line: 137 | Upvalues: LocalPlayer (copy) ]]
	if p1.Name ~= "!!!EQUIPPED_TOOL!!!" or p1:GetAttribute("Owner") == LocalPlayer.Name then
		return
	end
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") and v2.Name ~= "Handle" then
			if not v2:GetAttribute("Transparency") then
				v2:SetAttribute("Transparency", v2.Transparency)
			end
			v2.Transparency = if p2 then 1 else v2:GetAttribute("Transparency") or 0
			continue
		end
		if v2:IsA("Beam") or v2:IsA("ParticleEmitter") then
			v2.Enabled = not p2
		end
	end
end
local function UpdateFishModels() --[[ UpdateFishModels | Line: 153 | Upvalues: CosmeticFolder (copy), ScanFishModel (copy), v1 (ref) ]]
	for v12, v2 in CosmeticFolder:GetChildren() do
		ScanFishModel(v2, v1:Get({ "Settings", "Hide Player Fish" }))
	end
end
function t4.Init(p1) --[[ Init | Line: 159 | Upvalues: v1 (ref), Client (copy), v9 (copy), Characters (copy), AddCharacterTrove (copy), UpdateRodVFX (copy), UpdateFishModels (copy), CosmeticFolder (copy), ScanFishModel (copy), SettingsListener (copy) ]]
	v1 = Client:WaitReplion("Data")
	v1:OnChange({ "Settings", "Luck Modifiers" }, function() --[[ Line: 162 | Upvalues: v9 (ref) ]]
		v9:Fire()
	end)
	v1:OnChange({ "Settings", "Friend Luck" }, function() --[[ Line: 165 | Upvalues: v9 (ref) ]]
		v9:Fire()
	end)
	for v12, v2 in Characters:GetChildren() do
		AddCharacterTrove(v2)
	end
	v1:OnChange({ "Settings", "Self Rod VFX" }, UpdateRodVFX)
	v1:OnChange({ "Settings", "Others Rod VFX" }, UpdateRodVFX)
	Characters.ChildAdded:Connect(AddCharacterTrove)
	UpdateFishModels()
	v1:OnChange({ "Settings", "Hide Player Fish" }, UpdateFishModels)
	CosmeticFolder.ChildAdded:Connect(function(p1) --[[ Line: 179 | Upvalues: ScanFishModel (ref), v1 (ref) ]]
		ScanFishModel(p1, v1:Get({ "Settings", "Hide Player Fish" }))
	end)
	v1:OnChange("Settings", SettingsListener)
	SettingsListener(v1:GetExpect("Settings"))
end
function t4.Start(p1) --[[ Start | Line: 187 | Upvalues: GuiControl (copy), Settings_2 (copy), v11 (copy), v10 (ref), v12 (copy), Stat (copy), ScrollingFrame (copy), v1 (ref), PlayerStatsUtility (copy), LocalPlayer (copy), StringLibrary (copy), v9 (copy), HaloSkins (copy), v3 (copy), ColorPicker (copy), PlayerGui (copy) ]]
	GuiControl.GuiFocusedSignal:Connect(function(p12) --[[ Line: 188 | Upvalues: Settings_2 (ref), p1 (copy) ]]
		if p12 ~= Settings_2 then
			return
		end
		p1:_createSettings()
		if not hasVIP() then
			return
		end
		p1:SetHaloEnabled(true)
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p12) --[[ Line: 199 | Upvalues: Settings_2 (ref), p1 (copy) ]]
		if p12 ~= Settings_2 then
			return
		end
		p1:_destroySettings()
		p1:SetHaloEnabled(false)
	end)
	v11:Connect(function() --[[ Line: 217 | Upvalues: v10 (ref), p1 (copy), v12 (ref) ]]
		if v10 then
			p1:RenderHalos()
		else
			v12:Clean()
		end
	end)
	local v13 = Stat:Clone()
	v13.Label.TextColor3 = Color3.fromRGB(75, 255, 102)
	v13.LayoutOrder = 0
	v13.Parent = ScrollingFrame.StatTile
	local v2 = Stat:Clone()
	v2.Label.TextColor3 = Color3.fromRGB(255, 224, 153)
	v2.LayoutOrder = 1
	v2.Parent = ScrollingFrame.StatTile
	local v32 = Stat:Clone()
	v32.Label.TextColor3 = Color3.fromRGB(155, 245, 255)
	v32.LayoutOrder = 2
	v32.Parent = ScrollingFrame.StatTile
	local v4 = Stat:Clone()
	v4.Label.TextColor3 = Color3.fromRGB(128, 55, 255)
	v4.LayoutOrder = 3
	v4.Parent = ScrollingFrame.StatTile
	local v5 = Stat:Clone()
	v5.LayoutOrder = 4
	v5.Parent = ScrollingFrame.StatTile
	local v6 = Stat:Clone()
	v6.LayoutOrder = 5
	v6.Parent = ScrollingFrame.StatTile
	local v7 = Stat:Clone()
	v7.LayoutOrder = 6
	v7.Parent = ScrollingFrame.StatTile
	local v8 = Stat:Clone()
	v8.Label.TextColor3 = Color3.fromRGB(255, 206, 93)
	v8.LayoutOrder = 10
	v8.Parent = ScrollingFrame.StatTile
	local function updateStats() --[[ updateStats | Line: 264 | Upvalues: v1 (ref), PlayerStatsUtility (ref), LocalPlayer (ref), v2 (copy), v13 (copy), v32 (copy), v4 (copy), v6 (copy), v7 (copy), StringLibrary (ref), v8 (copy), p1 (copy), v5 (copy) ]]
		local v12 = v1:GetExpect("Statistics")
		local v22 = v1:GetExpect("Level")
		local v3 = v1:GetExpect("TotalEarnedTokens")
		local v42 = PlayerStatsUtility:GetPlayerModifiers(LocalPlayer)
		local v52 = PlayerStatsUtility:GetLevelLuck(v22)
		v2.Label.Text = ("Level Luck: +%*%%"):format((math.round(v52 * 100)))
		v13.Label.Text = ("Bonus Luck: +%*%%"):format(math.round((v42.BaseLuck - v52) * 100 * 10) / 10)
		v32.Label.Text = ("Shiny Chance: %*%%"):format(math.round(0.04 * v42.ShinyMultiplier * 10000) / 100)
		v4.Label.Text = ("Mutation Chance: x%*%%"):format(math.round(v42.MutationMultiplier * 100) / 100)
		v6.Label.Text = ("Monthly Fish: %*"):format(v12.MonthlyFishCaught)
		v7.Label.Text = ("Monthly Levels: %*"):format(v12.MonthlyLevel)
		v8.Label.Text = ("Total Earned Tokens: %*"):format((StringLibrary:AddCommas(v3)))
		v5.Label.Text = p1:_getPlayTime()
	end
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 293 | Upvalues: Settings_2 (ref), updateStats (copy) ]]
		if p1 ~= Settings_2 then
			return
		end
		updateStats()
	end)
	v9:Connect(updateStats)
	updateStats()
	local VIP = ScrollingFrame.VIP
	local Locked = HaloSkins.Locked
	local Locked_2 = VIP.Locked
	local Inputs = VIP.Box.Inputs
	local ColorPicker_2 = VIP.VectorFrame.ColorPicker
	local t = {}
	local function refreshLock() --[[ refreshLock | Line: 315 | Upvalues: Inputs (copy), Locked_2 (copy), Locked (copy) ]]
		local v1 = hasVIP()
		Inputs.Visible = v1
		Locked_2.Visible = not v1
		Locked.Visible = not v1
	end
	local function processChange() --[[ processChange | Line: 323 | Upvalues: Inputs (copy), t (ref), v3 (ref) ]]
		local t2 = {}
		for v1, v2 in { "R", "G", "B" } do
			local v32 = Inputs:FindFirstChild(v2)
			if v32 then
				local Input = v32.Input
				local Text = Input.Text
				local v6 = math.clamp(math.floor(tonumber(Text) or 255), 0, 255)
				if tostring(v6) == Text then
					table.insert(t2, v6)
				else
					Input.Text = tostring(v6)
					break
				end
			end
		end
		if #t2 ~= 3 then
			return
		end
		local v7 = Color3.fromRGB(t2[1], t2[2], t2[3])
		local v8 = Color3.fromRGB(t[1], t[2], t[3])
		if v7:ToHex() ~= v8:ToHex() then
			t = t2
			v3:FireServer(t2[1], t2[2], t2[3])
		end
	end
	local function waitForInput(p1) --[[ waitForInput | Line: 359 | Upvalues: processChange (copy) ]]
		task.wait(0.2)
		if p1.Input.Text ~= p1.Input.Text then
			return
		end
		processChange()
	end
	local function refreshHaloColor() --[[ refreshHaloColor | Line: 369 | Upvalues: v1 (ref), VIP (copy), Inputs (copy) ]]
		local v12 = v1:GetExpect("HaloColor")
		VIP.VectorFrame.ColorPicker.BackgroundColor3 = Color3.fromRGB(v12[1], v12[2], v12[3])
		for v3, v4 in { "R", "G", "B" } do
			local v5 = Inputs:FindFirstChild(v4)
			if not v5 then
				break
			end
			v5.Input.Text = v12[v3]
		end
	end
	for v92, v102 in { "R", "G", "B" } do
		local v112 = Inputs:WaitForChild(v102)
		if v112 then
			v112.Input:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 390 | Upvalues: v112 (copy), processChange (copy) ]]
				local v1 = v112
				task.wait(0.2)
				if v1.Input.Text ~= v1.Input.Text then
					return
				end
				processChange()
			end)
		end
	end
	v1:OnChange("HaloColor", refreshHaloColor)
	LocalPlayer.AttributeChanged:Connect(refreshLock)
	refreshHaloColor()
	local v122 = hasVIP()
	Inputs.Visible = v122
	Locked_2.Visible = not v122
	Locked.Visible = not v122
	task.spawn(function() --[[ Line: 401 | Upvalues: ColorPicker (ref), PlayerGui (ref), GuiControl (ref), ColorPicker_2 (copy), v1 (ref), v3 (ref), Inputs (copy) ]]
		local v12 = ColorPicker.new(PlayerGui.ColorPicker.Main.Bottom.ColorPicker)
		GuiControl:Hook("Hold Button", ColorPicker_2).Clicked:Connect(function() --[[ Line: 407 | Upvalues: v1 (ref), v12 (copy), v3 (ref), Inputs (ref), GuiControl (ref) ]]
			local v13 = v1:GetExpect("HaloColor")
			v12:SetColor(Color3.fromRGB(v13[1], v13[2], v13[3]))
			v12:Open(function(p1) --[[ Line: 413 | Upvalues: v3 (ref), Inputs (ref) ]]
				local v32 = math.clamp(math.round(p1.R * 255), 0, 255)
				local v6 = math.clamp(math.round(p1.G * 255), 0, 255)
				local v9 = math.clamp(math.round(p1.B * 255), 0, 255)
				v3:FireServer(v32, v6, v9)
				for v10, v11 in { "R", "G", "B" } do
					local v12 = Inputs:FindFirstChild(v11)
					if v12 then
						v12.Input.Text = tostring(({ v32, v6, v9 })[v10])
					end
				end
			end)
			GuiControl:Open("ColorPicker")
		end)
		GuiControl:Hook("Hold Button", PlayerGui.ColorPicker.Main.Close).Clicked:Connect(function() --[[ Line: 435 | Upvalues: v12 (copy), GuiControl (ref) ]]
			v12:Close()
			GuiControl:Open("Settings")
		end)
	end)
end
function t4.SetHaloEnabled(p1, p2) --[[ SetHaloEnabled | Line: 467 | Upvalues: v10 (ref), v11 (copy) ]]
	if p2 ~= v10 then
		v10 = p2
		v11:Fire()
	end
end
function t4.ToggleHalos(p1) --[[ ToggleHalos | Line: 476 | Upvalues: v10 (ref) ]]
	p1:SetHaloEnabled(not v10)
end
function t4.SortOwnedHalos(p1) --[[ SortOwnedHalos | Line: 481 | Upvalues: ItemUtility (copy), v1 (ref) ]]
	local t = { ItemUtility:GetHaloData("VIP Halo") }
	local v12 = v1:GetExpect({ "Inventory", "Halos" })
	local v2 = v1:GetExpect("EquippedHaloId")
	for i, v in ipairs(v12) do
		if v.Id ~= 1 then
			local v3 = ItemUtility:GetHaloData(v.Id)
			if v3 then
				table.insert(t, v3)
			end
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 500 | Upvalues: v2 (copy) ]]
		local sum = p1.Data.Tier * 100 + string.len(p1.Data.Name)
		local sum_2 = p2.Data.Tier * 100 + string.len(p2.Data.Name)
		if p1.Data.Id == v2 then
			sum = sum + 10000
		end
		if p2.Data.Id == v2 then
			sum_2 = sum_2 + 10000
		end
		return sum_2 < sum
	end)
	return t, v2
end
function t4.RenderHalos(p1) --[[ RenderHalos | Line: 518 | Upvalues: v12 (copy), t4 (copy), TierUtility (copy), Tile (copy), spr (copy), v1 (ref), GuiControl (copy), v5 (copy), v4 (copy), Scrolling (copy) ]]
	v12:Clean()
	local v13, v2 = t4:SortOwnedHalos()
	for k, v in pairs(v13) do
		local Id = v.Data.Id
		local v3 = TierUtility:GetTier(v.Data.Tier)
		local v42 = nil
		local v52 = Tile:Clone()
		local Vector = v52.VectorFrame.Vector
		local function setFade(p1) --[[ setFade | Line: 533 | Upvalues: spr (ref), v52 (copy) ]]
			spr.stop(v52)
			spr.target(v52, 20, 40, {
				BackgroundTransparency = p1
			})
		end
		local function selectionStart() --[[ selectionStart | Line: 540 | Upvalues: spr (ref), v52 (copy) ]]
			spr.stop(v52)
			spr.target(v52, 20, 40, {
				BackgroundTransparency = 0.95
			})
		end
		local function selectionStop() --[[ selectionStop | Line: 544 | Upvalues: v1 (ref), Id (copy), spr (ref), v52 (copy) ]]
			local v12 = if v1:GetExpect("EquippedHaloId") == Id then 0.88 else 1
			spr.stop(v52)
			spr.target(v52, 20, 40, {
				BackgroundTransparency = v12
			})
		end
		Vector.Image = v.Data.Icon or ""
		v52.Context.Header.Text = v.Data.Name or ""
		local function changeHaloColor() --[[ changeHaloColor | Line: 562 | Upvalues: v1 (ref), Vector (copy) ]]
			local v12 = v1:GetExpect("HaloColor")
			Vector.ImageColor3 = Color3.fromRGB(v12[1], v12[2], v12[3])
		end
		task.defer(function() --[[ Line: 568 | Upvalues: v42 (ref), v1 (ref), changeHaloColor (copy), Vector (copy) ]]
			v42 = v1:OnChange("HaloColor", changeHaloColor)
			local v12 = v1:GetExpect("HaloColor")
			Vector.ImageColor3 = Color3.fromRGB(v12[1], v12[2], v12[3])
		end)
		local v6 = GuiControl:Hook("Hold Button", v52)
		v6.Clicked:Connect(function() --[[ Line: 575 | Upvalues: v1 (ref), Id (copy), v5 (ref), v4 (ref) ]]
			if v1:GetExpect("EquippedHaloId") == Id then
				v5:FireServer()
			else
				v4:FireServer(Id)
			end
		end)
		v6.Cleaner:Add(v52.MouseEnter:Connect(selectionStart))
		v6.Cleaner:Add(v52.SelectionGained:Connect(selectionStart))
		v6.Cleaner:Add(v52.MouseLeave:Connect(selectionStop))
		v6.Cleaner:Add(v52.SelectionLost:Connect(selectionStop))
		v6.Cleaner:Add(function() --[[ Line: 589 | Upvalues: v42 (ref) ]]
			if not v42 then
				return
			end
			v42:Disconnect()
		end)
		if v2 == Id then
			v52.BackgroundTransparency = 0.88
		end
		v52.Gradient.UIGradient.Color = v3.TierColor
		task.delay((k - 1) * 0.12, function() --[[ Line: 602 | Upvalues: v52 (copy), spr (ref) ]]
			local v1 = if v52 and v52.Parent then v52:FindFirstChild("Gradient") else nil
			if v1 then
				spr.target(v1, 1, 3, {
					BackgroundTransparency = 0.5
				})
			end
		end)
		v52.AutoButtonColor = true
		v52.LayoutOrder = k
		v52.Parent = Scrolling
		v12:Add(function() --[[ Line: 619 | Upvalues: spr (ref), v52 (copy) ]]
			spr.stop(v52)
		end)
		v12:Add(v52)
	end
end
function t4._getPlayTime(p1) --[[ _getPlayTime | Line: 626 | Upvalues: v1 (ref) ]]
	local v12 = v1:GetExpect("TotalSessionTime")
	local v2 = (v12 - math.floor(v12 % 60)) / 60
	local v3 = (v2 - v2 % 60) / 60
	if v3 >= 1 then
		local v4 = math.round(v3)
		local v7 = math.round(v2 - math.floor(v3) * 60)
		return ("%* %* %* %*"):format(v4, if v4 == 1 then "Hour" else "Hours", v7, if v7 == 1 then "Minute" else "Minutes")
	else
		local v9 = math.round(v2)
		return ("%* %*"):format(v9, if v9 == 1 then "Minute" else "Minutes")
	end
end
function t4._createSettings(p1) --[[ _createSettings | Line: 649 | Upvalues: v7 (ref), v8 (copy), v6 (ref), Settings (copy), LargeTile (copy), Tile_2 (copy), v1 (ref), spr (copy), Soundbook (copy), v2 (copy), LocalPlayer (copy), ScrollingFrame (copy), t (copy), SpacerTile (copy), t2 (copy) ]]
	if v7 then
		v8:Wait()
	end
	if v6 then
		return
	end
	v6 = true
	p1:_destroySettings()
	for v12, v22 in Settings do
		for v3, v4 in v22.Options do
			local v5 = if v4.Large then LargeTile:Clone() else Tile_2:Clone()
			local Toggle = v5.Box.Inputs.Toggle
			v5.Box.Header.Text = v3
			v5.Box.Description.Text = v4.Description
			v5.VectorFrame.Vector.Image = v4.Icon or ""
			local v62 = nil
			local v72 = nil
			local v82 = nil
			local t3 = {}
			local v9 = v1:Get(v4.Path)
			local v10 = typeof(v9)
			if v10 == "boolean" then
				v72 = function() --[[ Line: 686 | Upvalues: v1 (ref), v4 (copy) ]]
					return not v1:Get(v4.Path)
				end
				v62 = function(p1, p2) --[[ Line: 693 | Upvalues: v6 (ref), Toggle (copy), spr (ref) ]]
					local v1 = if p1 then 0 else 1
					local v2 = if p1 then Color3.fromRGB(32, 217, 91) else Color3.fromRGB(217, 61, 41)
					if v6 then
						Toggle.Slider.Button.AnchorPoint = Vector2.new(v1, 0)
						Toggle.Slider.Button.Position = UDim2.fromScale(v1, 0)
						Toggle.Slider.Button.BackgroundColor3 = v2
					else
						spr.stop(Toggle.Slider.Button)
						spr.target(Toggle.Slider.Button, 90, 325, {
							AnchorPoint = Vector2.new(v1, 0),
							Position = UDim2.fromScale(v1, 0),
							BackgroundColor3 = v2
						})
					end
				end
			elseif v10 == "number" or v10 == "string" then
				v72 = function() --[[ Line: 713 ]]
					return nil
				end
			end
			if v62 then
				v82 = v1:OnChange(v4.Path, v62)
				v62(v9, v9)
			end
			if v72 then
				t3.ButtonConnection = Toggle.Slider.LargeButton.Activated:Connect(function() --[[ Line: 725 | Upvalues: v72 (ref), Soundbook (ref), v2 (ref), v3 (copy) ]]
					local v1 = v72()
					if v1 == nil then
						return
					end
					Soundbook.Sounds.ThickClick:Play()
					v2:FireServer(v3, v1)
				end)
				Toggle.Visible = true
			else
				Toggle.Visible = false
			end
			if v4.ShowCondition then
				local v11 = v4.ShowCondition.Condition(LocalPlayer)
				v5.Visible = v11
				if not v11 then
					t3.ShowConditionConnection = v4.ShowCondition.CheckConnection(LocalPlayer, function() --[[ Line: 744 | Upvalues: v5 (copy) ]]
						v5.Visible = true
					end)
				end
			end
			v5.Destroying:Once(function() --[[ Line: 750 | Upvalues: t3 (copy), v82 (ref) ]]
				for v1, v2 in t3 do
					v2:Disconnect()
				end
				if not v82 then
					return
				end
				v82:Disconnect()
			end)
			v5.LayoutOrder = v22.Order + string.len(v3)
			v5.Parent = ScrollingFrame
			t[v3] = v5
		end
		if v22.ShowHeader then
			local v122 = SpacerTile:Clone()
			v122.Label.Text = v12
			v122.LayoutOrder = v22.Order
			v122.Parent = ScrollingFrame
			t2[v12] = v122
		end
	end
	v6 = false
end
function t4._destroySettings(p1) --[[ _destroySettings | Line: 783 | Upvalues: v7 (ref), t (copy), t2 (copy), v8 (copy), v6 (ref) ]]
	v7 = true
	for v1, v2 in t do
		v2:Destroy()
	end
	for v3, v4 in t2 do
		v4:Destroy()
	end
	table.clear(t)
	table.clear(t2)
	v8:Fire()
	v7 = false
	v6 = false
end
function hasVIP() --[[ hasVIP | Line: 805 | Upvalues: v13 (copy), LocalPlayer (copy) ]]
	("Pass%*"):format(v13)
	return LocalPlayer:GetAttribute((("Pass%*"):format(v13)))
end
return t4