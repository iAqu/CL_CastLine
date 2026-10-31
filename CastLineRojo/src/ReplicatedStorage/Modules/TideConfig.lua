export type TidePhase = "Full" | "Receding" | "Low" | "Rising"

local TideConfig = {
	STATE_FOLDER_NAME = "TideState",
	STATE_ATTRIBUTE = table.freeze({
		PHASE = "Phase",
		PHASE_STARTED_AT = "PhaseStartedAt",
		PHASE_ENDS_AT = "PhaseEndsAt",
		LOW_TIDE_ENDS_AT = "LowTideEndsAt",
		CYCLE_ENDS_AT = "CycleEndsAt",
		GATE_REVEAL_AT = "GateRevealAt",
		IS_PAUSED = "IsPaused",
		REVISION = "Revision",
	}),
	PHASE = table.freeze({
		FULL = "Full" :: TidePhase,
		RECEDING = "Receding" :: TidePhase,
		LOW = "Low" :: TidePhase,
		RISING = "Rising" :: TidePhase,
	}),
	FULL_DURATION = 10,
	LOW_DURATION = 10,
	GATE_REVEAL_DELAY = 2,
	WATER_SPEED = 15,
	LOW_TIDE_ZONE_ID = "Zone_10",
	DIG_ZONE_COUNT = 10,
	PROXIMITY_WARNING_ZONE_DISTANCE = 3,
	TARGET_TOLERANCE = 0.001,
}

return table.freeze(TideConfig)
