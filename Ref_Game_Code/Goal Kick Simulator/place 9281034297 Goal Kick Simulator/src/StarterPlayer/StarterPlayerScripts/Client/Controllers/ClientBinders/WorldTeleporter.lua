-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:02
-- Luau version 6, Types version 3
-- Time taken: 0.001652 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 18 start (CF ANALYSIS FAILED)
	local Display_upvr = arg1:WaitForChild("Display")
	local function _(arg1_2) -- Line 11, Named "UpdatePurchased"
		--[[ Upvalues[1]:
			[1]: Display_upvr (readonly)
		]]
		Display_upvr.Enabled = not arg1_2
	end
	Util_upvr.Maid.new().PromptPurchase = arg1.Touched:Connect(function(arg1_3) -- Line 17
		--[[ Upvalues[4]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: Display_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		if arg1_3:IsDescendantOf(LocalPlayer_upvr.Character) and Display_upvr.Enabled then
			Util_upvr.PromptPurchase:Request(arg1.Name, arg1:GetAttribute("Price") or 1000000, function(arg1_4) -- Line 21
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				if arg1_4 and Util_upvr.Network:Invoke("UnlockArea", arg1) then
					return true
				end
			end)
			return
		end
	end)
	local tbl = {
		Common = 1;
		Rare = 1.1;
		Epic = 1.25;
		Legendary = 1.5;
	}
	local pairs_result1, pairs_result2, pairs_result3 = pairs(game.Selection:Get())
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [72.12]
	if not game.ReplicatedStorage.Assets.Chests:FindFirstChild(nil.Name) then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		warn("no chest data found for", nil.Name)
		-- KONSTANTWARNING: GOTO [71] #48
	end
	-- KONSTANTERROR: [0] 1. Error Block 18 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [95] 66. Error Block 13 start (CF ANALYSIS FAILED)
	for _, _ in warn("no chest data found for", nil.Name), "no chest data found for", nil.Name do
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [150.21]
		if nil then
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x2)
	end
	-- KONSTANTERROR: [95] 66. Error Block 13 end (CF ANALYSIS FAILED)
end
return module