-- Studio Client：真实 MeshPart 变形、阶段打断、嘴部连接、鱼线和镜头包围范围。
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local Motion = require(storage.Modules.BaitElasticMotion)
local config = require(storage.Modules.FishingConfig)
local settings = config.Bite
local template = storage.Models.FishBait["1"]["1"]
local originalSize = template.Size
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "BaitElasticValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = template:Clone()
	bait.Anchored, bait.Parent = true, folder
	local function anchor()
		local part = Instance.new("Part")
		part.Anchored, part.Transparency, part.Parent = true, 1, folder
		local attachment = Instance.new("Attachment")
		attachment.Parent = part
		return part, attachment
	end
	local lineEnd, lineEndAttachment = anchor()
	local lineTop, lineTopAttachment = anchor()
	local rod, tip = anchor()
	local line = Instance.new("Beam")
	line.Attachment0, line.Attachment1, line.Parent = tip, lineEndAttachment, folder
	local highlight = Instance.new("Highlight")
	highlight.Adornee, highlight.Parent = bait, folder
	local target = Vector3.new(10, 1000, 30)
	rod.Position = target - Vector3.zAxis * 55
	local eye = target + Vector3.new(12, 18, -20)
	local wind = { Volume = 0, Stop = function() end }
	local owner = setmetatable({
		folder = folder,
		bait = bait,
		baitBaseSize = originalSize,
		baitVisualScale = Vector3.one,
		baitAppearance = { [bait] = 0 },
		baitHighlight = highlight,
		forward = Vector3.zAxis,
		launch = rod.Position,
		distance = 55,
		initialYaw = math.rad(37),
		spin = math.rad(37),
		lineEnd = lineEnd,
		lineEndAttachment = lineEndAttachment,
		lineTop = lineTop,
		lineTopAttachment = lineTopAttachment,
		line = line,
		tip = tip,
		wind = wind,
		landedAt = 0,
		cameraFrame = CFrame.lookAt(eye, target),
		cameraFov = 60,
		statusLabel = {},
		returnLabel = {},
		distanceLabel = {},
		impulses = {},
		trail = { Clear = function() end },
		_waterTarget = function()
			return target
		end,
		_sound = function(_, name)
			return if name == "WindLoop" then wind else nil
		end,
		_shot = function() end,
		_impulse = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_splash = function() end,
		_ripple = function() end,
		_castFeedback = function() end,
		_updateAction = function() end,
	}, Cast)
	local samples, maxContactError = 0, 0
	local function close(a, b, message)
		assert((a - b).Magnitude < 0.001, message .. ": " .. tostring((a - b).Magnitude))
	end
	local function sameRotation(a, b, message)
		close(a.LookVector, b.LookVector, message .. " heading")
		close(a.UpVector, b.UpVector, message .. " up")
	end
	local function round(at, count)
		owner:_startBiteRound(at)
		active = owner.bite
		local random = {
			NextInteger = function()
				return count or 0
			end,
			NextNumber = function(_, low, high)
				return if low == 1 and high == 3 then 2 else 1
			end,
		}
		active.timeline = Bite.NewTimeline(at, random)
		active:_prepareRepositions()
		close(bait.Size, originalSize, "New round retained deformation")
	end
	local function present(now)
		local previousSize, previousFrame = bait.Size, bait.CFrame
		active:Update(now, true)
		close(bait.Size, previousSize, "Logic update wrote visual scale")
		close(bait.Position, previousFrame.Position, "Logic update wrote visual position")
		active:Present(eye)
		owner:_updateLine()
		close(line.Attachment1.WorldPosition, active.linePosition or bait.Position, "Line detached")
		local size, position = bait.Size, bait.Position
		active:Present(eye)
		close(bait.Size, size, "Repeated presentation accumulated scale")
		close(bait.Position, position, "Repeated presentation accumulated offset")
		close(owner.baitBaseSize, originalSize, "Logic size changed")
		samples += 1
	end
	local function mouth()
		return active.fish.PrimaryPart.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
	end

	-- 假咬主弹和两次余弹都越过水面落点，连续六次不积累变形。
	for _, rate in ipairs({ 30, 60, 144 }) do
		round(0, 6)
		for index = 1, 6 do
			active.timeline.nibbleIndex, active.timeline.completedNibbles = index, index - 1
			local timing = active.timeline:GetNibbleTiming()
			local at = index * 10
			active.timeline:_enter("Nibbling", at, timing.duration)
			local above, below = false, false
			for frame = 0, math.ceil(timing.duration * rate) - 1 do
				local elapsed = math.min(timing.duration - 1e-5, frame / rate)
				present(at + elapsed)
				if elapsed > timing.reboundEnd then
					above = above or bait.Position.Y > target.Y + 0.001
					below = below or bait.Position.Y < target.Y - 0.001
				end
			end
			assert(above and below, "Nibble did not rebound across rest")
			present(at + timing.duration)
			close(bait.Size, originalSize, "Nibble did not restore scale")
		end
		task.wait()
	end

	-- 真咬回弹的任意时刻提竿都从当时的位置、朝向、尺寸衔接。
	for _, elapsed in ipairs({ 0, 0.04, 0.15, 0.2, 0.32, 0.499, 0.599 }) do
		round(0)
		active.timeline:_enter("Bite", 100, settings.HookWindow)
		present(100 + elapsed)
		local frame, size = bait.CFrame, bait.Size
		assert(bait.Position.Y <= target.Y + 0.001, "True bite rose out of water")
		assert(active:TryHook(100 + elapsed), "Hook window changed")
		present(100 + elapsed)
		close(bait.Position, frame.Position, "Hook snapped position")
		close(bait.Size, size, "Hook snapped scale")
		close(bait.CFrame.LookVector, frame.LookVector, "Hook snapped orientation")
		for sample = 0, 90 do
			local time = settings.StruggleTime * sample / 90
			present(100 + elapsed + time)
			if time < settings.StruggleTime then
				local blend = math.clamp(time / settings.Struggle.BlendTime, 0, 1)
				blend = blend * blend * (3 - 2 * blend)
				local contact = active.hookContact:Lerp(Vector3.new(0.5, 0, 0), blend)
				local edge = bait.CFrame:PointToWorldSpace(contact * bait.Size)
				local error = (edge - mouth()).Magnitude
				maxContactError = math.max(maxContactError, error)
				assert(error < 0.001, "Squash/stretch detached fish mouth")
			end
		end
		task.wait()
	end

	-- 水面、假咬回弹、脱钩恢复中途收竿；竖屏/横屏镜头均包住变形后的鱼饵。
	for _, phase in ipairs({ "Waiting", "Holding", "Nibbling", "Escaped" }) do
		round(0, 1)
		active.timeline.nibbleIndex = 1
		local now = os.clock()
		active.timeline:_enter(phase, now - 0.32, if phase == "Nibbling" then active.timeline:GetNibbleTiming().duration else 1)
		present(now)
		local frame, size = bait.CFrame, bait.Size
		assert(not owner:TryHook(now) and active.timeline.phase == "Reeling", "Early input did not reel")
		present(now)
		close(bait.Position, frame.Position, "Reel snapped position")
		close(bait.Size, size, "Reel snapped scale")
		while active.timeline.phase == "Reeling" and os.clock() - now < 5 do
			task.wait()
			present(os.clock())
			for _, viewport in ipairs({ Vector2.new(1920, 1080), Vector2.new(390, 844) }) do
				local view = owner:_reelCamera(target, viewport)
				local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
				for _, x in ipairs({ -0.5, 0.5 }) do
					for _, y in ipairs({ -0.5, 0.5 }) do
						for _, z in ipairs({ -0.5, 0.5 }) do
							local point =
								view:PointToObjectSpace(bait.CFrame:PointToWorldSpace(bait.Size * Vector3.new(x, y, z)))
							assert(point.Z < 0 and math.abs(point.Y / point.Z) < tangent, "Vertical clipping")
							assert(
								math.abs(point.X / point.Z) < tangent * viewport.X / viewport.Y,
								"Horizontal clipping"
							)
						end
					end
				end
			end
		end
		assert(active.timeline.phase == "Reeled", "Reel spring did not settle")
		close(bait.Size, originalSize, "Reeled showcase retained stretch")
		task.wait()
	end

	-- 不同初始朝向贯穿持饵、出手、飞行和补饵；相同力度落点保持一致。
	local previousLanding
	for _, degrees in ipairs({ 0, 37, 180, 359 }) do
		owner.bite = nil
		active:Destroy()
		active = nil
		owner.initialYaw = math.rad(degrees)
		owner.spin = owner.initialYaw
		owner.castClickedAt = nil
		owner.phase, owner.meterStarted = "Preparing", os.clock()
		owner:_updateBait(owner.meterStarted + 0.2, 1 / 60)
		local initial = bait.CFrame
		sameRotation(initial, CFrame.Angles(0, owner.initialYaw, 0), "Held yaw was lost")
		owner:Cast(0)
		owner:_updateBait(owner.castClickedAt, 1 / 60)
		close(bait.Position, initial.Position, "Cast entry snapped")
		sameRotation(bait.CFrame, initial, "Cast entry snapped rotation")
		owner:_updateBait(owner.castClickedAt + 1, 1 / 60)
		owner:_release(100)
		local release = bait.CFrame
		owner:_updateBait(100, 1 / 60)
		close(bait.Position, release.Position, "Release snapped")
		sameRotation(bait.CFrame, release, "Release snapped rotation")
		local elapsed = owner.flightDuration * 0.5
		owner:_updateBait(100 + elapsed, 1 / 60)
		assert(bait.Size.Y > originalSize.Y, "Flight did not stretch")
		local flightRotation = CFrame.Angles(0, owner.initialYaw, 0)
			* CFrame.Angles(elapsed * 7 * 0.7, elapsed * 7, elapsed * 7 * 0.3)
		sameRotation(bait.CFrame, flightRotation, "Initial yaw changed flight tumble")
		local waterBefore = Cast._waterTarget(owner)
		Motion.Apply(owner, bait.CFrame, Motion.Scale(0.65))
		close(Cast._waterTarget(owner), waterBefore, "Deformation changed water target")
		owner:_updateBait(100 + owner.flightDuration + 1e-5, 1 / 60)
		active = owner.bite
		local landingRotation = CFrame.Angles(0, owner.initialYaw + owner.flightDuration * 7, 0)
		close(bait.Position, target, "Flight endpoint changed")
		sameRotation(bait.CFrame, landingRotation, "Landing lost initial yaw")
		sameRotation(active.baitRotation, landingRotation, "Bite round lost landing yaw")
		if previousLanding then
			assert((bait.CFrame.LookVector - previousLanding.LookVector).Magnitude > 0.001, "Casts kept the same yaw")
		end
		previousLanding = bait.CFrame
		local roundBefore = owner.round
		owner:_updateBait(1000, 1 / 30)
		active = owner.bite
		active:Present(eye)
		assert(owner.round == roundBefore + 1 and active.timeline.phase == "Waiting", "Long frame did not restart one round")
		sameRotation(bait.CFrame, landingRotation, "Retry rerolled landing yaw")
		close(bait.Size, originalSize, "Retry retained deformation")
		assert(owner.initialYaw == math.rad(degrees), "Frame updates changed initial yaw")
		task.wait()
	end
	close(template.Size, originalSize, "Template was modified")
	return { passed = true, samples = samples, maxContactError = maxContactError }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
