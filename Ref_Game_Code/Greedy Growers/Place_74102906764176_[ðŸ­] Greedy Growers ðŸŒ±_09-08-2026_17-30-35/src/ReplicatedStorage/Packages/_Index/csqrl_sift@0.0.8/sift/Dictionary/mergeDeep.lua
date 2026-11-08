-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLASMGc2VsZWN0BHR5cGUFdGFibGUFcGFpcnMJbWVyZ2VEZWVwBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQROb25lCGNvcHlEZWVwAAINAAMBAABGowAAAP8AAAAAAAAAjAMBAG8FAAC7OQUDpAQCAAAAEEDdBgAAnwQAAlIBBACMAgEAqAE4ALs5AwSkBAIAAAAQQFIFAwDdBgAAnwQAArsoBANSBgQApAUEAAAAMECfBQIC8AUrAAUAAICkBQcAAABgQFIGBACfBQIEFwUjAPsKAACaCQQACgAAAMYKAABqCgAIZQAdALsoCQNSCwkApAoEAAAAMECfCgIC8AoWAAUAAICHCgAIRwoIAAAAAACHCwAIuygLAqQKBAAAADBAnwoCAvAKBgAFAAAA+woBAFILCQCfCgICagoACGUABwD7CgIAhwsACFIMCQCfCgMCagoACGUAAQBqCQAIbgXc/wIAAACLAcj/ggACAAgDAQMCBAAAEEADAwQAADBAAwQDBQQAAGBAABwGARgAAQACAAAAAAAAAAAAAQAAAAAAAgAAAAAAAAQAAAAAAQAAAQAAAQAAAAAAAAEAAAAAAAAAAAABAAAAAAIAAAAAAAP2APkWHAAAAAAEAAABAgAaowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIAPwUAAACfAQICpAIEAAAAMECkAwEAAAAAQE0DAyQCAAAATQMDjQYAAACfAgICwAMHABIAAQASAAIAEgADAIIDAgAIAwcEAAAAQAMIAwkEAAAwQAMKAwsGAAEAAQABGAABAAAAAAACAAAAAAEAAAAAAAAAABcAAAAcAQAAAAABKSBhKu9LUZlp01R2Js21O1k4dl4b5Asr

-- https://lua.expert/
local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)

local function v2(...) --[[ mergeDeep | Line: 28 | Upvalues: None (copy), copyDeep (copy), v2 (copy) ]]
	local t = {}

	for i = 1, select("#", ...) do
		local v1 = select(i, ...)

		if type(v1) == "table" then
			for k, v in pairs(v1) do
				if v == None then
					t[k] = nil

					continue
				end

				if type(v) == "table" then
					if t[k] ~= nil and type(t[k]) == "table" then
						t[k] = v2(t[k], v)

						continue
					end

					t[k] = copyDeep(v)

					continue
				end

				t[k] = v
			end
		end
	end

	return t
end

return v2