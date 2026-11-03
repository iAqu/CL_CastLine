-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:38
-- Luau version 6, Types version 3
-- Time taken: 0.011095 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local tbl_upvr_4 = {}
local tbl_upvr = {}
local tbl_upvr_3 = {}
local tbl_upvr_2 = {}
local any_new2DTabular_result1_upvr = Util_upvr.Hashing.new2DTabular({
	GridSize = 60;
})
for _, v in pairs(Util_upvr.ReplicatedStorage.Shared.ClientVisualEffects:GetChildren()) do
	tbl_upvr_3[v.Name] = require(v)
end
local any_GetEasingStyles_result1_upvr = Util_upvr.EasingUtil:GetEasingStyles()
local function CreateEffectObject_upvr(arg1) -- Line 22, Named "CreateEffectObject"
	--[[ Upvalues[2]:
		[1]: any_GetEasingStyles_result1_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	local var17 = arg1.EasingType or "Linear"
	local var18 = any_GetEasingStyles_result1_upvr[var17]
	assert(var18, "EasingStep not found: "..var17)
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local tbl = {
		ID = Util_upvr.String.Random(16);
		EffectID = arg1.EffectID;
		EasingType = var17;
	}
	local StartTime = arg1.StartTime
	if not StartTime then
		StartTime = Util_upvr.Time.GetSyncedUTC()
	end
	tbl.StartTime = StartTime
	tbl.Name = arg1.Name
	tbl.Target = arg1.Target
	tbl.RequestID = arg1.RequestID
	tbl.EasingStep = var18
	tbl.Maid = any_new_result1_upvr
	tbl.Position = arg1.Position
	tbl.SecondsPassed = arg1.SecondsPassed or 0
	tbl.Duration = arg1.Duration or 1
	local var22_upvw
	function tbl.Destroy(arg1_2, arg2, ...) -- Line 48
		--[[ Upvalues[2]:
			[1]: var22_upvw (read and write)
			[2]: any_new_result1_upvr (readonly)
		]]
		if arg2 and var22_upvw.StepFunction then
			local var23 = arg2
			if not var23 then
				var23 = var22_upvw.Progress
			end
			var22_upvw.StepFunction(var23)
		end
		any_new_result1_upvr:Destroy()
	end
	tbl.Finished = Util_upvr.Signal.new()
	var22_upvw = tbl
	return var22_upvw
end
function module_upvr.CreateEffect(arg1, arg2, ...) -- Line 62
	--[[ Upvalues[6]:
		[1]: CreateEffectObject_upvr (readonly)
		[2]: tbl_upvr_3 (readonly)
		[3]: tbl_upvr_4 (readonly)
		[4]: tbl_upvr (readonly)
		[5]: any_new2DTabular_result1_upvr (readonly)
		[6]: tbl_upvr_2 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local CreateEffectObject_upvr_result1_upvr = CreateEffectObject_upvr(arg2)
	assert(CreateEffectObject_upvr_result1_upvr, "Failed to create effect!")
	local EffectID = CreateEffectObject_upvr_result1_upvr.EffectID
	local var26 = EffectID
	if var26 then
		if typeof(EffectID) ~= "string" then
			var26 = false
		else
			var26 = true
		end
	end
	assert(var26, "Invalid Given Value!")
	if not CreateEffectObject_upvr_result1_upvr.RequestID then
		local ID_upvr = CreateEffectObject_upvr_result1_upvr.ID
	end
	local var28 = tbl_upvr_3[EffectID]
	assert(var28, "Missing EffectModule for "..EffectID)
	local pcall_result1_2, pcall_result2_4 = pcall(var28, ...)
	local var31
	if pcall_result1_2 then
		var31 = typeof(pcall_result2_4)
		if var31 == "table" then
			var31 = CreateEffectObject_upvr_result1_upvr.Maid
			var31.ClearOnEnd = pcall_result2_4.ClearOnEnd
		end
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var31 = pcall_result2_4
			return var31
		end
		if typeof(pcall_result2_4) ~= "function" or not INLINED() then
			var31 = pcall_result2_4.Step
		end
	else
		var31 = tbl_upvr_4
		var31[arg2.RequestID] = CreateEffectObject_upvr_result1_upvr
	end
	CreateEffectObject_upvr_result1_upvr.EffectID = EffectID
	CreateEffectObject_upvr_result1_upvr.StepFunction = var31
	CreateEffectObject_upvr_result1_upvr.Maid:GiveTask(function() -- Line 93
		--[[ Upvalues[1]:
			[1]: CreateEffectObject_upvr_result1_upvr (readonly)
		]]
		if CreateEffectObject_upvr_result1_upvr.EndingArguments then
			CreateEffectObject_upvr_result1_upvr.Finished:Fire(CreateEffectObject_upvr_result1_upvr.Progress, table.unpack(CreateEffectObject_upvr_result1_upvr.EndingArguments))
		else
			CreateEffectObject_upvr_result1_upvr.Finished:Fire(CreateEffectObject_upvr_result1_upvr.Progress)
		end
	end)
	tbl_upvr[ID_upvr] = {CreateEffectObject_upvr_result1_upvr, ...}
	CreateEffectObject_upvr_result1_upvr.Maid:GiveTask(function() -- Line 103
		--[[ Upvalues[2]:
			[1]: tbl_upvr (copied, readonly)
			[2]: ID_upvr (readonly)
		]]
		tbl_upvr[ID_upvr] = nil
	end)
	if CreateEffectObject_upvr_result1_upvr.Position then
		any_new2DTabular_result1_upvr.AddPoint(CreateEffectObject_upvr_result1_upvr, CreateEffectObject_upvr_result1_upvr.Position)
		CreateEffectObject_upvr_result1_upvr.Maid:GiveTask(function() -- Line 109
			--[[ Upvalues[2]:
				[1]: any_new2DTabular_result1_upvr (copied, readonly)
				[2]: CreateEffectObject_upvr_result1_upvr (readonly)
			]]
			any_new2DTabular_result1_upvr.RemovePoint(CreateEffectObject_upvr_result1_upvr, CreateEffectObject_upvr_result1_upvr.Position)
		end)
	else
		tbl_upvr_2[ID_upvr] = CreateEffectObject_upvr_result1_upvr
		CreateEffectObject_upvr_result1_upvr.Maid:GiveTask(function() -- Line 114
			--[[ Upvalues[2]:
				[1]: tbl_upvr_2 (copied, readonly)
				[2]: ID_upvr (readonly)
			]]
			tbl_upvr_2[ID_upvr] = nil
		end)
	end
	local function UpdateEffect(arg1_3, arg2_2) -- Line 119
		--[[ Upvalues[1]:
			[1]: CreateEffectObject_upvr_result1_upvr (readonly)
		]]
		for i_2, v_2 in pairs(arg2_2) do
			CreateEffectObject_upvr_result1_upvr[i_2] = v_2
		end
		return true
	end
	CreateEffectObject_upvr_result1_upvr.UpdateEffect = UpdateEffect
	return CreateEffectObject_upvr_result1_upvr
end
function module_upvr.AbortServerEffect(arg1, ...) -- Line 129
	--[[ Upvalues[2]:
		[1]: tbl_upvr_4 (readonly)
		[2]: tbl_upvr (readonly)
	]]
	if tbl_upvr_4[arg1] then
		tbl_upvr_4[arg1] = nil
		return
	end
	local var42 = tbl_upvr[arg1]
	if not var42 then
		return false
	end
	local _1_3 = var42[1]
	if not _1_3 then
		return false
	end
	return _1_3:Destroy(...)
end
function module_upvr.UpdateEffect(arg1, arg2, arg3) -- Line 141
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var44 = tbl_upvr[arg2]
	if not var44 then
		return false
	end
	local _1_2 = var44[1]
	if not _1_2 then
		return false
	end
	return _1_2:UpdateEffect(arg3)
end
function module_upvr.AbortEffect(arg1, arg2, arg3) -- Line 149
	--[[ Upvalues[2]:
		[1]: tbl_upvr_4 (readonly)
		[2]: tbl_upvr (readonly)
	]]
	if tbl_upvr_4[arg2] then
		tbl_upvr_4[arg2] = nil
		return
	end
	local var46 = tbl_upvr[arg2]
	if not var46 then
		return false
	end
	local _1 = var46[1]
	if not _1 then
		return false
	end
	return _1:Destroy(arg3)
end
function module_upvr.CompleteEffect(arg1, arg2) -- Line 160
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:AbortEffect(arg2, 1)
end
function module_upvr.ResetEffect(arg1, arg2) -- Line 163
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:AbortEffect(arg2, 0)
end
function module_upvr.Start(arg1) -- Line 167
	--[[ Upvalues[6]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr_4 (readonly)
		[3]: tbl_upvr_3 (readonly)
		[4]: any_new2DTabular_result1_upvr (readonly)
		[5]: tbl_upvr_2 (readonly)
		[6]: module_upvr (readonly)
	]]
	Util_upvr.Thread.Every(0.5, function() -- Line 168
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: tbl_upvr_4 (copied, readonly)
			[3]: tbl_upvr_3 (copied, readonly)
		]]
		for i_3, v_3 in pairs(tbl_upvr_4) do
			local var73 = Util_upvr.Network:Invoke("GetRunningEffects")[i_3]
			if var73 then
				table.remove(var73, 1)
				local var74 = tbl_upvr_3[v_3.EffectID]
				if var74 then
					local pcall_result1_4, pcall_result2_3 = pcall(var74, table.unpack(var73))
					local var77
					if pcall_result1_4 then
						var77 = typeof(pcall_result2_3)
						if var77 == "table" then
							var77 = v_3.Maid
							var77.ClearOnEnd = pcall_result2_3.ClearOnEnd
						end
						local function INLINED_3() -- Internal function, doesn't exist in bytecode
							var77 = pcall_result2_3
							return var77
						end
						if typeof(pcall_result2_3) ~= "function" or not INLINED_3() then
							var77 = pcall_result2_3.Step
						end
						v_3.StepFunction = var77
						var77 = tbl_upvr_4
						var77[i_3] = nil
					end
				end
			end
		end
	end)
	local function _(arg1_4, arg2, arg3) -- Line 201, Named "HandleEnd"
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		if arg1_4.CheckFinished then
		else
			arg1_4.CheckFinished = true
			task.spawn(function() -- Line 204
				--[[ Upvalues[4]:
					[1]: arg1_4 (readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: arg3 (readonly)
					[4]: arg2 (readonly)
				]]
				if not arg1_4.RequestID or Util_upvr.Network:Invoke("CheckEffectCompleted", arg1_4.RequestID) then
					if arg3 and next(arg3) then
						arg1_4.EndingArguments = arg3
					end
					local var79 = arg2
					if var79 then
						var79 = arg1_4.Target or 1
					end
					arg1_4:Destroy(var79)
				else
					task.wait(0.2)
					arg1_4.CheckFinished = nil
				end
			end)
		end
	end
	local function HandleEffect_upvr(arg1_5, arg2) -- Line 217, Named "HandleEffect"
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		if arg1_5.CheckFinished then
		else
			local pcall_result1_3, pcall_result2_2, pcall_result3_upvr = pcall(arg1_5.EasingStep, arg1_5, arg2)
			if not pcall_result1_3 then
				warn("[VFXHandler/Step] ", arg1_5.Name, arg1_5, pcall_result2_2)
				return
			end
			if not arg1_5.StepFunction then
				if pcall_result3_upvr then
					if arg1_5.CheckFinished then return end
					arg1_5.CheckFinished = true
					local var84_upvr
					local var92_upvr = true
					task.spawn(function() -- Line 204
						--[[ Upvalues[4]:
							[1]: arg1_5 (readonly)
							[2]: Util_upvr (copied, readonly)
							[3]: var84_upvr (readonly)
							[4]: var92_upvr (readonly)
						]]
						if not arg1_5.RequestID or Util_upvr.Network:Invoke("CheckEffectCompleted", arg1_5.RequestID) then
							if var84_upvr and next(var84_upvr) then
								arg1_5.EndingArguments = var84_upvr
							end
							local var86 = var92_upvr
							if var86 then
								var86 = arg1_5.Target or 1
							end
							arg1_5:Destroy(var86)
						else
							task.wait(0.2)
							arg1_5.CheckFinished = nil
						end
					end)
				end
				return
			end
			var84_upvr = arg1_5.StepFunction
			var92_upvr = pcall_result2_2
			local packed_upvr = table.pack(pcall(var84_upvr, var92_upvr))
			packed_upvr.n = nil
			var84_upvr = packed_upvr
			var92_upvr = 1
			if not table.remove(var84_upvr, var92_upvr) then
				var84_upvr = warn
				var92_upvr = "[VFXHandler/Step][CRITICAL ERROR] "
				var84_upvr(var92_upvr, packed_upvr[1], debug.traceback())
				if pcall_result3_upvr then
					var84_upvr = arg1_5.CheckFinished
					if var84_upvr then return end
					var84_upvr = true
					arg1_5.CheckFinished = var84_upvr
					var84_upvr = task.spawn
					local var89_upvr
					local var90_upvr = true
					function var92_upvr() -- Line 204
						--[[ Upvalues[4]:
							[1]: arg1_5 (readonly)
							[2]: Util_upvr (copied, readonly)
							[3]: var89_upvr (readonly)
							[4]: var90_upvr (readonly)
						]]
						if not arg1_5.RequestID or Util_upvr.Network:Invoke("CheckEffectCompleted", arg1_5.RequestID) then
							if var89_upvr and next(var89_upvr) then
								arg1_5.EndingArguments = var89_upvr
							end
							local var91 = var90_upvr
							if var91 then
								var91 = arg1_5.Target or 1
							end
							arg1_5:Destroy(var91)
						else
							task.wait(0.2)
							arg1_5.CheckFinished = nil
						end
					end
					var84_upvr(var92_upvr)
				end
				return
			end
			local function INLINED_4() -- Internal function, doesn't exist in bytecode
				var84_upvr = var84_upvr(var92_upvr)
				var92_upvr = packed_upvr
				var84_upvr = next
				return var84_upvr ~= nil
			end
			if pcall_result3_upvr or INLINED_4() then
				var84_upvr = arg1_5.CheckFinished
				if var84_upvr then return end
				var84_upvr = true
				arg1_5.CheckFinished = var84_upvr
				var84_upvr = task.spawn
				function var92_upvr() -- Line 204
					--[[ Upvalues[4]:
						[1]: arg1_5 (readonly)
						[2]: Util_upvr (copied, readonly)
						[3]: packed_upvr (readonly)
						[4]: pcall_result3_upvr (readonly)
					]]
					if not arg1_5.RequestID or Util_upvr.Network:Invoke("CheckEffectCompleted", arg1_5.RequestID) then
						if packed_upvr and next(packed_upvr) then
							arg1_5.EndingArguments = packed_upvr
						end
						local var93 = pcall_result3_upvr
						if var93 then
							var93 = arg1_5.Target or 1
						end
						arg1_5:Destroy(var93)
					else
						task.wait(0.2)
						arg1_5.CheckFinished = nil
					end
				end
				var84_upvr(var92_upvr)
			end
		end
	end
	local CurrentCamera_upvr = workspace.CurrentCamera
	Util_upvr.Thread.Loop(function(arg1_6) -- Line 243
		--[[ Upvalues[4]:
			[1]: CurrentCamera_upvr (readonly)
			[2]: any_new2DTabular_result1_upvr (copied, readonly)
			[3]: HandleEffect_upvr (readonly)
			[4]: tbl_upvr_2 (copied, readonly)
		]]
		for _, v_4 in pairs(any_new2DTabular_result1_upvr.GetObjectsAround(CurrentCamera_upvr.CFrame.Position, 300)) do
			debug.profilebegin("VFXHandler[1]: "..v_4.Object.EffectID)
			HandleEffect_upvr(v_4.Object, arg1_6)
			debug.profileend()
		end
		for _, v_5 in pairs(tbl_upvr_2) do
			debug.profilebegin("VFXHandler[2]: "..v_5.EffectID)
			HandleEffect_upvr(v_5, arg1_6)
			debug.profileend()
		end
	end)
	Util_upvr.Network.Events.UpdateEffect = function(...) -- Line 258
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		module_upvr:UpdateEffect(...)
	end
	Util_upvr.Network.Events.AbortServerEffect = module_upvr.AbortServerEffect
	local function var107(...) -- Line 262
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		module_upvr:CreateEffect(...)
	end
	Util_upvr.Network.Events.CreateEffect = var107
	var107 = Util_upvr.Network:Invoke("GetRunningEffects")
	local var108 = var107
	if not var108 then
		var108 = {}
	end
	for _, v_6 in pairs(var108) do
		module_upvr:CreateEffect(table.unpack(v_6))
	end
end
Util_upvr.VFXController = module_upvr
return module_upvr