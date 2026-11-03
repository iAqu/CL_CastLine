-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Modules.ToolTip)
require(ReplicatedStorage.Types.Modifiers)
local v1 = nil
local v2 = nil
local v3 = nil
local function runPrompt(p1, p2, p3, p4) --[[ runPrompt | Line: 39 | Upvalues: StringLibrary (copy), ItemStringUtility (copy), v1 (ref) ]]
	local v12 = StringLibrary:Shorten(p1)
	local v2 = ItemStringUtility.GetItemName(p2.Item, p3)
	local v3 = p4.TierColor.Keypoints[1].Value
	local v9, v10 = v1:FirePrompt((("Buy <font color=\"rgb(%*)\">%*</font> for <font color=\"rgb(255, 206, 93)\">%* Trade Tokens</font>?"):format(("%*, %*, %*"):format(math.round(v3.R * 255), math.round(v3.G * 255), (math.round(v3.B * 255))), v2, v12))):await()
	if v9 then
		return v10
	else
		return false
	end
end
local function promptTokenPurchase(p1) --[[ promptTokenPurchase | Line: 57 | Upvalues: v3 (ref), GuiControl (copy) ]]
	if not v3 then
		return false
	end
	local v1 = v3:Get("Tokens") or 0
	print(p1 <= v1)
	if p1 <= v1 then
		return false
	else
		GuiControl:Open("! Trade Tokens")
		return true
	end
end
local function runDeletePrompt(p1, p2, p3) --[[ runDeletePrompt | Line: 72 | Upvalues: ItemStringUtility (copy), v1 (ref) ]]
	local v12 = ItemStringUtility.GetItemName(p1.Item, p2)
	local v2 = p3.TierColor.Keypoints[1].Value
	local v8, v9 = v1:FirePrompt((("Unlist <font color=\"rgb(%*)\">%*</font> from booth?"):format(("%*, %*, %*"):format(math.round(v2.R * 255), math.round(v2.G * 255), (math.round(v2.B * 255))), v12))):await()
	if v8 then
		return v9
	else
		return false
	end
end
local function errorMessage(p1, p2) --[[ errorMessage | Line: 88 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		},
		CustomDuration = p2
	})
