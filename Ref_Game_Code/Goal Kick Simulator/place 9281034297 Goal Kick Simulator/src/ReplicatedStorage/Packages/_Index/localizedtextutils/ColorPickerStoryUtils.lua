-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:09
-- Luau version 6, Types version 3
-- Time taken: 0.006508 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Blend")
local module_upvr = {}
local var1_result1_upvr = any_load_result1("HSVColorPicker")
function module_upvr.createPicker(arg1, arg2, arg3, arg4) -- Line 13
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr.new()
	any_new_result1_upvr_2.Gui.AnchorPoint = Vector2.new(0.5, 1)
	any_new_result1_upvr_2.Gui.Position = UDim2.new(0.5, 0, 1, 0)
	any_new_result1_upvr_2.Gui.Size = UDim2.new(0, 150, 1, -30)
	any_new_result1_upvr_2.Gui.ZIndex = 2
	arg1:GiveTask(any_new_result1_upvr_2)
	arg1:GiveTask(any_new_result1_upvr_2:SyncValue(arg2))
	local BoolValue_upvr = Instance.new("BoolValue")
	BoolValue_upvr.Value = false
	arg1:GiveTask(BoolValue_upvr)
	arg1:GiveTask(BoolValue_upvr.Changed:Connect(function() -- Line 27
		--[[ Upvalues[3]:
			[1]: BoolValue_upvr (readonly)
			[2]: arg4 (readonly)
			[3]: any_new_result1_upvr_2 (readonly)
		]]
		if BoolValue_upvr.Value then
			arg4.Value = any_new_result1_upvr_2
		end
	end))
	arg1:GiveTask(arg4.Changed:Connect(function(arg1_2, arg2_2) -- Line 33
		--[[ Upvalues[2]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: BoolValue_upvr (readonly)
		]]
		if arg2_2 == any_new_result1_upvr_2 then
			BoolValue_upvr.Value = false
		end
	end))
	local module = {
		BackgroundTransparency = 0;
		AutoButtonColor = true;
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2);
		Size = var1_result1_upvr_2.Spring(var1_result1_upvr_2.Computed(BoolValue_upvr, function(arg1_3) -- Line 43
			if arg1_3 then
				return UDim2.new(0, 170, 0, 190)
			end
			return UDim2.new(0, 170, 0, 50)
		end), 40);
		ClipsDescendants = false;
		[var1_result1_upvr_2.OnEvent("Activated")] = function() -- Line 51
			--[[ Upvalues[1]:
				[1]: BoolValue_upvr (readonly)
			]]
			BoolValue_upvr.Value = not BoolValue_upvr.Value
		end;
	}
	local tbl_2 = {}
	local tbl_4 = {
		BackgroundTransparency = 1;
	}
	tbl_4.Text = arg3
	tbl_4.Position = UDim2.new(0, 35, 0, 5)
	tbl_4.Size = UDim2.new(1, -40, 0, 20)
	tbl_4.Font = Enum.Font.FredokaOne
	tbl_4.TextXAlignment = Enum.TextXAlignment.Left
	tbl_4.TextScaled = true
	tbl_4.TextColor3 = Color3.new(1, 1, 1)
	tbl_4.ZIndex = 0
	local tbl = {}
	tbl.BackgroundColor3 = arg2
	tbl.Size = UDim2.new(0, 20, 0, 20)
	tbl.Position = UDim2.new(0, 5, 0, 5)
	tbl[var1_result1_upvr_2.Children] = {var1_result1_upvr_2.New("UICorner")({
		CornerRadius = UDim.new(0, 10);
	})}
	tbl_2[1] = any_new_result1_upvr_2.Gui
	tbl_2[2] = var1_result1_upvr_2.New("TextLabel")(tbl_4)
	tbl_2[3] = var1_result1_upvr_2.New("Frame")(tbl)
	tbl_2[4] = var1_result1_upvr_2.New("UIPadding")({
		PaddingTop = UDim.new(0, 10);
		PaddingBottom = UDim.new(0, 10);
		PaddingLeft = UDim.new(0, 10);
		PaddingRight = UDim.new(0, 10);
	})
	tbl_2[5] = var1_result1_upvr_2.New("UICorner")({
		CornerRadius = UDim.new(0, 10);
	})
	module[var1_result1_upvr_2.Children] = tbl_2
	return var1_result1_upvr_2.New("ImageButton")(module)
