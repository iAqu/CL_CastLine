-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:33
-- Luau version 6, Types version 3
-- Time taken: 0.004686 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local TweenService_upvr = game:GetService("TweenService")
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_Create_result1_upvr_2 = TweenService_upvr:Create(arg1, TweenInfo.new(0.1), {
		Size = UDim2.new(arg1.Size.X.Scale, arg1.Size.X.Offset + 2, arg1.Size.Y.Scale, arg1.Size.Y.Offset + 2);
		Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale, arg1.Position.Y.Offset - 1);
	})
	local any_Create_result1_upvr_3 = TweenService_upvr:Create(arg1, TweenInfo.new(0.1), {
		Size = UDim2.new(arg1.Size.X.Scale, arg1.Size.X.Offset - 2, arg1.Size.Y.Scale, arg1.Size.Y.Offset - 2);
		Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale, arg1.Position.Y.Offset + 1);
	})
	any_new_result1_upvr:GiveTask(arg1.MouseButton1Down:Connect(function() -- Line 15
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: any_Create_result1_upvr_3 (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		function any_new_result1_upvr.MouseUp() -- Line 16
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1:SetAttribute("UI_ButtonSelected")
		end
		any_Create_result1_upvr_3:Play()
		Util_upvr.Sounds:Play("btndown")
		arg1:SetAttribute("UI_ButtonSelected", true)
	end))
	any_new_result1_upvr:GiveTask(arg1.MouseButton1Up:Connect(function() -- Line 23
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: any_Create_result1_upvr_2 (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if any_new_result1_upvr.MouseUp then
			any_new_result1_upvr.MouseUp = nil
			any_Create_result1_upvr_2:Play()
			Util_upvr.Sounds:Play("btnup")
		end
	end))
	local any_Create_result1_upvr = TweenService_upvr:Create(arg1, TweenInfo.new(0.1), {
		Size = UDim2.new(arg1.Size.X.Scale, arg1.Size.X.Offset, arg1.Size.Y.Scale, arg1.Size.Y.Offset);
		Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale, arg1.Position.Y.Offset);
	})
	any_new_result1_upvr:GiveTask(arg1.MouseEnter:Connect(function() -- Line 30
		--[[ Upvalues[3]:
			[1]: any_Create_result1_upvr_2 (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: any_Create_result1_upvr (readonly)
		]]
		any_Create_result1_upvr_2:Play()
		function any_new_result1_upvr.MouseLeave() -- Line 32
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr (copied, readonly)
			]]
			any_Create_result1_upvr:Play()
		end
	end))
	any_new_result1_upvr:GiveTask(arg1.MouseLeave:Connect(function() -- Line 36
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.MouseUp = nil
		any_new_result1_upvr.MouseLeave = nil
	end))
	local var18_upvr
	if arg1:IsA("ImageButton") then
		var18_upvr = "ImageColor3"
	else
		var18_upvr = "BackgroundColor3"
	end
	local var19_upvr = arg1[var18_upvr]
	local function checkButtonSelected() -- Line 44
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: var19_upvr (readonly)
			[4]: var18_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [6] 6. Error Block 13 start (CF ANALYSIS FAILED)
		local UI_ButtonColor = arg1:GetAttribute("UI_ButtonColor")
		if not UI_ButtonColor then
			UI_ButtonColor = var19_upvr
		end
		local any_AdjustColor_result1 = Util_upvr.ValueConvertor:AdjustColor(UI_ButtonColor, 0.9)
		if not any_AdjustColor_result1 then
			-- KONSTANTERROR: [21] 18. Error Block 10 start (CF ANALYSIS FAILED)
			any_AdjustColor_result1 = arg1:GetAttribute("UI_ButtonColor")
			if not any_AdjustColor_result1 then
				any_AdjustColor_result1 = var19_upvr
			end
			-- KONSTANTERROR: [21] 18. Error Block 10 end (CF ANALYSIS FAILED)
		end
		arg1[var18_upvr] = any_AdjustColor_result1
		-- KONSTANTERROR: [6] 6. Error Block 13 end (CF ANALYSIS FAILED)
	end
	if not arg1:GetAttribute("UI_ButtonSelected") or not Util_upvr.ValueConvertor:AdjustColor(arg1:GetAttribute("UI_ButtonColor") or var19_upvr, 0.9) then
		if not arg1:GetAttribute("UI_ButtonColor") then
		end
	end
	arg1[var18_upvr] = var19_upvr
	any_new_result1_upvr:GiveTask(function() -- Line 50
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var18_upvr (readonly)
			[3]: var19_upvr (readonly)
		]]
		arg1[var18_upvr] = var19_upvr
	end)
	any_new_result1_upvr:GiveTask(arg1:GetAttributeChangedSignal("UI_ButtonSelected"):Connect(checkButtonSelected))
	any_new_result1_upvr:GiveTask(arg1:GetAttributeChangedSignal("UI_ButtonColor"):Connect(checkButtonSelected))
	return any_new_result1_upvr
end
return module