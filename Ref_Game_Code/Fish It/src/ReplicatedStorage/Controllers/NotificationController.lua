-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TweenService")
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.ModelProvider)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteEvent("ObtainedNewFishNotification")
local v2 = nil
local v3 = nil
local function updateTestServerMode() --[[ updateTestServerMode | Line: 55 | Upvalues: v2 (ref), v3 (ref) ]]
	v2 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
	v3 = if v2 then 0.5 else 1
end
v2 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
v3 = if v2 then 0.5 else 1
workspace:GetAttributeChangedSignal("__GOD_MODE"):Connect(function() --[[ Line: 61 | Upvalues: v2 (ref), v3 (ref) ]]
	v2 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
	v3 = if v2 then 0.5 else 1
end)
local v5 = Players.LocalPlayer.PlayerGui:WaitForChild("Small Notification")
local Display = v5.Display
local Container = Display.Container
local VectorFrame = Display.VectorFrame
local NewFrame = Display.NewFrame
local Frame = NewFrame.Frame
v5.Enabled = false
Display.Position = UDim2.new(0.5, 0, -0.5, 0)
local v6 = Signal.new()
local v7 = false
local v8 = Signal.new()
local t = {}
local t2 = {}
function t2.Init(p1) --[[ Init | Line: 86 | Upvalues: v1 (copy), t2 (copy), TextNotificationController (copy) ]]
	v1.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 87 | Upvalues: t2 (ref), TextNotificationController (ref) ]]
		task.delay(0.5, t2.AddObtainedItem, t2, "Small", p1, p2, p4)
		if not p3 then
			return
		end
		task.delay(3.5, TextNotificationController.DeliverNotification, TextNotificationController, p3)
	end)
end
function t2.Start(p1) --[[ Start | Line: 104 | Upvalues: t (copy), v8 (copy), v7 (ref), v6 (copy), t2 (copy) ]]
	task.spawn(function() --[[ Line: 105 | Upvalues: t (ref), v8 (ref), v7 (ref), v6 (ref), t2 (ref) ]]
		while true do
			local v1
			repeat
				if #t == 0 then
					v8:Wait()
				end
				if v7 then
					v6:Wait()
				end
				v1 = t[1]
			until v1
			table.remove(t, 1)
			t2:PlaySmallItemObtained(v1.Identifier, v1.Metadata, v1.NewItem)
		end
	end)
end
function t2.AddObtainedItem(p1, p2, p3, p4, p5) --[[ AddObtainedItem | Line: 147 | Upvalues: t (copy), v8 (copy) ]]
	table.insert(t, {
		Style = p2,
		Identifier = p3,
		Metadata = p4,
		NewItem = p5
	})
	v8:Fire()
