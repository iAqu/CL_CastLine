-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:30
-- Luau version 6, Types version 3
-- Time taken: 0.001850 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("TieUtils")
function module.get(arg1, arg2, arg3, arg4, arg5) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	return function(arg1_2, ...) -- Line 12
		--[[ Upvalues[6]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
			[4]: arg4 (read and write)
			[5]: arg5 (readonly)
			[6]: var2_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 27 start (CF ANALYSIS FAILED)
		if arg1_2 ~= arg1 then
			error("Must call methods with self as first parameter (Hint use `%s:%s()` instead of `%s.%s()`)":format(arg2:GetName(), arg3:GetMemberName(), arg2:GetName(), arg3:GetMemberName()))
		end
		if arg4 and arg5 then
			if arg4.Parent ~= arg5 then
				error("Folder is not a parent of the adornee")
				-- KONSTANTWARNING: GOTO [64] #52
			end
			-- KONSTANTWARNING: GOTO [64] #52
		end
		-- KONSTANTERROR: [0] 1. Error Block 27 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [42] 33. Error Block 28 start (CF ANALYSIS FAILED)
		if arg4 then
			arg4 = arg4
		elseif arg5 then
			arg4 = arg5:FindFirstChild(arg2:GetContainerName())
			if not arg4 then
				error("No folder")
			end
		end
		local SOME_2 = arg4:FindFirstChild(arg3:GetMemberName())
		if not SOME_2 then
			error("No bindableFunction")
		end
		do
			return var2_upvr.decode(SOME_2:Invoke(var2_upvr.encode(...)))
		end
		-- KONSTANTERROR: [42] 33. Error Block 28 end (CF ANALYSIS FAILED)
	end
end
return module