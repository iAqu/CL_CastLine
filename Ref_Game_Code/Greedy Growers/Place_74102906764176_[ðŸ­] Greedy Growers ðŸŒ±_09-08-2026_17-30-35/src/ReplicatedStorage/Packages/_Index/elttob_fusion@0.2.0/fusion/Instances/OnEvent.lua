-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMYEmdldFByb3BlcnR5X3Vuc2FmZQVwY2FsbAZ0eXBlb2YPUkJYU2NyaXB0U2lnbmFsEmNhbm5vdENvbm5lY3RFdmVudAlDbGFzc05hbWUIZnVuY3Rpb24TaW52YWxpZEV2ZW50SGFuZGxlcgdDb25uZWN0BXRhYmxlBmluc2VydAVhcHBseQpTcGVjaWFsS2V5BHR5cGUHT25FdmVudARraW5kCG9ic2VydmVyBXN0YWdlBnNjcmlwdAZQYXJlbnQHcmVxdWlyZQhQdWJUeXBlcwdMb2dnaW5nCGxvZ0Vycm9yAAQDAgAAAAcEAAAFAgcDAocCAAGCAgIAAAAMAQEYAAANAAAAAAsEAwAACQYAAAUEBA8HBC2kBAEAAAAAQPsFAABSBgIA+wcBAJ8EBAMOBAcAuywFA1IHBQCkBgMAAAAgQJ8GAgLwBgkABAAAAPsGAgBvBwUAxggAAE0JAtsGAAAA+woBAJ8GBQGCAAEAuywBA1IHAQCkBgMAAAAgQJ8GAgLwBgcABwAAAPsGAgBvBwgAxggAAPsJAQCfBgQBggABAFIHAwBSCgEAvAgFxwkAAACfCAMATDQAAqQGDAAALKCAnwYAAYIAAQANAwIEAAAAQAMDBAAAIEADBAMFAwYDBwMIAwkDCgMLBAAsoIAAFgwBGAAAAAAAAAEAAAAAAAAAAQAAAAAAAAABAAAAAAAAAQAAAAAAAgAAAAAAAAAAAhcAAAAAAwECAAAGAwAABQEDEv8BAwAAAAAAbwIAADACAXEBAAAAbwICADACAV0DAAAAbwIEADACAT4FAAAA2QIAABICAAASAAAAEgIBADACAc8GAAAAggECAAcDDQMOAw8DEAMRAxIDDAEBEA8BGAAAAQAAAQAAAQAAAgAAAAAACxEAAAAABQAAAQIAGKMAAACkAAEAAAAAQE0AACQCAAAATQAAJAIAAACkAQQAAAAwQE0CAKcFAAAAnwECAqQCBAAAADBATQMAfAYAAABNAwPTBwAAAJ8CAgLAAwgAwAQJABIAAwASAAIAggQCAAoDEwQAAABAAxQDFQQAADBAAxYDFwMYBgAGAgIAAgEAARgABwAAAAAAAQAAAAABAAAAAAAAAgQAABQBAAAAAAOYklw2Xj6Rm0BqOQPn7tiW6IpLQqpWNjc=

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local logError = require(v1.Logging.logError)

local function getProperty_unsafe(p1, p2) --[[ getProperty_unsafe | Line: 12 ]]
	return p1[p2]
end

return function(p1) --[[ OnEvent | Line: 16 | Upvalues: getProperty_unsafe (copy), logError (copy) ]]
	return {
		type = "SpecialKey",
		kind = "OnEvent",
		stage = "observer",
		apply = function(p12, p2, p3, p4) --[[ apply | Line: 22 | Upvalues: getProperty_unsafe (ref), p1 (copy), logError (ref) ]]
			local ok, result = pcall(getProperty_unsafe, p3, p1)

			if not ok or typeof(result) ~= "RBXScriptSignal" then
				logError("cannotConnectEvent", nil, p3.ClassName, p1)

				return
			end

			if typeof(p2) == "function" then
				table.insert(p4, result:Connect(p2))
			else
				logError("invalidEventHandler", nil, p1)
			end
		end
	}
end