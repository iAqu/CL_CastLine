-- ReplicatedFirst 阶段可直接读取的加载状态属性名。
return {
	PLAYER_DATA_LOADED = "PlayerDataLoaded",
	CLIENT_CONTROLLERS_READY = "ClientControllersReady",
	LOADING_SCREEN_ACTIVE = "LoadingScreenActive",
	LOADING_SCREEN_DONE = "LoadingScreenDone",
	LOADING_BASE_READY = "LoadingBaseReady",
	INTRO_HANDOFF_READY = "FishingIntroHandoffReady",
	INTRO_STARTUP_STATE = "FishingIntroStartupState",
	INTRO_STATE = {
		Pending = "Pending",
		Preparing = "Preparing",
		Prepared = "Prepared",
		Skipped = "Skipped",
	},
	INTRO_CLAIM_TIMEOUT = 10,
	INTRO_PREPARE_TIMEOUT = 30,
}
