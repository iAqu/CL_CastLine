--# selene: allow(global_usage)
-- Run in the Play Client after the per-fish gameplay run restores its temporary swaps.
return function(testRandom, testDrip)
	assert(_G.FishGameplayJob.done, "Gameplay pass is still running")
	local job = { done = false }
	_G.RigV2Regression = job
	local storage = game.ReplicatedStorage
	local templates = storage.Models.Fish
	local settings = require(storage.Modules.FishingConfig).Bite
	local originalName = settings.FishName
	local swaps = {}
	task.spawn(function()
		local ok, errorMessage = xpcall(function()
			for _, staged in workspace._RigV2Stage:GetChildren() do
				local original = assert(templates:FindFirstChild(staged.Name), "Missing legacy fish")
				local replacement = staged:Clone()
				table.insert(swaps, { old = original, new = replacement })
				original.Parent = nil
				replacement.Parent = templates
			end
			job.current = "Random fish and round identity"
			local randomOk, randomResult = xpcall(testRandom, debug.traceback)
			job.random = if randomOk then randomResult else { passed = false, error = randomResult }
			job.current = "Bone-attached water droplets"
			job.drip = testDrip()
		end, debug.traceback)
		for _, pair in swaps do
			pair.new:Destroy()
			pair.old.Parent = templates
		end
		settings.FishName = originalName
		if not ok then
			job.error = errorMessage
		end
		job.done = true
	end)
	return "Started Rig V2 random and drip regressions"
end
