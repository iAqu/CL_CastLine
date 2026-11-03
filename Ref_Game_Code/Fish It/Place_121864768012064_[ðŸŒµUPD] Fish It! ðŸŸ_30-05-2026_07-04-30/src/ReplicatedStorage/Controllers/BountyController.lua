-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Thread)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local BountyUtility = require(ReplicatedStorage.Shared.BountyUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local VendorUtility = require(ReplicatedStorage.Shared.VendorUtility)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Net:RemoteEvent("LockBounty")
local v2 = Net:RemoteEvent("UnlockBounty")
local v3 = Net:RemoteFunction("ClaimBounty")
local LocalPlayer = Players.LocalPlayer
local v4 = nil
local t = {}
function t.SetupBountyBoard(p1, p2, p3) --[[ SetupBountyBoard | Line: 46 | Upvalues: v4 (ref), Replion (copy), t (copy) ]]
	if not v4 then
		v4 = Replion.Client:WaitReplion("Data")
	end
	p3:WaitForChild("Gui")
	p3:WaitForChild("Decal")
	local function ObserveBounty() --[[ ObserveBounty | Line: 54 | Upvalues: v4 (ref), p2 (copy), t (ref), p3 (copy) ]]
		v4:OnChange({ "Bounty", "Slots", p2 }, function() --[[ Line: 55 | Upvalues: t (ref), p2 (ref), p3 (ref) ]]
			t:UpdateBounty(p2, p3)
		end)
		t:UpdateBounty(p2, p3)
		t:RegisterBounty(p2, p3)
	end
	if v4:Get("Bounty") then
		ObserveBounty()
	else
		local v1 = nil
		v1 = v4:OnChange("Bounty", function() --[[ Line: 67 | Upvalues: v1 (ref), ObserveBounty (copy) ]]
			v1:Disconnect()
			ObserveBounty()
		end)
	end
	local Gui = p3:WaitForChild("Gui")
	if Gui then
		Gui.Enabled = true
	end
	local Decal = p3:WaitForChild("Decal")
	if not Decal then
		return
	end
	Decal.Transparency = 0
end
function t.RegisterBounty(p1, p2, p3) --[[ RegisterBounty | Line: 84 | Upvalues: v4 (ref), TextNotificationController (copy), t (copy), Soundbook (copy), v1 (copy), v2 (copy), PlayerStatsUtility (copy), BountyUtility (copy), v3 (copy) ]]
	local v12 = script.EnrollAttachment:Clone()
	local v22 = script.UnenrollAttachment:Clone()
	local v32 = script.ClaimAttachment:Clone()
	local v42 = 0
	local v5 = script.TimerGui:Clone()
	v5.Enabled = false
	local function RemoveTimer() --[[ RemoveTimer | Line: 97 | Upvalues: v5 (copy) ]]
		v5.Frame.Remaining:SetAttribute("Expires", 0)
		v5.Frame.Remaining:RemoveTag("DHMSLabel")
		v5.Enabled = false
	end
	local function ActivateTimer(p1) --[[ ActivateTimer | Line: 104 | Upvalues: v4 (ref), v5 (copy) ]]
		v5.Frame.Remaining:SetAttribute("Expires", v4:Get({ "Bounty", "LastUpdate" }) + 86400)
		v5.Frame.Remaining:AddTag("DHMSLabel")
		v5.Enabled = true
	end
	local function SuccessAction(p1) --[[ SuccessAction | Line: 115 | Upvalues: TextNotificationController (ref) ]]
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p1,
			TextColor = {
				R = 0,
				G = 255,
				B = 0
			}
		})
	end
	local function ReportUserError(p1) --[[ ReportUserError | Line: 123 | Upvalues: TextNotificationController (ref) ]]
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p1,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
	local function Refresh() --[[ Refresh | Line: 131 | Upvalues: t (ref), p2 (copy), v12 (copy), v22 (copy), v32 (copy), ActivateTimer (copy), v5 (copy) ]]
		local v1 = t:_getBountySlot(p2)
		if v1 == nil or v1 and v1.Claimed then
			v12.ProximityPrompt.Enabled = false
			v22.ProximityPrompt.Enabled = false
			v32.ProximityPrompt.Enabled = false
			if v1 and v1.Claimed then
				ActivateTimer(v1)
			else
				v5.Frame.Remaining:SetAttribute("Expires", 0)
				v5.Frame.Remaining:RemoveTag("DHMSLabel")
				v5.Enabled = false
			end
		elseif v1.Locked then
			v12.ProximityPrompt.Enabled = false
			v22.ProximityPrompt.Enabled = true
			v32.ProximityPrompt.Enabled = true
			v5.Frame.Remaining:SetAttribute("Expires", 0)
			v5.Frame.Remaining:RemoveTag("DHMSLabel")
			v5.Enabled = false
		else
			v12.ProximityPrompt.Enabled = true
			v22.ProximityPrompt.Enabled = false
			v32.ProximityPrompt.Enabled = false
			ActivateTimer(v1)
		end
	end
	v4:OnChange({ "Bounty", "LastUpdate", p2 }, Refresh)
	v4:OnChange({ "Bounty", "Slots", p2 }, Refresh)
	Refresh()
	v12.ProximityPrompt.Triggered:Connect(function() --[[ Line: 170 | Upvalues: t (ref), p2 (copy), ReportUserError (copy), v42 (ref), Soundbook (ref), v1 (ref), SuccessAction (copy) ]]
		local v12 = t:_getBountySlot(p2)
		if not v12 then
			return
		end
		if v12.Claimed then
			ReportUserError("Already claimed reward!")
			return
		end
		if v12.Locked then
			ReportUserError("Already selected this bounty!")
			return
		end
		if not (v42 + 1 > tick()) then
			v42 = tick()
			Soundbook.Sounds.ThickClick:Play()
			v1:FireServer("Default", p2)
			SuccessAction("Started bounty!")
		end
	end)
	v22.ProximityPrompt.Triggered:Connect(function() --[[ Line: 199 | Upvalues: t (ref), p2 (copy), ReportUserError (copy), v42 (ref), Soundbook (ref), v2 (ref), SuccessAction (copy) ]]
		local v1 = t:_getBountySlot(p2)
		if not v1 then
			return
		end
		if v1.Claimed then
			ReportUserError("Already claimed reward!")
			return
		end
		if not v1.Locked then
			return
		end
		if not (v42 + 1 > tick()) then
			v42 = tick()
			Soundbook.Sounds.ThickClick:Play()
			v2:FireServer("Default", p2)
			SuccessAction("Removed bounty")
		end
	end)
	v32.ProximityPrompt.Triggered:Connect(function() --[[ Line: 227 | Upvalues: v4 (ref), ReportUserError (copy), t (ref), p2 (copy), PlayerStatsUtility (ref), BountyUtility (ref), v42 (ref), v3 (ref), SuccessAction (copy), Soundbook (ref) ]]
		local v1 = v4:GetExpect("EquippedId")
		local v2 = v4:GetExpect("EquippedType")
		if string.len(v2) == 0 or string.len(v1) == 0 then
			ReportUserError("You do not have an item equipped!")
			return
		end
		local v32 = t:_getBountySlot(p2)
		if not v32 then
			return
		end
		if v32.Type ~= v2 then
			ReportUserError("Wrong item equipped!")
			return
		end
		if v32.Claimed then
			ReportUserError("Already claimed reward!")
			return
		end
		if not v32.Locked then
			return
		end
		local Metadata = v32.Metadata
		local Id = v32.Id
		local v43 = false
		local v5 = false
		local v6 = v32.Metadata and (if next(v32.Metadata) == nil then false else true)
		if PlayerStatsUtility:GetItemFromInventory(v4, function(p1) --[[ Line: 262 | Upvalues: Id (copy), v1 (copy), v43 (ref), v6 (copy), v32 (copy), BountyUtility (ref), v5 (ref) ]]
			if p1.Id ~= Id then
				return false
			end
			if p1.UUID ~= v1 then
				return false
			end
			if p1.Favorited then
				v43 = true
				return false
			end
			if not v6 then
				return true
			end
			local t = {
				Id = p1.Id
			}
			if p1.Metadata and v32.Metadata then
				t.Metadata = {
					VariantId = p1.Metadata.VariantId,
					Shiny = p1.Metadata.Shiny
				}
			end
			local v12, v2 = BountyUtility:MatchArgs(t, v32.Metadata)
			if not v2 then
				return v12
			end
			v5 = v2
			return v12
		end, "Items") then
			if not (v42 + 1 > tick()) then
				v42 = tick()
				if v3:InvokeServer("Default", p2, v1) then
					SuccessAction("You claimed your bounty reward!")
					Soundbook.Sounds.CoinsChanged:Play()
					Soundbook.Sounds.QuestCompleted:Play()
				else
					Soundbook.Sounds.ThickClick:Play()
				end
			end
		else
			ReportUserError(if v43 then "You cannot exchange a favorited item" elseif v5 then "This is item is missing a characteristic such as mutated or shiny" else "Wrong item equipped!")
		end
	end)
	v5.Parent = p3
	v12.Parent = p3
	v22.Parent = p3
	v32.Parent = p3
