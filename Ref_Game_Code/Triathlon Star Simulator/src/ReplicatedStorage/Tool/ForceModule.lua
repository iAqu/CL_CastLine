-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:38
-- Luau version 6, Types version 3
-- Time taken: 0.002481 seconds

local module = {}
local TweenService_upvr = game:GetService("TweenService")
local Debris_upvr = game:GetService("Debris")
function module.ApplyForce(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 13
	--[[ Upvalues[2]:
		[1]: TweenService_upvr (readonly)
		[2]: Debris_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg6 then
		end
		local ForceAttach = arg1:FindFirstChild("ForceAttach")
		if not ForceAttach then
			ForceAttach = Instance.new("Attachment", arg1)
			ForceAttach.Name = "ForceAttach"
		end
		ForceAttach.CFrame = ForceAttach.CFrame.Rotation + Vector3.new(0, 0, 0)
		local var5 = arg2
		if not var5 then
			var5 = arg1.AssemblyMass
		end
		local VectorForce_upvr = Instance.new("VectorForce", arg1)
		VectorForce_upvr.Force = (arg3) * (var5 * arg5) * 10
		VectorForce_upvr.RelativeTo = Enum.ActuatorRelativeTo.World
		VectorForce_upvr.Attachment0 = ForceAttach
		VectorForce_upvr.Enabled = true
		TweenService_upvr:Create(VectorForce_upvr, TweenInfo.new(arg4), {
			Force = Vector3.new(0, 0, 0);
		}):Play()
		delay(arg4, function() -- Line 44
			--[[ Upvalues[2]:
				[1]: VectorForce_upvr (readonly)
				[2]: Debris_upvr (copied, readonly)
			]]
			if VectorForce_upvr then
				VectorForce_upvr.Enabled = false
				Debris_upvr:AddItem(VectorForce_upvr, 0)
			end
		end)
	end
end
local RunService_upvr = game:GetService("RunService")
function module.ApplyVelocity(arg1, arg2, arg3, arg4) -- Line 53
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg1.Parent:GetAttribute("Velocity") then
	end
	local var11_upvw
	var11_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_2) -- Line 64
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg3 (readonly)
			[3]: var11_upvw (read and write)
		]]
		arg1.AssemblyLinearVelocity += arg3
		var11_upvw:Disconnect()
		var11_upvw = nil
	end)
end
return module