-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:42
-- Luau version 6, Types version 3
-- Time taken: 0.004275 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local function SetLoading(arg1, arg2, arg3) -- Line 9
end
module_upvr.SetLoading = SetLoading
local function DisableLoading(arg1) -- Line 12
end
module_upvr.DisableLoading = DisableLoading
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.Binder(arg1) -- Line 17
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local Circle_upvr = arg1.Circle
	local function setCirclePosition_upvr(arg1_2) -- Line 24, Named "setCirclePosition"
		--[[ Upvalues[1]:
			[1]: Circle_upvr (readonly)
		]]
		if arg1_2 then
			local clamped = math.clamp(math.ceil(math.clamp((1 - math.abs(arg1_2 - 0.5)) / 1.1, 0, 1) * 64), 0, 63)
			Circle_upvr.ImageRectOffset = Vector2.new(clamped % 8 * 75, math.floor(clamped / 8) * 75)
			Circle_upvr.Rotation = arg1_2 * 1080
		end
	end
	if arg1.Enabled then
		local var13_upvw = 0
		any_new_result1_upvr.Animation = Util_upvr.Thread.Loop(function(arg1_4) -- Line 35
			--[[ Upvalues[2]:
				[1]: var13_upvw (read and write)
				[2]: setCirclePosition_upvr (readonly)
			]]
			var13_upvw += arg1_4
			setCirclePosition_upvr(var13_upvw % 2 / 2)
		end)
	else
		any_new_result1_upvr.Animation = nil
	end
	any_new_result1_upvr.EnabledChanged = arg1:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line 32, Named "UpdateShown"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: setCirclePosition_upvr (readonly)
		]]
		if arg1.Enabled then
			local var11_upvw = 0
			any_new_result1_upvr.Animation = Util_upvr.Thread.Loop(function(arg1_3) -- Line 35
				--[[ Upvalues[2]:
					[1]: var11_upvw (read and write)
					[2]: setCirclePosition_upvr (copied, readonly)
				]]
				var11_upvw += arg1_3
				setCirclePosition_upvr(var11_upvw % 2 / 2)
			end)
		else
			any_new_result1_upvr.Animation = nil
		end
	end)
	local any_Create_result1_upvr = TweenService_upvr:Create(arg1.Frame.Center, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 0);
	})
	function module_upvr.SetLoading(arg1_5, arg2, arg3, arg4) -- Line 46
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_Create_result1_upvr (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		local var19 = arg4
		if not var19 then
			var19 = Color3.new()
		end
		local var20 = var19
		local var21 = arg3 or 0.15
		arg1.Frame.Center.Visible = true
		arg1.Title.Text = arg2 or "Please wait..."
		arg1.Frame.Center.ImageTransparency = var21
		arg1.Frame.Center.ImageColor3 = var20
		for _, v in pairs(arg1.Frame.Center:GetChildren()) do
			if v:IsA("Frame") then
				v.BackgroundColor3 = var20
				v.BackgroundTransparency = var21
			end
		end
		arg1.Enabled = true
		any_Create_result1_upvr:Play()
		any_new_result1_upvr.DelayDisable = Util_upvr.Thread.Delay(0.35, function() -- Line 64
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.Title.Visible = true
			arg1.Circle.Visible = true
		end)
	end
	local any_Create_result1_upvr_2 = TweenService_upvr:Create(arg1.Frame.Center, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(3, 0, 3, 0);
	})
	function module_upvr.DisableLoading(arg1_6) -- Line 70
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_Create_result1_upvr_2 (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		arg1.Circle.Visible = false
		arg1.Title.Visible = false
		arg1.Frame.BackgroundTransparency = 1
		any_Create_result1_upvr_2:Play()
		any_new_result1_upvr.DelayDisable = Util_upvr.Thread.Delay(0.35, function() -- Line 76
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.Enabled = false
		end)
	end
	return any_new_result1_upvr
end
Util_upvr.Loader = module_upvr
return module_upvr