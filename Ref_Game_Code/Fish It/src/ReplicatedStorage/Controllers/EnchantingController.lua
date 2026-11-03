-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
require(ReplicatedStorage.Modules.Util.TableUtil)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local RNG = require(ReplicatedStorage.Shared.RNG)
require(ReplicatedStorage.Shared.StringLibrary)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Shared.WeightRandom)
local Constants = require(ReplicatedStorage.Shared.Constants)
local Enchants = require(ReplicatedStorage.Enchants)
require(ReplicatedStorage.Items)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Types.Enchanting)
local CoreCall = require(ReplicatedStorage.Modules.CoreCall)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local HUDController = require(ReplicatedStorage.Controllers.HUDController)
local VFXController = require(ReplicatedStorage.Controllers.VFXController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local BackpackController = require(ReplicatedStorage.Controllers.BackpackController)
local DialogueController = require(ReplicatedStorage.Controllers.DialogueController)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local v2 = Net:RemoteFunction("CreateTranscendedStone")
local v3 = Net:RemoteEvent("ActivateEnchantingAltar")
local v4 = Net:RemoteEvent("ActivateSecondEnchantingAltar")
local v5 = Net:RemoteEvent("UpdateEnchantState")
local v6 = Net:RemoteEvent("RollEnchant")
local ScrollingFrame = PlayerGui:WaitForChild("EnchantWorldGui").Content.ScrollingFrame
local v7 = PlayerGui:WaitForChild("Enchants Store")
local ScrollingFrame_2 = v7.Content.Index.ScrollingFrame
local Template = ScrollingFrame_2.Template
Template.Parent = nil
local v8 = PlayerGui:WaitForChild("Roll Enchant")
local Main = v8.Main
local Inside = Main.Inside
Inside.Parent = nil
local v9 = nil
local v10 = workspace:WaitForChild("! ENCHANTING ALTAR !")
local v11 = workspace:WaitForChild("! SECOND ENCHANTING ALTAR !")
local function fnv1a(p1) --[[ fnv1a | Line: 75 ]]
	local v1 = 2166136261
	for i = 1, #p1 do
		v1 = bit32.bxor(v1, p1:byte(i)) * 16777619 % 4294967296
	end
	return v1
end
local function romanNumeralToInteger(p1) --[[ romanNumeralToInteger | Line: 87 ]]
	local sum = 1
	local t = {
		I = 1,
		V = 5,
		X = 10
	}
	local sum_2 = 0
	while sum <= #p1 do
		local v1 = t[p1:sub(sum, sum)]
		local v2 = t[p1:sub(sum + 1, sum + 1)]
		if v2 and v1 < v2 then
			sum = sum + 2
			sum_2 = sum_2 + (v2 - v1)
		else
			sum = sum + 1
			sum_2 = sum_2 + v1
		end
	end
	return sum_2
end
local function getHashedPosition(p1) --[[ getHashedPosition | Line: 107 | Upvalues: fnv1a (copy), romanNumeralToInteger (copy) ]]
	local v1, v2 = p1:match("^(.-)%s+([IVXLCDM]+)$")
	if not (v1 and v2) then
		return 0
	end
	if v1:match("^%s*(.-)%s*$") then
		local v3 = fnv1a(v1)
		local v4 = romanNumeralToInteger(v2)
		return math.log10(v3) + v4
	else
		return 0
	end
end
local t = {}
function t.Start(p1) --[[ Start | Line: 129 | Upvalues: v1 (ref), Replion (copy), v6 (copy), t (copy), v5 (copy), DialogueController (copy), TextNotificationController (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	v6.OnClientEvent:Connect(function(...) --[[ Line: 134 | Upvalues: t (ref) ]]
		t:RollEnchant(...)
	end)
	v5.OnClientEvent:Connect(function(...) --[[ Line: 138 | Upvalues: t (ref) ]]
		t:UpdateEnchantState(...)
	end)
	DialogueController:ObservePath("Temple Guardian", 3, function(p1) --[[ Line: 142 | Upvalues: t (ref), TextNotificationController (ref) ]]
		if p1 ~= 2 then
			return
		end
		local v1, v2 = t:StartTranscendedStone()
		if v1 then
			return
		end
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v2 or "Unknown error",
			TextColor = {
				R = 0,
				G = 255,
				B = 0
			}
		})
	end)
end
function t.Init(p1) --[[ Init | Line: 157 | Upvalues: Observers (copy), ItemUtility (copy), Enchants (copy), fnv1a (copy), romanNumeralToInteger (copy), GuiControl (copy), v7 (copy), t (copy), ScrollingFrame_2 (copy), LocalPlayer (copy), ScrollingFrame (copy) ]]
	Observers.observeTag("RenderEnchants", function(p1) --[[ Line: 159 | Upvalues: ItemUtility (ref), Enchants (ref), fnv1a (ref), romanNumeralToInteger (ref) ]]
		local v2 = ItemUtility.GetItemDataFromItemType("Enchant Stones", (p1:GetAttribute("ItemIdentifier")))
		if not v2 then
			return
		end
		if not v2.Enchants then
			return
		end
		local Label = p1.Label
		for v4, v5 in v2.Enchants do
			local v3
			local v6 = Enchants[v4]
			if v6 then
				local v7, v8 = v4:match("^(.-)%s+([IVXLCDM]+)$")
				if v7 and v8 and v7:match("^%s*(.-)%s*$") then
					local v9 = fnv1a(v7)
					local v10 = romanNumeralToInteger(v8)
					v3 = math.log10(v9) + v10
				else
					v3 = 0
				end
				local v11 = Label:Clone()
				v11.Text = ("%s - %d%%"):format(v6.Data.Name, v5)
				v11.UIGradient.Color = v6.Data.TierColor
				v11.LayoutOrder = v3
				v11.Parent = p1
			end
		end
		Label:Destroy()
	end)
	local v1 = nil
	v1 = GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 194 | Upvalues: v7 (ref), v1 (ref), t (ref), ScrollingFrame_2 (ref) ]]
		if p1 ~= v7 then
			return
		end
		v1:Disconnect()
		t:_populate(ScrollingFrame_2)
	end)
	local v2 = nil
	v2 = LocalPlayer:GetAttributeChangedSignal("LocationName"):Connect(function() --[[ Line: 202 | Upvalues: LocalPlayer (ref), v2 (ref), t (ref), ScrollingFrame (ref) ]]
		if LocalPlayer:GetAttribute("LocationName") == "Mutation Cellar" then
			v2:Disconnect()
			t:_populate(ScrollingFrame)
		end
	end)
