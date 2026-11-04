-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:47
-- Luau version 6, Types version 3
-- Time taken: 0.000807 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
game:GetService("ScriptContext").Error:Connect(function(arg1, arg2, arg3) -- Line 11
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not arg3 then
	else
		local var3_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 17
			--[[ Upvalues[2]:
				[1]: var3_upvw (read and write)
				[2]: arg3 (readonly)
			]]
			var3_upvw = arg3:GetFullName()
		end)
		if not pcall_result1 then return end
		ReplicatedStorage_upvr.GameAnalyticsError:FireServer(arg1, arg2, var3_upvw)
	end
end)
local GuiService_upvr = game:GetService("GuiService")
local UserInputService_upvr = game:GetService("UserInputService")
require(script.Postie).setCallback("getPlatform", function() -- Line 28, Named "getPlatform"
	--[[ Upvalues[2]:
		[1]: GuiService_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
	]]
	if GuiService_upvr:IsTenFootInterface() then
		return "Console"
	end
	if UserInputService_upvr.TouchEnabled and not UserInputService_upvr.MouseEnabled then
		return "Mobile"
	end
	return "Desktop"
end)