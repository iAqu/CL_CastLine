local Controller = require("./Controller")

local function check(value, message)
	assert(value, message or "unexpected lifecycle state")
end

local function fixture()
	local env = { time = 0, edit = true, peers = {}, starts = {}, stops = {}, warnings = {}, delay = 1 }
	local worker
	local controller = Controller.new({
		now = function() return env.time end,
		wait = function(seconds) coroutine.yield(seconds) end,
		spawn = function(callback)
			worker = coroutine.create(callback)
			local ok, err = coroutine.resume(worker)
			check(ok, err)
		end,
		isEdit = function() return env.edit end,
		peers = function() return env.peers end,
		connected = function(connection) return connection.Connected end,
		delay = function() return env.delay end,
		stopServer = function(server, serial)
			table.insert(env.stops, { server = server, serial = serial, time = env.time })
		end,
		startPlay = function(serial, onboarding)
			table.insert(env.starts, { serial = serial, time = env.time, onboarding = onboarding })
		end,
		busyChanged = function(value) env.busy = value end,
		warning = function(message) table.insert(env.warnings, message) end,
	})
	function env.advance(seconds)
		env.time += seconds
		if worker and coroutine.status(worker) ~= "dead" then
			local ok, err = coroutine.resume(worker)
			check(ok, err)
		end
	end
	function env.play()
		env.edit = false
		env.peers = {
			{ connection = { Connected = true }, role = "server", supported = true },
			{ connection = { Connected = true }, role = "client", supported = true },
		}
	end
	function env.stop()
		for _, peer in env.peers do
			peer.connection.Connected = false
		end
		env.peers = {}
		env.edit = true
	end
	return controller, env
end

