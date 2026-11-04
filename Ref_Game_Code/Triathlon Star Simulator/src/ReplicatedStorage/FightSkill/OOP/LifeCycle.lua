-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:43
-- Luau version 6, Types version 3
-- Time taken: 0.000868 seconds

local module_upvr = {
	AllUpdate = {};
}
function module_upvr.Remove(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.AllUpdate[arg1] = nil
end
function module_upvr.Add(arg1) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1.LifeCycleStart ~= nil then
		arg1:LifeCycleStart()
	end
	if arg1.LifeCycleUpdate ~= nil then
		module_upvr.AllUpdate[arg1] = arg1
	end
	arg1.LifeCycleDestry = module_upvr.Remove
end
function module_upvr.Update(arg1) -- Line 30
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	for _, v in module_upvr.AllUpdate do
		v:LifeCycleUpdate(arg1)
	end
end
game:GetService("RunService").RenderStepped:Connect(module_upvr.Update)
return module_upvr