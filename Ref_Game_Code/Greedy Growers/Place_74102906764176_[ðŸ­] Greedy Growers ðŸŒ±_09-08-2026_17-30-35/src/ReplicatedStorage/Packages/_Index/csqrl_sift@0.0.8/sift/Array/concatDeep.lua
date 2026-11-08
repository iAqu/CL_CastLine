-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMMASMGc2VsZWN0BHR5cGUFdGFibGUGaXBhaXJzBmluc2VydApjb25jYXREZWVwBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQhjb3B5RGVlcAROb25lAAIOAAIBAAA9owAAAP8AAAAAAAAAjAMBAG8FAAC7OQUDpAQCAAAAEEDdBgAAnwQAAlIBBACMAgEAqAEvALs5AwSkBAIAAAAQQFIFAwDdBgAAnwQAArsoBANSBgQApAUEAAAAMECfBQIC8AUiAAUAAICkBQcAAABgQFIGBACfBQIEUQUaAPsKAADxCRgACgAAALsoCQNSCwkApAoEAAAAMECfCgIC8AoKAAUAAIBSCwAA+wwBAFINCQCfDAIATDQAAqQKCQAAIFCAnwoAAWUABwCeNAAFCQAAAFILAABSDAkApAoJAAAgUICfCgMBbgXl/wIAAICLAdH/ggACAAoDAQMCBAAAEEADAwQAADBAAwQDBQQAAGBAAwYEACBQgAAcBwEYAAEAAgAAAAAAAAAAAAEAAAAAAAIAAAAAAAAEAAAAAAEAAAEAAAAAAAABAAAAAAAAAAACAAAAAAAA+wD5EhwAAAAABAAAAQIAGaMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQKQCAQAAAABATQICJAIAAABNAgKNBQAAAJ8BAgKkAgQAAAAwQE0DAD8GAAAAnwICAsADBwASAAIAEgABAIIDAgAIAwgEAAAAQAMJAwoEAAAwQAMLAwwGAAEAAQABGAABAAAAAAACAAAAAAAAAAABAAAAABcAABgBAAAAAAGeO5wdmurSzfee9FCkdS7L7iOLaaz/9hw=

-- https://lua.expert/
local v1 = script.Parent.Parent
local copyDeep = require(script.Parent.copyDeep)
local None = require(v1.None)

return function(...) --[[ concatDeep | Line: 28 | Upvalues: None (copy), copyDeep (copy) ]]
	local t = {}

	for i = 1, select("#", ...) do
		local v1 = select(i, ...)

		if type(v1) == "table" then
			for i2, v in ipairs(v1) do
				if v ~= None then
					if type(v) == "table" then
						table.insert(t, copyDeep(v))

						continue
					end

					table.insert(t, v)
				end
			end
		end
	end

	return t
end