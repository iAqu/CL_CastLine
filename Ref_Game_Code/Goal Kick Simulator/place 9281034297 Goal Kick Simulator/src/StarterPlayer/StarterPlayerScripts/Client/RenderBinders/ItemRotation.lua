-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:34
-- Luau version 6, Types version 3
-- Time taken: 0.000915 seconds

local module = {}
local tbl_upvr = {}
local clock_upvr = os.clock
game:GetService("RunService").Heartbeat:Connect(function() -- Line 11
	--[[ Upvalues[2]:
		[1]: clock_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	debug.profilebegin("[PowerUpDrop/Step]")
	local cframe = CFrame.Angles(0, clock_upvr() * math.pi * 2, 0)
	for i, v in pairs(tbl_upvr) do
		i:PivotTo(v * cframe)
	end
	debug.profileend()
end)
function module.Binder(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	tbl_upvr[arg1] = arg1:GetPivot()
	return function() -- Line 23
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = nil
	end
end
return module