end
function t._populate(p1, p2) --[[ _populate | Line: 214 | Upvalues: ItemUtility (copy), fnv1a (copy), romanNumeralToInteger (copy), Template (copy), TierUtility (copy) ]]
	local v1 = ItemUtility:GetEnchantStones()
	local t = {}
	for v2, v3 in v1 do
		if not v3.SecondEnchantStone then
			for v4 in v3.Enchants do
				t[v4] = true
			end
		end
	end
	for i = #v1, 1, -1 do
		local v5 = v1[i]
		if not (v5.SecondEnchantStone or v5.Probability) then
			table.remove(v1, i)
		end
	end
	table.sort(v1, function(p1, p2) --[[ Line: 237 ]]
		return (p1.Probability or {
			Chance = 4e-6
		}).Chance < (p2.Probability or {
			Chance = 4e-6
		}).Chance
	end)
	for v7, v8 in v1 do
		local v6
		for v10 in v8.Enchants do
			local v9
			local v11 = ItemUtility:GetEnchantData(v10)
			if v11 then
				local v12, v13 = v10:match("^(.-)%s+([IVXLCDM]+)$")
				if v12 and v13 and v12:match("^%s*(.-)%s*$") then
					local v14 = fnv1a(v12)
					local v15 = romanNumeralToInteger(v13)
					v9 = math.log10(v14) + v15
				else
					v9 = 0
				end
				local v16 = Template:Clone()
				v16.Lower.Description.Text = v11.Data.Description
				v16.Top.EnchantLabel.Text = v10
				v16.Top.EnchantLabel.UIGradient.Color = v11.Data.TierColor
				v16.LayoutOrder = v7 * 10000 + 500 + v9
				v16.Parent = p2
			end
		end
		v6 = if v8.Probability then TierUtility:GetTierFromRarity(v8.Probability.Chance) else TierUtility:GetTier(v8.Data.Tier)
		local v19 = script.Divider:Clone()
		v19.Label.Text = v8.Data.Name
		v19.Label.UIGradient.Color = v6.TierColor
		v19.Vector.Image = v8.Data.Icon
		v19.LayoutOrder = v7 * 10000 + 50
		v19.Parent = p2
	end
