-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMKCUNvbm5lY3RlZApDb25uZWN0aW9uCkRpc2Nvbm5lY3QMc2V0bWV0YXRhYmxlBF9uZXcUUmJ4U2NyaXB0Q29ubmVjdGlvbjwIdG9zdHJpbmcBPgpfX3Rvc3RyaW5nB19faW5kZXgABAMBAAAAAAxNAQDRAAAAAA4BCACpAQAAMAEA0QAAAABNAQCAAQAAALwBARoCAAAAnwECAYIAAQADAwEDAgMDABQDARgAAAABAAABAAAAAAIVAAAAAAQBAQAABgMAAAUBBwriAgEAMAACgAAAAAD7AwAAnj0CAwMAAACkAQMAAAAgQJ8BAwKCAQIABAMCBQEAAwQEAAAgQAAbBQEYAAEAAQAA/gAAABwAAAAABwEAAAAAC28CAABNBgDRAQAAALs/BgKkBQMAAAAgQJ8FAgJSAwUAbwQEAHMBAgSCAQIABQMGAwEDBwQAACBAAwgAIQkBGAAAAAAAAAAAAAAAIgAAAAACAAABAgATowAAAP8ABAAAAAAAqQEBADABANEAAAAAMAAAbgEAAADAAQIAMAEAGgMAAADAAQQAEgAAADABAMIFAAAAwAEGADABAAYHAAAAggACAAgDAQMKBgADAwYBAwUGAgMJAwABAgEAARgABQABAAABAAwAAAcAAAAGAAAFAQAAAAADUiIxMaXWkF37EEd8d7jHQSI6JkVg5lsw

-- https://lua.expert/
local t = {
	Connected = true
}

t.__index = t
function t.Disconnect(p1) --[[ Disconnect | Line: 20 ]]
	if not p1.Connected then
		return
	end

	p1.Connected = false
	p1.Connection:Disconnect()
end
function t._new(p1) --[[ _new | Line: 27 | Upvalues: t (copy) ]]
	return setmetatable({
		Connection = p1
	}, t)
end
function t.__tostring(p1) --[[ __tostring | Line: 33 ]]
	return "RbxScriptConnection<" .. tostring(p1.Connected) .. ">"
end

return t