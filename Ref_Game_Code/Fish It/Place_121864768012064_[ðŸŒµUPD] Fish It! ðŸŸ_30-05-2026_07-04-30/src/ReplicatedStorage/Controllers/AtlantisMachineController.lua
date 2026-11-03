-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local AtlantisMachineConfig = require(ReplicatedStorage.Shared.AtlantisMachineConfig)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Controllers.ClientTimeController)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = Net:RemoteFunction("SacrificeAtlantisFish")
local v2 = Net:RemoteFunction("SacrificeAtlantisSellAll")
local v3 = Net:RemoteEvent("AtlantisMachineEffect")
local v4 = nil
local v5 = nil
local t = {}
local t2 = {}
local t3 = {}
local v6 = 0
local v7 = true
local v8 = 0
local v9 = false
local v10 = Trove.new()
local t4 = {}
local t5 = {
	"CommonTemplate",
	"UncommonTemplate",
	"RareTemplate",
	"EpicTemplate",
	"LegendaryTemplate",
	"MythicalTemplate",
	"SecretTemplate"
}
local t6 = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythical",
	"Secret"
}
local t7 = {}
local function getMachinePart(p1) --[[ getMachinePart | Line: 63 | Upvalues: t (copy) ]]
	local v1 = t.UnderwaterCity and t.UnderwaterCity:FindFirstChild("Atlantis Machine")
	if not v1 then
		return
	end
	for i, v in ipairs(p1) do
		local v2 = v1:FindFirstChild(v)
		if v2 and v2:IsA("BasePart") then
			return v2
		end
	end
end
local function getBoostData() --[[ getBoostData | Line: 79 | Upvalues: v4 (ref), AtlantisMachineConfig (copy) ]]
	if not v4 then
		return
	end
	local v1 = v4:Get("ActiveBoostId")
	if not v1 or v1 == "" then
		return
	end
	local v2 = v4:Get("ActiveBoostEndsAt") or 0
	if v2 <= workspace:GetServerTimeNow() then
	else
		return AtlantisMachineConfig:GetBoost(v1), AtlantisMachineConfig:GetDuration(v4:Get("ActiveDurationId")), v2
	end
end
local function isInAtlantis() --[[ isInAtlantis | Line: 97 | Upvalues: LocalPlayer (copy), AtlantisMachineConfig (copy) ]]
	local isLocationName = LocalPlayer:GetAttribute("LocationName") == AtlantisMachineConfig.LocationName
	return isLocationName
end
local function formatSeconds(p1) --[[ formatSeconds | Line: 101 ]]
	local v2 = math.max(math.floor(p1), 0)
	local v3 = math.floor(v2 / 3600)
	local v4 = math.floor(v2 % 3600 / 60)
	local v5 = v2 % 60
	if v3 > 0 then
		return string.format("%i:%02i:%02i", v3, v4, v5)
	else
		return string.format("%02i:%02i", v4, v5)
	end
end
local function tween(p1, p2, p3) --[[ tween | Line: 114 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p1, TweenInfo.new(p3 or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p2)
	v1:Play()
	return v1
end
local function clearRows() --[[ clearRows | Line: 121 | Upvalues: t2 (copy) ]]
	for i, v in ipairs(t2) do
		v:Destroy()
	end
	table.clear(t2)
end
local function deliverLocalMessage(p1, p2) --[[ deliverLocalMessage | Line: 129 | Upvalues: TextNotificationController (copy) ]]
	local t = {
		Type = "Text",
		Text = p1
	}
	t.TextColor = if p2 then p2 else {
	R = 255,
	G = 255,
	B = 255
}
	TextNotificationController:DeliverNotification(t)
end
local function bindButton(p1, p2, p3) --[[ bindButton | Line: 137 | Upvalues: Trove (copy), v10 (copy), GuiControl (copy) ]]
	local v1 = if p3 then p3 else Trove.new()
	if not p3 then
		v10:Add(v1)
	end
	local v2 = GuiControl:Hook("Hold Button", p1, nil, nil, v1)
	v1:Add(v2.Clicked:Connect(p2))
	return v2
end
local function getFishTemplate(p1) --[[ getFishTemplate | Line: 148 | Upvalues: t (copy), t5 (copy) ]]
	local Ui = t.Ui
	if not Ui then
		return
	end
	return Ui.FishTemplates and Ui.FishTemplates[t5[p1.Tier] or "CommonTemplate"]
end
local function getOddsLabels(p1) --[[ getOddsLabels | Line: 158 ]]
	local t = {}
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("TextLabel") then
			table.insert(t, v)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 167 ]]
		return p1.Position.X.Scale < p2.Position.X.Scale
	end)
	return t[1], t[2]