end
function t.StartTranscendedStone(p1) --[[ StartTranscendedStone | Line: 310 | Upvalues: v1 (ref), Constants (copy), PlayerStatsUtility (copy), ItemUtility (copy), TierUtility (copy), v2 (copy) ]]
	if v1:GetExpect("Level") < Constants.SecondEnchantingLevel then
		return false, "Requires Level 200"
	end
	local v12 = v1:GetExpect("EquippedId")
	local v22 = v1:GetExpect("EquippedType")
	if string.len(v12) == 0 then
		return false, "You have nothing equipped!"
	end
	if string.len(v22) == 0 or v22 ~= "Fish" then
		return false, "You are not holding a fish!"
	end
	local v3, _ = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 320 | Upvalues: v12 (copy) ]]
		return p1.UUID == v12
	end, "Items")
	if not v3 then
		return false, "No item found!"
	end
	local v4 = ItemUtility.GetItemDataFromItemType("Fish", v3.Id)
	if not v4 then
		return false, "Unable to find item!"
	end
	if v4.Data.Type ~= "Fish" then
		return false, "Held item is not a fish!"
	end
	if not v4.Probability then
		return false, "Invalid item!"
	end
	if TierUtility:GetTierFromRarity(v4.Probability.Chance).Tier == 7 then
		local v5, v6 = v2:InvokeServer()
		return v5, v6
	else
		return false, "You are not holding a SECRET fish!"
	end
end
function t.Activate(p1, p2, p3) --[[ Activate | Line: 338 | Upvalues: v1 (ref), Promise (copy), Constants (copy), v4 (copy), v3 (copy) ]]
	local v12 = v1:GetExpect("EquippedId")
	local v2 = v1:GetExpect("EquippedType")
	local v32 = v1:GetExpect("Level")
	if string.len(v12) == 0 then
		return Promise.reject("You have nothing equipped!", true)
	end
	if v2 ~= "Enchant Stones" then
		return Promise.reject("Wrong item type equipped!", true)
	end
	if p2 then
		if v32 < Constants.SecondEnchantingLevel then
			return Promise.reject("You must be Level 200!", true)
		end
		v4:FireServer()
	else
		if v32 < Constants.EnchantingLevel then
			return Promise.reject("You must be Level 10!", true)
		end
		v3:FireServer(p3)
	end
	return Promise.resolve()
end
function t.UpdateEnchantState(p1, p2, p3) --[[ UpdateEnchantState | Line: 368 | Upvalues: v11 (copy), v10 (copy), v9 (ref), ProximityPromptService (copy), Soundbook (copy), VFXController (copy), t (copy) ]]
	if (workspace.CurrentCamera.CFrame.Position - p3.CastCFrame.Position).Magnitude > 200 then
		return
	end
	local v1
	if p3.SecondEnchant then
		v1 = v11
	else
		local SpecialEnchant = p3.SpecialEnchant
		v1 = v10
	end
	v9 = p3
	ProximityPromptService.Enabled = false
	task.delay(8, function() --[[ Line: 383 | Upvalues: ProximityPromptService (ref) ]]
		ProximityPromptService.Enabled = true
	end)
	Soundbook.Sounds.EnchantStonePlaced:Play()
	VFXController:RenderAtPoint("Enchant Stone Placed", p3.TomeCFrame)
	VFXController:RenderAtPoint("Enchant Glow", p3.TomeCFrame)
	if p3.SecondEnchant then
		Soundbook.Sounds.SacreficeSequence:Play()
		task.spawn(function() --[[ Line: 396 | Upvalues: VFXController (ref), p3 (copy) ]]
			VFXController:RenderAtPoint("SACRIFICE", CFrame.new(p3.CastCFrame.Position - Vector3.new(0, 5, 0)))
		end)
	else
		task.delay(0.2, function() --[[ Line: 400 | Upvalues: Soundbook (ref), VFXController (ref), p3 (copy) ]]
			Soundbook.Sounds.EnchantImplosion:Play()
			VFXController:RenderAtPoint("Enchant Explosion", p3.CastCFrame)
		end)
	end
	task.delay(2, function() --[[ Line: 407 | Upvalues: v1 (copy), p3 (copy), t (ref) ]]
		local v12 = v1:FindFirstChild("PlaceholderEnchantTome") or p3.Tome
		if not v12 then
			return
		end
		t:_fadeModel(v12)
	end)
