local Config = require(script.Parent.FishingConfig)
local Settings = Config.BaitElastic
local BaitElasticMotion = {}

local function smooth(alpha)
	alpha = math.clamp(alpha, 0, 1)
	return alpha * alpha * (3 - 2 * alpha)
end

-- 纯时间采样；不积分、不抽随机数，也不读取上一帧变形后的尺寸。
function BaitElasticMotion.Rebound(alpha)
	if alpha <= 0 or alpha >= 1 then
		return 0
	end
	local previous = 0
	for index, finish in ipairs(Settings.LobeEnds) do
		if alpha < finish then
			local progress = (alpha - previous) / (finish - previous)
			return Settings.LobeAmplitudes[index] * math.sin(math.pi * progress) ^ 2
		end
		previous = finish
	end
	return 0
end

-- 从回弹顶点衔接两次余弹；首尾速度为零。
function BaitElasticMotion.Settle(alpha)
	alpha = math.clamp(alpha, 0, 1)
	return (1 - smooth(alpha)) * math.cos(math.pi * 2 * alpha)
end

function BaitElasticMotion.Scale(stretch)
	local y = math.clamp(stretch, Settings.MinStretch, Settings.MaxStretch)
	local side = 1 / math.sqrt(y)
	return Vector3.new(side, y, side)
end

function BaitElasticMotion.BaseSize(owner)
	return owner.baitBaseSize or owner.bait.Size
end

local function fade(elapsed, duration)
	return smooth(elapsed / Settings.BlendTime) * smooth((duration - elapsed) / Settings.BlendTime)
end

-- offset 为原始饵高的倍数；收竿位移由弹簧驱动，提鱼另用共享 Rebound 采样。
function BaitElasticMotion.Sample(phase, elapsed, duration, nibbleSpeed)
	elapsed = math.max(0, elapsed)
	local offset, stretch = 0, 1
	if phase == "Preparing" or phase == "Waiting" or phase == "Holding" or phase == "Approaching" then
		local wave = math.sin(elapsed * Settings.IdleFrequency) * fade(elapsed, duration or math.huge)
		offset, stretch = Settings.IdleHeight * wave, 1 + Settings.IdleStretch * wave
	elseif phase == "Casting" then
		local wave = 0
		for _, at in ipairs({ 0, Config.FrontShotTime, Config.OrbitShotTime }) do
			wave += BaitElasticMotion.Rebound((elapsed - Config.CastLeadTime - at) / Settings.HeldPulseTime)
		end
		local weight = fade(elapsed, Config.CastLeadTime + Config.ReleaseTime)
		offset, stretch = -Settings.HeldHeight * wave * weight, 1 + Settings.FlightStretch * wave * weight
	elseif phase == "Flying" then
		stretch = 1 + Settings.FlightStretch * math.sin(math.pi * math.clamp(elapsed / duration, 0, 1)) ^ 2
	elseif phase == "Settling" then
		local landing = Config.Landing
		local reboundEnd = landing.SinkTime + landing.ReboundTime
		if elapsed < landing.SinkTime then
			stretch = 1 + (Settings.MinStretch - 1) * smooth(elapsed / landing.SinkTime)
		elseif elapsed < reboundEnd then
			stretch = Settings.MinStretch
				+ (Settings.MaxStretch - Settings.MinStretch)
					* smooth((elapsed - landing.SinkTime) / landing.ReboundTime)
		else
			stretch = 1
				+ (Settings.MaxStretch - 1) * BaitElasticMotion.Settle((elapsed - reboundEnd) / landing.SettleTime)
		end
	elseif phase == "Nibbling" then
		elapsed *= nibbleSpeed or 1
		local nibble = Config.Bite.Nibble
		local retreatAt = nibble.AttackTime + nibble.ContactTime
		local release = smooth((elapsed - retreatAt) / nibble.ReboundTime)
		local pressure = smooth(elapsed / nibble.AttackTime) * (1 - release)
		local bounceAt = retreatAt + nibble.ReboundTime
		local wave = BaitElasticMotion.Rebound((elapsed - bounceAt) / (Config.Bite.NibbleTime - bounceAt))
		offset = Settings.NibbleBounceHeight * wave
		stretch = 1 + (Settings.MinStretch - 1) * pressure + (Settings.MaxStretch - 1) * wave
	elseif phase == "Bite" then
		local sinkTime = Config.Bite.BiteSinkTime
		local recovery = math.min(Settings.BiteRecoverTime, Config.Bite.HookWindow - sinkTime)
		local alpha = (elapsed - sinkTime) / recovery
		local pressure = smooth(elapsed / sinkTime) * (1 - smooth(alpha))
		local wave = BaitElasticMotion.Rebound(alpha)
		offset = -Settings.BiteOvershoot * pressure + Settings.BiteBounceHeight * wave
		stretch = 1 + (Settings.MinStretch - 1) * pressure + (Settings.MaxStretch - 1) * wave
	elseif phase == "Struggling" then
		local wave = BaitElasticMotion.Rebound((elapsed % Settings.StrugglePulseTime) / Settings.StrugglePulseTime)
		wave *= fade(elapsed, Config.Bite.StruggleTime)
		offset, stretch = Settings.StruggleHeight * wave, 1 + Settings.StruggleStretch * wave
	elseif phase == "Escaped" then
		local recover = smooth(elapsed / Settings.BlendTime)
		local wave =
			BaitElasticMotion.Rebound((elapsed - Settings.BlendTime) / (Config.Bite.EscapeTime - Settings.BlendTime))
		offset = -Config.Bite.BiteDepthFraction * (1 - recover) + Settings.NibbleBounceHeight * wave
		stretch = 1 + (Settings.MaxStretch - 1) * wave
	elseif phase == "Reeling" then
		local reel = Config.Reel
		local riseEnd = reel.SinkTime + Settings.ReelRiseTime
		if elapsed < reel.SinkTime then
			stretch = 1 + (Settings.MinStretch - 1) * smooth(elapsed / reel.SinkTime)
		elseif elapsed < riseEnd then
			stretch = Settings.MinStretch
				+ (1 - Settings.MinStretch) * smooth((elapsed - reel.SinkTime) / Settings.ReelRiseTime)
				+ Settings.FlightStretch * math.sin(math.pi * (elapsed - reel.SinkTime) / Settings.ReelRiseTime) ^ 2
		else
			stretch = 1
				+ (Settings.MaxStretch - 1)
					* BaitElasticMotion.Rebound((elapsed - riseEnd) / Settings.ReelBounceTime)
		end
	end
	return offset, BaitElasticMotion.Scale(stretch)
end

-- 所有正式呈现共用此入口；相同帧重复呈现也不会累乘尺寸。
function BaitElasticMotion.Apply(owner, frame, scale)
	owner.baitBaseSize = BaitElasticMotion.BaseSize(owner)
	owner.baitVisualScale = scale
	owner.bait.Size = owner.baitBaseSize * scale
	owner.bait.CFrame = frame
	if owner.trailA then
		owner.trailA.Position = Vector3.yAxis * owner.bait.Size.Y * 0.25
		owner.trailB.Position = -owner.trailA.Position
	end
end

return BaitElasticMotion
