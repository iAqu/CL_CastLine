-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:08
-- Luau version 6, Types version 3
-- Time taken: 0.001565 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local var1_result1_upvr_6 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ServiceBag")
local var1_result1_upvr_4 = any_load_result1("SharedInputKeyMap")
local var1_result1_upvr_7 = any_load_result1("GuiThemeService")
local var1_result1_upvr_8 = any_load_result1("GuiThemeServiceStoryUtils")
local var1_result1_upvr_5 = any_load_result1("DialogInput")
local var1_result1_upvr_9 = any_load_result1("DialogTextContainer")
local var1_result1_upvr_2 = any_load_result1("Blend")
local var1_result1_upvr_11 = any_load_result1("UICornerUtils")
local var1_result1_upvr_10 = any_load_result1("LipsumUtils")
local var1_result1_upvr_3 = any_load_result1("DialogEntityUtils")
return function(arg1) -- Line 21
	--[[ Upvalues[11]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
		[4]: var1_result1_upvr_7 (readonly)
		[5]: var1_result1_upvr_8 (readonly)
		[6]: var1_result1_upvr_5 (readonly)
		[7]: var1_result1_upvr_9 (readonly)
		[8]: var1_result1_upvr_2 (readonly)
		[9]: var1_result1_upvr_11 (readonly)
		[10]: var1_result1_upvr_10 (readonly)
		[11]: var1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_3_upvr = var1_result1_upvr_6.new()
	local any_new_result1 = var1_result1_upvr.new()
	any_new_result1_3_upvr:GiveTask(any_new_result1)
	var1_result1_upvr_8.createThemeButton(any_new_result1_3_upvr, any_new_result1, arg1)
	local any_new_result1_2 = var1_result1_upvr_5.new(any_new_result1)
	any_new_result1_3_upvr:GiveTask(any_new_result1_2)
	any_new_result1_2:SetEnabled(true)
	local any_new_result1_4 = var1_result1_upvr_9.new(any_new_result1, any_new_result1_2)
	any_new_result1_3_upvr:GiveTask(any_new_result1_4)
	local tbl = {
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Size = UDim2.new(0.5, 0, 0.5, 0);
		BackgroundColor3 = any_new_result1:GetService(var1_result1_upvr_7):ObserveColor("surface");
		BorderSizePixel = 0;
	}
	tbl.Parent = arg1
	tbl[var1_result1_upvr_2.Children] = {var1_result1_upvr_11.fromOffset(4), var1_result1_upvr_2.New("UIScale")({
		Scale = 1;
	}), any_new_result1_4.Gui}
	any_new_result1_3_upvr:GiveTask(var1_result1_upvr_2.New("Frame")(tbl):Subscribe())
	any_new_result1_4:SetParentUIScale(1)
	any_new_result1_4:RecordSize()
	any_new_result1_4:ShowText("Hi [player]! I'm [talker]! Click [hint]! (So exciting!) (Hi!)  text "..var1_result1_upvr_10.sentence().." *big text* "..var1_result1_upvr_10.paragraph(10, nil, Random.new(1337)), {
		player = var1_result1_upvr_3.createPlayerEntity("Quenty");
		talker = var1_result1_upvr_3.createTalkerEntity("John", Color3.new(1, 0.5, 0.5), 0);
		hint = var1_result1_upvr_3.createInputHint(any_new_result1:GetService(var1_result1_upvr_4):GetInputKeyMapList("PRIMARY"));
	})
	return function() -- Line 66
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		any_new_result1_3_upvr:DoCleaning()
	end
end