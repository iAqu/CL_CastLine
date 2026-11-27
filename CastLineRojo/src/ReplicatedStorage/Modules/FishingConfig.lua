local Config = {
	EggCatchChance = 0.10,
	EggMotion = { RockDegrees = 12, BobHeight = 0.3, StruggleRadius = 0.8, SinkDistance = 8 },
	DefaultRodId = "Rod_101",
	FixedCastDistance = 30,
	DistanceLuckScale = 100,
	MutationMaxChance = 0.5,
	RodWeightLimitEnabled = false,
	BaseDistance = 55,
	MeterBonus = 20,
	BaitFlightScale = 1.5, -- 飞行中逐渐放大，落水后作为新的基础尺寸。
	BaseFlightTime = 1.6,
	FlightTimeExponent = 0.585,
	MaxFlightTime = 6,
	ApexHeightFactor = 0.25,
	ApexHeightMin = 12,
	ApexHeightMax = 60,
	CastLeadTime = 0.35,
	CastConfirmationTimeout = 8,
	FrontShotTime = 0.16,
	OrbitShotTime = 1.39,
	-- CastRod 在 0.85～1.8 秒后摆停顿；2.05 秒竿尖已前挥且仍高于角色。
	ReleaseTime = 2.05,
	AnimationLoadTimeout = 8,
	ReturnInputDelay = 0.5,
	Transition = {
		Entering = { Cover = 0.12, Reveal = 0.10 },
		Returning = { Cover = 0.30, Reveal = 0.35 },
	},
	Vignette = {
		FadeIn = 0.3,
		FadeOut = 0.3,
		Strength = 0.9, -- ThrowFood 的透明度系数为 0.6，最外圈不透明度为 54%。
	},
	Meter = {
		Segments = 6,
		BaseSpeed = 0.55,
		TopSpeedFactor = 2.6,
		Enter = 0.45,
		Hold = 0.9,
		Exit = 0.3,
		MarkerPunch = 1.35,
		PromptPunch = 1.6,
		GlowAttack = 0.12,
		GlowRecovery = 0.35,
		PopupDuration = 1.5,
		PopupFadeAt = 1.05,
		PopupRise = 0.08,
		PerfectFlash = 0.35,
		Ratings = {
			{
				Id = "GODLIKE",
				Min = 0.95,
				Exclusive = true,
				Text = "GODLIKE!",
				Color = { 255, 255, 255 },
				Rainbow = true,
				ProbabilityGrade = "PERFECT",
				Perfect = true,
			},
			{
				Id = "PERFECT",
				Min = 0.8,
				Text = "PERFECT",
				Color = { 120, 255, 120 },
				ProbabilityGrade = "PERFECT",
				Perfect = true,
			},
			{ Id = "GOOD", Min = 0.5, Text = "GOOD", Color = { 255, 220, 80 }, ProbabilityGrade = "GOOD" },
			{ Id = "BAD", Min = 0, Text = "BAD", Color = { 255, 90, 90 }, ProbabilityGrade = "BAD" },
		},
		-- Each row is low/middle/high probability followed by the successful-catch pity limit.
		ProbabilityCurves = {
			BAD = { { 0.8, 0.18, 0.02, 12 }, { 0.65, 0.3, 0.05, 8 }, { 0.5, 0.4, 0.1, 5 } },
			GOOD = { { 0.7, 0.25, 0.05, 12 }, { 0.45, 0.4, 0.15, 8 }, { 0.25, 0.45, 0.3, 5 } },
			PERFECT = { { 0.6, 0.3, 0.1, 12 }, { 0.3, 0.45, 0.25, 8 }, { 0.1, 0.4, 0.5, 5 } },
		},
	},
	Camera = {
		FollowFishEnabled = true, -- 设为 false 可切回鱼饵固定近景。
		FollowFishMaxDistance = 24,
		WaterViewSmoothSpeed = 5, -- 约 0.6 秒完成 95% 的水面镜头过渡。
		BaitView = { Distance = 12, Height = 8, Fov = 60 },
		Dive = { EntryPitch = 70, FlightPitchEnd = 0.9, SettleBlendTime = 0.3 },
		WaterFraming = {
			MaxTurn = 8,
			BaitCenterFraction = 0.3,
			BaitFrameFraction = 0.65,
			SizeWidenStart = 0.5,
			SizeWidenFull = 1.25,
			SizeFov = 8,
			DistanceStart = 2,
			DistanceFull = 14,
			DistanceFov = 8,
			AimHalfLife = 0.18,
			WidenHalfLife = 0.35,
			NarrowDelay = 0.3,
			NarrowHalfLife = 0.75,
		},
		Attack = 0.05,
		-- 在 1.8 秒挥竿爆发前完成环绕，留出能容纳 Impact 的身后全景。
		CastOrbit = { Duration = 0.3, Distance = 18, Height = 4.5, FocusHeight = -2 },
		Tap = { Shake = 0.3, Bonus = 0.4, Duration = 0.25, Frequency = 22 },
		Perfect = { Fov = 6, Recovery = 0.3 },
		Front = { Fov = -6, Recovery = 0.35, Shake = 0.5, Duration = 0.35, Frequency = 20 },
		Orbit = { Shake = 0.3, Duration = 0.3, Frequency = 22 },
		Release = { Fov = 10, Recovery = 0.5, Shake = 0.5, Duration = 0.25, Frequency = 24 },
		Landing = { Fov = -8, Recovery = 0.4, Shake = 1.8, Bonus = 1.2, Duration = 0.65, Frequency = 18 },
		Bite = { Shake = 1.2, Duration = 0.35, Frequency = 24 },
		Struggle = {
			Shake = 0.7,
			Frequency = 24,
			BaseDistance = 20,
			EntryBlendTime = 0.2,
			FollowDegrees = 3,
			FollowHalfLife = 0.12,
			MaxShakeOffset = 0.25,
			MaxShakeDegrees = 1.5,
			WallClearance = 0.75,
		},
		FishExit = { Fov = 7, Recovery = 0.5, Shake = 3.6, Duration = 0.65, Frequency = 22 },
		ShowcaseSwayFade = 0.4,
	},
	Landing = {
		FishingDepth = 300, -- 临时试玩深度（studs）；设为 0 恢复水面钓鱼。
		DiveTime = 1.2,
		SinkTime = 0.12,
		ReboundTime = 0.18,
		SettleTime = 0.2,
		SinkDepth = 0.65,
		ReboundHeight = 0.65,
		SplashLifetime = 2,
	},
	WaterRipple = {
		Enabled = false, -- 临时关闭程序化水波纹；设为 true 恢复。
		Lifetime = 0.55,
		StartDiameter = 4,
		EndDiameter = 12,
		ExpansionPower = 3,
		FadePower = 1.5,
		LandingInterval = 0.08,
	},
	WaterVFX = {
		Entry = "Cast_WaterEntry",
		EntryScale = 1.5,
		Exit = "Cast_WaterOut",
		Idle = "Bite_Idle",
		IdleEnabled = false,
		Light = "Bite_Light",
		Heavy = "Bite_Heavey",
		Struggle = "Bite_Struggle",
		Lifetime = 2,
		StruggleInterval = 0.1,
		StrugglePositionScale = 0.6,
		StruggleScale = 0.75,
		StruggleStudsPerScale = 16,
		StruggleDiameterScaleCap = 4.5,
	},
	CharacterVFX = {
		Land = "FishingCast_Land",
		Wind = "FishingCast_Wind",
		Impact = "FishingCast_Impact",
		-- 前挥开始（1.8 秒）到鱼饵脱竿（2.05 秒）的中点，Impact 音画同步触发。
		SwingTime = 1.925,
		CleanupPadding = 0.1,
	},
	RarityVFX = {
		ReferenceDiameter = 12,
		ExitCountScale = 0.35,
		ExitSizeScale = 0.8,
		CleanupPadding = 0.1,
	},
	ShowcaseVFX = {
		OutlineDuration = 1.2,
		BurstMinRarity = "Legendary",
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Count = 70,
		LifetimeMin = 0.6,
		LifetimeMax = 1.3,
		SpeedMin = 8,
		SpeedMax = 18,
		SpreadAngle = 180,
		LightEmission = 1,
		Transparency = 0.1,
		SizeRatio = 0.12,
		SizeMin = 0.8,
		SizeMax = 4,
		SizePeakTime = 0.2,
		CleanupTime = 2.5,
	},
	BaitAppear = {
		StartScale = 0.3,
		PeakScale = 1.12,
		PeakTime = 0.18,
		Duration = 0.32,
		FillTransparency = 0.65,
		EffectLifetime = 1.3,
	},
	BaitElastic = {
		MinStretch = 0.65,
		MaxStretch = 1.4,
		-- 一次主回弹及两次余弹；每瓣在接缝处速度为零。
		LobeEnds = { 0.5, 0.8, 1 },
		LobeAmplitudes = { 1, -0.4, 0.16 },
		BlendTime = 0.15,
		HeldPulseTime = 0.5,
		HeldHeight = 0.25,
		IdleHeight = 0.06,
		IdleFrequency = 2.5,
		IdleStretch = 0.04,
		FlightStretch = 0.4,
		NibbleBounceHeight = 0.15,
		BiteOvershoot = 0.2,
		BiteBounceHeight = 0.2,
		BiteRecoverTime = 0.35,
		StrugglePulseTime = 0.6,
		StruggleHeight = 0.3,
		StruggleStretch = 0.3,
		-- 仅控制收竿时的拉伸恢复，不决定整体位移或返回时机。
		ReelRiseTime = 0.3,
		ReelBounceTime = 0.4,
	},
	Reel = {
		SinkTime = 0.2,
		SinkDepth = 0.6,
		Spring = {
			SinkDamping = 1,
			SinkFrequency = 6,
			LiftDamping = 0.45,
			LiftFrequency = 2,
			PositionTolerance = 0.02,
			VelocityTolerance = 0.1,
			SettleTime = 0.1,
		},
		ReboundPadding = 1.5,
		CameraTime = 0.2,
		CameraMinDistance = 6,
		SwayScale = 0.5,
		SwayFadeTime = 0.2,
		HoldTime = 0.5,
	},
	DeepCatch = {
		EntranceTime = 2.4,
		ApproachDistance = 12,
		SwayDistance = 0.75,
		SwayCycles = 4,
		RollDegrees = 5,
		InitialProgress = 0.5,
		TapGain = 0.125,
		MinTapInterval = 0.075,
		DecayDelay = 0.45,
		DecayPerSecond = 0.5,
	},
	Bite = {
		MutationTrail = {
			WidthRatio = 0.30, MinWidth = 0.6, EdgeDivisor = 28,
			Lifetime = 0.70, LengthRatio = 2, MinLength = 10,
		},
		Prompt = { PopTime = 0.08, StartScale = 0.7, HeightOffset = 2 },
		-- 独立演出测试可用 FishName 指定鱼种；正式钓鱼使用服务器抽取结果。
		-- 相对鱼身尺寸的嘴部连接位置。
		MouthOffset = { 0, -0.1, -0.485 },
		AppearDelayMin = 1,
		AppearDelayMax = 3,
		ApproachTime = 1.2,
		ApproachTimeMin = 0.75, -- 保留完整显形和末段减速，不随高游速继续缩短。
		ApproachDistance = 14,
		SpawnAngleJitter = 20,
		AppearTime = 0.65,
		AppearRise = 4,
		MaxNibbles = 6,
		PauseMin = 0.8,
		PauseMax = 1.4,
		NibbleTime = 0.55,
		NibbleGap = 1.5,
		Nibble = {
			AttackTime = 0.12,
			AttackTimeMin = 0.12,
			AttackTimeMax = 0.20,
			RippleTriggerRatio = 0.7,
			ContactTime = 0.06,
			ReboundTime = 0.08,
			DepthMin = 0.06,
			DepthMax = 0.09,
			GapMin = 0.9,
			GapMax = 1.1,
			SpeedMin = 0.8,
			SpeedMax = 1.3,
			ReturnSpeedMin = 0.8,
			ReturnSpeedMax = 1.2,
			ReturnRadiusScale = 0.5,
			ReturnRadiusMax = 6, -- 鱼的路径输入半径上限（studs），平滑规划仍可扩大半径。
			ReturnSpeedScale = 0.65,
			ReturnSpeedMaxStuds = 10,
			ReturnTurnRateMax = 140, -- 度/秒；弯道减速，直线恢复。
			ReturnRampTime = 0.15,
			ReturnTurnBlendTime = 0.3,
			SettleTime = 0.2,
			TurnMin = 15,
			TurnMax = 45,
			TurnLimit = 60,
			Pitch = 2,
			ArcLimit = 0.2,
		},
		HookWindow = 0.6,
		BiteSinkTime = 0.15,
		BiteDepthFraction = 0.65,
		BiteTilt = 35,
		BaitFillColor = { 255, 55, 55 },
		BaitFillTransparency = 0.2,
		WaterClearance = 0.3,
		Drip = {
			Template = "Fish_Drip",
			Points = {
				"Belly01",
				"Belly02",
				"Belly03",
				"Belly04",
				"Belly05",
				"Belly06",
				"Belly07",
				"Belly08",
				"Belly09",
				"Belly10",
				"Belly11",
				"Belly12",
				"Belly13",
				"Belly14",
				"Belly15",
				"Belly16",
				"Tail01",
				"Tail02",
				"Tail03",
				"Tail04",
				"Tail05",
				"Tail06",
				"Tail07",
				"Tail08",
			},
			DecayTime = 4,
			StartRate = 20, -- 全部表面点合计，不随点数增加。
			IdleRate = 5,
			MaxCatchup = 4,
			Speed = { 0.2, 0.6 },
			Spread = 15,
			Burst = {
				Count = 10,
				Window = { 0.1, 0.25 },
				Speed = { 10, 16 },
				Drag = 2,
				Acceleration = { 0, -60, 0 },
				Lifetime = { 0.45, 0.65 },
				Spread = 70,
			},
		},
		Motion = {
			Secondary = {
				FadeTime = 0.15,
				Bank = { MaxAngle = 4, FullTurnRate = 180, SampleInterval = 1 / 120 },
				Showcase = {
					IdleAngles = { 1, 0.8, 1.5 },
					Frequency = { 0.45, 0.35, 0.4 },
					BurstAngles = { 3, 4, 6 },
				},
			},
			Animation = {
				Bones = { "FishBody", "SpineFront", "SpineMid", "TailBase", "FishTail" },
				FadeTime = 0.15,
				HoldWeight = 0.4,
				ShowcaseIdleSpeed = 0.35,
				ShowcaseIdleWeight = 0.25,
				GapMin = 3,
				GapMax = 5,
				HeldGapMin = 2,
				HeldGapMax = 3,
				LoadTimeout = 8,
				SyncTolerance = 0.06,
				Clips = {
					SwimLoop = { Duration = 0.625, Looped = true },
					StruggleLeft = { Duration = 0.6, Looped = true },
					StruggleRight = { Duration = 0.6, Looped = true },
					LiftFlop = { Duration = 2, Looped = false },
					ShowcaseFlop = { Duration = 0.9, Looped = false },
				},
			},
		},
		StruggleTime = 3,
		Struggle = {
			BlendTime = 0.2,
			HighlightFadeTime = 0.5,
			Speed = 2,
			FeedbackFrequencyMin = 0.7,
			FeedbackFrequencyMax = 1.1,
			Radius = 5,
			MinRadius = 2,
			MaxRadius = 8,
			AnimationCycle = 0.45,
		},
		RippleInterval = 0.22,
		FishLift = {
			MinShowcaseHeight = 5.4,
			RiseTime = 0.40,
			PeakHold = 0.08,
			FallTime = 0.80,
			SettleTime = 0.27,
			ScaleTime = 0.35,
			BaseRise = 32,
			SizeRise = 1.5,
			EventWindow = 0.10,
			CameraHold = 0.12,
			CameraBlend = 0.18,
			CameraLag = 0.12,
			CameraRiseFollow = 0.35,
			CameraPullbackStartSize = 6,
			CameraPullbackPerStud = 0.3,
			CameraMaxPullback = 8,
			Exit = { Fov = 10, Recovery = 0.25, Shake = 3.6, Duration = 0.22, Frequency = 22 },
			Land = { Shake = 0.6, Duration = 0.12, Frequency = 22 },
		},
		ObserverFishLift = {
			RiseTime = 0.60,
			TurnEnd = 0.95,
			Duration = 1.55,
			StartSpeedScale = 0.8,
			MinHeightGain = 12,
			DistanceRise = 1.15,
			SizeRise = 1.5,
		},
		-- 鱼蛋保留原演出参数。
		LiftTime = 2,
		LiftRiseEnd = 0.35,
		LiftFallEnd = 0.72,
		LiftPeakHeight = 22,
		LiftSpinTurns = 1,
		LiftScalePeak = 1.45,
		LiftScaleTime = 0.55,
		LiftBounceHeight = 1.8,
		LiftBounceScale = 0.1,
		ShowcaseHeight = 5,
		ShowcaseHold = 0.5,
		ShowcaseLineHeight = 30,
		-- 展示连接点在嘴部世界坐标竖直下方的固定距离，不随鱼身缩放。
		ShowcaseLineMouthDrop = 1,
		ShowcaseFov = 60,
		ShowcaseScreenFraction = 0.55,
		ShowcasePadding = 0.5,
		ShowcaseMinDistance = 10,
		ShowcaseCloseupDistance = 24,
		ShowcaseCloseupHold = 0,
		ShowcasePullbackTime = 0.9,
		EscapeTime = 0.7,
		ShadowTransparency = 0.55,
		ShadowOutlineTransparency = 0.2,
		Text = {
			Waiting = "WAIT FOR A BITE...",
			Hook = "TAP TO HOOK!",
			Escaped = "THE FISH GOT AWAY!",
			Caught = "CAUGHT!",
			Return = "tap to continue",
		},
	},
	Sounds = {
		LuckTick = { Id = "rbxassetid://137872392480008", Volume = 0.3 },
		CatchRevealImpact = { Id = "rbxassetid://139520673393967", Volume = 0.32, Pitch = 1.06 },
		CatchRevealBurst = { Id = "rbxassetid://9118614058", Volume = 0.2, Pitch = 0.9 },
		LuckWhole = { Id = "rbxassetid://113397864512278", Volume = 0.85 },
		MeterTick = { Id = "rbxassetid://137872392480008", Volume = 0.25 },
		ButtonClick = { Id = "rbxassetid://113397864512278", Volume = 0.8 },
		Perfect = { Id = "rbxassetid://112485797063762", Volume = 0.5, Pitch = 1.3 },
		CameraWhoosh = { Id = "rbxassetid://9126233950", Volume = 0.4 },
		SpinWhoosh = { Id = "rbxassetid://134012322", Volume = 0.5 },
		WindLoop = { Id = "rbxassetid://3308152153", Volume = 0, Looped = true },
		Splash = { Id = "rbxasset://sounds/impact_water.mp3", Volume = 0.8 },
		FovImpact = { Id = "rbxassetid://9120705982", Volume = 0.5 },
	},
}

