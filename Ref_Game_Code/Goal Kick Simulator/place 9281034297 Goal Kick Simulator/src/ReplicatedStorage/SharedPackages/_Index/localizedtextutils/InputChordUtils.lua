-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:25
-- Luau version 6, Types version 3
-- Time taken: 0.001594 seconds

local var1_upvr = require(script.Parent.loader).load(script)("EnumUtils")
return {
	isModifierInputChord = function(arg1) -- Line 18, Named "isModifierInputChord"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var5 = false
		if type(arg1) == "table" then
			var5 = false
			if arg1.type == "ModifierInputChord" then
				var5 = false
				if type(arg1.modifiers) == "table" then
					var5 = var1_upvr.isOfType(Enum.KeyCode, arg1.keyCode)
				end
			end
		end
		return var5
	end;
	createModifierInputChord = function(arg1, arg2) -- Line 36, Named "createModifierInputChord"
		--[[ Upvalues[1]:
			[1]: var1_upvr (readonly)
		]]
		local var6
		if type(arg1) ~= "table" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad modifiers")
		var6 = var1_upvr.isOfType(Enum.KeyCode, arg2)
		assert(var6, "Bad keyCode")
		local module = {}
		var6 = "ModifierInputChord"
		module.type = var6
		module.modifiers = arg1
		module.keyCode = arg2
		return module
	end;
}