-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
local Events = require(ReplicatedStorage.Events)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.Device)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Types.ServerBrowser)
local v1 = Net:RemoteEvent("ServerHop")
local v2 = nil
local v3 = nil
local MaxPlayers = Players.MaxPlayers
local ServerBrowser = Players.LocalPlayer.PlayerGui:WaitForChild("ServerBrowser")
local Frame = ServerBrowser:WaitForChild("Frame")
local OnlineLabel = Frame.Visual.ScrollingFrame.OnlineLabel
local Visual = Frame.Visual
local Input = Visual.Sort.Search.Input
local Sort = Visual.Sort.Sort
local ScrollingFrame = Visual.ScrollingFrame
local Frame_2 = ScrollingFrame.Frame
Frame_2.Parent = script
local v4 = Trove.new()
local t = {}
local t2 = {
	Generic = function(p1, p2, p3, p4) --[[ Generic | Line: 52 ]]
		local v1 = p1:lower()
		if p2:lower():find(v1) then
			return true
		end
		if p3.Locale and p3.Locale:lower():find(v1) then
			return true
		end
		local v2 = v1
		if p3.Region and p3.Region:lower():find(v2) then
			return true
		end
		if not p4 then
			return false
		end
		for k, v in pairs(p3.Events) do
			if v:lower():find(v2) then
				return true
			end
		end
		return false
	end
}
local v5 = nil
local v6 = nil
local v7 = false
local v8 = nil
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 86 | Upvalues: v2 (ref), Replion (copy), v3 (ref), GuiControl (copy), t3 (copy), ServerBrowser (copy), v7 (ref), v8 (ref), UserPriority (copy), UserInputService (copy), Input (copy) ]]
	v2 = Replion.Client:WaitReplion("RemoteConfigs")
	v3 = Replion.Client:WaitReplion("ServerBrowser")
	v3:OnChange("Servers", function(p1, p2) --[[ Line: 90 | Upvalues: GuiControl (ref), t3 (ref) ]]
		if not GuiControl:IsOpen("ServerBrowser") then
			return
		end
		t3.ServersChanged(p1, p2)
	end)
	v3:OnChange("OnlinePlayers", t3.UpdatePlayers)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 98 | Upvalues: ServerBrowser (ref), v7 (ref), t3 (ref) ]]
		if p1 ~= ServerBrowser then
			return
		end
		if v7 then
			return
		end
		v7 = true
		t3:Unload()
		v7 = false
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 111 | Upvalues: ServerBrowser (ref), v8 (ref), v7 (ref), t3 (ref) ]]
		if p1 ~= ServerBrowser then
			return
		end
		local v1 = tick()
		v8 = v1
		if v7 then
			repeat
				task.wait(0.1)
			until not v7
		end
		if v1 ~= v1 then
			return
		end
		t3:Load()
	end)
	if not UserPriority:IsValidTestSession() then
		Input.FocusLost:Connect(function() --[[ Line: 145 | Upvalues: t3 (ref) ]]
			t3:UpdateFilter()
		end)
		return
	end
	UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 128 | Upvalues: GuiControl (ref) ]]
		if p2 then
			return
		end
		if p1.KeyCode ~= Enum.KeyCode.Q then
			return
		end
		if GuiControl:IsOpen("ServerBrowser") then
			GuiControl:Close()
		else
			GuiControl:Open("ServerBrowser")
		end
	end)
	Input.FocusLost:Connect(function() --[[ Line: 145 | Upvalues: t3 (ref) ]]
		t3:UpdateFilter()
	end)
end
function t3.GetLayoutOrder(p1, p2, p3) --[[ GetLayoutOrder | Line: 150 | Upvalues: LocalizationService (copy) ]]
	local v1 = p3.Locale:sub(1, 1)
	local v2 = p3.Locale:sub(2, 2)
	local v3 = 127462 + (v1:byte() - 65) + 127462 + (v2:byte() - 65)
	if p2 == game.JobId then
		return v3 * -100000
	end
	if p3.Locale == LocalizationService.RobloxLocaleId then
		return v3 * -1000 + p3.Ping
	else
		return v3 * 100 + p3.Ping
	end
end
function t3.ValidateFiter(p1, p2, p3, p4, p5) --[[ ValidateFiter | Line: 160 | Upvalues: v3 (ref) ]]
	local v1 = v3.Data.Servers[p3]
	if v1 then
		return p4(p2, p3, v1, p5)
	else
		return false
	end
