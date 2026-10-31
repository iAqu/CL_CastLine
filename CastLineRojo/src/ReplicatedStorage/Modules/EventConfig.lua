local EventConfig = {
	-- 临时关闭 15 分钟槽位自动开事件；改回 true 恢复自动轮转
	AUTO_SCHEDULE_ENABLED = false,
	STATE_FOLDER_NAME = "EventState",
	SLOT_SECONDS = 15 * 60,
	PHASE = table.freeze({
		ACTIVE = "Active",
		WAITING = "Waiting",
	}),
	STATE_ATTRIBUTE = table.freeze({
		PHASE = "Phase",
		EVENT_ID = "EventId",
		STARTED_AT = "StartedAt",
		ENDS_AT = "EndsAt",
		NEXT_STARTS_AT = "NextStartsAt",
		REVISION = "Revision",
	}),
}

function EventConfig.GetSlotIndex(timestamp: number): number
	return math.floor(timestamp / EventConfig.SLOT_SECONDS)
end

function EventConfig.GetSlotStartsAt(slotIndex: number): number
	return slotIndex * EventConfig.SLOT_SECONDS
end

return table.freeze(EventConfig)
