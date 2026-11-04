-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:14
-- Luau version 6, Types version 3
-- Time taken: 0.002936 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function _() -- Line 13, Named "CreateHitBox"
	local Part_5 = Instance.new("Part", workspace)
	Part_5.Anchored = false
	Part_5.CanCollide = false
	Part_5.CanTouch = false
	Part_5.CanQuery = false
	Part_5.CollisionGroup = "EnemyHitBox"
	Part_5.Massless = true
	Part_5.Transparency = 1
	return Part_5
end
local CheckGamePass_upvr = require(ReplicatedStorage.Tool.CheckGamePass)
local Value_upvr = ReplicatedStorage["游戏全局配置"]["武器放大倍数"].Value
function module.GetHitbox(arg1, arg2, arg3) -- Line 28
	--[[ Upvalues[2]:
		[1]: CheckGamePass_upvr (readonly)
		[2]: Value_upvr (readonly)
	]]
	local Character = arg1.Character
	local var7
	if not Character then
	else
		var7 = 1
		if CheckGamePass_upvr.IsHasPass(arg1, "BigWeapon") then
			var7 = Value_upvr * var7
			local var8
		end
		if arg2 == 4 then
			var8 = "RightHand"
			if arg3 == 1 then
				var8 = "RightHand"
			end
			if arg3 == 2 then
				var8 = "LeftHand"
			end
			local SOME_2 = Character:FindFirstChild(var8)
			if not SOME_2 then return end
			local Part_4 = Instance.new("Part", workspace)
			Part_4.Anchored = false
			Part_4.CanCollide = false
			Part_4.CanTouch = false
			Part_4.CanQuery = false
			Part_4.CollisionGroup = "EnemyHitBox"
			Part_4.Massless = true
			Part_4.Transparency = 1
			local var11 = Part_4
			var11.Size = Vector3.new(4, 4, 15) * var7
			var11:PivotTo(SOME_2:GetPivot():ToWorldSpace(CFrame.new(0, 0, -1)))
			local WeldConstraint_5 = Instance.new("WeldConstraint", var11)
			WeldConstraint_5.Part0 = var11
			WeldConstraint_5.Part1 = SOME_2
			return var11
		end
		if arg2 == 3 then
			var8 = "RightHand"
			if arg3 == 1 then
				var8 = "RightHand"
			end
			if arg3 == 2 then
				var8 = "LeftHand"
			end
			local SOME = Character:FindFirstChild(var8)
			if not SOME then return end
			local Part_6 = Instance.new("Part", workspace)
			Part_6.Anchored = false
			Part_6.CanCollide = false
			Part_6.CanTouch = false
			Part_6.CanQuery = false
			Part_6.CollisionGroup = "EnemyHitBox"
			Part_6.Massless = true
			Part_6.Transparency = 1
			local var15 = Part_6
			var15.Size = Vector3.new(5, 5, 12) * var7
			var15:PivotTo(SOME:GetPivot():ToWorldSpace(CFrame.new(0, 0, -1)))
			local WeldConstraint_3 = Instance.new("WeldConstraint", var15)
			WeldConstraint_3.Part0 = var15
			WeldConstraint_3.Part1 = SOME
			return var15
		end
		if arg2 == 1 then
			var8 = "RightHand"
			if arg3 == 1 then
				var8 = "RightHand"
			end
			if arg3 == 2 then
				var8 = "LeftHand"
			end
			local SOME_3 = Character:FindFirstChild(var8)
			if not SOME_3 then return end
			local Part_2 = Instance.new("Part", workspace)
			Part_2.Anchored = false
			Part_2.CanCollide = false
			Part_2.CanTouch = false
			Part_2.CanQuery = false
			Part_2.CollisionGroup = "EnemyHitBox"
			Part_2.Massless = true
			Part_2.Transparency = 1
			local var19 = Part_2
			var19.Size = Vector3.new(5, 5, 13) * var7
			var19:PivotTo(SOME_3:GetPivot():ToWorldSpace(CFrame.new(0, 0, -1.5)))
			local WeldConstraint_4 = Instance.new("WeldConstraint", var19)
			WeldConstraint_4.Part0 = var19
			WeldConstraint_4.Part1 = SOME_3
			return var19
		end
		if arg2 == 2 then
			var8 = Character:FindFirstChild("RightHand")
			if not var8 then return end
			local LeftHand = Character:FindFirstChild("LeftHand")
			if not LeftHand then return end
			local Part = Instance.new("Part", workspace)
			Part.Anchored = false
			Part.CanCollide = false
			Part.CanTouch = false
			Part.CanQuery = false
			Part.CollisionGroup = "EnemyHitBox"
			Part.Massless = true
			Part.Transparency = 1
			local var23 = Part
			var23.Size = Vector3.new(6, 6, 6) * var7
			local WeldConstraint_2 = Instance.new("WeldConstraint", var23)
			if arg3 == 2 then
				var23:PivotTo(var8:GetPivot())
				WeldConstraint_2.Part0 = var23
				WeldConstraint_2.Part1 = var8
			end
			if arg3 == 1 then
				var23:PivotTo(LeftHand:GetPivot())
				WeldConstraint_2.Part0 = var23
				WeldConstraint_2.Part1 = LeftHand
			end
			return var23
		end
	end
end
function module.RobotGetHitbox(arg1) -- Line 158
	local RightHand = arg1:FindFirstChild("RightHand")
	if not RightHand then return end
	local Part_3 = Instance.new("Part", workspace)
	Part_3.Anchored = false
	Part_3.CanCollide = false
	Part_3.CanTouch = false
	Part_3.CanQuery = false
	Part_3.CollisionGroup = "EnemyHitBox"
	Part_3.Massless = true
	Part_3.Transparency = 1
	local var27 = Part_3
	var27.Size = Vector3.new(4, 4, 15)
	var27:PivotTo(RightHand:GetPivot():ToWorldSpace(CFrame.new(0, 0, -1)))
	local WeldConstraint = Instance.new("WeldConstraint", var27)
	WeldConstraint.Part0 = var27
	WeldConstraint.Part1 = RightHand
	return var27
end
return module