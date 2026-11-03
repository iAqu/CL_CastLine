-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:46
-- Luau version 6, Types version 3
-- Time taken: 0.001787 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_2_upvr = Util_upvr.Maid.new()
	local function UpdateSize_upvr(arg1_2) -- Line 9, Named "UpdateSize"
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local Y = arg1_2.AbsoluteSize.Y
		arg1_2.Size = UDim2.new(Util_upvr.TextService:GetTextSize(tostring(arg1_2.ContentText), Y, arg1_2.Font, Vector2.new(math.huge, Y)).X / arg1.AbsoluteSize.X, 0, arg1_2.Size.Y.Scale, arg1_2.Size.Y.Offset)
	end
	local function Validate(arg1_3) -- Line 15
		--[[ Upvalues[3]:
			[1]: UpdateSize_upvr (readonly)
			[2]: any_new_result1_2_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if arg1_3:IsA("TextLabel") or arg1_3:IsA("TextBox") or arg1_3:IsA("TextButton") then
			UpdateSize_upvr(arg1_3)
			if not any_new_result1_2_upvr[arg1_3] then
				local any_new_result1 = Util_upvr.Maid.new()
				any_new_result1:GiveTask(arg1_3:GetPropertyChangedSignal("ContentText"):Connect(function() -- Line 20
					--[[ Upvalues[2]:
						[1]: UpdateSize_upvr (copied, readonly)
						[2]: arg1_3 (readonly)
					]]
					UpdateSize_upvr(arg1_3)
				end))
				any_new_result1:GiveTask(arg1_3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line 23
					--[[ Upvalues[2]:
						[1]: UpdateSize_upvr (copied, readonly)
						[2]: arg1_3 (readonly)
					]]
					UpdateSize_upvr(arg1_3)
				end))
				any_new_result1_2_upvr[arg1_3] = any_new_result1
			end
		end
	end
	for _, v in pairs(arg1:GetChildren()) do
		Validate(v)
	end
	any_new_result1_2_upvr.ChildAdded = arg1.ChildAdded:Connect(Validate)
	any_new_result1_2_upvr.ChildRemoved = arg1.ChildRemoved:Connect(function(arg1_4) -- Line 34
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr[arg1_4] = nil
	end)
	return any_new_result1_2_upvr
end
return module