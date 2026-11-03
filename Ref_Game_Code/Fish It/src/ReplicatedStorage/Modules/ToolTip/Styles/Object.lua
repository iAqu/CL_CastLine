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
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Types.Modifiers)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Modules.EventTags)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local Utility = require(script.Parent.Parent.Internal.Utility)
UserPriority:IsTradePlaza()
UserPriority:IsValidTestSession()
local Big = script:WaitForChild("Big")
local v1 = false
local v2 = Utility.UsernameTrove:Extend()
local v3 = false
local v4 = Trove.new()
local t = {
	DefaultProperties = {
		ItemType = "Fish",
		Id = 1,
		Metadata = nil
	}
}
local function GetHMS(p1) --[[ GetHMS | Line: 54 ]]
	local v1 = p1 % 86400
	return math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), math.floor(p1 % 60)
end
function t.Create(p1, p2, p3) --[[ Create | Line: 64 | Upvalues: TableUtil (copy), t (copy), v3 (ref), v4 (copy), v1 (ref), v2 (copy), ItemUtility (copy) ]]
	local v12 = p2 and TableUtil.Reconcile(p2, t.DefaultProperties) or t.DefaultProperties
	if v3 then
		pcall(function() --[[ Line: 68 | Upvalues: v4 (ref) ]]
			v4:Clean()
		end)
	end
	if v1 then
		pcall(function() --[[ Line: 74 | Upvalues: v2 (ref) ]]
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
function t.Populate(p1, p2, p3, p4, p5, p6) --[[ Populate | Line: 89 | Upvalues: Big (copy), Utility (copy), ItemUtility (copy), TradeData (copy), RAPController (copy), StringLibrary (copy), v3 (ref), v4 (copy), v1 (ref), v2 (copy) ]]
	local v12 = Big:Clone()
	local Right = v12.Frame.Right
	local Inside = v12.Frame.Left.Inside
	local Bottom = v12.Bottom
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
		p4:Add(function() --[[ Line: 119 | Upvalues: UIGradient (copy), UIGradient_2 (copy), UIGradient_3 (copy), UIGradient_4 (copy) ]]
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
	local v6 = if p3 and p3.VariantId then p3.VariantId else nil
	local v7 = if v6 then ItemUtility:GetVariantData(v6) else nil
	if v7 then
		Right.Modifier.VariantId.Label.Text = v7.Data.Name
		Right.Modifier.VariantId.Label.UIGradient.Color = v7.Data.TierColor
		Right.Modifier.VariantId.Vector.UIGradient.Color = v7.Data.TierColor
		Right.Modifier.VariantId.Visible = true
	else
		Right.Modifier.VariantId.Visible = false
	end
	local Description = p2.Data.Description
	if Description and string.len(Description) > 0 then
		Right.Description.Label.Text = Description
		Right.Description.Visible = true
	else
		Right.Description.Visible = false
	end
	local v8 = if p3 then p3.Weight else nil
	local v9 = if p2.Weight then p2.Weight else nil
	if v32 then
		Bottom.Event.Label.Text = v32.Tag
		Bottom.Event.UIGradient.Color = v32.TierColor
	end
	Bottom.Event.Visible = if v32 == nil then false else true
	Bottom.Shiny.Visible = if p3 then p3.Shiny else p3
	Bottom.Big.Visible = if v9 and v8 then if v9.Big.Min <= v8 then true else false else false
	local v14 = if p3 and p3.RemainingTime then p3.RemainingTime elseif p2.Duration then p2.Duration else nil
	if v14 then
		local v15 = v14 % 86400
		local v16 = math.floor(v15 / 3600)
		local v17 = math.floor(v15 % 3600 / 60)
		Bottom.Timer.Label.Text = ("Duration: %dh %dm %ds"):format(v16, v17, (math.floor(v14 % 60)))
		Bottom.Timer.Visible = true
	else
		Bottom.Timer.Visible = false
	end
	local Rap = Bottom.Rap
	if p2.TradeLocked or (p2.Price or p2.Modifiers) then
		Utility.Templates.Untradable:Clone().Parent = Right
		Rap.Visible = false
	else
		if not TradeData.FollowTradeRules(p2, {
			Metadata = p3
		}) then
			local v19 = Utility.Templates.TradeLocked:Clone()
			local v20 = p3 and p3.TradeLock
			if v20 and v20.Type == "Timestamp" then
				v19.Label.Text = ("\240\159\148\146 Locked (%*)"):format((Utility.formatDHMS((math.max(v20.Time - workspace:GetServerTimeNow(), 0)))))
			elseif v20 and v20.Type == "Untradable" then
				v19.Label.Text = "\240\159\148\146 Untradable"
			end
			v19.Parent = Right
		end
		local v23 = RAPController:GetRAP(p2.Data.Type, p2.Data.Name)
		if v23 then
			Rap.Counter.Text = StringLibrary:AddCommas(v23)
		else
			v3 = true
			Rap.Counter.Text = "Loading..."
			local v24 = nil
			v24 = v4:Add(task.spawn(function() --[[ Line: 228 | Upvalues: RAPController (ref), p2 (copy), StringLibrary (ref), Rap (copy), v4 (ref), v24 (ref), v3 (ref) ]]
				local v1 = RAPController:GetRAPAsync(p2.Data.Type, p2.Data.Name)
				local v2 = if typeof(v1) == "number" then StringLibrary:AddCommas(v1) else "Unknown"
				local v42 = Rap and Rap:FindFirstChild("Counter")
				if not v42 then
					v4:Remove(v24)
					v3 = false
					return
				end
				v42.Text = v2
				v4:Remove(v24)
				v3 = false
			end))
		end
		Rap.Visible = true
	end
	local v25 = if p3 and p3.OriginalOwner then p3.OriginalOwner else nil
	if v25 then
		v1 = true
		local Owner = Bottom.Owner
		local Label = Owner.Label
		local v26 = nil
		v26 = v2:Add(task.spawn(function() --[[ Line: 260 | Upvalues: Utility (ref), v25 (copy), Label (copy), Owner (copy), v26 (ref), v2 (ref), v1 (ref) ]]
			Label.Text = ("OG Owner: %*"):format((Utility.GetUsername(v25)))
			Owner.Visible = true
			if not v26 then
				return
			end
			v2:Remove(v26)
			v1 = false
		end))
	else
		Bottom.Owner.Visible = false
	end
	if v8 then
		Bottom.Weight.Label.Text = StringLibrary:AddWeight(v8)
		Bottom.Weight.Visible = true
	else
		Bottom.Weight.Visible = false
	end
	return v12
end
return t