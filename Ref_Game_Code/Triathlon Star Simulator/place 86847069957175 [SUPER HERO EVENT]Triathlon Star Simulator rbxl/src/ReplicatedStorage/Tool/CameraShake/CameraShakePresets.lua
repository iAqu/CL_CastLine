-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:42
-- Luau version 6, Types version 3
-- Time taken: 0.003882 seconds

local CameraShakeInstance_upvr = require(script.Parent.CameraShakeInstance)
local tbl_upvr = {
	Test = function() -- Line 26, Named "Test"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_9 = CameraShakeInstance_upvr.new(0, 0, 0, 0)
		any_new_result1_9.PositionInfluence = Vector3.new(0, 0, 0)
		any_new_result1_9.RotationInfluence = Vector3.new(0, -5, 0)
		any_new_result1_9.EasingStyle = Enum.EasingStyle.Quart
		any_new_result1_9.EasingDirection = Enum.EasingDirection.Out
		any_new_result1_9.playTime = 0.3
		return any_new_result1_9
	end;
	Test2 = function() -- Line 35, Named "Test2"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_3 = CameraShakeInstance_upvr.new(0, 0, 0, 0)
		any_new_result1_3.PositionInfluence = Vector3.new(0, 0, 0)
		any_new_result1_3.RotationInfluence = Vector3.new(0, 5, 0)
		any_new_result1_3.EasingStyle = Enum.EasingStyle.Quart
		any_new_result1_3.EasingDirection = Enum.EasingDirection.Out
		any_new_result1_3.playTime = 0.3
		return any_new_result1_3
	end;
	Shot = function() -- Line 44, Named "Shot"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_21 = CameraShakeInstance_upvr.new(2, 8, 0, 0.3)
		any_new_result1_21.PositionInfluence = Vector3.new(0.10000, 0.20000, 0.10000)
		any_new_result1_21.RotationInfluence = Vector3.new(1.20000, 1, 1)
		return any_new_result1_21
	end;
	Attack = function() -- Line 50, Named "Attack"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_10 = CameraShakeInstance_upvr.new(2, 10, 0.25, 0.35)
		any_new_result1_10.PositionInfluence = Vector3.new(0.15000, 0.15000, 0.15000)
		any_new_result1_10.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_10
	end;
	AttackLong = function() -- Line 56, Named "AttackLong"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_28 = CameraShakeInstance_upvr.new(2, 10, 0.1, 1.7)
		any_new_result1_28.PositionInfluence = Vector3.new(0.10000, 0.05000, 0.05000)
		any_new_result1_28.RotationInfluence = Vector3.new(1, 0.5, 0.5)
		return any_new_result1_28
	end;
	QuickAttack = function() -- Line 62, Named "QuickAttack"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_26 = CameraShakeInstance_upvr.new(2, 10, 0, 0.3)
		any_new_result1_26.PositionInfluence = Vector3.new(0.15000, 0.15000, 0.15000)
		any_new_result1_26.RotationInfluence = Vector3.new(1.20000, 1, 1)
		return any_new_result1_26
	end;
	HeavyAttack = function() -- Line 68, Named "HeavyAttack"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_11 = CameraShakeInstance_upvr.new(3, 10, 0, 0.55)
		any_new_result1_11.PositionInfluence = Vector3.new(0.30000, 0.25, 0.25)
		any_new_result1_11.RotationInfluence = Vector3.new(1.5, 1, 1.20000)
		return any_new_result1_11
	end;
	Clash = function() -- Line 74, Named "Clash"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_4 = CameraShakeInstance_upvr.new(6, 22, 0.1, 0.5)
		any_new_result1_4.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_4.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_4
	end;
	Hit = function() -- Line 80, Named "Hit"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1 = CameraShakeInstance_upvr.new(2.75, 12.5, 0.1, 0.5)
		any_new_result1.PositionInfluence = Vector3.new(0.15000, 0.15000, 0.15000)
		any_new_result1.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1
	end;
	Bump = function() -- Line 86, Named "Bump"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_14 = CameraShakeInstance_upvr.new(2.5, 4, 0.1, 0.75)
		any_new_result1_14.PositionInfluence = Vector3.new(0.15000, 0.15000, 0.15000)
		any_new_result1_14.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_14
	end;
	Bump2 = function() -- Line 92, Named "Bump2"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_20 = CameraShakeInstance_upvr.new(2.5, 4, 0.1, 0.75)
		any_new_result1_20.PositionInfluence = Vector3.new(0.15000, 0.15000, 0.15000)
		any_new_result1_20.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_20
	end;
	Bump3 = function() -- Line 98, Named "Bump3"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_12 = CameraShakeInstance_upvr.new(1, 2, 0.1, 0.75)
		any_new_result1_12.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_12.RotationInfluence = Vector3.new(2, 2, 2)
		return any_new_result1_12
	end;
	Bump4 = function() -- Line 104, Named "Bump4"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_15 = CameraShakeInstance_upvr.new(3, 12, 0.6, 1)
		any_new_result1_15.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_15.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)
		return any_new_result1_15
	end;
	TinyShake = function() -- Line 110, Named "TinyShake"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_8 = CameraShakeInstance_upvr.new(4, 8, 0, 0.2)
		any_new_result1_8.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_8.RotationInfluence = Vector3.new(1.5, 0.60000, 1.5)
		return any_new_result1_8
	end;
	TinyShake2 = function() -- Line 116, Named "TinyShake2"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_13 = CameraShakeInstance_upvr.new(4, 9, 0, 0.2)
		any_new_result1_13.PositionInfluence = Vector3.new(0.40000, 0.30000, 0.40000)
		any_new_result1_13.RotationInfluence = Vector3.new(1.70000, 0.60000, 1.70000)
		return any_new_result1_13
	end;
	TinyShake3 = function() -- Line 122, Named "TinyShake3"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_22 = CameraShakeInstance_upvr.new(5, 10, 0, 0.2)
		any_new_result1_22.PositionInfluence = Vector3.new(0.5, 0.30000, 0.5)
		any_new_result1_22.RotationInfluence = Vector3.new(2, 0.60000, 2)
		return any_new_result1_22
	end;
	MiddleShake = function() -- Line 128, Named "MiddleShake"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_23 = CameraShakeInstance_upvr.new(5, 10, 0.1, 0.5)
		any_new_result1_23.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_23.RotationInfluence = Vector3.new(2, 1, 2)
		return any_new_result1_23
	end;
	MiddleShakeLong = function() -- Line 134, Named "MiddleShakeLong"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_27 = CameraShakeInstance_upvr.new(5, 10, 0.1, 0.8)
		any_new_result1_27.PositionInfluence = Vector3.new(0.30000, 0.30000, 0.30000)
		any_new_result1_27.RotationInfluence = Vector3.new(2, 1, 2)
		return any_new_result1_27
	end;
	MiddleShakeLong2 = function() -- Line 140, Named "MiddleShakeLong2"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_24 = CameraShakeInstance_upvr.new(5, 10, 0.1, 0.8)
		any_new_result1_24.PositionInfluence = Vector3.new(0.30000, 0.20000, 0.20000)
		any_new_result1_24.RotationInfluence = Vector3.new(2, 1, 1.5)
		return any_new_result1_24
	end;
	Explosion = function() -- Line 148, Named "Explosion"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_16 = CameraShakeInstance_upvr.new(5, 10, 0, 1.5)
		any_new_result1_16.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		any_new_result1_16.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_16
	end;
	Explosion2 = function() -- Line 155, Named "Explosion2"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_19 = CameraShakeInstance_upvr.new(5, 10, 0, 0.3)
		any_new_result1_19.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		any_new_result1_19.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_19
	end;
	Explosion3 = function() -- Line 161, Named "Explosion3"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_25 = CameraShakeInstance_upvr.new(5, 10, 0.2, 0.5)
		any_new_result1_25.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		any_new_result1_25.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_25
	end;
	Explosion4 = function() -- Line 168, Named "Explosion4"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_18 = CameraShakeInstance_upvr.new(5, 10, 0.2, 1)
		any_new_result1_18.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		any_new_result1_18.RotationInfluence = Vector3.new(1.5, 1.5, 1.5)
		return any_new_result1_18
	end;
	Earthquake = function() -- Line 177, Named "Earthquake"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_17 = CameraShakeInstance_upvr.new(0.6, 3.5, 2, 10)
		any_new_result1_17.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		any_new_result1_17.RotationInfluence = Vector3.new(1, 1, 4)
		return any_new_result1_17
	end;
	BadTrip = function() -- Line 187, Named "BadTrip"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_7 = CameraShakeInstance_upvr.new(10, 0.15, 5, 10)
		any_new_result1_7.PositionInfluence = Vector3.new(0, 0, 0.15000)
		any_new_result1_7.RotationInfluence = Vector3.new(2, 1, 4)
		return any_new_result1_7
	end;
	HandheldCamera = function() -- Line 197, Named "HandheldCamera"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_6 = CameraShakeInstance_upvr.new(1, 0.25, 5, 10)
		any_new_result1_6.PositionInfluence = Vector3.new(0, 0, 0)
		any_new_result1_6.RotationInfluence = Vector3.new(1, 0.5, 0.5)
		return any_new_result1_6
	end;
	Vibration = function() -- Line 207, Named "Vibration"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_2 = CameraShakeInstance_upvr.new(0.4, 20, 2, 2)
		any_new_result1_2.PositionInfluence = Vector3.new(0, 0.15000, 0)
		any_new_result1_2.RotationInfluence = Vector3.new(1.25, 0, 4)
		return any_new_result1_2
	end;
	RoughDriving = function() -- Line 217, Named "RoughDriving"
		--[[ Upvalues[1]:
			[1]: CameraShakeInstance_upvr (readonly)
		]]
		local any_new_result1_5 = CameraShakeInstance_upvr.new(1, 2, 1, 1)
		any_new_result1_5.PositionInfluence = Vector3.new(0, 0, 0)
		any_new_result1_5.RotationInfluence = Vector3.new(1, 1, 1)
		return any_new_result1_5
	end;
}
return setmetatable({}, {
	__index = function(arg1, arg2) -- Line 229, Named "__index"
		--[[ Upvalues[1]:
			[1]: tbl_upvr (readonly)
		]]
		local var32 = tbl_upvr[arg2]
		if type(var32) == "function" then
			return var32()
		end
		error("No preset found with index \""..arg2..'"')
	end;
})