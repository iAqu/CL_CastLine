-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local SpinWheelPrizes = require(ReplicatedStorage.Shared.SpinWheelPrizes)
local MainlineQuestController = require(ReplicatedStorage.Controllers.MainlineQuestController)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local v2 = Net:RemoteFunction("RequestSpin")
local v3 = Net:RemoteEvent("SpinWheel")
local v4 = LocalPlayer.PlayerGui:WaitForChild("Spin Wheel")
local Wheel = v4.Main.Wheel
local Spinner = Wheel.Spinner
local RegionLocked = Wheel.RegionLocked
local Bottom = Wheel.Bottom
local Buttons = Wheel.Options.RightButtons.Buttons
local Odds = Wheel.Options.Odds
local OddsFrame = Wheel.Options.OddsFrame
local List = OddsFrame.Main.List
local PityFrame = v4.PityFrame
local ProgressBar = PityFrame.ProgressBar
local Title = ProgressBar.Title
local ExampleTile = List.ExampleTile
ExampleTile.Parent = nil
local v5 = TweenService:Create(Spinner, TweenInfo.new(14, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
	Rotation = -360
})
local t = {}
local v6 = Signal.new()
local v7 = Trove.new()
local v8 = false
local v9 = false
local v10 = Signal.new()
local t2 = {}
function t2.Init(p1) --[[ Init | Line: 73 | Upvalues: v3 (copy), t2 (copy), GuiControl (copy), Odds (copy), OddsFrame (copy), Bottom (copy), v9 (ref), v8 (ref), v2 (copy) ]]
	v3.OnClientEvent:Connect(t2._addSpin)
	GuiControl:Hook("Hold Button", Odds).Clicked:Connect(function() --[[ Line: 76 | Upvalues: OddsFrame (ref) ]]
		OddsFrame.Visible = not OddsFrame.Visible
	end)
	GuiControl:Hook("Hold Button", Bottom.Spin).Clicked:Connect(function() --[[ Line: 80 | Upvalues: v9 (ref), v8 (ref), v2 (ref) ]]
		if v9 then
			return
		end
		if not v8 then
			v8 = true
			v2:InvokeServer()
			task.delay(1, function() --[[ Line: 88 | Upvalues: v8 (ref) ]]
				v8 = false
			end)
		end
	end)
end
function t2.Start(p1) --[[ Start | Line: 94 | Upvalues: v1 (ref), Replion (copy), t (copy), t2 (copy), v6 (copy), GuiControl (copy), v4 (copy), MainlineQuestController (copy), PolicyWrapper (copy), LocalPlayer (copy), RegionLocked (copy), Buttons (copy), Bottom (copy), v9 (ref), v10 (copy), v5 (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	task.spawn(function() --[[ Line: 98 | Upvalues: t (ref), t2 (ref), v6 (ref) ]]
		while true do
			while true do
				task.wait()
				if not t[1] then
					break
				end
				t2:SpinWheel()
			end
			v6:Wait()
		end
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 112 | Upvalues: v4 (ref), t2 (ref), MainlineQuestController (ref) ]]
		if p1 ~= v4 then
			return
		end
		t2:_populate()
		MainlineQuestController:Suppress("SpinWheel")
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 119 | Upvalues: v4 (ref), t2 (ref), MainlineQuestController (ref) ]]
		if p1 ~= v4 then
			return
		end
		t2:Destroy()
		MainlineQuestController:Unsuppress("SpinWheel")
	end)
	if PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		RegionLocked.Visible = true
		Buttons.Visible = false
		Bottom.Visible = false
	else
		RegionLocked.Visible = false
	end
	v1:OnChange({ "SpinsData", "ProgressionLevel" }, function() --[[ Line: 138 | Upvalues: v9 (ref), v10 (ref), v4 (ref), t2 (ref) ]]
		if v9 then
			v10:Wait()
		end
		if not v4.Enabled then
			return
		end
		t2:_populate()
	end)
	v1:OnChange({ "SpinsData", "CurrentPityCount" }, function() --[[ Line: 149 | Upvalues: t2 (ref) ]]
		t2._updatePityProgress()
	end)
	v1:OnChange({ "SpinsData", "ProgressionLevel" }, function() --[[ Line: 155 | Upvalues: t2 (ref) ]]
		t2._updatePityProgress()
	end)
	t2._updatePityProgress()
	v5:Play()
	t2:StartIdleAnimation()
	v1:OnChange("Spins", t2._updateSpins)
	t2._updateSpins(v1:GetExpect("Spins"))
