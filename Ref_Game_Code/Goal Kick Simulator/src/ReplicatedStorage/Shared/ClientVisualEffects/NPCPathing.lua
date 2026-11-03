-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:57
-- Luau version 6, Types version 3
-- Time taken: 0.001568 seconds

local function MoveModel_upvr(arg1, arg2, arg3) -- Line 4, Named "MoveModel"
	if arg1.PrimaryPart then
		if arg3 then
			arg1:PivotTo(CFrame.new(arg2, Vector3.new(arg3.X, arg2.Y, arg3.Z)))
			return
		end
		local Orientation = arg1.PrimaryPart.Orientation
		arg1:PivotTo(CFrame.new(arg2) * CFrame.Angles(math.rad(Orientation.X), math.rad(Orientation.Y), math.rad(Orientation.Z)))
	end
end
local function MovePart_upvr(arg1, arg2) -- Line 15, Named "MovePart"
	arg1.Position = arg2
	arg1.AssemblyLinearVelocity = (arg2 - arg1.Position) * 30
end
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
return function(arg1, arg2) -- Line 21
	--[[ Upvalues[4]:
		[1]: MoveModel_upvr (readonly)
		[2]: MovePart_upvr (readonly)
		[3]: Util_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
	]]
	local var5_upvr
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var5_upvr = MoveModel_upvr
		return var5_upvr
	end
	if not arg1:IsA("Model") or not INLINED() then
		var5_upvr = MovePart_upvr
	end
	local var7_upvw = 0
	return function(arg1_2) -- Line 24
		--[[ Upvalues[6]:
			[1]: var7_upvw (read and write)
			[2]: Util_upvr (copied, readonly)
			[3]: arg2 (readonly)
			[4]: LocalPlayer_upvr (copied, readonly)
			[5]: var5_upvr (readonly)
			[6]: arg1 (readonly)
		]]
		if os.clock() < var7_upvw then
		else
			local any_GetVectorFromTrack_result1 = Util_upvr.Vector.GetVectorFromTrack(arg1_2, arg2)
			if any_GetVectorFromTrack_result1 then
				if LocalPlayer_upvr and 300 < (Util_upvr.CurrentCamera.CFrame.Position - any_GetVectorFromTrack_result1).Magnitude then
					var7_upvw = os.clock() + 1
				end
				var5_upvr(arg1, any_GetVectorFromTrack_result1, Util_upvr.Vector.GetVectorFromTrack(arg1_2 + 0.05, arg2))
			end
		end
	end
end