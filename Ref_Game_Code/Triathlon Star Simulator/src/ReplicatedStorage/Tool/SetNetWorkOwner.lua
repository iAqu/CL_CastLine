-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:09
-- Luau version 6, Types version 3
-- Time taken: 0.003735 seconds

local module = {}
local function _(arg1, arg2, arg3, arg4, arg5) -- Line 3, Named "SetNewWork"
	local RootPart_upvr = arg3.RootPart
	if not RootPart_upvr then
	else
		local var4_upvw
		local var5_upvw = 0
		var4_upvw = game["Run Service"].Heartbeat:Connect(function(arg1_2) -- Line 12
			--[[ Upvalues[8]:
				[1]: arg3 (readonly)
				[2]: RootPart_upvr (readonly)
				[3]: arg4 (readonly)
				[4]: arg2 (readonly)
				[5]: var4_upvw (read and write)
				[6]: var5_upvw (read and write)
				[7]: arg5 (readonly)
				[8]: arg1 (readonly)
			]]
			if not arg3 or not RootPart_upvr or not arg4 or arg3.Health <= 0 then
				if RootPart_upvr:CanSetNetworkOwnership() and RootPart_upvr.Anchored == false then
					arg4:SetAttribute("NetWorkOwner", arg2.UserId)
					RootPart_upvr:SetNetworkOwner(arg2)
				end
				var4_upvw:Disconnect()
				var4_upvw = nil
			else
				if var5_upvw < arg5 and RootPart_upvr and arg4 and RootPart_upvr:CanSetNetworkOwnership() and RootPart_upvr.Anchored == false then
					arg4:SetAttribute("NetWorkOwner", arg1.UserId)
					RootPart_upvr:SetNetworkOwner(arg1)
				end
				if arg5 <= var5_upvw and RootPart_upvr and arg4 and RootPart_upvr:CanSetNetworkOwnership() and RootPart_upvr.Anchored == false then
					arg4:SetAttribute("NetWorkOwner", arg2.UserId)
					RootPart_upvr:SetNetworkOwner(arg2)
				end
				if arg5 <= var5_upvw and RootPart_upvr and RootPart_upvr:CanSetNetworkOwnership() and RootPart_upvr:GetNetworkOwner() == arg2 then
					var4_upvw:Disconnect()
					var4_upvw = nil
					return
				end
				if arg5 + 0.5 <= var5_upvw then
					var4_upvw:Disconnect()
					var4_upvw = nil
					return
				end
				var5_upvw += arg1_2
			end
		end)
	end
