-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local LocalPlayer = Players.LocalPlayer
LocalPlayer.PlayerGui:WaitForChild("Crafting")
local v1 = Net:RemoteFunction("StartCrafting")
local v2 = Net:RemoteFunction("CancelCrafting")
local v3 = Net:RemoteFunction("ConfirmCrafting")
local CharmCrafting = script.Parent.Parent:WaitForChild("Styles"):WaitForChild("CharmCrafting")
local Tile = CharmCrafting.Frame.ActiveTile.Fish.Scroll.Tile
Tile.Parent = nil
local Sample = CharmCrafting.Frame.ActiveTile.Info.Frame.Sample
Sample.Parent = nil
local v4 = false
local v5 = Signal.new()
local v6 = false
local v7 = Trove.new()
local v8 = nil
local function SetState(p1) --[[ SetState | Line: 47 | Upvalues: v4 (ref), v5 (copy) ]]
	v4 = p1
	v5:Fire(p1)
end
local function QuitCrafting() --[[ QuitCrafting | Line: 52 | Upvalues: v2 (copy), v4 (ref), v5 (copy) ]]
	v2:InvokeServer()
	v4 = false
	v5:Fire(false)
end
local function EnableGui(p1, p2, p3) --[[ EnableGui | Line: 59 | Upvalues: ItemUtility (copy), TierUtility (copy), PlayerStatsUtility (copy), Sample (copy), v7 (copy), Tile (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v1 then
		return
	end
	local Frame = p1:WaitForChild("Frame", 5)
	if not Frame then
		return
	end
	local Info = Frame.ActiveTile.Info
	local Id = v1.Data.Id
	local v5 = v1.Modifiers.BaseLuck or 0
	local v6 = if v1.Probabiltity then TierUtility:GetTierFromRarity(v1.Probability.Chance) else TierUtility:GetTier(v1.Data.Tier)
	local Display = Info.Display
	Frame.Label.Text = v1.Data.Name
	Frame.Box.UIStroke.UIGradient.Color = v6.TierColor
	Display.UIStroke.UIGradient.Color = v6.TierColor
	Display.Inner.Glow.UIGradient.Color = v6.TierColor
	Display.Inner.ItemName.Text = v1.Data.Name
	Display.Inner.Vector.Image = v1.Data.Icon or ""
	if v6.Tier >= 5 then
		Frame.Box.UIStroke.UIGradient:AddTag("AnimateTier")
		Display.UIStroke.UIGradient:AddTag("AnimateTier")
		Display.Inner.Glow.UIGradient:AddTag("AnimateTier")
	end
	Info.Frame.Level.Counter.Text = ("%d"):format(v1.Level or 0)
	Info.Frame.Uses.Counter.Text = ("%d"):format(v1.Uses or 0)
	Info.Frame.Luck.Counter.Text = ("%*%%"):format((math.round(v5 * 100)))
	Info.Frame.Luck.Visible = if v5 > 0 then true else false
	if v1.Modifiers then
		for v11, v12 in v1.Modifiers do
			local v10
			if v11 ~= "BaseLuck" then
				local v13, v14 = PlayerStatsUtility:GetModifierDisplayName(v11)
				if v13 then
					v10 = if v13:find("Multi") or v11:find("Multiplier") then ("x%*"):format(math.round((1 + v12) * 10) / 10) else ("%*%%"):format((math.round(v12 * 100)))
					local v17 = Sample:Clone()
					v17.Label.Text = ("%*:"):format(v13)
					v17.Counter.Text = v10
					v17.Counter.UIGradient.Color = ColorSequence.new(v14)
					v17.LayoutOrder = math.abs(v12 * 100)
					v17.Parent = Info.Frame
					v7:Add(v17)
				end
			end
		end
	end
	local v18 = false
	if v1.FishModifiers then
		for v20, v21 in v1.FishModifiers do
			local v19
			local v22 = ItemUtility.GetItemDataFromItemType("Fish", v20)
			if v22 then
				local v23 = string.len(v20)
				if v22.Probabiltity then
					v23 = 1 / v22.Probability.Chance
					v19 = TierUtility:GetTierFromRarity(v22.Probability.Chance)
				else
					v19 = TierUtility:GetTier(v22.Data.Tier)
				end
				local v26 = Tile:Clone()
				v26.Inner.Top.Counter.Text = ("x%* Chance"):format(math.floor((v21 + 1) * 10) / 10)
				v26.Inner.Glow.UIGradient.Color = v19.TierColor
				v26.UIStroke.UIGradient.Color = v19.TierColor
				v26.Inner.Configuration.ItemName.Text = v22.Data.Name
				v26.Inner.Vector.Image = v22.Data.Icon or ""
				v26.LayoutOrder = v23
				v26.Parent = Frame.ActiveTile.Fish.Scroll
				v7:Add(v26)
				v18 = true
			end
		end
	end
	local v28
	if v1.Perks then
		for v29, v30 in v1.Perks do

		end
		v28 = true
	else
		v28 = false
	end
	Frame.ActiveTile.Perk.Visible = v28
	Frame.ActiveTile.Fish.Visible = v18
end
local function RunUpdate(p1, p2, p3, p4) --[[ RunUpdate | Line: 201 | Upvalues: v8 (ref), v6 (ref), v4 (ref), v7 (copy), GuiControl (copy), v2 (copy), v5 (copy), v3 (copy), Soundbook (copy), v1 (copy), LocalPlayer (copy), EnableGui (copy) ]]
	v8 = p1
	if v6 then
		return
	end
	v4 = false
	v6 = true
	v7:Clean()
	local Craft = p1.Frame.Craft
	local Counter = Craft.Counter
	local v12 = GuiControl:Hook("Hold Button", p1.Frame.Close)
	local v22 = GuiControl:Hook("Hold Button", Craft)
	v12.Clicked:Connect(function() --[[ Line: 225 | Upvalues: v2 (ref), v4 (ref), v5 (ref) ]]
		v2:InvokeServer()
		v4 = false
		v5:Fire(false)
	end)
	v22.Clicked:Connect(function() --[[ Line: 229 | Upvalues: v4 (ref), v3 (ref), Soundbook (ref), v5 (ref), v1 (ref), p3 (copy) ]]
		if v4 then
			if not v3:InvokeServer() then
				return
			end
			Soundbook.Sounds.CraftSound:Play()
			v4 = false
			v5:Fire(false)
		else
			if not v1:InvokeServer(p3) then
				return
			end
			v4 = true
			v5:Fire(true)
		end
	end)
	local function RefreshPage() --[[ RefreshPage | Line: 247 | Upvalues: LocalPlayer (ref), Craft (copy) ]]
		if LocalPlayer:GetAttribute("InstantCraftReroll") then
			Craft.Visible = false
		else
			Craft.Visible = true
		end
	end
	local function UpdateState(p1) --[[ UpdateState | Line: 256 | Upvalues: v4 (ref), GuiControl (ref), p4 (copy), Counter (copy), LocalPlayer (ref), Craft (copy) ]]
		local v1 = v4
		if not (p1 or v1) then
			GuiControl:Unlock()
			p4()
		end
		if Counter and Counter.Parent then
			Counter.Text = if v1 then "CONFIRM" else "START CRAFTING"
		end
		if LocalPlayer:GetAttribute("InstantCraftReroll") then
			Craft.Visible = false
		else
			Craft.Visible = true
		end
	end
	local v32 = LocalPlayer:GetAttributeChangedSignal("InstantCraftReroll"):Connect(RefreshPage)
	if LocalPlayer:GetAttribute("InstantCraftReroll") then
		Craft.Visible = false
	else
		Craft.Visible = true
	end
	local v42 = v5:Connect(UpdateState)
	local v52 = v4
	if Counter and Counter.Parent then
		Counter.Text = if v52 then "CONFIRM" else "START CRAFTING"
	end
	if LocalPlayer:GetAttribute("InstantCraftReroll") then
		Craft.Visible = false
	else
		Craft.Visible = true
	end
	v7:Add(function() --[[ Line: 278 | Upvalues: v12 (copy), v32 (ref), v42 (ref) ]]
		v12:Destroy()
		v32:Disconnect()
		v42:Disconnect()
	end)
	EnableGui(p1, p2, p3)
	v6 = false
end
GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 291 | Upvalues: v2 (copy), v4 (ref), v5 (copy) ]]
	task.wait(0.1)
	v2:InvokeServer()
	v4 = false
	v5:Fire(false)
end)
return RunUpdate