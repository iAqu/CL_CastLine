-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Constants = require(ReplicatedStorage.Shared.Constants)
local function CountAll(p1) --[[ CountAll | Line: 12 ]]
	local sum = 0
	for v1, v2 in p1 do
		if v1 ~= "Boats" then
			sum = sum + v2
		end
	end
	return sum
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 27 | Upvalues: Observers (copy), Constants (copy) ]]
	task.wait(4)
	Observers.observeTag("NotificationAlert", function(p12) --[[ Line: 30 | Upvalues: Constants (ref), p1 (copy) ]]
		local v1 = p1:OnChange("StoreNotification", function(p1) --[[ updateAlert | Line: 31 | Upvalues: p12 (copy), Constants (ref) ]]
			if not p1 then
				p12.Visible = false
				return
			end
			p12.Visible = p1 < Constants.StoreNotification
		end)
		local v2 = p1:Get("StoreNotification")
		if v2 then
			p12.Visible = v2 < Constants.StoreNotification
		else
			p12.Visible = false
		end
		return function() --[[ Line: 42 | Upvalues: v1 (copy) ]]
			v1:Disconnect()
		end
	end)
	Observers.observeTag("NotificationBubble", function(p12) --[[ Line: 47 | Upvalues: p1 (copy) ]]
		local Label = p12:FindFirstChild("Label")
		if not Label then
			return
		end
		local v1 = p12:GetAttribute("ItemType")
		if not v1 then
			return
		end
		local v2 = nil
		if v1 == "All" then
			v2 = p1:OnChange("InventoryNotifications", function(p1) --[[ onNotificationCountChanged | Line: 61 | Upvalues: Label (copy), p12 (copy) ]]
				local sum = 0
				for v1, v2 in p1 do
					if v1 ~= "Boats" then
						sum = sum + v2
					end
				end
				if sum > 0 then
					Label.Text = tostring(sum)
					p12.Visible = true
				else
					p12.Visible = false
				end
			end)
			local sum = 0
			for v3, v4 in p1:GetExpect("InventoryNotifications") do
				if v3 ~= "Boats" then
					sum = sum + v4
				end
			end
			if sum > 0 then
				Label.Text = tostring(sum)
				p12.Visible = true
			else
				p12.Visible = false
			end
		elseif p1:Get({ "InventoryNotifications", v1 }) then
			v2 = p1:OnChange({ "InventoryNotifications", v1 }, function(p1) --[[ onValueChanged | Line: 77 | Upvalues: Label (copy), p12 (copy) ]]
				if p1 > 0 then
					Label.Text = tostring(p1)
					p12.Visible = true
				else
					p12.Visible = false
				end
			end)
			local v5 = p1:GetExpect({ "InventoryNotifications", v1 })
			if v5 > 0 then
				Label.Text = tostring(v5)
				p12.Visible = true
			else
				p12.Visible = false
			end
		end
		return function() --[[ Line: 91 | Upvalues: v2 (ref) ]]
			if not (v2 and v2.Connected) then
				return
			end
			v2:Disconnect()
		end
	end)
end)
return {}