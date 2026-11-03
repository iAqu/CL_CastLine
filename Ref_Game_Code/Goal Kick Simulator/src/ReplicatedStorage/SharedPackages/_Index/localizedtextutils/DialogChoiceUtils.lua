-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:40
-- Luau version 6, Types version 3
-- Time taken: 0.002977 seconds

local var1_upvr = require(script.Parent.loader).load(script)("DialogChoiceTypes")
return {
	createChoice = function(arg1, arg2) -- Line 17, Named "createChoice"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var3
		if type(arg1) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad key")
		if type(arg2) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad text")
		local module = {}
		var3 = var1_upvr.DIALOG_CHOICE
		module.type = var3
		module.key = arg1
		module.text = arg2
		return module
	end;
	createColorChoice = function(arg1, arg2) -- Line 28, Named "createColorChoice"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var5
		if type(arg1) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad key")
		if typeof(arg2) ~= "Color3" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad color")
		local module_3 = {}
		var5 = var1_upvr.DIALOG_COLOR_CHOICE
		module_3.type = var5
		module_3.key = arg1
		module_3.color = arg2
		return module_3
	end;
	createLocalizedChoice = function(arg1, arg2) -- Line 39, Named "createLocalizedChoice"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var7
		if type(arg1) ~= "string" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad key")
		if type(arg2) ~= "string" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad textKey")
		local module_2 = {}
		var7 = var1_upvr.LOCALIZED_DIALOG_CHOICE
		module_2.type = var7
		module_2.key = arg1
		module_2.textKey = arg2
		return module_2
	end;
	createChoices = function(arg1, arg2) -- Line 50, Named "createChoices"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var9
		if type(arg1) ~= "string" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad key")
		if type(arg2) ~= "table" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad choices")
		local module_5 = {}
		var9 = var1_upvr.DIALOG_CHOICES
		module_5.type = var9
		module_5.key = arg1
		module_5.choices = arg2
		return module_5
	end;
	createGridChoices = function(arg1, arg2) -- Line 61, Named "createGridChoices"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var11
		if type(arg1) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad key")
		if type(arg2) ~= "table" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad choices")
		local module_4 = {}
		var11 = var1_upvr.DIALOG_GRID_CHOICES
		module_4.type = var11
		module_4.key = arg1
		module_4.choices = arg2
		return module_4
	end;
}