end
function t3.RunCurrentFilter(p1, p2, p3) --[[ RunCurrentFilter | Line: 169 | Upvalues: v5 (ref), v6 (ref) ]]
	if v5 and v6 then
		return v6(v5, p2, p3, true)
	else
		return true
	end
end
function t3.UpdateFilter(p1) --[[ UpdateFilter | Line: 177 | Upvalues: Input (copy), Events (copy), v5 (ref), v6 (ref), t (copy), t2 (copy), t3 (copy) ]]
	local v1 = Input.Text:lower()
	local v2 = false
	for k in pairs(Events) do
		if k:lower():find(v1) then
			v2 = true
			break
		end
	end
	if string.len(v1) == 0 then
		v5 = nil
		v6 = nil
		for k, v in pairs(t) do
			v.Visible = true
		end
	else
		local Generic = t2.Generic
		v5 = v1
		v6 = Generic
		for k, v in pairs(t) do
			v.Visible = t3:ValidateFiter(v1, k, Generic, v2)
		end
	end
end
function t3.Unload(p1) --[[ Unload | Line: 212 | Upvalues: v4 (copy), t (copy), t3 (copy) ]]
	v4:Clean()
	for k in pairs(t) do
		t3.RemoveTile(k)
	end
end
function t3.Load(p1) --[[ Load | Line: 220 | Upvalues: v4 (copy), v3 (ref), t3 (copy) ]]
	local v1 = nil
	v1 = v4:Add(task.spawn(function() --[[ Line: 222 | Upvalues: v3 (ref), t3 (ref), v4 (ref), v1 (ref) ]]
		local v12 = v3:GetExpect("Servers")
		local v2 = workspace:GetAttribute("CountryCode")
		local count = 0
		local count_2 = 0
		local function loadTile() --[[ loadTile | Line: 229 | Upvalues: t3 (ref), count_2 (ref) ]]
			pcall(function() --[[ Line: 230 | Upvalues: t3 (ref) ]]
				t3.AddTile(jobId, serverData)
			end)
			count_2 = count_2 + 1
			if count_2 % 50 ~= 0 then
				return
			end
			task.wait()
		end
		if v2 then
			for k, v in pairs(v12) do
				if v.Locale == v2 then
					count = count + 1
				end
			end
		end
		if count >= 100 then
			for k, v in pairs(v12) do
				if v.Locale == v2 then
					pcall(function() --[[ Line: 230 | Upvalues: t3 (ref) ]]
						t3.AddTile(jobId, serverData)
					end)
					count_2 = count_2 + 1
					if count_2 % 50 == 0 then
						task.wait()
					end
					if count_2 > 500 then
						break
					end
				end
			end
		else
			for k, v in pairs(v12) do
				pcall(function() --[[ Line: 230 | Upvalues: t3 (ref) ]]
					t3.AddTile(jobId, serverData)
				end)
				count_2 = count_2 + 1
				if count_2 % 50 == 0 then
					task.wait()
				end
				if count_2 > 500 then
					break
				end
			end
		end
		t3.UpdatePlayers()
		v4:Remove(v1)
	end))
end
function t3.ServersChanged(p1, p2) --[[ ServersChanged | Line: 273 | Upvalues: TableUtil (copy), t3 (copy) ]]
	for k, v in pairs((TableUtil.IntersectDictionary(p1, p2))) do
		t3.RemoveTile(v)
	end
	local count = 0
	for k, v in pairs(p1) do
		t3.AddTile(k, v, p2[k] and p2[k].Events or {})
		count = count + 1
		if count % 50 == 0 then
			task.wait()
		end
	end
