-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:18
-- Luau version 6, Types version 3
-- Time taken: 0.000676 seconds

local Progress_upvr = script.Parent.Progress
local UIGradient_upvr_2 = script.Parent.Bar1.Frame.UIGradient
local UIGradient_upvr = script.Parent.Bar2.Frame.UIGradient
require(game.ReplicatedStorage.Tool.AddListen).NumValueAdd(Progress_upvr, function() -- Line 10
	--[[ Upvalues[3]:
		[1]: Progress_upvr (readonly)
		[2]: UIGradient_upvr_2 (readonly)
		[3]: UIGradient_upvr (readonly)
	]]
	local var5 = 360 * Progress_upvr.Value
	if var5 <= 0 then
		UIGradient_upvr_2.Parent.Parent.Visible = false
		UIGradient_upvr.Parent.Parent.Visible = false
	else
		if var5 <= 180 then
			UIGradient_upvr_2.Parent.Parent.Visible = true
			UIGradient_upvr.Parent.Parent.Visible = false
			UIGradient_upvr_2.Rotation = 180 - var5
			return
		end
		UIGradient_upvr_2.Parent.Parent.Visible = true
		UIGradient_upvr.Parent.Parent.Visible = true
		UIGradient_upvr_2.Rotation = 0
		UIGradient_upvr.Rotation = -var5
	end
end)