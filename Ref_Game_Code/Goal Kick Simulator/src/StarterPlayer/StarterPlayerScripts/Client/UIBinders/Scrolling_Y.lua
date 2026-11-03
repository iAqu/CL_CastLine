-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:43
-- Luau version 6, Types version 3
-- Time taken: 0.000967 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local var5_upvr = arg1:GetAttribute("UI_Extra") or 0
	local var6 = arg1:GetAttribute("UI_Source") or "UIListLayout"
	local SOME_upvr = arg1:FindFirstChild(var6)
	if not SOME_upvr then
		SOME_upvr = arg1:FindFirstChildOfClass(var6)
	end
	if SOME_upvr then
		any_new_result1:GiveTask(SOME_upvr:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line 11, Named "UpdateSize"
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: SOME_upvr (readonly)
				[3]: var5_upvr (readonly)
			]]
			arg1.CanvasSize = UDim2.new(0, 0, 0, SOME_upvr.AbsoluteContentSize.Y + var5_upvr)
		end))
		arg1.CanvasSize = UDim2.new(0, 0, 0, SOME_upvr.AbsoluteContentSize.Y + var5_upvr)
	end
	return any_new_result1
end
return module