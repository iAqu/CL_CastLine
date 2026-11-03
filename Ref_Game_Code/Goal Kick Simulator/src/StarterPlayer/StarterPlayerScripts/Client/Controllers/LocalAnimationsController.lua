-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:47
-- Luau version 6, Types version 3
-- Time taken: 0.002832 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local function NotLoaded() -- Line 5
	warn("Animations not loaded for client!")
end
module_upvr.LoadAnimation = NotLoaded
module_upvr.PlayAnimation = NotLoaded
module_upvr.Adjust = NotLoaded
module_upvr.AdjustSpeed = NotLoaded
module_upvr.AdjustWeight = NotLoaded
module_upvr.StopAnimation = NotLoaded
function module_upvr.Start(arg1) -- Line 15
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(function(arg1_2) -- Line 16
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		local var5_upvr = arg1_2:WaitForChild("Humanoid", 30)
		if var5_upvr then
			var5_upvr = arg1_2:WaitForChild("Humanoid", 30):WaitForChild("Animator", 30)
		end
		if not var5_upvr then
			warn("[Animations] No animator found!")
		else
			module_upvr.Index = {}
			module_upvr.Loaded = {}
			function module_upvr.Preload(arg1_3, arg2, arg3, ...) -- Line 22
				--[[ Upvalues[1]:
					[1]: var5_upvr (readonly)
				]]
				if not arg1_3.Loaded[arg3] then
					local Animation = Instance.new("Animation")
					Animation.AnimationId = arg3
					arg1_3.Loaded[arg3] = var5_upvr:LoadAnimation(Animation)
				end
				if arg1_3.Loaded[arg3] then
					arg1_3.Index[arg2] = arg1_3.Loaded[arg3]
				end
				return arg1_3.Index[arg2]
			end
			function module_upvr.PlayAnimation(arg1_4, arg2, arg3, ...) -- Line 34
				--[[ Upvalues[1]:
					[1]: var5_upvr (readonly)
				]]
				if not arg1_4.Loaded[arg3] then
					local Animation_2 = Instance.new("Animation")
					Animation_2.AnimationId = arg3
					arg1_4.Loaded[arg3] = var5_upvr:LoadAnimation(Animation_2)
				end
				if arg1_4.Loaded[arg3] then
					arg1_4.Index[arg2] = arg1_4.Loaded[arg3]
					arg1_4.Loaded[arg3]:Play(...)
					return arg1_4.Loaded[arg3]
				end
			end
			function module_upvr.StopAnimation(arg1_5, arg2, ...) -- Line 47
				local var8 = arg1_5.Index[arg2]
				if var8 and var8.IsPlaying then
					var8:Stop(...)
					return true
				end
			end
			function module_upvr.StopAnimationWithID(arg1_6, arg2, ...) -- Line 56
				local var9 = arg1_6.Loaded[arg2]
				if var9 and var9.IsPlaying then
					var9:Stop(...)
					return true
				end
			end
			function module_upvr.Adjust(arg1_7, arg2, arg3, arg4, arg5) -- Line 66
				local var10 = arg1_7.Index[arg2]
				if var10 then
					if not var10.IsPlaying and arg5 then
						var10:Play(0.1, arg4, arg3)
					else
						var10:AdjustSpeed(arg3)
						var10:AdjustWeight(arg4)
					end
					return true
				end
			end
			function module_upvr.AdjustSpeed(arg1_8, arg2, arg3, arg4) -- Line 78
				local var11 = arg1_8.Index[arg2]
				if var11 then
					if not var11.IsPlaying and arg4 then
						var11:Play(0.1, 1, arg3)
					else
						var11:AdjustSpeed(arg3)
					end
					return true
				end
			end
			function module_upvr.AdjustWeight(arg1_9, arg2, arg3, arg4) -- Line 90
				local var12 = arg1_9.Index[arg2]
				if var12 then
					if not var12.IsPlaying and arg4 then
						var12:Play(0.1, 1, arg3)
					else
						var12:AdjustWeight(arg3)
					end
					return true
				end
			end
		end
	end)
end
Util_upvr.Animations = module_upvr
return module_upvr