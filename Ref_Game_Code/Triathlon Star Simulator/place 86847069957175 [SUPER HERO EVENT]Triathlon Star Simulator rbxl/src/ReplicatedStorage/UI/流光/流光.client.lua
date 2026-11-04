-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:38
-- Luau version 6, Types version 3
-- Time taken: 0.001663 seconds

local RunService_upvr = game:GetService("RunService")
local Parent = script.Parent
;(function(arg1, arg2, arg3, arg4, arg5) -- Line 3, Named "AddStreamer"
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local Parent_2_upvr = script.Parent
	local tbl = {
		[#tbl + 1] = ColorSequenceKeypoint.new(0, arg1);
		[#tbl + 1] = ColorSequenceKeypoint.new(1, arg1);
	}
	Parent_2_upvr.Color = ColorSequence.new(tbl)
	local var5_upvw = 0
	local var6_upvr = (arg2 - arg3) / 2
	local function _(arg1_2) -- Line 15
		--[[ Upvalues[7]:
			[1]: var5_upvw (read and write)
			[2]: arg4 (readonly)
			[3]: arg5 (readonly)
			[4]: arg2 (readonly)
			[5]: var6_upvr (readonly)
			[6]: arg3 (readonly)
			[7]: Parent_2_upvr (readonly)
		]]
		var5_upvw += arg1_2
		if var5_upvw <= arg4 + arg5 then
			local tbl_2 = {}
			local var8 = var5_upvw / arg4
			tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(0, 1, 0)
			if arg2 < var8 and var8 < 1 + arg2 then
				tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(var8 - arg2, 1, 0)
			end
			if var6_upvr + arg3 < var8 and var8 < 1 + var6_upvr + arg3 then
				tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(var8 - var6_upvr - arg3, 0.5, 0)
			end
			if var6_upvr < var8 and var8 < 1 + var6_upvr then
				tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(var8 - var6_upvr, 0.5, 0)
			end
			if 0 < var8 and var8 < 1 then
				tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(var8, 1, 0)
			end
			tbl_2[#tbl_2 + 1] = NumberSequenceKeypoint.new(1, 1, 0)
			Parent_2_upvr.Transparency = NumberSequence.new(tbl_2)
		else
			var5_upvw = 0
		end
	end
end)(Color3.fromHex(Parent:GetAttribute("hex")), Parent:GetAttribute("max"), Parent:GetAttribute("min"), Parent:GetAttribute("duration"), Parent:GetAttribute("cd"))