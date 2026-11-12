-- Run in a fresh Play Client after installation.
local rs = game:GetService("ReplicatedStorage")
local modules = rs.Modules
local assets = require(modules.FishingAssets)
local bite = require(modules.FishingBiteSequence)
local player = game:GetService("Players").LocalPlayer
local template = assert(assets.GetFish("Axolotl"), "Axolotl template missing")
local expectedMesh, expectedSwim = template.PrimaryPart.MeshId, template.Animations.SwimLoop.AnimationId
assert(template:GetAttribute("LogicalBoneCount") == 20, "FishingAssets resolved old Axolotl")
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "_AxolotlFishingQA", workspace
local sequence, plot
local ok, result = xpcall(function()
	local bait = rs.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local origin = Vector3.new(0, 1000, 0)
	local owner = {
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		spin = 0,
		statusLabel = {},
		returnLabel = {},
		_waterTarget = function()
			return origin
		end,
		_presentBait = function() end,
		_setPhase = function() end,
	}
	local start = os.clock()
	sequence = bite.new(owner, start, start, Random.new(11), Random.new(12), template)
	local animation = sequence.animation
	local deadline = os.clock() + 12
	while animation.loading and os.clock() < deadline do
		task.wait()
	end
	assert(not animation.loading and not animation.failed, "Fishing did not load the new asset")
	start = os.clock()
	sequence.timeline:_enter("Holding", start, 5)
	local observedWeight
	repeat
		sequence:Update(os.clock())
		task.wait()
		local active = animation.active
		if active and active.name == "SwimLoop" and active.track.IsPlaying then
			observedWeight = active.track.WeightCurrent
		end
	until os.clock() - start > 0.45
	local swim = animation.tracks.SwimLoop
	assert(
		sequence.fish.PrimaryPart.MeshId == expectedMesh and swim.Animation.AnimationId == expectedSwim,
		"Old fishing asset"
	)
	assert(observedWeight and math.abs(observedWeight - 0.4) < 0.02, "Fishing swim weight changed")
	sequence:Destroy()
	sequence = nil

	-- A client-only placement exercises the real PlotFishController without writing player data.
	local data = require(modules.FishInventoryData)
	local itemId, item
	for id, fish in data do
		if fish.Model == "Axolotl" then
			itemId, item = id, fish
			break
		end
	end
	assert(item, "Axolotl item missing")
	local character = player.Character or player.CharacterAdded:Wait()
	local root = assert(character:WaitForChild("HumanoidRootPart", 10), "Character did not spawn")
	local plots = workspace:WaitForChild("Areas"):WaitForChild("Plot")
	plot = Instance.new("Model")
	plot.Name = "_AxolotlPondQA"
	plot:SetAttribute("OwnerUserId", player.UserId)
	local boundary = Instance.new("Part")
	boundary.Name, boundary.Size = "3", Vector3.new(36, 1, 36)
	boundary.Anchored, boundary.CanCollide, boundary.Transparency = true, false, 1
	boundary.CFrame = root.CFrame * CFrame.new(0, 15, -18)
	boundary.Parent = plot
	local placed = Instance.new("Folder")
	placed.Name, placed.Parent = "PlacedFish", plot
	placed:SetAttribute("OwnerUserId", player.UserId)
	plot.Parent = plots
	local config = Instance.new("Configuration")
	config.Name = "AxolotlSwimQA"
	config:SetAttribute("ItemId", itemId)
	config:SetAttribute("Weight", item.DefaultWeight)
	config:SetAttribute("Slot", 1)
	config:SetAttribute("Entry", Vector3.zero)
	config:SetAttribute("StartedAt", workspace:GetServerTimeNow())
	config.Parent = placed
	local display =
		assert(plot:WaitForChild("PlotFish_AxolotlSwimQA", 12), "PlotFishController did not create the display")
	assert(
		display:GetAttribute("LogicalBoneCount") == 20 and display.PrimaryPart.MeshId == expectedMesh,
		"Pond used the old rig"
	)
	local track
	deadline = os.clock() + 12
	repeat
		local controller = display:FindFirstChildOfClass("AnimationController")
		local animator = controller and controller:FindFirstChildOfClass("Animator")
		for _, candidate in (animator and animator:GetPlayingAnimationTracks() or {}) do
			if candidate.Animation.AnimationId == expectedSwim and candidate.WeightCurrent > 0.98 then
				track = candidate
				break
			end
		end
		task.wait()
	until track or os.clock() >= deadline
	assert(track, "Pond did not play the new SwimLoop at full weight")
	local pondWeight = track.WeightCurrent
	local leg = display.PrimaryPart:FindFirstChild("FrontLeftLeg", true)
	local a = leg.Transform
	task.wait(0.22)
	assert(not a:FuzzyEq(leg.Transform, 0.001), "Pond front leg remained static")
	config:Destroy()
	task.wait()
	assert(not display.Parent, "Pond display survived removal")
	return {
		passed = true,
		mesh = expectedMesh,
		swim = expectedSwim,
		fishingWeight = observedWeight,
		pondWeight = pondWeight,
	}
end, debug.traceback)
if sequence then
	sequence:Destroy()
end
if plot then
	plot:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
