-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:07
-- Luau version 6, Types version 3
-- Time taken: 0.001396 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1 = Util_upvr.Link:GetLink("PlayerData")
	local Transparency_upvr = arg1.Transparency
	local SurfaceGui_upvr = arg1:WaitForChild("SurfaceGui")
	local var8_upvw = false
	any_new_result1_upvr:GiveTask(function() -- Line 22
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: Transparency_upvr (readonly)
			[3]: SurfaceGui_upvr (readonly)
		]]
		arg1.CanCollide = true
		arg1.Transparency = Transparency_upvr
		SurfaceGui_upvr.Enabled = true
	end)
	arg1:GetAttributeChangedSignal("LightingZone"):Connect(function() -- Line 28, Named "UpdateLightingZone"
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if arg1:GetAttribute("LightingZone") then
			any_new_result1_upvr.LightingZone = Util_upvr.Thread.Every(1, function() -- Line 31
			end)
		end
	end)
	local var12 = any_GetLink_result1.Zones[arg1.Name]
	local var13 = not var12
	arg1.CanCollide = var13
	if var12 then
		var13 = 1
	else
		var13 = Transparency_upvr
	end
	arg1.Transparency = var13
	SurfaceGui_upvr.Enabled = not var12
	var8_upvw = var12
	any_new_result1_upvr.ZonesUpdate = any_GetLink_result1.Zones.Changed:On(arg1.Name, function(arg1_2) -- Line 15, Named "UpdatePurchased"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: Transparency_upvr (readonly)
			[3]: SurfaceGui_upvr (readonly)
			[4]: var8_upvw (read and write)
		]]
		local var9 = not arg1_2
		arg1.CanCollide = var9
		if arg1_2 then
			var9 = 1
		else
			var9 = Transparency_upvr
		end
		arg1.Transparency = var9
		SurfaceGui_upvr.Enabled = not arg1_2
		var8_upvw = arg1_2
	end)
	return any_new_result1_upvr
end
return module