-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:21
-- Luau version 6, Types version 3
-- Time taken: 0.008664 seconds

local module_upvr = {}
local tbl_upvr_2 = {}
local any_GetDataStore_result1_upvr = game:GetService("DataStoreService"):GetDataStore("Data")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local SaveMetaData = require(script.SaveMetaData)
local PLAYER_META_DATA_upvr = SaveMetaData.PLAYER_META_DATA
local PLAYER_VALUE_LIST_upvr = SaveMetaData.PLAYER_VALUE_LIST
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local UpdateLocalData_2_upvr = ReplicatedStorage_upvr.ServerMsg.UpdateLocalData
local Copy_upvr = require(ReplicatedStorage_upvr.Tool.Copy)
local function setPlayerValueInstance_upvr(arg1) -- Line 23, Named "setPlayerValueInstance"
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: PLAYER_VALUE_LIST_upvr (readonly)
	]]
	local var14 = tbl_upvr_2["Player"..arg1.UserId]
	for _, v in pairs(PLAYER_VALUE_LIST_upvr) do
		local any = Instance.new(v[2], arg1)
		any.Name = v[1]
		if tonumber(var14[v[1]]) or tostring(var14[v[1]]) then
			any.Value = var14[v[1]] or 0
		end
	end
end
local function RepairPlayerStat_upvr(arg1) -- Line 37, Named "RepairPlayerStat"
	--[[ Upvalues[3]:
		[1]: tbl_upvr_2 (readonly)
		[2]: PLAYER_META_DATA_upvr (readonly)
		[3]: Copy_upvr (readonly)
	]]
	local var21 = "Player"..arg1.UserId
	for i_2, v_2 in pairs(PLAYER_META_DATA_upvr) do
		if tbl_upvr_2[var21][tostring(i_2)] == nil then
			if typeof(v_2) == "table" then
				tbl_upvr_2[var21][tostring(i_2)] = Copy_upvr.deepCopy(v_2)
			else
				tbl_upvr_2[var21][tostring(i_2)] = v_2
			end
		end
	end
