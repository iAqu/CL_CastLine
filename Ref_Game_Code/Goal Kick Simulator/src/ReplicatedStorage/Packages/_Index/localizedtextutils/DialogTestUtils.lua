-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:28
-- Luau version 6, Types version 3
-- Time taken: 0.007894 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local Players_upvr = game:GetService("Players")
local var1_result1_upvr_3 = any_load_result1_upvr("DialogEntityUtils")
local var1_result1_upvr = any_load_result1_upvr("DialogChoiceUtils")
local var1_result1_upvr_6 = any_load_result1_upvr("DialogServiceClient")
local var1_result1_upvr_4 = any_load_result1_upvr("Promise")
local module_3_upvr = {
	getPlayerEntity = function() -- Line 18, Named "getPlayerEntity"
		--[[ Upvalues[2]:
			[1]: Players_upvr (readonly)
			[2]: var1_result1_upvr_3 (readonly)
		]]
		if Players_upvr.LocalPlayer then
			return var1_result1_upvr_3.createPlayerEntityFromPlayer(Players_upvr.LocalPlayer)
		end
		return var1_result1_upvr_3.createPlayerEntity("Unnamed Player")
	end;
}
function module_3_upvr.showIntroText(arg1) -- Line 26
	--[[ Upvalues[4]:
		[1]: any_load_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: module_3_upvr (readonly)
		[4]: var1_result1_upvr_6 (readonly)
	]]
	assert(arg1, "Bad serviceBag")
	arg1:GetService(any_load_result1_upvr("DialogTestTranslator"))
	local module_2_upvr = {
		game = var1_result1_upvr_3.createLocalizedGameNameEntity();
		player = module_3_upvr.getPlayerEntity();
		shopname = var1_result1_upvr_3.createLocalizedEntity("shops.scottClothes.name", Color3.new(1, 0.6, 0.6));
		talker = var1_result1_upvr_3.createLocalizedTalkerEntity("npcs.quenty.name", Color3.fromRGB(255, 85, 127), 2.5);
		catchphrase = var1_result1_upvr_3.createLocalizedEntity("npcs.quenty.catchphrase", Color3.fromRGB(255, 85, 127));
		pickupInputHint = var1_result1_upvr_3.createLocalizedInputHint("SharedInputKeyMap", "PRIMARY");
	}
	return arg1:GetService(var1_result1_upvr_6):PromiseLocalSession():Then(function(arg1_2) -- Line 41
		--[[ Upvalues[2]:
			[1]: module_3_upvr (copied, readonly)
			[2]: module_2_upvr (readonly)
		]]
		return module_3_upvr.showIntro(arg1_2, module_2_upvr)
	end)
end
function module_3_upvr.showIntro(arg1, arg2) -- Line 46
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_3_upvr (readonly)
	]]
	return arg1:ShowText("dialogTest.welcome2", arg2):Then(function() -- Line 48
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		return arg1:ShowText("dialogTest.haveAnyQuestions", arg2)
	end):Then(function() -- Line 51
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		return arg1:ShowChoiceList({var1_result1_upvr.createLocalizedChoice("start", "dialogTest.choices.sayThatAgain"), var1_result1_upvr.createLocalizedChoice("exit", "dialogTest.choices.nopeSeeYah")})
	end):Then(function(arg1_3) -- Line 57
		--[[ Upvalues[3]:
			[1]: module_3_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		if arg1_3.key == "start" then
			return module_3_upvr.showIntro(arg1, arg2)
		end
		return arg1:ShowText("dialogTest.talkToSummer", arg2)
	end):Then(function() -- Line 64
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:EndSession()
	end)
end
function module_3_upvr.showTestDialog(arg1) -- Line 69
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_6 (readonly)
		[2]: module_3_upvr (readonly)
	]]
	assert(arg1, "No serviceBag")
	return arg1:GetService(var1_result1_upvr_6):PromiseLocalSession():Then(function(arg1_4) -- Line 73
		--[[ Upvalues[1]:
			[1]: module_3_upvr (copied, readonly)
		]]
		return module_3_upvr.showTestDialogForSession(arg1_4)
	end)
