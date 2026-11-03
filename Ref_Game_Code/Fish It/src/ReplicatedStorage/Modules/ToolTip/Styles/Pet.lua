-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Trove = require(ReplicatedStorage.Packages.Trove)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
require(ReplicatedStorage.Modules.ColorUtility)
require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Modules.ItemStringUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Pets)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Types.Modifiers)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Modules.EventTags)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local Utility = require(script.Parent.Parent.Internal.Utility)
UserPriority:IsTradePlaza()
UserPriority:IsValidTestSession()
local Pet = script:WaitForChild("Pet")
local v1 = false
local v2 = Utility.UsernameTrove:Extend()
local v3 = false
local v4 = Trove.new()
local t = {
	DefaultProperties = {
		ItemType = "Pets",
		Id = 1,
		Metadata = nil
	}
}
local function GetHMS(p1) --[[ GetHMS | Line: 56 ]]
	local v1 = p1 % 86400
	return math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), math.floor(p1 % 60)
end
function t.Create(p1, p2, p3) --[[ Create | Line: 66 | Upvalues: TableUtil (copy), t (copy), v3 (ref), v4 (copy), v1 (ref), v2 (copy), ItemUtility (copy) ]]
	local v12 = p2 and TableUtil.Reconcile(p2, t.DefaultProperties) or t.DefaultProperties
	if v3 then
		pcall(function() --[[ Line: 70 | Upvalues: v4 (ref) ]]
			v4:Clean()
		end)
	end
	if v1 then
		pcall(function() --[[ Line: 76 | Upvalues: v2 (ref) ]]
			v2:Clean()
		end)
	end
	local v22 = ItemUtility.GetItemDataFromItemType(v12.ItemType, v12.Id)
	if v22 then
		return p1:Populate(v22, v12.Metadata, p3, v12.TradeLocked, v12.UUID)
	else
		error((("Unable to create style: %*! No ItemData found! ItemType: %*, ItemId: %*"):format(script.Name, v12.ItemType, v12.ItemId)))
	end
