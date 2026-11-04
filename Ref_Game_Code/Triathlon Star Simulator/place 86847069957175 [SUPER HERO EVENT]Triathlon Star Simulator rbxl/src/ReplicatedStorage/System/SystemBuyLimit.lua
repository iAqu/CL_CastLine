-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:34
-- Luau version 6, Types version 3
-- Time taken: 0.001724 seconds

local module_upvr = {}
local any_GetDataStore_result1_upvr = game:GetService("DataStoreService"):GetDataStore("ShopLimit")
local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
function module_upvr.GetLimitItemNum(arg1) -- Line 9
	--[[ Upvalues[1]:
		[1]: any_GetDataStore_result1_upvr (readonly)
	]]
	local pcall_result1, pcall_result2 = pcall(function() -- Line 10
		--[[ Upvalues[2]:
			[1]: any_GetDataStore_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return any_GetDataStore_result1_upvr:GetAsync(tostring(arg1))
	end)
	return pcall_result1, pcall_result2
end
function module_upvr.RecordItemNum(arg1, arg2) -- Line 18
	--[[ Upvalues[3]:
		[1]: ServerUtil_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: any_GetDataStore_result1_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then return end
		if ServerUtil_upvr.CfgFind.FindCfgByOnlyTag(arg1) then
			local any_GetIns_result1 = ServerUtil_upvr.InsMgr.GetIns(arg1, "NumberValue", ServerUtil_upvr.InsMgr.GetIns("限量商品", "Folder", workspace))
			delay(0, function() -- Line 31
				--[[ Upvalues[5]:
					[1]: module_upvr (copied, readonly)
					[2]: arg1 (readonly)
					[3]: arg2 (readonly)
					[4]: ServerUtil_upvr (copied, readonly)
					[5]: any_GetDataStore_result1_upvr (copied, readonly)
				]]
				local any_GetLimitItemNum_result1_2, any_GetLimitItemNum_result2_2 = module_upvr.GetLimitItemNum(arg1)
				if any_GetLimitItemNum_result1_2 then
					local var11 = 0
					if tonumber(any_GetLimitItemNum_result2_2) then
						var11 = tonumber(any_GetLimitItemNum_result2_2)
					end
					local var12_upvr = var11 + arg2
					ServerUtil_upvr.Log.print("上传限量商品次数", var12_upvr)
					local pcall_result1_2, _ = pcall(function() -- Line 42
						--[[ Upvalues[3]:
							[1]: any_GetDataStore_result1_upvr (copied, readonly)
							[2]: arg1 (copied, readonly)
							[3]: var12_upvr (readonly)
						]]
						any_GetDataStore_result1_upvr:SetAsync(tostring(arg1), var12_upvr)
					end)
					if pcall_result1_2 then
						module_upvr.UpdateLimitNum()
					end
				end
			end)
			if any_GetIns_result1.Value == 0 then
				any_GetIns_result1.Value += arg2
				return
			end
			any_GetIns_result1.Value += arg2
		end
	end
end
function module_upvr.UpdateLimitNum() -- Line 60
	--[[ Upvalues[2]:
		[1]: ServerUtil_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	for _, v in pairs(ServerUtil_upvr.CfgFind.GetCfgByName("itemshopdataConf")) do
		if v.BuyLimitNum ~= "" then
			local any_GetLimitItemNum_result1, any_GetLimitItemNum_result2 = module_upvr.GetLimitItemNum(v.OnlyTag)
			if any_GetLimitItemNum_result1 and any_GetLimitItemNum_result2 then
				ServerUtil_upvr.InsMgr.GetIns(v.OnlyTag, "NumberValue", ServerUtil_upvr.InsMgr.GetIns("限量商品", "Folder", workspace)).Value = any_GetLimitItemNum_result2
			else
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				ServerUtil_upvr.InsMgr.GetIns(v.OnlyTag, "NumberValue", ServerUtil_upvr.InsMgr.GetIns("限量商品", "Folder", workspace)).Value = 0
			end
		end
	end
end
return module_upvr