-- Animation-relative clocks shared by presentation and the server's earliest landing gate.
Config.CastProfiles = {
	Normal = {
		Id = "Normal",
		Animation = "CastRod",
		LeadTime = Config.CastLeadTime,
		Duration = 2.1666667,
		ReleaseTime = Config.ReleaseTime,
		ImpactTime = Config.CharacterVFX.SwingTime,
		FrontTime = Config.FrontShotTime,
		OrbitTime = Config.OrbitShotTime,
		ReleaseImpulse = Config.Camera.Release,
	},
	Godlike = {
		Id = "Godlike",
		Animation = "SpecialCastRod",
		LeadTime = Config.CastLeadTime,
		Duration = 2.5166667,
		ReleaseTime = 2.49,
		ImpactTime = 2.43,
		TrailTime = 0.20,
		LandingTime = 1.03,
		ChargeTime = 1.03,
		OrbitTime = 1.70,
		Trails = {
			Rod = { Width = 1.4, Lifetime = 0.85, MaxLength = 18, EdgeWidth = 0.05 },
			Flight = { Width = 1.2, Lifetime = 0.70, MaxLength = 20, EdgeWidth = 0.04 },
		},
		VFX = {
			LandCount = 1.3,
			WindScale = 1.25,
			WindRate = 1.5,
			ImpactScale = 1.5,
			ImpactCount = 1.6,
			ReducedBudget = 0.6,
		},
		Camera = {
			MaxDistance = 22,
			SafeFraction = 0.72,
			MaxFitFov = 85,
			-- time, FOV, yaw (root-relative), distance, height
			Nodes = {
				{ 0, 54, 145, 9, -0.4 },
				{ 0.20, 54, 145, 9, -0.4 },
				{ 0.45, 66, 145, 11, 1.5 },
				{ 1.03, 66, 145, 11, 1.5 },
				{ 1.30, 60, 145, 10, 1 },
				{ 1.70, 60, 145, 10, 1 },
				{ 2.30, 70, 45, 12, 2 },
				{ 2.49, 70, 45, 12, 2 },
			},
		},
		LandingImpulse = { Shake = 0.25, Duration = 0.12, Frequency = 20 },
		ImpactImpulse = { Shake = 1.25, Duration = 0.20, Frequency = 24 },
		ReleaseImpulse = { Fov = 12, Recovery = 0.5, Duration = 0.20, Frequency = 24 },
	},
}

