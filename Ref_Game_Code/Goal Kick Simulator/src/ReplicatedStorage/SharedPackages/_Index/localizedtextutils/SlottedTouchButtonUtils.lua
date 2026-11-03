-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:13
-- Luau version 6, Types version 3
-- Time taken: 0.003587 seconds

local module_2_upvr = {
	createSlottedTouchButton = function(arg1) -- Line 38, Named "createSlottedTouchButton"
		local var14 = true
		if arg1 ~= "primary1" then
			var14 = true
			if arg1 ~= "primary2" then
				var14 = true
				if arg1 ~= "primary3" then
					var14 = true
					if arg1 ~= "primary4" then
						var14 = true
						if arg1 ~= "inner1" then
							var14 = true
							if arg1 ~= "inner2" then
								var14 = true
								if arg1 ~= "jumpbutton" then
									if arg1 ~= "touchpad1" then
										var14 = false
									else
										var14 = true
									end
								end
							end
						end
					end
				end
			end
		end
		assert(var14, "Bad slotId")
		local module_5 = {
			type = "SlottedTouchButton";
		}
		module_5.slotId = arg1
		return module_5
	end;
	isSlottedTouchButton = function(arg1) -- Line 60, Named "isSlottedTouchButton"
		local var16 = false
		if type(arg1) == "table" then
			if arg1.type ~= "SlottedTouchButton" then
				var16 = false
			else
				var16 = true
			end
		end
		return var16
	end;
	createTouchButtonData = function(arg1, arg2) -- Line 71, Named "createTouchButtonData"
		local module_4 = {}
		module_4.slotId = arg1
		module_4.inputModeType = arg2
		return module_4
	end;
}
local var18_upvr = require(script.Parent.loader).load(script)("InputModeType")
function module_2_upvr.getSlottedTouchButtonData(arg1) -- Line 84
	--[[ Upvalues[2]:
		[1]: var18_upvr (readonly)
		[2]: module_2_upvr (readonly)
	]]
	for _, v in pairs(arg1) do
		assert(var18_upvr.isInputModeType(v.inputModeType), "Bad inputKeyMap.inputModeType")
		assert(v.inputTypes, "Bad inputKeyMap.inputTypes")
		for _, v_2 in pairs(v.inputTypes) do
			if module_2_upvr.isSlottedTouchButton(v_2) then
				table.insert({}, module_2_upvr.createTouchButtonData(v_2.slotId, v.inputModeType))
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
return module_2_upvr