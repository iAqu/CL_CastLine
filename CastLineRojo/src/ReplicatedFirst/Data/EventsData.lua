export type EventConfig = {
	EventID: string,
	Index: number,
	DisplayName: string,
	Description: string,
	EventType: string,
	Duration: number,
	EffectValue: number,
	MutationId: string,
	Info: string,
}

local data: {[string]: EventConfig} = {
	Event_01 = {
		EventID = "Event_01",
		Index = 1,
		DisplayName = "Golden Sea",
		Description = "Item: Golden mutation",
		EventType = "mutation",
		Duration = 300,
		EffectValue = 1,
		MutationId = "Golden",
		Info = "nil",
	},
	Event_02 = {
		EventID = "Event_02",
		Index = 2,
		DisplayName = "Diamond Sea",
		Description = "Item: Diamond mutation",
		EventType = "mutation",
		Duration = 300,
		EffectValue = 1,
		MutationId = "Diamond",
		Info = "nil",
	},
	Event_03 = {
		EventID = "Event_03",
		Index = 3,
		DisplayName = "Rainbow Sea",
		Description = "Item: Rainbow mutation",
		EventType = "mutation",
		Duration = 300,
		EffectValue = 1,
		MutationId = "Rainbow",
		Info = "nil",
	},
}

return data