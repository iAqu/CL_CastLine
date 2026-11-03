-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:35
-- Luau version 6, Types version 3
-- Time taken: 0.000799 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
return {
	Binder = function(arg1) -- Line 7
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		local any_new_result1 = Util_upvr.Maid.new()
		local Transparency_upvw = arg1.Transparency
		arg1.Transparency = -1
		any_new_result1:GiveTask(arg1:GetPropertyChangedSignal("Transparency"):Connect(function() -- Line 13
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: Transparency_upvw (read and write)
			]]
			if arg1.Transparency ~= -1 then
				Transparency_upvw = arg1.Transparency
			end
		end))
		any_new_result1:GiveTask(function() -- Line 19
			--[[ Upvalues[3]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: Transparency_upvw (read and write)
			]]
			Util_upvr.Thread.LoopFor(0.2, function(arg1_2) -- Line 20
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: Transparency_upvw (copied, read and write)
				]]
				debug.profilebegin("LoopTransparency")
				arg1.Transparency = Transparency_upvw * arg1_2
				debug.profileend()
			end)
		end)
		return any_new_result1
	end;
}