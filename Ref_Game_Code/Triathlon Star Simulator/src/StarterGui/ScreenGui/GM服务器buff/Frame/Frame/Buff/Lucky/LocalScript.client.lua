-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:11
-- Luau version 6, Types version 3
-- Time taken: 0.000494 seconds

local Power_upvr = script.Parent.Parent.Power
local Gold_upvr = script.Parent.Parent.Gold
local Lucky_upvr = script.Parent.Parent.Lucky
local DMG_upvr = script.Parent.Parent.DMG
local BuffName_upvr = script.Parent.Parent.BuffName
script.Parent.MouseButton1Click:Connect(function() -- Line 10
	--[[ Upvalues[5]:
		[1]: Power_upvr (readonly)
		[2]: Gold_upvr (readonly)
		[3]: Lucky_upvr (readonly)
		[4]: DMG_upvr (readonly)
		[5]: BuffName_upvr (readonly)
	]]
	Power_upvr.Text = "Power"
	Gold_upvr.Text = "Gold"
	Lucky_upvr.Text = "Lucky".."√"
	DMG_upvr.Text = "DMG"
	BuffName_upvr.Value = "Lucky"
end)