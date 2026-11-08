-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMHCUluc3RhbmNlcw1Xb3JsZFBvc2l0aW9uBVNvbHZlFFVwZGF0ZVRvTmV4dFBvc2l0aW9uBkNGcmFtZQZsb29rQXQJVmlzdWFsaXplAAQHAgAAAAcEAAAFAgQEEU0DAecAAAAAEwIDAE0CAuABAAAATQUB5wAAAAATBAUBTQQE4AEAAABNBgHnAAAAABMFBgBNBQXgAQAAACYDBAWCAgMAAgMBAwIACQMBGAAAAAAAAQAAAAAAAAAAAAACCgAAAAAEAgAAAAcEAAAFAgQEBk0DAecAAAAAEwIDAE0CAuABAAAAggICAAIDAQMCABAEARgAAAAAAAARAAAAAAYCAAAABwQAAAUCBAQOpAICAAAEAIBNBAHnAwAAABMDBABNAwPgBAAAAE0FAecDAAAAEwQFAU0EBOAEAAAAnwIDAIICAAAFAwUDBgQABACAAwEDAgAUBwEYAAAAAAAAAAAAAAAAAAAVAAAAAAIAAAECAA2jAAAA/wADAAAAAADAAQAAMAEAtAEAAADAAQIAMAEAdwMAAADAAQQAMAEAggUAAACCAAIABgYAAwMGAQMEBgIDBwMAAQIBAAEYAAQABAAABwAABAAABAEAAAAAAzgl/BgquIVnUoLiuRxukZRIPetsCuGWGQ==

-- https://lua.expert/
return {
	Solve = function(p1, p2) --[[ Solve | Line: 9 ]]
		return p2.Instances[1].WorldPosition, p2.Instances[2].WorldPosition - p2.Instances[1].WorldPosition
	end,
	UpdateToNextPosition = function(p1, p2) --[[ UpdateToNextPosition | Line: 16 ]]
		return p2.Instances[1].WorldPosition
	end,
	Visualize = function(p1, p2) --[[ Visualize | Line: 20 ]]
		return CFrame.lookAt(p2.Instances[1].WorldPosition, p2.Instances[2].WorldPosition)
	end
}