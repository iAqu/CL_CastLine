-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:31
-- Luau version 6, Types version 3
-- Time taken: 0.017097 seconds

local module_upvr = {}
local ServerStorage_upvr = game:GetService("ServerStorage")
local function _(arg1, arg2, arg3, arg4, arg5) -- Line 12, Named "weld"
	local Weld_2 = Instance.new("Weld")
	Weld_2.Part0 = arg1
	Weld_2.Part1 = arg2
	local var4 = arg4
	if not var4 then
		var4 = arg1.CFrame:Inverse() * arg2.CFrame
	end
	Weld_2.C0 = var4
	var4 = arg5
	local var5 = var4
	if not var5 then
		var5 = CFrame.new()
	end
	Weld_2.C1 = var5
	Weld_2.Parent = arg3 or arg1
	return Weld_2
end
local function motor6D_upvr(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 23, Named "motor6D"
	local var6 = arg3 or arg1
	local cframe = CFrame.new(var6.Position)
	local NEVER = CFrame.Angles(var6.CFrame:ToEulerAnglesXYZ())
	local var9 = arg7
	if not var9 then
		var9 = Instance.new("Motor6D")
	end
	local var10 = var9
	var9 = arg1
	local var11 = var9
	if not var11 then
		var11 = var10.Part0
	end
	var10.Part0 = var11
	var11 = arg2
	local var12 = var11
	if not var12 then
		var12 = var10.Part1
	end
	var10.Part1 = var12
	var12 = arg5
	local var13 = var12
	if not var13 then
		var13 = arg1.CFrame:Inverse() * cframe * NEVER
	end
	var10.C0 = var13
	var13 = arg6
	local var14 = var13
	if not var14 then
		var14 = arg2.CFrame:Inverse() * cframe * NEVER
	end
	var10.C1 = var14
	var10.Parent = arg4 or arg1
	return var10
end
local tbl_6_upvr = {}
local Maid_upvr = require(script.Parent.Maid)
local CollisionUtil_upvr = require(script.Parent.CollisionUtil)
function module_upvr.MorphModel(arg1, arg2, arg3) -- Line 38
	--[[ Upvalues[5]:
		[1]: tbl_6_upvr (readonly)
		[2]: motor6D_upvr (readonly)
		[3]: Maid_upvr (readonly)
		[4]: ServerStorage_upvr (readonly)
		[5]: CollisionUtil_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if not arg3 then
	end
	local tbl = {}
	for _, v_upvw in pairs({arg2:FindFirstChild("RightHand"), arg2:FindFirstChild("LeftHand")}) do
		if not arg2:FindFirstChild(v_upvw.Name.."Handle") then
			local function autoRerig_upvr() -- Line 43, Named "autoRerig"
				--[[ Upvalues[4]:
					[1]: arg2 (readonly)
					[2]: v_upvw (read and write)
					[3]: motor6D_upvr (copied, readonly)
					[4]: autoRerig_upvr (readonly)
				]]
				local SOME_2 = arg2:FindFirstChild(v_upvw.Name.."Handle")
				if not SOME_2 then
					SOME_2 = Instance.new("Part")
				end
				SOME_2.Name = v_upvw.Name.."Handle"
				SOME_2.Size = Vector3.new(0.5, 0.5, 0.5)
				SOME_2.CanCollide = false
				SOME_2.Massless = true
				SOME_2.Transparency = 1
				SOME_2.CFrame = v_upvw.CFrame
				motor6D_upvr(v_upvw, SOME_2, SOME_2).Name = v_upvw.Name.."ToolMotor6D"
				local var177_upvw
				var177_upvw = v_upvw:GetPropertyChangedSignal("Parent"):Connect(function() -- Line 54
					--[[ Upvalues[4]:
						[1]: v_upvw (copied, read and write)
						[2]: var177_upvw (read and write)
						[3]: arg2 (copied, readonly)
						[4]: autoRerig_upvr (copied, readonly)
					]]
					if not v_upvw.Parent then
						var177_upvw:Disconnect()
						v_upvw = arg2:WaitForChild(v_upvw.Name, 1)
						if v_upvw then
							autoRerig_upvr()
						end
					end
				end)
				SOME_2.Parent = arg2
			end
			autoRerig_upvr()
		end
	end
	if not tbl_6_upvr[arg2] then
		local var179 = {
			BodyParts = {};
			Maid = Maid_upvr.new();
		}
		tbl_6_upvr[arg2] = var179
	end
	if tbl.Face then
		local face_2 = arg2.Head:FindFirstChild("face")
		if face_2 then
			face_2.Texture = tbl.Face
		end
	end
	if tbl.Animate and not arg2:FindFirstChild("Animate") then
		ServerStorage_upvr.Assets.Animate:Clone().Parent = arg2
	end
	if tbl.Clothing then
		for _, v_2 in pairs(tbl.Clothing) do
			if var179.Maid[v_2] then return end
			local SOME_3 = ServerStorage_upvr.Appearance.Clothing:FindFirstChild(v_2)
			if SOME_3 then
				local tbl_5 = {}
				for _, v_3 in pairs(SOME_3:GetChildren()) do
					local SOME = arg2:FindFirstChild(v_3.Name)
					if SOME then
						local clone_3 = v_3:Clone()
						for _, v_4 in pairs(clone_3:GetDescendants()) do
							if v_4.Name == "PartBodyColor" then
								v_4.Color = SOME.Color
							end
						end
						clone_3:PivotTo(SOME.CFrame)
						local PrimaryPart_2 = clone_3.PrimaryPart
						local Weld = Instance.new("Weld")
						Weld.Part0 = PrimaryPart_2
						Weld.Part1 = SOME
						local any_Inverse_result1_2 = clone_3.PrimaryPart.CFrame:Inverse()
						if not any_Inverse_result1_2 then
							any_Inverse_result1_2 = PrimaryPart_2.CFrame:Inverse() * SOME.CFrame
						end
						Weld.C0 = any_Inverse_result1_2
						any_Inverse_result1_2 = SOME.CFrame:Inverse()
						local var197 = any_Inverse_result1_2
						if not var197 then
							var197 = CFrame.new()
						end
						Weld.C1 = var197
						Weld.Parent = clone_3 or PrimaryPart_2
						clone_3.Parent = SOME
						tbl_5[#tbl_5 + 1] = clone_3
					end
				end
				if 0 < #tbl_5 then
					local any_new_result1_2 = Maid_upvr.new()
					for _, v_5_upvr in pairs(tbl_5) do
						any_new_result1_2:GiveTask(v_5_upvr)
						for _, v_6_upvr in pairs(v_5_upvr:GetDescendants()) do
							if v_6_upvr.Name == "PartBodyColor" then
								print("tracking bodycololr changes")
								any_new_result1_2:GiveTask(v_5_upvr.Parent:GetPropertyChangedSignal("Color"):Connect(function() -- Line 110
									--[[ Upvalues[2]:
										[1]: v_6_upvr (readonly)
										[2]: v_5_upvr (readonly)
									]]
									v_6_upvr.Color = v_5_upvr.Parent.Color
								end))
							end
						end
					end
					var179.Maid[v_2] = any_new_result1_2
				end
			end
		end
	end
	if tbl.BodyColor3 then
		local class_BodyColors_2 = arg2:FindFirstChildOfClass("BodyColors")
		if not class_BodyColors_2 then
			class_BodyColors_2 = Instance.new("BodyColors")
			class_BodyColors_2.Parent = arg2
		end
		class_BodyColors_2.HeadColor3 = tbl.BodyColor3
		class_BodyColors_2.TorsoColor3 = tbl.BodyColor3
		class_BodyColors_2.LeftArmColor3 = tbl.BodyColor3
		class_BodyColors_2.RightArmColor3 = tbl.BodyColor3
		class_BodyColors_2.LeftLegColor3 = tbl.BodyColor3
		class_BodyColors_2.RightLegColor3 = tbl.BodyColor3
	end
	if tbl.CollisionGroup then
		for _, v_7 in pairs(arg2:GetDescendants()) do
			if v_7:IsA("BasePart") then
				v_7.CanCollide = false
				CollisionUtil_upvr:SetCollision(v_7, tbl.CollisionGroup)
			end
		end
	end
end
local tbl_3_upvr = {}
local Players_upvr = game:GetService("Players")
function module_upvr.MorphPlayer(arg1, arg2, arg3, arg4, arg5) -- Line 145
	--[[ Upvalues[3]:
		[1]: tbl_3_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	local var212 = arg4
	if not var212 then
		var212 = {}
	end
	local var213 = arg5
	if not var213 then
		var213 = arg2.Parent.Parent
	end
	arg2.Parent.Parent = var213
	if arg3 then
		if not tbl_3_upvr[arg3] then
			local any_GetHumanoidDescriptionFromUserId_result1 = Players_upvr:GetHumanoidDescriptionFromUserId(arg3)
			any_GetHumanoidDescriptionFromUserId_result1.Parent = game.ReplicatedStorage
			tbl_3_upvr[arg3] = any_GetHumanoidDescriptionFromUserId_result1
		end
		if any_GetHumanoidDescriptionFromUserId_result1 then
			arg2:ApplyDescription(any_GetHumanoidDescriptionFromUserId_result1)
		end
	end
	return module_upvr:MorphHumanoid(arg2, var212)
end
function module_upvr.Clone(arg1, arg2, ...) -- Line 162
	arg2.Archivable = true
	local clone_2 = arg2:Clone()
	arg2.Archivable = false
	for _, v_8 in pairs(clone_2:GetDescendants()) do
		if v_8:IsA("Script") or v_8:IsA("LocalScript") then
			v_8.Disabled = true
		end
	end
	return clone_2
end
function module_upvr.MorphHumanoidDescription(arg1, arg2, arg3, arg4, arg5) -- Line 176
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var221 = arg4
	if not var221 then
		var221 = {}
	end
	local var222 = arg5
	if not var222 then
		var222 = arg2.Parent.Parent
	end
	arg2.Parent.Parent = var222
	if arg3 then
		arg2:ApplyDescription(arg3)
	end
	return module_upvr:MorphHumanoid(arg2, var221)
end
function module_upvr.MorphHumanoid(arg1, arg2, arg3) -- Line 185
	--[[ Upvalues[2]:
		[1]: ServerStorage_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local var227 = arg3
	if not var227 then
		var227 = {}
	end
	local var228 = var227
	var227 = var228.BodyType
	local var229 = var227
	if var229 then
		var229 = ServerStorage_upvr.Appearance.BodyTypes:FindFirstChild(var228.BodyType)
	end
	if not arg2:FindFirstChildOfClass("Animator") then
		Instance.new("Animator").Parent = arg2
	end
	if arg2.BreakJointsOnDeath then
		arg2.BreakJointsOnDeath = false
	end
	if var229 then
		for _, v_9 in pairs(var229:GetChildren()) do
			if v_9:IsA("BasePart") then
				arg2:ReplaceBodyPartR15(v_9.Name, v_9:Clone())
			end
		end
	end
	if var228.WalkSpeed then
		arg2.WalkSpeed = var228.WalkSpeed
	end
	if var228.JumpPower then
		arg2.JumpPower = var228.JumpPower
	end
	if var228.Name then
		arg2.DisplayName = var228.Name
	end
	arg2.NameDisplayDistance = 0
	arg2.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	return module_upvr:MorphModel(arg2.Parent, var228)
end
return module_upvr