-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:14
-- Luau version 6, Types version 3
-- Time taken: 0.002950 seconds

local module = {}
local InsMgr_upvr = require(game:GetService("ReplicatedStorage").Tool.InsMgr)
local RunService_upvr = game:GetService("RunService")
function module.Follow(arg1, arg2, arg3) -- Line 11
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local isFollow = arg2:FindFirstChild("isFollow")
	if isFollow and isFollow.Value == true then
	else
		local any_GetIns_result1_upvr = InsMgr_upvr.GetIns("isFollow", "BoolValue", arg2)
		any_GetIns_result1_upvr.Value = true
		local var7_upvw
		var7_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_2) -- Line 23
			--[[ Upvalues[5]:
				[1]: any_GetIns_result1_upvr (readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
				[4]: var7_upvw (read and write)
				[5]: arg3 (readonly)
			]]
			if not any_GetIns_result1_upvr or any_GetIns_result1_upvr.Value == false or not arg1 or not arg2 then
				if any_GetIns_result1_upvr then
					any_GetIns_result1_upvr.Value = false
				end
				var7_upvw:Disconnect()
				var7_upvw = nil
			else
				local any_GetPivot_result1 = arg1:GetPivot()
				local any_GetPivot_result1_2 = arg2:GetPivot()
				local Position = any_GetPivot_result1:ToWorldSpace(arg3).Position
				local Position_2 = any_GetPivot_result1_2.Position
				local Magnitude = (Position - Position_2).Magnitude
				local Unit = (Position - Position_2).Unit
				if Magnitude == 0 then
					Unit = Vector3.new(0, 0, 1)
				end
				local Rotation = any_GetPivot_result1_2.Rotation
				local any_ToWorldSpace_result1 = any_GetPivot_result1.Rotation:ToWorldSpace(arg3.Rotation)
				local degrees = math.deg(Rotation.LookVector:Angle(any_ToWorldSpace_result1.LookVector))
				local clamped = math.clamp(30000 * math.sin(math.rad(degrees / 2)) * arg1_2 / math.abs(math.deg(degrees)), 0, 1)
				if degrees < 5 then
					clamped = 1
				end
				arg2:PivotTo(Rotation:Lerp(any_ToWorldSpace_result1, clamped).Rotation + any_GetPivot_result1_2.Position + Unit * math.min(80 * arg1_2, Magnitude))
			end
		end)
	end
end
local Debris_upvr = game:GetService("Debris")
function module.StopFollow(arg1) -- Line 74
	--[[ Upvalues[1]:
		[1]: Debris_upvr (readonly)
	]]
	local isFollow_2 = arg1:FindFirstChild("isFollow")
	if isFollow_2 then
		isFollow_2.Value = false
		Debris_upvr:AddItem(isFollow_2, 0)
	end
end
return module