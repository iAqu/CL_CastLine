-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:41
-- Luau version 6, Types version 3
-- Time taken: 0.003494 seconds

local var1_upvr = require(script.Parent.loader).load(script)("DialogTextBoxOptionTypes")
return {
	createTextBoxOptions = function(arg1) -- Line 11, Named "createTextBoxOptions"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var3
		if type(arg1) ~= "table" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad options")
		if type(arg1.key) ~= "string" then
			var3 = false
		else
			var3 = true
		end
		assert(var3, "Bad options.key")
		var3 = true
		if type(arg1.promptText) ~= "string" then
			if arg1.promptText ~= nil then
				var3 = false
			else
				var3 = true
			end
		end
		assert(var3, "Bad options.promptText")
		var3 = true
		if type(arg1.text) ~= "string" then
			if arg1.text ~= nil then
				var3 = false
			else
				var3 = true
			end
		end
		assert(var3, "Bad options.text")
		var3 = true
		if type(arg1.maxCharacters) ~= "number" then
			if arg1.maxCharacters ~= nil then
				var3 = false
			else
				var3 = true
			end
		end
		assert(var3, "Bad options.maxCharacters")
		var3 = true
		if type(arg1.previewFilter) ~= "boolean" then
			if arg1.previewFilter ~= nil then
				var3 = false
			else
				var3 = true
			end
		end
		assert(var3, "Bad options.previewFilter")
		var3 = true
		if type(arg1.inputRequired) ~= "boolean" then
			if arg1.inputRequired ~= nil then
				var3 = false
			else
				var3 = true
			end
		end
		assert(var3, "Bad options.inputRequired")
		local module = {}
		var3 = var1_upvr.TEXTBOX_OPTIONS
		module.type = var3
		var3 = arg1.key
		module.key = var3
		var3 = arg1.text or ""
		module.text = var3
		var3 = arg1.promptText
		module.promptText = var3
		var3 = arg1.maxCharacters or 20
		module.maxCharacters = var3
		if arg1.previewFilter or arg1.previewFilter == nil then
			var3 = true
		else
			var3 = false
		end
		module.previewFilter = var3
		if arg1.inputRequired == false then
			var3 = false
		else
			var3 = true
		end
		module.inputRequired = var3
		return module
	end;
	createLocalizedTextBoxOptions = function(arg1) -- Line 31, Named "createLocalizedTextBoxOptions"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var5
		if type(arg1) ~= "table" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad options")
		if type(arg1.key) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad options.key")
		var5 = true
		if type(arg1.promptTextKey) ~= "string" then
			if arg1.promptTextKey ~= nil then
				var5 = false
			else
				var5 = true
			end
		end
		assert(var5, "Bad options.promptTextKey")
		var5 = true
		if type(arg1.maxCharacters) ~= "number" then
			if arg1.maxCharacters ~= nil then
				var5 = false
			else
				var5 = true
			end
		end
		assert(var5, "Bad options.maxCharacters")
		var5 = true
		if type(arg1.text) ~= "string" then
			if arg1.text ~= nil then
				var5 = false
			else
				var5 = true
			end
		end
		assert(var5, "Bad options.text")
		var5 = true
		if type(arg1.inputRequired) ~= "boolean" then
			if arg1.inputRequired ~= nil then
				var5 = false
			else
				var5 = true
			end
		end
		assert(var5, "Bad options.inputRequired")
		local module_2 = {}
		var5 = var1_upvr.LOCALIZED_TEXTBOX_OPTIONS
		module_2.type = var5
		var5 = arg1.key
		module_2.key = var5
		var5 = arg1.text or ""
		module_2.text = var5
		var5 = arg1.promptTextKey
		module_2.promptTextKey = var5
		var5 = arg1.maxCharacters or 20
		module_2.maxCharacters = var5
		if arg1.inputRequired == false then
			var5 = false
		else
			var5 = true
		end
		module_2.inputRequired = var5
		return module_2
	end;
}