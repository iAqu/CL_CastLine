-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:11
-- Luau version 6, Types version 3
-- Time taken: 0.001965 seconds

local module_upvr = {}
local RunService_upvr = game:GetService("RunService")
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local function _(arg1, arg2) -- Line 9, Named "GetTime"
	return arg2 - arg1 % arg2
end
function module_upvr.DayPoint(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var4 = 0
	if RunService_upvr:IsServer() then
		var4 = os.time()
	else
		var4 = LocalData_upvr:GetSerVerTime()
	end
	return 86400 - (var4 - arg1) % 86400
end
function module_upvr.WeekPoint(arg1) -- Line 34
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var5 = 0
	if RunService_upvr:IsServer() then
		var5 = os.time()
	else
		var5 = LocalData_upvr:GetSerVerTime()
	end
	return 604800 - (var5 - arg1) % 604800
end
function module_upvr.GetDayTimeLess(arg1, arg2) -- Line 52
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var6 = 0
	if RunService_upvr:IsServer() then
		var6 = os.time()
	else
		var6 = LocalData_upvr:GetSerVerTime()
	end
	if arg1 <= var6 then
		return true
	end
	return false
end
function module_upvr.CheckIsOtherDay(arg1, arg2) -- Line 72
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var7 = 0
	if RunService_upvr:IsServer() then
		var7 = os.time()
	else
		var7 = LocalData_upvr:GetSerVerTime()
	end
	if arg1 <= var7 then
		return true
	end
	return false
end
function module_upvr.CheckIsOtherWeek(arg1, arg2) -- Line 91
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var8 = 0
	if RunService_upvr:IsServer() then
		var8 = os.time()
	else
		var8 = LocalData_upvr:GetSerVerTime()
	end
	if arg1 <= var8 then
		return true
	end
	return false
end
function module_upvr.GetSpecialTickBySec(arg1) -- Line 110
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: LocalData_upvr (readonly)
	]]
	local var9 = 0
	local var10
	if RunService_upvr:IsServer() then
		var9 = os.time()
	else
		var9 = LocalData_upvr:GetSerVerTime()
	end
	if not var10 then
		var10 = 0
	end
	return (var9) - (os.date("%M") * 60 + os.date("%S")) + var10
end
function module_upvr.GetSpecialTickByMin(arg1) -- Line 131
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	end
	return module_upvr.GetSpecialTickBySec(0 * 60)
end
return module_upvr