-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local spr = require(ReplicatedStorage.Packages.spr)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Promise = require(ReplicatedStorage.Packages.Promise)
require(ReplicatedStorage.Emotes)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.Animations)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Shared.GiftProducts)
require(ReplicatedStorage.Shared.GamePassUtility)
local DialogueController = require(ReplicatedStorage.Controllers.DialogueController)
local v1 = Net:RemoteFunction("PurchaseEmote")
local EmoteShop = LocalPlayer.PlayerGui:WaitForChild("EmoteShop")
local Tile = EmoteShop.Main.Content.Scroll.Tile
Tile.Parent = nil
local v2 = nil
local v3 = Promise.promisify(function() --[[ Line: 49 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v1 then
		return v1:GetAppliedDescription()
	end
	error("No rig humanoid")
end)
local t = {}
function t.Start(p1) --[[ Start | Line: 62 | Upvalues: v2 (ref), Replion (copy), GuiControl (copy), EmoteShop (copy), t (copy), DialogueController (copy) ]]
	v2 = Replion.Client:WaitReplion("Data")
	local v1 = nil
	v1 = GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 66 | Upvalues: EmoteShop (ref), v1 (ref), t (ref) ]]
		if p1 ~= EmoteShop then
			return
		end
		v1:Disconnect()
		t:LoadEmotes()
	end)
	DialogueController:ObservePath("Jordan", 1, function(p1) --[[ Line: 73 | Upvalues: GuiControl (ref) ]]
		if p1 ~= 1 then
			return
		end
		GuiControl:Open("EmoteShop")
	end)
end
function t.OwnsEmote(p1, p2) --[[ OwnsEmote | Line: 80 | Upvalues: ItemUtility (copy), PlayerStatsUtility (copy), v2 (ref) ]]
	local v1 = ItemUtility.GetItemDataFromItemType("Emotes", p2)
	if not v1 then
		return false
	end
	return PlayerStatsUtility:GetItemFromInventory(v2, function(p1) --[[ Line: 88 | Upvalues: v1 (copy) ]]
		return p1.Id == v1.Data.Id
	end, "Emotes") ~= nil
end
function t.LoadEmotes(p1) --[[ LoadEmotes | Line: 96 | Upvalues: ItemUtility (copy), TierUtility (copy), t (copy), Trove (copy), Tile (copy), StringLibrary (copy), spr (copy), GuiControl (copy), v1 (copy), Soundbook (copy), v2 (ref), EmoteShop (copy) ]]
	for i, v in ipairs((ItemUtility:GetEmotes())) do
		local v12 = v.Price or v.RobuxPrice
		if v12 then
			local v22 = TierUtility:GetTier(v.Data.Tier)
			if v22 then
				local ProductId = v.ProductId
				local RobuxPrice = v.RobuxPrice
				local Id = v.Data.Id
				local v3 = if v.RobuxPrice then -1000 - v.RobuxPrice else v22.Tier * 1000 + v.Price
				local v4 = if ProductId == nil then false elseif RobuxPrice == nil then false else true
				local v5 = t:OwnsEmote(Id)
				local v6 = if v.Price == nil then false else not v5
				local v7 = Trove.new()
				local v8 = Tile:Clone()
				local ViewportFrame = v8.BG.ViewportFrame
				local PurchaseOptions = v8.PurchaseOptions
				local Buy = PurchaseOptions.Buy
				local function refreshEmoteTile() --[[ refreshEmoteTile | Line: 124 | Upvalues: t (ref), Id (copy), v4 (copy), v7 (copy), Buy (copy) ]]
					local v1 = t:OwnsEmote(Id)
					local v2 = if v1 then not v4 else v1
					if v2 then
						v7:Destroy()
					end
					Buy.Label.Text = if v2 then "Owned Emote" else "Buy"
				end
				v8.Padded.Top.Label.Text = v.Data.Name
				v8.Padded.Top.RarityLabel.Text = v22.Name
				v8.Padded.Top.RarityLabel.UIGradient.Color = v22.TierColor
				v8.BG.Glow.UIGradient.Color = v22.TierColor
				v8.BG.Glow.Visible = if v22.Tier > 1 then true else false
				v8.UIStroke.UIGradient.Color = v22.TierColor
				v8.BG.Middle.Vector.UIStroke.UIGradient.Color = v22.TierColor
				v8.BG.Glow.UIGradient.Color = v22.TierColor
				v8.BG.Middle.Vector.Image = v.Data.Icon or ""
				if ProductId and RobuxPrice then
					v8.Padded.Info.Visible = false
					PurchaseOptions.Gift.Visible = true
					PurchaseOptions.Buy.Size = UDim2.fromScale(0.85, 0.85)
					ViewportFrame.Size = UDim2.fromScale(1, 1.275)
					PurchaseOptions:SetAttribute("DevProductId", ProductId)
					PurchaseOptions:AddTag("DevProductPurchase")
					Buy:SetAttribute("DevProductId", ProductId)
					Buy:AddTag("DevProductPrice")
				elseif v12 then
					PurchaseOptions.Gift.Visible = false
					PurchaseOptions.Buy.Size = UDim2.fromScale(1, 1)
					v8.Padded.Info.Quantity.Text = StringLibrary:AddCommas(v12)
				else
					v8.Padded.Info.Visible = false
					PurchaseOptions.Visible = false
				end
				local function mouseEnter() --[[ mouseEnter | Line: 168 | Upvalues: spr (ref), ViewportFrame (copy) ]]
					spr.stop(ViewportFrame)
					spr.target(ViewportFrame, 30, 80, {
						ImageTransparency = 0
					})
					local CurrentCamera = ViewportFrame.CurrentCamera
					if CurrentCamera then
						spr.stop(CurrentCamera)
						spr.target(CurrentCamera, 30, 80, {
							FieldOfView = 50
						})
					end
					spr.completed(ViewportFrame, function() --[[ Line: 182 | Upvalues: ViewportFrame (ref) ]]
						ViewportFrame.LayoutOrder = 10
					end)
				end
				local function mouseLeave() --[[ mouseLeave | Line: 187 | Upvalues: spr (ref), ViewportFrame (copy) ]]
					spr.stop(ViewportFrame)
					spr.target(ViewportFrame, 30, 80, {
						ImageTransparency = 0.5
					})
					local CurrentCamera = ViewportFrame.CurrentCamera
					if not CurrentCamera then
						spr.completed(ViewportFrame, function() --[[ Line: 201 | Upvalues: ViewportFrame (ref) ]]
							ViewportFrame.LayoutOrder = 2
						end)
						return
					end
					spr.stop(CurrentCamera)
					spr.target(CurrentCamera, 30, 80, {
						FieldOfView = 60
					})
					spr.completed(ViewportFrame, function() --[[ Line: 201 | Upvalues: ViewportFrame (ref) ]]
						ViewportFrame.LayoutOrder = 2
					end)
				end
				v8.MouseEnter:Connect(mouseEnter)
				v8.SelectionGained:Connect(mouseEnter)
				v8.MouseLeave:Connect(mouseLeave)
				v8.SelectionLost:Connect(mouseLeave)
				if v6 then
					local v10 = GuiControl:Hook("Hold Button", Buy, nil, nil, v7)
					v10.Clicked:Connect(function() --[[ Line: 214 | Upvalues: t (ref), Id (copy), v1 (ref), Soundbook (ref) ]]
						if t:OwnsEmote(Id) then
							return
						end
						if not v1:InvokeServer(Id) then
							return
						end
						Soundbook.Sounds.StorePurchase:Play()
						Soundbook.Sounds.CoinsChanged:Play()
					end)
					v7:Add(function() --[[ Line: 226 | Upvalues: v10 (copy) ]]
						v10:Destroy()
					end)
				end
				v2:OnChange({ "Inventory", "Emotes" }, refreshEmoteTile)
				local v11 = t:OwnsEmote(Id)
				local v122 = if v11 then not v4 else v11
				if v122 then
					v7:Destroy()
				end
				Buy.Label.Text = if v122 then "Owned Emote" else "Buy"
				v8.LayoutOrder = v3
				v8.Parent = EmoteShop.Main.Content.Scroll
				createModel(ViewportFrame, i, v)
			end
		end
	end