end
function t2.PlaySmallItemObtained(p1, p2, p3, p4) --[[ PlaySmallItemObtained | Line: 228 | Upvalues: ItemUtility (copy), v7 (ref), v3 (ref), t (copy), Soundbook (copy), TierUtility (copy), StringLibrary (copy), ItemStringUtility (copy), Container (copy), VectorFrame (copy), spr (copy), Frame (copy), NewFrame (copy), Display (copy), v5 (copy), v6 (copy) ]]
	local v1 = ItemUtility:GetItemData(p2)
	if not v1 then
		return
	end
	local v2 = v1.Probability or v1.ForcedProbability
	v7 = true
	local sum = v3
	if #t > 3 then
		sum = sum - 0.15
	end
	local v32 = math.clamp(sum, 0.05, 1)
	if v2 and v2.Chance <= 0.0002 then
		Soundbook.Sounds.VeryRareItem:Play()
	else
		Soundbook.Sounds.NewItem:Play()
	end
	local v4 = if v2 then TierUtility:GetTierFromRarity(v2.Chance) else TierUtility:GetTier(v1.Data.Tier)
	local v72 = if p3 and p3.VariantId then ItemUtility:GetVariantData(p3.VariantId) else nil
	if v1.Weight and (p3 and p3.Weight) then
		local v9 = StringLibrary:AddWeight(p3.Weight)
		local v10 = ItemStringUtility.GetItemName({
			Metadata = p3
		}, v1)
		if v72 then
			Container.ItemName.UIGradient.Color = v72.Data.TierColor
			Container.ItemName.Text = ("%* %* (%*)"):format(v72.Data.Name, v10, v9)
		else
			Container.ItemName.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
			Container.ItemName.Text = ("%* (%*)"):format(v10, v9)
		end
	else
		if v72 then
			Container.ItemName.UIGradient.Color = v72.Data.TierColor
		else
			Container.ItemName.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		end
		Container.ItemName.Text = v1.Data.Name
	end
	local v11 = nil
	if v2 then
		if v1.ForcedProbability then
			v11 = "1 in ???"
		else
			local Chance = v2.Chance
			v11 = ("1 in %*"):format((StringLibrary:Shorten(math.round(1 / v2.Chance * 10) / 10)))
		end
	elseif v4 then
		v11 = v4.Name
	end
	if v11 then
		local v14 = if v4 and v4.Tier == 1 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(35, 35, 35)
		local v15 = if v4 then v4.TierColor else ColorSequence.new(Color3.fromRGB(255, 255, 255))
		Container.Rarity.Text = v11
		Container.Rarity.UIGradient.Color = v15
		Container.Rarity.UIStroke.Color = v14
		Container.Rarity.Visible = true
	else
		Container.Rarity.Visible = false
	end
	VectorFrame.Vector.Image = v1.Data.Icon or ""
	spr.stop(VectorFrame.Vector)
	VectorFrame.Vector.Rotation = 0
	Frame.NewLabel.Rotation = -10
	NewFrame.Visible = p4
	local v16 = game.TweenService:Create(Frame.NewLabel, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In, -1, true), {
		Rotation = 5
	})
	task.delay(0.14, function() --[[ Line: 326 | Upvalues: v16 (copy), spr (ref), VectorFrame (ref), v32 (ref) ]]
		v16:Play()
		spr.stop(VectorFrame.Vector)
		spr.target(VectorFrame.Vector, 90, 325, {
			Rotation = 20
		})
		spr.stop(VectorFrame.UIScale)
		spr.target(VectorFrame.UIScale, 90, 325, {
			Scale = 1.2
		})
		task.wait(0.63 * v32)
		spr.stop(VectorFrame.Vector)
		spr.target(VectorFrame.Vector, 90, 325, {
			Rotation = 0
		})
		spr.stop(VectorFrame.UIScale)
		spr.target(VectorFrame.UIScale, 90, 325, {
			Scale = 1
		})
	end)
	spr.stop(Display)
	spr.stop(Display.UIScale)
	spr.stop(Container)
	spr.stop(VectorFrame)
	spr.stop(NewFrame)
	spr.stop(VectorFrame.Rays)
	VectorFrame.Rays.Rotation = 0
	Container.Position = UDim2.fromScale(0.5, 0.1)
	VectorFrame.Position = UDim2.fromScale(0.5, 0.45)
	NewFrame.Position = UDim2.fromScale(0.5, 0.45)
	Display.Position = UDim2.new(0.5, 0, -0.5, 0)
	if not v5.Enabled then
		v5.Enabled = true
	end
	spr.target(Display, 50, 325, {
		Position = UDim2.new(0.5, 0, 0, 80)
	})
	task.delay(0.3, function() --[[ Line: 375 | Upvalues: spr (ref), VectorFrame (ref) ]]
		spr.stop(VectorFrame.Rays)
		spr.target(VectorFrame.Rays, 3, 3, {
			Rotation = 540
		})
	end)
	task.wait(0.5 * v32)
	spr.stop(Display)
	spr.stop(Container)
	spr.stop(VectorFrame)
	spr.stop(NewFrame)
	task.wait(1.65 * v32)
	v16:Cancel()
	v16:Destroy()
	spr.stop(VectorFrame)
	spr.target(VectorFrame, 20, 90, {
		Position = UDim2.fromScale(0.5, -1.55)
	})
	spr.stop(NewFrame)
	spr.target(NewFrame, 20, 90, {
		Position = UDim2.fromScale(0.5, -1.55)
	})
	task.delay(0.1, function() --[[ Line: 402 | Upvalues: spr (ref), Container (ref) ]]
		spr.stop(Container)
		spr.target(Container, 20, 90, {
			Position = UDim2.fromScale(0.5, -1.9)
		})
	end)
	task.wait(1 * v32)
	spr.stop(VectorFrame.Vector)
	spr.stop(VectorFrame.UIScale)
	v7 = false
	v6:Fire()
end
return t2