end
local function formatSellAllBreakdown(p1) --[[ formatSellAllBreakdown | Line: 174 | Upvalues: TierUtility (copy) ]]
	local t = {}
	local v1 = ipairs
	for v3, v4 in v1(p1.Breakdown or {}) do
		local v5 = TierUtility:GetTier(v4.Tier).TierColor.Keypoints[1].Value
		table.insert(t, (("x%* <font color=\"rgb(%*)\">%*</font>"):format(v4.Count, ("%*, %*, %*"):format(math.round(v5.R * 255), math.round(v5.G * 255), (math.round(v5.B * 255))), v4.Name)))
	end
	if #t == 0 then
		return "No eligible fish"
	else
		return table.concat(t, ", ")
	end
end
local function buildRow(p1) --[[ buildRow | Line: 191 | Upvalues: t (copy), t5 (copy), t6 (copy), TierUtility (copy), StringLibrary (copy), Trove (copy), bindButton (copy), t7 (copy), t2 (copy) ]]
	local Ui = t.Ui
	local v1 = if Ui then Ui.FishTemplates and Ui.FishTemplates[t5[p1.Tier] or "CommonTemplate"] else nil
	if not v1 then
		return
	end
	local v3 = v1:Clone()
	local Icon = v3.Box.Icon
	local FishName = v3.FishName
	local Rarity = v3.Rarity
	local Points = v3.Points
	local SELL = v3.SELL
	v3.Name = p1.UUID
	v3.Visible = true
	Icon.Image = p1.Icon or ""
	FishName.Text = p1.Name
	Rarity.Text = t6[p1.Tier] or TierUtility:GetTier(p1.Tier).Name
	Points.Text = ("%* Points"):format((StringLibrary:AddCommas(p1.Points)))
	local v5 = Trove.new()
	v3.Destroying:Once(function() --[[ Line: 212 | Upvalues: v5 (copy) ]]
		v5:Destroy()
	end)
	bindButton(SELL, function() --[[ Line: 216 | Upvalues: t7 (ref), p1 (copy) ]]
		t7:_sellSingle(p1)
	end, v5)
	table.insert(t2, v3)
	return v3
end
local function updateFishListSummary() --[[ updateFishListSummary | Line: 224 | Upvalues: t (copy), t3 (copy), StringLibrary (copy), v6 (ref) ]]
	local Ui = t.Ui
	if not Ui then
		return
	end
	if Ui.BottomTextLabel then
		Ui.BottomTextLabel.Text = if #t3 == 0 then "No eligible fish available to sacrifice" else "Sell fish to charge Atlantis machine!"
	end
	Ui.InventoryValueLabel.Text = ("Inventory Value: %* Points"):format((StringLibrary:AddCommas(v6)))
end
local function removeFishEntry(p1) --[[ removeFishEntry | Line: 237 | Upvalues: t3 (copy), v6 (ref), t2 (copy), t (copy), StringLibrary (copy) ]]
	for i, v in ipairs(t3) do
		if v.UUID == p1.UUID then
			table.remove(t3, i)
			v6 = math.max(v6 - v.Points, 0)
			break
		end
	end
	for i = #t2, 1, -1 do
		local v2 = t2[i]
		if v2.Name == p1.UUID then
			table.remove(t2, i)
			v2:Destroy()
			break
		end
	end
	local Ui = t.Ui
	if not Ui then
		return
	end
	if Ui.BottomTextLabel then
		Ui.BottomTextLabel.Text = if #t3 == 0 then "No eligible fish available to sacrifice" else "Sell fish to charge Atlantis machine!"
	end
	Ui.InventoryValueLabel.Text = ("Inventory Value: %* Points"):format((StringLibrary:AddCommas(v6)))
