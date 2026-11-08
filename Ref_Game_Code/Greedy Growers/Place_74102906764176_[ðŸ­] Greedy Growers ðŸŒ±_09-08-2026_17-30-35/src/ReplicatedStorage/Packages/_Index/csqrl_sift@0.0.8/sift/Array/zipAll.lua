-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNBG1hdGgDbWF4ASMGc2VsZWN0BmlwYWlycwV0YWJsZQZpbnNlcnQGemlwQWxsBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQZyZWR1Y2UETm9uZQADBQIAAAAACBwEAQCeEgAEBAAAAFIDAACkAgIAAAQAgJ8CAwKCAgIAAwMBAwIEAAQAgAAhAAEYAAAAAAAAAAAiAAAAABEAAgEAADmjAAAAbwEAALs5AQOkAAIAAAAQQN0CAACfAAAC/wEAAAAAAADdAgAAxQECAAEAAAD/AgAAAAAAAA0AAgADAACAggICAPsDAABSBAEAwAUEABMHAQAcBgcAnwMEAowGAQBSBAMAjAUBAKgEHQD/BwAAAAAAAKQIBgAAAFBAUgkBAJ8IAgRRCAwAhw0MBkcNAwAAAACA+xABAGUAAQBSEA0AnjQHBBAAAABSDwcApA4JAAAgcICfDgMBbgjz/wIAAICeNAIFBwAAAFIJAgBSCgcApAgJAAAgcICfCAMBiwTj/4ICAgAKAwMDBAQAABBAAgAAAAAAAAAABgADBQQAAFBAAwYDBwQAIHCAAQAYCAEYAAEAAAAAAAEAAAAAAQACAAEDAAACAP4EAAAAAQACAAAAAAEBAAAAAAAAAAAAAP4ABQAAAAAAAPgLGAAAAAAEAAABAgAZowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBApAIBAAAAAEBNAgIkAgAAAE0CAv4FAAAAnwECAqQCBAAAADBATQMAPwYAAACfAgICwAMHABIAAQASAAIAggMCAAgDCQQAAABAAwoDCwQAADBAAwwDDQYBAQEBAAEYAAEAAAAAAAIAAAAAAAAAAAEAAAAAEwAAGwEAAAAAAkw7cZXme3GitB9XH3j3K7I8I2bhfv8blA==

-- https://lua.expert/
local v1 = script.Parent.Parent
local reduce = require(script.Parent.reduce)
local None = require(v1.None)

return function(...) --[[ zipAll | Line: 24 | Upvalues: reduce (copy), None (copy) ]]
	local list = { ... }
	local t = {}

	if select("#", ...) == 0 then
		return t
	end

	for i = 1, reduce(list, function(p1, p2) --[[ Line: 33 ]]
		return math.max(p1, #p2)
	end, #list[1]) do
		local t2 = {}

		for i2, v in ipairs(list) do
			local v1 = v[i]

			table.insert(t2, if v1 == nil then None else v1)
		end

		table.insert(t, t2)
	end

	return t
end