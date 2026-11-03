-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:08
-- Luau version 6, Types version 3
-- Time taken: 0.001883 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {
	MultiChanged = Util_upvr.Signal.new();
}
local tbl_upvr = {}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
Util_upvr.Thread.Every(1, function() -- Line 12
	--[[ Upvalues[5]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: any_GetLink_result1_upvr (readonly)
		[4]: Util_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var15
	local Character = LocalPlayer_upvr.Character
	if Character then
		Character = LocalPlayer_upvr.Character:GetPivot().Position
	end
	if not Character then
	else
		for i, v in pairs(tbl_upvr) do
			if any_GetLink_result1_upvr.Zones[i.Name] and Util_upvr.CFrame.InsidePart(i, Character) and (not var15 or var15 < v) then
				local Name = i.Name
				local var21 = v
			end
		end
		if var21 ~= module_upvr.CurrentMulti then
			module_upvr.CurrentName = Name
			module_upvr.CurrentMulti = var21
			i = Name
			module_upvr.MultiChanged:Fire(var21, i)
		end
	end
end)
function module_upvr.Binder(arg1) -- Line 29
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.Track = arg1:GetAttributeChangedSignal("Multi"):Connect(function() -- Line 32, Named "Update"
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = arg1:GetAttribute("Multi") or nil
	end)
	tbl_upvr[arg1] = arg1:GetAttribute("Multi") or nil
	return any_new_result1
end
Util_upvr.AreaMultiplier = module_upvr
return module_upvr