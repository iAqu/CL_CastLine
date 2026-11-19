-- Temporary Studio-only presentation probe. Copy through Rojo, then remove the entry after Stop.
if not game:GetService("RunService"):IsStudio() then
	return
end
local RS, Players, Run = game:GetService("ReplicatedStorage"), game:GetService("Players"), game:GetService("RunService")
local Http = game:GetService("HttpService")
local Config = require(RS.Modules.FishingConfig)
local Presentation = require(RS.Modules.FishingCastPresentation)
local Cast = require(RS.Modules.FishingCastSequence)
local RigUtil = require(RS.Modules.FishingRigUtil)
local Audio = require(RS.Modules.FishingAudio)
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local control = Instance.new("Folder")
control.Name, control.Parent = "GodlikePreviewControl", workspace
control:SetAttribute("Progress", 0.97)
control:SetAttribute("Seek", -1)
local owner, rig, guis, saved, stats
local function cleanup()
	Run:UnbindFromRenderStep("GodlikePreview")
	if owner then
		owner:Destroy()
		owner = nil
	end
	if rig then
		rig:Destroy()
		rig = nil
	end
	for _, gui in pairs(guis or {}) do
		gui:Destroy()
	end
	guis = {}
	if saved then
		local camera = workspace.CurrentCamera
		camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType, camera.CameraSubject =
			saved.frame, saved.focus, saved.fov, saved.mode, saved.subject
		saved = nil
	end
end
local function projection(frame, fov, viewport, point)
	local p = frame:PointToObjectSpace(point)
	local half = math.tan(math.rad(fov * 0.5))
	return Vector2.new(0.5 + p.X / (-p.Z * half * viewport.X / viewport.Y) * 0.5, 0.5 - p.Y / (-p.Z * half) * 0.5), -p.Z
