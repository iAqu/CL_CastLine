return function(clock, wait)
	local mock = {}

	function mock.Request(profile)
		profile:Save()
	end

	function mock.Wait(profile, tag, revision, timeout)
		local deadline = clock() + (timeout or 10)
		local nextSave = 0
		while profile:IsActive() and (profile.MetaData.MetaTagsLatest[tag] or 0) < revision and clock() < deadline do
			if clock() >= nextSave then
				mock.Request(profile)
				nextSave = clock() + 2
			end
			wait(0.1)
		end
		return profile:IsActive() and (profile.MetaData.MetaTagsLatest[tag] or 0) >= revision
	end

	return mock
end
