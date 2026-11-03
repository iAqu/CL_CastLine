-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:15
-- Luau version 6, Types version 3
-- Time taken: 0.005256 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local any_Create_result1_upvr = Util_upvr.Create("Folder", {
	Name = "UnrenderedZones";
	Parent = game.ReplicatedStorage;
})
local tbl_upvr = {}
local tbl_3_upvr = {}
module_upvr.ZoneChanged = Util_upvr.Signal.new()
module_upvr.ZoneChangeRequested = Util_upvr.Signal.new()
local function DetectBaseParts_upvr(arg1) -- Line 21, Named "DetectBaseParts"
	if arg1:FindFirstChildWhichIsA("BasePart") then
		return true
	end
	for _, v in pairs(arg1:GetDescendants()) do
		if v:IsA("BasePart") then
			return true
		end
	end
end
local function MoveBaseParts_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 32, Named "MoveBaseParts"
	--[[ Upvalues[2]:
		[1]: DetectBaseParts_upvr (readonly)
		[2]: MoveBaseParts_upvr (readonly)
	]]
	local var28
	if arg1.Parent == arg2 then return end
	local var29 = arg3 or 30
	var28 = var28 or var29
	local Folder_2 = Instance.new("Folder")
	Folder_2.Name = arg1.Name
	Folder_2.Parent = arg2
	local children = arg1:GetChildren()
	while 0 < #children do
		local popped_2 = table.remove(children, 1)
		if DetectBaseParts_upvr(popped_2) then
			var28 = MoveBaseParts_upvr(popped_2, Folder_2, var29, var28, arg5)
		end
		if popped_2:IsA("BasePart") then
			var28 -= 1
			if var28 <= 0 then
				if arg5 then
					arg5:Fire(var29)
				end
				task.wait()
				var28 = var29
			end
		end
		popped_2.Parent = Folder_2
	end
	arg1.Parent = arg2
	for _, v_2 in pairs(Folder_2:GetChildren()) do
		v_2.Parent = arg1
	end
	Folder_2:Destroy()
	return var28
end
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local Lighting_upvr = game:GetService("Lighting")
function module_upvr.GetCurrentZone(arg1) -- Line 124
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	for i_4 in pairs(tbl_upvr) do
		if i_4.Name == module_upvr.CurrentZone then
			return i_4
		end
	end
end
Util_upvr.Network.Events.ChangeZone = function(arg1) -- Line 71, Named "ChangeZone"
	--[[ Upvalues[8]:
		[1]: module_upvr (readonly)
		[2]: tbl_3_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
		[4]: Util_upvr (readonly)
		[5]: tbl_upvr (readonly)
		[6]: MoveBaseParts_upvr (readonly)
		[7]: any_Create_result1_upvr (readonly)
		[8]: Lighting_upvr (readonly)
	]]
	if module_upvr.CurrentZone == arg1 then return end
	if next(tbl_3_upvr) then
		return false
	end
	module_upvr.ZoneChangeRequested:Fire(arg1)
	task.spawn(function() -- Line 79
		--[[ Upvalues[1]:
			[1]: LocalPlayer_upvr (copied, readonly)
		]]
		local var44 = LocalPlayer_upvr
		if var44 then
			var44 = LocalPlayer_upvr.Character
			if var44 then
				var44 = LocalPlayer_upvr.Character.PrimaryPart
			end
		end
		if var44 then
			LocalPlayer_upvr.Character.PrimaryPart.Anchored = true
		end
	end)
	Util_upvr.Loader:SetLoading("Loading Zone: "..arg1, 0)
	local tbl = {}
	for i_3, v_3 in pairs(tbl_upvr) do
		local var49
		if i_3.Name ~= arg1 then
			var49 = false
		else
			var49 = true
		end
		if var49 then
			tbl[#tbl + 1] = i_3
		end
		tbl_3_upvr[i_3] = true
		if var49 then
			MoveBaseParts_upvr(i_3, v_3)
		else
			MoveBaseParts_upvr(i_3, any_Create_result1_upvr)
		end
		tbl_3_upvr[i_3] = nil
	end
	local SOME = Lighting_upvr.LightingSettings:FindFirstChild(arg1)
	if not SOME then
		SOME = Lighting_upvr.LightingSettings.Default
	end
	Util_upvr.LightingController:SetDefault(SOME)
	Util_upvr.Network:Invoke("StreamArea")
	Util_upvr.Loader:DisableLoading()
	task.spawn(function() -- Line 108
		--[[ Upvalues[1]:
			[1]: LocalPlayer_upvr (copied, readonly)
		]]
		local var52 = LocalPlayer_upvr
		if var52 then
			var52 = LocalPlayer_upvr.Character
			if var52 then
				var52 = LocalPlayer_upvr.Character.PrimaryPart
			end
		end
		if var52 then
			LocalPlayer_upvr.Character.PrimaryPart.Anchored = false
		end
	end)
	module_upvr.CurrentZone = arg1
	module_upvr.ZoneChanged:Fire(arg1, tbl)
	Util_upvr.SoundtrackController:PlaySoundtrack(arg1, 5)
	return true
end
local tbl_2_upvr = {}
function module_upvr.Binder(arg1) -- Line 136
	--[[ Upvalues[7]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: tbl_upvr (readonly)
		[4]: tbl_2_upvr (readonly)
		[5]: tbl_3_upvr (readonly)
		[6]: MoveBaseParts_upvr (readonly)
		[7]: any_Create_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 139
		--[[ Upvalues[8]:
			[1]: module_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: tbl_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: tbl_2_upvr (copied, readonly)
			[6]: tbl_3_upvr (copied, readonly)
			[7]: MoveBaseParts_upvr (copied, readonly)
			[8]: any_Create_result1_upvr (copied, readonly)
		]]
		repeat
			task.wait()
		until module_upvr.CurrentZone and not any_new_result1_upvr.Active
		if not any_new_result1_upvr.Active then
		else
			tbl_upvr[arg1] = arg1.Parent
			tbl_2_upvr[arg1.Name] = arg1:GetAttributes()
			if arg1.Name ~= module_upvr.CurrentZone then
				tbl_3_upvr[arg1] = true
				MoveBaseParts_upvr(arg1, any_Create_result1_upvr)
				tbl_3_upvr[arg1] = nil
			end
		end
	end)
	return any_new_result1_upvr
end
Util_upvr.ZonesData = tbl_2_upvr
Util_upvr.ClientZone = module_upvr
Util_upvr.Network:Fire("LoadZone")
return module_upvr