-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:58
-- Luau version 6, Types version 3
-- Time taken: 0.001656 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ForceModule_upvr = require(ReplicatedStorage.Tool.ForceModule)
function module.Kick_Model_Back(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 14
	--[[ Upvalues[1]:
		[1]: ForceModule_upvr (readonly)
	]]
	if not arg1 then
	else
		if arg1:IsA("Model") then
		end
		if arg1:IsA("BasePart") then
			local var8 = arg1
		end
		if not var8 then return end
		if not arg6 then
		end
		local descendants = arg1:GetDescendants()
		table.insert(descendants, var8)
		for _, v in pairs(descendants) do
			if v:IsA("BasePart") then
			end
		end
		ForceModule_upvr.ApplyVelocity(var8, arg3, 4.8 * arg2 * arg3 * arg4, arg5)
	end
end
local BezierCurve_upvr = require(ReplicatedStorage["特效表现工具"].BezierCurve)
function module.Kick_Back_HeartBeat(arg1, arg2, arg3, arg4) -- Line 63
	--[[ Upvalues[1]:
		[1]: BezierCurve_upvr (readonly)
	]]
	if arg1:GetAttribute("IsHeartbeatMove") then
	else
		arg1:SetAttribute("IsHeartbeatMove", true)
		local X = arg2.X
		local Z = arg2.Z
		local Position = arg1:GetPivot().Position
		local var17 = Position + (Vector3.new(arg2.X, 0, arg2.Z).Unit) * (arg3 * arg4)
		BezierCurve_upvr.QuadraticBezierCurves_Kick(60, 60, arg1, Position, (Position + var17) / 2 + Vector3.new(0, (arg2.Y / math.pow(X * X + Z * Z, 0.5)) * ((Position + var17).Magnitude / 2), 0), var17, function() -- Line 86
		end, function() -- Line 90
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:SetAttribute("IsHeartbeatMove", false)
		end)
	end
end
return module