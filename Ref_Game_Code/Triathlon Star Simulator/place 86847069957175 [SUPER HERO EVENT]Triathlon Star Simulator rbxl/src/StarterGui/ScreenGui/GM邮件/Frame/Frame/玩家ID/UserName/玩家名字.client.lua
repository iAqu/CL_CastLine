-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:23
-- Luau version 6, Types version 3
-- Time taken: 0.000566 seconds

local TextBox_upvr = script.Parent.Parent.TextBox
local Parent_upvr = script.Parent
TextBox_upvr.InputEnded:Connect(function(arg1) -- Line 8
	--[[ Upvalues[2]:
		[1]: Parent_upvr (readonly)
		[2]: TextBox_upvr (readonly)
	]]
	Parent_upvr.Text = ""
	local tonumber_result1_upvr = tonumber(TextBox_upvr.Text)
	if not tonumber_result1_upvr then
	else
		local var5_upvw = ""
		local function _() -- Line 17
			--[[ Upvalues[2]:
				[1]: var5_upvw (read and write)
				[2]: tonumber_result1_upvr (readonly)
			]]
			var5_upvw = game.Players:GetNameFromUserIdAsync(tonumber_result1_upvr)
		end
		Parent_upvr.Text = var5_upvw
	end
end)