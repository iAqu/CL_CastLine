-- Edit/Server：两个资源目录都必须包含完整、唯一且绑定骨骼的滴水点。
local settings = require(game.ReplicatedStorage.Modules.FishingConfig).Bite.Drip
local result = { passed = true, folders = {}, failures = {} }
for _, folder in ipairs({ game.ReplicatedStorage.Models.Fish, workspace.Fish_Processed }) do
	local checked, failed = 0, 0
	for _, fish in ipairs(folder:GetChildren()) do
		if fish:IsA("Model") and fish.PrimaryPart then
			checked += 1
			local counts, valid = {}, 0
			for _, instance in ipairs(fish.PrimaryPart:GetDescendants()) do
				if string.sub(instance.Name, 1, 9) == "FishDrip_" then
					counts[instance.Name] = (counts[instance.Name] or 0) + 1
				end
			end
			for _, name in ipairs(settings.Points) do
				local point = fish.PrimaryPart:FindFirstChild("FishDrip_" .. name, true)
				if point and point:IsA("Attachment") and point.Parent:IsA("Bone") and counts[point.Name] == 1 then
					valid += 1
				end
			end
			if valid ~= #settings.Points then
				failed += 1
				table.insert(result.failures, { fish = fish:GetFullName(), valid = valid, expected = #settings.Points })
			end
		end
	end
	result.passed = result.passed and failed == 0 and checked == 28
	table.insert(result.folders, { path = folder:GetFullName(), checked = checked, failed = failed })
end
return result
