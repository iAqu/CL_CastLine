-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMGBmlwYWlycwV0b1NldAZzY3JpcHQGUGFyZW50B3JlcXVpcmUFVHlwZXMAAggBAAAABgMAAAUBBAz/AQAAAAAAAKQCAQAAAABAUgMAAJ8CAgRRAgIAqQcBAGoHAQZuAv3/AgAAgIIBAgACAwEEAAAAQAAUAgEYAAACAAAAAAEA/wAEFQAAAAADAAABAgAOowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIA7wUAAACfAQICwAIGAIICAgAHAwMEAAAAQAMEAwUEAAAwQAMGBgABAAEAARgAAQAAAAAAAQAAAAARCgEAAAAAAQ==

-- https://lua.expert/
require(script.Parent.Parent.Types)

return function(p1) --[[ toSet | Line: 20 ]]
	local t = {}

	for i, v in ipairs(p1) do
		t[v] = true
	end

	return t
end