end
local function refreshFishList() --[[ refreshFishList | Line: 258 | Upvalues: v5 (ref), t (copy), v7 (ref), AtlantisMachineConfig (copy), t3 (copy), v8 (ref), t2 (copy), v6 (ref), StringLibrary (copy), buildRow (copy) ]]
	if not v5 then
		return
	end
	local Ui = t.Ui
	if not Ui then
		return
	end
	local v2 = if v7 then AtlantisMachineConfig:BuildEligibleEntries(v5:Get({ "Inventory", "Items" }) or {}) else t3
	local sum = 0
	v8 = v8 + 1
	local v3 = v8
	for i, v in ipairs(t2) do
		v:Destroy()
	end
	table.clear(t2)
	if v7 then
		table.clear(t3)
		v6 = 0
		for i, v in ipairs(v2) do
			sum = sum + v.Points
			t3[i] = v
		end
		v6 = sum
		local Ui_2 = t.Ui
		if Ui_2 then
			if Ui_2.BottomTextLabel then
				Ui_2.BottomTextLabel.Text = if #t3 == 0 then "No eligible fish available to sacrifice" else "Sell fish to charge Atlantis machine!"
			end
			Ui_2.InventoryValueLabel.Text = ("Inventory Value: %* Points"):format((StringLibrary:AddCommas(sum)))
		end
		Ui.FishList.CanvasSize = UDim2.fromOffset(0, 0)
		v7 = false
	end
	if #t3 ~= 0 then
		task.spawn(function() --[[ Line: 296 | Upvalues: t3 (ref), v8 (ref), v3 (copy), buildRow (ref), Ui (copy) ]]
			for i, v in ipairs(t3) do
				if v8 ~= v3 then
					break
				end
				local v1 = buildRow(v)
				if v1 then
					v1.LayoutOrder = i
					v1.Parent = Ui.FishList
				end
				if i % 20 == 0 then
					task.wait()
				end
			end
		end)
	end
end
local function refreshOdds() --[[ refreshOdds | Line: 315 | Upvalues: t (copy), getOddsLabels (copy), AtlantisMachineConfig (copy) ]]
	local Ui = t.Ui
	local BoostOddsList = Ui.BoostOddsList
	local BoostOddsTemplate = Ui.BoostOddsTemplate
	local DurationOddsList = Ui.DurationOddsList
	local DurationOddsTemplate = Ui.DurationOddsTemplate
	if not (BoostOddsList and (BoostOddsTemplate and (DurationOddsList and DurationOddsTemplate))) then
		return
	end
	for i, v in ipairs(BoostOddsList:GetChildren()) do
		if v:IsA("Frame") and v.Name == "Entry" then
			v:Destroy()
		end
	end
	for i, v in ipairs(DurationOddsList:GetChildren()) do
		if v:IsA("Frame") and v.Name == "Entry" then
			v:Destroy()
		end
	end
	local function createOddsEntry(p1, p2, p3, p4, p5) --[[ createOddsEntry | Line: 337 | Upvalues: getOddsLabels (ref) ]]
		local Entry = p2:Clone()
		local v1, v2 = getOddsLabels(Entry)
		Entry.Name = "Entry"
		Entry.Visible = true
		Entry.LayoutOrder = p5
		if v1 then
			v1.Text = p3
		end
		if v2 then
			v2.Text = p4
		end
		Entry.Parent = p1
	end
	local count = 10
	for i, v in ipairs(AtlantisMachineConfig:GetBoostPercentages()) do
		local v1 = v.Name
		local v2 = ("%*%%"):format(v.Percentage)
		local Entry = BoostOddsTemplate:Clone()
		local v3, v4 = getOddsLabels(Entry)
		Entry.Name = "Entry"
		Entry.Visible = true
		Entry.LayoutOrder = count
		if v3 then
			v3.Text = v1
		end
		if v4 then
			v4.Text = v2
		end
		Entry.Parent = BoostOddsList
		count = count + 1
	end
	local count_2 = 10
	for i, v in ipairs(AtlantisMachineConfig:GetDurationPercentages()) do
		local v5 = v.Name
		local v6 = ("%*%%"):format(v.Percentage)
		local Entry = DurationOddsTemplate:Clone()
		local v7, v8 = getOddsLabels(Entry)
		Entry.Name = "Entry"
		Entry.Visible = true
		Entry.LayoutOrder = count_2
		if v7 then
			v7.Text = v5
		end
		if v8 then
			v8.Text = v6
		end
		Entry.Parent = DurationOddsList
		count_2 = count_2 + 1
	end
