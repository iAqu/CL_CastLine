local PurchasePersistence = {}

local SAVE_RETRY_INTERVAL = 2

function PurchasePersistence.Request(profile)
	local ok, message = pcall(profile.Save, profile)
	if not ok then
		warn("Purchase profile save failed", message)
	end
end

function PurchasePersistence.Wait(profile, tag, revision, timeout)
	local function isSaved()
		return (profile.MetaData.MetaTagsLatest[tag] or 0) >= revision
	end
	if not profile:IsActive() or isSaved() then
		return profile:IsActive()
	end

	local waiter = coroutine.running()
	local waiting, finished, result = false, false, false
	local deadline = os.clock() + (timeout or 10)
	local retryTimer, timeoutTimer
	local function finish(saved)
		if finished then
			return
		end
		finished, result = true, saved
		if waiting then
			task.defer(waiter)
		end
	end
	local tags = profile.MetaTagsUpdated:Connect(function()
		if isSaved() then
			finish(profile:IsActive())
		end
	end)
	local release = profile:ListenToRelease(function()
		finish(false)
	end)
	timeoutTimer = task.delay(timeout or 10, function()
		timeoutTimer = nil
		finish(profile:IsActive() and isSaved())
	end)
	local function requestSave()
		retryTimer = nil
		if finished then
			return
		end
		if not profile:IsActive() then
			finish(false)
			return
		end
		if isSaved() then
			finish(true)
			return
		end
		PurchasePersistence.Request(profile)
		if isSaved() then
			finish(profile:IsActive())
		end
		if not finished and os.clock() + SAVE_RETRY_INTERVAL < deadline then
			retryTimer = task.delay(SAVE_RETRY_INTERVAL, requestSave)
		end
	end
	requestSave()
	if not finished then
		waiting = true
		coroutine.yield()
	end
	tags:Disconnect()
	release:Disconnect()
	if retryTimer then
		task.cancel(retryTimer)
	end
	if timeoutTimer then
		task.cancel(timeoutTimer)
	end
	return result and profile:IsActive()
end

return PurchasePersistence
