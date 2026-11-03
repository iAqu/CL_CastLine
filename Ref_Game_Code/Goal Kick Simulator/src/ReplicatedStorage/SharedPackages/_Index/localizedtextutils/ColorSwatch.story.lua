-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:20
-- Luau version 6, Types version 3
-- Time taken: 0.003033 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_3 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("Blend")
local var1_result1_upvr_2 = any_load_result1("ColorSwatch")
return function(arg1) -- Line 11
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr_3.new()
	local function entry_upvr(arg1_2, arg2, arg3) -- Line 14, Named "entry"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (copied, readonly)
		]]
		local module = {
			Name = "Entry";
			Size = UDim2.new(0, 25, 0, 45);
			BackgroundTransparency = 1;
		}
		local tbl_3 = {}
		local tbl_5 = {}
		tbl_5.BackgroundColor3 = arg1_2
		tbl_5.Size = UDim2.new(0, 25, 0, 25)
		local tbl_2 = {
			Text = tostring(arg2);
			Size = UDim2.new(1, 0, 0, 15);
			Position = UDim2.new(0, 0, 1, 0);
			AnchorPoint = Vector2.new(0, 1);
			Font = Enum.Font.Code;
			TextScaled = true;
		}
		local tbl_7 = {}
		local tbl_6 = {}
		local Color3_new_result1 = Color3.new(0.6, 1, 0.6)
		tbl_6.Color = Color3_new_result1
		if arg3 then
			Color3_new_result1 = 3
		else
			Color3_new_result1 = 0
		end
		tbl_6.Thickness = Color3_new_result1
		tbl_7[1] = var1_result1_upvr.New("UIStroke")(tbl_6)
		tbl_2[var1_result1_upvr.Children] = tbl_7
		tbl_3[1] = var1_result1_upvr.New("Frame")(tbl_5)
		tbl_3[2] = var1_result1_upvr.New("TextLabel")(tbl_2)
		module[var1_result1_upvr.Children] = tbl_3
		return var1_result1_upvr.New("Frame")(module)
	end
	local function palette(arg1_3) -- Line 46
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: entry_upvr (readonly)
			[3]: var1_result1_upvr (copied, readonly)
		]]
		local tbl_4 = {}
		local any_new_result1 = var1_result1_upvr_2.new(arg1_3, 1)
		for i = 0, 100, 10 do
			local var18 = i
			if math.abs(any_new_result1:GetBaseGrade() - i) > 5 then
				var18 = false
			else
				var18 = true
			end
			table.insert(tbl_4, entry_upvr(any_new_result1:GetGraded(i), tostring(var18), var18))
		end
		return var1_result1_upvr.New("Frame")({
			Size = UDim2.new(1, 0, 0, 45);
			[var1_result1_upvr.Children] = {tbl_4, var1_result1_upvr.New("UIListLayout")({
				Padding = UDim.new(0, 0);
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				VerticalAlignment = Enum.VerticalAlignment.Center;
				FillDirection = Enum.FillDirection.Horizontal;
			})};
		})
	end
	local tbl = {
		Size = UDim2.new(1, 0, 1, 0);
	}
	tbl.Parent = arg1
	tbl[var1_result1_upvr.Children] = {palette(Color3.new(0, 0, 0)), palette(Color3.fromRGB(117, 117, 117)), palette(Color3.fromRGB(245, 238, 214)), palette(Color3.fromRGB(96, 58, 58)), palette(Color3.fromRGB(85, 170, 127)), palette(Color3.new(1, 0, 0)), palette(Color3.new(0, 1, 0)), palette(Color3.new(0, 0, 1)), palette(Color3.new(1, 0, 1)), palette(Color3.new(1, 1, 0)), palette(Color3.new(0, 1, 1)), var1_result1_upvr.New("UIListLayout")({
		Padding = UDim.new(0, 5);
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		FillDirection = Enum.FillDirection.Vertical;
	}), var1_result1_upvr.New("UIPadding")({
		PaddingTop = UDim.new(0, 10);
	})}
	any_new_result1_upvr:GiveTask(var1_result1_upvr.New("ScrollingFrame")(tbl):Subscribe())
	return function() -- Line 101
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end