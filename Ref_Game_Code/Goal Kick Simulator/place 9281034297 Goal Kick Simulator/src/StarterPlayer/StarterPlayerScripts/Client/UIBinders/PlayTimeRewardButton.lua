-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:11
-- Luau version 6, Types version 3
-- Time taken: 0.002280 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function UpdateTime(arg1_2) -- Line 12
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: any_new_result1_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 34 start (CF ANALYSIS FAILED)
		local var13
		for i, v in pairs(Util_upvr.PlaytimeFrames) do
			local var14 = arg1_2 / v
			local clamped = math.clamp(var14, 0, 1)
			if clamped == 1 then
				local var16
				if any_GetLink_result1_upvr.ClaimedGifts and any_GetLink_result1_upvr.ClaimedGifts[i.Name] then
					var16 = "✅"
				else
					var16 = "Redeem!"
				end
				i.TimeLeft.Text = var16
				var16 = i.ProgressBar
				var16 = ColorSequence.new(Color3.new(0, 1, 0))
				var16.UIGradient.Color = var16
			else
				var16 = Util_upvr.ValueConvertor:FormatTime(math.ceil(v - arg1_2))
				i.TimeLeft.Text = var16
				var16 = i.ProgressBar
				var16 = ColorSequence.new(Color3.fromRGB(55, 202, 255))
				var16.UIGradient.Color = var16
				var16 = i.ProgressBar
				var16 = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(clamped, 0.025)
				var16.UIGradient.Transparency = var16
			end
			i.ProgressBar.Visible = false
			if not any_GetLink_result1_upvr.ClaimedGifts or not any_GetLink_result1_upvr.ClaimedGifts[i.Name] or not var13 or nil < var14 then
				var13 = i
			end
		end
		-- KONSTANTERROR: [0] 1. Error Block 34 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [178] 119. Error Block 20 start (CF ANALYSIS FAILED)
		any_new_result1_upvr.AnimateWiggle = Util_upvr.Thread.Every(3, function() -- Line 42
			--[[ Upvalues[2]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			Util_upvr.Thread.LoopFor(0.45, function(arg1_3) -- Line 43
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1.Icon.Rotation = math.sin(arg1_3 * math.pi * 2) * 20
				arg1.Icon.Position = UDim2.new(0.5, 0, 0.5, -math.sin(arg1_3 * math.pi) * 5)
			end)
		end)
		do
			return
		end
		-- KONSTANTERROR: [178] 119. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [192] 130. Error Block 21 start (CF ANALYSIS FAILED)
		any_new_result1_upvr.AnimateWiggle = nil
		arg1.Tip.Visible = false
		arg1.ProgressBar.Visible = false
		-- KONSTANTERROR: [192] 130. Error Block 21 end (CF ANALYSIS FAILED)
	end
	any_new_result1_upvr.Claim = arg1.MouseButton1Click:Connect(function() -- Line 56
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		Util_upvr.Windows:SwitchWindow("PlayTime")
	end)
	any_new_result1_upvr.AutoUpdate = any_GetLink_result1_upvr.Changed:On("DailyPlayTime", UpdateTime)
	UpdateTime(any_GetLink_result1_upvr.DailyPlayTime)
	return any_new_result1_upvr
end
return module