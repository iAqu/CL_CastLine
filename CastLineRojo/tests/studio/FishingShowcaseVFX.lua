-- Studio Client：真实鱼体、揭晓同帧触发、描边恢复、叠加与退出清理。
local storage = game:GetService("ReplicatedStorage")
local modules = storage.Modules
local Bite = require(modules.FishingBiteSequence)
local Cast = require(modules.FishingCastSequence)
local Info = require(modules.FishingSequenceInfo)
local VFX = require(modules.FishingShowcaseVFX)
local Rarity = require(modules.RarityConfig)
local Config = require(modules.FishingConfig)
local Mutations = require(modules.MutationDataUtil)
local target = Vector3.new(0, 5000, 0)
local apex = Config.Bite.LiftTime * Config.Bite.LiftRiseEnd
local owners, guis = {}, {}
local report = { cases = 0, sizes = {}, integration = true, cleanup = true }

local function create(modelName, rarity, isNew, mutationId, egg)
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingShowcaseVFXValidation", workspace
	local gui = game.StarterGui.FishingSequenceGui:Clone()
	gui.Name, gui.Enabled = "FishingShowcaseVFXValidation", true
	gui.Parent = game.Players.LocalPlayer.PlayerGui
	table.insert(guis, gui)
	local bait = Instance.new("Part")
	bait.Anchored, bait.Parent = true, folder
	local owner = setmetatable({
		gui = gui, folder = folder, bait = bait, forward = Vector3.zAxis, spin = 0,
		baitBaseSize = Vector3.one, continueLabel = {}, originals = {}, createdScales = {},
		_waterTarget = function() return target end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_impulse = function() end,
	}, Cast)
	table.insert(owners, owner)
	owner.info = Info.new(gui, owner, 1, 0)
	local template = assert(storage.Models.Fish:FindFirstChild(modelName), "Missing fixture: " .. modelName)
	owner.bite = Bite.new(owner, 0, 0, Random.new(41), Random.new(42), template,
		{ DisplayName = modelName, Rarity = rarity, CpsPrice = 1, DefaultWeight = 1, ModelDefaultScale = 1 },
		if egg then "Egg" else nil)
	local bite = owner.bite
	bite.isNewDiscovery, bite.mutationId = isNew, mutationId
	bite.timeline:_enter("Lifting", 0, Config.Bite.LiftTime)
	return owner, bite
end
local function frame(owner, now)
	owner.bite:Update(now, true)
	owner.info:Update(now, owner.bite)
	owner.bite:Present(workspace.CurrentCamera.CFrame.Position)
end
local function near(a, b)
	assert(math.abs(a - b) < 0.001, tostring(a) .. " differs from " .. tostring(b))