Config.CastRainbow = {
	{ 255, 60, 60 },
	{ 255, 145, 35 },
	{ 255, 235, 60 },
	{ 70, 240, 95 },
	{ 65, 225, 255 },
	{ 90, 130, 255 },
	{ 195, 80, 255 },
}

function Config.GetLandingSettleTime(): number
	local landing = Config.Landing
	local diveTime = if landing.FishingDepth > 0 then landing.DiveTime else 0
	return math.max(Config.ReturnInputDelay, landing.SinkTime + landing.ReboundTime + landing.SettleTime, diveTime)
end

function Config.GetCastProfile(castRating: string?)
	return if castRating == "GODLIKE" then Config.CastProfiles.Godlike else Config.CastProfiles.Normal
end

-- Integrate the speed curve once so the meter is independent of client frame rate.
local meterAcceleration = Config.Meter.BaseSpeed * (Config.Meter.TopSpeedFactor - 1)
local meterHalfPeriod = math.log(Config.Meter.TopSpeedFactor) / meterAcceleration

function Config.GetCastMeterProgress(elapsed: number): number
	local time = math.max(elapsed, 0) % (2 * meterHalfPeriod)
	time = math.min(time, 2 * meterHalfPeriod - time)
	return math.clamp((math.exp(meterAcceleration * time) - 1) / (Config.Meter.TopSpeedFactor - 1), 0, 1)
