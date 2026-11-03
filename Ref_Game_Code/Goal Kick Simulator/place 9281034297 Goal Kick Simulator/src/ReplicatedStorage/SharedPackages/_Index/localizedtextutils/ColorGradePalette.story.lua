-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:38
-- Luau version 6, Types version 3
-- Time taken: 0.006209 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_6 = any_load_result1("ValueObject")
local any_load_result1_result1_upvr_3 = any_load_result1("ColorSwatch")
local any_load_result1_result1_upvr_2 = any_load_result1("ColorGradePalette")
local any_load_result1_result1_upvr_5 = any_load_result1("Blend")
local any_load_result1_result1_upvr_4 = any_load_result1("ColorPickerStoryUtils")
return function(arg1) -- Line 14
	--[[ Upvalues[6]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_6 (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
		[5]: any_load_result1_result1_upvr_5 (readonly)
		[6]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_8_upvr = any_load_result1_result1_upvr.new()
	local any_new_result1_9_upvr = any_load_result1_result1_upvr_6.new(Color3.fromRGB(245, 238, 214))
	local any_new_result1_upvr = any_load_result1_result1_upvr_3.new(any_new_result1_9_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_9_upvr)
	local any_new_result1_4_upvr = any_load_result1_result1_upvr_6.new(Color3.fromRGB(96, 58, 58))
	local any_new_result1_6_upvr = any_load_result1_result1_upvr_3.new(any_new_result1_4_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_6_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_4_upvr)
	local any_new_result1_2_upvr = any_load_result1_result1_upvr_6.new(Color3.fromRGB(85, 170, 127))
	local any_new_result1_5_upvr = any_load_result1_result1_upvr_3.new(any_new_result1_2_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_2_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_5_upvr)
	local any_new_result1_upvr_2 = any_load_result1_result1_upvr_6.new(Color3.fromRGB(47, 28, 28))
	local any_new_result1_3_upvr = any_load_result1_result1_upvr_3.new(any_new_result1_upvr_2)
	any_new_result1_8_upvr:GiveTask(any_new_result1_3_upvr)
	any_new_result1_8_upvr:GiveTask(any_new_result1_upvr_2)
	local any_new_result1 = any_load_result1_result1_upvr_2.new()
	any_new_result1:SetDefaultSurfaceName("surface")
	any_new_result1:Add("surface", 5)
	any_new_result1:Add("text", 75)
	any_new_result1:Add("border", 25)
	any_new_result1:Add("highlight", 20)
	any_new_result1:Add("action", any_new_result1_3_upvr:ObserveBaseGradeBetween(0, 30))
	any_new_result1:Add("mouseOver", -15)
	local any_new_result1_7 = any_load_result1_result1_upvr_2.new()
	any_new_result1_7:SetDefaultSurfaceName("surface")
	any_new_result1_7:Add("surface", 95, 0.1)
	any_new_result1_7:Add("text", 30, 0.5)
	any_new_result1_7:Add("border", 75, 0.1)
	any_new_result1_7:Add("highlight", 70, 1)
	any_new_result1_7:Add("action", any_new_result1_3_upvr:ObserveBaseGradeBetween(70, 100), 0.1)
	any_new_result1_7:Add("mouseOver", -15)
	local function sampleGui(arg1_2, arg2) -- Line 55
		--[[ Upvalues[6]:
			[1]: any_new_result1_8_upvr (readonly)
			[2]: any_load_result1_result1_upvr_5 (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: any_new_result1_6_upvr (readonly)
			[5]: any_new_result1_5_upvr (readonly)
			[6]: any_new_result1_3_upvr (readonly)
		]]
		local NumberValue_upvr = Instance.new("NumberValue")
		NumberValue_upvr.Value = 0
		any_new_result1_8_upvr:GiveTask(NumberValue_upvr)
		local any_Spring_result1 = any_load_result1_result1_upvr_5.Spring(NumberValue_upvr, 60)
		local module = {
			BackgroundColor3 = any_new_result1_upvr:ObserveGraded(arg2:ObserveGrade("surface"));
			Size = UDim2.new(0, 250, 0, 100);
		}
		local tbl_2 = {}
		local tbl_3 = {
			TextColor3 = any_new_result1_6_upvr:ObserveGraded(arg2:ObserveGrade("text"));
		}
		tbl_3.Text = arg1_2
		tbl_3.Font = Enum.Font.FredokaOne
		tbl_3.Size = UDim2.new(1, 0, 1, 0)
		tbl_3.BackgroundTransparency = 1
		tbl_3.TextScaled = true
		tbl_3.ZIndex = 2
		tbl_2[1] = any_load_result1_result1_upvr_5.New("TextLabel")(tbl_3)
		tbl_2[2] = any_load_result1_result1_upvr_5.New("UIPadding")({
			PaddingTop = UDim.new(0, 10);
			PaddingBottom = UDim.new(0, 10);
			PaddingLeft = UDim.new(0, 10);
			PaddingRight = UDim.new(0, 10);
		})
		tbl_2[3] = any_load_result1_result1_upvr_5.New("UIStroke")({
			Color = any_new_result1_upvr:ObserveGraded(arg2:ObserveGrade("border"));
			Thickness = 5;
		})
		tbl_2[4] = any_load_result1_result1_upvr_5.New("UICorner")({
			CornerRadius = UDim.new(0, 10);
		})
		tbl_2[5] = any_load_result1_result1_upvr_5.New("Frame")({
			Name = "Highlight";
			Size = UDim2.new(0.8, 0, 0, 20);
			Position = UDim2.fromScale(0.5, 0.75);
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundColor3 = any_new_result1_5_upvr:ObserveGraded(arg2:ObserveGrade("highlight"));
			[any_load_result1_result1_upvr_5.Children] = {any_load_result1_result1_upvr_5.New("UICorner")({
				CornerRadius = UDim.new(0, 10);
			})};
		})
		tbl_2[6] = any_load_result1_result1_upvr_5.New("Frame")({
			Name = "Button";
			Size = UDim2.new(0.5, 0, 0, 40);
			AnchorPoint = Vector2.new(1, 1);
			BackgroundColor3 = any_new_result1_3_upvr:ObserveGraded(arg2:ObserveModified("action", "mouseOver", any_Spring_result1));
			Position = UDim2.new(1, 30, 1, 40);
			ZIndex = 2;
			[any_load_result1_result1_upvr_5.OnEvent("MouseEnter")] = function() -- Line 114
				--[[ Upvalues[1]:
					[1]: NumberValue_upvr (readonly)
				]]
				NumberValue_upvr.Value = 1
			end;
			[any_load_result1_result1_upvr_5.OnEvent("MouseLeave")] = function() -- Line 118
				--[[ Upvalues[1]:
					[1]: NumberValue_upvr (readonly)
				]]
				NumberValue_upvr.Value = 0
			end;
			[any_load_result1_result1_upvr_5.Children] = {
				[any_load_result1_result1_upvr_5.Children] = {any_load_result1_result1_upvr_5.New("UIStroke")({
					Color = any_new_result1_3_upvr:ObserveGraded(arg2:ObserveModified(arg2:ObserveOn("border", "action"), "mouseOver", any_Spring_result1));
					Thickness = 5;
				})};
				
				any_load_result1_result1_upvr_5.New("UICorner")({
					CornerRadius = UDim.new(0, 10);
				}), any_load_result1_result1_upvr_5.New("TextLabel")({
					TextColor3 = any_new_result1_3_upvr:ObserveGraded(arg2:ObserveModified(arg2:ObserveOn("text", "action"), "mouseOver", any_Spring_result1));
					Text = "Action";
					TextScaled = true;
					Font = Enum.Font.FredokaOne;
					Size = UDim2.new(1, 0, 1, 0);
					BackgroundTransparency = 1;
					ZIndex = 2;
				}), any_load_result1_result1_upvr_5.New("Frame")({
					Name = "Highlight";
					Size = UDim2.new(0.9, 0, 0, 10);
					Position = UDim2.fromScale(0.5, 0.75);
					AnchorPoint = Vector2.new(0.5, 0.5);
					BackgroundColor3 = any_new_result1_5_upvr:ObserveGraded(arg2:ObserveOn("highlight", "action"));
					[any_load_result1_result1_upvr_5.Children] = {any_load_result1_result1_upvr_5.New("UICorner")({
						CornerRadius = UDim.new(0, 10);
					})};
				}), any_load_result1_result1_upvr_5.New("UIPadding")({
					PaddingTop = UDim.new(0, 5);
					PaddingBottom = UDim.new(0, 5);
					PaddingLeft = UDim.new(0, 5);
					PaddingRight = UDim.new(0, 5);
				})
			};
		})
		module[any_load_result1_result1_upvr_5.Children] = tbl_2
		return any_load_result1_result1_upvr_5.New("Frame")(module)
	end
	local tbl = {
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundColor3 = Color3.new(0, 0, 0);
		AutomaticCanvasSize = Enum.AutomaticSize.Y;
		CanvasSize = UDim2.new(1, 0, 0, 0);
	}
	tbl.Parent = arg1
	tbl[any_load_result1_result1_upvr_5.Children] = {any_load_result1_result1_upvr_4.create(any_new_result1_8_upvr, function(arg1_3) -- Line 178
		--[[ Upvalues[4]:
			[1]: any_new_result1_9_upvr (readonly)
			[2]: any_new_result1_4_upvr (readonly)
			[3]: any_new_result1_2_upvr (readonly)
			[4]: any_new_result1_upvr_2 (readonly)
		]]
		arg1_3("Surface", any_new_result1_9_upvr)
		arg1_3("Text", any_new_result1_4_upvr)
		arg1_3("Accent", any_new_result1_2_upvr)
		arg1_3("Action", any_new_result1_upvr_2)
	end), any_load_result1_result1_upvr_5.New("Frame")({
		Size = UDim2.new(1, 0, 0, 0);
		BackgroundTransparency = 1;
		AutomaticSize = Enum.AutomaticSize.Y;
		[any_load_result1_result1_upvr_5.Children] = {sampleGui("Light", any_new_result1), sampleGui("Dark", any_new_result1_7), any_load_result1_result1_upvr_5.New("UIListLayout")({
			Padding = UDim.new(0, 50);
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			VerticalAlignment = Enum.VerticalAlignment.Top;
			FillDirection = Enum.FillDirection.Vertical;
		})};
	}), any_load_result1_result1_upvr_5.New("UIListLayout")({
		Padding = UDim.new(0, 20);
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		FillDirection = Enum.FillDirection.Vertical;
	}), any_load_result1_result1_upvr_5.New("UIPadding")({
		PaddingTop = UDim.new(0, 10);
	})}
	any_new_result1_8_upvr:GiveTask(any_load_result1_result1_upvr_5.New("ScrollingFrame")(tbl):Subscribe())
	return function() -- Line 219
		--[[ Upvalues[1]:
			[1]: any_new_result1_8_upvr (readonly)
		]]
		any_new_result1_8_upvr:DoCleaning()
	end
end