--# selene: allow(global_usage)
-- Client-only QA wrapper; callbacks execute repository test sources, never synchronize scripts.
return function(runRandom, runDrip)
	assert(_G.FishGameplayJob.done and #_G.FishGameplayJob.errors == 0, "Wait for gameplay QA")
	local job = { done = false }
	_G.RaceRegressionJob = job
	local storage = game.ReplicatedStorage
	local settings = require(storage.Modules.FishingConfig).Bite
	local originalName = settings.FishName
	local created = {}
	local function cleanup()
		settings.FishName = originalName
		for _, fish in created do
			fish:Destroy()
		end
	end
	task.spawn(function()
		local ok, err = xpcall(function()
			local stage = workspace:FindFirstChild("_FishRace_Staging")
			if stage then
				for _, fish in stage:GetChildren() do
					assert(not storage.Models.Fish:FindFirstChild(fish.Name), "Duplicate QA species")
					local clone = fish:Clone()
					clone.Parent = storage.Models.Fish
					table.insert(created, clone)
				end
			end
			job.current = "Random selection and round identity"
			job.random = runRandom()
			job.current = "53-species drip regression"
			job.drip = runDrip()
			job.current = "Legacy mouth fallback"
			local Bite = require(storage.Modules.FishingBiteSequence)
			local legacy = storage.Models.Fish["Elder Fish"]:Clone()
			legacy.Name, legacy.Parent = "_LegacyMouthQA", storage.Models.Fish
			table.insert(created, legacy)
			legacy.PrimaryPart.MouthAttachment:Destroy()
			settings.FishName = legacy.Name
			local folder = Instance.new("Folder")
			folder.Parent = workspace
			table.insert(created, folder)
			local bait = storage.Models.FishBait["1"]["1"]:Clone()
			bait.Anchored, bait.Parent = true, folder
			local owner = {
				folder = folder,
				bait = bait,
				forward = Vector3.zAxis,
				spin = 0,
				statusLabel = {},
				returnLabel = {},
				_waterTarget = function()
					return Vector3.new(0, 1000, 0)
				end,
			}
			local sequence = Bite.new(owner, 100, 100, Random.new(1))
			local expected = legacy.PrimaryPart.Size * Vector3.new(table.unpack(settings.MouthOffset))
			assert((sequence.mouthOffset - expected).Magnitude < 0.00001, "Legacy mouth ratio ignored")
			sequence:Destroy()
			job.legacyMouthFallback = { passed = true }
		end, debug.traceback)
		cleanup()
		if not ok then
			job.error = err
		end
		job.done = true
	end)
	return "Started random, drip and legacy-mouth regression on temporary Client templates"
end
