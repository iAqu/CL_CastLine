-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:07
-- Luau version 6, Types version 3
-- Time taken: 0.001091 seconds

local module = {}
local Workspace_upvr = game:GetService("Workspace")
local RunService_upvr = game:GetService("RunService")
function module.reparentFromWorkspaceIfNeeded(arg1, arg2) -- Line 11
	--[[ Upvalues[2]:
		[1]: Workspace_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local var4
	if typeof(arg1) ~= "Instance" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad parent")
	if type(arg2) ~= "string" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad name")
	local SOME = Workspace_upvr:FindFirstChild(arg2)
	var4 = arg1:FindFirstChild(arg2)
	if SOME then
		if var4 then
			error("Duplicate container in %q and %q":format(SOME:GetFullName(), var4:GetFullName()))
		end
		if RunService_upvr:IsRunning() then
			SOME.Parent = arg1
		end
		return SOME
	end
	if not var4 then
		error("No template container with name %q in %q":format(arg1:GetFullName(), arg2))
	end
	return var4
end
return module