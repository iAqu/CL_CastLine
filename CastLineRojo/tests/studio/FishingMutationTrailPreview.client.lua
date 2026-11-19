-- Studio-only isolated fish presentation. Temporarily copy through Rojo, then remove after Stop.
if not game:GetService("RunService"):IsStudio() then
	return
end
local RS, Run, Workspace =
	game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("Workspace")
local Http = game:GetService("HttpService")
local Cast = require(RS.Modules.FishingCastSequence)
local Bite = require(RS.Modules.FishingBiteSequence)
local Config = require(RS.Modules.FishingConfig)
local Water = require(RS.Modules.WaterSurfaceUtil)
local Audio = require(RS.Modules.FishingAudio)
local control = Instance.new("Folder")
control.Name, control.Parent = "FishingMutationTrailControl", Workspace
control:SetAttribute("Mutation", "Rainbow")
control:SetAttribute("Model", "GreenSeahorse")
control:SetAttribute("Weight", 1)
local owner, active, folder, saved, stats
local function report()
	if stats then
		control:SetAttribute("Report", Http:JSONEncode(stats))
	end
end
local function cleanup()
	Run:UnbindFromRenderStep("FishingMutationTrailPreview")
	if active then
		active:Destroy()
		active = nil
	end
	if owner then
		if owner.fishAudio then
			owner.fishAudio:Destroy(false)
		end
		for sound in pairs(owner.sounds or {}) do
			sound:Destroy()
		end
		owner = nil
	end
	if folder then
		folder:Destroy()
		folder = nil
	end
	if saved then
		local camera = Workspace.CurrentCamera
		camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType, camera.CameraSubject =
			saved.frame, saved.focus, saved.fov, saved.mode, saved.subject
		saved = nil
	end
	control:SetAttribute("Clean", Workspace:FindFirstChild("FishingMutationTrailStage") == nil)
