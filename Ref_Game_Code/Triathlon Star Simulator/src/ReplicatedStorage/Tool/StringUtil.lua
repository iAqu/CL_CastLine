-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:28
-- Luau version 6, Types version 3
-- Time taken: 0.001198 seconds

local module = {
	Split = function(arg1, arg2) -- Line 9, Named "Split"
		local module_upvr = {}
		string.gsub(arg1, "[^"..arg2.."]+", function(arg1_2) -- Line 11
			--[[ Upvalues[1]:
				[1]: module_upvr (readonly)
			]]
			module_upvr[#module_upvr + 1] = arg1_2
		end)
		return module_upvr
	end;
}
local ConstString_upvr = require(game:GetService("ReplicatedStorage").ConstString)
function module.FormatByKey(arg1, ...) -- Line 17
	--[[ Upvalues[1]:
		[1]: ConstString_upvr (readonly)
	]]
	local var5 = ConstString_upvr[arg1]
	if not var5 then
		warn("本地化文本错误:", arg1)
		return arg1
	end
	return string.format(var5, ...)
end
function module.CheckGuildName(arg1) -- Line 27
	-- KONSTANTERROR: [0] 1. Error Block 15 start (CF ANALYSIS FAILED)
	if 16 < #arg1 then
		return false
	end
	-- KONSTANTERROR: [0] 1. Error Block 15 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [22] 19. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [22] 19. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 15. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [22.6]
	-- KONSTANTERROR: [16] 15. Error Block 4 end (CF ANALYSIS FAILED)
end
function module.CheckIconURL(arg1) -- Line 51
	if not string.find(arg1, "roblox.com") then
		return false, 1
	end
	local string_match_result1 = string.match(arg1, "%d+")
	if not string_match_result1 then
		return false, 2
	end
	return true, string_match_result1
end
return module