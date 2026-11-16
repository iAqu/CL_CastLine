-- Run in Studio Client. Uses real egg models and the shared server/client bite window.
local RS = game:GetService("ReplicatedStorage")
local Bite = require(RS.Modules.FishingBiteSequence)
local EggTools = require(RS.Modules.EggToolUtil)
local Config = require(RS.Modules.FishingConfig)
local EggData = require(game:GetService("ReplicatedFirst").Data.EggsData)
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "EggFishingPresentationValidation", workspace
local active
local ok, result = xpcall(function()
	local hook = assert(EggTools.GetTemplate("Draw001"), "Draw001 model missing")
	local baitTemplate = select(1, require(RS.Modules.FishingAssets).GetBait(nil))
	local bait = baitTemplate:Clone()
	bait.Anchored, bait.Parent = true, folder
	local waterY = assert(require(RS.Modules.WaterSurfaceUtil).GetWaterSurfaceY(), "Water missing")
	local target = Vector3.new(0, waterY, 0)
	local owner = {
		folder = folder,
		bait = bait,
		baitBaseSize = bait.Size,
		forward = Vector3.zAxis,
		spin = 0,
		continueLabel = {},
		impulses = {},
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_playRarityVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_sound = function() end,
		_impulse = function() end,
		_setPhase = function() end,
		_landingOffset = function()
			return 0
		end,
	}
	local cases = {}
	for _, id in ipairs({ "Draw001", "Draw006", "Robux1", "Season2" }) do
		local template = assert(EggTools.GetTemplate(id), "Egg model missing: " .. id)
		local config = table.clone(EggData[id])
		config.NibbleCountMin, config.NibbleCountMax = 1, 1
		active = Bite.new(owner, 100, 100, Random.new(123), Random.new(456), template, config, "Egg")
		local biteAt, endsAt = Bite.GetBiteWindow(template, owner.baitBaseSize, 100, 100, 123, 456, 0, config, "Egg")
		while active.timeline.phase ~= "Bite" do
			active.timeline:Advance(active.timeline.endsAt)
		end
		assert(active.timeline.startedAt == biteAt and active.timeline.endsAt == endsAt, string.format("Bite clocks differ for %s: client %.17g..%.17g server %.17g..%.17g",id,active.timeline.startedAt,active.timeline.endsAt,biteAt,endsAt))
		assert(active.mouthOffset == template.PrimaryPart.HookAttachment.Position, "Hook attachment ignored")
		local at = 200
		for _, entry in ipairs({
			{ "Approaching", 2 },
			{ "Holding", 1 },
			{ "Nibbling", Config.Bite.NibbleTime },
			{ "Bite", config.HookWindow },
			{ "Struggling", config.StruggleTime },
			{ "Lifting", Config.Bite.LiftTime },
			{ "Caught", 2 },
			{ "Escaped", Config.Bite.EscapeTime },
		}) do
			local phase, duration = entry[1], entry[2]
			active.timeline.nibbleIndex = 1
			active.timeline:_enter(phase, at, duration)
			for _, fraction in ipairs({ 0, 0.5, 0.95 }) do
				active:Update(at + fraction * duration)
				local primary = active.fish.PrimaryPart
				assert(primary.Position.X == primary.Position.X, "Invalid egg position")
				if phase == "Caught" then
					assert(primary.CFrame.UpVector.Y > 0.99, "Caught egg must be upright")
					assert(math.abs(active.fish:GetScale() - template:GetScale()) < 1e-5, "Authored egg size changed")
				end
				assert(
					not active.animation.active and not active.drip and not active.fishTrail,
					"Egg used fish-only effects"
				)
			end
			at += duration + 1
		end
		table.insert(cases, { id = id, phases = 8, clocksMatch = true })
		active:Destroy()
		active = nil
		task.wait()
	end
	return { cases = cases, originalTemplateUntouched = hook.PrimaryPart.HookAttachment ~= nil }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
