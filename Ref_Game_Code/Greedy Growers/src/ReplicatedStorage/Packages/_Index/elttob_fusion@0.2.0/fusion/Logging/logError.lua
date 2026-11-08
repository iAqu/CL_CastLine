-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMVDnVua25vd25NZXNzYWdlBnN0cmluZwZmb3JtYXQJW0Z1c2lvbl0gBgooSUQ6IAEpDUVSUk9SX01FU1NBR0UHbWVzc2FnZQRnc3ViGCkKLS0tLSBTdGFjayB0cmFjZSAtLS0tCgV0cmFjZQVlcnJvcgEKBQogICAgCGxvZ0Vycm9yBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQVUeXBlcwdMb2dnaW5nCG1lc3NhZ2VzAAIMAgEBAAcEAAAFAgMPOaMCAADGAgAA+wQAAIcDBABHAwQAAAAAAPsDAACHAgMAZQADAG8AAAD7AwAAhwIDAMYDAABHAQ0AAAAAgKQEAwAACBCAbwYEAFIHAgBvCAUAUgkAAG8KBgBzBQYK3QYAAJ8EAAJSAwQAZQAUAG8GBwBNBwGYCAAAALwEAswJAAAAnwQEAlICBACkBAMAAAgQgG8GBABSBwIAbwgFAFIJAABvCgoATQsBTQsAAABzBQYL3QYAAJ8EAAJSAwQApAQNAAAAwEBvBw4AbwgPALwFA8wJAAAAnwUEAowGAACfBAMBggABABADAQMCAwMEAAgQgAMEAwUDBgMHAwgDCQMKAwsDDAQAAMBAAw0DDgALDwEYAAECAAAAAQAAAgEAAwEAAQAAAAAAAAAAAAAAAgAAAAAAAAEAAAAAAAAAAAAAAAADAAAAAAAAAAABCwAAAAAEAAABAgAWowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIA7wUAAACfAQICpAIEAAAAMEBNAwB8BgAAAE0DAwIHAAAAnwICAsADCAASAAIAggMCAAkDEAQAAABAAxEDEgQAADBAAxMDFAMVBgABAAEAARgABgAAAAAAAQAAAAABAAAAAAAAAgAVAQAAAAABMDXroh+rEJv7d0xA30xMuUAt/NYC8YGj

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.Types)

local messages = require(v1.Logging.messages)

return function(p1, p2, ...) --[[ logError | Line: 11 | Upvalues: messages (copy) ]]
	if messages[p1] == nil then
		p1 = "unknownMessage"
	end

	local v1 = messages[p1]

	error((if p2 == nil then string.format("[Fusion] " .. v1 .. "\n(ID: " .. p1 .. ")", ...) else string.format("[Fusion] " .. v1:gsub("ERROR_MESSAGE", p2.message) .. "\n(ID: " .. p1 .. ")\n---- Stack trace ----\n" .. p2.trace, ...)):gsub("\n", "\n    "), 0)
end