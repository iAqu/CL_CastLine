-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:23
-- Luau version 6, Types version 3
-- Time taken: 0.000762 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("DialogStyleUtils")
function module.addScale(arg1, arg2) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	if arg2 == 1 then
	else
		table.insert(arg1, 1, var2_upvr.createPushStyle({
			addPercentTextSize = arg2 - 1;
		}))
	end
end
function module.calculateTotalScale(arg1) -- Line 21
	local var4 = arg1
	local var5
	while var4 do
		local class_UIScale = var4:FindFirstChildOfClass("UIScale")
		if class_UIScale then
			var5 *= class_UIScale.Scale
		end
	end
	return var5
end
return module