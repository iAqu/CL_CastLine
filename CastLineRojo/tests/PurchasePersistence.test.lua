local path = "src/ServerScriptService/Services/PurchasePersistence.lua"
local file = assert(io.open(path, "r"), "Expected purchase persistence source")
local source = file:read("*a")
file:close()

local function fixture()
	local now = 0
	local jobs = {}
	local function delay(seconds, action)
		local job = { Time = now + seconds, Action = action }
		table.insert(jobs, job)
		return job
	end
	local function signal()
		local listeners = {}
		return {
			Connect = function(_, callback)
				listeners[callback] = true
				return { Disconnect = function() listeners[callback] = nil end }
			end,
			Fire = function()
				for callback in listeners do
					callback()
				end
			end,
			HasListeners = function()
				return next(listeners) ~= nil
			end,
		}
	end
	local release = signal()
	local profile = { Active = true, MetaData = { MetaTagsLatest = {} }, MetaTagsUpdated = signal() }
	function profile:IsActive()
		return self.Active
	end
	function profile:ListenToRelease(callback)
		return release:Connect(callback)
	end
	function profile:Commit(revision)
		self.MetaData.MetaTagsLatest.Purchase = revision
		self.MetaTagsUpdated:Fire()
	end
	function profile:Release()
		self.Active = false
		release:Fire()
	end
	local persistence = assert(load(source, path, "t", setmetatable({
		os = { clock = function() return now end },
		task = {
			delay = delay,
			defer = function(waiter)
				delay(0, function()
					local ok, message = coroutine.resume(waiter)
					assert(ok, message)
				end)
			end,
			cancel = function(job)
				job.Canceled = true
			end,
		},
		warn = function() end,
	}, { __index = getfenv() })))()
	local function run(timeout)
		local result
		local waiter = coroutine.create(function()
			result = persistence.Wait(profile, "Purchase", 2, timeout)
		end)
		local ok, message = coroutine.resume(waiter)
		assert(ok, message)
		while #jobs > 0 do
			table.sort(jobs, function(a, b) return a.Time < b.Time end)
			local job = table.remove(jobs, 1)
			if not job.Canceled then
				now = job.Time
				job.Action()
			end
		end
		assert(coroutine.status(waiter) == "dead", "Wait must finish")
		assert(not profile.MetaTagsUpdated.HasListeners() and not release.HasListeners(), "Listeners must disconnect")
		return result, now
	end
	return profile, delay, run
end

local profile, delay, run = fixture()
function profile:Save()
	delay(0.011, function() self:Commit(1) end)
	delay(0.034, function() self:Commit(2) end)
end
local saved, elapsed = run()
assert(saved and elapsed == 0.034, "Wait resumes on the corresponding revision without polling")

profile, delay, run = fixture()
local attempts = 0
function profile:Save()
	attempts += 1
	if attempts == 1 then
		error("transient save error")
	end
	delay(0.013, function() self:Commit(2) end)
end
saved, elapsed = run()
assert(saved and attempts == 2 and elapsed == 2.013, "Transient failures retry")

profile, delay, run = fixture()
function profile:Save()
	delay(0.03, function() self:Release() end)
end
saved, elapsed = run()
assert(not saved and elapsed == 0.03, "Releasing a profile wakes the waiter")

profile, delay, run = fixture()
function profile:Save() end
saved, elapsed = run(0.2)
assert(not saved and elapsed == 0.2, "A missing confirmation respects the timeout")