end
function module.SetPlrNetworkOwnerToPlayer(arg1, arg2, arg3) -- Line 72
	local any_GetPlayerByUserId_result1_upvr = game.Players:GetPlayerByUserId(arg2)
	if not any_GetPlayerByUserId_result1_upvr then
		return false
	end
	local Character_3_upvr = any_GetPlayerByUserId_result1_upvr.Character
	if not Character_3_upvr then
		return false
	end
	local class_Humanoid_upvr = Character_3_upvr:FindFirstChildOfClass("Humanoid")
	if class_Humanoid_upvr == nil or class_Humanoid_upvr.RootPart == nil or class_Humanoid_upvr.Health <= 0 or not class_Humanoid_upvr.RootPart:CanSetNetworkOwnership() or class_Humanoid_upvr.RootPart.Anchored then
		return false
	end
	if class_Humanoid_upvr.RootPart:GetAttribute("NetWorkOwner") and class_Humanoid_upvr.RootPart:GetAttribute("NetWorkOwner") == arg1.UserId then
		return false
	end
	if class_Humanoid_upvr.RootPart:GetAttribute("NetWorkOwner") and class_Humanoid_upvr.RootPart:GetAttribute("NetWorkOwner") ~= any_GetPlayerByUserId_result1_upvr.UserId then
		return false
	end
	local RootPart_upvr_2 = class_Humanoid_upvr.RootPart
	if not RootPart_upvr_2 then
	else
		local var11_upvw
		local var12_upvw = 0
		var11_upvw = game["Run Service"].Heartbeat:Connect(function(arg1_3) -- Line 12
			--[[ Upvalues[8]:
				[1]: class_Humanoid_upvr (readonly)
				[2]: RootPart_upvr_2 (readonly)
				[3]: Character_3_upvr (readonly)
				[4]: any_GetPlayerByUserId_result1_upvr (readonly)
				[5]: var11_upvw (read and write)
				[6]: var12_upvw (read and write)
				[7]: arg3 (readonly)
				[8]: arg1 (readonly)
			]]
			if not class_Humanoid_upvr or not RootPart_upvr_2 or not Character_3_upvr or class_Humanoid_upvr.Health <= 0 then
				if RootPart_upvr_2:CanSetNetworkOwnership() and RootPart_upvr_2.Anchored == false then
					Character_3_upvr:SetAttribute("NetWorkOwner", any_GetPlayerByUserId_result1_upvr.UserId)
					RootPart_upvr_2:SetNetworkOwner(any_GetPlayerByUserId_result1_upvr)
				end
				var11_upvw:Disconnect()
				var11_upvw = nil
			else
				if var12_upvw < arg3 and RootPart_upvr_2 and Character_3_upvr and RootPart_upvr_2:CanSetNetworkOwnership() and RootPart_upvr_2.Anchored == false then
					Character_3_upvr:SetAttribute("NetWorkOwner", arg1.UserId)
					RootPart_upvr_2:SetNetworkOwner(arg1)
				end
				if arg3 <= var12_upvw and RootPart_upvr_2 and Character_3_upvr and RootPart_upvr_2:CanSetNetworkOwnership() and RootPart_upvr_2.Anchored == false then
					Character_3_upvr:SetAttribute("NetWorkOwner", any_GetPlayerByUserId_result1_upvr.UserId)
					RootPart_upvr_2:SetNetworkOwner(any_GetPlayerByUserId_result1_upvr)
				end
				if arg3 <= var12_upvw and RootPart_upvr_2 and RootPart_upvr_2:CanSetNetworkOwnership() and RootPart_upvr_2:GetNetworkOwner() == any_GetPlayerByUserId_result1_upvr then
					var11_upvw:Disconnect()
					var11_upvw = nil
					return
				end
				if arg3 + 0.5 <= var12_upvw then
					var11_upvw:Disconnect()
					var11_upvw = nil
					return
				end
				var12_upvw += arg1_3
			end
		end)
	end
	return true
end
function module.SetPlrNetWorkOwnerToService(arg1) -- Line 103
	if not arg1 then
		return false
	end
	local Character = arg1.Character
	if not Character then
		return false
	end
	local class_Humanoid_2 = Character:FindFirstChildOfClass("Humanoid")
	if class_Humanoid_2 == nil or class_Humanoid_2.RootPart == nil or class_Humanoid_2.Health <= 0 or not class_Humanoid_2.RootPart:CanSetNetworkOwnership() or class_Humanoid_2.RootPart.Anchored then
		return false
	end
	if class_Humanoid_2.RootPart:GetAttribute("NetWorkOwner") and class_Humanoid_2.RootPart:GetAttribute("NetWorkOwner") ~= arg1.UserId and class_Humanoid_2.RootPart:GetAttribute("NetWorkOwner") ~= 0 then
		return false
	end
	class_Humanoid_2.RootPart:SetAttribute("NetWorkOwner", 0)
	class_Humanoid_2.RootPart:SetNetworkOwner(nil)
	return true
end
function module.SetPlrNetWorkOwnerToSelf(arg1) -- Line 131
	if not arg1 then
		return false
	end
	local Character_2 = arg1.Character
	if not Character_2 then
		return false
	end
	local class_Humanoid = Character_2:FindFirstChildOfClass("Humanoid")
	if class_Humanoid == nil or class_Humanoid.RootPart == nil or class_Humanoid.Health <= 0 or not class_Humanoid.RootPart:CanSetNetworkOwnership() or class_Humanoid.RootPart.Anchored then
		return false
	end
	class_Humanoid.RootPart:SetAttribute("NetWorkOwner", arg1.UserId)
	class_Humanoid.RootPart:SetNetworkOwner(arg1)
	return true
end
return module