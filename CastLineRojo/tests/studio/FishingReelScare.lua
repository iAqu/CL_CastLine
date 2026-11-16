-- Studio Client：使用真实鱼模型，精确控制出水边界，验证收竿吓走表现与计时。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local Config = require(storage.Modules.FishingConfig)
local Water = require(storage.Modules.WaterSurfaceUtil)
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingReelScareValidation", workspace
local active

local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.CanCollide, bait.Parent = true, false, folder
	local baseSize = bait.Size
	local top = assert(Water.GetWaterTop())
	local target = Vector3.new(top.Position.X, Water.GetWaterSurfaceY(), top.Position.Z)
	local owner = {
		folder = folder,
		bait = bait,
		baitBaseSize = baseSize,
		forward = Vector3.zAxis,
		continueLabel = {},
		lineEnd = {},
		lineTop = {},
		line = {},
		lineTopAttachment = {},
		tip = {},
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_shot = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_sound = function() end,
		_impulse = function() end,
		_setPhase = function(self, phase)
			self.phase = phase
		end,
	}
	local cases = {
		{ phase = "Waiting", elapsed = 0.3, visible = false },
		{ phase = "Approaching", elapsed = 0, visible = false },
		{ phase = "Approaching", elapsed = 0.3, visible = true },
		{ phase = "Holding", elapsed = 0.3, visible = true },
		{ phase = "Nibbling", elapsed = 0.1, visible = true },
		{ phase = "Escaped", elapsed = 0.3, visible = true },
		{ phase = "Escaped", elapsed = Config.Bite.EscapeTime + 0.01, visible = false },
	}
	local visibleCases = 0
	for index, case in ipairs(cases) do
		owner.baitVisualScale, bait.Size = Vector3.one, baseSize
		active = Bite.new(owner, 10, 10, Random.new(index), Random.new(index + 100))
		owner.bite = active
		active.timeline.nibbleIndex = 1
		if case.phase == "Escaped" then
			active.timeline:_enter("Holding", 9, math.huge)
			active:Update(9.1)
		end
		active.timeline:_enter(case.phase, 10, math.huge)
		local now = 10 + case.elapsed
		active:Update(now)
		local body = active.fish.PrimaryPart
		local initialFrame, initialTransparency = body.CFrame, body.Transparency
		assert((initialTransparency < 1) == case.visible, "Invalid visibility fixture: " .. case.phase)
		assert(not active:TryHook(now) and active.timeline.phase == "Reeling", "Early input did not reel")
		local motion, proxy = active.reelMotion, active.reelMotion.proxy
		-- 位移弹簧另有真实逐帧测试；此处固定采样点以锁定出水判定。
		motion.Update = function(self)
			return self.position, self.settled
		end
		local function update(at)
			active:Update(at)
			Cast._updateLine(owner)
			assert((owner.lineEnd.Position - bait.Position).Magnitude < 0.001, "Line left bait center")
		end
		update(now)
		if case.visible then
			assert((body.Position - initialFrame.Position).Magnitude < 0.001, "Reel entry snapped visible fish position: " .. case.phase)
		end
		assert(math.abs(body.Transparency - initialTransparency) < 0.001, "Reel entry changed fish visibility")
		assert(not owner.continueLabel.Visible, "Reeling showed a manual return prompt")
		if case.visible then
			visibleCases += 1
			local captured = assert(active.reelFish, "Visible fish was not captured")
			motion.lifting, motion.position = false, Vector3.yAxis * -baseSize.Y
			update(now + 0.1)
			assert(not captured.startedAt and body.Transparency < 1, "Fish fled before the lift")
			motion.lifting = true
			motion.position = -Vector3.yAxis * 0.05
			update(now + 0.2)
			assert(not captured.startedAt, "Fish fled below the water surface")
			motion.position = Vector3.yAxis * 0.05
			update(now + 0.3)
			local scaredAt = assert(captured.startedAt, "Fish did not flee after the bait left water")
			assert((body.Position - initialFrame.Position).Magnitude < 0.001, "Scare entry snapped fish position")
			assert(body.Transparency >= initialTransparency - 0.001, "Scare revived a faded fish")
			active:TryHook(scaredAt + 0.01)
			update(scaredAt + 0.35)
			assert(active.reelFish == captured and captured.startedAt == scaredAt, "Repeated input restarted fleeing")
			local travel = body.Position - initialFrame.Position
			assert(
				travel:Dot(captured.direction) > 6 and math.abs(travel.Y) < 0.001,
				"Fish did not swim away underwater"
			)
			assert(body.Transparency > initialTransparency and body.Transparency < 1, "Fish did not fade gradually")
			local previousY = body.Position.Y
			target += Vector3.yAxis * 2
			update(scaredAt + 0.4)
			assert(math.abs(body.Position.Y - previousY - 2) < 0.001, "Fleeing fish did not follow water height")
			target -= Vector3.yAxis * 2
			update(scaredAt + Config.Bite.EscapeTime + 0.001)
			assert(
				captured.finished and body.Transparency == 1 and not active.highlight.Enabled,
				"Fleeing fish remained visible"
			)
			assert(active.timeline.phase == "Reeling" and not active:CanRetry(scaredAt + 10), "Scare restarted fishing")
			motion.settled = true
			local settledAt = scaredAt + Config.Bite.EscapeTime + 0.1
			update(settledAt)
			assert(active.timeline.phase == "Reeled", "Settled reel did not enter showcase")
			assert(not active:CanReturn(settledAt + Config.Reel.HoldTime - 0.001), "Showcase ended before 0.5 seconds")
			update(settledAt + Config.Reel.HoldTime)
			assert(
				active:CanReturn(settledAt + Config.Reel.HoldTime) and not owner.continueLabel.Visible,
				"Auto-return readiness or prompt is wrong"
			)
		else
			assert(not active.reelFish, "Invisible fish was captured for fleeing")
			motion.lifting, motion.position = true, Vector3.yAxis * Config.Bite.ShowcaseHeight
			update(now + 0.5)
			assert(
				not active.reelFish and body.Transparency == 1 and not active.highlight.Enabled,
				"Absent fish reappeared"
			)
		end
		active:Destroy()
		active:Destroy()
		assert(not body.Parent and not proxy.Parent, "Reel resources survived cleanup")
		owner.bite, active = nil, nil
	end
	return { passed = true, cases = #cases, visibleFishCases = visibleCases }
end, debug.traceback)

if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
