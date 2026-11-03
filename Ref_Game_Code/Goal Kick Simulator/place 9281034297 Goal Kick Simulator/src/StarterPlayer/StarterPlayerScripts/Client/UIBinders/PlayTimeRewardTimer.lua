-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:58
-- Luau version 6, Types version 3
-- Time taken: 0.001511 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local function _(arg1_2) -- Line 12, Named "UpdateTime"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		if not arg1_2 or not (arg1_2 + 57600 - os.time()) then
			local const_number = 0
		end
		if 0 >= const_number or not "Available for "..Util_upvr.ValueConvertor:FormatTime(const_number) then
		end
		arg1.Text = "Rejoining will reset the progress!"
	end
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	any_new_result1.AutoUpdate = Util_upvr.Thread.Every(1, function() -- Line 17
		--[[ Upvalues[3]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local DailyPlayTimeStamp = any_GetLink_result1_upvr.DailyPlayTimeStamp
		local var9
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var9 = DailyPlayTimeStamp + 57600 - os.time()
			return var9
		end
		if not DailyPlayTimeStamp or not INLINED() then
			var9 = 0
		end
		if 0 >= var9 or not "Available for "..Util_upvr.ValueConvertor:FormatTime(var9) then
		end
		arg1.Text = "Rejoining will reset the progress!"
	end)
	return any_new_result1
end
return module