end
local function showMain() --[[ showMain | Line: 370 | Upvalues: t (copy), GuiControl (copy), v7 (ref), refreshFishList (copy) ]]
	local Ui = t.Ui
	if GuiControl:IsOpen("Atlantis Machine") then
		v7 = true
		refreshFishList()
	else
		GuiControl:Open("Atlantis Machine")
	end
	Ui.MainFrame.Visible = true
	Ui.OddsFrame.Visible = false
end
local function showOdds() --[[ showOdds | Line: 383 | Upvalues: t (copy), GuiControl (copy), refreshOdds (copy) ]]
	local Ui = t.Ui
	if not GuiControl:IsOpen("Atlantis Machine") then
		GuiControl:Open("Atlantis Machine")
	end
	Ui.MainFrame.Visible = false
	Ui.OddsFrame.Visible = true
	refreshOdds()
end
local function closeMachine() --[[ closeMachine | Line: 393 | Upvalues: GuiControl (copy) ]]
	GuiControl:Close()
end
local function setBar(p1, p2, p3) --[[ setBar | Line: 397 | Upvalues: t4 (copy), TweenService (copy) ]]
	local v1 = math.clamp(p2, 0, 1)
	local Scale = p1.Size.X.Scale
	if math.abs(Scale - v1) < 0.001 then
		return
	end
	local v2 = t4[p1]
	if v2 then
		v2:Cancel()
		t4[p1] = nil
	end
	if p3 and not (v1 <= Scale) then
		local v3 = TweenService:Create(p1, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(v1, 0, 1, 0)
		})
		t4[p1] = v3
		v3.Completed:Connect(function() --[[ Line: 421 | Upvalues: t4 (ref), p1 (copy), v3 (copy) ]]
			if t4[p1] ~= v3 then
				return
			end
			t4[p1] = nil
		end)
		v3:Play()
		return
	end
	p1.Size = UDim2.new(v1, 0, 1, 0)
end
local function updateStatusVisuals() --[[ updateStatusVisuals | Line: 429 | Upvalues: t (copy), v4 (ref), AtlantisMachineConfig (copy), getBoostData (copy), StringLibrary (copy), setBar (copy), formatSeconds (copy) ]]
	local Ui = t.Ui
	local v1 = if v4 then v4:Get("CurrentPoints") or 0 else 0
	local v2 = v4 and v4:Get("MaxPoints") or AtlantisMachineConfig.MaxPoints
	local v3 = v2 > 0 and v1 / v2 or 0
	local v42, v5, v6 = getBoostData()
	local v8 = not (if v42 then if v5 then v6 else v5 else v42)
	Ui.MilestoneLabel.Text = ("Boost Event at %* points!"):format((StringLibrary:AddCommas(v2)))
	if v42 and (v5 and v6) then
		if v5.Seconds > 0 then
			v3 = math.clamp((v6 - workspace:GetServerTimeNow()) / v5.Seconds, 0, 1)
		end
		setBar(Ui.ProgressFill, v3, v8)
		setBar(Ui.BottomFill, v3, v8)
		local v11 = formatSeconds(v6 - workspace:GetServerTimeNow())
		Ui.ProgressLabel.Text = ("Time Left: %*"):format(v11)
		Ui.BoostLabel.Text = ("%*  \226\128\162  %*"):format(v42.Name, v11)
		Ui.BottomBoostLabel.Text = Ui.BoostLabel.Text
		Ui.BottomLabel.Text = "Underwater City boost running"
		Ui.WorldTimer.Text = v11
		Ui.WorldBoostName.Text = v42.Name
		Ui.WorldTimer.Visible = true
		Ui.WorldBoostName.Visible = true
	else
		setBar(Ui.ProgressFill, v3, v8)
		setBar(Ui.BottomFill, v3, v8)
		Ui.ProgressLabel.Text = ("%* / %*"):format(StringLibrary:AddCommas(v1), (StringLibrary:AddCommas(v2)))
		Ui.BoostLabel.Text = "No boost active"
		Ui.BottomBoostLabel.Text = "No boost active"
		Ui.BottomLabel.Text = "Underwater City machine progress"
		Ui.WorldTimer.Visible = false
		Ui.WorldBoostName.Visible = false
	end
