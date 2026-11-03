-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:06
-- Luau version 6, Types version 3
-- Time taken: 0.006141 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_4 = any_load_result1("ColorPalette")
local any_load_result1_result1_upvr_3 = any_load_result1("Blend")
local any_load_result1_result1_upvr_2 = any_load_result1("ColorPickerStoryUtils")
return function(arg1) -- Line 14
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr_2 = any_load_result1_result1_upvr.new()
	local any_new_result1_upvr = any_load_result1_result1_upvr_4.new()
	any_new_result1_upvr:SetDefaultSurfaceName("surface")
	any_new_result1_upvr:DefineColorSwatch("surface")
	any_new_result1_upvr:DefineColorSwatch("text")
	any_new_result1_upvr:DefineColorSwatch("accent")
	any_new_result1_upvr:DefineColorSwatch("action")
	any_new_result1_upvr:DefineColorGrade("surface")
	any_new_result1_upvr:DefineColorGrade("text")
	any_new_result1_upvr:DefineColorGrade("border")
	any_new_result1_upvr:DefineColorGrade("highlight")
	any_new_result1_upvr:DefineColorGrade("action")
	any_new_result1_upvr:DefineColorGrade("mouseOver")
	any_new_result1_upvr_2:GiveTask(any_new_result1_upvr)
	local function _() -- Line 31, Named "light"
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:SetColor("surface", Color3.fromRGB(245, 238, 214))
		any_new_result1_upvr:SetColor("text", Color3.fromRGB(96, 58, 58))
		any_new_result1_upvr:SetColor("accent", Color3.fromRGB(85, 170, 127))
		any_new_result1_upvr:SetColor("action", Color3.fromRGB(47, 28, 28))
		any_new_result1_upvr:SetColorGrade("surface", 5)
		any_new_result1_upvr:SetColorGrade("text", 75)
		any_new_result1_upvr:SetColorGrade("border", 25)
		any_new_result1_upvr:SetColorGrade("highlight", 20)
		any_new_result1_upvr:SetColorGrade("action", any_new_result1_upvr:ObserveColorBaseGradeBetween("action", 0, 30))
		any_new_result1_upvr:SetColorGrade("mouseOver", -15)
	end
	;(function() -- Line 44, Named "dark"
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:SetColor("surface", Color3.fromRGB(245, 238, 214))
		any_new_result1_upvr:SetColor("text", Color3.fromRGB(96, 58, 58))
		any_new_result1_upvr:SetColor("accent", Color3.fromRGB(85, 170, 127))
		any_new_result1_upvr:SetColor("action", Color3.fromRGB(47, 28, 28))
		any_new_result1_upvr:SetColorGrade("surface", 95, 0.1)
		any_new_result1_upvr:SetColorGrade("text", 30, 0.5)
		any_new_result1_upvr:SetColorGrade("border", 75, 0.1)
		any_new_result1_upvr:SetColorGrade("highlight", 70, 1)
		any_new_result1_upvr:SetColorGrade("action", any_new_result1_upvr:ObserveColorBaseGradeBetween("action", 70, 100), 0.1)
		any_new_result1_upvr:SetColorGrade("mouseOver", -15)
	end)()
	local tbl_3 = {
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundColor3 = Color3.new(0, 0, 0);
		AutomaticCanvasSize = Enum.AutomaticSize.Y;
		CanvasSize = UDim2.new(1, 0, 0, 0);
	}
	tbl_3.Parent = arg1
	tbl_3[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_2.create(any_new_result1_upvr_2, function(arg1_3) -- Line 193
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		arg1_3("Surface", any_new_result1_upvr:GetColorValue("surface"))
		arg1_3("Text", any_new_result1_upvr:GetColorValue("text"))
		arg1_3("Accent", any_new_result1_upvr:GetColorValue("accent"))
		arg1_3("Action", any_new_result1_upvr:GetColorValue("action"))
	end), any_load_result1_result1_upvr_3.New("Frame")({
		Size = UDim2.new(1, 0, 0, 0);
		BackgroundTransparency = 1;
		AutomaticSize = Enum.AutomaticSize.Y;
		[any_load_result1_result1_upvr_3.Children] = {(function(arg1_2) -- Line 63, Named "sampleGui"
			--[[ Upvalues[3]:
				[1]: any_new_result1_upvr_2 (readonly)
				[2]: any_load_result1_result1_upvr_3 (copied, readonly)
				[3]: any_new_result1_upvr (readonly)
			]]
			local NumberValue_upvr = Instance.new("NumberValue")
			NumberValue_upvr.Value = 0
			any_new_result1_upvr_2:GiveTask(NumberValue_upvr)
			local any_Spring_result1 = any_load_result1_result1_upvr_3.Spring(NumberValue_upvr, 60)
			local module = {
				BackgroundColor3 = any_new_result1_upvr:ObserveColor("surface");
				Size = UDim2.new(0, 250, 0, 100);
			}
			local tbl = {}
			local tbl_2 = {
				TextColor3 = any_new_result1_upvr:ObserveColor("text");
			}
			tbl_2.Text = arg1_2
			tbl_2.Font = Enum.Font.FredokaOne
			tbl_2.Size = UDim2.new(1, 0, 1, 0)
			tbl_2.BackgroundTransparency = 1
			tbl_2.TextScaled = true
			tbl_2.ZIndex = 2
			tbl[1] = any_load_result1_result1_upvr_3.New("TextLabel")(tbl_2)
			tbl[2] = any_load_result1_result1_upvr_3.New("UIPadding")({
				PaddingTop = UDim.new(0, 10);
				PaddingBottom = UDim.new(0, 10);
				PaddingLeft = UDim.new(0, 10);
				PaddingRight = UDim.new(0, 10);
			})
			tbl[3] = any_load_result1_result1_upvr_3.New("UIStroke")({
				Color = any_new_result1_upvr:ObserveColor("surface", "border");
				Thickness = 5;
			})
			tbl[4] = any_load_result1_result1_upvr_3.New("UICorner")({
				CornerRadius = UDim.new(0, 10);
			})
			tbl[5] = any_load_result1_result1_upvr_3.New("Frame")({
				Name = "Highlight";
				Size = UDim2.new(0.8, 0, 0, 20);
				Position = UDim2.fromScale(0.5, 0.75);
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = any_new_result1_upvr:ObserveColor("accent", "highlight");
				[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UICorner")({
					CornerRadius = UDim.new(0, 10);
				})};
			})
			tbl[6] = any_load_result1_result1_upvr_3.New("Frame")({
				Name = "Button";
				Size = UDim2.new(0.5, 0, 0, 40);
				AnchorPoint = Vector2.new(1, 1);
				BackgroundColor3 = any_new_result1_upvr:GetSwatch("action"):ObserveGraded(any_new_result1_upvr:ObserveModifiedGrade("action", "mouseOver", any_Spring_result1));
				Position = UDim2.new(1, 30, 1, 40);
				ZIndex = 2;
				[any_load_result1_result1_upvr_3.OnEvent("MouseEnter")] = function() -- Line 123
					--[[ Upvalues[1]:
						[1]: NumberValue_upvr (readonly)
					]]
					NumberValue_upvr.Value = 1
				end;
				[any_load_result1_result1_upvr_3.OnEvent("MouseLeave")] = function() -- Line 127
					--[[ Upvalues[1]:
						[1]: NumberValue_upvr (readonly)
					]]
					NumberValue_upvr.Value = 0
				end;
				[any_load_result1_result1_upvr_3.Children] = {
					[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UIStroke")({
						Color = any_new_result1_upvr:ObserveColor("action", any_new_result1_upvr:ObserveModifiedGrade(any_new_result1_upvr:ObserveGradeOn("border", "action"), "mouseOver", any_Spring_result1));
						Thickness = 5;
					})};
					
					any_load_result1_result1_upvr_3.New("UICorner")({
						CornerRadius = UDim.new(0, 10);
					}), any_load_result1_result1_upvr_3.New("TextLabel")({
						TextColor3 = any_new_result1_upvr:ObserveColor("action", any_new_result1_upvr:ObserveModifiedGrade(any_new_result1_upvr:ObserveGradeOn("text", "action"), "mouseOver", any_Spring_result1));
						Text = "Action";
						TextScaled = true;
						Font = Enum.Font.FredokaOne;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						ZIndex = 2;
					}), any_load_result1_result1_upvr_3.New("Frame")({
						Name = "Highlight";
						Size = UDim2.new(0.9, 0, 0, 10);
						Position = UDim2.fromScale(0.5, 0.75);
						AnchorPoint = Vector2.new(0.5, 0.5);
						BackgroundColor3 = any_new_result1_upvr:ObserveColor("accent", any_new_result1_upvr:ObserveGradeOn("highlight", "action"));
						[any_load_result1_result1_upvr_3.Children] = {any_load_result1_result1_upvr_3.New("UICorner")({
							CornerRadius = UDim.new(0, 10);
						})};
					}), any_load_result1_result1_upvr_3.New("UIPadding")({
						PaddingTop = UDim.new(0, 5);
						PaddingBottom = UDim.new(0, 5);
						PaddingLeft = UDim.new(0, 5);
						PaddingRight = UDim.new(0, 5);
					})
				};
			})
			module[any_load_result1_result1_upvr_3.Children] = tbl
			return any_load_result1_result1_upvr_3.New("Frame")(module)
		end)("Light"), any_load_result1_result1_upvr_3.New("UIListLayout")({
			Padding = UDim.new(0, 50);
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			VerticalAlignment = Enum.VerticalAlignment.Top;
			FillDirection = Enum.FillDirection.Vertical;
		})};
	}), any_load_result1_result1_upvr_3.New("UIListLayout")({
		Padding = UDim.new(0, 20);
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		FillDirection = Enum.FillDirection.Vertical;
	}), any_load_result1_result1_upvr_3.New("UIPadding")({
		PaddingTop = UDim.new(0, 10);
	})}
	any_new_result1_upvr_2:GiveTask(any_load_result1_result1_upvr_3.New("ScrollingFrame")(tbl_3):Subscribe())
	return function() -- Line 232
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
	end
end