end
local var1_result1_upvr_3 = any_load_result1("ValueObject")
function module_upvr.create(arg1, arg2) -- Line 94
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	arg1:GiveTask(any_new_result1_upvr)
	local tbl_3_upvr = {}
	arg2(function(arg1_4, arg2_3) -- Line 100
		--[[ Upvalues[4]:
			[1]: tbl_3_upvr (readonly)
			[2]: module_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_new_result1_upvr (readonly)
		]]
		table.insert(tbl_3_upvr, module_upvr.createPicker(arg1, arg2_3, arg1_4, any_new_result1_upvr))
	end)
	local tbl_5 = {}
	local var29
	for i = 1, #tbl_3_upvr do
		table.insert(var29, tbl_3_upvr[i])
		if 4 <= #var29 then
			table.insert(tbl_5, (function(arg1_5) -- Line 104, Named "pickerGroup"
				--[[ Upvalues[1]:
					[1]: var1_result1_upvr_2 (copied, readonly)
				]]
				local module_2 = {
					Size = UDim2.new(1, 0, 0, 0);
					AnchorPoint = Vector2.new(0.5, 0.5);
					Position = UDim2.fromScale(0.5, 0.5);
					BackgroundTransparency = 1;
					AutomaticSize = Enum.AutomaticSize.Y;
				}
				local tbl_6 = {var1_result1_upvr_2.New("UIListLayout")({
					Padding = UDim.new(0, 10);
					HorizontalAlignment = Enum.HorizontalAlignment.Left;
					VerticalAlignment = Enum.VerticalAlignment.Top;
					FillDirection = Enum.FillDirection.Horizontal;
				})}
				tbl_6[2] = arg1_5
				module_2[var1_result1_upvr_2.Children] = tbl_6
				return var1_result1_upvr_2.New("Frame")(module_2)
			end)(var29))
			var29 = {}
		end
	end
	if 0 < #var29 then
		i = (function(arg1_5) -- Line 104, Named "pickerGroup"
			--[[ Upvalues[1]:
				[1]: var1_result1_upvr_2 (copied, readonly)
			]]
			local module_2 = {
				Size = UDim2.new(1, 0, 0, 0);
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				BackgroundTransparency = 1;
				AutomaticSize = Enum.AutomaticSize.Y;
			}
			local tbl_6 = {var1_result1_upvr_2.New("UIListLayout")({
				Padding = UDim.new(0, 10);
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				VerticalAlignment = Enum.VerticalAlignment.Top;
				FillDirection = Enum.FillDirection.Horizontal;
			})}
			tbl_6[2] = arg1_5
			module_2[var1_result1_upvr_2.Children] = tbl_6
			return var1_result1_upvr_2.New("Frame")(module_2)
		end)(var29)
		table.insert(tbl_5, i)
	end
	return var1_result1_upvr_2.New("Frame")({
		Size = UDim2.new(0, 0, 0, 0);
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = UDim2.fromScale(0.5, 0.5);
		BackgroundTransparency = 1;
		AutomaticSize = Enum.AutomaticSize.XY;
		[var1_result1_upvr_2.OnEvent("InputBegan")] = function(arg1_6, arg2_4) -- Line 145
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			if arg2_4 then
			elseif arg1_6.UserInputType == Enum.UserInputType.MouseButton1 then
				any_new_result1_upvr.Value = nil
			end
		end;
		[var1_result1_upvr_2.Children] = {var1_result1_upvr_2.New("UIListLayout")({
			Padding = UDim.new(0, 10);
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			VerticalAlignment = Enum.VerticalAlignment.Top;
			FillDirection = Enum.FillDirection.Vertical;
		}), tbl_5};
	})
end
return module_upvr