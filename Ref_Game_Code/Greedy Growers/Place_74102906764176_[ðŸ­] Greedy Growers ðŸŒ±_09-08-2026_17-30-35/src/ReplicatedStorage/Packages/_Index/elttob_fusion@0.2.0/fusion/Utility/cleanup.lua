-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNBnR5cGVvZghJbnN0YW5jZQdEZXN0cm95E1JCWFNjcmlwdENvbm5lY3Rpb24KRGlzY29ubmVjdAhmdW5jdGlvbgV0YWJsZQdkZXN0cm95BmlwYWlycwpjbGVhbnVwT25lASMGc2VsZWN0B2NsZWFudXAAAwkBAQAAAD67LAADUgIAAKQBAQAAAABAnwECAvABBQACAACAvAIAUAMAAACfAgIBggABAPABBQAEAACAvAIAGgUAAACfAgIBggABAPABBAAGAACAUgIAAJ8CAQGCAAEA8AEmAAcAAIBNAwAwCAAAALssAwKkAgEAAAAAQJ8CAgLwAgUABgAAgLwCADAIAAAAnwICAYIAAQBNAwBQAwAAALssAwKkAgEAAAAAQJ8CAgLwAgUABgAAgLwCAFADAAAAnwICAYIAAQATAgAARwILAAAAAACkAgoAAACQQFIDAACfAgIEUQIDAPsHAABSCAYAnwcCAW4C/P8CAACAggABAAsDAQQAAABAAwIDAwMEAwUDBgMHAwgDCQQAAJBAAA4KARgAAAAAAAMAAQAAAAMAAQAAAAMAAQAAAgACAAAAAAAAAAEAAAADAAAAAAAAAAEAAAADAAABAAAAAAEAAP8ABQ8AAAAABwABAQAAFKMAAACMAgEAbwQAALs5BAOkAwIAAAAQQN0FAACfAwACUgADAIwBAQCoAAgA+wMAAKQEAgAAABBAUgUCAN0GAACfBAAAnwMAAYsA+P+CAAEAAwMLAwwEAAAQQAAvDQEYAAEAAAAAAAAAAAABAAAAAAAA/wMvAAAAAAIAAAECAAajAAAAwAAAABIAAADAAQEAEgAAAIIBAgACBgAGAQIAAQEAARgADQAhAAYBAAAAAAJfKAKpszG8A3pSOmwz+mn7LzAV3W3saKg=

-- https://lua.expert/
local function v1(p1) --[[ cleanupOne | Line: 14 | Upvalues: v1 (copy) ]]
	local v12 = typeof(p1)

	if v12 == "Instance" then
		p1:Destroy()

		return
	end

	if v12 == "RBXScriptConnection" then
		p1:Disconnect()

		return
	end

	if v12 == "function" then
		p1()

		return
	end

	if v12 ~= "table" then
		return
	end

	if typeof(p1.destroy) == "function" then
		p1:destroy()

		return
	end

	if typeof(p1.Destroy) == "function" then
		p1:Destroy()

		return
	end

	if p1[1] == nil then
		return
	end

	for i, v in ipairs(p1) do
		v1(v)
	end
end

return function(...) --[[ cleanup | Line: 47 | Upvalues: v1 (copy) ]]
	for i = 1, select("#", ...) do
		v1(select(i, ...))
	end
end