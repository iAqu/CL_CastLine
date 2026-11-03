-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:34
-- Luau version 6, Types version 3
-- Time taken: 0.001301 seconds

local module = {}
local tbl_upvr = {
	Secret = "<font color = \"#555555\">???:</font>";
	Legendary = "<font color = \"#ff5826\">Legendary:</font>";
	Epic = "<font color = \"#8241c3\">Epic:</font>";
	Rare = "<font color = \"#2b9cbe\">Rare:</font>";
	Common = "<font color = \"#a2a2a2\">Common:</font>";
}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 13
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	for _, v_upvr in pairs(Util_upvr.ItemData.Products.Crates) do
		if v_upvr.ID == arg1.Name then
			Util_upvr.Maid.new().Submit = arg1.MouseButton1Click:Connect(function() -- Line 18
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: v_upvr (readonly)
					[3]: tbl_upvr (copied, readonly)
				]]
				local any_GetPercentageTable_result1 = Util_upvr.ValueConvertor:GetPercentageTable(v_upvr.Content)
				local var16 = "Chances ("..Util_upvr.ValueConvertor:ShrinkNumber(v_upvr.Cards).." Cards):"
				for _, v_2 in pairs({"Secret", "Legendary", "Epic", "Rare", "Common"}) do
					var16 = var16..'\n'..tbl_upvr[v_2]..' '..(any_GetPercentageTable_result1[v_2] * 100)..'%'
				end
				Util_upvr.Windows:PromptNotification({
					Text = var16;
				})
			end)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return Util_upvr.Maid.new()
end
return module