end
local function playMachineSound(p1, p2) --[[ playMachineSound | Line: 469 | Upvalues: t (copy), Soundbook (copy) ]]
	local MachineVFXPart = t.MachineVFXPart
	if not MachineVFXPart then
		return
	end
	local v1 = Soundbook.Sounds[p1]
	if v1 then
		Soundbook:PlaySound(MachineVFXPart, v1, true, {
			PlaybackSpeed = p2 or 1
		})
	end
end
local function emitMachineParticles() --[[ emitMachineParticles | Line: 485 | Upvalues: t (copy), ParticleEmitter (copy) ]]
	local MachineVFXPart = t.MachineVFXPart
	if not MachineVFXPart then
		return
	end
	local v1 = MachineVFXPart:Clone()
	v1.CFrame = MachineVFXPart.CFrame
	v1.Anchored = true
	v1.CanCollide = false
	v1.CanQuery = false
	v1.CanTouch = false
	v1.Parent = workspace:FindFirstChild("CosmeticFolder") or workspace
	task.delay(ParticleEmitter.emitContainer(v1) + 2, function() --[[ Line: 500 | Upvalues: v1 (copy) ]]
		if not v1.Parent then
			return
		end
		v1:Destroy()
	end)
end
local function applyEffect(p1, p2) --[[ applyEffect | Line: 508 | Upvalues: emitMachineParticles (copy), t (copy), Soundbook (copy) ]]
	if p1 == "Pulse" then
		emitMachineParticles()
		local MachineVFXPart = t.MachineVFXPart
		if MachineVFXPart then
			local UseAtlantisMachine = Soundbook.Sounds.UseAtlantisMachine
			if UseAtlantisMachine then
				Soundbook:PlaySound(MachineVFXPart, UseAtlantisMachine, true, {
					PlaybackSpeed = 1
				})
			end
		end
		local MachineVFXPart_2 = t.MachineVFXPart
		if not MachineVFXPart_2 then
			return
		end
		local TotemPlace = Soundbook.Sounds.TotemPlace
		if TotemPlace then
			Soundbook:PlaySound(MachineVFXPart_2, TotemPlace, true, {
				PlaybackSpeed = 1.05
			})
		end
	elseif p1 == "Batch" then
		emitMachineParticles()
		local MachineVFXPart = t.MachineVFXPart
		if MachineVFXPart then
			local UseAtlantisMachine = Soundbook.Sounds.UseAtlantisMachine
			if UseAtlantisMachine then
				Soundbook:PlaySound(MachineVFXPart, UseAtlantisMachine, true, {
					PlaybackSpeed = 1
				})
			end
		end
		local MachineVFXPart_2 = t.MachineVFXPart
		if not MachineVFXPart_2 then
			return
		end
		local TotemActivated = Soundbook.Sounds.TotemActivated
		if TotemActivated then
			Soundbook:PlaySound(MachineVFXPart_2, TotemActivated, true, {
				PlaybackSpeed = 1
			})
		end
	else
		if p1 ~= "Burst" then
			return
		end
		local MachineVFXPart = t.MachineVFXPart
		if MachineVFXPart then
			local LuckMachineOn = Soundbook.Sounds.LuckMachineOn
			if LuckMachineOn then
				Soundbook:PlaySound(MachineVFXPart, LuckMachineOn, true, {
					PlaybackSpeed = 1
				})
			end
		end
		local MachineVFXPart_2 = t.MachineVFXPart
		if MachineVFXPart_2 then
			local TotemActivated = Soundbook.Sounds.TotemActivated
			if TotemActivated then
				Soundbook:PlaySound(MachineVFXPart_2, TotemActivated, true, {
					PlaybackSpeed = 0.95
				})
			end
		end
		local MachineVFXPart_3 = t.MachineVFXPart
		if not MachineVFXPart_3 then
			return
		end
		local AllTotemsActivated = Soundbook.Sounds.AllTotemsActivated
		if not AllTotemsActivated then
			return
		end
		Soundbook:PlaySound(MachineVFXPart_3, AllTotemsActivated, true, {
			PlaybackSpeed = 1
		})
	end
