-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:33
-- Luau version 6, Types version 3
-- Time taken: 0.005772 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(function(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = Util_upvr.Maid.new()
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "Humanoid")
	any_new_result1_upvr_2:GiveTask(any_Sync_result1_2)
	any_new_result1_upvr_2.OnHumanoidLoad = any_Sync_result1_2.Loaded:Connect(function(arg1_2) -- Line 16
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		any_new_result1_upvr_2.Running = arg1_2.Running:Connect(function(arg1_3) -- Line 17
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: any_new_result1_upvr_2 (copied, readonly)
				[3]: Util_upvr (copied, readonly)
			]]
			if 12 < arg1_3 then
				local Position_upvw = arg1:GetPivot().Position
				any_new_result1_upvr_2.TrackRun = Util_upvr.Thread.Every(1, function() -- Line 21
					--[[ Upvalues[3]:
						[1]: Position_upvw (read and write)
						[2]: arg1 (copied, readonly)
						[3]: Util_upvr (copied, readonly)
					]]
					local Magnitude = (Position_upvw - arg1:GetPivot().Position).Magnitude
					Position_upvw = arg1:GetPivot().Position
					if 5 < Magnitude then
						Util_upvr.Network:Fire("TrackRunQuest", Magnitude)
					end
				end)
			else
				any_new_result1_upvr_2.TrackRun = nil
			end
		end)
	end)
end)
local tbl_upvr = {
	Time = function(arg1) -- Line 37, Named "Time"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		return Util_upvr.ValueConvertor:FormatTime(arg1)
	end;
	Default = function(arg1) -- Line 40, Named "Default"
		--[[ Upvalues[1]:
			[1]: Util_upvr (readonly)
		]]
		return Util_upvr.ValueConvertor:AddCommas(math.floor(arg1))
	end;
}
function module.Binder(arg1) -- Line 44
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local tbl_upvr_2 = {}
	for i = 1, 3 do
		local var18_upvw
		local var19_upvr = "QID"..i
		local var20_upvr = "QXP"..i
		local var21_upvr = "QMAX"..i
		local var22_upvr = "QueuedUpdate"..i
		local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "Content", 'Q'..i)
		any_new_result1_upvr:GiveTask(any_Sync_result1)
		any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_4) -- Line 81
			--[[ Upvalues[9]:
				[1]: var18_upvw (read and write)
				[2]: any_new_result1_upvr (readonly)
				[3]: var22_upvr (readonly)
				[4]: Util_upvr (copied, readonly)
				[5]: any_GetLink_result1_upvr (readonly)
				[6]: var19_upvr (readonly)
				[7]: var20_upvr (readonly)
				[8]: var21_upvr (readonly)
				[9]: tbl_upvr (copied, readonly)
			]]
			var18_upvw = arg1_4
			if not var18_upvw then
			else
				any_new_result1_upvr[var22_upvr] = Util_upvr.Thread.Delay(0.5, function() -- Line 60
					--[[ Upvalues[7]:
						[1]: any_GetLink_result1_upvr (copied, readonly)
						[2]: var19_upvr (copied, readonly)
						[3]: var20_upvr (copied, readonly)
						[4]: var21_upvr (copied, readonly)
						[5]: Util_upvr (copied, readonly)
						[6]: tbl_upvr (copied, readonly)
						[7]: var18_upvw (copied, read and write)
					]]
					-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
					local var32 = any_GetLink_result1_upvr.QData[var19_upvr]
					local var33 = any_GetLink_result1_upvr.QData[var20_upvr] or 0
					local var34 = any_GetLink_result1_upvr.QData[var21_upvr] or 1
					local var35
					if var32 then
						var35 = Util_upvr
						local any_GetChallengeData_result1 = var35.BattlePassChallenges:GetChallengeData(var32)
						local function INLINED_2() -- Internal function, doesn't exist in bytecode
							var35 = tbl_upvr[any_GetChallengeData_result1.FormatType]
							return var35
						end
						if not any_GetChallengeData_result1 or not any_GetChallengeData_result1.FormatType or not INLINED_2() then
							var35 = tbl_upvr.Default
						end
						if not any_GetChallengeData_result1 or not any_GetChallengeData_result1.Text then
						end
						var18_upvw.Description.Text = "Unassigned Quest (%s)":format("<b><font color=\"rgb(255,125,0)\">"..var35(var33)..'/'..var35(var34).."</font></b>")
						if not any_GetChallengeData_result1 or not any_GetChallengeData_result1.XP then
						end
						var18_upvw.XP.Text = Util_upvr.ValueConvertor:AddCommas(200).." BATTLE PASS XP"
						var18_upvw.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(var33 / var34, 0.025)
					end
				end)
			end
		end))
		tbl_upvr_2[#tbl_upvr_2 + 1] = function() -- Line 57, Named "Update"
			--[[ Upvalues[9]:
				[1]: var18_upvw (read and write)
				[2]: any_new_result1_upvr (readonly)
				[3]: var22_upvr (readonly)
				[4]: Util_upvr (copied, readonly)
				[5]: any_GetLink_result1_upvr (readonly)
				[6]: var19_upvr (readonly)
				[7]: var20_upvr (readonly)
				[8]: var21_upvr (readonly)
				[9]: tbl_upvr (copied, readonly)
			]]
			if not var18_upvw then
			else
				any_new_result1_upvr[var22_upvr] = Util_upvr.Thread.Delay(0.5, function() -- Line 60
					--[[ Upvalues[7]:
						[1]: any_GetLink_result1_upvr (copied, readonly)
						[2]: var19_upvr (copied, readonly)
						[3]: var20_upvr (copied, readonly)
						[4]: var21_upvr (copied, readonly)
						[5]: Util_upvr (copied, readonly)
						[6]: tbl_upvr (copied, readonly)
						[7]: var18_upvw (copied, read and write)
					]]
					-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
					local var24 = any_GetLink_result1_upvr.QData[var19_upvr]
					local var25 = any_GetLink_result1_upvr.QData[var20_upvr] or 0
					local var26 = any_GetLink_result1_upvr.QData[var21_upvr] or 1
					local var27
					if var24 then
						var27 = Util_upvr
						local any_GetChallengeData_result1_2 = var27.BattlePassChallenges:GetChallengeData(var24)
						local function INLINED() -- Internal function, doesn't exist in bytecode
							var27 = tbl_upvr[any_GetChallengeData_result1_2.FormatType]
							return var27
						end
						if not any_GetChallengeData_result1_2 or not any_GetChallengeData_result1_2.FormatType or not INLINED() then
							var27 = tbl_upvr.Default
						end
						if not any_GetChallengeData_result1_2 or not any_GetChallengeData_result1_2.Text then
						end
						var18_upvw.Description.Text = "Unassigned Quest (%s)":format("<b><font color=\"rgb(255,125,0)\">"..var27(var25)..'/'..var27(var26).."</font></b>")
						if not any_GetChallengeData_result1_2 or not any_GetChallengeData_result1_2.XP then
						end
						var18_upvw.XP.Text = Util_upvr.ValueConvertor:AddCommas(200).." BATTLE PASS XP"
						var18_upvw.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(var25 / var26, 0.025)
					end
				end)
			end
		end
	end
	any_new_result1_upvr:GiveTask(any_GetLink_result1_upvr.QData.Changed:Connect(function() -- Line 88, Named "UpdateQuests"
		--[[ Upvalues[1]:
			[1]: tbl_upvr_2 (readonly)
		]]
		for _, v in pairs(tbl_upvr_2) do
			v()
		end
	end))
	return any_new_result1_upvr
end
return module