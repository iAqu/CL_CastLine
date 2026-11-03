-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:29
-- Luau version 6, Types version 3
-- Time taken: 0.002949 seconds

local SoundService = game:GetService("SoundService")
local UI = SoundService:FindFirstChild("UI")
local SFX = SoundService:FindFirstChild("SFX")
return {
	AwardNotification = {
		SoundId = "rbxassetid://9416427368";
		SoundGroup = UI;
		Volume = 1;
	};
	ChestPopInfo = {
		SoundId = "rbxassetid://9416427368";
		SoundGroup = UI;
		PlaybackSpeed = 0.8;
		Volume = 1;
	};
	PowerAreaBoost = {
		SoundId = "rbxassetid://9431658609";
		SoundGroup = UI;
		Volume = 1;
	};
	HeavenlyLoop = {
		SoundId = "rbxassetid://9437811346";
		SoundGroup = UI;
		Looped = true;
		Volume = 1;
	};
	BallHit = {
		SoundId = "rbxassetid://112503990";
		SoundGroup = SFX;
		PlaybackSpeed = {0.9, 0.1};
		Volume = 1;
	};
	CrowdSwell = {
		SoundId = "rbxassetid://9416494525";
		SoundGroup = UI;
		Volume = 1;
	};
	TimeClickStart = {
		SoundId = "rbxassetid://9416464741";
		SoundGroup = SFX;
		Volume = 1;
		PlaybackSpeed = 1.25;
	};
	TimeClickPerfect = {
		SoundId = "rbxassetid://9418608406";
		SoundGroup = SFX;
	};
	TimeClickNormal = {
		SoundId = "rbxassetid://9418608320";
		SoundGroup = SFX;
	};
	TimeClickBad = {
		SoundId = "rbxassetid://9418608466";
		SoundGroup = SFX;
	};
	BallKick = {
		SoundId = "rbxassetid://1903464934";
		PlaybackSpeed = {0.9, 1.2};
		SoundGroup = SFX;
	};
	ScoreGoal = {
		SoundId = "rbxassetid://9415438684";
		PlaybackSpeed = {0.9, 1.2};
		Volume = 2;
		SoundGroup = SFX;
	};
	BlockDebris = {
		SoundId = {"rbxassetid://9332116477", "rbxassetid://rbxassetid://9332116898"};
		PlaybackSpeed = {1, 1.2};
		SoundGroup = SFX;
	};
	BlockDestroyed = {
		SoundId = {"rbxassetid://9310115333", "rbxassetid://9310115549", "rbxassetid://9310115748", "rbxassetid://9310115895"};
		SoundGroup = SFX;
		Volume = 2;
	};
	BlockHit = {
		SoundId = "rbxassetid://9372905321";
		SoundGroup = SFX;
		Looped = true;
		Volume = 10;
	};
	Collect = {
		SoundId = "rbxassetid://9215418570";
		SoundGroup = SFX;
		Volume = 1;
	};
	Swish = {
		SoundId = {"rbxassetid://9369817791", "rbxassetid://9369817617", "rbxassetid://9369817434", "rbxassetid://9369817308", "rbxassetid://9369817188", "rbxassetid://9369817061", "rbxassetid://9369818001"};
		SoundGroup = SFX;
		PlaybackSpeed = {0.8, 1.2};
		Volume = 1;
	};
	Pop = {
		SoundId = {"rbxassetid://9369801112", "rbxassetid://9369803307"};
		PlaybackSpeed = {1, 1.1};
		SoundGroup = SFX;
	};
	Click = {
		SoundId = "rbxassetid://9215418570";
		PlaybackSpeed = {1, 1.2};
		SoundGroup = SFX;
		Volume = 1;
	};
	TimeSkip = {
		SoundId = "rbxassetid://8355865845";
		PlaybackSpeed = {0.9, 1};
		SoundGroup = UI;
		Volume = 1;
	};
	Congratulation = {
		SoundId = "rbxassetid://5908637114";
		SoundGroup = UI;
		Volume = 1;
	};
	BoostActivated = {
		SoundId = "rbxassetid://7845507620";
		PlaybackSpeed = {0.9, 1};
		SoundGroup = UI;
		Volume = 1;
	};
	ChestFill = {
		SoundId = "rbxassetid://4612385951";
		SoundGroup = UI;
		Volume = 0.4;
	};
	ChestShowCard = {
		SoundId = "rbxassetid://4612386368";
		SoundGroup = UI;
		Volume = 0.25;
	};
	ChestSkipSpam = {
		SoundId = "rbxassetid://7845495731";
		SoundGroup = UI;
		Volume = 0.65;
	};
	ChestDropped = {
		SoundId = "rbxassetid://4593780627";
		SoundGroup = UI;
		Volume = 0.4;
	};
	ChestIdle = {
		SoundId = "rbxassetid://4612378969";
		SoundGroup = SFX;
		Volume = 2;
		RollOffMaxDistance = 120;
		RollOffMinDistance = 10;
		Looped = true;
	};
	Crash = {
		SoundId = "rbxassetid://8541022206";
		SoundGroup = SFX;
		Volume = 1;
		PlaybackSpeed = {0.9, 1.1};
		RollOffMaxDistance = 75;
		RollOffMinDistance = 10;
	};
	LegendaryCustomer = {
		SoundId = "rbxassetid://8524344013";
		SoundGroup = SFX;
		Volume = 2;
	};
	Error = {
		SoundId = "rbxassetid://4612384231";
		SoundGroup = SFX;
	};
	CartWheels = {
		SoundId = "rbxassetid://8053947378";
		SoundGroup = SFX;
		Volume = 0.5;
		Looped = true;
	};
	CollectMoney = {
		SoundId = {"rbxassetid://4612375802"};
		SoundGroup = SFX;
		PlaybackSpeed = {0.95, 1.05};
		Volume = 0.25;
	};
	BuySuccess = {
		SoundId = "rbxassetid://4612383453";
		SoundGroup = SFX;
	};
	BuyFailed = {
		SoundId = "rbxassetid://4612384231";
		SoundGroup = SFX;
	};
	MoneyChange = {
		SoundId = "rbxassetid://930700226";
		SoundGroup = UI;
		PlaybackSpeed = {0.95, 1.05};
	};
	PurchaseSuccessful = {
		SoundId = "rbxassetid://7845508173";
		SoundGroup = UI;
	};
	btndown = {
		SoundId = "rbxassetid://7845496431";
		SoundGroup = UI;
	};
	btnup = {
		SoundId = "rbxassetid://7845496314";
		SoundGroup = UI;
	};
	windowswitch = {
		SoundId = "rbxassetid://7845506901";
		PlaybackSpeed = 1.25;
		SoundGroup = UI;
	};
	windowopen = {
		SoundId = "rbxassetid://7845511047";
		SoundGroup = UI;
		Volume = 1;
	};
	windowclose = {
		SoundId = "rbxassetid://7845512669";
		SoundGroup = UI;
		Volume = 1;
	};
}