end
function t2.SpinWheel(p1) --[[ SpinWheel | Line: 174 | Upvalues: t (copy), v9 (ref), GuiControl (copy), TweenService (copy), Spinner (copy), Soundbook (copy), v5 (copy), v10 (copy) ]]
	local v1 = t[1]
	if not v1 then
		return
	end
	v9 = true
	table.remove(t, 1)
	if not GuiControl:IsOpen("Spin Wheel") then
		GuiControl:Open("Spin Wheel")
	end
	local v2 = 45 * v1.SpotIndex
	local v3 = TweenService:Create(Spinner, TweenInfo.new(2, Enum.EasingStyle.Quart), {
		Rotation = -(1440 + v2)
	})
	local Rotation = Spinner.Rotation
	local v4 = Spinner:GetPropertyChangedSignal("Rotation"):Connect(function() --[[ Line: 196 | Upvalues: Spinner (ref), Rotation (ref), Soundbook (ref) ]]
		local Rotation_2 = Spinner.Rotation
		local v2 = math.abs(Rotation_2 - Rotation)
		if not (v2 >= 3) then
			return
		end
		Soundbook.Sounds.BoxTick:Play().PlaybackSpeed = math.min(v2 / 30, 1) + 1
		Rotation = Rotation_2
	end)
	v5:Pause()
	v3:Play()
	v3.Completed:Wait()
	v3:Cancel()
	v3:Destroy()
	local v52 = if v1.Chance <= 0.02 then "WheelLegendary" elseif v1.Chance <= 0.1 then "WheelEpic" else "WheelRare"
	if not Soundbook:HasSound(v52) then
		v4:Disconnect()
		Spinner.Rotation = -v2
		v9 = false
		v10:Fire()
		return
	end
	Soundbook.Sounds[v52]:Play()
	v4:Disconnect()
	Spinner.Rotation = -v2
	v9 = false
	v10:Fire()
end
function t2.StartIdleAnimation(p1) --[[ StartIdleAnimation | Line: 262 | Upvalues: Spinner (copy) ]]
	Spinner:GetPropertyChangedSignal("Rotation"):Connect(function() --[[ Line: 264 | Upvalues: Spinner (ref) ]]
		local Rotation = Spinner.Rotation
		for k, v in pairs(Spinner.Images:GetChildren()) do
			if v:IsA("Frame") then
				v.Rotation = -Rotation
			end
		end
	end)
