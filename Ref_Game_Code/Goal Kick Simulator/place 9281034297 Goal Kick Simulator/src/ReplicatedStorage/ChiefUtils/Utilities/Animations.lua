-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:19
-- Luau version 6, Types version 3
-- Time taken: 0.002684 seconds

local module = {}
local tbl_upvr = {}
function module.GetAnimationManager(arg1, arg2) -- Line 5
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local class_Animator_upvr = arg2:FindFirstChildOfClass("Animator")
	local var4 = tbl_upvr[arg2]
	assert(class_Animator_upvr, "Animator not found")
	if not var4 then
		var4 = {
			Index = {};
			Loaded = {};
			LoadAnimation = function(arg1_2, arg2_2, arg3, arg4, ...) -- Line 13, Named "LoadAnimation"
				--[[ Upvalues[1]:
					[1]: class_Animator_upvr (readonly)
				]]
				if not arg1_2.Loaded[arg3] then
					local Animation_2 = Instance.new("Animation")
					Animation_2.AnimationId = arg3
					arg1_2.Loaded[arg3] = class_Animator_upvr:LoadAnimation(Animation_2)
				end
				if arg1_2.Loaded[arg3] then
					arg1_2.Index[arg2_2] = arg1_2.Loaded[arg3]
					if arg4 then
						arg1_2.Loaded[arg3]:Play(...)
					end
				end
			end;
			Play = function(arg1_3, arg2_3, ...) -- Line 27, Named "Play"
				local var8 = arg1_3.Index[arg2_3]
				if var8 then
					var8:Play(...)
					return true
				end
			end;
			Adjust = function(arg1_4, arg2_4, arg3, arg4, arg5) -- Line 34, Named "Adjust"
				local var9 = arg1_4.Index[arg2_4]
				if var9 then
					if not var9.IsPlaying and arg5 then
						var9:Play(0.1, arg4, arg3)
					else
						var9:AdjustSpeed(arg3)
						var9:AdjustWeight(arg4)
					end
					return true
				end
			end;
			AdjustSpeed = function(arg1_5, arg2_5, arg3, arg4) -- Line 46, Named "AdjustSpeed"
				local var10 = arg1_5.Index[arg2_5]
				if var10 then
					if not var10.IsPlaying and arg4 then
						var10:Play(0.1, 1, arg3)
					else
						var10:AdjustSpeed(arg3)
					end
					return true
				end
			end;
			AdjustWeight = function(arg1_6, arg2_6, arg3, arg4) -- Line 58, Named "AdjustWeight"
				local var11 = arg1_6.Index[arg2_6]
				if var11 then
					if not var11.IsPlaying and arg4 then
						var11:Play(0.1, 1, arg3)
					else
						var11:AdjustWeight(arg3)
					end
					return true
				end
			end;
			Stop = function(arg1_7, arg2_7, ...) -- Line 70, Named "Stop"
				local var12 = arg1_7.Index[arg2_7]
				if var12 and var12.IsPlaying then
					var12:Stop(...)
					return true
				end
			end;
		}
		tbl_upvr[arg2] = var4
	end
	return var4
end
module.EasingStyles = {
	ElasticOut = function(arg1) -- Line 86, Named "ElasticOut"
		return math.pow(2, -10 * arg1) * math.sin((arg1 * 10 - 0.75) * (-math.pi*2) / 3) + 1
	end;
}
return module