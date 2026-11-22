local file = assert(io.open("src/ServerScriptService/Libs/ProfileService.lua", "r"))
local source = file:read("*a")
file:close()

local storeName = "RELEASE_230724"
local profileKey = "Player_123"

local function makeStudioStore(update)
	local clock = 8
	local waits = 0
	local close
	local requestedStores = {}
	local runService = {
		IsStudio = function() return true end,
		Heartbeat = { Connect = function() return { Disconnect = function() end } end },
	}
	local dataStoreService = {
		GetDataStore = function(_, name)
			table.insert(requestedStores, name)
			if name ~= storeName then
				error("ConnectFail")
			end
			return { UpdateAsync = update }
		end,
	}
	local chunk = assert(loadstring(source, "ProfileService"))
	local profileService = setfenv(chunk, setmetatable({
		game = {
			PlaceId = 84106335829275,
			JobId = "studio",
			GetService = function(_, name)
				return if name == "DataStoreService" then dataStoreService else runService
			end,
			BindToClose = function(_, callback) close = callback end,
		},
		Instance = { new = function() return { SetExperimentalFeatures = function() end } end },
		os = { clock = function() return clock end, time = os.time },
		task = {
			spawn = function(callback, ...) callback(...) end,
			wait = function()
				waits += 1
				assert(waits < 25, "The load kept retrying after cancellation")
				clock += 8
			end,
		},
		warn = function() end,
		print = function() end,
	}, { __index = getfenv() }))()
	return profileService.GetProfileStore(storeName, { Wins = 0 }), requestedStores, close
end

local existing = {
	Data = { Wins = 345 },
	MetaData = { SessionLoadCount = 2, ProfileCreateTime = 111, MetaTags = {} },
	GlobalUpdates = { 0, {} },
}
local attempts = 0
local store, requestedStores, close = makeStudioStore(function(_, key, transform)
	assert(key == profileKey)
	attempts += 1
	if attempts == 1 then
		error("ConnectFail")
	end
	existing = transform(existing)
	return existing, {}
end)

local realProfile = assert(store:LoadProfileAsync(profileKey))
assert(realProfile.Data.Wins == 345 and attempts == 2, "Retry must load the preexisting cloud profile")
assert(#requestedStores == 1 and requestedStores[1] == storeName, "Ordinary Studio play must only open the real store")
local mockProfile = assert(store.Mock:LoadProfileAsync(profileKey))
assert(mockProfile.Data.Wins == 0 and attempts == 2, "Explicit mock play must use isolated data")
mockProfile.Data.Wins = 12
mockProfile:Release()
assert(assert(store.Mock:LoadProfileAsync(profileKey)).Data.Wins == 12, "Explicit mock data lasts for the current session")
assert(realProfile.Data.Wins == 345 and attempts == 2, "Mock changes must stay out of the cloud")
realProfile.Data.Wins = 347
assert(close, "The Studio server must register its profile shutdown save")
close()
assert(existing.Data.Wins == 347 and existing.MetaData.ActiveSession == nil, "Studio shutdown must save and release the real profile")

attempts = 0
local unavailable = makeStudioStore(function()
	attempts += 1
	error("403: Studio access to APIs is not allowed")
end)
assert(unavailable:LoadProfileAsync(profileKey, nil, function() return attempts >= 3 end) == nil)
assert(attempts == 3, "A persistent error must stop retrying when the caller cancels")

local cancelled = false
local interrupted = makeStudioStore(function(_, _, transform)
	cancelled = true
	assert(transform(nil) == nil, "Cancellation before the transform must not write a new profile")
	return nil
end)
assert(interrupted:LoadProfileAsync(profileKey, nil, function() return cancelled end) == nil)
