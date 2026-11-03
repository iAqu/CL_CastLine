-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:47
-- Luau version 6, Types version 3
-- Time taken: 0.000821 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local class_UIGridLayout_upvr = arg1:FindFirstChildOfClass("UIGridLayout")
	local var6_upvw = false
	local var7_upvw = false
	local function UpdateSize_upvr() -- Line 12, Named "UpdateSize"
		--[[ Upvalues[5]:
			[1]: var6_upvw (read and write)
			[2]: var7_upvw (read and write)
			[3]: arg1 (readonly)
			[4]: class_UIGridLayout_upvr (readonly)
			[5]: UpdateSize_upvr (readonly)
		]]
		if var6_upvw then
			var7_upvw = true
		else
			var6_upvw = true
			arg1.Size = UDim2.new(arg1.Size.X.Scale, math.ceil(arg1.Size.X.Offset), 0, math.ceil(class_UIGridLayout_upvr.AbsoluteContentSize.Y))
			task.delay(0.5, function() -- Line 16
				--[[ Upvalues[3]:
					[1]: var6_upvw (copied, read and write)
					[2]: var7_upvw (copied, read and write)
					[3]: UpdateSize_upvr (copied, readonly)
				]]
				var6_upvw = false
				if var7_upvw then
					var7_upvw = false
					UpdateSize_upvr()
				end
			end)
		end
	end
	UpdateSize_upvr()
	any_new_result1.ContentChanged = class_UIGridLayout_upvr:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize_upvr)
	return any_new_result1
end
return module