end
function t2.GetLocalPrize(p1, p2) --[[ GetLocalPrize | Line: 279 | Upvalues: v1 (ref), SpinWheelPrizes (copy) ]]
	if p2.IsTopPrize then
		return SpinWheelPrizes.TopPrizes[math.clamp(v1:Get({ "SpinsData", "ProgressionLevel" }) or 1, 1, #SpinWheelPrizes.TopPrizes)]
	else
		return p2
	end
end
function t2.Destroy(p1) --[[ Destroy | Line: 291 | Upvalues: v7 (copy) ]]
	v7:Clean()
end
function t2._updateSpins(p1) --[[ _updateSpins | Line: 295 | Upvalues: Bottom (copy) ]]
	Bottom.Spin.Amount.Text = ("%* (%*)"):format(if math.abs(p1) == 1 then "Spin" else "Spins", p1)
	Bottom.Spin.Visible = p1 > 0
end
function t2._addSpin(p1) --[[ _addSpin | Line: 302 | Upvalues: t (copy), v6 (copy) ]]
	table.insert(t, p1)
	v6:Fire()
end
function t2._updatePityProgress() --[[ _updatePityProgress | Line: 308 | Upvalues: v1 (ref), SpinWheelPrizes (copy), PityFrame (copy), Title (copy), ProgressBar (copy) ]]
	local v3 = math.clamp(v1:Get({ "SpinsData", "ProgressionLevel" }) or 1, 1, #SpinWheelPrizes.TopPrizes)
	local v4 = v1:Get({ "SpinsData", "CurrentPityCount" }) or 0
	if #SpinWheelPrizes.TopPrizes < v3 then
		PityFrame.Visible = false
		return
	end
	local v5 = SpinWheelPrizes.TopPrizes[v3]
	if v5.PityCount then
		PityFrame.Rod.Image = v5.Icon
		PityFrame.Desc.Text = ("<font color=\"rgb(255, 58, 58)\">%*</font> Spins for guaranteed"):format(v5.PityCount)
		PityFrame.Title.Text = v5.DisplayName
		Title.Text = ("%* / %*"):format(v4, v5.PityCount)
		PityFrame.Visible = true
		local v6 = UDim2.new
		ProgressBar.FillBar:TweenSize(v6(math.clamp(v4 / v5.PityCount, 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
	end
end
function t2._populate(p1) --[[ _populate | Line: 346 | Upvalues: v7 (copy), SpinWheelPrizes (copy), t2 (copy), ExampleTile (copy), ItemUtility (copy), StringLibrary (copy), TierUtility (copy), Spinner (copy), CurrencyUtility (copy), List (copy) ]]
	v7:Clean()
	for i, v in ipairs(SpinWheelPrizes.RegularBag) do
		local v1 = t2:GetLocalPrize(v)
		local v2 = if v.IsTopPrize then v1.Currency else v.RewardData.Currency
		local v3 = if v.IsTopPrize then v1.CurrencyRewardInfo else v.RewardData.CurrencyRewardInfo
		local v4 = if v.IsTopPrize then v1.DisplayName else v.RewardData.DisplayName
		local v5 = if v.IsTopPrize then v1.Icon else v.RewardData.Icon
		local v72 = math.round(v.Chance * 10000) / 100
		local v8 = ExampleTile:Clone()
		local v9 = v8.Content
		if v2 == "ItemReward" then
			local v10, v11, v12, _ = table.unpack(v3)
			local v13 = ItemUtility.GetItemDataFromItemType(v10, v11)
			if v13 then
				local v15 = StringLibrary:Shorten(v12 or 1)
				local v16 = TierUtility:GetTier(v13.Data.Tier or 1)
				local v17 = ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
				if v16 then
					v17 = v16.TierColor
				end
				local v18 = if v5 then v5 else v13.Data.Icon or ""
				local v19 = if v4 then v4 else v13.Data.Name
				v9.Inside.Vector.Image = v18
				v9.Inside.Quantity.Text = ("x%*"):format(v15)
				if v13.Data.Type == "Fishing Rods" then
					v9.Inside.Vector.ScaleType = Enum.ScaleType.Crop
					v9.Inside.Vector.Position = UDim2.fromScale(0.5, 1)
					v9.Inside.Vector.AnchorPoint = Vector2.new(0.5, 1)
				else
					v9.Inside.Vector.ScaleType = Enum.ScaleType.Fit
					v9.Inside.Vector.Position = UDim2.fromScale(0.5, 0.5)
					v9.Inside.Vector.AnchorPoint = Vector2.new(0.5, 0.5)
				end
				if v.IsTopPrize then
					local v21 = Spinner.Images:FindFirstChild((tostring(v.SpotIndex)))
					if v21 then
						v21.Vector.Image = v18
						v21.Label.Text = v19
						v21.Label.UIGradient.Color = v17
					end
				end
				v9.Label.Text = v19
				v9.Label.UIGradient.Color = v17
				v9.Odds.Text = ("%*%%"):format(v72)
				v8.Visible = true
				v8.LayoutOrder = v72 * 10000
				v8.Parent = List
				v7:Add(v8)
			end
		elseif v2 == "LuckReward" then
			local _, _2 = table.unpack(v3)
			local v22 = ColorSequence.new(Color3.new(0.0823529, 1, 0.341176))
			v9.Inside.Vector.Image = v5 or ""
			v9.Inside.Quantity.Visible = false
			v9.Inside.Vector.ScaleType = Enum.ScaleType.Fit
			v9.Label.Text = v4 or ""
			v9.Label.UIGradient.Color = v22
			v9.Odds.Text = ("%*%%"):format(v72)
			v8.Visible = true
			v8.LayoutOrder = v72 * 10000
			v8.Parent = List
			v7:Add(v8)
		else
			local v23 = table.unpack(v3)
			if v23 then
				local v24 = CurrencyUtility:GetCurrency(v2)
				if v24 then
					local v25 = StringLibrary:Shorten(v23 or 1)
					v9.Inside.Vector.Image = if v5 then v5 else v24.Icon or ""
					v9.Inside.Quantity.Text = ("%*"):format(v25)
					v9.Inside.Vector.ScaleType = Enum.ScaleType.Fit
					v9.Label.Text = v4 or v2
					v9.Label.UIGradient.Color = v24.TextColor
				end
				v9.Odds.Text = ("%*%%"):format(v72)
				v8.Visible = true
				v8.LayoutOrder = v72 * 10000
				v8.Parent = List
				v7:Add(v8)
			end
		end
	end
end
return t2