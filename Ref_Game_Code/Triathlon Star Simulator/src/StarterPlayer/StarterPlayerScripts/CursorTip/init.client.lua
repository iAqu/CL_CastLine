-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:23
-- Luau version 6, Types version 3
-- Time taken: 0.000744 seconds

local UserInputService = game:GetService("UserInputService")
local CursorTip = script.CursorTip
if game:GetService("RunService"):IsStudio() and UserInputService.GamepadEnabled == true or UserInputService.KeyboardEnabled == false and UserInputService.GamepadEnabled == true then
	CursorTip.Parent = game.Players.LocalPlayer.PlayerGui
	CursorTip.DisplayOrder = 101
	UserInputService.MouseIconEnabled = false
	local var4_upvw = false
	local GamepadService_upvr = game:GetService("GamepadService")
	UserInputService.InputBegan:Connect(function(arg1, arg2) -- Line 17
		--[[ Upvalues[2]:
			[1]: var4_upvw (read and write)
			[2]: GamepadService_upvr (readonly)
		]]
		if arg1.KeyCode == Enum.KeyCode.ButtonL1 then
			if not var4_upvw then
				GamepadService_upvr:EnableGamepadCursor(nil)
				var4_upvw = true
				return
			end
			GamepadService_upvr:DisableGamepadCursor(nil)
			var4_upvw = false
		end
	end)
end