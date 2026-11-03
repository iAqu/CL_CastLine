-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:27
-- Luau version 6, Types version 3
-- Time taken: 0.003268 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
function module_upvr.Binder(arg1) -- Line 5
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 16 start (CF ANALYSIS FAILED)
	local any_new_result1 = Util_upvr.Maid.new()
	local any_GetLink_result1_2 = Util_upvr.Link:GetLink("ServerData")
	local GiftingTo_2 = any_GetLink_result1_2.GiftingTo
	if GiftingTo_2 then
		local var15
		if GiftingTo_2.Parent then
			arg1.Select.Title.Text = "Clear"
			local function INLINED_4() -- Internal function, doesn't exist in bytecode
				var15 = " (@"..GiftingTo_2.Name..')'
				return var15
			end
			if GiftingTo_2.Name == GiftingTo_2.DisplayName or not INLINED_4() then
				var15 = ""
			end
			arg1.SelectionName.Text = GiftingTo_2.DisplayName..var15
			-- KONSTANTWARNING: GOTO [62] #42
		end
	end
	arg1.SelectionName.Text = "*NONE"
	arg1.Select.Title.Text = "Change"
	-- KONSTANTERROR: [0] 1. Error Block 16 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [62] 42. Error Block 10 start (CF ANALYSIS FAILED)
	module_upvr.SelectedPlayer = GiftingTo_2
	any_new_result1.TrackPickedGifting = any_GetLink_result1_2.Changed:On("GiftingTo", function(arg1_3) -- Line 10, Named "UpdateSelect"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: module_upvr (copied, readonly)
		]]
		if not arg1_3 then
			-- KONSTANTWARNING: GOTO [34] #24
		end
		if not arg1_3.Parent then
			-- KONSTANTWARNING: GOTO [34] #24
		end
		arg1.Select.Title.Text = "Clear"
		if arg1_3.Name ~= arg1_3.DisplayName then
			local var13 = " (@"..arg1_3.Name..')'
			if not var13 then
				var13 = ""
			end
			arg1.SelectionName.Text = arg1_3.DisplayName..var13
			-- KONSTANTWARNING: GOTO [48] #33
		end
	end)
	any_new_result1.OnSelect = arg1.Select.MouseButton1Down:Connect(function() -- Line 22
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		if module_upvr.SelectedPlayer then
			Util_upvr.Network:Fire("SelectGiftGamePassReceiver")
		elseif not Util_upvr.Network:Invoke("SelectGiftGamePassReceiver", Util_upvr.PlayerPick:SelectPlayer()) then
			Util_upvr.Sounds:Play("BuyFailed")
		end
	end)
	do
		return any_new_result1
	end
	-- KONSTANTERROR: [62] 42. Error Block 10 end (CF ANALYSIS FAILED)
end
Util_upvr.GiftSelection = module_upvr
return module_upvr