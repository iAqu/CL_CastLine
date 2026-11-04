-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:45
-- Luau version 6, Types version 3
-- Time taken: 0.002778 seconds

local module = {}
local function OnTimeChanged_upvr(arg1) -- Line 5, Named "OnTimeChanged"
	local maximum_3 = math.max(0, arg1)
	return string.format("%02d:%02d:%02d", math.floor(maximum_3 / 60 / 60), math.floor(maximum_3 / 60) % 60, math.floor(maximum_3) % 60)
end
local function OnTimeChangedMS_upvr(arg1) -- Line 15, Named "OnTimeChangedMS"
	local maximum_6 = math.max(0, arg1)
	return string.format("%02d:%02d", math.floor(maximum_6 / 60 / 60) * 60 + math.floor(maximum_6 / 60) % 60, math.floor(maximum_6) % 60)
end
function module.FormatTime(arg1) -- Line 25
	--[[ Upvalues[1]:
		[1]: OnTimeChanged_upvr (readonly)
	]]
	return OnTimeChanged_upvr(arg1)
end
function module.FormatTimeMS(arg1) -- Line 31
	--[[ Upvalues[2]:
		[1]: OnTimeChanged_upvr (readonly)
		[2]: OnTimeChangedMS_upvr (readonly)
	]]
	if 3600 < arg1 then
		return OnTimeChanged_upvr(arg1)
	end
	return OnTimeChangedMS_upvr(arg1)
end
local function OnTimeChangedM_upvr(arg1) -- Line 40, Named "OnTimeChangedM"
	local maximum_2 = math.max(0, arg1)
	return string.format("%02d:%02d", math.floor(maximum_2 / 60 / 60), math.floor(maximum_2 / 60) % 60)
end
function module.FormatTimeM(arg1) -- Line 48
	--[[ Upvalues[1]:
		[1]: OnTimeChangedM_upvr (readonly)
	]]
	return OnTimeChangedM_upvr(arg1)
end
function module.FormatTimeS(arg1) -- Line 53
	local maximum_4 = math.max(0, arg1)
	local var6 = math.floor(maximum_4) % 60
	local var7 = math.floor(maximum_4 / 60) % 60
	local var8 = math.floor(maximum_4 / 60 / 60) % 24
	local floored_2 = math.floor(maximum_4 / 60 / 60 / 24)
	local var10
	if 0 < tonumber(floored_2) then
		var10 = var10..string.format("%d"..'d', floored_2)
	end
	if 0 < tonumber(var8) then
		var10 = var10..string.format("%d"..'h', var8)
	end
	if 0 < tonumber(var7) then
		var10 = var10..string.format("%d"..'m', var7)
	end
	if tonumber(floored_2) <= 0 and 0 < tonumber(var6) then
		var10 = var10..string.format("%d"..'s', var6)
	end
	return var10
end
function module.UniqueTimeString(arg1) -- Line 83
	if arg1 < 60 then
		return arg1.." Sec"
	end
	if 60 <= arg1 and arg1 < 3600 then
		return math.ceil(arg1 / 60).." Min"
	end
	if 3600 <= arg1 and arg1 < 86400 then
		return math.ceil(arg1 / 3600).." Hour"
	end
	if 86400 <= arg1 then
		return math.ceil(arg1 / 86400).." Day"
	end
	return ""
end
function module.UniqueTimeString_Rank(arg1) -- Line 96
	local maximum = math.max(0, arg1)
	return ""..string.format("%d".."d ".."%d"..'h', math.floor(maximum / 60 / 60 / 24), math.floor(maximum / 60 / 60) % 24)
end
function module.FormatTimeMins(arg1) -- Line 110
	local maximum_5 = math.max(0, arg1)
	local var13 = math.floor(maximum_5 / 60) % 60
	local var14 = math.floor(maximum_5 / 60 / 60) % 24
	local floored = math.floor(maximum_5 / 60 / 60 / 24)
	local var16
	if 0 < tonumber(floored) then
		var16 = var16..string.format("%d".."d ", floored)
	end
	if 0 < tonumber(var14) then
		var16 = var16..string.format("%d".."hrs ", var14)
	end
	if 0 < tonumber(var13) then
		var16 = var16..string.format("%d".."mins", var13)
	end
	return var16
end
return module