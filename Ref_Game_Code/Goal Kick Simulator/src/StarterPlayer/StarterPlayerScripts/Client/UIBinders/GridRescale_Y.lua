-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:38
-- Luau version 6, Types version 3
-- Time taken: 0.000838 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local var5_upvr = arg1:GetAttribute("UI_GridRatio") or 1
	any_new_result1:GiveTask(arg1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 8, Named "UpdateSize"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var5_upvr (readonly)
		]]
		arg1.CellSize = UDim2.new(arg1.CellSize.X.Scale, arg1.CellSize.X.Offset, 0, arg1.AbsoluteCellSize.X / var5_upvr)
	end))
	arg1.CellSize = UDim2.new(arg1.CellSize.X.Scale, arg1.CellSize.X.Offset, 0, arg1.AbsoluteCellSize.X / var5_upvr)
	return any_new_result1
end
return module