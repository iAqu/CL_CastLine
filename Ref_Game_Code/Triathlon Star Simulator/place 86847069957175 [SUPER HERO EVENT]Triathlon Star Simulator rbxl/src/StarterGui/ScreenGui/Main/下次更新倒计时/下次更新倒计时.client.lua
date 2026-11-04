-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:04
-- Luau version 6, Types version 3
-- Time taken: 0.001253 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local TextLabel = script.Parent:WaitForChild("TextLabel", math.huge)
while true do
	task.wait(1)
	local Value = workspace:WaitForChild("GameNextUpdateTime", math.huge).Value
	local any_GetSerVerTime_result1 = require(game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts", math.huge):WaitForChild("LocalData", math.huge)):GetSerVerTime()
	local var5
	if Value and any_GetSerVerTime_result1 then
		if any_GetSerVerTime_result1 >= Value then
			var5 = false
		else
			var5 = true
		end
		script.Parent.Visible = var5
		if var5 then
		else
		end
		TextLabel.Text = TextLabel.Text
	end
end