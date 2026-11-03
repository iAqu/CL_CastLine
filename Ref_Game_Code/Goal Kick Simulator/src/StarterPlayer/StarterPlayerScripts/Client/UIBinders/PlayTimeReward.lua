-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:10
-- Luau version 6, Types version 3
-- Time taken: 0.000764 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {}
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.Claim = arg1.MouseButton1Click:Connect(function() -- Line 10
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		if Util_upvr.Network:Invoke("ClaimPlayTimeReward", arg1.Name) then
			Util_upvr.Sounds:Play("PurchaseSuccessful")
		else
			Util_upvr.Sounds:Play("BuyFailed")
		end
	end)
	tbl_upvr[arg1] = tonumber(arg1.Name)
	function any_new_result1.Clear() -- Line 19
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = nil
	end
	return any_new_result1
end
Util_upvr.PlaytimeFrames = tbl_upvr
return module