end
function t.RollEnchant(p1, p2, p3, p4, p5) --[[ RollEnchant | Line: 415 | Upvalues: ItemUtility (copy), v9 (ref), v11 (copy), v10 (copy), GuiControl (copy), t (copy), spr (copy), v8 (copy), Inside (copy), Main (copy), HUDController (copy), VFXController (copy), RNG (copy), Soundbook (copy), LocalPlayer (copy), BackpackController (copy) ]]
	if p5 then
		task.wait(3)
	end
	local v1 = ItemUtility.GetItemDataFromItemType("Enchant Stones", p4)
	if not v1 then
		print("[EnchantingController] No enchant stone data")
		return
	end
	local Enchants = v1.Enchants
	if not Enchants then
		print("[EnchantingController] No enchant pool")
		return
	end
	local v2 = ItemUtility:GetEnchantData(p3)
	if not v2 then
		print("[EnchantingController] No winning enchant data")
		return
	end
	local v3 = if v9 and v9.SecondEnchant then true else false
	local _ = v9 and v9.SpecialEnchant and true or false
	local v4 = if v3 then v11 else v10
	GuiControl:Close(true)
	GuiControl:Lock()
	t:_setCoreGui(false)
	spr.stop(v8.Vignette)
	v8.Vignette.ImageTransparency = 1
	local v5 = Inside:Clone()
	v5.Lower.Description.Visible = false
	v5.Visible = false
	v5.Parent = Main
	GuiControl:Open("Roll Enchant", true)
	GuiControl:Lock()
	HUDController.SetCameraFOV(55)
	spr.target(v8.Vignette, 1, 3, {
		ImageTransparency = 0.45
	})
	task.wait(0.2)
	GuiControl:Open("Roll Enchant", true)
	GuiControl:Lock()
	if v9 and v9.Floor then
		VFXController:RenderAtPoint("Enchant Enable", v9.Floor)
	end
	local v6 = math.random(17, 20)
	for i = 1, v6 do
		local v7 = if i == v6 then true else false
		local v82 = nil
		if v7 then
			v82 = v2
		else
			local v92 = RNG.Weighted:Random(Enchants)
			local v102 = if v92 then ItemUtility:GetEnchantData(v92) else v92
			if v102 then
				v82 = v102
			end
		end
		Soundbook.Sounds.EnchantStoneTick:Play().PlaybackSpeed = 1 + i / v6 * 0.2
		if v82 then
			spr.stop(v5)
			v5.Visible = false
			v5.Position = UDim2.fromScale(0.5, 0.4)
			if v7 then
				v5.UIScale.Scale = 2.5
				v5.Lower.Description.Text = v82.Data.Description
				v5.Lower.Description.Visible = true
			else
				v5.UIScale.Scale = 1
				v5.Lower.Description.Visible = false
			end
			v5.Top.EnchantLabel.Text = v82.Data.Name
			spr.stop(v5.Top.EnchantLabel.UIGradient)
			spr.stop(v8.Vignette)
			spr.stop(v5)
			spr.target(v8.Vignette.UIGradient, 90, 325, {
				Color = v82.Data.TierColor
			})
			spr.target(v5.Top.EnchantLabel.UIGradient, 90, 325, {
				Color = v82.Data.TierColor
			})
			if v7 then
				spr.target(v5.UIScale, 90, 250, {
					Scale = 1.5
				})
				Soundbook.Sounds.EnchantRecieved:Play()
			end
			spr.target(v5, 1, 3, {
				Position = UDim2.fromScale(0.5, 0.5)
			})
			v5.Visible = true
		end
		if v7 then
			break
		end
		task.wait(0.1)
	end
	task.wait(2)
	spr.stop(v5.UIScale)
	spr.stop(v8.Vignette)
	spr.target(v8.Vignette, 1, 3, {
		ImageTransparency = 1
	})
	if v9 then
		local v112 = v4:FindFirstChild("PlaceholderEnchantRod") or v9.Rod
		if v112 then
			task.delay(1, function() --[[ Line: 573 | Upvalues: t (ref), v112 (copy) ]]
				t:_fadeModel(v112)
			end)
		end
		local v12 = v4:FindFirstChild("PlaceholderEnchantTome") or v9.Tome
		if v12 then
			task.delay(1, function() --[[ Line: 580 | Upvalues: t (ref), v12 (copy) ]]
				t:_fadeModel(v12)
			end)
		end
	end
	if LocalPlayer:GetAttribute("IgnoreFOV") or LocalPlayer:GetAttribute("InCutscene") then
		FadeTile(v5)
		task.wait(1)
		BackpackController:Refresh()
		GuiControl:Unlock()
		GuiControl:Close(true)
		task.delay(1, function() --[[ Line: 599 | Upvalues: t (ref) ]]
			t:_setCoreGui(true)
		end)
		v9 = nil
		return
	end
	HUDController.ResetCamera()
	FadeTile(v5)
	task.wait(1)
	BackpackController:Refresh()
	GuiControl:Unlock()
	GuiControl:Close(true)
	task.delay(1, function() --[[ Line: 599 | Upvalues: t (ref) ]]
		t:_setCoreGui(true)
	end)
	v9 = nil