local cases = {
	["running test without handshake asks to reload instead of claiming startup failed"] = function()
		local c, e = fixture()
		c:request()
		e.edit = false
		e.peers = { { connection = { Connected = true }, role = "unknown", supported = false } }
		e.advance(0.1)
		e.advance(60)
		check(not c.busy and #e.starts == 1 and #e.warnings == 1)
		check(string.find(e.warnings[1], "Reload Plugin", 1, true), "missing actionable reload diagnosis")
	end,
	["manual Stop while waiting for handshake cancels the startup watch"] = function()
		local c, e = fixture()
		c:request()
		e.edit = false
		e.peers = { { connection = { Connected = true }, role = "unknown", supported = false } }
		e.advance(0.1)
		e.stop()
		e.advance(0.1)
		check(not c.busy and #e.warnings == 0, "watch continued after manual Stop")
		e.advance(60)
		check(#e.warnings == 0 and #e.starts == 1)
	end,
	["Edit starts once and ignores rapid clicks"] = function()
		local c, e = fixture()
		check(c:request())
		check(not c:request())
		check(#e.starts == 1 and #e.stops == 0)
		e.play()
		e.advance(0.1)
		check(not c.busy and #e.warnings == 0)
	end,
	["full delay begins after Edit AND both connections close"] = function()
		local c, e = fixture()
		e.play()
		local old = e.peers
		c:request()
		check(#e.stops == 1 and #e.starts == 0)
		e.edit = true
		e.advance(2)
		check(#e.starts == 0)
		e.peers = {}
		e.advance(2)
		check(#e.starts == 0)
		for _, peer in old do
			peer.connection.Connected = false
		end
		e.advance(0.1)
		e.advance(0.99)
		check(#e.starts == 0)
		e.advance(0.02)
		check(#e.starts == 1)
		e.play()
		e.advance(0.1)
		check(not c.busy and #e.warnings == 0)
	end,
	["settings change allowance to three seconds"] = function()
		local c, e = fixture()
		e.delay = 3
		e.play()
		c:request()
		e.stop()
		e.advance(0.1)
		e.advance(2.99)
		check(#e.starts == 0)
		e.advance(0.02)
		check(#e.starts == 1)
	end,
	["ordinary Stop never requests a restart"] = function()
		local c, e = fixture()
		e.play()
		e.stop()
		e.advance(5)
		check(#e.starts == 0 and #e.stops == 0 and not c.busy)
	end,
	["three consecutive restarts each start exactly once"] = function()
		local c, e = fixture()
		e.play()
		for index = 1, 3 do
			check(c:request())
			check(not c:request())
			e.stop()
			e.advance(0.1)
			e.advance(1.1)
			e.play()
			e.advance(0.1)
			check(not c.busy and #e.starts == index and #e.stops == index)
		end
	end,
	["onboarding mode applies only to the requested restart"] = function()
		local c, e = fixture()
		e.play()
		check(c:request(true))
		check(not c:request(false))
		e.stop()
		e.advance(0.1)
		e.advance(1.1)
		check(#e.starts == 1 and e.starts[1].onboarding == true)
		e.play()
		e.advance(0.1)
		e.stop()
		check(c:request(false))
		check(#e.starts == 2 and e.starts[2].onboarding == false)
	end,
	["stop timeout cancels without another stop or start"] = function()
		local c, e = fixture()
		e.play()
		c:request()
		e.advance(60)
		check(not c.busy and #e.stops == 1 and #e.starts == 0 and #e.warnings == 1)
		e.stop()
		e.advance(10)
		check(#e.starts == 0)
	end,
	["a new test during stop cancels the old request"] = function()
		local c, e = fixture()
		e.play()
		c:request()
		e.stop()
		e.play()
		e.advance(0.1)
		check(#e.starts == 0 and #e.warnings == 1 and not c.busy)
	end,
	["a new test during synchronization allowance is preserved"] = function()
		local c, e = fixture()
		e.play()
		c:request()
		e.stop()
		e.advance(0.1)
		e.play()
		e.advance(1.1)
		check(#e.starts == 0 and #e.stops == 1 and #e.warnings == 1)
	end,
	["missing test plugin cancels safely"] = function()
		local c, e = fixture()
		e.edit = false
		c:request()
		check(#e.stops == 0 and #e.starts == 0 and #e.warnings == 1)
	end,
	["Run or detached multiplayer is rejected"] = function()
		local c, e = fixture()
		e.play()
		e.peers[1].supported = false
		c:request()
		check(#e.stops == 0 and #e.starts == 0 and #e.warnings == 1)
	end,
	["multiple clients are rejected"] = function()
		local c, e = fixture()
		e.play()
		table.insert(e.peers, { connection = { Connected = true }, role = "client", supported = true })
		c:request()
		check(#e.stops == 0 and #e.starts == 0 and #e.warnings == 1)
	end,
	["server failure ends the request without retry"] = function()
		local c, e = fixture()
		e.play()
		c:request()
		c:fail(1, "EndTest unavailable")
		e.advance(0.1)
		check(not c.busy and #e.starts == 0 and #e.warnings == 1)
	end,
	["start failure does not start again"] = function()
		local c, e = fixture()
		c:request()
		c:fail(1, "ExecutePlayModeAsync unavailable")
		e.advance(0.1)
		check(not c.busy and #e.starts == 1 and #e.warnings == 1)
	end,
	["unloading cancels a pending restart"] = function()
		local c, e = fixture()
		e.play()
		c:request()
		e.stop()
		e.advance(0.1)
		c:destroy()
		e.advance(2)
		check(#e.starts == 0 and #e.warnings == 0)
	end,
	["another Studio coordinator remains idle"] = function()
		local c, e = fixture()
		local other, otherEnv = fixture()
		e.play()
		otherEnv.play()
		c:request()
		check(not other.busy and #otherEnv.stops == 0 and #otherEnv.starts == 0)
	end,
}

local count = 0
local failures = {}
for name, test in cases do
	local ok, err = pcall(test)
	if not ok then
		table.insert(failures, name .. ": " .. tostring(err))
	end
	count += 1
end
check(#failures == 0, table.concat(failures, "\n"))
return tostring(count) .. " lifecycle cases passed"