end
function createModel(p1, p2, p3) --[[ createModel | Line: 245 | Upvalues: Promise (copy), v3 (copy), LocalPlayer (copy) ]]
	local v1 = CFrame.new(0, 0, p2 * 1000)
	local v2 = script.EmoteRig:Clone()
	local Humanoid = v2.Humanoid
	local Animator = Humanoid.Animator
	Humanoid.AutoRotate = false
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	for i, v in ipairs(v2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.CollisionGroup = "Players"
		end
	end
	v2:PivotTo(v1)
	v2.Parent = p1
	Promise.try(v3, LocalPlayer):andThen(function(p1) --[[ Line: 274 | Upvalues: Humanoid (copy) ]]
		Humanoid:ApplyDescription(p1)
	end):catch(warn)
	Promise.try(function() --[[ Line: 279 | Upvalues: p3 (copy), v2 (copy), Animator (copy) ]]
		local Animation = Instance.new("Animation")
		Animation.AnimationId = p3.AnimationId
		Animation.Parent = script
		local v1 = loadTrack(v2, Animator, Animation)
		if not v1 then
			return
		end
		v1.Priority = Enum.AnimationPriority.Action4
		v1.Looped = true
		v1:Play(nil, nil, p3.PlaybackSpeed)
	end)
	local v32 = fitToFrame(v2, v1)
	local Camera = Instance.new("Camera")
	Camera.FieldOfView = 60
	Camera.CFrame = v1 * CFrame.new(0, 0, -v32 * 1.05) * CFrame.Angles(-0.08726646259971647, math.pi, 0)
	Camera.Parent = p1
	p1.CurrentCamera = Camera
end
function loadTrack(p1, p2, p3) --[[ loadTrack | Line: 302 ]]
	local v1, v2 = pcall(function() --[[ Line: 307 | Upvalues: p2 (copy), p3 (copy) ]]
		return p2:LoadAnimation(p3)
	end)
	if v1 then
		return v2
	end
end
function fitToFrame(p1, p2) --[[ fitToFrame | Line: 318 ]]
	local v1, v2 = p1:GetBoundingBox()
	if not (v1 and v2) then
		return 1
	end
	if p2 then
		v1 = p2
	end
	local v3 = (v1 - v1.Position):Inverse() * v2
	local v7 = Vector3.new(math.abs(v3.X), math.abs(v3.Y), (math.abs(v3.Z)))
	local v8 = math.max(v7.X, v7.Y, v7.Z)
	return v8 / 2 / 0.5773502691896257 + (if v8 == v7.X then math.sqrt(v7.Y * v7.Y + v7.Z * v7.Z) / 2 elseif v8 == v7.Y then math.sqrt(v7.X * v7.X + v7.Z * v7.Z) / 2 else math.sqrt(v7.X * v7.X + v7.Y * v7.Y) / 2)
end
return t