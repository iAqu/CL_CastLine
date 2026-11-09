local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local AnimationSettings = Settings.Motion.Animation

local FishAnimationController = {}
FishAnimationController.__index = FishAnimationController
local State = {}
State.__index = State
local warned = {}

local function warnOnce(key, message)
	if not warned[key] then
		warned[key] = true
		warn("FishAnimationController: " .. message)
	end
end

local function smooth(alpha)
	alpha = math.clamp(alpha, 0, 1)
	return alpha * alpha * (3 - 2 * alpha)
end

function FishAnimationController.NewState(startedAt, random)
	return setmetatable({ startedAt = startedAt, random = random or Random.new() }, State)
end

-- 这里只选择固定动画、权重和播放时间；骨骼姿势由 Animator 的关键帧插值产生。
function State:Sample(phase, phaseStartedAt, now, mirror, swimWeight, nibbleSpeed)
	local elapsed = math.max(0, now - phaseStartedAt)
	local clips = AnimationSettings.Clips
	local name, token, position, speed, weight
	if phase == "Approaching" or phase == "Holding" or phase == "Nibbling" or phase == "Bite" or phase == "Escaped" then
		name, token, speed = "SwimLoop", "SwimLoop", 1
		position = math.max(0, now - self.startedAt) % clips.SwimLoop.Duration
		weight = AnimationSettings.HoldWeight
		if phase == "Approaching" then
			weight = smooth(elapsed / AnimationSettings.FadeTime)
				* (
					1
					- (1 - AnimationSettings.HoldWeight)
						* smooth(
							(elapsed - Settings.ApproachTime + AnimationSettings.FadeTime) / AnimationSettings.FadeTime
						)
				)
		elseif phase == "Nibbling" then
			elapsed *= nibbleSpeed or 1
			local retreatAt = Settings.Nibble.AttackTime + Settings.Nibble.ContactTime
			weight *= if elapsed < retreatAt
				then 1 - smooth(elapsed / Settings.Nibble.AttackTime)
				else smooth((elapsed - retreatAt) / (Settings.NibbleTime - retreatAt))
		elseif phase == "Bite" then
			weight *= 1 - smooth(elapsed / Settings.BiteSinkTime)
		elseif phase == "Escaped" then
			weight = smooth(elapsed / AnimationSettings.FadeTime)
		end
		if swimWeight ~= nil then
			weight = swimWeight
		end
	elseif phase == "Struggling" then
		if elapsed < Settings.StruggleTime then
			local cycle = Settings.Struggle.AnimationCycle
			name = if (mirror or 1) > 0 then "StruggleLeft" else "StruggleRight"
			-- 同一轨道连续循环，避免每个周期重播时淡入造成鱼身回直。
			token = phaseStartedAt
			speed = clips[name].Duration / cycle
			position, weight = (elapsed % cycle) * speed, 1
		end
	elseif phase == "Lifting" and elapsed < Settings.LiftTime then
		name, token = "LiftFlop", phaseStartedAt
		speed = clips.LiftFlop.Duration / Settings.LiftTime
		position, weight = elapsed * speed, 1
	elseif phase == "Caught" then
		if self.caughtAt ~= phaseStartedAt then
			self.caughtAt = phaseStartedAt
			-- 展示镜头落位时先甩尾一次，结束后再恢复随机间隔。
			self.nextBurst = phaseStartedAt
		end
		if now >= self.nextBurst + clips.ShowcaseFlop.Duration then
			-- 长帧跳过过期动作，不追赶或积压挣动次数。
			self.nextBurst = now + self.random:NextNumber(AnimationSettings.GapMin, AnimationSettings.GapMax)
		end
		if now >= self.nextBurst then
			name, token, speed = "ShowcaseFlop", self.nextBurst, 1
			position, weight = now - self.nextBurst, 1
		else
			name, token, speed = "SwimLoop", "ShowcaseIdle", AnimationSettings.ShowcaseIdleSpeed
			position = elapsed * speed % clips.SwimLoop.Duration
			weight = AnimationSettings.ShowcaseIdleWeight
		end
	end
	if not name or weight <= 0.00001 then
		return nil
	end
	return { name = name, token = token, position = position, speed = speed, weight = weight }
end

