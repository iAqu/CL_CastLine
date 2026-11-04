-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:56
-- Luau version 6, Types version 3
-- Time taken: 0.000632 seconds

local module = {
	updateUi = function(arg1, arg2) -- Line 4, Named "updateUi"
	end;
}
local Tips_upvr = script.Parent.BG.Tips
function module.openUi(arg1) -- Line 8
	--[[ Upvalues[1]:
		[1]: Tips_upvr (readonly)
	]]
	for _ = 1, 50 do
		Tips_upvr.Text = "Roblox will be updated soon..."
		wait(0.5)
		Tips_upvr.Text = "Roblox will be updated soon.."
		wait(0.5)
		Tips_upvr.Text = "Roblox will be updated soon."
		wait(0.5)
		Tips_upvr.Text = "Roblox will be updated soon"
		wait(0.5)
	end
end
function module.closeUi(arg1) -- Line 31
end
return module