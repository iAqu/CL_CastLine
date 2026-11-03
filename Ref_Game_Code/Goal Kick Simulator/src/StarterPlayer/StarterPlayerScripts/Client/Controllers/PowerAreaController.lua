-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:50
-- Luau version 6, Types version 3
-- Time taken: 0.003005 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Start(arg1) -- Line 5
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("ServerData")
	local any_GetAsset_result1_upvr = Util_upvr.Assets:GetAsset("BuffArea")
	local function UpdateHighlightArea() -- Line 9
		--[[ Upvalues[2]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: any_GetAsset_result1_upvr (readonly)
		]]
		local HighlightArea_3 = any_GetLink_result1_upvr.HighlightArea
		if not HighlightArea_3 then
			any_GetAsset_result1_upvr.Parent = nil
		else
			any_GetAsset_result1_upvr:PivotTo(CFrame.new(HighlightArea_3) * CFrame.Angles(0, 0, (math.pi/2)))
			any_GetAsset_result1_upvr.Parent = workspace.Ignore
		end
	end
	local function _() -- Line 19, Named "IsInside"
		--[[ Upvalues[3]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		local Character = LocalPlayer_upvr.Character
		if Character then
			Character = LocalPlayer_upvr.Character:GetPivot().Position
		end
		if not Character then return end
		local HighlightArea_2 = any_GetLink_result1_upvr.HighlightArea
		if not HighlightArea_2 then return end
		return Util_upvr.GameMath:IsInsidePowerArea(Character, HighlightArea_2)
	end
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local PowerArea_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("PowerArea")
	Util_upvr.Thread.Every(0.5, function() -- Line 30
		--[[ Upvalues[5]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: any_new_result1_upvr (readonly)
			[5]: PowerArea_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local Character_2 = LocalPlayer_upvr.Character
		if Character_2 then
			Character_2 = LocalPlayer_upvr.Character:GetPivot().Position
		end
		if not Character_2 then
		else
			local HighlightArea = any_GetLink_result1_upvr.HighlightArea
			if not HighlightArea then
			else
			end
		end
		if Util_upvr.GameMath:IsInsidePowerArea(Character_2, HighlightArea) then
			if any_new_result1_upvr.Active then
			else
				Util_upvr.Sounds:Play("PowerAreaBoost")
				PowerArea_upvr.Bottom.Static.Visible = true
				PowerArea_upvr.Top.Static.Visible = true
				PowerArea_upvr.Top:TweenPosition(UDim2.new(0.5, 0, 0, 0), "Out", "Quad", 0.3, true)
				PowerArea_upvr.Bottom:TweenPosition(UDim2.new(0.5, 0, 1, 0), "Out", "Quad", 0.3, true)
				PowerArea_upvr.Buffs.Visible = true
				any_new_result1_upvr.DelayDestroyStatic = nil
				local any_Play_result1_upvr = Util_upvr.Sounds:Play("HeavenlyLoop")
				function any_new_result1_upvr.Active() -- Line 42
					--[[ Upvalues[4]:
						[1]: any_new_result1_upvr (copied, readonly)
						[2]: Util_upvr (copied, readonly)
						[3]: PowerArea_upvr (copied, readonly)
						[4]: any_Play_result1_upvr (readonly)
					]]
					any_new_result1_upvr.DelayDestroyStatic = Util_upvr.Thread.Delay(0.3, function() -- Line 43
						--[[ Upvalues[1]:
							[1]: PowerArea_upvr (copied, readonly)
						]]
						PowerArea_upvr.Bottom.Static.Visible = false
						PowerArea_upvr.Top.Static.Visible = false
					end)
					task.spawn(function() -- Line 47
						--[[ Upvalues[2]:
							[1]: Util_upvr (copied, readonly)
							[2]: any_Play_result1_upvr (copied, readonly)
						]]
						Util_upvr.Thread.LoopFor(1, function(arg1_2) -- Line 48
							--[[ Upvalues[1]:
								[1]: any_Play_result1_upvr (copied, readonly)
							]]
							any_Play_result1_upvr.Volume = 1 - arg1_2
						end).Ended:Wait()
						any_Play_result1_upvr:Stop()
					end)
					PowerArea_upvr.Top:TweenPosition(UDim2.new(0.5, 0, -0.1, -86), "Out", "Quad", 0.5, true)
					PowerArea_upvr.Bottom:TweenPosition(UDim2.new(0.5, 0, 1.1, 50), "Out", "Quad", 0.5, true)
					PowerArea_upvr.Buffs.Visible = false
				end
			end
		end
		any_Play_result1_upvr = any_new_result1_upvr.Active
		if any_Play_result1_upvr then
			any_Play_result1_upvr = any_new_result1_upvr:Destroy
			any_Play_result1_upvr()
		end
	end)
	UpdateHighlightArea()
	any_GetLink_result1_upvr.Changed:On("HighlightArea", UpdateHighlightArea)
end
return module