-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:04
-- Luau version 6, Types version 3
-- Time taken: 0.000886 seconds

local module = {}
local var2_upvw = false
if game:GetService("RunService"):IsStudio() == true or require(game:GetService("ReplicatedStorage").Tool.WorldUtil).GetTestOrPublic() == "开发服" then
	var2_upvw = true
end
function module.print(...) -- Line 13
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	if var2_upvw then
		print(...)
	end
end
function module.warn(...) -- Line 19
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	if var2_upvw then
		warn(...)
	end
end
function module.printf(arg1, ...) -- Line 25
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	if var2_upvw then
		print(string.format(arg1, ...))
	end
end
function module.isDebug() -- Line 31
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	return var2_upvw
end
return module