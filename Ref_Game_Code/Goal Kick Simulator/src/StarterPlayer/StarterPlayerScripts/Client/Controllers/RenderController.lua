-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:42
-- Luau version 6, Types version 3
-- Time taken: 0.002773 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
module_upvr.RenderDistance = 70
module_upvr.RenderDistanceRadius = 280
function module_upvr.SetRenderDistance(arg1, arg2) -- Line 11
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.RenderDistance = arg2 * 2
	module_upvr.RenderDistanceRadius = arg2
end
local CurrentCamera_upvr = Util_upvr.CurrentCamera
function module_upvr.Start(arg1) -- Line 16
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: CurrentCamera_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	Util_upvr.Binder.new("Render_ActiveRendering", function(arg1_2) -- Line 19
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: CurrentCamera_upvr (copied, readonly)
			[3]: module_upvr (copied, readonly)
		]]
		local any_new_result1 = Util_upvr.Maid.new()
		local tbl_upvr = {}
		any_new_result1:GiveTask(Util_upvr.Thread.Loop(function() -- Line 23
			--[[ Upvalues[4]:
				[1]: arg1_2 (readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: module_upvr (copied, readonly)
				[4]: tbl_upvr (readonly)
			]]
			local Position_2 = arg1_2:GetPivot().Position
			if not Position_2 then
				task.wait(1)
			else
				local Position = CurrentCamera_upvr.CFrame.Position
				if (Position - Vector3.new(Position_2.X, Position.Y, Position_2.Z)).Magnitude < module_upvr.RenderDistanceRadius then
					arg1_2:SetAttribute("RenderActive", true)
					tbl_upvr[arg1_2] = function() -- Line 29
						--[[ Upvalues[1]:
							[1]: arg1_2 (copied, readonly)
						]]
						arg1_2:SetAttribute("RenderActive", false)
					end
				elseif next(tbl_upvr) then
					while next(tbl_upvr) do
						local next_result1, next_result2 = next(tbl_upvr)
						next_result2()
						tbl_upvr[next_result1] = nil
					end
				end
				task.wait(1)
			end
		end))
		return any_new_result1
	end):Start()
	for _, v in pairs(script.Parent.Parent.RenderBinders:GetChildren()) do
		local v_2 = require(v)
		setmetatable(v_2, getmetatable(module_upvr))
		local Name_upvr = v.Name
		local Binder_upvr = v_2.Binder
		task.spawn(function() -- Line 52
			--[[ Upvalues[3]:
				[1]: Name_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: Binder_upvr (readonly)
			]]
			local var22_upvr = "REN__"..Name_upvr
			Util_upvr.Binder.new("Render_"..Name_upvr, function(arg1_3) -- Line 54
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: var22_upvr (readonly)
				]]
				local any_new_result1_upvr = Util_upvr.Maid.new()
				local function CheckParent() -- Line 56
					--[[ Upvalues[4]:
						[1]: arg1_3 (readonly)
						[2]: any_new_result1_upvr (readonly)
						[3]: Util_upvr (copied, readonly)
						[4]: var22_upvr (copied, readonly)
					]]
					if not any_new_result1_upvr.HasTag and arg1_3:GetAttribute("RenderActive") then
						Util_upvr.CollectionService:AddTag(arg1_3, var22_upvr)
						function any_new_result1_upvr.HasTag() -- Line 60
							--[[ Upvalues[3]:
								[1]: Util_upvr (copied, readonly)
								[2]: arg1_3 (copied, readonly)
								[3]: var22_upvr (copied, readonly)
							]]
							Util_upvr.CollectionService:RemoveTag(arg1_3, var22_upvr)
						end
					elseif any_new_result1_upvr.HasTag then
						-- KONSTANTERROR: Expression was reused, decompilation is incorrect
						if not arg1_3:GetAttribute("RenderActive") then
							any_new_result1_upvr.HasTag = nil
						end
					end
				end
				any_new_result1_upvr:GiveTask(arg1_3:GetAttributeChangedSignal("RenderActive"):Connect(CheckParent))
				CheckParent()
				return any_new_result1_upvr
			end):Start()
			Util_upvr.Binder.new(var22_upvr, Binder_upvr):Start()
		end)
	end
end
Util_upvr.Render = module_upvr
return module_upvr