-- Edit-only repair for current templates and staged models. Keeps a full resource backup.
return function(baseUrl)
	assert(not game:GetService("RunService"):IsRunning(), "Repair fish resources in Edit mode")
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	baseUrl = baseUrl or "http://127.0.0.1:18773"
	local http = game:GetService("HttpService")
	local data = http:JSONDecode(http:GetAsync(baseUrl .. "/drip-surface-points.json"))
	local install = assert(loadstring(http:GetAsync(baseUrl .. "/install_drip_points.studio.lua")))()
	local folders = { game.ReplicatedStorage.Models.Fish, workspace.Fish_Processed }
	-- Preflight every target before changing any resources.
	for _, folder in ipairs(folders) do
		assert(#folder:GetChildren() == 28, "Expected 28 fish: " .. folder:GetFullName())
		for _, fish in ipairs(folder:GetChildren()) do
			local spec = assert(data.fish[fish.Name], "Missing authored drip data: " .. fish.Name)
			local body = assert(fish.PrimaryPart, "Fish PrimaryPart is missing")
			assert(#spec.points == 24, "Expected 24 surface points")
			if spec.primarySize then
				assert((body.Size - Vector3.new(table.unpack(spec.primarySize))).Magnitude < 0.01,
					"Authored fish geometry differs: " .. fish.Name)
			end
			for _, point in ipairs(spec.points) do
				local bone = body:FindFirstChild(point.bone, true)
				assert(bone and bone:IsA("Bone"), "Missing surface bone: " .. fish.Name .. "/" .. point.bone)
			end
		end
	end
	local history = game:GetService("ChangeHistoryService")
	history:SetWaypoint("Before all-fish drip points")
	local backups = game.ServerStorage:FindFirstChild("FishDripBackups")
	if not backups then
		backups = Instance.new("Folder")
		backups.Name, backups.Parent = "FishDripBackups", game.ServerStorage
	end
	local backup = Instance.new("Folder")
	backup.Name = "BeforeAllFishDrip_" .. os.date("!%Y%m%d_%H%M%S")
	backup.Parent = backups
	for index, folder in ipairs(folders) do
		local saved = Instance.new("Folder")
		saved.Name, saved.Parent = if index == 1 then "Templates" else "Processed", backup
		for _, fish in ipairs(folder:GetChildren()) do
			fish:Clone().Parent = saved
			task.wait()
		end
	end
	local result = { backup = backup:GetFullName(), changedPoints = 0, results = {} }
	for _, folder in ipairs(folders) do
		for _, fish in ipairs(folder:GetChildren()) do
			local record = install(fish, data.fish[fish.Name])
			record.path = fish:GetFullName()
			result.changedPoints += record.changed
			table.insert(result.results, record)
			task.wait()
		end
	end
	history:SetWaypoint("Install all-fish drip points")
	return result
end
