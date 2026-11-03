-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:51
-- Luau version 6, Types version 3
-- Time taken: 0.003713 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local Workspace_upvr = game:GetService("Workspace")
local RunService_upvr = game:GetService("RunService")
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Start(arg1) -- Line 9
	--[[ Upvalues[4]:
		[1]: Util_upvr (readonly)
		[2]: Workspace_upvr (readonly)
		[3]: RunService_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var14
	while not Util_upvr.Link:GetLink("Companions") and not var14 do
		var14 = Util_upvr.Link:GetRawLink("Companions")
	end
	local tbl_upvr = {}
	for i, v in pairs(var14) do
		(function(arg1_2, arg2) -- Line 21, Named "SetTroop"
			--[[ Upvalues[3]:
				[1]: tbl_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: Workspace_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [7] 6. Error Block 2 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [7] 6. Error Block 2 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [67] 50. Error Block 11 start (CF ANALYSIS FAILED)
			arg1_2.Parent = Workspace_upvr.Ignore
			-- KONSTANTERROR: [67] 50. Error Block 11 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [72] 53. Error Block 12 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [72] 53. Error Block 12 end (CF ANALYSIS FAILED)
		end)(i, v)
		local var19
	end
	Util_upvr.Link:GetLink("Companions").Changed:Connect(var19)
	RunService_upvr.Stepped:Connect(function(arg1_3, arg2) -- Line 85
		--[[ Upvalues[3]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: tbl_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		local Character = LocalPlayer_upvr.Character
		if Character then
			Character = LocalPlayer_upvr.Character:GetPivot()
		end
		if not Character then
		else
			local len = #tbl_upvr
			for i_2, v_2 in pairs(tbl_upvr) do
				local Object = v_2.Object
				if not Object or not Object.Parent then
					v_2.AlignOrientation.Enabled = false
				elseif Object:GetAttribute("Kicking") then
					v_2.AlignOrientation.Enabled = false
				else
					local var31 = Character * CFrame.Angles(0, math.pi / len * i_2 - math.pi / len / 2, 0) * CFrame.new(-5, 0, 0)
					local var32 = var31.Position - Object:GetPivot().Position
					local magnitude = var32.magnitude
					if magnitude <= 5 then
						v_2.AlignOrientation.Enabled = true
						v_2.TargetAttachment.CFrame = CFrame.new(var31.Position, var31.Position + Character.LookVector)
						v_2.Maid.WalkTo = nil
					elseif magnitude <= 30 then
						v_2.AlignOrientation.Enabled = false
						Object.Humanoid:MoveTo(var31.p)
						if 2 <= var32.y then
							Object.Humanoid.Jump = true
						end
						v_2.Maid.WalkTo = nil
					else
						v_2.AlignOrientation.Enabled = false
						if Object.Humanoid.RootPart then
							if v_2.Maid.WalkTo then
								if v_2.Maid.WalkTo:GetFailedToComputePath() then
									Object.Humanoid:MoveTo(var31.p)
									if 2 <= var32.y then
										Object.Humanoid.Jump = true
									end
									v_2.Maid.WalkTo = nil
								elseif v_2.Maid.WalkTo:PromiseFinished():IsPending() then
									v_2.Maid.WalkTo:SetTarget(var31.p)
								else
									v_2.Maid.WalkTo = Util_upvr.HumanoidWalkTo.new(Object.Humanoid, var31.p)
								end
							else
								v_2.Maid.WalkTo = Util_upvr.HumanoidWalkTo.new(Object.Humanoid, var31.p)
							end
						else
							v_2.Maid.WalkTo = nil
						end
					end
					if 120 < magnitude then
						Object:PivotTo(var31, Character)
					end
				end
			end
		end
	end)
end
return module