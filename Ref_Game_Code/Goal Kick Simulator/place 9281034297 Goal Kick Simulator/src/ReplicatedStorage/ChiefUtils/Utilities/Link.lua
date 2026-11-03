-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:37
-- Luau version 6, Types version 3
-- Time taken: 0.008300 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
local Network_upvr = require(script.Parent.Network)
local Signal_upvr = require(script.Parent.Signal)
if game:GetService("RunService"):IsClient() then
	local function ListenToDeepChanges_upvr(arg1, ...) -- Line 9, Named "ListenToDeepChanges"
		--[[ Upvalues[2]:
			[1]: Signal_upvr (readonly)
			[2]: ListenToDeepChanges_upvr (readonly)
		]]
		local args_list_3_upvr = {...}
		local module_upvr_2 = {
			Changed = Signal_upvr.new();
		}
		local tbl_2_upvr = {}
		local tbl_4 = {}
		local function __index(arg1_2, arg2) -- Line 14
			--[[ Upvalues[2]:
				[1]: tbl_2_upvr (readonly)
				[2]: arg1 (readonly)
			]]
			if tbl_2_upvr[arg2] then
				return tbl_2_upvr[arg2]
			end
			if arg1[arg2] ~= nil then
				return arg1[arg2]
			end
		end
		tbl_4.__index = __index
		local function __newindex(arg1_3, arg2, arg3) -- Line 21
			--[[ Upvalues[5]:
				[1]: arg1 (readonly)
				[2]: tbl_2_upvr (readonly)
				[3]: ListenToDeepChanges_upvr (copied, readonly)
				[4]: args_list_3_upvr (readonly)
				[5]: module_upvr_2 (readonly)
			]]
			if arg3 == nil then
				arg1[arg2] = nil
				tbl_2_upvr[arg2] = nil
			elseif typeof(arg3) == "table" then
				local var20 = tbl_2_upvr[arg2]
				if var20 then
					for i_9, v_8 in pairs(arg3) do
						if i_9 ~= "Changed" then
							var20[i_9] = v_8
						end
					end
					return
				end
				if arg1[arg2] and typeof(arg1[arg2]) == "table" then
					for i_10, v_9 in pairs(arg3) do
						arg1[arg2][i_10] = v_9
					end
				else
					arg1[arg2] = arg3
				end
				tbl_2_upvr[arg2] = ListenToDeepChanges_upvr(arg3, arg2, unpack(args_list_3_upvr))
			else
				arg1[arg2] = arg3
			end
			task.spawn(function() -- Line 48
				--[[ Upvalues[3]:
					[1]: module_upvr_2 (copied, readonly)
					[2]: arg2 (readonly)
					[3]: arg3 (readonly)
				]]
				module_upvr_2.Changed:Fire(arg2, arg3)
			end)
		end
		tbl_4.__newindex = __newindex
		for i, v in pairs(arg1) do
			if typeof(v) == "table" then
				if arg1[i] and typeof(arg1[i]) == "table" then
					for i_2, v_2 in pairs(v) do
						arg1[i][i_2] = v_2
					end
				else
					arg1[i] = v
				end
				tbl_2_upvr[i] = ListenToDeepChanges_upvr(v, i, unpack(args_list_3_upvr))
			end
		end
		setmetatable(module_upvr_2, tbl_4)
		return module_upvr_2, arg1
	end
	local ListenToDeepChanges_upvr_result1_upvr, ListenToDeepChanges_upvr_result2_upvr = ListenToDeepChanges_upvr({})
	local function GetLink(arg1, arg2, arg3) -- Line 70
		--[[ Upvalues[1]:
			[1]: ListenToDeepChanges_upvr_result1_upvr (readonly)
		]]
		local var36 = arg2 or "PlayerData"
		while not ListenToDeepChanges_upvr_result1_upvr[var36] and not (not arg3 or os.clock() - os.clock() >= arg3) do
			task.wait()
		end
		return ListenToDeepChanges_upvr_result1_upvr[var36]
	end
	module_upvr.GetLink = GetLink
	local function GetRawLink(arg1, arg2, arg3) -- Line 78
		--[[ Upvalues[1]:
			[1]: ListenToDeepChanges_upvr_result2_upvr (readonly)
		]]
		if typeof(arg2) == "Instance" and arg2:IsA("Player") then
			warn("[WARNING] Client does not need to provide a Player instance, leave the first argument for the LinkName")
		end
		local var37 = arg2 or "PlayerData"
		while not ListenToDeepChanges_upvr_result2_upvr[var37] and not (not arg3 or os.clock() - os.clock() >= arg3) do
			task.wait()
		end
		return ListenToDeepChanges_upvr_result2_upvr[var37]
	end
	module_upvr.GetRawLink = GetRawLink
	Network_upvr.Events._LinksUpdate = function(arg1, ...) -- Line 89
		--[[ Upvalues[1]:
			[1]: ListenToDeepChanges_upvr_result1_upvr (readonly)
		]]
		local args_list = {...}
		local var42 = ListenToDeepChanges_upvr_result1_upvr
		if var42 then
			for i_3 = #args_list, 1, -1 do
				local var43 = args_list[i_3]
				local var44 = var42[var43]
				if i_3 == 1 then
					if rawget(var42, var43) then
						var42[var43] = nil
					end
					var42[var43] = arg1
				elseif not var44 then
					local tbl = {}
					var42[var43] = tbl
					var44 = tbl
				end
			end
		end
	end
	for i_4, v_3 in pairs(Network_upvr:Invoke("GetLinks")) do
		ListenToDeepChanges_upvr_result1_upvr[i_4] = v_3
		local _
	end
	return module_upvr
