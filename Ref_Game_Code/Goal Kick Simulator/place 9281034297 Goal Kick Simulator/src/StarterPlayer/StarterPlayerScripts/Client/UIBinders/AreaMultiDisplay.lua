-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:21
-- Luau version 6, Types version 3
-- Time taken: 0.000801 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 4
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.MultiChanged = Util_upvr.AreaMultiplier.MultiChanged:Connect(function(arg1_2, arg2) -- Line 7, Named "Update"
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_2 then
			arg1.Amount.Text = arg1_2
			arg1.Title.Text = arg2.." Multi" or "Area Boost"
			arg1.Visible = true
		else
			arg1.Visible = false
		end
	end)
	local CurrentMulti = Util_upvr.AreaMultiplier.CurrentMulti
	if CurrentMulti then
		arg1.Amount.Text = CurrentMulti
		arg1.Title.Text = Util_upvr.AreaMultiplier.CurretName.." Multi" or "Area Boost"
		arg1.Visible = true
		return any_new_result1
	end
	arg1.Visible = false
	return any_new_result1
end
return module