end
local function start()
	cleanup()
	control:SetAttribute("Error", nil)
	local ok, err = xpcall(function()
		local camera = Workspace.CurrentCamera
		saved = {
			frame = camera.CFrame,
			focus = camera.Focus,
			fov = camera.FieldOfView,
			mode = camera.CameraType,
			subject = camera.CameraSubject,
		}
		local top = Workspace.Areas.Water.Top
		local target = Vector3.new(top.Position.X, assert(Water.GetWaterSurfaceY()), top.Position.Z)
		local incoming = CFrame.lookAt(target + Vector3.new(0, 12, -18), target)
		folder = Instance.new("Folder")
		folder.Name, folder.Parent = "FishingMutationTrailStage", Workspace
		local bait = Instance.new("Part")
		bait.Transparency, bait.Anchored, bait.Parent = 1, true, folder
		owner = setmetatable({
			options = {},
			folder = folder,
			bait = bait,
			baitBaseSize = Vector3.one,
			forward = Vector3.zAxis,
			continueLabel = {},
			sounds = {},
			impulses = {},
			root = { CFrame = CFrame.identity },
			cameraFrame = incoming,
			cameraFocus = target,
			cameraFov = 60,
			biteFocus = target,
			shotFrom = incoming,
			shotMode = "Landing",
			shotStarted = 0,
			shotDuration = 0,
			fovFrom = 60,
			_waterTarget = function()
				return target
			end,
			_presentBait = function() end,
			_waterFeedback = function() end,
			_playWaterVFX = function() end,
			_sound = function() end,
		}, Cast)
		owner.fishAudio = Audio.new(function()
			return false
		end)
		local template = assert(RS.Models.Fish:FindFirstChild(control:GetAttribute("Model")), "Fish fixture missing")
		local egg = control:GetAttribute("Egg") == true
		active = Bite.new(
			owner,
			0,
			0,
			Random.new(51),
			Random.new(52),
			template,
			{ DefaultWeight = 1, ModelDefaultScale = 1, Rarity = "Common", DisplayName = template.Name },
			if egg then "Egg" else nil
		)
		owner.bite = active
		active:SetCaughtWeight(control:GetAttribute("Weight") or 1)
		local mutation = control:GetAttribute("Mutation")
		active.mutationId = if mutation == "None" then nil else mutation
		local timing = active:GetLiftTiming()
		local deadline = os.clock() + 10
		while active.animation.loading and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(not active.animation.failed and not active.animation.loading, "Fish animation did not load")
		local started = os.clock()
		active.timeline:_enter("Lifting", started, timing.duration)
		stats = {
			model = template.Name,
			mutation = mutation,
			egg = egg,
			weight = control:GetAttribute("Weight"),
			frames = 0,
			creations = 0,
			colors = {},
			bands = 0,
			emittedAfterApex = false,
			ordinary = false,
			stopped = false,
			expired = false,
			minWidth = 999,
			maxWidth = 0,
			narrowClipped = 0,
			desktopClipped = 0,
		}
		local recorded = false
		Run:BindToRenderStep("FishingMutationTrailPreview", Enum.RenderPriority.Camera.Value + 100, function(dt)
			local success, failure = xpcall(function()
				if not active then
					return
				end
				local elapsed = os.clock() - started
				local stopAt = control:GetAttribute("FreezeAt")
				if stopAt then
					elapsed = math.min(elapsed, stopAt)
				end
				local now = started + elapsed
				control:SetAttribute("Elapsed", elapsed)
				active:Update(now, true)
				owner:_updateCamera(now, dt)
				active:Present(camera.CFrame.Position)
				stats.frames += 1
				stats.ordinary = stats.ordinary or active.fishTrail ~= nil
				local effect = active.mutationTrail
				if effect then
					local ribbon = effect.ribbon
					if not recorded then
						recorded = true
						stats.creations += 1
						stats.bands = #ribbon.bands
						stats.width = ribbon.settings.Width
						stats.lifetime = ribbon.settings.Lifetime
						stats.maxLength = ribbon.settings.MaxLength
						for _, band in ribbon.bands do
							if not band.edge then
								local color = band.trail.Color.Keypoints[1].Value
								table.insert(stats.colors, { color.R, color.G, color.B })
							end
						end
					end
					stats.minWidth = math.min(stats.minWidth, ribbon.settings.Width)
					stats.maxWidth = math.max(stats.maxWidth, ribbon.settings.Width)
					if elapsed >= timing.riseEnd then
						stats.emittedAfterApex = stats.emittedAfterApex or ribbon.enabled
						stats.stopped = stats.stopped or not ribbon.enabled
					end
				elseif recorded then
					stats.expired = true
				end
				-- Use the protected production fish shot to check both screen shapes.
				for _, size in { camera.ViewportSize, Vector2.new(390, 844) } do
					local frame = owner:_fishLiftCamera(now, target, size)
					local radius = (
						active.timeline.phase == "Caught" and active:GetShowcaseRadius()
						or active.presentationRadius * active.scale
					) + Config.Bite.ShowcasePadding
					frame = Cast._protectShowcase(owner, frame, active.showcasePosition, radius, size, 60, 1)
					local p = frame:PointToObjectSpace(active.showcasePosition)
					local vertical = math.rad(30)
					local horizontal = math.atan(math.tan(vertical) * size.X / size.Y)
					if
						-p.Z * math.sin(vertical) - math.abs(p.Y) * math.cos(vertical) < radius - 0.01
						or -p.Z * math.sin(horizontal) - math.abs(p.X) * math.cos(horizontal) < radius - 0.01
					then
						local key = if size == camera.ViewportSize then "desktopClipped" else "narrowClipped"
						stats[key] += 1
					end
				end
				if elapsed >= timing.duration + 1 then
					report()
					cleanup()
				end
			end, debug.traceback)
			if not success then
				control:SetAttribute("Error", failure)
				report()
				cleanup()
			end
		end)
	end, debug.traceback)
	if not ok then
		control:SetAttribute("Error", err)
		report()
		cleanup()
	end
end
control:GetAttributeChangedSignal("Run"):Connect(start)
control:GetAttributeChangedSignal("Stop"):Connect(function()
	report()
	cleanup()
end)
control:SetAttribute("Ready", true)