end
function t3.RemoveTile(p1) --[[ RemoveTile | Line: 293 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if v1 then
		v1:Destroy()
		t[p1] = nil
	end
end
function t3.GetTile(p1, p2) --[[ GetTile | Line: 303 | Upvalues: t (copy), Frame_2 (copy), GuiControl (copy), v2 (ref), TextNotificationController (copy), v1 (copy), t3 (copy), ScrollingFrame (copy) ]]
	local v12 = t[p1]
	if v12 then
		return v12, true
	end
	if not p2 then
		return nil, false
	end
	local v22 = Frame_2:Clone()
	local JoinButton = v22:FindFirstChild("JoinButton")
	if not JoinButton then
		return nil, false
	end
	if if p1 == game.JobId or p1 == "" then true elseif game.JobId == "" then true else false then
		v22.BackgroundColor3 = Color3.fromRGB(20, 73, 141)
		JoinButton.Visible = false
	else
		GuiControl:Hook("Hold Button", JoinButton).Clicked:Connect(function() --[[ Line: 326 | Upvalues: v2 (ref), TextNotificationController (ref), v1 (ref), p1 (copy) ]]
			if v2:Get("ServerBrowser") then
				v1:FireServer(p1)
			else
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Server browser is disabled!",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
		end)
		JoinButton.Visible = true
	end
	v22.LayoutOrder = t3:GetLayoutOrder(p1, p2)
	v22.Visible = t3:RunCurrentFilter(p1, p2)
	v22.Parent = ScrollingFrame
	t[p1] = v22
	return v22, true
end
function t3.AddTile(p1, p2, p3) --[[ AddTile | Line: 352 | Upvalues: t3 (copy), StringLibrary (copy), MaxPlayers (copy), EventUtility (copy), ToolTip (copy) ]]
	local v1, v2 = t3.GetTile(p1, p2)
	if not v1 then
		return
	end
	if not v1.Parent then
		return
	end
	local v3 = if p1 == game.JobId or p1 == "" then true elseif game.JobId == "" then true else false
	local Frame = v1.Events.Frame
	local Frame_2 = v1.Performance.Frame
	v1.Top.Flag.Text = ("%* %* | %*"):format(StringLibrary.CountryCodeToEmoji(p2.Locale) or "??", p2.Region or "??", v3 and ("Your Server - %*"):format(p1) or p1)
	if p2.RAP then
		v1.RAP.Section.Text = ("RAP: %*"):format((StringLibrary:AddCommas(p2.RAP)))
		v1.RAP.Visible = true
	else
		v1.RAP.Visible = false
	end
	if p2.Fish then
		v1.FishCaught.Section.Text = ("Fish Caught: %*"):format((StringLibrary:AddCommas(p2.Fish)))
		v1.FishCaught.Visible = true
	else
		v1.FishCaught.Visible = false
	end
	Frame_2.PingFrame.Label.Text = ("Avg Ping: %*ms"):format((math.round(p2.Ping)))
	Frame_2.PlayersFrame.Label.Text = ("Players: %*/%*"):format(#p2.Players, MaxPlayers)
	Frame_2.UptimeFrame.Label.Text = ("Uptime: %*"):format((formatDHMS(p2.Uptime or 0)))
	for i, v in ipairs(p2.Events) do
		if not Frame:FindFirstChild(v) then
			local v8 = EventUtility:GetEvent(v)
			if v8 then
				local ImageButton = Instance.new("ImageButton")
				ImageButton.Name = v
				ImageButton.Image = v8.Icon
				ImageButton.Size = UDim2.fromScale(0.9, 0.9)
				ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
				ImageButton.BackgroundTransparency = 1
				ToolTip.observe(ImageButton, nil, function() --[[ Line: 415 | Upvalues: v8 (copy), v (copy) ]]
					local t = {
						Style = "Label"
					}
					t.Text = v8.Name or v or "???"
					return t
				end)
				ImageButton.Parent = Frame
			end
		end
	end
	if p3 and #p3 > 0 then
		for i, v in ipairs((intersectArray(p3, p2.Events))) do
			local v10 = Frame:FindFirstChild(v)
			if v10 then
				v10:Destroy()
			end
		end
	end
	Frame.Visible = if #p2.Events > 0 then true else false
	if not v2 then
		return
	end
	v1.LayoutOrder = t3:GetLayoutOrder(p1, p2)
	v1.Visible = t3:RunCurrentFilter(p1, p2)
end
function t3.UpdatePlayers() --[[ UpdatePlayers | Line: 445 | Upvalues: UserPriority (copy), OnlineLabel (copy), TableUtil (copy), v3 (ref), StringLibrary (copy) ]]
	if not UserPriority:IsTradePlaza() then
		OnlineLabel.Visible = false
		return
	end
	OnlineLabel.Text = if TableUtil.Count(v3.Data.Servers) < 1 then "Total Players Online: ??" else ("Total Players Online: %*"):format((StringLibrary:AddCommas((v3:GetExpect("OnlinePlayers")))))
	OnlineLabel.Visible = true
end
function formatDHMS(p1) --[[ formatDHMS | Line: 464 ]]
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
function intersectArray(p1, p2) --[[ intersectArray | Line: 481 ]]
	local t = {}
	for i, v in ipairs(p2) do
		t[v] = true
	end
	local t2 = {}
	for i, v in ipairs(p1) do
		if not t[v] then
			table.insert(t2, v)
		end
	end
	return t2
end
return t3