end
function t.Populate(p1, p2, p3, p4, p5, p6) --[[ Populate | Line: 91 | Upvalues: Pet (copy), Utility (copy), PlayerStatsUtility (copy), TradeData (copy), RAPController (copy), StringLibrary (copy), v3 (ref), v4 (copy), v1 (ref), v2 (copy) ]]
	local v12 = Pet:Clone()
	local Right = v12.Frame.Right
	local Inside = v12.Frame.Left.Inside
	local Bottom = v12.Bottom
	local Perk = Right.Perk
	Perk.Parent = nil
	local UIGradient = v12.UIStroke.UIGradient
	local UIGradient_2 = Inside.UIStroke.UIGradient
	local UIGradient_3 = Inside.Glow.UIGradient
	local UIGradient_4 = Inside.Gradient.UIGradient
	local v22 = Utility.getTierData(p2)
	local v32 = Utility.getEventTagData(p2, p3)
	local v42 = Utility.getColorBlend(v22, v32)
	Inside.Vector.Image = if p2.Data.Icon then p2.Data.Icon else ""
	UIGradient.Color = v42
	UIGradient_2.Color = v42
	UIGradient_3.Color = v42
	UIGradient_4.Color = v42
	if v22.Tier >= 5 then
		UIGradient:AddTag("AnimateTier")
		UIGradient_2:AddTag("AnimateTier")
		UIGradient_3:AddTag("AnimateTier")
		UIGradient_4:AddTag("AnimateTier")
		p4:Add(function() --[[ Line: 124 | Upvalues: UIGradient (copy), UIGradient_2 (copy), UIGradient_3 (copy), UIGradient_4 (copy) ]]
			UIGradient:RemoveTag("AnimateTier")
			UIGradient_2:RemoveTag("AnimateTier")
			UIGradient_3:RemoveTag("AnimateTier")
			UIGradient_4:RemoveTag("AnimateTier")
		end)
	end
	Right.Header.Label.Text = p2.Data.Name
	Right.Modifier.Tier.Label.Text = v22.Name
	Right.Modifier.Tier.Label.UIGradient.Color = v22.TierColor
	Right.Modifier.Tier.Visible = true
	if next(p2.Modifiers) ~= nil then
		for k, v in pairs(p2.Modifiers) do
			if typeof(v) == "number" then
				local v6, v7, v8 = PlayerStatsUtility:GetModifierDisplayName(k)
				if v6 then
					local v9 = Perk:Clone()
					if v8 then
						v9.Vector.Image = v8
						v9.Vector.UIGradient.Color = v7
						v9.Vector.Visible = true
					else
						v9.Vector.Visible = false
					end
					v9.Label.Text = string.format("%s +%.2f%%", v6, v * 100)
					v9.Parent = Right
					local UIGradient_5 = Instance.new("UIGradient")
					UIGradient_5.Color = ColorSequence.new(v7)
					UIGradient_5.Parent = v9.Label
				end
			end
		end
	end
	if p2.PetFishing.Enabled then
		Right.Fish.Label.Text = string.format("Catch %d Fish every %ds", 1, p2.PetFishing.ReelDurationSeconds)
		Right.Fish.Visible = true
		Right.Recharge.Label.Text = string.format("Recharges in %ds", 1, p2.PetFishing.CastCooldownSeconds)
		Right.Recharge.Visible = true
	else
		Right.Fish.Visible = false
		Right.Recharge.Visible = false
	end
	Perk:Destroy()
	local Rap = Bottom.Rap
	if p2.TradeLocked or p2.Price then
		Utility.Templates.Untradable:Clone().Parent = Right
		Rap.Visible = false
	else
		if not TradeData.FollowTradeRules(p2, {
			Metadata = p3
		}) then
			local v10 = Utility.Templates.TradeLocked:Clone()
			local v11 = p3 and p3.TradeLock
			if v11 and v11.Type == "Timestamp" then
				v10.Label.Text = ("\240\159\148\146 Locked (%*)"):format((Utility.formatDHMS((math.max(v11.Time - workspace:GetServerTimeNow(), 0)))))
			elseif v11 and v11.Type == "Untradable" then
				v10.Label.Text = "\240\159\148\146 Untradable"
			end
			v10.Parent = Right
		end
		local v14 = RAPController:GetRAP(p2.Data.Type, p2.Data.Name)
		if v14 then
			Rap.Counter.Text = StringLibrary:AddCommas(v14)
		else
			v3 = true
			Rap.Counter.Text = "Loading..."
			local v15 = nil
			v15 = v4:Add(task.spawn(function() --[[ Line: 225 | Upvalues: RAPController (ref), p2 (copy), StringLibrary (ref), Rap (copy), v4 (ref), v15 (ref), v3 (ref) ]]
				local v1 = RAPController:GetRAPAsync(p2.Data.Type, p2.Data.Name)
				local v2 = if typeof(v1) == "number" then StringLibrary:AddCommas(v1) else "Unknown"
				local v42 = Rap and Rap:FindFirstChild("Counter")
				if not v42 then
					v4:Remove(v15)
					v3 = false
					return
				end
				v42.Text = v2
				v4:Remove(v15)
				v3 = false
			end))
		end
		Rap.Visible = true
	end
	local v16 = if p3 and p3.OriginalOwner then p3.OriginalOwner else nil
	if v16 then
		v1 = true
		local Owner = Bottom.Owner
		local Label = Owner.Label
		local v17 = nil
		v17 = v2:Add(task.spawn(function() --[[ Line: 257 | Upvalues: Utility (ref), v16 (copy), Label (copy), Owner (copy), v17 (ref), v2 (ref), v1 (ref) ]]
			Label.Text = ("OG Owner: %*"):format((Utility.GetUsername(v16)))
			Owner.Visible = true
			if not v17 then
				return
			end
			v2:Remove(v17)
			v1 = false
		end))
	else
		Bottom.Owner.Visible = false
	end
	return v12
end
return t