end
local function successMessage(p1, p2) --[[ successMessage | Line: 97 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		},
		CustomDuration = p2
	})
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 106 | Upvalues: v3 (ref), v1 (ref), ReplicatedStorage (copy), v2 (ref), Observers (copy), Trove (copy), Players (copy), Replion (copy), GuiControl (copy), StringLibrary (copy), ItemUtility (copy), runPrompt (copy), TradeData (copy), successMessage (copy), errorMessage (copy), runDeletePrompt (copy) ]]
	v3 = p1
	v1 = require(ReplicatedStorage.Controllers.PromptController)
	v2 = require(ReplicatedStorage.Controllers.Trading.TradeController.Renderer)
	Observers.observeTag("Booth", function(p1) --[[ Line: 112 | Upvalues: Trove (ref), Players (ref), v2 (ref), Replion (ref), GuiControl (ref), StringLibrary (ref), ItemUtility (ref), v3 (ref), runPrompt (ref), TradeData (ref), successMessage (ref), errorMessage (ref), runDeletePrompt (ref), Observers (ref) ]]
		local Plane = p1:WaitForChild("Plane")
		local v1 = Plane and Plane:WaitForChild("SurfaceGui", 120)
		if v1 then
			local v22 = Trove.new()
			local v32 = nil
			local function updateOwner() --[[ updateOwner | Line: 126 | Upvalues: p1 (copy), Players (ref), v32 (ref), v2 (ref), Replion (ref), v22 (copy), GuiControl (ref), v1 (copy), StringLibrary (ref), ItemUtility (ref), v3 (ref), runPrompt (ref), TradeData (ref), successMessage (ref), errorMessage (ref), runDeletePrompt (ref) ]]
				local v12 = p1:GetAttribute("Owner")
				local v23 = v12 and Players:GetPlayerByUserId(v12)
				if not v23 then
					return
				end
				local v33 = false
				if v32 and v32.Player ~= v23 or not v32 then
					if v32 then
						v32:DestroyTiles()
					end
					v32 = v2.new(v23, nil, nil, false, false)
					v33 = true
				end
				local v4 = Replion.Client:WaitReplion("SaleListings")
				local v5 = if Players.LocalPlayer == v23 then true else false
				local v6 = p1:FindFirstChildWhichIsA("ProximityPrompt", true)
				if v6 then
					v6.ActionText = if v5 then "Edit Booth" else "Open Booth"
					v6.Enabled = v5
					v22:Add(v6.Triggered:Connect(function() --[[ Line: 155 | Upvalues: v5 (copy), GuiControl (ref) ]]
						if not v5 then
							return
						end
						GuiControl:Open("! Booth")
					end))
				end
				local function updateListings() --[[ updateListings | Line: 163 | Upvalues: v4 (copy), v12 (copy), v1 (ref), v32 (ref), StringLibrary (ref), ItemUtility (ref), v2 (ref), v5 (copy), GuiControl (ref), v3 (ref), runPrompt (ref), TradeData (ref), v23 (copy), successMessage (ref), errorMessage (ref), runDeletePrompt (ref), v22 (ref) ]]
					local t = {}
					t[1] = "Players"
					t[2] = tostring(v12)
					t[3] = "Booth"
					local v33 = v4:Get(t)
					local Items = v1:WaitForChild("Items", 30)
					if not Items then
						return
					end
					if not v33 then
						return
					end
					for v42, v52 in Items:GetChildren() do
						if v52:IsA("Frame") and not v33[v52.Name] then
							local v6 = v52:GetAttribute("ItemType")
							local v7 = v52:GetAttribute("ItemId")
							local v8 = v52:GetAttribute("ItemUUID")
							if v6 and (v7 and v8) then
								v32:DestroyTile(v6, v7, v8)
							end
							v52:Destroy()
						end
					end
					for k, v in pairs(v33) do
						if v32 then
							local v9 = Items:FindFirstChild(k)
							if v9 then
								if v9:FindFirstChild("Inside") then
									local Buy = v9:FindFirstChild("Buy")
									if Buy and v.Price then
										Buy:SetAttribute("LastKnownPrice", v.Price)
										Buy.Label.Text = StringLibrary:AddCommas(v.Price)
									end
								end
								continue
							end
							local v10 = ItemUtility.GetItemDataFromItemType(v.ItemType, v.Item.Id)
							if v10 then
								local v11 = v2.getTierData(v10)
								if v11 then
									local v122 = v32:Draw(v.ItemType, v.Item.Id, v.Item)
									if v122 then
										local v132 = script.Tile:Clone()
										v132.Name = k
										v132:SetAttribute("ItemType", v.ItemType)
										v132:SetAttribute("ItemId", v.Item.Id)
										v132:SetAttribute("ItemUUID", v.Item.UUID)
										local Buy = v132.Buy
										local Template = v132.Template
										if v.Price then
											Buy:SetAttribute("LastKnownPrice", v.Price)
											Buy.Label.Text = StringLibrary:AddCommas(v.Price)
										else
											Buy.Label.Text = "???"
										end
										v122.Tile.Name = "Inside"
										v122.Tile.SizeConstraint = Enum.SizeConstraint.RelativeYY
										v122.Tile.AnchorPoint = Template.AnchorPoint
										v122.Tile.Position = Template.Position
										v122.Tile.Size = Template.Size
										v122.Visible = true
										Template:Destroy()
										v122.Tile.Parent = v132
										v132.LayoutOrder = v.Price
										v132.Parent = Items
										local v14 = false
										local v15 = nil
										local v16 = nil
										if v5 then
											v16 = GuiControl:Hook("Hold Button", v132.Delete)
											v16.Clicked:Connect(function() --[[ Line: 305 | Upvalues: runDeletePrompt (ref), v (copy), v10 (copy), v11 (copy), TradeData (ref), k (copy), successMessage (ref), errorMessage (ref) ]]
												if not runDeletePrompt(v, v10, v11) then
													return
												end
												local v1, v2 = TradeData.Remotes.DeleteSaleListing:InvokeServer("Booth", k)
												if v1 then
													successMessage("This item is NO longer selling!", nil)
													return
												end
												errorMessage(v2, nil)
											end)
										else
											v132.Delete:Destroy()
											v15 = GuiControl:Hook("Hold Button", Buy)
											v15.Clicked:Connect(function() --[[ Line: 267 | Upvalues: Buy (copy), v3 (ref), GuiControl (ref), v14 (ref), runPrompt (ref), v (copy), v10 (copy), v11 (copy), TradeData (ref), v23 (ref), k (copy), successMessage (ref), errorMessage (ref) ]]
												local v1 = Buy:GetAttribute("LastKnownPrice")
												if not v1 then
													return
												end
												local v2
												if v3 then
													local v32 = v3:Get("Tokens") or 0
													print(v1 <= v32)
													if v1 <= v32 then
														v2 = false
													else
														GuiControl:Open("! Trade Tokens")
														v2 = true
													end
												else
													v2 = false
												end
												if v2 then
													return
												end
												if v14 then
													return
												end
												v14 = true
												if not runPrompt(v1, v, v10, v11) then
													v14 = false
													return
												end
												local v6, v7 = TradeData.Remotes.PurchaseSaleListing:InvokeServer(v23, "Booth", k)
												if v6 then
													successMessage((("Successfully bought %*!"):format(v10.Data.Name)))
												else
													if v7 == "Not enough Tokens!" and v3 then
														local v8 = v3:Get("Tokens") or 0
														print(v1 <= v8)
														if not (v1 <= v8) then
															GuiControl:Open("! Trade Tokens")
														end
													end
													errorMessage(v7, nil)
												end
												v14 = false
											end)
										end
										v22:Add(v122.Tile.Destroying:Once(function() --[[ Line: 318 | Upvalues: v15 (ref), v16 (ref), v132 (copy) ]]
											if v15 then
												v15:Destroy()
											end
											if v16 then
												v16:Destroy()
											end
											v132:Destroy()
										end))
									end
								end
							end
						end
					end
				end
				v22:Add(v4:OnDescendantChange({ "Players", tostring(v12), "Booth" }, function() --[[ Line: 334 | Upvalues: updateListings (copy) ]]
					updateListings()
				end))
				if not v33 then
					return
				end
				updateListings()
			end
			v22:Add(Observers.observeAttribute(p1, "Owner", function() --[[ Line: 343 | Upvalues: updateOwner (copy) ]]
				updateOwner()
			end))
			return function() --[[ Line: 347 | Upvalues: v32 (ref), v22 (copy) ]]
				if v32 then
					v32:Destroy()
					v32 = nil
				end
				v22:Destroy()
			end
		else
			print("Unable to set up booth due to no SurfaceGui!")
		end
	end, { workspace })
end)
return {}