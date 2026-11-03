-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:00
-- Luau version 6, Types version 3
-- Time taken: 0.001213 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	repeat
		task.wait()
	until Util_upvr.Windows
	local var7_upvw = false
	local SOME_upvr = Util_upvr.Windows.Object.Windows:FindFirstChild(arg1.Name)
	any_new_result1.CheckIsInside = Util_upvr.Thread.Every(0.5, function() -- Line 14
		--[[ Upvalues[5]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: var7_upvw (read and write)
			[5]: SOME_upvr (readonly)
		]]
		local Character = LocalPlayer_upvr.Character
		local var10 = Character
		if var10 then
			var10 = Character:GetPivot().Position
		end
		if Util_upvr.CFrame.InsidePart(arg1, var10) then
			if var7_upvw then
			else
				var7_upvw = true
				Util_upvr.Windows:SwitchWindow(SOME_upvr)
			end
		end
		if var7_upvw then
			var7_upvw = false
			if Util_upvr.Windows.CurrentWindow ~= SOME_upvr then return end
			Util_upvr.Windows:SwitchWindow()
		end
	end)
	return any_new_result1
end
return module