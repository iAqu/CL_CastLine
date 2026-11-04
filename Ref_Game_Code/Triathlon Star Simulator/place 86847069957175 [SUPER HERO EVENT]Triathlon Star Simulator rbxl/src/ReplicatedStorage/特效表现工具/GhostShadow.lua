-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:51
-- Luau version 6, Types version 3
-- Time taken: 0.003447 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
local Debris_upvr = game:GetService("Debris")
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.Spawn_Normal_Ghost(arg1, arg2, arg3, arg4, arg5) -- Line 13
	--[[ Upvalues[3]:
		[1]: VisibleMgr_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: TweenService_upvr (readonly)
	]]
	if not arg3 then
		local Color3_new_result1 = Color3.new(0, 0, 0)
	end
	if not arg2 then
	end
	if not arg4 then
		local var19 = 0.5
	end
	if not arg1 then
	else
		if not arg5 then
		end
		arg1.Archivable = true
		local clone_upvr = arg1:Clone()
		arg1.Archivable = false
		for _, v in pairs(clone_upvr:GetChildren()) do
			if v:IsA("LocalScript") then
				v:Destroy()
			end
		end
		clone_upvr.Name = arg1.Name.."Shadow"
		clone_upvr.Parent = workspace
		VisibleMgr_upvr.AnchoredAll(clone_upvr)
		VisibleMgr_upvr.UnQueryAll(clone_upvr)
		VisibleMgr_upvr.UnCollideAll(clone_upvr)
		VisibleMgr_upvr.UnTouchAll(clone_upvr)
		VisibleMgr_upvr.SetPlayerCollideID(clone_upvr)
		clone_upvr:ScaleTo(1)
		local descendants = clone_upvr:GetDescendants()
		table.insert(descendants, clone_upvr)
		for _, v_2 in pairs(descendants) do
			if v_2:IsA("Shirt") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("Pants") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("MeshPart") then
				v_2.Transparency += (1 - v_2.Transparency) * var19
				v_2.Material = Enum.Material.Neon
				v_2.TextureID = ""
				v_2.Color = Color3_new_result1
			end
			if v_2:IsA("Part") then
				v_2.Transparency += (1 - v_2.Transparency) * var19
				v_2.Material = Enum.Material.Neon
				v_2.Color = Color3_new_result1
			end
			if v_2:IsA("Decal") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("SpecialMesh") then
				v_2.TextureId = ""
			end
			if v_2:IsA("ParticleEmitter") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("Beam") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("BillboardGui") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("SurfaceGui") then
				Debris_upvr:AddItem(v_2, 0)
			end
			if v_2:IsA("Texture") then
				Debris_upvr:AddItem(v_2, 0)
			end
		end
		for _, v_3 in pairs(descendants) do
			if v_3:IsA("BasePart") then
				TweenService_upvr:Create(v_3, TweenInfo.new(0.5), {
					Transparency = 1;
				}):Play()
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		delay(0.5, function() -- Line 146
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: clone_upvr (readonly)
			]]
			Debris_upvr:AddItem(clone_upvr, 0)
		end)
	end
end
function module_upvr.Spawn_Several_Ghosts(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 153
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg5 then
	end
	if not arg6 then
	end
	local const_number_upvw_2 = 1
	local const_number_upvw = 0.5
	spawn(function() -- Line 163
		--[[ Upvalues[7]:
			[1]: const_number_upvw_2 (read and write)
			[2]: arg1 (readonly)
			[3]: module_upvr (copied, readonly)
			[4]: arg2 (readonly)
			[5]: arg3 (readonly)
			[6]: arg4 (readonly)
			[7]: const_number_upvw (read and write)
		]]
		for _ = 1, const_number_upvw_2 do
			if arg1 then
				module_upvr.Spawn_Normal_Ghost(arg1, arg2, arg3, arg4)
			end
			task.wait(const_number_upvw)
		end
	end)
end
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local RunService_upvr = game:GetService("RunService")
function module_upvr.Ghost_Shadow_On(arg1, arg2, arg3, arg4, arg5) -- Line 177
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		local any_GetIns_result1_upvr = InsMgr_upvr.GetIns("GhostShadow", "BoolValue", arg1)
		if any_GetIns_result1_upvr.Value then return end
		any_GetIns_result1_upvr.Value = true
		local var41_upvw
		local var42_upvw = 0
		var41_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_2) -- Line 191
			--[[ Upvalues[9]:
				[1]: arg1 (readonly)
				[2]: any_GetIns_result1_upvr (readonly)
				[3]: var41_upvw (read and write)
				[4]: var42_upvw (read and write)
				[5]: arg5 (readonly)
				[6]: module_upvr (copied, readonly)
				[7]: arg2 (readonly)
				[8]: arg3 (readonly)
				[9]: arg4 (readonly)
			]]
			if not arg1 or not any_GetIns_result1_upvr or any_GetIns_result1_upvr.Value == false then
				var41_upvw:Disconnect()
				var41_upvw = nil
			else
				if arg5 <= var42_upvw then
					module_upvr.Spawn_Normal_Ghost(arg1, arg2, arg3, arg4)
					var42_upvw = 0
				end
				var42_upvw += arg1_2
			end
		end)
	end
end
function module_upvr.Ghost_Shadow_Off(arg1) -- Line 214
	if not arg1 then
	else
		local GhostShadow = arg1:FindFirstChild("GhostShadow")
		if GhostShadow then
			GhostShadow.Value = false
		end
	end
end
return module_upvr