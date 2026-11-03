-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("GuiService")
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Thread)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Modules.CurrencyUtility)
require(ReplicatedStorage.Shared.StringLibrary)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local DailyRewardsUtility = require(ReplicatedStorage.Shared.DailyRewardsUtility)
require(ReplicatedStorage.Shared.RewardInfo)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
require(ReplicatedStorage.Controllers.PromptController)
local Device = require(ReplicatedStorage.Modules.Device)
local Constants = require(ReplicatedStorage.Shared.Constants)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v2 = PlayerGui:WaitForChild("!!! Update Log")
local v3 = PlayerGui:WaitForChild("!!! Daily Login")
local MainFrame = v3.Main.MainFrame
local v4 = MainFrame.Content
local ProgressBar = MainFrame.ProgressBar
local v5 = Net:RemoteFunction("ClaimDailyLogin")
local v6 = Net:RemoteEvent("RecievedDailyRewards")
local v7 = Net:RemoteEvent("UpdateChangeLog")
local v8 = false
local t = { 0.06, 0.2, 0.34, 0.48, 0.62, 0.78, 1 }
local t2 = {
	Buttons = {
		ActiveDay = {
			Image = "rbxassetid://125448249763547",
			HoverImage = ""
		},
		InactiveDay = {
			Image = "rbxassetid://85341066062909",
			HoverImage = ""
		},
		NormalDay = {
			Image = "rbxassetid://72156093853240",
			HoverImage = ""
		},
		FinalDay = {
			Image = "rbxassetid://130884365093528",
			HoverImage = ""
		},
		ClaimedButton = {
			Image = "rbxassetid://131222119201378",
			HoverImage = "",
			Outline = Color3.fromRGB(59, 59, 59)
		},
		ClaimButton = {
			Image = "rbxassetid://74200413420801",
			HoverImage = "rbxassetid://122490084115477",
			Outline = Color3.fromRGB(10, 90, 33)
		},
		Unfilled = {
			Image = "rbxassetid://113519249638685"
		},
		Filled = {
			Image = "rbxassetid://94287407798844"
		}
	}
}
local v9 = Trove.new()
local v10 = nil
local t3 = {}
function t3.ShowDailyReward(p1, p2) --[[ ShowDailyReward | Line: 117 | Upvalues: ContentProvider (copy), v3 (copy), t3 (copy), GuiControl (copy) ]]
	pcall(function() --[[ Line: 118 | Upvalues: ContentProvider (ref), v3 (ref) ]]
		ContentProvider:PreloadAsync({ v3.Dots, v3.Sparkles, v3.Vignette })
	end)
	v3.Main.Streak.Text = ("Your Streak: %*"):format(p2.Streak)
	t3:Update()
	GuiControl:Lock()
	GuiControl:Open("!!! Daily Login", true)
end
function t3.Init(p1) --[[ Init | Line: 133 | Upvalues: GuiControl (copy), v3 (copy), v8 (ref), t3 (copy), Soundbook (copy), v9 (copy), InputControl (copy), v6 (copy), v10 (ref), v1 (ref) ]]
	GuiControl:Hook("Hold Button", v3.Main.MainFrame.Close).Clicked:Connect(function() --[[ Line: 134 | Upvalues: v8 (ref), t3 (ref), GuiControl (ref) ]]
		if v8 then
			GuiControl:Close(true)
		else
			t3:ShowLog()
		end
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 145 | Upvalues: v3 (ref), Soundbook (ref), v9 (ref), GuiControl (ref) ]]
		if p1 ~= v3 then
			return
		end
		Soundbook.Sounds.CoinsChanged:Play().Volume = 0.6
		v9:Clean()
		GuiControl:Unlock()
	end)
	InputControl:RegisterInput({ Enum.KeyCode.X }, { function() --[[ Line: 157 | Upvalues: GuiControl (ref) ]]
			return GuiControl:IsOpen("!!! Daily Login")
		end }, function() --[[ Line: 161 | Upvalues: GuiControl (ref) ]]
		GuiControl:Close(true)
		GuiControl:Unlock()
	end)
	v6.OnClientEvent:Connect(function(p1) --[[ Line: 166 | Upvalues: v10 (ref), v1 (ref), t3 (ref) ]]
		v10 = p1
		local v12 = v1 and v1:Get("PlayerOnboarding")
		if v12 and v1:Find("CompletedQuests", "First 5 Catch Experience") == nil then
			local v3 = nil
			v3 = v1:OnChange("CompletedQuests", function(p12) --[[ Line: 174 | Upvalues: v3 (ref), t3 (ref), p1 (copy) ]]
				if not table.find(p12, "First 5 Catch Experience") then
					return
				end
				v3:Disconnect()
				t3:ShowDailyReward(p1)
			end)
			return
		end
		t3:ShowDailyReward(p1)
	end)
	playTween(v3.Sparkles1)
	playTween(v3.Sparkles2)