end
local var1_result1_upvr_2 = any_load_result1_upvr("DialogTextBoxOptionUtils")
local var1_result1_upvr_5 = any_load_result1_upvr("DialogSliderOptionUtils")
function module_3_upvr.showTestDialogForSession(arg1) -- Line 78
	--[[ Upvalues[7]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: module_3_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
		[4]: var1_result1_upvr_2 (readonly)
		[5]: Players_upvr (readonly)
		[6]: var1_result1_upvr (readonly)
		[7]: var1_result1_upvr_5 (readonly)
	]]
	local module_upvr = {
		game = var1_result1_upvr_3.createLocalizedGameNameEntity();
		player = module_3_upvr.getPlayerEntity();
		shopname = var1_result1_upvr_3.createLocalizedEntity("shops.scottClothes.name", Color3.new(1, 0.6, 0.6));
		talker = var1_result1_upvr_3.createLocalizedTalkerEntity("npcs.quenty.name", Color3.fromRGB(255, 85, 127), 2.5);
		catchphrase = var1_result1_upvr_3.createLocalizedEntity("npcs.quenty.catchphrase", Color3.fromRGB(255, 85, 127));
		pickupInputHint = var1_result1_upvr_3.createLocalizedInputHint("SharedInputKeyMap", "PRIMARY");
	}
	return arg1:ShowText("dialogTest.welcome", module_upvr):Then(function(arg1_5) -- Line 89
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: module_upvr (readonly)
		]]
		if not arg1_5.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1_5:ShowText("dialogTest.whatShouldICallYou", module_upvr)
	end):Then(function(arg1_6) -- Line 96
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: var1_result1_upvr_2 (copied, readonly)
			[3]: Players_upvr (copied, readonly)
		]]
		local var21
		if not arg1_6.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		local module = {}
		var21 = "test"
		module.key = var21
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var21 = Players_upvr.LocalPlayer.DisplayName
			return var21
		end
		if not Players_upvr.LocalPlayer or not INLINED() then
			var21 = "Unnamed player"
		end
		module.text = var21
		var21 = "dialogTest.prompts.preferredName"
		module.promptTextKey = var21
		var21 = 20
		module.maxCharacters = var21
		return arg1_6:ShowTextBox(var1_result1_upvr_2.createLocalizedTextBoxOptions(module))
	end):Then(function(arg1_7, arg2) -- Line 109
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: module_upvr (readonly)
			[3]: var1_result1_upvr_3 (copied, readonly)
		]]
		if not arg2.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		assert(arg1_7, "Bad text")
		module_upvr.player = var1_result1_upvr_3.createPlayerEntity(arg1_7)
		return arg2:ShowText("dialogTest.nameSet", module_upvr)
	end):Then(function(arg1_8) -- Line 118
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: module_upvr (readonly)
		]]
		if not arg1_8.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1_8:ShowText("dialogTest.colorFitsMe", module_upvr)
	end):Then(function(arg1_9) -- Line 125
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		if not arg1_9.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1_9:ShowChoices(var1_result1_upvr.createGridChoices("haha", {var1_result1_upvr.createColorChoice("choice_1", Color3.fromRGB(2, 138, 123)), var1_result1_upvr.createColorChoice("choice_2", Color3.fromRGB(255, 85, 127)), var1_result1_upvr.createColorChoice("choice_3", Color3.fromRGB(170, 85, 127)), var1_result1_upvr.createColorChoice("choice_4", Color3.fromRGB(255, 170, 127)), var1_result1_upvr.createColorChoice("choice_5", Color3.fromRGB(127, 213, 255)), var1_result1_upvr.createColorChoice("choice_6", Color3.fromRGB(255, 255, 255)), var1_result1_upvr.createColorChoice("choice_7", Color3.new(0.5, 0.5, 0.5)), var1_result1_upvr.createColorChoice("choice_8", Color3.new(0, 0, 0))}))
	end):Then(function(arg1_10, arg2) -- Line 143
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: module_upvr (readonly)
			[3]: var1_result1_upvr_3 (copied, readonly)
		]]
		if not arg2.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		module_upvr.talker = var1_result1_upvr_3.createLocalizedTalkerEntity("npcs.quenty.name", arg1_10.color, 2.5)
		return arg2:ShowText("dialogTest.cuteTest", module_upvr)
	end):Then(function(arg1_11) -- Line 153
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: var1_result1_upvr_5 (copied, readonly)
		]]
		if not arg1_11.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1_11:ShowSlider(var1_result1_upvr_5.createLocalizedSliderOptions({
			key = "test";
			initialValue = 3;
			min = 1;
			minLabelKey = "dialogTest.slider.not";
			max = 5;
			maxLabelKey = "dialogTest.slider.very";
			round = 0.5;
		}))
	end):Then(function(arg1_12, arg2) -- Line 168
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		if 0.5 <= arg1_12.percent then
			return arg2:ShowText("dialogTest.youAreCuteToo", module_upvr)
		end
		return arg2:ShowText("dialogTest.tryHarderToBeCute", module_upvr)
	end):Then(function(arg1_13) -- Line 175
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_4 (copied, readonly)
			[2]: module_3_upvr (copied, readonly)
			[3]: module_upvr (readonly)
		]]
		if not arg1_13.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return module_3_upvr.reenterMenu(arg1_13, module_upvr)
	end)
end
function module_3_upvr.reenterMenu(arg1, arg2) -- Line 184
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: module_3_upvr (readonly)
	]]
	return arg1:ShowText("dialogTest.test3", arg2):Then(function() -- Line 186
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: var1_result1_upvr (copied, readonly)
		]]
		if not arg1.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1:ShowChoiceList({var1_result1_upvr.createLocalizedChoice("where", "dialogTest.choices.whereAmI"), var1_result1_upvr.createLocalizedChoice("cute", "dialogTest.choices.youAreCute"), var1_result1_upvr.createLocalizedChoice("exit", "dialogTest.choices.nopeSeeYah")})
	end):Then(function(arg1_14) -- Line 197
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
			[3]: arg2 (readonly)
			[4]: module_3_upvr (copied, readonly)
		]]
		if not arg1.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		if arg1_14.key == "cute" then
			return arg1:ShowText("dialogTest.youAreCuteToo", arg2):Then(function() -- Line 204
				--[[ Upvalues[3]:
					[1]: module_3_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
				]]
				return module_3_upvr.reenterMenu(arg1, arg2)
			end)
		end
		if arg1_14.key == "where" then
			return arg1:ShowText("dialogTest.whereYouAre", arg2):Then(function() -- Line 209
				--[[ Upvalues[3]:
					[1]: module_3_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
				]]
				return module_3_upvr.reenterMenu(arg1, arg2)
			end)
		end
		return arg1
	end):Then(function() -- Line 216
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_4 (copied, readonly)
		]]
		if not arg1.Destroy then
			return var1_result1_upvr_4.rejected()
		end
		return arg1:EndSession()
	end)
end
return module_3_upvr