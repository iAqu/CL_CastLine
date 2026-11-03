-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("TweenService")
game:GetService("RunService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Packages.spr)
local Thread = require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Shared.UserPriority)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local v2 = Trove.new()
local v3 = Trove.new()
local v4 = nil
local v5 = nil
v5 = Observers.observeTag("WorldNotificationGui", function(p1) --[[ Line: 30 | Upvalues: v4 (ref), v5 (ref) ]]
	if not p1:IsA("BillboardGui") then
		return
	end
	v4 = p1
	v5()
end)
local PlayerGui = Players.LocalPlayer.PlayerGui
PlayerGui:WaitForChild("Compass")
local Main = PlayerGui:WaitForChild("Text Notifications"):WaitForChild("Frame"):WaitForChild("Main")
local t = {}
local function FormatDHMS(p1) --[[ FormatDHMS | Line: 48 ]]
	local v1 = p1 % 86400
	local v2 = math.floor(p1 / 86400)
	local v3 = math.floor(v1 / 3600)
	local v4 = math.floor(v1 % 3600 / 60)
	local v5 = math.floor(p1 % 60)
	if v2 >= 1 then
		return string.format("%02dd %02dh %02dm %02ds", v2, v3, v4, v5)
	end
	if v3 >= 1 then
		return string.format("%02dh %02dm %02ds", v3, v4, v5)
	else
		return string.format("%02dm %02ds", v4, v5)
	end
end
local function HideWorldNotification() --[[ HideWorldNotification | Line: 65 | Upvalues: v4 (ref), v3 (copy) ]]
	if not v4 then
		v3:Clean()
		return
	end
	v4.Enabled = false
	v3:Clean()
end
local function HideUI() --[[ HideUI | Line: 73 | Upvalues: Main (copy), v2 (copy) ]]
	Main.Visible = false
	v2:Clean()
end
local function ShowUI() --[[ ShowUI | Line: 78 | Upvalues: v3 (copy), Thread (copy), v1 (ref), v4 (ref), FormatDHMS (copy), v2 (copy), Main (copy) ]]
	v3:Clean()
	v3:Add(Thread:Execute(1, function() --[[ Line: 83 | Upvalues: v1 (ref), v4 (ref), v3 (ref), FormatDHMS (ref) ]]
		local v12 = workspace:GetServerTimeNow()
		local v2 = v1:Get("NextUpdate") or 0
		local v32 = v1:Get("EventName")
		v1:Get("Description")
		if v32 == "NONE" then
			if v4 then
				v4.Enabled = false
			end
			v3:Clean()
		else
			local v42 = v2 - v12
			local v5 = FormatDHMS(v42)
			if v42 <= 0 then
				v5 = "Update is now!"
			end
			if v42 <= -30 then
				if v4 then
					v4.Enabled = false
				end
				v3:Clean()
			else
				if not v4 then
					return
				end
				v4.Frame.DisplayName.Text = v32 or ""
				v4.Frame.Frame.Remaining.Text = v5
			end
		end
	end))
	if not v4 then
		v2:Clean()
		v2:Add(Thread:Execute(1, function() --[[ Line: 123 | Upvalues: v1 (ref), Main (ref), v2 (ref), FormatDHMS (ref) ]]
			local v12 = workspace:GetServerTimeNow()
			local v22 = v1:Get("NextUpdate") or 0
			local v3 = v1:Get("EventName")
			local v4 = v1:Get("Description")
			if v3 == "NONE" then
				Main.Visible = false
				v2:Clean()
				return
			end
			local v5 = v22 - v12
			local v6 = FormatDHMS(v5)
			if v5 <= 0 then
				v6 = "Update is now!"
			end
			if v5 <= -30 then
				Main.Visible = false
				v2:Clean()
				return
			end
			Main.Content.Info.Header.Text = v3 or ""
			Main.Content.Info.Description.Text = if v4 == "NONE" then "" else v4
			Main.Content.Countdown.Label.Text = v6
		end), "Disconnect")
		Main.Visible = true
		return
	end
	v4.Enabled = true
	v2:Clean()
	v2:Add(Thread:Execute(1, function() --[[ Line: 123 | Upvalues: v1 (ref), Main (ref), v2 (ref), FormatDHMS (ref) ]]
		local v12 = workspace:GetServerTimeNow()
		local v22 = v1:Get("NextUpdate") or 0
		local v3 = v1:Get("EventName")
		local v4 = v1:Get("Description")
		if v3 == "NONE" then
			Main.Visible = false
			v2:Clean()
			return
		end
		local v5 = v22 - v12
		local v6 = FormatDHMS(v5)
		if v5 <= 0 then
			v6 = "Update is now!"
		end
		if v5 <= -30 then
			Main.Visible = false
			v2:Clean()
			return
		end
		Main.Content.Info.Header.Text = v3 or ""
		Main.Content.Info.Description.Text = if v4 == "NONE" then "" else v4
		Main.Content.Countdown.Label.Text = v6
	end), "Disconnect")
	Main.Visible = true
end
local function CheckEvent() --[[ CheckEvent | Line: 157 | Upvalues: v1 (ref), Main (copy), v2 (copy), v4 (ref), v3 (copy), ShowUI (copy) ]]
	if not (workspace:GetServerTimeNow() > (v1:Get("NextUpdate") or 0)) then
		ShowUI()
		return
	end
	Main.Visible = false
	v2:Clean()
	if not v4 then
		v3:Clean()
		return
	end
	v4.Enabled = false
	v3:Clean()
end
function t.Start(p1) --[[ Start | Line: 171 | Upvalues: Replion (copy), v1 (ref), CheckEvent (copy), Main (copy), v2 (copy), v4 (ref), v3 (copy), ShowUI (copy), GuiControl (copy), HideUI (copy) ]]
	Replion.Client:AwaitReplion("RemoteConfigs", function(p1) --[[ Line: 172 | Upvalues: v1 (ref), CheckEvent (ref), Main (ref), v2 (ref), v4 (ref), v3 (ref), ShowUI (ref) ]]
		v1 = p1
		p1:OnChange("NextUpdate", CheckEvent)
		if not (workspace:GetServerTimeNow() > (p1:Get("NextUpdate") or 0)) then
			ShowUI()
			return
		end
		Main.Visible = false
		v2:Clean()
		if v4 then
			v4.Enabled = false
		end
		v3:Clean()
	end)
	GuiControl:Hook("Hold Button", Main.BG.Close).Clicked:Connect(HideUI)
end
return t