function FishAnimationController.new(fish, startedAt, random)
	local self = setmetatable(
		{ fish = fish, tracks = {}, state = FishAnimationController.NewState(startedAt, random) },
		FishAnimationController
	)
	local parent = fish.PrimaryPart
	for index, name in ipairs(AnimationSettings.Bones) do
		-- Keep the root directly under the mesh; expanded rigs can insert joints between anchors.
		local bone = parent and parent:FindFirstChild(name, index > 1)
		if not bone or not bone:IsA("Bone") then
			warnOnce("rig", "fish rig anchors are missing; keeping neutral pose")
			return self
		end
		parent = bone
	end
	local controller = fish:FindFirstChildOfClass("AnimationController")
	if not controller then
		controller = Instance.new("AnimationController")
		controller.Name, controller.Parent = "FishAnimationController", fish
		self.ownedController = controller
	end
	local animator = controller:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = controller
	end
	self.animator, self.loading = animator, true
	task.spawn(function()
		local ok, err = pcall(function()
			local localFolder = fish:FindFirstChild("Animations")
			local folder = ReplicatedStorage:FindFirstChild("Animation")
			folder = folder and folder:FindFirstChild("Fishing")
			folder = folder and folder:FindFirstChild("Fish")
			local assets = {}
			for name in pairs(AnimationSettings.Clips) do
				local asset = localFolder and localFolder:FindFirstChild(name)
				if not asset then
					asset = folder and folder:FindFirstChild(name)
				end
				assert(asset and asset:IsA("Animation") and asset.AnimationId ~= "", name .. " animation is missing")
				table.insert(assets, asset)
			end
			ContentProvider:PreloadAsync(assets)
			if self.destroyed then
				return
			end
			for _, asset in ipairs(assets) do
				local track = animator:LoadAnimation(asset)
				if self.destroyed then
					track:Stop(0)
					track:Destroy()
					return
				end
				track.Looped = AnimationSettings.Clips[asset.Name].Looped
				track.Priority = Enum.AnimationPriority.Action
				self.tracks[asset.Name] = track
			end
			local deadline = os.clock() + AnimationSettings.LoadTimeout
			while not self.destroyed do
				local ready = true
				for _, track in pairs(self.tracks) do
					if track.Length == 0 then
						ready = false
						break
					end
				end
				if ready then
					return
				end
				assert(os.clock() < deadline, "fish animations did not load before timeout")
				task.wait(0.05)
			end
		end)
		self.loading = false
		if not ok and not self.destroyed then
			self.failed = true
			for _, track in pairs(self.tracks) do
				track:Stop(0)
				track:Destroy()
			end
			self.tracks = {}
			warnOnce("load", tostring(err) .. "; keeping neutral pose")
		end
	end)
	return self
end

function FishAnimationController:_stop(fade)
	if self.active then
		self.active.track:Stop(fade)
		self.active = nil
	end
end

function FishAnimationController:Update(phase, phaseStartedAt, now, mirror, swimWeight, nibbleSpeed)
	if self.destroyed then
		return
	end
	local request = self.state:Sample(phase, phaseStartedAt, now, mirror, swimWeight, nibbleSpeed)
	if self.loading or self.failed then
		return request
	end
	local track = request and self.tracks[request.name]
	if not track or track.Length == 0 then
		self:_stop(AnimationSettings.FadeTime)
		return request
	end
	local active = self.active
	if not active or active.name ~= request.name or active.token ~= request.token or not track.IsPlaying then
		self:_stop(AnimationSettings.FadeTime)
		track:Play(AnimationSettings.FadeTime, request.weight, request.speed)
		track.TimePosition = math.min(request.position, track.Length - 0.0001)
		active = {
			track = track,
			name = request.name,
			token = request.token,
			weight = request.weight,
			speed = request.speed,
		}
		self.active = active
	else
		if math.abs(active.weight - request.weight) > 0.0001 then
			track:AdjustWeight(request.weight, 0)
			active.weight = request.weight
		end
		if math.abs(active.speed - request.speed) > 0.0001 then
			track:AdjustSpeed(request.speed)
			active.speed = request.speed
		end
		local drift = math.abs(track.TimePosition - request.position)
		if track.Looped then
			drift = math.min(drift, math.abs(track.Length - drift))
		end
		if drift > AnimationSettings.SyncTolerance then
			track.TimePosition = math.min(request.position, track.Length - 0.0001)
		end
	end
	return request
end

function FishAnimationController:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	for _, track in pairs(self.tracks) do
		track:Stop(0)
		track:Destroy()
	end
	self.tracks, self.active = {}, nil
	if self.ownedController then
		self.ownedController:Destroy()
	end
end

return FishAnimationController
