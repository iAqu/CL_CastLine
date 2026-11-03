-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:48
-- Luau version 6, Types version 3
-- Time taken: 0.003538 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local tbl_upvw = {}
function module_upvr.ShowAwardItem(arg1, arg2, arg3, arg4, arg5) -- Line 9
	--[[ Upvalues[4]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvw (read and write)
		[3]: LocalPlayer_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
	if not Util_upvr.ShowAwards then
		if next(tbl_upvw) then
			tbl_upvw = {}
		end
		return
	end
	local Awards = LocalPlayer_upvr.PlayerGui:FindFirstChild("Awards")
	if not Awards then return end
	local pairs_result1, pairs_result2, pairs_result3 = pairs(Awards.List:GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [53] 43. Error Block 11 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [53] 43. Error Block 11 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [41] 33. Error Block 8 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [53.12]
	-- KONSTANTERROR: [41] 33. Error Block 8 end (CF ANALYSIS FAILED)
end
function module_upvr.ShowAwardPhysicalItem(arg1, arg2, arg3) -- Line 77
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetAsset_result1_upvr = Util_upvr.Assets:GetAsset("UI", "AwardDisplayBG")
	any_GetAsset_result1_upvr.Adornee = LocalPlayer_upvr.Character
	any_new_result1_upvr.BGUI = any_GetAsset_result1_upvr
	local var11_upvw = 0
	local var12_upvw = 0
	local Target_upvw = any_GetAsset_result1_upvr:GetAttribute("Target")
	local function _() -- Line 88, Named "Animate"
		--[[ Upvalues[6]:
			[1]: var12_upvw (read and write)
			[2]: var11_upvw (read and write)
			[3]: Target_upvw (read and write)
			[4]: any_GetAsset_result1_upvr (readonly)
			[5]: any_new_result1_upvr (readonly)
			[6]: Util_upvr (copied, readonly)
		]]
		var12_upvw = var11_upvw
		Target_upvw = any_GetAsset_result1_upvr:GetAttribute("Target") - var11_upvw
		any_new_result1_upvr.Close = nil
		any_new_result1_upvr.TweenText = Util_upvr.Thread.LoopFor(math.min(Target_upvw, 1), function(arg1_2) -- Line 92
			--[[ Upvalues[6]:
				[1]: var11_upvw (copied, read and write)
				[2]: var12_upvw (copied, read and write)
				[3]: Target_upvw (copied, read and write)
				[4]: any_GetAsset_result1_upvr (copied, readonly)
				[5]: Util_upvr (copied, readonly)
				[6]: any_new_result1_upvr (copied, readonly)
			]]
			var11_upvw = var12_upvw + Target_upvw * arg1_2
			any_GetAsset_result1_upvr.Frame.Amount.AmountText.Text = Util_upvr.ValueConvertor:AddCommas(math.floor(var11_upvw))
			if arg1_2 == 1 then
				any_new_result1_upvr.Close = Util_upvr.Thread.Delay(1, function() -- Line 96
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr (copied, readonly)
					]]
					any_new_result1_upvr:Destroy()
				end)
			end
		end)
	end
	var12_upvw = var11_upvw
	local var16_upvw = var12_upvw
	Target_upvw = any_GetAsset_result1_upvr:GetAttribute("Target") - var11_upvw
	local var17_upvw = Target_upvw
	any_new_result1_upvr.Close = nil
	any_new_result1_upvr.TweenText = Util_upvr.Thread.LoopFor(math.min(var17_upvw, 1), function(arg1_3) -- Line 92
		--[[ Upvalues[6]:
			[1]: var11_upvw (read and write)
			[2]: var16_upvw (read and write)
			[3]: var17_upvw (read and write)
			[4]: any_GetAsset_result1_upvr (readonly)
			[5]: Util_upvr (copied, readonly)
			[6]: any_new_result1_upvr (readonly)
		]]
		var11_upvw = var16_upvw + var17_upvw * arg1_3
		any_GetAsset_result1_upvr.Frame.Amount.AmountText.Text = Util_upvr.ValueConvertor:AddCommas(math.floor(var11_upvw))
		if arg1_3 == 1 then
			any_new_result1_upvr.Close = Util_upvr.Thread.Delay(1, function() -- Line 96
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr:Destroy()
			end)
		end
	end)
	any_new_result1_upvr.TargetChanged = any_GetAsset_result1_upvr:GetAttributeChangedSignal("Target"):Connect(function() -- Line 103
		--[[ Upvalues[6]:
			[1]: var16_upvw (read and write)
			[2]: var11_upvw (read and write)
			[3]: var17_upvw (read and write)
			[4]: any_GetAsset_result1_upvr (readonly)
			[5]: any_new_result1_upvr (readonly)
			[6]: Util_upvr (copied, readonly)
		]]
		var16_upvw = var11_upvw
		var17_upvw = any_GetAsset_result1_upvr:GetAttribute("Target") - var11_upvw
		any_new_result1_upvr.Close = nil
		any_new_result1_upvr.TweenText = Util_upvr.Thread.LoopFor(math.min(var17_upvw, 1), function(arg1_4) -- Line 92
			--[[ Upvalues[6]:
				[1]: var11_upvw (copied, read and write)
				[2]: var16_upvw (copied, read and write)
				[3]: var17_upvw (copied, read and write)
				[4]: any_GetAsset_result1_upvr (copied, readonly)
				[5]: Util_upvr (copied, readonly)
				[6]: any_new_result1_upvr (copied, readonly)
			]]
			var11_upvw = var16_upvw + var17_upvw * arg1_4
			any_GetAsset_result1_upvr.Frame.Amount.AmountText.Text = Util_upvr.ValueConvertor:AddCommas(math.floor(var11_upvw))
			if arg1_4 == 1 then
				any_new_result1_upvr.Close = Util_upvr.Thread.Delay(1, function() -- Line 96
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr (copied, readonly)
					]]
					any_new_result1_upvr:Destroy()
				end)
			end
		end)
	end)
	any_GetAsset_result1_upvr.Parent = LocalPlayer_upvr.PlayerGui
end
Util_upvr.Network.Events.ShowAwardPhysicalItem = function(...) -- Line 109
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:ShowAwardPhysicalItem(...)
end
Util_upvr.Network.Events.ShowAwardItem = function(...) -- Line 113
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:ShowAwardItem(...)
end
function module_upvr.Start(arg1) -- Line 117
end
Util_upvr.AwardDisplay = module_upvr
return module_upvr