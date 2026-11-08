-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMXBXBjYWxsGEdldFByb3BlcnR5Q2hhbmdlZFNpZ25hbBNjYW5ub3RDb25uZWN0Q2hhbmdlCUNsYXNzTmFtZQZ0eXBlb2YIZnVuY3Rpb24UaW52YWxpZENoYW5nZUhhbmRsZXIHQ29ubmVjdAV0YWJsZQZpbnNlcnQFYXBwbHkKU3BlY2lhbEtleQR0eXBlCE9uQ2hhbmdlBGtpbmQIb2JzZXJ2ZXIFc3RhZ2UGc2NyaXB0BlBhcmVudAdyZXF1aXJlCFB1YlR5cGVzB0xvZ2dpbmcIbG9nRXJyb3IABAQAAwAAAAb7AAAA+wIBAPsDAgCHAQIDnwACAYIAAQAAABkAARgAAAAAAAEaAAAAAAsEAgAACQYAAAUEBA8HBCqkBAEAAAAAQE0FApQCAAAAUgYCAPsHAACfBAQDKwQIAPsGAQBvBwMAxggAAE0JAtsEAAAA+woAAJ8GBQGCAAEAuywBA1IHAQCkBgYAAABQQJ8GAgLwBgcABwAAAPsGAQBvBwgAxggAAPsJAACfBgQBggABAFIHAwDZCgAAEgABABIAAgASAgAAvAgFxwkAAACfCAMATDQAAqQGDAAALKCAnwYAAYIAAQANAwEEAAAAQAMCAwMDBAMFBAAAUEADBgMHAwgDCQMKBAAsoIABABILARgAAAAAAAAAAQEAAAAAAAAAAQAAAAAAAAEAAAAAAAIAAAAAAAAAAAAAAAQTAAAAAAMBAQAABgMAAAUBAxH/AQMAAAAAAG8CAAAwAgFxAQAAAG8CAgAwAgFdAwAAAG8CBAAwAgE+BQAAANkCAAASAAAAEgIAADACAc8GAAAAggECAAcDDAMNAw4DDwMQAxEDCwEBDA4BGAAAAQAAAQAAAQAAAgAAAAANDQAAAAAEAAABAgAWowAAAKQAAQAAAABATQAAJAIAAABNAAAkAgAAAKQBBAAAADBATQIApwUAAACfAQICpAIEAAAAMEBNAwB8BgAAAE0DA9MHAAAAnwICAsADCAASAAIAggMCAAkDEgQAAABAAxMDFAQAADBAAxUDFgMXBgIBAgEAARgABwAAAAAAAQAAAAABAAAAAAAAAgAWAQAAAAADn1ALo92hNRmfNzSvh3Ogfe9IHNetlGGi

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local logError = require(v1.Logging.logError)

return function(p1) --[[ OnChange | Line: 12 | Upvalues: logError (copy) ]]
	return {
		type = "SpecialKey",
		kind = "OnChange",
		stage = "observer",
		apply = function(p12, p2, p3, p4) --[[ apply | Line: 18 | Upvalues: p1 (copy), logError (ref) ]]
			local ok, result = pcall(p3.GetPropertyChangedSignal, p3, p1)

			if not ok then
				logError("cannotConnectChange", nil, p3.ClassName, p1)

				return
			end

			if typeof(p2) == "function" then
				local function f1() --[[ Line: 25 | Upvalues: p2 (copy), p3 (copy), p1 (ref) ]]
					p2(p3[p1])
				end

				table.insert(p4, result:Connect(f1))
			else
				logError("invalidChangeHandler", nil, p1)
			end
		end
	}
end