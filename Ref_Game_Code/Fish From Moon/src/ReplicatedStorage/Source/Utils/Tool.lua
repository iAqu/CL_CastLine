local Tool = {}

function Tool.getTableLegth(t)   ---获得数组的长度
	local total =  0
	for key, value in pairs(t) do
		total  =  total +1
	end
	return total
end

function Tool.topAtk(test2)
	table.sort(test2, function(a, b)
		return a.atk > b.atk
	end)
	return test2
end

function  Tool.HHMMSS(time)           ----转换时间单位
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time/60)
	local hours= math.floor(minutes/60) 
	--	return string.format("%02d:%02d",minutes,seconds)
	local shi = hours
	local fen = (minutes-hours*60)
	local miao = (seconds-minutes*60)

	--	return string.format("%02d:%02d",minutes,seconds)
	return string.format("%02d:%02d:%02d",shi,fen,miao)
end

--如果大于 60分钟 格式HHMM 小于50分钟MMSS
function Tool.HHORMM(time)           ----转换时间单位
	local seconds = math.modf(time, 60)
	local minutes = math.floor(time/60)
	local hours= math.floor(minutes/60) 
	--	return string.format("%02d:%02d",minutes,seconds)
	local shi = hours
	local fen = (minutes-hours*60)

	if shi > 0 then
		return string.format("%02dh",shi)
	else
		return string.format("%02dm",fen)
	end
	--	return string.format("%02d:%02d",minutes,seconds)
end

--如果大于 60分钟 格式HHMM 小于50分钟MMSS
function Tool.HHMM(time)           ----转换时间单位
	if time > 24 * 3600 then -- 时间超过1天 格式 XXdayXXhour
		local day = math.floor(time / 60 / 60 / 24)
		local hour = math.floor(time / 3600) % 24
		return string.format("%02dd %02dh",day,hour)
	else --时间没有超过1天 -- 格式 XXhourXXmin
		local seconds = math.modf(time, 60)
		local minutes = math.floor(time/60)
		local hours= math.floor(minutes/60) 
		--	return string.format("%02d:%02d",minutes,seconds)
		local shi = hours
		local fen = (minutes-hours*60)
		local miao = (seconds-minutes*60)

		if shi > 0 then
			return string.format("%02dh %02dm",shi,fen)
		else
			return string.format("%02dm %02ds",fen,miao)
		end
	end 
	--	return string.format("%02d:%02d",minutes,seconds)
end

--加载服务
local BadgeService = game:GetService("BadgeService")

function Tool.AwardPlayerBadge(player,badgeId)
	task.spawn(function()
		-- 授予徽章
		local awarded, errorMessage = pcall(function()
			BadgeService:AwardBadge(player.UserId, badgeId)
		end)
		if not awarded then
			warn("授予徽章时出错：", errorMessage)
		end

	end)
end

function Tool.AwardBadge(player, badgeId)
	-- Fetch badge information
	local success, hasBadge = pcall(function()
		-- 检查玩家是否有该徽章
		return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
	end)
	if not hasBadge then
		Tool.AwardPlayerBadge(player,badgeId)
	end
end

return Tool
