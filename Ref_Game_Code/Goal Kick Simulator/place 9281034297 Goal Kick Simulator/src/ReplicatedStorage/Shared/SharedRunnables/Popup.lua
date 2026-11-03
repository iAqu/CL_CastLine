-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:09
-- Luau version 6, Types version 3
-- Time taken: 0.001918 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {
	PopupNumber = function(arg1, arg2) -- Line 4, Named "PopupNumber"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local var3_upvr = arg2.StartingValue or 0
		local var4 = arg2.Duration or 0.35
		local var5_upvr = arg2.StudsOffsetWorldSpace or Vector3.new(0, 0, 0)
		local any_GetAsset_result1_upvr = Util_upvr.Assets:GetAsset("Popup")
		any_GetAsset_result1_upvr.Title.Text = var3_upvr
		local Icon = arg2.Icon
		if not Icon then
			Icon = any_GetAsset_result1_upvr.Icon.Image
		end
		any_GetAsset_result1_upvr.Icon.Image = Icon
		any_GetAsset_result1_upvr.StudsOffsetWorldSpace = var5_upvr
		local Gradient = arg2.Gradient
		if Gradient then
			Gradient = Util_upvr.Assets:GetAsset("Colors", arg2.Gradient)
		end
		if Gradient then
			Gradient.Parent = any_GetAsset_result1_upvr.Title
		end
		local var10_upvr = arg2.FinalValue or 10
		Util_upvr.Thread.LoopFor(var4, function(arg1_2) -- Line 23
			--[[ Upvalues[4]:
				[1]: any_GetAsset_result1_upvr (readonly)
				[2]: var10_upvr (readonly)
				[3]: var3_upvr (readonly)
				[4]: Util_upvr (copied, readonly)
			]]
			if not any_GetAsset_result1_upvr.Parent then
			else
				any_GetAsset_result1_upvr.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(math.ceil((var10_upvr - var3_upvr) * arg1_2 - 0.5)))
			end
		end)
		local var12_upvr = arg2.AnimationHeight or 1
		Util_upvr.Thread.LoopFor(var4 + 0.3, function(arg1_3) -- Line 28
			--[[ Upvalues[3]:
				[1]: any_GetAsset_result1_upvr (readonly)
				[2]: var5_upvr (readonly)
				[3]: var12_upvr (readonly)
			]]
			any_GetAsset_result1_upvr.StudsOffsetWorldSpace = var5_upvr + Vector3.new(0, math.sin(arg1_3 * math.pi) * var12_upvr, 0)
		end)
		task.delay(var4 + 1.3, function() -- Line 31
			--[[ Upvalues[1]:
				[1]: any_GetAsset_result1_upvr (readonly)
			]]
			any_GetAsset_result1_upvr:Destroy()
		end)
		local Parent = arg2.Parent
		if not Parent then
			Parent = workspace
		end
		any_GetAsset_result1_upvr.Parent = Parent
	end;
}
Util_upvr.Popup = module
return module