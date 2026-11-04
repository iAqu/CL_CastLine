-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:18
-- Luau version 6, Types version 3
-- Time taken: 0.001763 seconds

local module = {
	SeasonTask = {
		RunTrain = 1;
		SwimTrain = 2;
		BikeTrain = 3;
		HeroHatch = 4;
		OnlineTime = 5;
		Compete = 6;
	};
	AniState = {
		Safe = -1;
		Swim = 0;
		Ride = 1;
		Run = 2;
	};
	ToolTp = {
		Swim = 0;
		Ride = 1;
		Run = 2;
	};
	GameState = {
		Prepear = 1;
		Ready = 3;
		Run = 4;
	};
	PetMagicAddType = {
		PetPowerAdd = 1;
		TotalPowerGainUp = 2;
		StaminaGainUp = 3;
		ComptitionRewardUp = 4;
		PetSizeDown = 5;
		PlayerSpeedUp = 6;
		StaminaRecoverUp = 7;
		MagicTokenDropRate = 8;
	};
	CoachBuffType = {
		SwimGainUp = 1;
		RideGainUp = 2;
		RunGainUp = 3;
		ComptitionRewardUp = 4;
		AllGainUp = 5;
	};
	CoachUnlockType = {
		Blank = 1;
		Event = 2;
		LimitedPurchase = 3;
		ShopPurchase = 4;
		DailyAward = 5;
		Spin = 6;
	};
	CoachUnlockCoinType = {
		Money = 1;
		Robux = 2;
	};
	ComptitionAction = {
		FrontDoubleBiceps = 1;
		SideChest = 2;
		BackDoubleBiceps = 3;
		AbdominalsAndThiqhs = 4;
		WarLeg = 5;
	};
	ComptitionStage = {
		ShowPlay = 1;
		CountToStart = 2;
		BeforeAction = 3;
		Action = 4;
		Action_Keep = 5;
		Action_Mark = 6;
		Action_Stay = 7;
	};
	TipTp = {
		Normal = 0;
		Error = 1;
		Warn = 2;
	};
	EquipmentType = {
		None = 0;
		Fixed = 1;
		Free = 2;
		Run = 3;
	};
	HeroState = {
		NONE = 0;
		Running = 1;
		Idle = 2;
		Walk = 3;
		Atk = 4;
	};
	CoachState = {
		Idle = 1;
		Running = 2;
		Walk = 3;
		Encourage = 4;
	};
	PetState = {
		Idle = 1;
		Running = 2;
		Walk = 3;
	};
	HeroPoolType = {
		Common = 1;
		Advanced = 2;
	};
	RareName = {"普通", "稀有", "史诗", "传说", "神秘", "神话", "秘密"};
	Rare = {
		Normal = 1;
		Rare = 2;
		Epic = 3;
		Legendary = 4;
		Mysterious = 5;
		Immortal = 6;
		Secret = 7;
	};
	ItemID = {
		Money = 1;
		DinosaurToken = 2;
		HatchToolToken = 3;
		DinosaurHatch = 4;
		DailyToken = 5;
		MagicToken = 6;
		Attr_0 = 10;
		Attr_1 = 11;
		Attr_2 = 12;
		Attr_3 = 13;
	};
	ActionToMuscle = {
		[module.ComptitionAction.SideChest] = module.ItemID.Attr_1;
		[module.ComptitionAction.BackDoubleBiceps] = module.ItemID.Attr_3;
		[module.ComptitionAction.AbdominalsAndThiqhs] = module.ItemID.Attr_2;
	};
	ItemType = {
		UseItem = 0;
		Item = 1;
		Equipment = 2;
		GamePass = 3;
		Box = 4;
		Hero = 5;
		Enemy = 6;
		Egg = 7;
		Coach = 8;
		Aura = 9;
		Magic = 10;
		Tool = 11;
		FriendCoach = 12;
		FriendCoachBuff = 13;
	};
	ModelType = {
		Hero = 5;
		Coach = 8;
	};
	TradeState = {
		EveryOne = 1;
		UnTrade = 2;
		OnlyFriend = 3;
	};
	TradeProcess = {
		None = 0;
		ReviceTrade = 1;
		Prepare = 2;
		Ready = 3;
		Trading = 4;
	};
	TradeTipsType = {
		TradeSuc = 1;
		TradeCancle = 2;
		TradeIng = 3;
		TradeOnlyFriend = 4;
		TradeNo = 5;
		TradeFail = 6;
	};
	RobuxType = {
		RobuxItem = 1;
		GamePass = 2;
	};
	SerMsgType = {
		TextOnly = 1;
		HatchHero = 3;
		Lottery = 4;
	};
	SerMsgSendType = {
		CurServer = 1;
		AllServer = 2;
	};
	TimeType = {
		CompAll = 0;
		Day = 1;
		Week = 2;
		World = 3;
	};
	Task = {
		CompleteDayTask = 1;
		CompleteWeekTask = 2;
		OnlineTime = 3;
		ClickTrain = 4;
		JumpCount = 5;
		SprintCount = 6;
		Kills = 7;
		LoginCount = 8;
		RebirthCount = 9;
		HatchHero = 10;
		HatchSkill = 11;
	};
}
return module