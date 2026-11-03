-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:41
-- Luau version 6, Types version 3
-- Time taken: 0.028075 seconds

local module_2_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Util_upvr = require(ReplicatedStorage.Util)
local ChestModels_upvr = ReplicatedStorage.Assets.ChestModels
local new_upvr = CFrame.new
local Angles_upvr = CFrame.Angles
local sin_upvr = math.sin
local new_upvr_2 = Vector3.new
local function CreateChest_upvr(arg1, arg2) -- Line 15, Named "CreateChest"
	--[[ Upvalues[6]:
		[1]: Util_upvr (readonly)
		[2]: ChestModels_upvr (readonly)
		[3]: new_upvr (readonly)
		[4]: Angles_upvr (readonly)
		[5]: sin_upvr (readonly)
		[6]: new_upvr_2 (readonly)
	]]
	local any_new_result1_upvr_4 = Util_upvr.Maid.new()
	local SOME = ChestModels_upvr:FindFirstChild(arg1)
	if not SOME then
		SOME = ChestModels_upvr.Default
	end
	local clone_upvw = SOME:Clone()
	local var12 = arg2
	if not var12 then
		var12 = clone_upvw.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
	end
	clone_upvw:PivotTo(var12)
	local module = {
		Maid = any_new_result1_upvr_4;
		Destroy = function() -- Line 25, Named "Destroy"
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr_4 (readonly)
			]]
			any_new_result1_upvr_4:Destroy()
		end;
		Model = clone_upvw;
	}
	local Top_upvr = clone_upvw.Top
	local any_GetPivot_result1_upvr_4 = clone_upvw:GetPivot()
	local Offset = Top_upvr:FindFirstChild("Offset", true)
	local Offset_2 = clone_upvw.Base:FindFirstChild("Offset", true)
	local var18_upvr = new_upvr(Offset_2.Position) * Angles_upvr(math.rad(Offset_2.Orientation.X), math.rad(Offset_2.Orientation.Y), math.rad(Offset_2.Orientation.Z)):Inverse()
	local var19_upvr = new_upvr(-Offset.Position) * Angles_upvr(math.rad(Offset.Orientation.X), math.rad(Offset.Orientation.Y), math.rad(Offset.Orientation.Z)):Inverse()
	function module.Spawn(arg1_2, arg2_2) -- Line 41
		--[[ Upvalues[10]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: sin_upvr (copied, readonly)
			[4]: any_GetPivot_result1_upvr_4 (readonly)
			[5]: new_upvr (copied, readonly)
			[6]: Angles_upvr (copied, readonly)
			[7]: Top_upvr (readonly)
			[8]: var18_upvr (readonly)
			[9]: var19_upvr (readonly)
			[10]: clone_upvw (read and write)
		]]
		any_new_result1_upvr_4.CurrentAnimation = Util_upvr.Thread.LoopFor(arg2_2 or 0.5, function(arg1_3) -- Line 43
			--[[ Upvalues[8]:
				[1]: sin_upvr (copied, readonly)
				[2]: any_GetPivot_result1_upvr_4 (copied, readonly)
				[3]: new_upvr (copied, readonly)
				[4]: Angles_upvr (copied, readonly)
				[5]: Top_upvr (copied, readonly)
				[6]: var18_upvr (copied, readonly)
				[7]: var19_upvr (copied, readonly)
				[8]: clone_upvw (copied, read and write)
			]]
			local var7_result1 = sin_upvr(arg1_3 * math.pi)
			local var22 = any_GetPivot_result1_upvr_4 * new_upvr(0, var7_result1 * 2, sin_upvr(arg1_3 * math.pi / 2) * 4 - 4) * Angles_upvr(-var7_result1 / 5, 0, 0)
			Top_upvr:PivotTo((var22) * (var18_upvr * Angles_upvr(-var7_result1 / 2, 0, 0)) * var19_upvr)
			clone_upvw:PivotTo(var22)
		end)
		return any_new_result1_upvr_4.CurrentAnimation
	end
	function module.PlayIdle(arg1_4, arg2_3) -- Line 53
		--[[ Upvalues[9]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: any_GetPivot_result1_upvr_4 (readonly)
			[4]: new_upvr (copied, readonly)
			[5]: Top_upvr (readonly)
			[6]: var18_upvr (readonly)
			[7]: Angles_upvr (copied, readonly)
			[8]: var19_upvr (readonly)
			[9]: clone_upvw (read and write)
		]]
		local var24_upvw = 0
		local var25_upvw = arg2_3 or 1
		any_new_result1_upvr_4.CurrentAnimation = Util_upvr.Thread.Loop(function(arg1_5) -- Line 56
			--[[ Upvalues[9]:
				[1]: var24_upvw (read and write)
				[2]: var25_upvw (read and write)
				[3]: any_GetPivot_result1_upvr_4 (copied, readonly)
				[4]: new_upvr (copied, readonly)
				[5]: Top_upvr (copied, readonly)
				[6]: var18_upvr (copied, readonly)
				[7]: Angles_upvr (copied, readonly)
				[8]: var19_upvr (copied, readonly)
				[9]: clone_upvw (copied, read and write)
			]]
			var24_upvw += arg1_5 * var25_upvw
			local var26 = any_GetPivot_result1_upvr_4 * new_upvr(0, math.sin(var24_upvw) ^ 2 / 10, 0)
			Top_upvr:PivotTo((var26) * (var18_upvr * Angles_upvr(-math.sin(var24_upvw) ^ 2 / 12, 0, 0)) * var19_upvr)
			clone_upvw:PivotTo(var26)
		end)
		return any_new_result1_upvr_4.CurrentAnimation
	end
	function module.Open(arg1_6, arg2_4, arg3) -- Line 64
		--[[ Upvalues[10]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: sin_upvr (copied, readonly)
			[4]: any_GetPivot_result1_upvr_4 (readonly)
			[5]: new_upvr_2 (copied, readonly)
			[6]: Top_upvr (readonly)
			[7]: var18_upvr (readonly)
			[8]: Angles_upvr (copied, readonly)
			[9]: var19_upvr (readonly)
			[10]: clone_upvw (read and write)
		]]
		local var27 = arg3 or 1.5
		if arg2_4 then
			any_new_result1_upvr_4.CurrentAnimation = Util_upvr.Thread.LoopFor(var27 / 3, function(arg1_7) -- Line 67
				--[[ Upvalues[9]:
					[1]: Util_upvr (copied, readonly)
					[2]: sin_upvr (copied, readonly)
					[3]: any_GetPivot_result1_upvr_4 (copied, readonly)
					[4]: new_upvr_2 (copied, readonly)
					[5]: Top_upvr (copied, readonly)
					[6]: var18_upvr (copied, readonly)
					[7]: Angles_upvr (copied, readonly)
					[8]: var19_upvr (copied, readonly)
					[9]: clone_upvw (copied, read and write)
				]]
				local var29 = 1 - arg1_7
				local var30 = any_GetPivot_result1_upvr_4 + new_upvr_2(0, sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(var29, 0, 0.8) * math.pi) / 2, 0)
				Top_upvr:PivotTo((var30) * (var18_upvr * Angles_upvr(-sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(var29, 0.6, 1) * math.pi / 2) * 2, 0, 0)) * var19_upvr)
				clone_upvw:PivotTo(var30)
			end).Ended:Wait()
		end
		any_new_result1_upvr_4.CurrentAnimation = Util_upvr.Thread.LoopFor(var27, function(arg1_8) -- Line 83
			--[[ Upvalues[9]:
				[1]: Util_upvr (copied, readonly)
				[2]: sin_upvr (copied, readonly)
				[3]: any_GetPivot_result1_upvr_4 (copied, readonly)
				[4]: new_upvr_2 (copied, readonly)
				[5]: Angles_upvr (copied, readonly)
				[6]: Top_upvr (copied, readonly)
				[7]: var18_upvr (copied, readonly)
				[8]: var19_upvr (copied, readonly)
				[9]: clone_upvw (copied, read and write)
			]]
			local any_GetPercentageFromNumbers_result1 = Util_upvr.ValueConvertor:GetPercentageFromNumbers(arg1_8, 0.2, 0.8)
			local var33 = (any_GetPivot_result1_upvr_4 + new_upvr_2(0, sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(arg1_8, 0, 0.8) * math.pi), 0)) * Angles_upvr(0, sin_upvr(any_GetPercentageFromNumbers_result1 * math.pi * 12) / 5, math.sin(any_GetPercentageFromNumbers_result1 * math.pi) * sin_upvr(any_GetPercentageFromNumbers_result1 * math.pi * 8) / 3)
			Top_upvr:PivotTo((var33) * (var18_upvr * Angles_upvr(-sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(arg1_8, 0.6, 1) * math.pi / 2) * 2, 0, 0)) * var19_upvr)
			clone_upvw:PivotTo(var33)
		end)
		return any_new_result1_upvr_4.CurrentAnimation
	end
	function module.Close(arg1_9, arg2_5) -- Line 103
		--[[ Upvalues[10]:
			[1]: any_new_result1_upvr_4 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: sin_upvr (copied, readonly)
			[4]: any_GetPivot_result1_upvr_4 (readonly)
			[5]: new_upvr_2 (copied, readonly)
			[6]: Top_upvr (readonly)
			[7]: var18_upvr (readonly)
			[8]: Angles_upvr (copied, readonly)
			[9]: var19_upvr (readonly)
			[10]: clone_upvw (read and write)
		]]
		any_new_result1_upvr_4.CurrentAnimation = Util_upvr.Thread.LoopFor(arg2_5 or 0.35, function(arg1_10) -- Line 105
			--[[ Upvalues[9]:
				[1]: Util_upvr (copied, readonly)
				[2]: sin_upvr (copied, readonly)
				[3]: any_GetPivot_result1_upvr_4 (copied, readonly)
				[4]: new_upvr_2 (copied, readonly)
				[5]: Top_upvr (copied, readonly)
				[6]: var18_upvr (copied, readonly)
				[7]: Angles_upvr (copied, readonly)
				[8]: var19_upvr (copied, readonly)
				[9]: clone_upvw (copied, read and write)
			]]
			local var35 = 1 - arg1_10
			local var36 = any_GetPivot_result1_upvr_4 + new_upvr_2(0, sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(var35, 0, 0.8) * math.pi) / 2, 0)
			Top_upvr:PivotTo((var36) * (var18_upvr * Angles_upvr(-sin_upvr(Util_upvr.ValueConvertor:GetPercentageFromNumbers(var35, 0.6, 1) * math.pi / 2) * 2, 0, 0)) * var19_upvr)
			clone_upvw:PivotTo(var36)
		end)
		return any_new_result1_upvr_4.CurrentAnimation
	end
	any_new_result1_upvr_4.Model = clone_upvw
	return module