end
local function start()
	cleanup()
	local ok, err = xpcall(function()
		local camera = workspace.CurrentCamera
		saved = {
			frame = camera.CFrame,
			focus = camera.Focus,
			fov = camera.FieldOfView,
			mode = camera.CameraType,
			subject = camera.CameraSubject,
		}
		guis = {}
		for _, name in { "FishingSequenceGui", "FishingVignetteGui", "CastMeterGui" } do
			local gui = game.StarterGui[name]:Clone()
			gui.Name = "GodlikePreview_" .. name
			gui.DisplayOrder = 20000
			gui.Parent = pg
			guis[name] = gui
		end
		local proxy = {
			FindFirstChild = function(_, name)
				return guis[name]
			end,
			GetFullName = function()
				return "GodlikePreviewGui"
			end,
		}
		local spot
		for _, part in workspace:GetDescendants() do
			if part.Name == "FishingStartPart" and part:IsA("BasePart") then
				spot = part
				break
			end
		end
		assert(spot, "Fishing stage missing")
		local source = RS.Character.PoseDefaultCharacter
		rig = RigUtil.Create(source, player.Character or source, RS.Models.FishRod.TestRod)
		local root, humanoid = rig.PrimaryPart, rig:FindFirstChildOfClass("Humanoid")
		local ground = spot.Position + Vector3.yAxis * spot.Size.Y * 0.5
		rig:PivotTo(CFrame.new(ground + Vector3.yAxis * (humanoid.HipHeight + root.Size.Y * 0.5)))
		rig.Parent = workspace
		local mg = guis.CastMeterGui
		local holder = mg.Meter
		local meter = {
			gui = mg,
			holder = holder,
			bar = holder.Bar,
			marker = holder.Bar.Marker,
			label = holder.Bar.Marker.MultLabel,
			prompt = holder.Prompt,
		}
		owner = Cast.new(rig, proxy, meter, RS.Animation.Fishing.CastRod, RS.Models.FishBait.DefaultBait, {
			fixedCast = true,
			initialLuck = 10,
			initialYaw = 0,
			specialCastAnimation = RS.Animation.Fishing.SpecialCastRod,
			audio = Audio.new(function()
				return true
			end),
			launchPosition = spot.Position,
		})
		local deadline = os.clock() + 10
		repeat
			task.wait()
		until (owner.castTracks.Normal.Length > 0 and owner.castTracks.Godlike.Length > 0) or os.clock() > deadline
		local progress = control:GetAttribute("Progress") or 0.97
		owner.meterProgress = progress
		owner:LockCastMeter()
		owner:Cast(progress, Config.FixedCastDistance, 10, Config.GetCastRating(progress).Id)
		stats = {
			rating = Config.GetCastRating(progress).Id,
			frames = 0,
			desktopClipped = 0,
			narrowClipped = 0,
			maxBodyOffset = 0,
			minTipHeight = 100,
			minFootHeight = 100,
			sounds = {},
			events = {},
			length = owner.track.Length,
		}
		local effect = owner.characterVFX
		local baseCreate = effect._create
		stats.burstColors = {}
		stats.burstStars = 0
		stats.groundDrift = 0
		stats.windOffset = 0
		effect._create = function(self, name, now, ground, continuous, options)
			local created = baseCreate(self, name, now, ground, continuous, options)
			if created and name == "EffectPart_Rainbow" and not continuous and options.color then
				local color = options.color.Keypoints[1].Value
				stats.burstColors[tostring(color)] = true
				for _, emission in created.emissions do
					if emission.emitter.Name == "Stars" then
						stats.burstStars += emission.count
					end
				end
			end
			return created
		end
		local basePlay = owner.fishAudio.Play
		owner.fishAudio.Play = function(self, name, ...)
			stats.sounds[name] = (stats.sounds[name] or 0) + 1
			stats.events[name] = owner.actionStarted and os.clock() - owner.actionStarted or -1
			return basePlay(self, name, ...)
		end
		Run:BindToRenderStep("GodlikePreview", Enum.RenderPriority.Camera.Value + 100, function(dt)
			local success, failure = xpcall(function()
				if not owner then
					return
				end
				local now = os.clock()
				local seek = control:GetAttribute("Seek")
				if seek and seek >= 0 and owner.actionStarted then
					owner.track:AdjustSpeed(0)
					owner.track.TimePosition = math.min(seek, owner.track.Length - 0.001)
					now = owner.actionStarted + seek
				end
				owner:Update(now, dt)
				if owner.actionStarted then
					local elapsed = now - owner.actionStarted
					control:SetAttribute("Elapsed", elapsed)
					local torso = rig.UpperTorso
					for _, fx in owner.characterVFX.effects do
						if fx.fixedFrame then
							stats.groundDrift = math.max(
								stats.groundDrift,
								(fx.model:GetPivot().Position - fx.fixedFrame.Position).Magnitude
							)
						end
					end
					if owner.characterVFX.wind then
						stats.windOffset = math.max(
							stats.windOffset,
							(owner.characterVFX.wind.model:GetPivot().Position - torso.Position).Magnitude
						)
					end
					stats.maxBodyOffset = math.max(stats.maxBodyOffset, (torso.Position - root.Position).Magnitude)
					stats.minTipHeight = math.min(stats.minTipHeight, owner.tip.WorldPosition.Y - ground.Y)
					stats.minFootHeight = math.min(
						stats.minFootHeight,
						rig.LeftFoot.Position.Y - rig.LeftFoot.Size.Y * 0.5 - ground.Y,
						rig.RightFoot.Position.Y - rig.RightFoot.Size.Y * 0.5 - ground.Y
					)
					if owner.phase == "Casting" and owner.castProfile.Id == "Godlike" then
						stats.frames += 1
						for _, size in { camera.ViewportSize, Vector2.new(390, 844) } do
							local frame, fov = Presentation.Camera(owner, elapsed, size)
							local clipped = false
							for _, point in
								{
									rig.Head.Position,
									rig.LeftHand.Position,
									rig.RightHand.Position,
									rig.LeftFoot.Position,
									rig.RightFoot.Position,
									owner.tip.WorldPosition,
								}
							do
								local p, z = projection(frame, fov, size, point)
								if z <= 0 or p.X < 0.03 or p.X > 0.97 or p.Y < 0.12 or p.Y > 0.88 then
									clipped = true
								end
							end
							if clipped then
								local key = if size == camera.ViewportSize then "desktopClipped" else "narrowClipped"
								stats[key] += 1
							end
						end
					end
					if owner.flightStarted then
						stats.releaseAt = owner.flightStarted - owner.actionStarted
					end
					local pauseAt = control:GetAttribute("PauseAt")
					if pauseAt and elapsed >= pauseAt and (not seek or seek < 0) then
						control:SetAttribute("Seek", pauseAt)
					end
					if elapsed >= 3.1 and (not seek or seek < 0) then
						stats.finalTrackTime = owner.track.TimePosition
						stats.trackPlaying = owner.track.IsPlaying
						control:SetAttribute("Report", Http:JSONEncode(stats))
						cleanup()
					end
				end
			end, debug.traceback)
			if not success then
				control:SetAttribute("Error", failure)
				cleanup()
			end
		end)
	end, debug.traceback)
	if not ok then
		control:SetAttribute("Error", err)
		cleanup()
	end
end
control:GetAttributeChangedSignal("Run"):Connect(start)
control:GetAttributeChangedSignal("Stop"):Connect(function()
	if stats then
		control:SetAttribute("Report", Http:JSONEncode(stats))
	end
	cleanup()
	control:SetAttribute("Clean", workspace:FindFirstChild("FishingSequence") == nil)
end)
control:SetAttribute("Ready", true)