end
function t7._sellSingle(p1, p2) --[[ _sellSingle | Line: 525 | Upvalues: getBoostData (copy), deliverLocalMessage (copy), PromptController (copy), v1 (copy), t (copy), Soundbook (copy), removeFishEntry (copy), v7 (ref), updateStatusVisuals (copy) ]]
	if getBoostData() then
		deliverLocalMessage("Wait for the current boost to end")
		return
	end
	if p2.IsSecret then
		local v12, v2 = PromptController:FirePrompt((("Sell <b>%*</b> for <font color=\"rgb(104, 255, 213)\">%*</font> points?"):format(p2.Name, p2.Points))):await()
		if not (v12 and v2) then
			return
		end
		local v3, v4 = PromptController:FirePrompt((("Are you REALLY sure you want to sacrifice <b>%*</b>?"):format(p2.Name))):await()
		if not (v3 and v4) then
			return
		end
	end
	local v5 = v1:InvokeServer(p2.UUID)
	if v5 and v5.Success then
		local MachineVFXPart = t.MachineVFXPart
		if MachineVFXPart then
			local CoinsChanged = Soundbook.Sounds.CoinsChanged
			if CoinsChanged then
				Soundbook:PlaySound(MachineVFXPart, CoinsChanged, true, {
					PlaybackSpeed = 1.2
				})
			end
		end
		removeFishEntry(p2)
		v7 = true
		updateStatusVisuals()
	else
		deliverLocalMessage(if v5 then v5.Message or "Unable to sacrifice fish" else "Unable to sacrifice fish")
	end
end
function t7._sellAll(p1) --[[ _sellAll | Line: 556 | Upvalues: getBoostData (copy), deliverLocalMessage (copy), v5 (ref), AtlantisMachineConfig (copy), v4 (ref), PromptController (copy), formatSellAllBreakdown (copy), v9 (ref), v2 (copy), t (copy), Soundbook (copy), v7 (ref), refreshFishList (copy), updateStatusVisuals (copy) ]]
	if getBoostData() then
		deliverLocalMessage("Wait for the current boost to end")
		return
	end
	local v22 = AtlantisMachineConfig:BuildSellAllSummary(if v5 then v5:Get({ "Inventory", "Items" }) or {} else {}, v4:Get("CurrentPoints") or 0)
	if v22.Count == 0 then
		deliverLocalMessage("You have no eligible fish to sacrifice")
		return
	end
	local v3, v42 = PromptController:FirePrompt("Sell your worst fish until the machine fills?"):await()
	if not (v3 and v42) then
		return
	end
	local v52 = if (v22.FavoritedCount or 0) > 0 then "<br/><font color=\"rgb(255, 96, 96)\">Favorited fish cannot be sacrificed.</font>" else ""
	local v72, v8 = PromptController:FirePrompt((("Are you REALLY sure? You are selling <b>%* fish</b> for <font color=\"rgb(104, 255, 213)\">%*</font> points.<br/>%*%*"):format(v22.Count, v22.TotalPoints, formatSellAllBreakdown(v22), v52))):await()
	if not (v72 and v8) then
		return
	end
	v9 = true
	local v92, v10 = pcall(function() --[[ Line: 587 | Upvalues: v2 (ref) ]]
		return v2:InvokeServer()
	end)
	v9 = false
	if not v92 then
		deliverLocalMessage("Unable to sacrifice fish")
		return
	end
	if v10 and v10.Success then
		local MachineVFXPart = t.MachineVFXPart
		if not MachineVFXPart then
			v7 = true
			refreshFishList()
			updateStatusVisuals()
			return
		end
		local CoinsChanged = Soundbook.Sounds.CoinsChanged
		if not CoinsChanged then
			v7 = true
			refreshFishList()
			updateStatusVisuals()
			return
		end
		Soundbook:PlaySound(MachineVFXPart, CoinsChanged, true, {
			PlaybackSpeed = 1
		})
		v7 = true
		refreshFishList()
		updateStatusVisuals()
	else
		deliverLocalMessage(if v10 then v10.Message or "Unable to sacrifice fish" else "Unable to sacrifice fish")
	end
