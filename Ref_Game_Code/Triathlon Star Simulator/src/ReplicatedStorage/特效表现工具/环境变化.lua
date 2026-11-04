-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:15
-- Luau version 6, Types version 3
-- Time taken: 0.001385 seconds

local module = {
	ChangeSky = function() -- Line 11, Named "ChangeSky"
	end;
}
local tbl_upvr = {
	["豹子-反色"] = {
		ChangeTime = 0.1;
		LastTime = 0.2;
		BackTime = 0.1;
		Brightness = 0;
		Contrast = -2;
		Saturation = -1;
		TintColor = Color3.new(1, 1, 1);
		EasingStyle = Enum.EasingStyle.Quart;
		EasingDirection = Enum.EasingDirection.Out;
		BackEasingStyle = Enum.EasingStyle.Quart;
		BackEasingDirection = Enum.EasingDirection.Out;
	};
}
local Lighting_upvr = game:GetService("Lighting")
local TweenService_upvr = game:GetService("TweenService")
local Debris_upvr = game:GetService("Debris")
function module.ChangeColorCorrection(arg1) -- Line 46
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: Lighting_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	local var7_upvr = tbl_upvr[arg1]
	local ColorCorrectionEffect_upvr = Instance.new("ColorCorrectionEffect", Lighting_upvr)
	local any_Create_result1_upvw = TweenService_upvr:Create(ColorCorrectionEffect_upvr, TweenInfo.new(var7_upvr.ChangeTime, var7_upvr.EasingStyle, var7_upvr.EasingDirection), {
		Brightness = var7_upvr.Brightness;
		Contrast = var7_upvr.Contrast;
		Saturation = var7_upvr.Saturation;
		TintColor = var7_upvr.TintColor;
	})
	any_Create_result1_upvw.Completed:Connect(function() -- Line 61
		--[[ Upvalues[5]:
			[1]: any_Create_result1_upvw (read and write)
			[2]: var7_upvr (readonly)
			[3]: ColorCorrectionEffect_upvr (readonly)
			[4]: TweenService_upvr (copied, readonly)
			[5]: Debris_upvr (copied, readonly)
		]]
		any_Create_result1_upvw:Pause()
		any_Create_result1_upvw:Destroy()
		any_Create_result1_upvw = nil
		task.delay(var7_upvr.LastTime, function() -- Line 66
			--[[ Upvalues[4]:
				[1]: ColorCorrectionEffect_upvr (copied, readonly)
				[2]: TweenService_upvr (copied, readonly)
				[3]: var7_upvr (copied, readonly)
				[4]: Debris_upvr (copied, readonly)
			]]
			if ColorCorrectionEffect_upvr then
				local any_Create_result1_upvw_2 = TweenService_upvr:Create(ColorCorrectionEffect_upvr, TweenInfo.new(var7_upvr.ChangeTime, var7_upvr.BackEasingStyle, var7_upvr.BackEasingDirection), {
					Brightness = 0;
					Contrast = 0;
					Saturation = 0;
					TintColor = Color3.new(1, 1, 1);
				})
				any_Create_result1_upvw_2.Completed:Connect(function() -- Line 79
					--[[ Upvalues[3]:
						[1]: any_Create_result1_upvw_2 (read and write)
						[2]: Debris_upvr (copied, readonly)
						[3]: ColorCorrectionEffect_upvr (copied, readonly)
					]]
					any_Create_result1_upvw_2:Pause()
					any_Create_result1_upvw_2:Destroy()
					any_Create_result1_upvw_2 = nil
					Debris_upvr:AddItem(ColorCorrectionEffect_upvr, 0)
				end)
				any_Create_result1_upvw_2:Play()
			end
		end)
	end)
	any_Create_result1_upvw:Play()
end
return module