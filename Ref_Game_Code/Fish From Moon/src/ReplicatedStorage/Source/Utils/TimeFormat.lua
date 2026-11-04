local TimeFormat = {}

----转换时间单位 MM
function TimeFormat.MM(time)
	local minutes = math.floor(time / 60)

	local fen = minutes
	--return string.format("%02d:%02d",minutes,seconds)
	return string.format("%02d", fen)
end
----转换时间单位 MMSS
function TimeFormat.MMSS(time)
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time / 60)

	local fen = minutes
	local miao = (seconds - minutes * 60)
	--return string.format("%02d:%02d",minutes,seconds)
	return string.format("%02d:%02d", fen, miao)
end
----转换时间单位 MMSS
function TimeFormat.MMSSLine(time)
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time / 60)

	local fen = minutes
	local Lfen=math.floor(fen/10)
	local Rfen=math.floor(fen%10)
	local miao = (seconds - minutes * 60)
	local Lmiao=math.floor(miao/10)
	local Rmiao=math.floor(miao%10)
	--return string.format("%02d:%02d",minutes,seconds)
	return Lfen..'-'..Rfen..'-'..Lmiao.."-"..Rmiao
end

----转换时间单位 HHMMSS
function TimeFormat.HHMMSS(time)
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time / 60)
	local hours = math.floor(minutes / 60)

	local shi = hours
	local fen = (minutes - hours * 60)
	local miao = (seconds - minutes * 60)
	--	return string.format("%02d:%02d",minutes,seconds)
	return string.format("%02d:%02d:%02d", shi, fen, miao)
end
--游戏时长 格式
function TimeFormat.HHMM(time)
	--时间没有超过1天 -- 格式 XXhour XXmin
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time / 60)
	local hours = math.floor(minutes / 60)

	local shi = hours
	local fen = (minutes - hours * 60)
	local miao = (seconds - minutes * 60)
	if shi>0 then
		return string.format("%02dh %02dm", shi, fen)
	else
		return string.format("%02dm", fen)
	end
end
--游戏时长 格式
function TimeFormat.Playtime(time)
	-- 时间超过1天 格式 XXday XXhour
	if time > 24 * 3600 then
		local day = math.floor(time / 60 / 60 / 24)
		local hour = math.floor(time / 3600) % 24
		return string.format("%02dd %02dh", day, hour)
	else
		--时间没有超过1天 -- 格式 XXhour XXmin
		local seconds = math.modf(time, 60)
		local minutes = math.floor(time / 60)
		local hours = math.floor(minutes / 60)

		local shi = hours
		local fen = (minutes - hours * 60)
		local miao = (seconds - minutes * 60)
		if shi > 0 then
			return string.format("%02dh %02dm", shi, fen)
		else
			return string.format("%02dm %02ds", fen, miao)
		end
	end
end
--游戏时长 格式
function TimeFormat.FreeGiftTime(time)
	-- 时间超过1天 格式 XXday XXhour
	if time > 24 * 3600 then
		local day = math.floor(time / 60 / 60 / 24)
		local hour = math.floor(time / 3600) % 24
		return string.format("%02d : %02d", day, hour)
	else
		--时间没有超过1天 -- 格式 XXhour XXmin
		local seconds = math.modf(time, 60)
		local minutes = math.floor(time / 60)
		local hours = math.floor(minutes / 60)

		local shi = hours
		local fen = (minutes - hours * 60)
		local miao = (seconds - minutes * 60)
		if shi > 0 then
			return string.format("%02d : %02d", shi, fen)
		else
			return string.format("%02d : %02d", fen, miao)
		end
	end
end

return TimeFormat