end
function t._fadeModel(p1, p2) --[[ _fadeModel | Line: 607 | Upvalues: spr (copy) ]]
	if not p2 then
		return
	end
	if p2:GetAttribute("TweenOut") then
		return
	end
	p2:SetAttribute("TweenOut", true)
	for i, v in ipairs(p2:GetDescendants()) do
		if v:IsA("BasePart") then
			spr.target(v, 1, 3, {
				Transparency = 1
			})
		end
		if v:IsA("ParticleEmitter") or (v:IsA("Beam") or (v:IsA("Light") or v:IsA("Trail"))) then
			v.Enabled = false
		end
	end
end
function t._setCoreGui(p1, p2) --[[ _setCoreGui | Line: 631 | Upvalues: ProximityPromptService (copy), CoreCall (copy) ]]
	ProximityPromptService.Enabled = p2
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, p2)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, p2)
end
function t._reportError(p1, p2) --[[ _reportError | Line: 637 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p2,
		TextColor = {
			R = 255,
			G = 58,
			B = 84
		}
	})
end
function FadeTile(p1) --[[ FadeTile | Line: 646 | Upvalues: spr (copy) ]]
	local t = {
		TextStrokeTransparency = {},
		TextTransparency = {},
		Transparency = {}
	}
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Frame") and v.BackgroundTransparency < 1 then
			table.insert(t.BackgroundTransparency, v)
			continue
		end
		if v:IsA("TextLabel") and v.TextTransparency < 1 then
			table.insert(t.TextStrokeTransparency, v)
			table.insert(t.TextTransparency, v)
			continue
		end
		if v:IsA("UIStroke") and v.Transparency < 1 then
			table.insert(t.Transparency, v)
			continue
		end
		if v:IsA("ImageLabel") and v.ImageTransparency < 1 then
			table.insert(t.ImageTransparency, v)
		end
	end
	for v1, v2 in t do
		for i, v in ipairs(v2) do
			spr.target(v, 60, 250, {
				[v1] = 1
			})
		end
	end
	task.delay(0.4, function() --[[ Line: 686 | Upvalues: p1 (copy) ]]
		p1:Destroy()
	end)
end
return t