end
function t3.Start(p1) --[[ Start | Line: 192 | Upvalues: v1 (ref), Replion (copy), LocalPlayer (copy), v5 (copy), Device (copy), v2 (copy), GuiControl (copy), v8 (ref), t3 (copy), v7 (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	task.spawn(function() --[[ Line: 196 | Upvalues: LocalPlayer (ref), v1 (ref), v5 (ref) ]]
		while true do
			repeat
				local count = 0.5
				if LocalPlayer:GetAttribute("Loading") then
					LocalPlayer:GetAttributeChangedSignal("Loading"):Wait()
					count = count + 1
				end
				task.wait(count)
			until workspace:GetServerTimeNow() >= v1:GetExpect("LastLogin") + 86400
			v5:InvokeServer()
		end
	end)
	Device:RegisterDeviceChanged(RefreshConsoleInputs)
	task.spawn(RefreshConsoleInputs)
	local v12 = v2.Main.Content
	local Pages = v12.Pages
	local Selection = v12.Selection
	local UIPageLayout = v12.UIPageLayout
	local t = {}
	for i, v in ipairs(Pages:GetChildren()) do
		if v:IsA("GuiObject") then
			table.insert(t, v)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 237 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	local function hideAllPages() --[[ hideAllPages | Line: 241 | Upvalues: t (copy) ]]
		for i, v in ipairs(t) do
			v.Visible = false
		end
	end
	local function resetPage() --[[ resetPage | Line: 247 | Upvalues: Selection (copy), Pages (copy), t (copy), UIPageLayout (copy) ]]
		Selection.Visible = true
		Pages.Visible = true
		for i, v in ipairs(t) do
			v.Visible = false
		end
		UIPageLayout:JumpTo(Selection)
	end
	local function setPage(p1) --[[ setPage | Line: 255 | Upvalues: Selection (copy), Pages (copy), t (copy), UIPageLayout (copy) ]]
		Selection.Visible = true
		Pages.Visible = true
		local v1 = Pages:FindFirstChild(p1)
		if v1 then
			for i, v in ipairs(t) do
				v.Visible = false
			end
			v1.Visible = true
		end
		UIPageLayout:JumpTo(Pages)
	end
	task.defer(setPage, t[1].Name)
	GuiControl.GuiFocusedSignal:Once(function(p1) --[[ Line: 270 | Upvalues: v2 (ref), t (copy), Selection (copy), Pages (copy), UIPageLayout (copy) ]]
		if p1 ~= v2 then
			return
		end
		task.wait(0.1)
		Selection.Visible = true
		Pages.Visible = true
		local v22 = Pages:FindFirstChild(t[1].Name)
		if v22 then
			for i, v in ipairs(t) do
				v.Visible = false
			end
			v22.Visible = true
		end
		UIPageLayout:JumpTo(Pages)
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 277 | Upvalues: v2 (ref), Selection (copy), Pages (copy), t (copy), UIPageLayout (copy) ]]
		if p1 ~= v2 then
			return
		end
		Selection.Visible = true
		Pages.Visible = true
		for i, v in ipairs(t) do
			v.Visible = false
		end
		UIPageLayout:JumpTo(Selection)
	end)
	GuiControl:Hook("Hold Button", v2.Main.Toggle).Clicked:Connect(function() --[[ Line: 283 | Upvalues: Selection (copy), Pages (copy), t (copy), UIPageLayout (copy) ]]
		Selection.Visible = true
		Pages.Visible = true
		for i, v in ipairs(t) do
			v.Visible = false
		end
		UIPageLayout:JumpTo(Selection)
	end)
	UIPageLayout:GetPropertyChangedSignal("CurrentPage"):Connect(function() --[[ Line: 288 | Upvalues: UIPageLayout (copy), v2 (ref), Pages (copy) ]]
		v2.Main.Toggle.Visible = UIPageLayout.CurrentPage == Pages
	end)
	for i, v in ipairs(Selection:GetChildren()) do
		if v:IsA("GuiButton") then
			GuiControl:Hook("Hold Button", v).Clicked:Connect(function() --[[ Line: 298 | Upvalues: v (copy), Selection (copy), Pages (copy), t (copy), UIPageLayout (copy) ]]
				Selection.Visible = true
				Pages.Visible = true
				local v2 = Pages:FindFirstChild(v.Name)
				if not v2 then
					UIPageLayout:JumpTo(Pages)
					return
				end
				for i, v3 in ipairs(t) do
					v3.Visible = false
				end
				v2.Visible = true
				UIPageLayout:JumpTo(Pages)
			end)
		end
	end
	local Exit = v2.Main.Top.Exit
	if workspace:GetServerTimeNow() < v1:GetExpect("LastLogin") + 86400 then
		v8 = true
		t3:ShowLog()
	end
	GuiControl:Hook("Hold Button", Exit).Clicked:Connect(function() --[[ Line: 322 | Upvalues: Exit (copy), GuiControl (ref), v7 (ref) ]]
		if Exit:GetAttribute("Unlock") == true then
			GuiControl:Unlock()
		end
		v7:FireServer()
		GuiControl:Close()
	end)
end
function t3.ShowLog(p1) --[[ ShowLog | Line: 335 | Upvalues: v1 (ref), Constants (copy), GuiControl (copy), v8 (ref) ]]
	local v12 = false
	if v1 then
		local v2 = v1:GetExpect("LastGameVersion") or 0
		if v1:GetExpect("Level") >= 10 then
			v12 = Constants.GameVersion ~= v2
		end
	end
	if v12 then
		GuiControl:Open("!!! Update Log", true)
		return
	end
	if v8 then
		return
	end
	GuiControl:Close(true)
end
function t3.Update(p1) --[[ Update | Line: 362 | Upvalues: v1 (ref), DailyRewardsUtility (copy), v4 (copy), v10 (ref), ItemUtility (copy), ProgressBar (copy), t2 (copy), t (copy) ]]
	local v12 = v1:GetExpect("LoginStreak")
	local v2 = v1:Get("ClaimedWeeklyBoat")
	local _, v3 = DailyRewardsUtility:GetReward(v12)
	local v42 = v4["7"]
	local v5 = nil
	local v6 = nil
	if v2 and (v10 and v10.CurrencyRewardInfo.Type ~= "Boats") then
		local v7 = DailyRewardsUtility:GetMaxReward()
		local v8 = ItemUtility.GetItemDataFromItemType(v7.Type, v7.Identifier)
		v6 = v7.Quantity
		v5 = v8
	else
		local v9 = DailyRewardsUtility:GetRewards()
		local v102 = v9[#v9]
		if v102 then
			local v11 = ItemUtility.GetItemDataFromItemType(v102.Type, v102.Identifier)
			v6 = v102.Quantity
			v5 = v11
		end
	end
	if v5 and v6 then
		v42.Vector.Image = v5.Data.Icon or ""
		v42.Quantity.Text = ("x%*"):format(v6 or 0)
	else
		v42.Vector.Visible = false
		v42.Quantity.Visible = false
	end
	for i = 1, #DailyRewardsUtility:GetRewards() do
		local v122 = ("%*"):format(i)
		local v13 = v4:FindFirstChild(v122)
		if v13 then
			local v14 = ProgressBar.Markers:FindFirstChild(v122)
			if v14 then
				local v15 = i == v12
				local v16 = if i <= v12 then true else false
				local Button = v13:FindFirstChild("Button")
				if Button then
					Button.Visible = v15
				end
				v14.Image = (v16 and t2.Buttons.Filled or t2.Buttons.Unfilled).Image
				v14.Icon.Visible = v16
			end
		end
	end
	ProgressBar.Fill.Size = UDim2.fromScale(t[v3] or 0, 1)
end
function GetOriginalPosition(p1) --[[ GetOriginalPosition | Line: 431 ]]
	local v1 = p1:GetAttribute("OriginalPosition")
	if v1 then
		return v1
	else
		local Position = p1.Position
		p1:SetAttribute("OriginalPosition", Position)
		return Position
	end
end
function RefreshConsoleInputs(p1) --[[ RefreshConsoleInputs | Line: 443 | Upvalues: v3 (copy), UserInputService (copy), Device (copy) ]]
	local Close = v3.Main.MainFrame.Close
	if p1 then
		local UserInputType = p1.UserInputType
	else
		UserInputService:GetLastInputType()
	end
	if Device:_getDevice() == "Console" then
		Close.Vector.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
		Close.Vector.Visible = true
	else
		Close.Vector.Visible = false
	end
end
function playTween(p1) --[[ playTween | Line: 455 | Upvalues: TweenService (copy), v9 (copy) ]]
	local v1 = GetOriginalPosition(p1)
	if v1 then
		p1.Position = v1 - UDim2.fromOffset(0, 10)
		local v2 = TweenService:Create(p1, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, -1, true), {
			Position = v1
		})
		v9:Add(function() --[[ Line: 469 | Upvalues: v2 (copy) ]]
			v2:Cancel()
			v2:Destroy()
		end)
		v2:Play()
	end
end
return t3