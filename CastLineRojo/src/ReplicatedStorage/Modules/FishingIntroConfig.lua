-- First-session fishing tutorial. No cinematic timeline or NPC assets.
return {
	Version = 1,
	StarterFishId = "Fish_102",
	SuccessHold = 1.4,
	RaiseFishTime = 0.25,
	Instructions = {
		Cast = { Action = "CAST", Color = { 0, 200, 255 } },
		Waiting = { Text = "WAIT FOR A STRONG BITE", Color = { 255, 200, 0 } },
		Retry = { Text = "WAIT UNTIL IT HOLDS", Color = { 255, 128, 0 } },
		Hook = { Action = "HOOK", Color = { 30, 255, 60 } },
		Continue = { Action = "CONTINUE", Color = { 255, 255, 255 } },
	},
}
