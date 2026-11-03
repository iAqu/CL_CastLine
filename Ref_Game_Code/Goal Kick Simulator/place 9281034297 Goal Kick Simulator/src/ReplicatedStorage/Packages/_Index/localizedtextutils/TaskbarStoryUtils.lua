-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:15
-- Luau version 6, Types version 3
-- Time taken: 0.002256 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("Blend")
local module_2_upvr = {}
function module_2_upvr.toggleVisible(arg1, arg2) -- Line 13
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.button(arg1, {
		Text = "Toggle";
		OnActivated = function() -- Line 16, Named "OnActivated"
			--[[ Upvalues[1]:
				[1]: arg2 (readonly)
			]]
			if arg2.Value == 0 then
				arg2.Value = 1
			else
				arg2.Value = 0
			end
		end;
	})
end
local var1_result1_upvr_2 = any_load_result1("GuiThemeService")
local var1_result1_upvr_3 = any_load_result1("TextServiceUtils")
function module_2_upvr.button(arg1, arg2) -- Line 26
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local service = arg1:GetService(var1_result1_upvr_2)
	return var1_result1_upvr.New("TextButton")({
		Text = arg2.Text;
		AutomaticSize = Enum.AutomaticSize.X;
		Size = var1_result1_upvr.Computed(var1_result1_upvr_3.observeSizeForLabelProps({
			Font = service:ObserveFont("font");
			TextSize = 20;
			Text = arg2.Text;
		}), function(arg1_2) -- Line 38
			return UDim2.new(0, arg1_2.x + 20, 1, 0)
		end);
		Font = service:ObserveFont("action");
		BackgroundColor3 = service:ObserveColor("action");
		TextColor3 = service:ObserveColor("text", service:ObserveGradeOn("text", "action"));
		AutoButtonColor = true;
		TextSize = 20;
		[var1_result1_upvr.OnEvent("Activated")] = arg2.OnActivated;
		[var1_result1_upvr.Children] = {var1_result1_upvr.New("UICorner")({
			CornerRadius = UDim.new(0, 5);
		})};
	})
end
function module_2_upvr.controlBar(arg1, arg2) -- Line 55
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local module = {
		Parent = arg2.Parent;
	}
	local Position = arg2.Position
	if not Position then
		Position = UDim2.new(0.5, 0, 1, -10)
	end
	module.Position = Position
	Position = arg2.AnchorPoint
	local var15 = Position
	if not var15 then
		var15 = Vector2.new(0.5, 1)
	end
	module.AnchorPoint = var15
	module.Size = UDim2.new(1, 0, 0, 30)
	module.BackgroundTransparency = 1
	module.ZIndex = 1000
	module[var1_result1_upvr.Children] = {var1_result1_upvr.New("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal;
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		VerticalAlignment = Enum.VerticalAlignment.Center;
		Padding = UDim.new(0, 5);
	}), arg2[var1_result1_upvr.Children]}
	return var1_result1_upvr.New("Frame")(module)
end
return module_2_upvr