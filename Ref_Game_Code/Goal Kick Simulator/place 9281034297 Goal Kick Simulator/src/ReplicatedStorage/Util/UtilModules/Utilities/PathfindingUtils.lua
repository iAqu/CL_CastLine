-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:39
-- Luau version 6, Types version 3
-- Time taken: 0.001667 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise_upvr = require(ReplicatedStorage.ChiefUtils.Utilities.Promise)
local module = {
	promiseComputeAsync = function(arg1, arg2, arg3) -- Line 21, Named "promiseComputeAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		assert(arg1, "Bad path")
		assert(arg2, "Bad start")
		assert(arg3, "Bad finish")
		return Promise_upvr.spawn(function(arg1_2, arg2_2) -- Line 26
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: arg3 (readonly)
			]]
			local pcall_result1, pcall_result2 = pcall(function() -- Line 27
				--[[ Upvalues[3]:
					[1]: arg1 (copied, readonly)
					[2]: arg2 (copied, readonly)
					[3]: arg3 (copied, readonly)
				]]
				arg1:ComputeAsync(arg2, arg3)
			end)
			if not pcall_result1 then
				arg2_2(pcall_result2 or "Failed to compute path")
				return
			end
			return arg1_2(arg1)
		end)
	end;
	promiseCheckOcclusion = function(arg1, arg2) -- Line 45, Named "promiseCheckOcclusion"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		return Promise_upvr.spawn(function(arg1_3, arg2_3) -- Line 46
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			arg1_3(arg1:CheckOcclusionAsync(arg2))
		end)
	end;
}
local Maid_upvr = require(ReplicatedStorage.ChiefUtils.Utilities.Maid)
local Draw_upvr = require(script.Parent.Draw)
function module.visualizePath(arg1) -- Line 58
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: Draw_upvr (readonly)
	]]
	local any_new_result1 = Maid_upvr.new()
	local Folder = Instance.new("Folder")
	Folder.Name = "PathVisualization"
	any_new_result1:GiveTask(Folder)
	for i, v in pairs(arg1:GetWaypoints()) do
		if v.Action == Enum.PathWaypointAction.Walk then
			local any_point_result1_2 = Draw_upvr.point(v.Position, Color3.new(0.5, 1, 0.5), Folder)
			any_point_result1_2.Name = "%03d_WalkPoint":format(i)
			any_new_result1:GiveTask(any_point_result1_2)
		elseif v.Action == Enum.PathWaypointAction.Jump then
			local any_point_result1 = Draw_upvr.point(v.Position, Color3.new(0.5, 0.5, 1), Folder)
			any_point_result1.Name = "%03d_JumpPoint":format(i)
			any_new_result1:GiveTask(any_point_result1)
		end
	end
	Folder.Parent = Draw_upvr.getDefaultParent()
	return any_new_result1
end
return module