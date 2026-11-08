-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMQBndlaWdodAt0b3RhbFdlaWdodAtOZXh0SW50ZWdlcgVwcmludA10b3RhbCB3ZWlnaHQgBXJhbmQgBnRhYmxlIAdyZXN1bHQgBWVycm9yJnJvbGwgd2VudCBvb2IsIHRoaXMgc2hvdWxkIG5ldmVyIG9jY3VyBFJvbGwEZ2FtZQpSdW5TZXJ2aWNlCkdldFNlcnZpY2UGUmFuZG9tA25ldwADCQIAAAAHBAAABQIEBAuMAgAAUgMBAMYEAADGBQAAZAMDAE0IB8sAAAAAQwICCG4D/P8CAAAAggICAAEDAQAZAgEYAAEAAAABAAD/AAMaAAAAAA0DAQAACAUAAAUDBAQBNFIFAQC8AwCdAAAAAJ8DAwL7BAAAjAYBAFIHAwC8BASMAQAAAJ8EBAIOAg8ApAUDAAAAIEBvBgQAUgcDAJ8FAwGkBQMAAAAgQG8GBQBSBwQAnwUDAaQFAwAAACBAbwYGAFIHAQCfBQMBUgUBAMYGAADGBwAAZAUPAE0KCcsHAAAAJgQECowKAQBgBAoACgAAAA4CBQCkCgMAAAAgQG8LCABSDAkAnwoDAVIKCQBSCwgAggoDAG4F8P8CAAAApAUKAAAAkEBvBgsAnwUCAYIAAQAMAwIDAwMEBAAAIEADBQMGAwcDAQMIAwkEAACQQAMKACELARgAAAAAAQAAAAAAAgEAAAAAAQAAAAABAAAAAAIAAAABAAABAAABAQAAAAACAAD6AAkAAAABIgAAAAAEAAABAgAUowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAv8BAgAAAAAApAIGAAAUQICfAgECwAMHADADAZ0IAAAAwAMJABIAAgAwAwGqCgAAAIIBAgALAwwEAAAAQAMNAw4DDwMQBAAUQIAGAAMCBgEDCwIAAQEAARgAAAAAAAAAFAACAAACAAAIAAAAFQEAAAAAAjLN9Td7DqIdCrAcwsZHQfdC1eJDAAmfNg==

-- https://lua.expert/
game:GetService("RunService")

local t = {}
local v1 = Random.new()

function t.totalWeight(p1, p2) --[[ totalWeight | Line: 25 ]]
	local sum = 0

	for v1, v2 in p2 do
		sum = sum + v2.weight
	end

	return sum
end
function t.Roll(p1, p2, p3) --[[ Roll | Line: 33 | Upvalues: v1 (copy) ]]
	local totalweight = p1:totalWeight(p2)
	local rand = v1:NextInteger(1, totalweight)

	if p3 then
		print("total weight ", totalweight)
		print("rand ", rand)
		print("table ", p2)
	end

	for v12, v2 in p2 do
		rand = rand - v2.weight

		if rand < 1 then
			if p3 then
				print("result ", v2)
			end

			return v2, v12
		end
	end

	error("roll went oob, this should never occur")
end

return t