-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:11
-- Luau version 6, Types version 3
-- Time taken: 0.002090 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local var5_upvw
function module.Binder(arg1) -- Line 8
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: var5_upvw (read and write)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	repeat
		task.wait()
	until Util_upvr.Windows
	arg1.Transparency = 1
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	any_new_result1.CheckIsInside = Util_upvr.Thread.Every(0.5, function() -- Line 16
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
			[4]: Util_upvr (copied, readonly)
			[5]: var5_upvw (copied, read and write)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local RequiredZone = arg1:GetAttribute("RequiredZone")
		local var10
		if not RequiredZone or any_GetLink_result1_upvr.Zones[RequiredZone] then
			var10 = true
		end
		if var10 then
			local Character = LocalPlayer_upvr.Character
		end
		if Character then
			local Position = Character:GetPivot().Position
		end
		if Position and Util_upvr.CFrame.InsidePart(arg1, Position) then
			if var5_upvw then
			else
				var5_upvw = arg1
				Util_upvr.Windows:PromptNotification({
					Sound = "windowswitch";
					Text = "Do you really want to move to <font color=\"#FF89FF\">"..arg1.Name.."</font>?";
					Text1 = "No";
					Text2 = "Go";
					Option2 = function() -- Line 34, Named "Option2"
						--[[ Upvalues[2]:
							[1]: Util_upvr (copied, readonly)
							[2]: arg1 (copied, readonly)
						]]
						Util_upvr.Network:Fire("PromptGoZone", arg1)
					end;
					Priority = 10;
				})
			end
		end
		if var5_upvw == arg1 then
			var5_upvw = nil
			Util_upvr.Windows:CloseNotification(10)
		end
	end)
	return any_new_result1
end
return module