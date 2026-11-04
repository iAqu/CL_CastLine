-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:31
-- Luau version 6, Types version 3
-- Time taken: 0.002633 seconds

local module = {
	NumValueAdd = function(arg1, arg2, arg3) -- Line 10, Named "NumValueAdd"
		if arg3 == nil or arg3 == true then
			arg2(arg1.Value)
		end
		return arg1.Changed:Connect(arg2)
	end;
}
local UIanima_upvr = require(game:GetService("ReplicatedStorage").Tool.UIanima)
function module.AddMouseCLick(arg1, arg2, arg3, arg4) -- Line 19
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	local module_3 = {
		[#module_3 + 1] = arg1.MouseEnter:Connect(function() -- Line 24
			--[[ Upvalues[2]:
				[1]: arg3 (readonly)
				[2]: UIanima_upvr (copied, readonly)
			]]
			if arg3 then
				UIanima_upvr.BtnScaleAnimEnter(arg3)
			end
		end);
		[#module_3 + 1] = arg1.MouseLeave:Connect(function() -- Line 30
			--[[ Upvalues[2]:
				[1]: arg3 (readonly)
				[2]: UIanima_upvr (copied, readonly)
			]]
			if arg3 then
				UIanima_upvr.BtnScaleAnimLeave(arg3)
			end
		end);
		[#module_3 + 1] = arg1.MouseButton1Down:Connect(function() -- Line 36
			--[[ Upvalues[3]:
				[1]: arg3 (readonly)
				[2]: UIanima_upvr (copied, readonly)
				[3]: arg4 (readonly)
			]]
			if arg3 then
				UIanima_upvr.ButtonDown(arg3, arg4)
			end
		end);
		[#module_3 + 1] = arg1.MouseButton1Up:Connect(function() -- Line 42
			--[[ Upvalues[2]:
				[1]: arg3 (readonly)
				[2]: UIanima_upvr (copied, readonly)
			]]
			if arg3 then
				UIanima_upvr.ButtonUp(arg3)
			end
		end);
		[#module_3 + 1] = arg1.MouseButton1Click:Connect(function() -- Line 48
			--[[ Upvalues[1]:
				[1]: arg2 (readonly)
			]]
			arg2()
		end);
	}
	return module_3
end
function module.RemoveMouseClick(arg1) -- Line 55
	for i, v in pairs(arg1) do
		if v then
			arg1[i]:Disconnect()
			arg1[i] = nil
		end
	end
end
local MouseEnabled_upvr = game:GetService("UserInputService").MouseEnabled
local var15_upvw
function module.AddMouseHover(arg1, arg2, arg3) -- Line 70
	--[[ Upvalues[2]:
		[1]: MouseEnabled_upvr (readonly)
		[2]: var15_upvw (read and write)
	]]
	local module_2 = {}
	if MouseEnabled_upvr == true then
		module_2[1] = arg1.MouseEnter:Connect(function() -- Line 74
			--[[ Upvalues[3]:
				[1]: var15_upvw (copied, read and write)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			var15_upvw = arg1
			arg2()
		end)
		module_2[2] = arg1.MouseLeave:Connect(function() -- Line 79
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: var15_upvw (copied, read and write)
				[3]: arg3 (readonly)
			]]
			if arg1 == var15_upvw then
				arg3()
			end
		end)
		return module_2
	end
end
return module