end
function t.UpdateBounty(p1, p2, p3) --[[ UpdateBounty | Line: 336 | Upvalues: t (copy), ItemUtility (copy), StringLibrary (copy), TierUtility (copy), VendorUtility (copy) ]]
	local v1 = t:_getBountySlot(p2)
	if not v1 then
		p3.Gui.Enabled = false
		warn("[BountyController] No Bounty found for", p2)
		return
	end
	local v2 = ItemUtility.GetItemDataFromItemType(v1.Type, v1.Name) or ItemUtility.GetItemDataFromItemType(v1.Type, v1.Id)
	if not v2 then
		p3.Gui.Enabled = false
		return
	end
	local v3 = nil
	local Probability = v2.Probability
	local v4
	if Probability then
		v3, v4 = ("1 in %*"):format((StringLibrary:AddCommas((math.ceil(1 / Probability.Chance))))), TierUtility:GetTierFromRarity(Probability.Chance)
	else
		v4 = TierUtility:GetTier(v2.Data.Tier)
	end
	local Housing = p3.Gui.Housing
	local Configuration = Housing.Inner.Configuration
	if v3 then
		Housing.Catch.Text = v3
	end
	if v4 then
		for i = 1, 3 do
			local v10 = Housing.StarFrame:FindFirstChild((("Star%*"):format(i)))
			if v10 then
				v10.Visible = i <= v4.Tier
			end
		end
	end
	local v12 = false
	local v13 = false
	if v1.Metadata then
		if v1.Metadata.Shiny then
			Configuration.ShinyFrame.Visible = true
			v12 = true
		end
		if v1.Metadata.VariantId then
			local v14 = ItemUtility:GetVariantData(v1.Metadata.VariantId)
			if v14 then
				Configuration.MutationFrame.Label.Text = v14.Data.Name
				Configuration.MutationFrame.Label.UIGradient.Color = v14.Data.TierColor
				Configuration.MutationFrame.Glow.UIGradient.Color = v14.Data.TierColor
				v13 = true
			end
		end
	end
	Configuration.ShinyFrame.Visible = v12
	Configuration.MutationFrame.Visible = v13
	Configuration.Visible = if v1.Metadata == nil then false else true
	Housing.Inner.Vector.Image = v2.Data.Icon or ""
	Housing.Inner.Tags.ItemName.Text = v2.Data.Name
	if v4 then
		Housing.Inner.Tags.ItemName.UIGradient.Color = v4.TierColor
		Housing.Inner.Gradient.UIGradient.Color = v4.TierColor
		Housing.Inner.UIStroke.UIGradient.Color = v4.TierColor
	end
	if v1.Claimed then
		Housing.Header.Text = "CLAIMED"
		Housing.Header.TextColor3 = Color3.fromRGB(42, 255, 67)
	else
		Housing.Header.Text = "BOUNTY"
		Housing.Header.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	local v16 = if v4 and v4.Tier >= 6 then 2 else 3
	local v17 = VendorUtility:GetSellPrice({
		Quantity = 1,
		Timestamp = -1,
		UUID = game.JobId,
		Id = v1.Id,
		Metadata = v1.Metadata
	})
	if v17 then
		Housing.CurrencyCounter.Counter.Text = StringLibrary:AddCommas(v17 * v16)
		Housing.CurrencyCounter.Visible = true
	else
		Housing.CurrencyCounter.Visible = false
	end
	Housing.Visible = if v3 == nil then false else true
	p3.Gui.Enabled = true
end
function t._getBountySlot(p1, p2) --[[ _getBountySlot | Line: 455 | Upvalues: v4 (ref) ]]
	local v1 = v4:Get("Bounty")
	if v1 then
		return v1.Slots[p2]
	end
end
return t