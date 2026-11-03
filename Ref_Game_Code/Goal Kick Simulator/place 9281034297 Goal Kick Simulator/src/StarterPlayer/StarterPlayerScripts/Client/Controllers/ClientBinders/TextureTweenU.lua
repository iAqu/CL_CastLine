-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:57
-- Luau version 6, Types version 3
-- Time taken: 0.002502 seconds

local module = {}
local tbl_upvr = {}
require(game:GetService("ReplicatedStorage").Util).Thread.Every(0.25, function() -- Line 8
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local os_clock_result1 = os.clock()
	for i, v in pairs(tbl_upvr) do
		i.OffsetStudsU = os_clock_result1 * v
	end
end)
function module.Binder(arg1) -- Line 15
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local SpeedU_5 = arg1:GetAttribute("SpeedU")
	if not SpeedU_5 then
		SpeedU_5 = arg1:GetAttribute("Speed")
		if not SpeedU_5 then
			SpeedU_5 = 1
		end
	end
	tbl_upvr[arg1] = SpeedU_5
	local any_Connect_result1_upvr_4 = arg1:GetAttributeChangedSignal("SpeedU"):Connect(function() -- Line 17
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local SpeedU_2 = arg1:GetAttribute("SpeedU")
		if not SpeedU_2 then
			SpeedU_2 = arg1:GetAttribute("Speed")
			if not SpeedU_2 then
				SpeedU_2 = 1
			end
		end
		tbl_upvr[arg1] = SpeedU_2
	end)
	local any_Connect_result1_upvr = arg1:GetAttributeChangedSignal("Speed"):Connect(function() -- Line 20
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local SpeedU = arg1:GetAttribute("SpeedU")
		if not SpeedU then
			SpeedU = arg1:GetAttribute("Speed")
			if not SpeedU then
				SpeedU = 1
			end
		end
		tbl_upvr[arg1] = SpeedU
	end)
	return function() -- Line 23
		--[[ Upvalues[4]:
			[1]: any_Connect_result1_upvr_4 (readonly)
			[2]: any_Connect_result1_upvr (readonly)
			[3]: tbl_upvr (copied, readonly)
			[4]: arg1 (readonly)
		]]
		any_Connect_result1_upvr_4:Disconnect()
		any_Connect_result1_upvr:Disconnect()
		tbl_upvr[arg1] = nil
	end
end
return module