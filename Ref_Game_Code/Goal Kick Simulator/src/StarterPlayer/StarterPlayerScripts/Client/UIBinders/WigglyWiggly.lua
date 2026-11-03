-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:08
-- Luau version 6, Types version 3
-- Time taken: 0.001190 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_upvr = {}
Util_upvr.RunService.Heartbeat:Connect(function() -- Line 8
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if next(tbl_upvr) then
		for i, v in pairs(tbl_upvr) do
			if v then
				i.Rotation = math.sin(os.clock() * math.pi * 2) * 15
			end
		end
	end
end)
function module.Binder(arg1) -- Line 19
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.CheckIfVisible = arg1:GetPropertyChangedSignal("Visible"):Connect(function() -- Line 22
		--[[ Upvalues[3]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		tbl_upvr[arg1] = Util_upvr:IsGuiObjectVisible(arg1)
	end)
	tbl_upvr[arg1] = Util_upvr:IsGuiObjectVisible(arg1)
	function any_new_result1.Remove() -- Line 27
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_upvr[arg1] = nil
	end
	return any_new_result1
end
return module