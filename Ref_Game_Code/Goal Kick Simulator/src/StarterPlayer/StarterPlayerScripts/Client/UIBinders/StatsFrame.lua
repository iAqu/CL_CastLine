-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:51
-- Luau version 6, Types version 3
-- Time taken: 0.005348 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local tbl_upvr = {}
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 10
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: tbl_upvr (copied, readonly)
		]]
		local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
		repeat
			task.wait()
		until Util_upvr.ClientZone and not any_new_result1_upvr.Active
		if not any_new_result1_upvr.Active then
		else
			local Name_upvr = arg1.Name
			local var9_upvw
			local function UpdateFrame_upvr(arg1_2) -- Line 20, Named "UpdateFrame"
				--[[ Upvalues[6]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: var9_upvw (read and write)
					[4]: Name_upvr (readonly)
					[5]: any_GetLink_result1_upvr (readonly)
					[6]: tbl_upvr (copied, readonly)
				]]
				-- KONSTANTERROR: [0] 1. Error Block 30 start (CF ANALYSIS FAILED)
				arg1.Content.Level.Text = "Level "..arg1_2
				local Icons = Util_upvr.Icons
				local var11 = Icons[var9_upvw]
				if not var11 then
					Icons = Util_upvr.Icons
					var11 = Icons.Money
				end
				arg1.Content.Price.Icon.Image = var11
				-- KONSTANTERROR: [0] 1. Error Block 30 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [61] 44. Error Block 36 start (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [61] 44. Error Block 36 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [43] 30. Error Block 4 start (CF ANALYSIS FAILED)
				-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [63.67579]
				-- KONSTANTERROR: [43] 30. Error Block 4 end (CF ANALYSIS FAILED)
			end
			any_new_result1_upvr.MouseSubmit = arg1.MouseButton1Click:Connect(function() -- Line 57
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: Name_upvr (readonly)
					[3]: var9_upvw (read and write)
				]]
				if Util_upvr.Network:Invoke("UpgradeStats", Name_upvr, Util_upvr.UIUpgrades.BulkNumber or 1, var9_upvw) then
					Util_upvr.Sounds:Play("BuySuccess")
				else
					Util_upvr.Sounds:Play("BuyFailed")
				end
			end)
			any_new_result1_upvr.MouseDown = arg1.MouseButton1Down:Connect(function() -- Line 65
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: any_new_result1_upvr (copied, readonly)
				]]
				arg1.Content:TweenSize(UDim2.new(0.85, 0, 0.85, 0), nil, nil, 0.2, true)
				function any_new_result1_upvr.Unclick() -- Line 67
					--[[ Upvalues[1]:
						[1]: arg1 (copied, readonly)
					]]
					arg1.Content:TweenSize(UDim2.new(1, 0, 1, 0), nil, nil, 0.2, true)
				end
			end)
			any_new_result1_upvr.MouseUp = arg1.MouseButton1Up:Connect(function() -- Line 71
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr.Unclick = nil
			end)
			any_new_result1_upvr.MouseLeave = arg1.MouseLeave:Connect(function() -- Line 75
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr.Unclick = nil
			end)
			local function UpdateZone_upvr(arg1_3) -- Line 80, Named "UpdateZone"
				--[[ Upvalues[6]:
					[1]: Util_upvr (copied, readonly)
					[2]: var9_upvw (read and write)
					[3]: any_GetLink_result1_upvr (readonly)
					[4]: UpdateFrame_upvr (readonly)
					[5]: Name_upvr (readonly)
					[6]: any_new_result1_upvr (copied, readonly)
				]]
				local var17 = Util_upvr.Settings.ZONECURRENCY[arg1_3] or "Money"
				if var9_upvw ~= var17 then
					var9_upvw = var17
				end
				local var18_upvr = any_GetLink_result1_upvr.ZoneStats[arg1_3]
				if not var18_upvr then
					var18_upvr = any_GetLink_result1_upvr.Stats
				end
				UpdateFrame_upvr(var18_upvr[Name_upvr])
				any_new_result1_upvr.OnBulkNumberChanged = Util_upvr.UIUpgrades.BulkNumberChanged:Connect(function() -- Line 89
					--[[ Upvalues[3]:
						[1]: UpdateFrame_upvr (copied, readonly)
						[2]: var18_upvr (readonly)
						[3]: Name_upvr (copied, readonly)
					]]
					UpdateFrame_upvr(var18_upvr[Name_upvr])
				end)
				any_new_result1_upvr.OnStatUpdate = var18_upvr.Changed:On(Name_upvr, UpdateFrame_upvr)
				any_new_result1_upvr.OnMoneyUpdate = any_GetLink_result1_upvr.Changed:On(var9_upvw, function() -- Line 93
					--[[ Upvalues[3]:
						[1]: UpdateFrame_upvr (copied, readonly)
						[2]: var18_upvr (readonly)
						[3]: Name_upvr (copied, readonly)
					]]
					UpdateFrame_upvr(var18_upvr[Name_upvr])
				end)
			end
			any_new_result1_upvr.ZoneChanged = Util_upvr.ClientZone.ZoneChanged:Connect(UpdateZone_upvr)
			UpdateZone_upvr(Util_upvr.ClientZone.CurrentZone)
			any_new_result1_upvr.AttributeChanged = arg1:GetAttributeChangedSignal("Area"):Connect(function() -- Line 100
				--[[ Upvalues[2]:
					[1]: UpdateZone_upvr (readonly)
					[2]: Util_upvr (copied, readonly)
				]]
				UpdateZone_upvr(Util_upvr.ClientZone.CurrentZone)
			end)
		end
	end)
	return any_new_result1_upvr
end
return module