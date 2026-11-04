-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:39
-- Luau version 6, Types version 3
-- Time taken: 0.000995 seconds

local module_upvr = {}
local Players_upvr = game:GetService("Players")
local UserInputService_upvr = game:GetService("UserInputService")
function module_upvr.IsOnMoveArea(arg1) -- Line 11
	--[[ Upvalues[2]:
		[1]: UserInputService_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	if UserInputService_upvr.TouchEnabled and arg1 then
		local ScreenGui_2 = Players_upvr.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
		if ScreenGui_2 then
			local AbsoluteSize = ScreenGui_2.AbsoluteSize
			if arg1.X <= AbsoluteSize.X * 0.4 and AbsoluteSize.Y * 0.5 <= arg1.Y then
				return true
			end
		end
	end
	return false
end
function module_upvr.IsOnMoveArea_WorldPos(arg1) -- Line 31
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_WorldToScreenPoint_result1, any_WorldToScreenPoint_result2 = workspace.CurrentCamera:WorldToScreenPoint(arg1)
	return module_upvr.IsOnMoveArea(Vector3.new(any_WorldToScreenPoint_result1.X, any_WorldToScreenPoint_result1.Y, 0))
end
return module_upvr