-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:56
-- Luau version 6, Types version 3
-- Time taken: 0.003752 seconds

local tbl_upvr = {
	Door = function(arg1, arg2) -- Line 5, Named "Door"
		arg1.Door:PivotTo(arg1.PivotCFrame * CFrame.Angles(0, math.sin(arg2 * math.pi / 2) * math.pi / 2, 0) * CFrame.new(arg1.Offset))
	end;
	TrapDoor = function(arg1, arg2) -- Line 8, Named "TrapDoor"
		arg1.Door:PivotTo(arg1.PivotCFrame * CFrame.Angles(0, 0, math.sin(arg2 * math.pi / 2) * math.pi / 2) * CFrame.new(arg1.Offset))
	end;
	DoubleDoor = function(arg1, arg2, arg3) -- Line 11, Named "DoubleDoor"
		arg1.DoorL:PivotTo(arg1.PivotCFrameL * CFrame.Angles(0, math.sin(arg2 * math.pi / 2) * math.pi / 2, 0) * CFrame.new(arg1.OffsetL))
		arg1.DoorR:PivotTo(arg1.PivotCFrameR * CFrame.Angles(0, -math.sin(arg2 * math.pi / 2) * math.pi / 2, 0) * CFrame.new(arg1.OffsetR))
		if arg3 then
			arg3.SecondsPassed = arg1.SecondsPassed
			arg3.Progress = arg2
		end
	end;
	GarageGate = function(arg1, arg2) -- Line 19, Named "GarageGate"
		arg1.Door.PrimaryPart.Size = Vector3.new(arg1.Door.PrimaryPart.Size.X, arg1.Height * (1 - arg2), arg1.Door.PrimaryPart.Size.Z)
		arg1.Door:PivotTo(arg1.OriginCFrame * CFrame.new(0, -arg1.Height / 2 * arg2, 0))
	end;
	GarageGateX = function(arg1, arg2) -- Line 23, Named "GarageGateX"
		arg1.Door.PrimaryPart.Size = Vector3.new(arg1.Height * (1 - arg2), arg1.Door.PrimaryPart.Size.Y, arg1.Door.PrimaryPart.Size.Z)
		arg1.Door:PivotTo(arg1.OriginCFrame * CFrame.new(-arg1.Height / 2 * arg2, 0, 0))
	end;
	GarageDoorUp = function(arg1, arg2) -- Line 27, Named "GarageDoorUp"
		arg1.Door.Door.CFrame = arg1.OriginCFrame + Vector3.new(0, arg1.Height * arg2, 0)
	end;
	SideDoor = function(arg1, arg2) -- Line 30, Named "SideDoor"
		arg1.Door:PivotTo(arg1.ClosedCF:lerp(arg1.OpenedCF, math.sin(arg2 * math.pi / 2)))
	end;
	SideGate = function(arg1, arg2) -- Line 33, Named "SideGate"
		arg1.Door:PivotTo(arg1.ClosedCF:lerp(arg1.OpenedCF, math.sin(arg2 * math.pi / 2)))
	end;
	AutoSideGate = function(arg1, arg2) -- Line 36, Named "AutoSideGate"
		arg1.Door:PivotTo(arg1.ClosedCF:lerp(arg1.OpenedCF, math.sin(arg2 * math.pi / 2)))
	end;
}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function tbl_upvr.SlidingDoubleDoor(arg1, arg2) -- Line 39
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_SinBoth_result1 = Util_upvr.Easing.SinBoth(arg2)
	arg1.DoorR:PivotTo(arg1.ClosedRCF:lerp(arg1.OpenedRCF, any_SinBoth_result1))
	arg1.DoorL:PivotTo(arg1.ClosedLCF:lerp(arg1.OpenedLCF, any_SinBoth_result1))
end
function tbl_upvr.ElevatorDoor(arg1, arg2) -- Line 44
	arg1.Big.CFrame = arg1.BigCF:lerp(arg1.BigOpenCF, arg2)
	arg1.Small.CFrame = arg1.SmallCF:lerp(arg1.SmallOpenCF, arg2)
	arg1.Big.Size = arg1.BigSize:lerp(arg1.BigSizeOpen, arg2)
	arg1.Small.Size = arg1.SmallSize:lerp(arg1.SmallSizeOpen, arg2)
end
return function(arg1, arg2, arg3, ...) -- Line 53
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var5_upvr = tbl_upvr[arg2]
	if not var5_upvr then
		warn("NO DOOR", arg1, arg2, arg3, ...)
	end
	local var7 = var5_upvr
	if var7 then
		function var7(arg1_2) -- Line 58
			--[[ Upvalues[3]:
				[1]: var5_upvr (readonly)
				[2]: arg1 (readonly)
				[3]: arg3 (readonly)
			]]
			var5_upvr(arg1, arg1_2, arg3)
		end
	end
	return var7
end