end
function ListenToDeepChanges_upvr(arg1, arg2, ...) -- Line 115, Named "ListenToDeepChanges"
	--[[ Upvalues[3]:
		[1]: Signal_upvr (readonly)
		[2]: var50_upvr (readonly)
		[3]: Network_upvr (readonly)
	]]
	local args_list_2_upvr = {...}
	local module_upvr_3 = {
		Changed = Signal_upvr.new();
	}
	local tbl_3_upvr = {}
	for i_7, v_6 in pairs(arg2) do
		if typeof(v_6) == "table" then
			if arg2[i_7] and typeof(arg2[i_7]) == "table" then
				for i_8, v_7 in pairs(v_6) do
					arg2[i_7][i_8] = v_7
				end
			else
				arg2[i_7] = v_6
			end
			tbl_3_upvr[i_7] = var50_upvr(arg1, v_6, i_7, unpack(args_list_2_upvr))
		end
	end
	setmetatable(module_upvr_3, {
		__index = function(arg1_4, arg2_2) -- Line 120, Named "__index"
			--[[ Upvalues[2]:
				[1]: tbl_3_upvr (readonly)
				[2]: arg2 (readonly)
			]]
			if tbl_3_upvr[arg2_2] then
				return tbl_3_upvr[arg2_2]
			end
			if arg2[arg2_2] ~= nil then
				return arg2[arg2_2]
			end
		end;
		__newindex = function(arg1_5, arg2_3, arg3) -- Line 127, Named "__newindex"
			--[[ Upvalues[7]:
				[1]: arg2 (readonly)
				[2]: tbl_3_upvr (readonly)
				[3]: var50_upvr (copied, readonly)
				[4]: arg1 (readonly)
				[5]: args_list_2_upvr (readonly)
				[6]: module_upvr_3 (readonly)
				[7]: Network_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 42 start (CF ANALYSIS FAILED)
			if arg3 == nil then
				arg2[arg2_3] = nil
				tbl_3_upvr[arg2_3] = nil
				-- KONSTANTWARNING: GOTO [69] #59
			end
			-- KONSTANTERROR: [0] 1. Error Block 42 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [9] 9. Error Block 43 start (CF ANALYSIS FAILED)
			if typeof(arg3) == "table" then
				local var63 = tbl_3_upvr[arg2_3]
				if var63 then
					for i_5, v_4 in pairs(arg3) do
						if i_5 ~= "Changed" then
							var63[i_5] = v_4
						end
					end
					return
				end
				if arg2[arg2_3] and typeof(arg2[arg2_3]) == "table" then
					for i_6, v_5 in pairs(arg3) do
						arg2[arg2_3][i_6] = v_5
					end
				else
					arg2[arg2_3] = arg3
				end
				tbl_3_upvr[arg2_3] = var50_upvr(arg1, arg3, arg2_3, unpack(args_list_2_upvr))
			else
				arg2[arg2_3] = arg3
			end
			task.spawn(function() -- Line 154
				--[[ Upvalues[3]:
					[1]: module_upvr_3 (copied, readonly)
					[2]: arg2_3 (readonly)
					[3]: arg3 (readonly)
				]]
				module_upvr_3.Changed:Fire(arg2_3, arg3)
			end)
			if arg1 and arg1.Parent then
				Network_upvr:Fire(arg1, "_LinksUpdate", arg3, arg2_3, unpack(args_list_2_upvr))
			end
			-- KONSTANTERROR: [9] 9. Error Block 43 end (CF ANALYSIS FAILED)
		end;
	})
	return module_upvr_3, arg2
end
local var50_upvr = ListenToDeepChanges_upvr
local tbl_upvr = {}
ListenToDeepChanges_upvr_result2_upvr = Network_upvr.Events
function ListenToDeepChanges_upvr_result2_upvr.GetLinks(arg1) -- Line 178
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local tostring_result1_2 = tostring(arg1.UserId)
	local var80
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var80 = tbl_upvr[tostring_result1_2].Raw
		return var80
	end
	if not tbl_upvr[tostring_result1_2] or not INLINED() then
		var80 = {}
	end
	return var80
end
function ListenToDeepChanges_upvr_result2_upvr(arg1, arg2, arg3) -- Line 183, Named "GetCacheData"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg2 then
	else
		local tostring_result1_3 = tostring(arg2.UserId)
		if arg3 then
			return tbl_upvr[tostring_result1_3]
		end
		while not tbl_upvr[tostring_result1_3] and os.time() - os.time() < 15 do
			task.wait(1)
		end
		if tbl_upvr[tostring_result1_3] then
			return tbl_upvr[tostring_result1_3]
		end
	end
end
module_upvr.GetCacheData = ListenToDeepChanges_upvr_result2_upvr
function ListenToDeepChanges_upvr_result2_upvr(arg1, arg2, arg3, arg4) -- Line 193, Named "GetLink"
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var82 = arg3 or "PlayerData"
	local any_GetCacheData_result1_2 = module_upvr:GetCacheData(arg2, arg4)
	if not any_GetCacheData_result1_2 then return end
	if arg4 then
		return any_GetCacheData_result1_2.Link[var82]
	end
	while not any_GetCacheData_result1_2.Link[var82] and os.time() - os.time() < 60 do
		warn("Waiting for Link:", var82)
		task.wait(1)
	end
	return any_GetCacheData_result1_2.Link[var82]
end
module_upvr.GetLink = ListenToDeepChanges_upvr_result2_upvr
function ListenToDeepChanges_upvr_result2_upvr(arg1, arg2, arg3, arg4) -- Line 202, Named "GetRawLink"
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var84 = arg3 or "PlayerData"
	local any_GetCacheData_result1 = module_upvr:GetCacheData(arg2, arg4)
	if not any_GetCacheData_result1 then return end
	if arg4 then
		return any_GetCacheData_result1.Raw[var84]
	end
	while not any_GetCacheData_result1.Raw[var84] and os.time() - os.time() < 60 do
		warn("Waiting for Link:", var84)
		task.wait(1)
	end
	return any_GetCacheData_result1.Raw[var84]
end
module_upvr.GetRawLink = ListenToDeepChanges_upvr_result2_upvr
function ListenToDeepChanges_upvr_result2_upvr(arg1, arg2, arg3) -- Line 211, Named "Connect"
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: var50_upvr (readonly)
	]]
	local tostring_result1 = tostring(arg1.UserId)
	if not tbl_upvr[tostring_result1] then
		local var50_upvr_result1, var50_upvr_result2 = var50_upvr(arg1, {})
		tbl_upvr[tostring_result1] = {
			Link = var50_upvr_result1;
			Raw = var50_upvr_result2;
		}
	end
	if tbl_upvr[tostring_result1] then
		local Link = tbl_upvr[tostring_result1].Link
		local Raw = tbl_upvr[tostring_result1].Raw
		local var92 = arg3
		if not var92 then
			var92 = {}
		end
		Link[arg2] = var92
		Raw[arg2] = var92
		return Link[arg2], Raw[arg2]
	end
end
module_upvr.Connect = ListenToDeepChanges_upvr_result2_upvr
ListenToDeepChanges_upvr_result2_upvr = game:GetService("Players").PlayerRemoving
ListenToDeepChanges_upvr_result2_upvr = ListenToDeepChanges_upvr_result2_upvr:Connect
ListenToDeepChanges_upvr_result2_upvr(function(arg1) -- Line 230
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local tostring_result1_4 = tostring(arg1.UserId)
	if tbl_upvr[tostring_result1_4] then
		tbl_upvr[tostring_result1_4] = nil
	end
end)
return module_upvr