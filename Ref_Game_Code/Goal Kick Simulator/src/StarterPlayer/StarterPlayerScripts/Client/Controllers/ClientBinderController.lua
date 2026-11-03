-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:45
-- Luau version 6, Types version 3
-- Time taken: 0.001563 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module_upvr.PostRun(arg1) -- Line 6
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	for _, v in pairs(script.Parent.ClientBinders:GetChildren()) do
		local v_2 = require(v)
		setmetatable(v_2, getmetatable(module_upvr))
		local Name_upvr = v.Name
		local Binder_upvr = v_2.Binder
		task.spawn(function() -- Line 14
			--[[ Upvalues[4]:
				[1]: Name_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: LocalPlayer_upvr (copied, readonly)
				[4]: Binder_upvr (readonly)
			]]
			local var13_upvr = "CB_"..Name_upvr
			Util_upvr.Binder.new(Name_upvr, function(arg1_2) -- Line 16
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: LocalPlayer_upvr (copied, readonly)
					[3]: var13_upvr (readonly)
				]]
				local any_new_result1_upvr = Util_upvr.Maid.new()
				local function CheckParent() -- Line 18
					--[[ Upvalues[5]:
						[1]: any_new_result1_upvr (readonly)
						[2]: arg1_2 (readonly)
						[3]: LocalPlayer_upvr (copied, readonly)
						[4]: Util_upvr (copied, readonly)
						[5]: var13_upvr (copied, readonly)
					]]
					-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [27] 21. Error Block 13 start (CF ANALYSIS FAILED)
					Util_upvr.CollectionService:AddTag(arg1_2, var13_upvr)
					function any_new_result1_upvr.HasTag() -- Line 22
						--[[ Upvalues[3]:
							[1]: Util_upvr (copied, readonly)
							[2]: arg1_2 (copied, readonly)
							[3]: var13_upvr (copied, readonly)
						]]
						Util_upvr.CollectionService:RemoveTag(arg1_2, var13_upvr)
					end
					do
						return
					end
					-- KONSTANTERROR: [27] 21. Error Block 13 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [43] 34. Error Block 12 start (CF ANALYSIS FAILED)
					if not arg1_2:IsDescendantOf(workspace) and arg1_2:IsDescendantOf(LocalPlayer_upvr) and arg1_2:IsDescendantOf(Util_upvr.ReplicatedStorage.BinderWorkspace) then
						any_new_result1_upvr.HasTag = nil
					end
					-- KONSTANTERROR: [43] 34. Error Block 12 end (CF ANALYSIS FAILED)
				end
				any_new_result1_upvr:GiveTask(arg1_2.AncestryChanged:Connect(CheckParent))
				CheckParent()
				return any_new_result1_upvr
			end):Start()
			Util_upvr.Binder.new(var13_upvr, Binder_upvr):Start()
		end)
		if v_2.Start then
			v_2:Start()
		end
	end
end
return module_upvr