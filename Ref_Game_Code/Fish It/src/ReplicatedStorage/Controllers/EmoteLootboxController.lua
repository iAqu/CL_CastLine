-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local EmoteCrates = require(ReplicatedStorage.EmoteCrates)
local v1 = Net:RemoteFunction("PurchaseEmoteCrate")
local LocalPlayer = Players.LocalPlayer
local EmoteLootbox = LocalPlayer.PlayerGui:WaitForChild("EmoteLootbox")
local Background = EmoteLootbox:WaitForChild("Main"):WaitForChild("Background")
local Frame = Background:WaitForChild("Frame")
local ItemName = Frame:WaitForChild("ItemName")
local Icon = Frame:WaitForChild("Icon")
local NewLabel = Frame:WaitForChild("NewLabel")
local Options = Background:WaitForChild("Options")
local Buy1 = Options:WaitForChild("Buy1")
local Buy5 = Options:WaitForChild("Buy5")
local CoinsBuy1 = Options:WaitForChild("CoinsBuy1")
local Roller = Background:WaitForChild("Roller")
local List = Roller:WaitForChild("List")
local ItemTemplate = List:WaitForChild("ItemTemplate")
local Close = Background:WaitForChild("Close")
local v2 = List:FindFirstChildWhichIsA("UIListLayout")
ItemTemplate.Visible = false
local v3 = Trove.new()
local Position = List.Position
local v4 = 0
local v5 = false
local t = {}
local function arePaidRandomItemsRestricted() --[[ arePaidRandomItemsRestricted | Line: 46 | Upvalues: PolicyWrapper (copy), LocalPlayer (copy) ]]
	return PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted
end
local function stopRoller() --[[ stopRoller | Line: 51 | Upvalues: v4 (ref), List (copy), Position (copy) ]]
	v4 = v4 + 1
	List.Position = Position
end
local function startRoller(p1) --[[ startRoller | Line: 56 | Upvalues: v4 (ref), List (copy), Position (copy), v3 (copy), EmoteLootbox (copy), v2 (copy), Roller (copy), TweenService (copy) ]]
	v4 = v4 + 1
	List.Position = Position
	local v1 = v4
	v3:Add(function() --[[ Line: 60 | Upvalues: v4 (ref), v1 (copy), List (ref), Position (ref) ]]
		if v4 == v1 then
			v4 = v4 + 1
		end
		List.Position = Position
	end)
	task.spawn(function() --[[ Line: 67 | Upvalues: v4 (ref), v1 (copy), EmoteLootbox (ref), v2 (ref), Roller (ref), List (ref), Position (ref), p1 (copy), TweenService (ref) ]]
		while v4 == v1 do
			if EmoteLootbox.Enabled then
				if v2 then
					local v22 = math.max(v2.AbsoluteContentSize.X - Roller.AbsoluteSize.X, 0)
					if v22 <= 0 then
						List.Position = Position
						task.wait(0.5)
						continue
					end
					local v42 = math.clamp(p1 * 0.4, 1, 5)
					local v5 = UDim2.new(Position.X.Scale, Position.X.Offset - v22, Position.Y.Scale, Position.Y.Offset)
					local v6 = TweenService:Create(List, TweenInfo.new(v42, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
						Position = v5
					})
					v6:Play()
					v6.Completed:Wait()
					v6:Destroy()
					if v4 ~= v1 then
						break
					end
					task.wait(0.4)
					local v7 = TweenService:Create(List, TweenInfo.new(v42, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
						Position = Position
					})
					v7:Play()
					v7.Completed:Wait()
					v7:Destroy()
					if v4 ~= v1 then
						break
					end
					task.wait(0.4)
					continue
				end
				task.wait(0.5)
				continue
			end
			task.wait(0.1)
		end
	end)
end
local function configureBuyButton(p1, p2) --[[ configureBuyButton | Line: 126 ]]
	p2.Visible = true
	p2.LayoutOrder = p1.Quantity
	p2:SetAttribute("ProductId", p1.DevProductId)
	p2:SetAttribute("DevProductId", p1.DevProductId)
	p2:RemoveTag("DevProductPurchase")
	p2:RemoveTag("DevProductPrice")
	p2:AddTag("DevProductPurchase")
	p2:AddTag("DevProductPrice")