end

function Config.GetFishingInputDelay(player: Player): number
	return math.clamp(player:GetNetworkPing() / 2, 0, 0.2)
end

function Config.GetDeepCatchEntrance(catchKind: string, tutorial: boolean): string?
	if Config.Landing.FishingDepth <= 0 or catchKind ~= "Fish" or tutorial then
		return nil
	end
	return "Rise"
end

function Config.GetCatchProgress(value: number, lastTapAt: number, now: number): number
	local settings = Config.DeepCatch
	return math.max(0, value - math.max(0, now - lastTapAt - settings.DecayDelay) * settings.DecayPerSecond)
end

function Config.GetHookTime(receivedAt: number, pressedAt: unknown, biteAt: number, biteEndsAt: number, rtt: number): number?
	if type(pressedAt) ~= "number" or not (pressedAt >= biteAt and pressedAt < biteEndsAt) then
		return nil
	end
	-- Reliable gameplay traffic can arrive later than the network-ping estimate.
	local deliveryBudget = math.clamp(1.5 * rtt + 0.15, 0.25, 1.25)
	if pressedAt > receivedAt + 0.05 or receivedAt > pressedAt + deliveryBudget then
		return nil
	end
	return pressedAt
end

-- Pure shared classification. Internal compatibility callers omit progress to use the top curve.
function Config.GetCastRating(progress: number?)
	local value = if progress == nil then 1 else progress
	for _, rating in ipairs(Config.Meter.Ratings) do
		if (rating.Exclusive and value > rating.Min) or (not rating.Exclusive and value >= rating.Min) then
			return rating
		end
	end
	return Config.Meter.Ratings[#Config.Meter.Ratings]
end

return Config
