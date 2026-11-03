-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local GiftingReward = PlayerGui:WaitForChild("GiftingReward")
local Frame = GiftingReward.Frame
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local GiftingRewards = require(ReplicatedStorage.Shared.GiftingRewards)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local v1 = GiftingRewards[#GiftingRewards]
local v2 = false
local v3 = nil
local v4 = -1
local v5 = "AltReward"
local t = {}
local t2 = {}
local function FlipShowingReward() --[[ FlipShowingReward | Line: 41 | Upvalues: v4 (ref), v5 (ref), TweenUtil (copy), Frame (copy), t (ref), t2 (ref) ]]
	v4 = os.time()
	if v5 == "AltReward" then
		v5 = "Reward"
		TweenUtil.TweenAll(Frame.AltReward, 1, TweenInfo.new(0.2), true)
		TweenUtil.TweenAllToMap(Frame.Reward, t, TweenInfo.new(0.2), true)
	else
		v5 = "AltReward"
		TweenUtil.TweenAll(Frame.Reward, 1, TweenInfo.new(0.2), true)
		TweenUtil.TweenAllToMap(Frame.AltReward, t2, TweenInfo.new(0.2), true)
	end
end
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 57 | Upvalues: v3 (ref), Replion (copy), Observers (copy), v1 (copy), GuiControl (copy), spr (copy), StringLibrary (copy), PlayerGui (copy), t3 (copy), GiftingReward (copy), v2 (ref), t (ref), TweenUtil (copy), Frame (copy), t2 (ref), FlipShowingReward (copy), RunService (copy), v4 (ref) ]]
	v3 = Replion.Client:WaitReplion("Data")
	Observers.observeTag("GiftingRewardProgress", function(p1) --[[ Line: 60 | Upvalues: v3 (ref), v1 (ref), GuiControl (ref), spr (ref), StringLibrary (ref) ]]
		local FillBar = p1.FillBar
		local function recalculateBar() --[[ recalculateBar | Line: 63 | Upvalues: v3 (ref), v1 (ref), GuiControl (ref), spr (ref), FillBar (copy), p1 (copy), StringLibrary (ref) ]]
			local _ = v3:Get("GiftAwardCount") or 0
			local v12 = v3:Get("GiftRobuxSpent") or 0
			local v32 = math.clamp(v12 % v1.Milestone / v1.Milestone, 0, 1)
			if GuiControl:IsOpen("GiftingRewards") then
				spr.stop(FillBar)
				spr.target(FillBar, 2, 10, {
					Size = UDim2.fromScale(v32, 1)
				})
			else
				FillBar.Size = UDim2.fromScale(v32, 1)
			end
			local Title = p1:FindFirstChild("Title")
			if not Title then
				return
			end
			Title.Text = ("%* / %*"):format(StringLibrary:AddCommas((math.floor(v12 % v1.Milestone))), (StringLibrary:AddCommas(v1.Milestone)))
		end
		v3:OnChange("GiftRobuxSpent", function() --[[ Line: 86 | Upvalues: recalculateBar (copy) ]]
			recalculateBar()
		end)
		recalculateBar()
	end, { PlayerGui })
	v3:OnChange("GiftRobuxSpent", function() --[[ Line: 94 | Upvalues: t3 (ref) ]]
		t3:UpdateProgress(false)
	end)
	v3:OnChange("GiftAwardCount", function() --[[ Line: 97 | Upvalues: t3 (ref) ]]
		t3:UpdateProgress(false)
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 101 | Upvalues: GiftingReward (ref), v2 (ref), t (ref), TweenUtil (ref), Frame (ref), t2 (ref), t3 (ref), FlipShowingReward (ref), RunService (ref), v4 (ref) ]]
		if p1 ~= GiftingReward then
			return
		end
		if not v2 then
			v2 = true
			t = TweenUtil.GetMap(Frame.Reward)
			t2 = TweenUtil.GetMap(Frame.AltReward)
			t3:LoadGifts()
		end
		FlipShowingReward()
		RunService:BindToRenderStep("RotateAlternativeReward", Enum.RenderPriority.Character.Value, function() --[[ Line: 115 | Upvalues: v4 (ref), FlipShowingReward (ref) ]]
			if not (os.time() - v4 > 5) then
				return
			end
			FlipShowingReward()
		end)
	end)
end
function t3.LoadGifts(p1) --[[ LoadGifts | Line: 128 | Upvalues: t3 (copy) ]]
	t3:UpdateProgress(true)
end
function t3.UpdateProgress(p1, p2) --[[ UpdateProgress | Line: 227 | Upvalues: v3 (ref), v1 (copy), Frame (copy), spr (copy), StringLibrary (copy) ]]
	local v12 = v3:Get("GiftRobuxSpent") or 0
	local v2 = v3:Get("GiftAwardCount") or 0
	local v4 = math.clamp(v12 % v1.Milestone / v1.Milestone, 0, 1)
	local BarBG = Frame.BarBG
	local Bar = BarBG.Bar
	spr.stop(Bar)
	if p2 then
		Bar.Size = UDim2.fromScale(0, 0)
	end
	spr.target(Bar, 40, 200, {
		Size = UDim2.fromScale(v4, 1)
	})
	BarBG.CurrentProgress.Text = ("%*%% Completed"):format(math.round(v4 * 10000) / 100)
	BarBG.ClaimCount.Text = ("Claimed %*"):format((StringLibrary:AddCommas(v2)))
	BarBG.ClaimCount.Visible = v2 > 0
end
return t3