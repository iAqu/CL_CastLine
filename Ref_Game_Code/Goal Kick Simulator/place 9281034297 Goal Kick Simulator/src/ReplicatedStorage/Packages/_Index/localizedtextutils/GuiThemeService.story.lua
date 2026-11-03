-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:03
-- Luau version 6, Types version 3
-- Time taken: 0.001633 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_4 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_2 = any_load_result1("GuiThemeService")
local var1_result1_upvr_5 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_6 = any_load_result1("Blend")
local var1_result1_upvr_3 = any_load_result1("ColorPickerStoryUtils")
return function(arg1) -- Line 14
	--[[ Upvalues[6]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr_5 (readonly)
		[5]: var1_result1_upvr_6 (readonly)
		[6]: var1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_2_upvr = var1_result1_upvr_4.new()
	local any_new_result1 = var1_result1_upvr.new()
	any_new_result1_2_upvr:GiveTask(any_new_result1)
	local service_upvr = any_new_result1:GetService(var1_result1_upvr_2)
	var1_result1_upvr_5.createThemeButton(any_new_result1_2_upvr, any_new_result1, arg1)
	local tbl = {
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundColor3 = service_upvr:ObserveColor("surface");
	}
	tbl.Parent = arg1
	tbl[var1_result1_upvr_6.Children] = {var1_result1_upvr_6.New("UIListLayout")({
		Padding = UDim.new(0, 20);
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		FillDirection = Enum.FillDirection.Vertical;
	}), var1_result1_upvr_6.New("TextLabel")({
		Size = UDim2.new(1, 0, 0, 40);
		TextSize = 30;
		BackgroundTransparency = 1;
		TextColor3 = service_upvr:ObserveColor("text");
		Font = service_upvr:ObserveFont("title");
		Text = service_upvr:GetPreferredThemeNameValue();
	}), var1_result1_upvr_6.New("UIPadding")({
		PaddingTop = UDim.new(0, 20);
	}), var1_result1_upvr_3.create(any_new_result1_2_upvr, function(arg1_2) -- Line 48
		--[[ Upvalues[1]:
			[1]: service_upvr (readonly)
		]]
		local any_GetColorPalette_result1 = service_upvr:GetColorPalette()
		local any_GetSwatchNames_result1 = any_GetColorPalette_result1:GetSwatchNames()
		table.sort(any_GetSwatchNames_result1)
		for _, v in pairs(any_GetSwatchNames_result1) do
			arg1_2(v, any_GetColorPalette_result1:GetColorValue(v))
		end
	end)}
	any_new_result1_2_upvr:GiveTask(var1_result1_upvr_6.New("Frame")(tbl):Subscribe())
	return function() -- Line 59
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:DoCleaning()
	end
end