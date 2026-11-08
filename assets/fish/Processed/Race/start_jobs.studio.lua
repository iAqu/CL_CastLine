--# selene: allow(global_usage)
local h = game.HttpService
_G.RacePublishFish = assert(loadstring(h:GetAsync("http://127.0.0.1:18775/publish_fish.studio.lua")))()
_G.RacePublishAnimation = assert(loadstring(h:GetAsync("http://127.0.0.1:18775/publish_animations.studio.lua")))()
_G.RaceMeshJob = { done = false, results = {}, errors = {} }
_G.RaceAnimationJob = { done = false, results = {}, errors = {} }
task.spawn(function()
	local order = { 1, 22, 11, 5, 9, 15, 10 }
	local seen = {}
	for _, i in order do
		seen[i] = true
	end
	for i = 1, 25 do
		if not seen[i] then
			table.insert(order, i)
		end
	end
	for _, i in order do
		local key = string.format("Race%03d", i)
		_G.RaceMeshJob.current = key
		_G.RaceMeshJob.part = 0
		local ok, result = xpcall(function()
			return _G.RacePublishFish(key)
		end, debug.traceback)
		if ok then
			table.insert(_G.RaceMeshJob.results, result)
		else
			table.insert(_G.RaceMeshJob.errors, { key = key, error = result })
		end
		h:PostAsync(
			"http://127.0.0.1:18775/mesh-publication.json",
			h:JSONEncode(_G.RaceMeshJob),
			Enum.HttpContentType.ApplicationJson
		)
		task.wait()
	end
	_G.RaceMeshJob.done = true
	h:PostAsync(
		"http://127.0.0.1:18775/mesh-publication.json",
		h:JSONEncode(_G.RaceMeshJob),
		Enum.HttpContentType.ApplicationJson
	)
end)
task.spawn(function()
	for _, family in { "shark", "dolphin", "ray", "turtle", "eel", "squid", "ornate" } do
		local variant = "race_" .. family
		_G.RaceAnimationJob.current = variant
		local ok, result = xpcall(function()
			return _G.RacePublishAnimation(variant)
		end, debug.traceback)
		if ok then
			table.insert(_G.RaceAnimationJob.results, result)
		else
			table.insert(_G.RaceAnimationJob.errors, { variant = variant, error = result })
		end
		h:PostAsync(
			"http://127.0.0.1:18775/animation-publication.json",
			h:JSONEncode(_G.RaceAnimationJob),
			Enum.HttpContentType.ApplicationJson
		)
		task.wait()
	end
	_G.RaceAnimationJob.done = true
	h:PostAsync(
		"http://127.0.0.1:18775/animation-publication.json",
		h:JSONEncode(_G.RaceAnimationJob),
		Enum.HttpContentType.ApplicationJson
	)
end)
return "Publishing skins and seven five-clip animation families"
