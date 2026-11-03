-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:44
-- Luau version 6, Types version 3
-- Time taken: 0.002036 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 9
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: LocalPlayer_upvr (copied, readonly)
		]]
		repeat
			task.wait()
		until Util_upvr.ClientZone and not any_new_result1_upvr.Active
		if not any_new_result1_upvr.Active then
		else
			local var7_upvw
			local function UpdateZone_upvr(arg1_2) -- Line 15, Named "UpdateZone"
				--[[ Upvalues[5]:
					[1]: Util_upvr (copied, readonly)
					[2]: var7_upvw (read and write)
					[3]: arg1 (copied, readonly)
					[4]: any_new_result1_upvr (copied, readonly)
					[5]: LocalPlayer_upvr (copied, readonly)
				]]
				local SOME = Util_upvr.ReplicatedStorage.ButtonTeleporters:FindFirstChild(arg1_2)
				if var7_upvw == SOME then
				else
					var7_upvw = SOME
					if SOME then
						local SOME_3_upvr = SOME:FindFirstChild(arg1.Name)
						if SOME_3_upvr then
							any_new_result1_upvr.OnClick = arg1.MouseButton1Click:Connect(function() -- Line 23
								--[[ Upvalues[2]:
									[1]: LocalPlayer_upvr (copied, readonly)
									[2]: SOME_3_upvr (readonly)
								]]
								LocalPlayer_upvr.Character:PivotTo(CFrame.new(SOME_3_upvr.Position, SOME_3_upvr.Position + LocalPlayer_upvr.Character:GetPivot().LookVector))
							end)
							arg1.Visible = true
							return
						end
					end
					SOME_3_upvr = any_new_result1_upvr
					SOME_3_upvr.OnClick = nil
					SOME_3_upvr = arg1
					SOME_3_upvr.Visible = false
				end
			end
			any_new_result1_upvr.ZoneChanged = Util_upvr.ClientZone.ZoneChanged:Connect(UpdateZone_upvr)
			UpdateZone_upvr(Util_upvr.ClientZone.CurrentZone)
			any_new_result1_upvr.AttributeChanged = arg1:GetAttributeChangedSignal("Area"):Connect(function() -- Line 36
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