end
function t7.Init(p1) --[[ Init | Line: 608 | Upvalues: UserPriority (copy), t (copy), AtlantisMachineConfig (copy), getMachinePart (copy), PlayerGui (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	t.UnderwaterCity = workspace.Islands:WaitForChild(AtlantisMachineConfig.LocationName)
	t.MachineEffectPart = getMachinePart({ "Screen", "PromptScreen", "PromptPart" })
	t.MachineVFXPart = getMachinePart({ "VFXMachine" })
	local v1 = getMachinePart({ "PromptScreen", "PromptPart", "Screen" })
	t.MachinePrompt = if v1 then v1:FindFirstChild("AtlantisPrompt") else nil
	local v4 = PlayerGui["Atlantis Machine"]
	local Main = v4.Main
	local Odds = v4.Odds
	local BottomBar = v4.BottomBar
	local ScrollingFrame = Main.Scrolling.ScrollingFrame
	local UIListLayout = ScrollingFrame.UIListLayout
	local ScrollingFrame_2 = Odds.BoostOdds.ScrollingFrame
	local ScrollingFrame_3 = Odds.DurationOdds.ScrollingFrame
	local Frame = t.UnderwaterCity:WaitForChild("Atlantis Machine").Label.Tag.Frame
	t.Ui = {
		MainFrame = Main,
		OddsFrame = Odds,
		FishList = ScrollingFrame,
		FishListLayout = ScrollingFrame:FindFirstChildOfClass("UIListLayout"),
		FishTemplates = {
			CommonTemplate = UIListLayout.CommonTemplate,
			UncommonTemplate = UIListLayout.UncommonTemplate,
			RareTemplate = UIListLayout.RareTemplate,
			EpicTemplate = UIListLayout.EpicTemplate,
			LegendaryTemplate = UIListLayout.LegendaryTemplate,
			MythicalTemplate = UIListLayout.MythicalTemplate,
			SecretTemplate = UIListLayout.SecretTemplate
		},
		SellAllButton = Main.Top.Above.SellAll,
		OddsButton = Main.Top.Above.Percentage,
		CloseButton = Main.Close,
		OddsCloseButton = Odds.Close,
		BackButton = Odds.Top.Above.SellAll,
		InventoryValueLabel = Main.InvValue,
		ProgressLabel = Main.Bar.Points,
		MilestoneLabel = Main.Bar.BoostEvent,
		ProgressFill = Main.Bar.InnerBar,
		BoostLabel = Main.BoostInfo,
		BottomTextLabel = Main.BottomText,
		BoostOddsList = ScrollingFrame_2,
		BoostOddsTemplate = ScrollingFrame_2.UIListLayout.Template,
		DurationOddsList = ScrollingFrame_3,
		DurationOddsTemplate = ScrollingFrame_3.UIListLayout.Template,
		BottomFill = BottomBar.Bar.Fill,
		BottomLabel = BottomBar.Status,
		BottomBoostLabel = BottomBar.Boost,
		WorldTimer = Frame.Timer,
		WorldBoostName = Frame.BoostName
	}
end
function t7.Start(p1) --[[ Start | Line: 667 | Upvalues: v4 (ref), Client (copy), AtlantisMachineConfig (copy), v5 (ref), UserPriority (copy), t (copy), v10 (copy), GuiControl (copy), v7 (ref), refreshFishList (copy), v8 (ref), t2 (copy), t7 (copy), Trove (copy), showOdds (copy), showMain (copy), closeMachine (copy), updateStatusVisuals (copy), v9 (ref), v3 (copy), applyEffect (copy), RunService (copy), refreshOdds (copy) ]]
	v4 = Client:WaitReplion(AtlantisMachineConfig.Channel)
	v5 = Client:WaitReplion("Data")
	if UserPriority:IsTradePlaza() then
		return
	end
	local Ui = t.Ui
	for k, v in pairs(Ui.FishTemplates) do
		v.Visible = false
	end
	Ui.BoostOddsTemplate.Visible = false
	Ui.DurationOddsTemplate.Visible = false
	Ui.WorldTimer.Visible = false
	Ui.WorldBoostName.Visible = false
	local FishListLayout = Ui.FishListLayout
	if FishListLayout then
		v10:Add(FishListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ Line: 687 | Upvalues: Ui (copy), FishListLayout (copy) ]]
			Ui.FishList.CanvasSize = UDim2.fromOffset(0, FishListLayout.AbsoluteContentSize.Y + 8)
		end))
	end
	v10:Add(Ui.FishList:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 692 | Upvalues: GuiControl (ref), Ui (copy), v7 (ref), refreshFishList (ref) ]]
		if not (GuiControl:IsOpen("Atlantis Machine") and Ui.MainFrame.Visible) then
			return
		end
		v7 = true
		refreshFishList()
	end))
	v10:Add(GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 699 | Upvalues: Ui (copy), refreshFishList (ref) ]]
		if p1.Name ~= "Atlantis Machine" then
			return
		end
		if not Ui.MainFrame.Visible then
			return
		end
		refreshFishList()
	end))
	v10:Add(GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 709 | Upvalues: v8 (ref), t2 (ref) ]]
		if p1.Name ~= "Atlantis Machine" then
			return
		end
		v8 = v8 + 1
		for i, v in ipairs(t2) do
			v:Destroy()
		end
		table.clear(t2)
	end))
	local v1, v2, v32, v42, v6, v72, v92, v102, v12, v13, v15, v16
	if t.MachinePrompt then
		t.MachinePrompt.Triggered:Connect(function() --[[ Line: 719 | Upvalues: t (ref), GuiControl (ref), v7 (ref), refreshFishList (ref) ]]
			local Ui = t.Ui
			if GuiControl:IsOpen("Atlantis Machine") then
				v7 = true
				refreshFishList()
			else
				GuiControl:Open("Atlantis Machine")
			end
			Ui.MainFrame.Visible = true
			Ui.OddsFrame.Visible = false
		end)
	end
	v1 = Ui.SellAllButton
	v2 = function() --[[ Line: 724 | Upvalues: t7 (ref) ]]
		t7:_sellAll()
	end
	v32 = Trove.new()
	v10:Add(v32)
	v32:Add(GuiControl:Hook("Hold Button", v1, nil, nil, v32).Clicked:Connect(v2))
	v42 = Ui.OddsButton
	v6 = Trove.new()
	v10:Add(v6)
	v6:Add(GuiControl:Hook("Hold Button", v42, nil, nil, v6).Clicked:Connect(showOdds))
	v72 = Ui.BackButton
	v92 = Trove.new()
	v10:Add(v92)
	v92:Add(GuiControl:Hook("Hold Button", v72, nil, nil, v92).Clicked:Connect(showMain))
	v102 = Ui.CloseButton
	v12 = Trove.new()
	v10:Add(v12)
	v12:Add(GuiControl:Hook("Hold Button", v102, nil, nil, v12).Clicked:Connect(closeMachine))
	v13 = Ui.OddsCloseButton
	v15 = Trove.new()
	v10:Add(v15)
	v15:Add(GuiControl:Hook("Hold Button", v13, nil, nil, v15).Clicked:Connect(closeMachine))
	v10:Add(v4:OnChange("CurrentPoints", function() --[[ Line: 733 | Upvalues: updateStatusVisuals (ref) ]]
		updateStatusVisuals()
	end))
	v10:Add(v4:OnChange("ActiveBoostId", function() --[[ Line: 737 | Upvalues: updateStatusVisuals (ref) ]]
		updateStatusVisuals()
	end))
	v10:Add(v4:OnChange("ActiveBoostEndsAt", function() --[[ Line: 741 | Upvalues: updateStatusVisuals (ref) ]]
		updateStatusVisuals()
	end))
	v10:Add(v5:OnChange({ "Inventory", "Items" }, function() --[[ Line: 745 | Upvalues: v9 (ref), v7 (ref) ]]
		if not v9 then
			v7 = true
		end
	end))
	v10:Add(v3.OnClientEvent:Connect(function(p1, p2) --[[ Line: 753 | Upvalues: applyEffect (ref) ]]
		applyEffect(p1, p2)
	end))
	v16 = 0
	v10:Add(RunService.Heartbeat:Connect(function(p1) --[[ Line: 758 | Upvalues: v16 (ref), updateStatusVisuals (ref) ]]
		v16 = v16 + p1
		if not (v16 < 0.2) then
			v16 = 0
			updateStatusVisuals()
		end
	end))
	refreshOdds()
	updateStatusVisuals()
end
return t7