end
local function changePlayerValue_upvr(arg1) -- Line 52, Named "changePlayerValue"
	--[[ Upvalues[2]:
		[1]: PLAYER_VALUE_LIST_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	local var27 = "Player"..arg1.UserId
	for _, v_3 in pairs(PLAYER_VALUE_LIST_upvr) do
		local SOME = arg1:FindFirstChild(v_3[1])
		if SOME and SOME.ClassName ~= "Folder" and (tonumber(tbl_upvr_2[var27][v_3[1]]) or tostring(tbl_upvr_2[var27][v_3[1]])) then
			SOME.Value = tbl_upvr_2[var27][v_3[1]] or 0
		end
	end
end
local function _(arg1) -- Line 65, Named "repairBagData"
	for _, v_4 in pairs(arg1) do
		if v_4 then
			table.insert({}, v_4)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
local function _(arg1, arg2) -- Line 75, Named "setSessionData"
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	arg2.IsInServer = 1
	tbl_upvr_2[arg1] = arg2
end
local Value_upvr = game.ReplicatedStorage["游戏全局配置"]["版本号"].Value
local function setPlayerStat_upvr(arg1) -- Line 81, Named "setPlayerStat"
	--[[ Upvalues[8]:
		[1]: tbl_upvr_2 (readonly)
		[2]: any_GetDataStore_result1_upvr (readonly)
		[3]: Value_upvr (readonly)
		[4]: setPlayerStat_upvr (readonly)
		[5]: Copy_upvr (readonly)
		[6]: PLAYER_META_DATA_upvr (readonly)
		[7]: RepairPlayerStat_upvr (readonly)
		[8]: changePlayerValue_upvr (readonly)
	]]
	local var38_upvr = "Player"..arg1.UserId
	local var39 = false
	if tbl_upvr_2[var38_upvr] == nil then
		local pcall_result1, pcall_result2 = pcall(function() -- Line 86
			--[[ Upvalues[2]:
				[1]: any_GetDataStore_result1_upvr (copied, readonly)
				[2]: var38_upvr (readonly)
			]]
			return any_GetDataStore_result1_upvr:GetAsync(var38_upvr)
		end)
		if pcall_result1 then
			if pcall_result2 then
				local IsInServer = pcall_result2.IsInServer
				local LastSaveTime = pcall_result2.LastSaveTime
				if IsInServer and IsInServer == 1 then
					local LAST_VERSION = pcall_result2.LAST_VERSION
					if LAST_VERSION and Value_upvr ~= LAST_VERSION then
						pcall_result2.IsInServer = 1
						tbl_upvr_2[var38_upvr] = pcall_result2
					elseif LastSaveTime and 60 < os.time() - LastSaveTime then
						pcall_result2.IsInServer = 1
						tbl_upvr_2[var38_upvr] = pcall_result2
					else
						wait(6)
						return setPlayerStat_upvr(arg1)
					end
				else
					pcall_result2.IsInServer = 1
					tbl_upvr_2[var38_upvr] = pcall_result2
				end
			else
				tbl_upvr_2[var38_upvr] = Copy_upvr.deepCopy(PLAYER_META_DATA_upvr)
				var39 = true
			end
		else
			warn("cant get playerdata")
			arg1:Kick("Can't load your game data ,please login again!")
		end
	else
		tbl_upvr_2[var38_upvr].IsInServer = 1
	end
	RepairPlayerStat_upvr(arg1)
	changePlayerValue_upvr(arg1)
	return var39
end
local function savePlayerStat_upvr(arg1, arg2) -- Line 133, Named "savePlayerStat"
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: any_GetDataStore_result1_upvr (readonly)
	]]
	repeat
		local pcall_result1_2 = pcall(function() -- Line 138
			--[[ Upvalues[4]:
				[1]: tbl_upvr_2 (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
				[4]: any_GetDataStore_result1_upvr (copied, readonly)
			]]
			if tbl_upvr_2[arg1] then
				if arg2 and arg2 == true then
					tbl_upvr_2[arg1].IsInServer = 0
				end
				tbl_upvr_2[arg1].LastSaveTime = os.time()
			end
		end)
		if not pcall_result1_2 then
			wait(2)
		else
			warn("SaveDate Suc:"..arg1)
			return true
		end
	until 0 + 1 == 3 and pcall_result1_2
	return false
end
local function _(arg1) -- Line 166, Named "saveOnRemoving"
	--[[ Upvalues[2]:
		[1]: savePlayerStat_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	local var48_upvr = "Player"..arg1.UserId
	savePlayerStat_upvr(var48_upvr, true)
	local UserId_upvr_2 = arg1.UserId
	delay(10, function() -- Line 171
		--[[ Upvalues[3]:
			[1]: UserId_upvr_2 (readonly)
			[2]: tbl_upvr_2 (copied, readonly)
			[3]: var48_upvr (readonly)
		]]
		for _, v_5 in pairs(game.Players:GetChildren()) do
			if v_5.UserId == UserId_upvr_2 then return end
		end
		tbl_upvr_2[var48_upvr] = nil
	end)
end
local Players_upvr = game:GetService("Players")
function module_upvr.autoSave() -- Line 181
	--[[ Upvalues[3]:
		[1]: tbl_upvr_2 (readonly)
		[2]: Players_upvr (readonly)
		[3]: savePlayerStat_upvr (readonly)
	]]
	for i_6, _ in pairs(tbl_upvr_2) do
		if Players_upvr:GetPlayerByUserId(tonumber(string.split(i_6, "Player")[2])) then
			savePlayerStat_upvr(i_6)
		end
	end
end
function module_upvr.ChangeStat(arg1, arg2, arg3, arg4) -- Line 193
	--[[ Upvalues[3]:
		[1]: tbl_upvr_2 (readonly)
		[2]: changePlayerValue_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if arg4 == nil then
	end
	local var62 = "Player"..arg1.UserId
	if tbl_upvr_2[var62] and tbl_upvr_2[var62][tostring(arg2)] then
		tbl_upvr_2[var62][tostring(arg2)] = arg3
	end
	changePlayerValue_upvr(arg1)
	if true then
		module_upvr.UpdateLocalData(arg1)
	end
end
function module_upvr.GetStat(arg1) -- Line 210
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	if arg1 and tbl_upvr_2["Player"..arg1.UserId] then
		return tbl_upvr_2["Player"..arg1.UserId]
	end
	return tbl_upvr_2
end
function module_upvr.UpdateToClient() -- Line 218
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: UpdateLocalData_2_upvr (readonly)
	]]
	for _, v_7 in pairs(game.Players:GetChildren()) do
		local any_GetIns_result1_2 = InsMgr_upvr.GetIns("isUpDataData", "BoolValue", v_7)
		if any_GetIns_result1_2 then
			if any_GetIns_result1_2.Value == true then
				any_GetIns_result1_2.Value = false
				local any_GetStat_result1_3 = module_upvr.GetStat(v_7)
				if any_GetStat_result1_3 then
					UpdateLocalData_2_upvr:FireClient(v_7, any_GetStat_result1_3)
				end
			end
		end
	end
end
function module_upvr.InitialPlayerData(arg1) -- Line 231
	--[[ Upvalues[5]:
		[1]: InsMgr_upvr (readonly)
		[2]: setPlayerStat_upvr (readonly)
		[3]: setPlayerValueInstance_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: UpdateLocalData_2_upvr (readonly)
	]]
	setPlayerValueInstance_upvr(arg1)
	local any_GetStat_result1_2 = module_upvr.GetStat(arg1)
	if any_GetStat_result1_2 then
		UpdateLocalData_2_upvr:FireClient(arg1, any_GetStat_result1_2)
	end
	return true, setPlayerStat_upvr(arg1)
end
function module_upvr.PlayerLeaveSave(arg1) -- Line 249
	--[[ Upvalues[2]:
		[1]: savePlayerStat_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	local var80_upvr = "Player"..arg1.UserId
	savePlayerStat_upvr(var80_upvr, true)
	local UserId_upvr = arg1.UserId
	delay(10, function() -- Line 171
		--[[ Upvalues[3]:
			[1]: UserId_upvr (readonly)
			[2]: tbl_upvr_2 (copied, readonly)
			[3]: var80_upvr (readonly)
		]]
		for _, v_8 in pairs(game.Players:GetChildren()) do
			if v_8.UserId == UserId_upvr then return end
		end
		tbl_upvr_2[var80_upvr] = nil
	end)
end
function module_upvr.UpdateLocalData(arg1) -- Line 254
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local any_GetIns_result1_4 = InsMgr_upvr.GetIns("isUpDataData", "BoolValue", arg1)
	if any_GetIns_result1_4 then
		any_GetIns_result1_4.Value = true
	end
end
function module_upvr.TradeSave(arg1) -- Line 261
	--[[ Upvalues[1]:
		[1]: savePlayerStat_upvr (readonly)
	]]
	return savePlayerStat_upvr("Player"..arg1.UserId)
end
local tbl_upvr_3 = {"GameNextUpdateTime"}
function module_upvr.UpdateSpecialData() -- Line 271
	--[[ Upvalues[3]:
		[1]: tbl_upvr_3 (readonly)
		[2]: InsMgr_upvr (readonly)
		[3]: any_GetDataStore_result1_upvr (readonly)
	]]
	for _, v_9_upvr in pairs(tbl_upvr_3) do
		local pcall_result1_4, pcall_result2_4 = pcall(function() -- Line 275
			--[[ Upvalues[2]:
				[1]: any_GetDataStore_result1_upvr (copied, readonly)
				[2]: v_9_upvr (readonly)
			]]
			return any_GetDataStore_result1_upvr:GetAsync(v_9_upvr)
		end)
		if pcall_result1_4 then
			if pcall_result2_4 then
				InsMgr_upvr.GetIns(v_9_upvr, "NumberValue", workspace).Value = pcall_result2_4
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				InsMgr_upvr.GetIns(v_9_upvr, "NumberValue", workspace).Value = 0
			end
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			InsMgr_upvr.GetIns(v_9_upvr, "NumberValue", workspace).Value = 0
		end
	end
end
local any_GetIns_result1_upvr = InsMgr_upvr.GetIns("服务器BUFF", "Folder", game.Workspace)
function module_upvr.UpdateServerBuff() -- Line 292
	--[[ Upvalues[3]:
		[1]: any_GetDataStore_result1_upvr (readonly)
		[2]: any_GetIns_result1_upvr (readonly)
		[3]: InsMgr_upvr (readonly)
	]]
	local pcall_result1_6, pcall_result2_3 = pcall(function() -- Line 296
		--[[ Upvalues[1]:
			[1]: any_GetDataStore_result1_upvr (copied, readonly)
		]]
		return any_GetDataStore_result1_upvr:GetAsync("ServerBuff")
	end)
	if pcall_result1_6 and pcall_result2_3 then
		any_GetIns_result1_upvr:ClearAllChildren()
		for _, v_10 in pairs(pcall_result2_3) do
			local BuffName = v_10.BuffName
			local AddPower = v_10.AddPower
			if BuffName and AddPower and v_10.EndTime and v_10.StartTime then
				local any_GetIns_result1_3 = InsMgr_upvr.GetIns(BuffName, "NumberValue", any_GetIns_result1_upvr)
				any_GetIns_result1_3.Value = AddPower
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				InsMgr_upvr.GetIns("EndTime", "NumberValue", any_GetIns_result1_3).Value = v_10.EndTime
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				InsMgr_upvr.GetIns("StartTime", "NumberValue", any_GetIns_result1_3).Value = v_10.StartTime
			end
		end
	end
end
local tbl_upvr = {"LimitPet1", "LimitPet2", "LimitPet3", "LimitPet4"}
function module_upvr.UpdateLimitData() -- Line 330
	--[[ Upvalues[3]:
		[1]: InsMgr_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: any_GetDataStore_result1_upvr (readonly)
	]]
	for _, v_11_upvr in pairs(tbl_upvr) do
		local pcall_result1_5, pcall_result2_2 = pcall(function() -- Line 339
			--[[ Upvalues[2]:
				[1]: any_GetDataStore_result1_upvr (copied, readonly)
				[2]: v_11_upvr (readonly)
			]]
			return any_GetDataStore_result1_upvr:GetAsync(v_11_upvr)
		end)
		if pcall_result1_5 then
			if pcall_result2_2 then
				InsMgr_upvr.GetIns(v_11_upvr, "NumberValue", InsMgr_upvr.GetIns("限定宠物数量", "Folder", workspace)).Value = pcall_result2_2
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				InsMgr_upvr.GetIns(v_11_upvr, "NumberValue", InsMgr_upvr.GetIns("限定宠物数量", "Folder", workspace)).Value = 0
			end
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			InsMgr_upvr.GetIns(v_11_upvr, "NumberValue", InsMgr_upvr.GetIns("限定宠物数量", "Folder", workspace)).Value = 0
		end
	end
end
function module_upvr.AddLimitedHeroSellNum(arg1) -- Line 355
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: any_GetDataStore_result1_upvr (readonly)
	]]
	local pcall_result1_3, pcall_result2_5 = pcall(function() -- Line 360
		--[[ Upvalues[2]:
			[1]: any_GetDataStore_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return any_GetDataStore_result1_upvr:GetAsync(arg1)
	end)
	if pcall_result1_3 then
		if not pcall_result2_5 then
			pcall_result2_5 = 0
		end
		if pcall_result2_5 then
			InsMgr_upvr.GetIns(arg1, "NumberValue", workspace).Value = pcall_result2_5 + 1
			any_GetDataStore_result1_upvr:SetAsync(arg1, pcall_result2_5 + 1)
		end
	end
end
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
function module_upvr.GetIsPass(arg1, arg2) -- Line 377
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
	]]
	local any_GetStat_result1 = module_upvr.GetStat(arg1)
	if not any_GetStat_result1 then
		return false
	end
	local GamePass = any_GetStat_result1.GamePass
	if not GamePass then
		return false
	end
	if GamePass[tostring(arg2)] and GamePass[tostring(arg2)] == 1 then
		return true
	end
	local any_GetGamePassItemIDByOnlyID_result1 = CfgFind_upvr.GetGamePassItemIDByOnlyID(arg2)
	if any_GetGamePassItemIDByOnlyID_result1 and tonumber(any_GetGamePassItemIDByOnlyID_result1) and 1 <= require(ReplicatedStorage_upvr.System.SystemBag).GetItemCountByID(arg1, tonumber(any_GetGamePassItemIDByOnlyID_result1)) then
		return true
	end
	return false
end
return module_upvr