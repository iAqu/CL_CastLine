-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Thread = require(ReplicatedStorage.Packages.Thread)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
require(ReplicatedStorage.Potions)
local Device = require(ReplicatedStorage.Modules.Device)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local t = {}
local t2 = {}
local v2 = LocalPlayer.PlayerGui:WaitForChild("Active Potions")
v2.Enabled = false
local Tile = v2.Rows.Tile
Tile.Parent = nil
local t3 = {
	["Double XP"] = {
		Id = 10,
		Quantity = 1,
		Infinite = true
	},
	["Advanced Luck"] = {
		Id = 9,
		Quantity = 1,
		Infinite = true
	},
	["Extra Luck"] = {
		Id = 3,
		Quantity = 1,
		Infinite = true
	},
	["Small Luck"] = {
		Id = 5,
		Quantity = 1,
		Infinite = true
	},
	["More Mutations"] = {
		Id = 7,
		Quantity = 1,
		Infinite = true
	},
	VIP = {
		Id = 8,
		Quantity = 1,
		Infinite = true
	}
}
local t4 = {}
local v3 = nil
local t5 = {}
local t6 = {
	Init = function(p1) --[[ Init | Line: 97 | Upvalues: t3 (copy), t5 (copy) ]]
		for v1, v2 in t3 do
			t5[v1] = {
				Expires = 0,
				Id = v2.Id,
				Quantity = v2.Quantity,
				Infinite = v2.Infinite
			}
		end
	end,
	Start = function(p1) --[[ Start | Line: 108 | Upvalues: v1 (ref), Replion (copy), Thread (copy), Device (copy), v2 (copy), LocalPlayer (copy) ]]
		v1 = Replion.Client:WaitReplion("Data")
		v1:OnArrayInsert("EquippedPotions", OnPotionAdded)
		v1:OnArrayRemove("EquippedPotions", OnPotionRemoved)
		v1:OnArrayInsert("TotemBoosts", OnTotemAdded)
		v1:OnArrayRemove("TotemBoosts", OnTotemRemoved)
		v1:OnChange({ "Settings", "Luck Modifiers" }, UpdateGamePassPotions)
		v1:OnArrayInsert("Passes", UpdateGamePassPotions)
		UpdateGamePassPotions()
		UpdateFriendshipBoost()
		Thread:Execute(2, UpdateExistingPotions)
		UpdateExistingPotions(1)
		local function DeviceChanged() --[[ DeviceChanged | Line: 130 | Upvalues: Device (ref), v2 (ref) ]]
			if Device:IsMobile() then
				v2.UIPadding.PaddingLeft = UDim.new(0, 20)
				v2.UIPadding.PaddingRight = UDim.new(0, 20)
			else
				v2.UIPadding.PaddingLeft = UDim.new(0, 5)
				v2.UIPadding.PaddingRight = UDim.new(0, 5)
			end
		end
		Device:RegisterDeviceChanged(DeviceChanged)
		DeviceChanged()
		v2.Enabled = true
		LocalPlayer:GetAttributeChangedSignal("FriendshipBoostConnections"):Connect(UpdateFriendshipBoost)
	end
}
function UpdateExistingPotions(p1) --[[ UpdateExistingPotions | Line: 149 | Upvalues: v1 (ref) ]]
	local v12 = v1:GetExpect("EquippedPotions")
	local v2 = if v1:GetExpect({ "Settings", "Luck Modifiers" }) then OnPotionAdded else OnPotionRemoved
	for i, v in ipairs(v12) do
		v2(i, v)
	end
end
function OnPotionAdded(p1, p2) --[[ OnPotionAdded | Line: 160 | Upvalues: ItemUtility (copy), t (copy), t4 (copy), Trove (copy), Tile (copy), ToolTip (copy), v2 (copy), t2 (copy) ]]
	local v1 = ItemUtility:GetPotionData(p2.Id)
	if not v1 then
		return
	end
	t[tonumber(p2.Id)] = true
	local v3 = t4[v1.Data.Name]
	if not v3 then
		local v4 = Trove.new()
		local v5 = Tile:Clone()
		v5.Vector.Image = v1.Data.Icon or ""
		v5.Label.Visible = false
		ToolTip.observe(v5, v4, function() --[[ Line: 177 | Upvalues: v1 (copy) ]]
			return {
				Style = "Label",
				Text = v1.Data.Description or "???"
			}
		end)
		v5.Destroying:Once(function() --[[ Line: 184 | Upvalues: v4 (copy) ]]
			v4:Destroy()
		end)
		v5.Parent = v2.Rows
		t4[v1.Data.Name] = v5
		v3 = v5
	end
	if t2[tonumber(p2.Id)] then
		return
	end
	if p2.Infinite then
		v3.Label.Visible = false
	else
		local Expires = p2.Expires
		local v7 = math.floor(Expires % 60)
		v3.Label.Text = ("%02i:%02i"):format((Expires - v7) / 60, v7)
		v3.Label.Visible = true
	end
