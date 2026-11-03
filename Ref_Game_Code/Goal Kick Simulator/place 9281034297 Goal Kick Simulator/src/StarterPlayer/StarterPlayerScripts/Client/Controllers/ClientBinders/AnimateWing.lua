-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:56
-- Luau version 6, Types version 3
-- Time taken: 0.000758 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local Animation_upvr = Instance.new("Animation")
	Animation_upvr.AnimationId = "rbxassetid://9234073712"
	Animation_upvr.Parent = arg1
	local any_Play_result1_upvr = arg1:WaitForChild("Humanoid"):LoadAnimation(Animation_upvr):Play()
	any_new_result1:GiveTask(function() -- Line 16
		--[[ Upvalues[2]:
			[1]: any_Play_result1_upvr (readonly)
			[2]: Animation_upvr (readonly)
		]]
		any_Play_result1_upvr:Stop()
		Animation_upvr:Destroy()
	end)
	return any_new_result1
end
return module