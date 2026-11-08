-- 在 Studio Client 执行；使用预置 UI 和正式模块，以固定步长验证两轮演出并恢复现场。
local storage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Cast = require(storage.Modules.FishingCastSequence)
local Rig = require(storage.Modules.FishingRigUtil)
assert(not workspace:FindFirstChild("FishingRig"), "Finish the active fishing session before validation")
local gui = assert(playerGui:FindFirstChild("FishingSequenceGui"), "Preset did not clone from StarterGui")
assert(not gui.Enabled and #gui:GetDescendants() == 9, "Preset has an unexpected initial state")
local meterGui = playerGui.CastMeterGui
local holder = meterGui.Meter
local marker = holder.Bar.Marker
local meter = {
	gui = meterGui,
	holder = holder,
	marker = marker,
	label = marker.MultLabel,
	prompt = holder.Prompt,
	scale = holder.Prompt.UIScale,
	glow = marker.Glow,
}
local camera = workspace.CurrentCamera
local savedCamera = { frame = camera.CFrame, focus = camera.Focus, fov = camera.FieldOfView, mode = camera.CameraType }
local meterEnabled = meterGui.Enabled
local sequence, rig
local report = { rounds = {}, presetDescendants = #gui:GetDescendants() }
local function createRig()
	rig = Rig.Create(storage.Character.PoseDefaultCharacter, player.Character, storage.Models.FishRod.TestRod)
	rig.Parent = workspace
	return rig
end
local function create(animation)
	return Cast.new(createRig(), playerGui, meter, animation, storage.Models.FishBait["1"]["1"], {
		isSoundEnabled = function()
			return false
		end,
	})
end
local function assertRestored(originals)
	assert(
		gui.Parent == playerGui and not gui.Enabled and #gui:GetDescendants() == report.presetDescendants,
		"Preset was destroyed, duplicated or left enabled"
	)
	for _, original in ipairs(originals) do
		assert(
			original.instance[original.property] == original.value,
			original.instance:GetFullName() .. "." .. original.property .. " was not restored"
		)
	end
end
local ok, err = xpcall(function()
	-- 绑定 UI 后的构造失败，也必须保留预置实例并还原所有状态。
	local created = pcall(create, nil)
	assert(not created and gui.Parent == playerGui and not gui.Enabled, "Failed constructor leaked preset state")
	rig:Destroy()
	rig = nil
	report.failedConstructor = true
	for _, catchFish in ipairs({ true, false }) do
		sequence = create(storage.Animation.Fishing.CastRod)
		assert(sequence.gui == gui and gui.Enabled, "Sequence did not use the preset instance")
		local deadline = os.clock() + 8
		while sequence.track.Length <= 0 and os.clock() < deadline do
			task.wait()
		end
		assert(sequence.track.Length > 0, "Cast animation did not load")
		sequence:Cast(1)
		local started = sequence.castClickedAt
		local states = { catchFish = catchFish }
		for frame = 1, 60 * 30 do
			local now = started + frame / 60
			if sequence.bite then
				sequence.bite.timeline.nibbles = 0
			end
			sequence:Update(now, 1 / 60)
			states.flash = states.flash or sequence.flash.BackgroundTransparency < 1
			states.popup = states.popup or sequence.popup.Visible
			states.blackBars = states.blackBars or sequence.bars[1].Size.Y.Scale > 0
			states.distance = states.distance or sequence.distanceLabel.Visible
			if sequence.phase == "Bite" then
				assert(
					sequence.returnLabel.Visible and sequence.returnLabel.Text == "TAP TO HOOK!",
					"Hook prompt is missing"
				)
				states.hookPrompt = true
				if catchFish then
					assert(sequence:TryHook(now), "Hook did not succeed")
				end
			end
			if
				(catchFish and sequence.phase == "Caught" and sequence:CanReturn(now))
				or (not catchFish and sequence.phase == "Escaped")
			then
				assert(
					sequence.statusLabel.Visible
						and sequence.statusLabel.Text == (if catchFish then "CAUGHT!" else "THE FISH GOT AWAY!"),
					"Result prompt is missing"
				)
				if catchFish then
					assert(
						sequence.returnLabel.Visible and sequence.returnLabel.Text == "TAP TO RETURN",
						"Return prompt is missing"
					)
				end
				states.result = sequence.phase
				break
			end
			if frame % 30 == 0 then
				task.wait()
			end
		end
		assert(
			states.flash
				and states.popup
				and states.blackBars
				and states.distance
				and states.hookPrompt
				and states.result,
			"Fishing presentation did not complete"
		)
		local originals = sequence.originals
		sequence:Destroy()
		sequence:Destroy()
		assertRestored(originals)
		sequence = nil
		rig:Destroy()
		rig = nil
		table.insert(report.rounds, states)
	end
	local count = 0
	for _, child in ipairs(playerGui:GetChildren()) do
		if child.Name == "FishingSequenceGui" then
			count += 1
		end
	end
	assert(count == 1, "Duplicate sequence UI was created")
	report.guiCount = count
end, debug.traceback)
if sequence then
	sequence:Destroy()
end
if rig then
	rig:Destroy()
end
meterGui.Enabled = meterEnabled
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType =
	savedCamera.frame, savedCamera.focus, savedCamera.fov, savedCamera.mode
assert(ok, err)
return report