end
function OnTotemAdded(p1, p2) --[[ OnTotemAdded | Line: 213 | Upvalues: ItemUtility (copy), t2 (copy), t4 (copy), Trove (copy), Tile (copy), ToolTip (copy), v2 (copy) ]]
	local v1 = ItemUtility:GetTotemData(p2.Id)
	if not v1 then
		return
	end
	if not v1.Boosts then
		return
	end
	for k, v in pairs(v1.Boosts) do
		local v22 = ItemUtility:GetPotionData((tonumber(v)))
		if v22 then
			t2[tonumber(v)] = true
			local v3 = t4[v22.Data.Name]
			if not v3 then
				local v4 = Trove.new()
				local v5 = Tile:Clone()
				v5.Vector.Image = v22.Data.Icon or ""
				v5.Label.Visible = false
				ToolTip.observe(v5, v4, function() --[[ Line: 239 | Upvalues: v22 (copy) ]]
					return {
						Style = "Label",
						Text = v22.Data.Description or "???"
					}
				end)
				v5.Destroying:Once(function() --[[ Line: 246 | Upvalues: v4 (copy) ]]
					v4:Destroy()
				end)
				v5.Parent = v2.Rows
				t4[v22.Data.Name] = v5
				v3 = v5
			end
			v3.Label.Visible = false
		end
	end
end
function OnPotionRemoved(p1, p2) --[[ OnPotionRemoved | Line: 261 | Upvalues: ItemUtility (copy), t4 (copy), t (copy) ]]
	local v1 = ItemUtility:GetPotionData(p2.Id)
	if not v1 then
		return
	end
	local v2 = t4[v1.Data.Name]
	if not v2 then
		return
	end
	t[tonumber(p2.Id)] = nil
	v2:Destroy()
	t4[v1.Data.Name] = nil
end
function OnTotemRemoved(p1, p2) --[[ OnTotemRemoved | Line: 279 | Upvalues: ItemUtility (copy), t2 (copy), t (copy), t4 (copy) ]]
	local v1 = ItemUtility:GetTotemData(p2.Id)
	if not v1 then
		return
	end
	if not v1.Boosts then
		return
	end
	for k, v in pairs(v1.Boosts) do
		local v2 = ItemUtility:GetPotionData((tonumber(v)))
		if v2 then
			t2[tonumber(v)] = nil
			if not t[tonumber(v)] then
				local v3 = t4[v2.Data.Name]
				if v3 then
					v3:Destroy()
					t4[v2.Data.Name] = nil
				end
			end
		end
	end
end
function UpdateGamePassPotions() --[[ UpdateGamePassPotions | Line: 308 | Upvalues: t3 (copy), t5 (copy), GamePassUtility (copy), v1 (ref), LocalPlayer (copy) ]]
	for v12, v2 in t3 do
		local v3 = t5[v12]
		if v3 then
			local v4 = GamePassUtility:GetGamePassIdFromName(v12)
			if v4 then
				local v5 = v1:GetExpect({ "Settings", "Luck Modifiers" })
				if GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v4) and v5 then
					OnPotionAdded(0, v3)
					continue
				end
				OnPotionRemoved(0, v3)
			end
		end
	end
end
function UpdateFriendshipBoost() --[[ UpdateFriendshipBoost | Line: 331 | Upvalues: LocalPlayer (copy), v3 (ref), t4 (copy), Trove (copy), Tile (copy), ToolTip (copy), v2 (copy) ]]
	local v1 = LocalPlayer:GetAttribute("FriendshipBoostConnections")
	if if typeof(v1) == "number" then v1 > 0 else false then
		if not t4["Friendship Boost"] then
			local v32 = Trove.new()
			local v4 = Tile:Clone()
			v4.Vector.Image = "rbxassetid://86976186336556"
			v4.Label.Visible = false
			ToolTip.observe(v4, v32, function() --[[ Line: 358 ]]
				return {
					Style = "Label",
					Text = "Friendship Boost Active\n+10% Luck"
				}
			end)
			v4.Destroying:Once(function() --[[ Line: 365 | Upvalues: v32 (copy), v3 (ref) ]]
				v32:Destroy()
				if v3 ~= v32 then
					return
				end
				v3 = nil
			end)
			v4.Parent = v2.Rows
			t4["Friendship Boost"] = v4
			v3 = v32
		end
	else
		if v3 then
			v3:Destroy()
			v3 = nil
		end
		local v5 = t4["Friendship Boost"]
		if not v5 then
			return
		end
		v5:Destroy()
		t4["Friendship Boost"] = nil
	end
end
return t6