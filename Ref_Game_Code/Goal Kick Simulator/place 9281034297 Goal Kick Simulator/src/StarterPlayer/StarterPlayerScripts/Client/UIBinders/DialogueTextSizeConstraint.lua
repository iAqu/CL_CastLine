-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:36
-- Luau version 6, Types version 3
-- Time taken: 0.000599 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1:GiveTask(arg1.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line 7, Named "UpdateSize"
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.MaxTextSize = (arg1.Parent.AbsoluteSize.Y * 0.8 - 20) / 2
	end))
	arg1.MaxTextSize = (arg1.Parent.AbsoluteSize.Y * 0.8 - 20) / 2
	return any_new_result1
end
return module