end
local function configureCoinsBuyButton(p1, p2, p3) --[[ configureCoinsBuyButton | Line: 138 | Upvalues: CoinsBuy1 (copy), StringLibrary (copy), GuiControl (copy), v1 (copy), v3 (copy) ]]
	CoinsBuy1.Visible = true
	CoinsBuy1.LayoutOrder = p3.Quantity
	CoinsBuy1.Inside.Cost.Text = StringLibrary:AddCommas(p3.Coins)
	local v12 = false
	v3:Add((GuiControl:Hook("Hold Button", CoinsBuy1).Clicked:Connect(function() --[[ Line: 145 | Upvalues: v12 (ref), v1 (ref), p1 (copy), p2 (copy) ]]
		if not v12 then
			v12 = true
			task.delay(1, function() --[[ Line: 151 | Upvalues: v12 (ref) ]]
				v12 = false
			end)
			v1:InvokeServer(p1, p2)
		end
	end)))
end
local function setupGui() --[[ setupGui | Line: 161 | Upvalues: v5 (ref), GuiControl (copy), Close (copy), EmoteLootbox (copy), v3 (copy), v4 (ref), List (copy), Position (copy) ]]
	if not v5 then
		v5 = true
		GuiControl:Hook("Hold Button", Close).Clicked:Connect(function() --[[ Line: 167 | Upvalues: GuiControl (ref) ]]
			GuiControl:Close()
		end)
		GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 171 | Upvalues: EmoteLootbox (ref), v3 (ref), v4 (ref), List (ref), Position (ref) ]]
			if p1 ~= EmoteLootbox then
				return
			end
			v3:Clean()
			v4 = v4 + 1
			List.Position = Position
		end)
	end
end
function t.Render(p1, p2) --[[ Render | Line: 179 | Upvalues: setupGui (copy), EmoteCrates (copy), v3 (copy), v4 (ref), List (copy), Position (copy), ItemName (copy), Icon (copy), NewLabel (copy), Buy1 (copy), Buy5 (copy), CoinsBuy1 (copy), PolicyWrapper (copy), LocalPlayer (copy), configureCoinsBuyButton (copy), configureBuyButton (copy), ItemTemplate (copy), ItemUtility (copy), TierUtility (copy), startRoller (copy) ]]
	setupGui()
	local v1 = EmoteCrates[p2]
	if not v1 then
		return
	end
	v3:Clean()
	v4 = v4 + 1
	List.Position = Position
	ItemName.Text = p2
	Icon.Image = v1.Icon or ""
	NewLabel.Text = "LIMITED"
	Buy1.Visible = false
	Buy5.Visible = false
	CoinsBuy1.Visible = false
	Buy1:RemoveTag("DevProductPurchase")
	Buy1:RemoveTag("DevProductPrice")
	Buy5:RemoveTag("DevProductPurchase")
	Buy5:RemoveTag("DevProductPrice")
	if PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		NewLabel.Text = "UNAVAILABLE"
		return
	end
	local v2 = v1.PurchaseOptions[1]
	local v32 = v1.PurchaseOptions[2]
	if v2.Coins then
		configureCoinsBuyButton(p2, 1, v2)
	else
		configureBuyButton(v2, Buy1)
		configureBuyButton(v32, Buy5)
	end
	for i, v in ipairs(v1.Items) do
		local v42 = v3:Clone(ItemTemplate)
		v42.Visible = true
		v42.LayoutOrder = math.floor(v.Chance * 1000)
		if v.Currency == "ItemReward" then
			local v6, v7 = table.unpack(v.CurrencyRewardInfo)
			local v8 = ItemUtility.GetItemDataFromItemType(v6, v7)
			if v8 then
				local Data = v8.Data
				v42.Vector.Image = Data.Icon or ""
				v42.Label.Text = ("%*%%"):format(v.Chance)
				local v9 = TierUtility:GetTier(Data.Tier or 1)
				if v9 then
					for i2, v10 in ipairs(v42:GetDescendants()) do
						if v10:IsA("UIGradient") then
							v10.Color = v9.TierColor
						end
					end
				end
			end
		end
		v42.Parent = List
	end
	startRoller(#v1.Items)
end
function t.Open(p1, p2) --[[ Open | Line: 248 | Upvalues: PolicyWrapper (copy), LocalPlayer (copy), GuiControl (copy), t (copy) ]]
	if not PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		GuiControl:Open("EmoteLootbox")
		t:Render(p2)
	end
end
function t.Start(p1) --[[ Start | Line: 257 | Upvalues: setupGui (copy) ]]
	setupGui()
end
return t