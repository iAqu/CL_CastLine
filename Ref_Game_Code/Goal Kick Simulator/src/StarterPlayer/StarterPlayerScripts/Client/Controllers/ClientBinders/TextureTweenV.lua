-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:58
-- Luau version 6, Types version 3
-- Time taken: 0.002447 seconds

local module = {}
local tbl_upvr = {}
require(game:GetService("ReplicatedStorage").Util).Thread.Every(0.25, function() -- Line 8
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local time_result1 = time()
	for i, v in pairs(tbl_upvr) do
		i.OffsetStudsV = time_result1 * v
	end
end)
function module.Binder(arg1) -- Line 15
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local SpeedV_5 = arg1:GetAttribute("SpeedV")
	if not SpeedV_5 then
		SpeedV_5 = arg1:GetAttribute("Speed")
		if not SpeedV_5 then
			SpeedV_5 = 1
		end
	end
	tbl_upvr[arg1] = SpeedV_5
	local any_Connect_result1_upvr_4 = arg1:GetAttributeChangedSignal("SpeedV"):Connect(function() -- Line 17
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local SpeedV_2 = arg1:GetAttribute("SpeedV")
		if not SpeedV_2 then
			SpeedV_2 = arg1:GetAttribute("Speed")
			if not SpeedV_2 then
				SpeedV_2 = 1
			end
		end
		tbl_upvr[arg1] = SpeedV_2
	end)
	local any_Connect_result1_upvr = arg1:GetAttributeChangedSignal("Speed"):Connect(function() -- Line 20
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local SpeedV = arg1:GetAttribute("SpeedV")
		if not SpeedV then
			SpeedV = arg1:GetAttribute("Speed")
			if not SpeedV then
				SpeedV = 1
			end
		end
		tbl_upvr[arg1] = SpeedV
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