end
local ok, err = xpcall(function()
	for _, case in {
		{ "Common", false, nil, false },
		{ "Common", true, nil, true },
		{ "Epic", false, nil, false },
		{ "Legendary", false, nil, true },
		{ "Exclusive", false, nil, true },
		{ "Event", false, nil, true },
		{ "Rare", false, "Rainbow", true },
		{ "Common", false, "Invalid", false },
	} do
		local owner, bite = create("GreenSeahorse", case[1], case[2], case[3])
		frame(owner, apex - 0.01)
		assert(not bite.showcaseVFX and not bite.showcasePending, "Effect preceded fish-name reveal")
		frame(owner, apex + 0.01)
		local effect = assert(bite.showcaseVFX, "Reveal did not create colored outline")
		assert(owner.gui.RevealInfo.Visible and owner.gui:FindFirstChild("ConfettiLayer"), "Existing reveal celebration disappeared")
		assert(bite.highlight.OutlineColor == Rarity.Get(case[1]).Color, "Wrong outline color")
		assert(bite.highlight.FillTransparency == 1 and bite.highlight.DepthMode == Enum.HighlightDepthMode.Occluded,
			"Outline changed shadow fill or occlusion")
		assert((effect.part ~= nil) == case[4], "Unexpected burst eligibility")
		if effect.part then
			local center, size = bite.fish:GetBoundingBox()
			near((effect.part.Position - center.Position).Magnitude, 0)
			local emitter = effect.part.Stars
			near(emitter.Size.Keypoints[2].Value, math.clamp(size.Magnitude * 0.12, 0.8, 4))
			assert(emitter.Texture == Config.ShowcaseVFX.Texture and not emitter.LockedToPart and not emitter.Enabled,
				"Stars must use the reference texture and world-space burst")
		end
		frame(owner, apex + 0.02)
		assert(bite.showcaseVFX == effect, "Repeated frame restarted effect")
		frame(owner, apex + 0.01 + Config.ShowcaseVFX.OutlineDuration)
		assert(bite.highlight.OutlineColor == Color3.new(0, 0, 0), "Outline did not recover after 1.2 seconds")
		frame(owner, Config.Bite.LiftTime + 0.01)
		assert(if case[4] then bite.showcaseVFX == effect else bite.showcaseVFX == nil,
			"Caught lost active star tail")
		if storage.VFX.AnimalRoller:FindFirstChild(case[1]) then
			assert(#(bite.rarityEffects or {}) > 0, "Caught lost existing rarity particles")
		end
		local part = effect.part
		frame(owner, apex + 0.01 + Config.ShowcaseVFX.CleanupTime)
		assert(not bite.showcaseVFX and (not part or not part.Parent), "Expired star anchor survived")
		owner.info.revealedBite, owner.celebratedBite = nil, nil
		frame(owner, 10)
		assert(not bite.showcaseVFX and not bite.showcasePending, "Repeated reveal replayed stars")
		owner:Destroy()
		report.cases += 1
	end
	-- 大鱼、多网格鱼、小鱼；按本帧缩放后的真实包围盒发射，发射点不随鱼移动。
	for _, name in { "GreenSeahorse", "AttackingWhale", "AncientMegalodon" } do
		local owner, bite = create(name, "Epic", true)
		bite:SetCaughtWeight(8)
		frame(owner, apex + 0.01)
		local effect = assert(bite.showcaseVFX, "Missing scaled showcase")
		local part = assert(effect.part, "Missing scaled star anchor")
		local center, size = bite.fish:GetBoundingBox()
		near((part.Position - center.Position).Magnitude, 0)
		near(part.Stars.Size.Keypoints[2].Value, math.clamp(size.Magnitude * 0.12, 0.8, 4))
		table.insert(report.sizes, { model = name, peak = part.Stars.Size.Keypoints[2].Value })
		local position = part.Position
		frame(owner, apex + 0.1)
		assert(part.Position == position, "Star anchor followed fish motion")
		owner:Destroy()
		owner:Destroy()
		assert(not part.Parent and not bite.showcaseVFX and not bite.showcasePending, "Early exit leaked stars")
		bite:Present()
	end
	local owner, bite = create("GreenSeahorse", "Legendary", true, "Rainbow", true)
	frame(owner, apex + 0.01)
	assert(not bite.showcaseVFX and not bite.showcasePending and not VFX.ShouldBurst(bite), "Egg received fish effects")
	owner:Destroy()
	owner, bite = create("GreenSeahorse", "Rare", true)
	frame(owner, Config.Bite.LiftTime + 0.01)
	local effect = assert(bite.showcaseVFX, "Skipping Lifting missed reveal")
	frame(owner, Config.Bite.LiftTime + 0.02)
	assert(bite.showcaseVFX == effect, "Skipped reveal played twice")
	owner:Destroy()
	for _, phase in { "Escaped", "Reeling", "Reeled" } do
		owner, bite = create("GreenSeahorse", "Legendary", true)
		bite.timeline:_enter(phase, 0)
		owner.info:Update(0.01, bite)
		assert(not bite.showcasePending and not bite.showcaseVFX, phase .. " triggered a reveal")
		owner:Destroy()
	end
	assert(Mutations.NormalizeMutationId("Rainbow"), "Rainbow fixture is invalid")
end, debug.traceback)
for _, owner in owners do
	owner:Destroy()
end
for _, gui in guis do
	gui:Destroy()
end
assert(ok, err)
return report
