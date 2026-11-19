if not game:GetService("RunService"):IsStudio() then
	return
end
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
RunService:BindToRenderStep("TrainingVerificationCamera", Enum.RenderPriority.Camera.Value + 1, function()
	if workspace:GetAttribute("TrainingVerificationCamera") == true then
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			workspace.CurrentCamera.CFrame = CFrame.lookAt(
				root.Position - root.CFrame.LookVector * 10 + Vector3.new(0, 4, 0),
				root.Position + Vector3.new(0, 1, 0)
			)
		end
	end
end)
local Bite = require(RS.Modules.FishingBiteSequence)
local Stats = require(RS.Modules.ItemStatUtil)
local Progress = require(RS.Modules.TrainingProgress)
local Fishes = require(game.ReplicatedFirst.Data.FishesData)
local folder = Instance.new("Folder")
local sequence
local ok, err = xpcall(function()
	local fish = Fishes.Fish_101
	local template = RS.Models.Fish:FindFirstChild(fish.Model)
	local weight = Progress.CalculateFishWeight(fish.DefaultWeight, 10)
	local owner = { folder = folder, baitBaseSize = Vector3.new(1, 1, 1), forward = Vector3.zAxis, spin = 0 }
	sequence = Bite.new(owner, 0, 0, Random.new(1), Random.new(2), template, fish, "Fish", false, weight)
	local expected = Stats.GetScaleRatio(fish, weight, template)
	assert(
		math.abs(sequence.fish:GetScale() / template:GetScale() - expected) < 1e-5,
		"Shadow must start at final scale"
	)
	for _, phase in ipairs({ "Waiting", "Approaching", "Nibbling", "Bite", "Struggling", "Lifting", "Caught" }) do
		assert(sequence:_scaleAt(phase, 0.4) == expected, "No growth animation in " .. phase)
	end
	player:SetAttribute(
		"TrainingVisualVerification",
		Http:JSONEncode({ ok = true, weight = weight, scale = expected, phases = 7 })
	)
end, debug.traceback)
if sequence then
	sequence:Destroy()
end
folder:Destroy()
if not ok then
	player:SetAttribute("TrainingVisualVerification", Http:JSONEncode({ ok = false, error = tostring(err) }))
end
