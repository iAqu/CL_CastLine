-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("UserService")
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"))
local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
local Observers = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Observers"))
local Trove = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Trove"))
local Leaderboards = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Leaderboards"))
local StringLibrary = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("StringLibrary"))
local ItemUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemUtility"))
local TierUtility = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("TierUtility"))
local UserInfo = require(script:WaitForChild("UserInfo"))
local Colors = require(script:WaitForChild("Colors"))
local LeaderboardColors = require(script:WaitForChild("LeaderboardColors"))
require(script:WaitForChild("Types"))
local Tile = script:WaitForChild("Tile")
local FishTile = script:WaitForChild("FishTile")
local function ObserveLeaderboard(p1) --[[ ObserveLeaderboard | Line: 47 | Upvalues: Leaderboards (copy), Trove (copy), UserInfo (copy), FishTile (copy), ItemUtility (copy), TierUtility (copy), StringLibrary (copy), LeaderboardColors (copy), Colors (copy), Tile (copy), Replion (copy) ]]
	local v1 = p1:GetAttribute("Type")
	local v2 = v1 and Leaderboards[v1]
	if v2 then
		local Scrolling = p1:WaitForChild("Bottom"):WaitForChild("Scrolling")
		local v3 = nil
		local v4 = Trove.new()
		local v5 = false
		local function DestroyTiles() --[[ DestroyTiles | Line: 59 | Upvalues: v4 (copy) ]]
			v4:Clean()
		end
		local function Render() --[[ Render | Line: 63 | Upvalues: v3 (ref), v5 (ref), v4 (copy), UserInfo (ref), v1 (copy), FishTile (ref), ItemUtility (ref), TierUtility (ref), StringLibrary (ref), LeaderboardColors (ref), Colors (ref), Scrolling (copy), Tile (ref), v2 (copy) ]]
			if v3.Destroyed then
				return
			end
			local v12 = v3:Get("Ranks")
			if not v12 then
				return
			end
			if #v12 == 0 then
				return
			end
			local v22 = v3:Get("Context")
			local v32 = v3:Get("OrderedUserIds")
			if not v32 then
				return
			end
			if #v32 == 0 then
				return
			end
			if v5 then
				return
			end
			v5 = true
			v4:Clean()
			UserInfo:UpdateUserInfoCache(v32)
			local v42 = UserInfo:GetCache()
			local function populateTile(p1) --[[ populateTile | Line: 88 | Upvalues: v12 (copy), v1 (ref), v4 (ref), FishTile (ref), v22 (copy), ItemUtility (ref), TierUtility (ref), StringLibrary (ref), v42 (copy), LeaderboardColors (ref), Colors (ref), Scrolling (ref), Tile (ref) ]]
				local v13 = v12[p1]
				if not v13 then
					return
				end
				local v2 = tonumber(v13.key) or 0
				local v3 = tonumber(v13.value) or 0
				if v1 == "Rarest Caught Fish" then
					local v43 = v4:Clone(FishTile)
					local Frame = v43.Frame
					local UserFrame = Frame.UserFrame
					local DisplayFrame = Frame.DisplayFrame
					local VectorFrame = Frame.VectorFrame
					local RankFrame = Frame.RankFrame
					local Tier = DisplayFrame.Modifier.Tier
					local VariantId = DisplayFrame.Modifier.VariantId
					local v5 = v22[p1]
					local v6 = if v5 then v5.Score else v3
					if v5 then
						local v7 = ItemUtility:GetItemData(v5.Id)
						if not v7 then
							return
						end
						local v8 = if v7.Probability then TierUtility:GetTierFromRarity(v7.Probability.Chance) else TierUtility:GetTier(v7.Data.Tier)
						if not v8 then
							return
						end
						local v11 = if v5.Variant then ItemUtility:GetVariantData(v5.Variant) else nil
						local Weight = v5.Weight
						DisplayFrame.ItemHeader.Label.Text = v7.Data.Name
						VectorFrame.Inside.Vector.Image = v7.Data.Icon
						VectorFrame.Date.Text = DateTime.fromUnixTimestamp(v5.Timestamp):FormatLocalTime("l", "en-us")
						Tier.Label.Text = v8.Name
						Tier.Label.UIGradient.Color = v8.TierColor
						RankFrame.Inside.UIStroke.UIGradient.Color = v8.TierColor
						UserFrame.Inside.UIStroke.UIGradient.Color = v8.TierColor
						VectorFrame.Inside.UIStroke.UIGradient.Color = v8.TierColor
						VectorFrame.Inside.Gradient.UIGradient.Color = v8.TierColor
						VectorFrame.Inside.Glow.UIGradient.Color = v8.TierColor
						VectorFrame.Inside.Shape.UIGradient.Color = v8.TierColor
						if v11 then
							VariantId.Vector.UIGradient.Color = v11.Data.TierColor
							VariantId.Label.UIGradient.Color = v11.Data.TierColor
							VariantId.Label.Text = v11.Data.Name
							VariantId.Visible = true
						else
							VariantId.Visible = false
						end
						DisplayFrame.Bottom.Big.Visible = v5.Big
						DisplayFrame.Bottom.Shiny.Visible = v5.Shiny
						if Weight then
							DisplayFrame.Bottom.Weight.Label.Text = StringLibrary:AddWeight(Weight)
							DisplayFrame.Bottom.Weight.Visible = true
						else
							DisplayFrame.Bottom.Weight.Visible = false
						end
					else
						DisplayFrame.Bottom.Visible = false
						DisplayFrame.ItemHeader.Visible = false
						DisplayFrame.Modifier.Visible = false
						VectorFrame.Visible = false
					end
					RankFrame.Score.Text = ("1 in %*"):format((StringLibrary:Shorten(v6)))
					local v132 = v42[v2]
					if v132 then
						DisplayFrame.Display.Label.Text = ("%* (@%*)"):format(v132.DisplayName, v132.Username)
						UserFrame.Vector.Verified.Visible = v132.HasVerifiedBadge
					else
						DisplayFrame.Display.Label.Text = ("UserId %*"):format(v2)
						UserFrame.Vector.Verified.Visible = false
					end
					UserFrame.Vector.Image = ("rbxthumb://type=AvatarBust&id=%*&w=60&h=60"):format(v2)
					UserFrame.Vector.Visible = true
					RankFrame.Label.TextColor3 = (LeaderboardColors[v1] or Colors)[p1] or Color3.fromRGB(255, 255, 255)
					RankFrame.Label.Text = tostring(p1)
					v43.LayoutOrder = p1
					v43.Parent = Scrolling
				else
					local v16 = v4:Clone(Tile)
					local Frame = v16.Frame
					local UserFrame = Frame.UserFrame
					local v17 = v42[v2]
					if v17 then
						UserFrame.Frame.DisplayName.Text = ("%*"):format(v17.DisplayName)
						UserFrame.Frame.Username.Text = ("@%*"):format(v17.Username)
						UserFrame.Vector.Verified.Visible = v17.HasVerifiedBadge
					else
						UserFrame.Frame.DisplayName.Text = ("%*"):format(v2)
						UserFrame.Frame.Username.Text = ("@%*"):format(v2)
						UserFrame.Vector.Verified.Visible = false
					end
					if p1 < 10 then
						UserFrame.Vector.Image = ("rbxthumb://type=AvatarBust&id=%*&w=60&h=60"):format(v2)
						UserFrame.Vector.Visible = true
					else
						UserFrame.Vector.Visible = false
					end
					local v19 = (LeaderboardColors[v1] or Colors)[p1] or Color3.fromRGB(255, 255, 255)
					Frame.Label.Text = StringLibrary:Shorten(v3)
					Frame.RankFrame.Label.TextColor3 = v19
					Frame.RankFrame.Label.Text = tostring(p1)
					v16.LayoutOrder = p1
					v16.Parent = Scrolling
				end
			end
			for i = 1, v2.VisualPlacements do
				populateTile(i)
				if i % 5 == 0 then
					task.wait(0.1)
				end
			end
			v5 = false
		end
		local function LoadingStateChanged(p12) --[[ LoadingStateChanged | Line: 262 | Upvalues: p1 (copy) ]]
			p1.LoadingLabel.Visible = p12
		end
		Replion.Client:AwaitReplion(v1, function(p12) --[[ Line: 266 | Upvalues: v3 (ref), LoadingStateChanged (copy), Render (copy), p1 (copy) ]]
			v3 = p12
			v3:OnChange("Loading", LoadingStateChanged)
			v3:OnChange("OrderedUserIds", Render)
			task.delay(1, function() --[[ Line: 272 | Upvalues: v3 (ref), p1 (ref), Render (ref) ]]
				p1.LoadingLabel.Visible = v3:GetExpect("Loading")
				if not (#v3.Data.OrderedUserIds > 0) then
					return
				end
				Render()
			end)
		end)
		return function() --[[ Line: 281 | Upvalues: v4 (copy) ]]
			v4:Clean()
		end
	end
end
Observers.observeTag("Leaderboard", ObserveLeaderboard)
return {}