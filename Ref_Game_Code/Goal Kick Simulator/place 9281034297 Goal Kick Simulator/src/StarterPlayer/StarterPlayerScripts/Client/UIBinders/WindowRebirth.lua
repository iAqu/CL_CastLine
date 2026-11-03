-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:22
-- Luau version 6, Types version 3
-- Time taken: 0.001559 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function UpdateRebirth_upvr(arg1_2) -- Line 10, Named "UpdateRebirth"
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		local any_GetRebirthPrice_result1 = Util_upvr.GameMath:GetRebirthPrice(any_GetLink_result1_upvr.Rebirth)
		if any_GetRebirthPrice_result1 <= arg1_2 then
			arg1.Confirm.ImageColor3 = Color3.fromRGB(48, 184, 255)
		else
			arg1.Confirm.ImageColor3 = Color3.fromRGB(90, 90, 90)
		end
		arg1.Confirm.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(any_GetRebirthPrice_result1)
	end
	UpdateRebirth_upvr(any_GetLink_result1_upvr.Money)
	any_new_result1.MoneyChanged = any_GetLink_result1_upvr.Changed:On("Money", UpdateRebirth_upvr)
	any_new_result1.RebirthChanged = any_GetLink_result1_upvr.Changed:On("Rebirth", function() -- Line 22
		--[[ Upvalues[2]:
			[1]: UpdateRebirth_upvr (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
		]]
		UpdateRebirth_upvr(any_GetLink_result1_upvr.Money)
	end)
	any_new_result1.PromptRebirth = arg1.Confirm.MouseButton1Click:Connect(function() -- Line 25
		--[[ Upvalues[2]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		if any_GetLink_result1_upvr.Money < Util_upvr.GameMath:GetRebirthPrice(any_GetLink_result1_upvr.Rebirth) then
		else
			Util_upvr.PromptPurchase:Request("Rebirth "..(any_GetLink_result1_upvr.Rebirth + 1), Util_upvr.GameMath:GetRebirthPrice(any_GetLink_result1_upvr.Rebirth), function(arg1_3) -- Line 27
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				if arg1_3 and Util_upvr.Network:Invoke("Rebirth") then
					return true
				end
			end)
		end
	end)
	return any_new_result1
end
return module