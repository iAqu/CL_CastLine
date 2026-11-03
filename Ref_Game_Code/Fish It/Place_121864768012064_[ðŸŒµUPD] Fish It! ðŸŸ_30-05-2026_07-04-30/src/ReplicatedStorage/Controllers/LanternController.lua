-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Signal)
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Modules.ItemStringUtility)
require(ReplicatedStorage.Shared.StringLibrary)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Shared.GamePassUtility)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Modules.Device)
require(ReplicatedStorage.Modules.InputControl)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.ToolTip)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
require(ReplicatedStorage.Controllers.VendorController)
require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Controllers.PromptController)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local v1 = nil
local Lanterns = Players.LocalPlayer.PlayerGui:WaitForChild("Lanterns")
local v2 = Net:RemoteEvent("EquipLantern")
local v3 = Net:RemoteEvent("UnequipLantern")
local v4 = Lanterns.Main.Content
local Lanterns_2 = v4.Lanterns
local None = v4.None
local Tile = Lanterns_2.Tile
Tile.Parent = nil
local t = {}
local v5 = nil
local v6 = false
local v7 = Trove.new()
local t2 = {
	Init = function(p1) --[[ Init | Line: 67 | Upvalues: GuiControl (copy), Lanterns (copy) ]]
		GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 68 | Upvalues: Lanterns (ref) ]]
			if p1 ~= Lanterns then
				return
			end
			DestroyTiles()
			DrawTiles()
		end)
		GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 75 | Upvalues: Lanterns (ref) ]]
			if p1 ~= Lanterns then
				return
			end
			DestroyTiles()
		end)
	end,
	Start = function(p1) --[[ Start | Line: 82 | Upvalues: v1 (ref), Replion (copy), t (copy) ]]
		v1 = Replion.Client:WaitReplion("Data")
		v1:OnChange("EquippedLanternId", function(p1) --[[ Line: 85 | Upvalues: t (ref) ]]
			for k, v in pairs(t) do
				v.UIStroke.Enabled = v:GetAttribute("Id") == p1
			end
		end)
	end
}
function DrawLanternTile(p1) --[[ DrawLanternTile | Line: 94 | Upvalues: ItemUtility (copy), t (copy), Tile (copy), spr (copy), GuiControl (copy), v1 (ref), v3 (copy), v2 (copy), TierUtility (copy), TradeData (copy), RAPController (copy), StringLibrary (copy), Lanterns_2 (copy) ]]
	if not p1.UUID then
		return
	end
	local v12 = ItemUtility:GetLanternData(p1.Id)
	if not v12 then
		return
	end
	if v12.Price and t[v12.Data.Id] then
		return
	end
	local v22 = Tile:Clone()
	v22:SetAttribute("Id", v12.Data.Id)
	t[p1.UUID] = v22
	local EquipAsSkin = v22.EquipAsSkin
	v22.Padded.Top.Label.Text = v12.Data.Name or ""
	v22.BG.Vector.Image = v12.Data.Icon or ""
	local function onSkinChanged(p1) --[[ onSkinChanged | Line: 121 | Upvalues: spr (ref), EquipAsSkin (copy), v12 (copy) ]]
		spr.stop(EquipAsSkin)
		if p1 == v12.Data.Id then
			EquipAsSkin.Label.Text = "UNEQUIP SKIN"
			spr.target(EquipAsSkin, 3, 10, {
				ImageColor3 = Color3.fromRGB(255, 94, 97)
			})
		else
			EquipAsSkin.Label.Text = "EQUIP SKIN"
			spr.target(EquipAsSkin, 3, 10, {
				ImageColor3 = Color3.fromRGB(123, 187, 255)
			})
		end
	end
	local v32 = GuiControl:Hook("Hold Button", EquipAsSkin)
	local v4 = v1:OnChange("EquippedLanternId", onSkinChanged)
	v32.Cleaner:Add(function() --[[ Line: 140 | Upvalues: v4 (copy) ]]
		v4:Disconnect()
	end)
	v32.Clicked:Connect(function() --[[ Line: 144 | Upvalues: v1 (ref), v12 (copy), v3 (ref), v2 (ref), GuiControl (ref) ]]
		if v1:GetExpect("EquippedLanternId") == v12.Data.Id then
			v3:FireServer()
		else
			v2:FireServer(v12.Data.Id)
			GuiControl:Close()
		end
	end)
	onSkinChanged(v1.Data.EquippedLanternId)
	EquipAsSkin.Visible = true
	local Tier = v12.Data.Tier
	local v5 = if Tier then TierUtility:GetTier(Tier) else Tier
	if v5 and Tier > 1 then
		v22.BG.Glow.UIGradient.Color = v5.TierColor
		v22.UIStroke.Color = v5.TierColor.Keypoints[1].Value
		v22.BG.Glow.Visible = true
	else
		v22.BG.Glow.Visible = false
	end
	local RapCounter = v22.RapCounter
	if TradeData.FollowTradeRules(v12, p1) then
		local v6 = RAPController:GetRAP(v12.Data.Type, v12.Data.Name)
		RapCounter.Counter.Text = if v6 then StringLibrary:AddCommas(v6) else "???"
		RapCounter.Visible = true
	else
		RapCounter.Visible = false
	end
	v22.UIStroke.Enabled = if v1.Data.EquippedLanternId == v12.Data.Id then true else false
	v22.LayoutOrder = if v12.Modifiers then (v12.Modifiers.BaseLuck or 0) * -1000 else string.len(v12.Data.Name)
	v22.Parent = Lanterns_2
end
function DrawTiles() --[[ DrawTiles | Line: 191 | Upvalues: v6 (ref), HttpService (copy), v5 (ref), v1 (ref), t (copy), None (copy), Lanterns_2 (copy) ]]
	if v6 then
		return
	end
	v6 = true
	local v12 = HttpService:GenerateGUID(false)
	v5 = v12
	local Lanterns = v1:GetExpect({ "Inventory" }).Lanterns
	local v2 = t
	local v3 = false
	for i, v in ipairs(Lanterns) do
		if v12 ~= v12 then
			break
		end
		DrawLanternTile(v)
	end
	if v2 and next(v2) == nil then
		v3 = true
	end
	None.Visible = v3
	Lanterns_2.Visible = not v3
	v6 = false
end
function DestroyTiles() --[[ DestroyTiles | Line: 230 | Upvalues: v7 (copy), t (copy), v6 (ref) ]]
	v7:Clean()
	for v1, v2 in t do
		v2:Destroy()
	end
	table.clear(t)
	v6 = false
end
return t2