end
local var37_upvw = false
local tbl_6_upvr = {}
function module_2_upvr.SyncCrates(arg1, arg2, arg3) -- Line 129
	--[[ Upvalues[5]:
		[1]: var37_upvw (read and write)
		[2]: Util_upvr (readonly)
		[3]: CreateChest_upvr (readonly)
		[4]: tbl_6_upvr (readonly)
		[5]: module_2_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	warn(arg2, arg3)
	if not arg3 or #arg3 == 0 then
	elseif not var37_upvw then
		var37_upvw = true
		while not Util_upvr.Windows do
			task.wait()
		end
		local ChestBlur_upvr_2 = Util_upvr.Lighting.ChestBlur
		Util_upvr.Windows.State:AddState(11, false, function() -- Line 137
			--[[ Upvalues[3]:
				[1]: ChestBlur_upvr_2 (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg2 (readonly)
			]]
			ChestBlur_upvr_2.Enabled = true
			Util_upvr.Thread.LoopFor(0.5, function(arg1_17) -- Line 139
				--[[ Upvalues[1]:
					[1]: arg2 (copied, readonly)
				]]
				arg2.Content.ImageTransparency = 1 - arg1_17
			end)
			arg2.Enabled = true
			local any_Play_result1_upvr = Util_upvr.Sounds:Play("ChestIdle")
			return function() -- Line 145
				--[[ Upvalues[3]:
					[1]: arg2 (copied, readonly)
					[2]: ChestBlur_upvr_2 (copied, readonly)
					[3]: any_Play_result1_upvr (readonly)
				]]
				arg2.Enabled = false
				ChestBlur_upvr_2.Enabled = false
				if any_Play_result1_upvr then
					any_Play_result1_upvr:Stop()
				end
			end
		end)
		task.wait(1)
		if next(arg3) then
			local tbl_5 = {table.remove(arg3, 1), table.remove(arg3, 1), table.remove(arg3, 1)}
			local tbl_2_upvr = {}
			for i = 1, math.min(#tbl_5, 3) do
				local var236 = tbl_5[i]
				local cframe_2 = CFrame.new(0, 0, -14)
				if i == 2 then
					cframe_2 = CFrame.new(3, -0.5, -17) * CFrame.Angles(0, 0.5235987755982988, 0)
				elseif i == 3 then
					cframe_2 = CFrame.new(-3, -0.5, -17) * CFrame.Angles(0, -0.5235987755982988, 0)
				end
				local CreateChest_result1_2 = CreateChest_upvr(var236.Name, cframe_2)
				CreateChest_result1_2.Reward = var236.Value
				CreateChest_result1_2.Sold = var236.Sold
				CreateChest_result1_2.RewardPosition = cframe_2 * CFrame.new(0, 0, 6)
				if i == 1 then
					CreateChest_result1_2.RewardPosition = cframe_2 * CFrame.new(0, 0, 6)
				else
					CreateChest_result1_2.RewardPosition = cframe_2 * CFrame.new(0, 0, 5) + Vector3.new(0, 0, 3)
				end
				tbl_2_upvr[#tbl_2_upvr + 1] = CreateChest_result1_2
			end
			for _, v in pairs(arg2.Content:GetChildren()) do
				local tonumber_result1_2 = tonumber(v.Name)
				if v:IsA("Frame") then
					v.Visible = false
					if tonumber_result1_2 and tbl_2_upvr[tonumber_result1_2] then
						tbl_2_upvr[tonumber_result1_2].Frame = v
					end
				end
			end
			local any_new_result1_upvr_5 = Util_upvr.Signal.new()
			for _, v_2_upvr in pairs(tbl_2_upvr) do
				local any_GetAsset_result1_4 = Util_upvr.Assets:GetAsset("Balls", v_2_upvr.Reward)
				local var248
				if not any_GetAsset_result1_4 or not any_GetAsset_result1_4:GetAttribute("Rarity") then
					local var249 = "Common"
				end
				local Frame = v_2_upvr.Frame
				v_2_upvr.BallModel = any_GetAsset_result1_4
				var248 = Frame.ItemName
				local function INLINED_3() -- Internal function, doesn't exist in bytecode
					var248 = any_GetAsset_result1_4:GetAttribute("Icon")
					return var248
				end
				if not any_GetAsset_result1_4 or not INLINED_3() then
					var248 = ""
				end
				var248.Icon.Image = var248
				var248 = Frame.ItemName
				var248 = v_2_upvr.Reward
				var248.Title.Text = var248
				if v_2_upvr.Sold then
					var248 = true
				else
					var248 = false
				end
				Frame.Sold.Visible = var248
				var248 = Frame.Sold
				local function INLINED_4() -- Internal function, doesn't exist in bytecode
					var248 = '+'..Util_upvr.ValueConvertor:ShrinkNumber(v_2_upvr.Sold)
					return var248
				end
				if not v_2_upvr.Sold or not INLINED_4() then
					var248 = "Sold!"
				end
				var248.Title.Text = var248
				Frame.Rarity.Text = var249
				var248 = {}
				var248[1] = Frame.Rarity
				local pairs_result1_6, pairs_result2_2, pairs_result3_4 = pairs(var248)
				for _, v_3 in pairs_result1_6, pairs_result2_2, pairs_result3_4 do
					local any_GetAsset_result1_3 = Util_upvr.Assets:GetAsset("Colors", var249.."Gradient")
					if any_GetAsset_result1_3 then
						any_GetAsset_result1_3.Parent = v_3
						v_2_upvr.Maid:GiveTask(any_GetAsset_result1_3)
					end
				end
				local var256_upvw = 0
				function pairs_result2_2() -- Line 219
					--[[ Upvalues[4]:
						[1]: v_2_upvr (readonly)
						[2]: var256_upvw (read and write)
						[3]: tbl_2_upvr (readonly)
						[4]: any_new_result1_upvr_5 (readonly)
					]]
					v_2_upvr:Spawn().Ended:Wait()
					v_2_upvr:PlayIdle()
					var256_upvw += 1
					if #tbl_2_upvr <= var256_upvw then
						any_new_result1_upvr_5:Fire()
					end
				end
				task.spawn(pairs_result2_2)
				pairs_result2_2 = arg2.ViewportFrame
				v_2_upvr.Model.Parent = pairs_result2_2
				pairs_result2_2 = 0.2
				task.wait(pairs_result2_2)
			end
			any_new_result1_upvr_5:Wait()
			Util_upvr.Sounds:Play("ChestDropped")
			task.wait(0.35)
			Util_upvr.Input.Actions.Click.Activated:Wait()
			local any_new_result1_upvr_2 = Util_upvr.Signal.new()
			for i_5, v_4_upvr in pairs(tbl_2_upvr) do
				local var262_upvw = 0
				task.delay(i_5 / 3, function() -- Line 242
					--[[ Upvalues[5]:
						[1]: v_4_upvr (readonly)
						[2]: Util_upvr (copied, readonly)
						[3]: var262_upvw (read and write)
						[4]: tbl_2_upvr (readonly)
						[5]: any_new_result1_upvr_2 (readonly)
					]]
					local any_Open_result1_upvr = v_4_upvr:Open(false, 1.5)
					any_Open_result1_upvr.Ended:Wait()
					local BallModel = v_4_upvr.BallModel
					if BallModel then
						local clone_upvw_3 = BallModel:Clone()
						v_4_upvr.Maid.Ball = clone_upvw_3
						local any_GetPivot_result1_upvr_3 = v_4_upvr.Model:GetPivot()
						local RewardPosition_upvr = v_4_upvr.RewardPosition
						v_4_upvr.Maid.BallAnimation = Util_upvr.Thread.LoopFor(1, function(arg1_18) -- Line 258
							--[[ Upvalues[3]:
								[1]: clone_upvw_3 (read and write)
								[2]: any_GetPivot_result1_upvr_3 (readonly)
								[3]: RewardPosition_upvr (readonly)
							]]
							clone_upvw_3:PivotTo(any_GetPivot_result1_upvr_3:Lerp(RewardPosition_upvr, arg1_18) * CFrame.Angles(math.sin(arg1_18 * math.pi), arg1_18 * math.pi * 2, 0) + Vector3.new(0, math.sin(arg1_18 * math.pi) * 5, 0))
						end).Ended:Connect(function() -- Line 260
							--[[ Upvalues[3]:
								[1]: clone_upvw_3 (read and write)
								[2]: v_4_upvr (copied, readonly)
								[3]: Util_upvr (copied, readonly)
							]]
							local var272_upvw = 0
							local any_GetPivot_result1_upvr_7 = clone_upvw_3:GetPivot()
							v_4_upvr.Maid.BallAnimation = Util_upvr.Thread.Loop(function(arg1_19) -- Line 263
								--[[ Upvalues[3]:
									[1]: var272_upvw (read and write)
									[2]: clone_upvw_3 (copied, read and write)
									[3]: any_GetPivot_result1_upvr_7 (readonly)
								]]
								var272_upvw += arg1_19
								clone_upvw_3:PivotTo(any_GetPivot_result1_upvr_7 * CFrame.Angles(math.sin(var272_upvw) / 2, var272_upvw, (1 - math.cos(var272_upvw)) / 2) + Vector3.new(0, -math.sin(var272_upvw * math.pi) / 2, 0))
							end)
						end)
						clone_upvw_3.Parent = v_4_upvr.Model
					end
					any_GetPivot_result1_upvr_3 = Util_upvr.Input.Actions.Click.Activated:Connect(function() -- Line 244
						--[[ Upvalues[2]:
							[1]: any_Open_result1_upvr (readonly)
							[2]: Util_upvr (copied, readonly)
						]]
						any_Open_result1_upvr:Skip(0.5)
						Util_upvr.Sounds:Play("ChestSkipSpam")
					end):Disconnect
					any_GetPivot_result1_upvr_3()
					RewardPosition_upvr = v_4_upvr
					any_GetPivot_result1_upvr_3 = RewardPosition_upvr.Maid
					RewardPosition_upvr = Util_upvr.Thread.LoopFor
					RewardPosition_upvr = RewardPosition_upvr(1, function(arg1_20) -- Line 272
						--[[ Upvalues[1]:
							[1]: v_4_upvr (copied, readonly)
						]]
						v_4_upvr.Frame.ItemName.Size = UDim2.new(arg1_20, 0, 0.05 * arg1_20, 0)
						v_4_upvr.Frame.Rarity.Size = UDim2.new(arg1_20, 0, 0.05 * arg1_20, 0)
					end)
					any_GetPivot_result1_upvr_3.TextSizeLerp = RewardPosition_upvr
					RewardPosition_upvr = v_4_upvr
					any_GetPivot_result1_upvr_3 = RewardPosition_upvr.Frame
					RewardPosition_upvr = UDim2.new(v_4_upvr.Frame.Position.X.Scale, 0, 1, 0)
					any_GetPivot_result1_upvr_3.Position = RewardPosition_upvr
					RewardPosition_upvr = v_4_upvr
					any_GetPivot_result1_upvr_3 = RewardPosition_upvr.Frame
					any_GetPivot_result1_upvr_3 = any_GetPivot_result1_upvr_3:TweenPosition
					any_GetPivot_result1_upvr_3(UDim2.new(v_4_upvr.Frame.Position.X.Scale, 0, 0, 0), "Out", "Quad", 0.5, true, function() -- Line 278
						--[[ Upvalues[2]:
							[1]: v_4_upvr (copied, readonly)
							[2]: Util_upvr (copied, readonly)
						]]
						local var277_upvw = 0
						v_4_upvr.Maid.ShakyShaky = Util_upvr.Thread.Loop(function(arg1_21) -- Line 280
							--[[ Upvalues[2]:
								[1]: var277_upvw (read and write)
								[2]: v_4_upvr (copied, readonly)
							]]
							var277_upvw += arg1_21
							v_4_upvr.Frame.ItemName.Rotation = math.sin(var277_upvw * 10) * 5
							v_4_upvr.Frame.Rarity.Rotation = -math.sin(var277_upvw * 10) * 5
						end)
					end)
					RewardPosition_upvr = v_4_upvr
					any_GetPivot_result1_upvr_3 = RewardPosition_upvr.Frame
					RewardPosition_upvr = true
					any_GetPivot_result1_upvr_3.Visible = RewardPosition_upvr
					any_GetPivot_result1_upvr_3 = task.wait
					RewardPosition_upvr = 1
					any_GetPivot_result1_upvr_3(RewardPosition_upvr)
					any_GetPivot_result1_upvr_3 = var262_upvw
					any_GetPivot_result1_upvr_3 += 1
					var262_upvw = any_GetPivot_result1_upvr_3
					any_GetPivot_result1_upvr_3 = var262_upvw
					RewardPosition_upvr = #tbl_2_upvr
					if RewardPosition_upvr <= any_GetPivot_result1_upvr_3 then
						any_GetPivot_result1_upvr_3 = any_new_result1_upvr_2:Fire
						any_GetPivot_result1_upvr_3()
					end
				end)
				local _
			end
			any_new_result1_upvr_2:Wait()
			Util_upvr.Sounds:Play("ChestOpen")
			Util_upvr.Sounds:Play("ChestShowContentResult")
			Util_upvr.Input.Actions.Click.Activated:Wait()
			for i_6, v_5_upvr in pairs(tbl_2_upvr) do
				i_5 = task.delay
				task.delay(i_6 / 3, function() -- Line 301
					--[[ Upvalues[2]:
						[1]: v_5_upvr (readonly)
						[2]: Util_upvr (copied, readonly)
					]]
					local Ball_upvr_2 = v_5_upvr.Maid.Ball
					if Ball_upvr_2 then
						local any_GetPivot_result1_upvr_6 = Ball_upvr_2:GetPivot()
						v_5_upvr.Maid.BallAnimation = Util_upvr.Thread.LoopFor(2, function(arg1_22) -- Line 305
							--[[ Upvalues[2]:
								[1]: Ball_upvr_2 (readonly)
								[2]: any_GetPivot_result1_upvr_6 (readonly)
							]]
							Ball_upvr_2:PivotTo(any_GetPivot_result1_upvr_6 - Vector3.new(0, 20 * arg1_22, 0))
						end)
					end
					any_GetPivot_result1_upvr_6 = v_5_upvr.Frame
					any_GetPivot_result1_upvr_6 = any_GetPivot_result1_upvr_6:TweenPosition
					any_GetPivot_result1_upvr_6(UDim2.new(v_5_upvr.Frame.Position.X.Scale, 0, 1, 0), "Out", "Quad", 0.5, true, function() -- Line 309
						--[[ Upvalues[1]:
							[1]: v_5_upvr (copied, readonly)
						]]
						v_5_upvr.Maid.ShakyShaky = nil
						v_5_upvr.Frame.Visible = false
					end)
				end)
			end
			local any_new_result1_upvr = Util_upvr.Signal.new()
			for i_7, v_6_upvr in pairs(tbl_2_upvr) do
				local var292_upvw = 0
				task.spawn(function() -- Line 320
					--[[ Upvalues[4]:
						[1]: v_6_upvr (readonly)
						[2]: var292_upvw (read and write)
						[3]: tbl_2_upvr (readonly)
						[4]: any_new_result1_upvr (readonly)
					]]
					v_6_upvr:Close().Ended:Wait()
					var292_upvw += 1
					if #tbl_2_upvr <= var292_upvw then
						any_new_result1_upvr:Fire()
					end
				end)
				local _
			end
			any_new_result1_upvr:Wait()
			task.wait(1)
			for _, v_7 in pairs(tbl_2_upvr) do
				i_7 = v_7:Destroy
				i_7()
			end
			if next(tbl_6_upvr) then
				task.spawn(function() -- Line 336
					--[[ Upvalues[3]:
						[1]: var37_upvw (copied, read and write)
						[2]: module_2_upvr (copied, readonly)
						[3]: tbl_6_upvr (copied, readonly)
					]]
					var37_upvw = false
					module_2_upvr:SyncCrates(unpack(table.remove(tbl_6_upvr, 1)))
				end)
			else
				var37_upvw = false
				Util_upvr.Windows.State:RemoveState(11)
			end
			print("finished")
			-- KONSTANTWARNING: GOTO [45] #36
		end
	else
		ChestBlur_upvr_2 = tbl_6_upvr
		tbl_2_upvr = tbl_6_upvr
		local tbl_3 = {}
		tbl_2_upvr = arg2
		tbl_3[1] = tbl_2_upvr
		tbl_3[2] = arg3
		ChestBlur_upvr_2[#tbl_2_upvr + 1] = tbl_3
	end
end
Util_upvr.ChestAnimation = module_2_upvr
return module_2_upvr