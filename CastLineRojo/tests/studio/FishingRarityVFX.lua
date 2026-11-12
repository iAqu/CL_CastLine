-- Studio Client：真实模板、发射时序、尺寸、两阶段生命周期与异常资源。
local storage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Player = require(storage.Modules.FishingRarityVFX)
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local RarityConfig = require(storage.Modules.RarityConfig)
local settings = require(storage.Modules.FishingConfig).RarityVFX
local water = require(storage.Modules.WaterSurfaceUtil)
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRarityVFXValidation", workspace
local owners, active = {}, {}
local hidden
local function near(a, b)
	assert(math.abs(a - b) < 0.0001, tostring(a) .. " ~= " .. tostring(b))
end
local function play(rarity, diameter, stage)
	local effect = assert(Player.Play({ folder = folder }, 10, Vector3.new(0, 1000, 0), rarity, diameter, stage))
	table.insert(active, effect)
	return effect
end
local ok, result = xpcall(function()
	local templates, textures, lastCount, lastLayers = storage.VFX.AnimalRoller, {}, 0, 0
	local counts = {}
	for _, rarity in ipairs(RarityConfig.List) do
		local template = assert(templates:FindFirstChild(rarity.Name))
		assert(template:IsA("Model") and template.PrimaryPart, "Expected Model: " .. rarity.Name)
		local count, layers = 0, 0
		for _, emitter in ipairs(template:GetDescendants()) do
			if emitter:IsA("ParticleEmitter") then
				assert(not emitter.Enabled and emitter.Rate == 0, "Template emitting continuously")
				assert(emitter:GetAttribute("EmitDuration") == 0, "Unexpected continuous emission")
				count += emitter:GetAttribute("EmitCount")
				layers += 1
				textures[emitter.Texture] = true
			end
		end
		assert(count > lastCount and count <= 180 and layers > lastLayers, "Rarity progression changed")
		lastCount, lastLayers = count, layers
		counts[rarity.Name] = count
		local exit = play(rarity.Name, 12, "Exit")
		local showcase = play(rarity.Name, 12, "Showcase")
		assert(exit.model.Name == rarity.Name and showcase.model.Name == rarity.Name, "Wrong rarity template")
		near(exit.scale, 0.8)
		near(showcase.scale, 1)
		-- 被筛掉的高阶层不能通过连续发射泄漏到轻量版。
		for _, emitter in ipairs(exit.model:GetDescendants()) do
			if emitter:IsA("ParticleEmitter") then
				assert(not emitter.Enabled, "Exit emitter remained enabled")
			end
		end
		assert(#exit.emissions == 0, "Exit must emit only the immediate base layers")
		exit:Destroy()
		showcase:Destroy()
		task.wait()
	end
	local failed = {}
	local assets = {}
	for texture in pairs(textures) do
		table.insert(assets, texture)
	end
	ContentProvider:PreloadAsync(assets, function(id, status)
		if status ~= Enum.AssetFetchStatus.Success then
			table.insert(failed, id)
		end
	end)
	assert(#failed == 0, "Roll textures failed to load: " .. table.concat(failed, ", "))

	local normalized = play("Mythical", 12, "Showcase")
	assert(normalized.model.Name == "Mythic", "Legacy rarity alias was lost")
	normalized:Destroy()
	local unknown = play(nil, 12, "Showcase")
	assert(unknown.model.Name == "Common", "Preview fallback changed")
	unknown:Destroy()
	local source = templates.Exclusive.Root.Middle.Stars
	local originalSize, originalSpeed = source.Size.Keypoints[1].Value, source.Speed.Max
	local effect = play("Exclusive", 6, "Showcase")
	local stars = effect.model.Root.Middle.Stars
	near(stars.Size.Keypoints[1].Value, originalSize * 0.5)
	near(stars.Speed.Max, originalSpeed * 0.5)
	local delayed = assert(effect.emissions[#effect.emissions], "Expected delayed layers")
	assert(not delayed.emitted, "Delayed emission fired early")
	local target = Vector3.new(5, 1004, 8)
	effect:Update(10.05, target, 24)
	near(effect.model:GetScale(), 2)
	near(stars.Size.Keypoints[1].Value, originalSize * 2)
	near(stars.Speed.Max, originalSpeed * 2)
	near((effect.model:GetPivot().Position - target).Magnitude, 0)
	for _ = 1, 3 do
		effect:Update(10.05, target, 24)
	end
	near(stars.Size.Keypoints[1].Value, originalSize * 2)
	effect:Update(10.06, target, 6)
	near(stars.Size.Keypoints[1].Value, originalSize * 0.5)
	near(source.Size.Keypoints[1].Value, originalSize)
	effect:Update(10.41, target, 6)
	assert(#effect.emissions == 0, "Delayed emissions did not drain")
	assert(effect:Update(effect.expiresAt - 0.01, target, 6), "Truncated particle tail")
	assert(not effect:Update(effect.expiresAt, target, 6) and not effect.model.Parent, "Effect survived expiry")
	local interrupted = play("Exclusive", 12, "Showcase")
	interrupted:Destroy()
	assert(not interrupted:Update(10.5, target, 12) and #interrupted.emissions == 0, "Interrupted effect resumed")

	-- 使用完整 Bite 模块走成功、逃鱼、跳帧及提前退出场景。
	local template = Bite.SelectFishTemplate(storage.Models.Fish, Random.new(71))
	local function round(fishTemplate, fishConfig)
		local targetPosition = Vector3.new(1838, assert(water.GetWaterSurfaceY()), 1010)
		local owner = setmetatable({
			folder = folder,
			forward = Vector3.zAxis,
			spin = 0,
			baitBaseSize = Vector3.one,
			continueLabel = {},
			events = {},
			_waterTarget = function()
				return targetPosition
			end,
			_presentBait = function() end,
			_waterFeedback = function() end,
			_playWaterVFX = function() end,
			_impulse = function() end,
			_setPhase = function() end,
			_nibbleRipple = function() end,
			_nibbleFeedback = function() end,
			_playRarityVFX = function(self, now, position, rarity, diameter, stage)
				local burst = Cast._playRarityVFX(self, now, position, rarity, diameter, stage)
				table.insert(self.events, { stage = stage, burst = burst })
				return burst
			end,
		}, Cast)
		local bait = Instance.new("Part")
		bait.Anchored, bait.Parent = true, folder
		owner.bait = bait
		owner.bite = Bite.new(
			owner,
			0,
			0,
			Random.new(71),
			Random.new(72),
			fishTemplate or template,
			fishConfig or { Rarity = "Exclusive" }
		)
		table.insert(owners, owner)
		return owner
	end
	local owner = round()
	local bite = owner.bite
	while bite.timeline.phase ~= "Bite" do
		bite.timeline:Advance(bite.timeline.endsAt)
	end
	local hookAt = bite.timeline.startedAt + 0.01
	assert(bite:TryHook(hookAt))
	for step = 0, 400 do
		bite:Update(hookAt + step / 60)
		if step % 60 == 0 then
			task.wait()
		end
	end
	assert(
		#owner.events == 2 and owner.events[1].stage == "Exit" and owner.events[2].stage == "Showcase",
		"Expected Exit then Showcase once"
	)
	assert(#bite.rarityEffects == 0, "Completed round retained effects")
	local skipped = round()
	skipped.bite.timeline:_enter("Lifting", 0, 2)
	skipped.bite:Update(3)
	skipped.bite:Update(3)
	assert(#skipped.events == 1 and skipped.events[1].stage == "Showcase", "Skipped frame replayed Exit")
	local stopped = skipped.events[1].burst
	skipped.bite:Destroy()
	assert(stopped.destroyed and not stopped.model.Parent, "Round teardown left an effect")
	local escaped = round()
	escaped.bite.timeline:_enter("Escaped", 0)
	escaped.bite:Update(0.1)
	assert(#escaped.events == 0, "Escaped fish played showcase VFX")
	local sizeCases = {}
	for _, modelName in ipairs({ "GreenSeahorse", "AttackingWhale" }) do
		local model = assert(storage.Models.Fish:FindFirstChild(modelName), "Missing scale fixture: " .. modelName)
		for _, weight in ipairs({ 1, 8 }) do
			local sized = round(model, { Rarity = "Epic", DefaultWeight = 1, ModelDefaultScale = 1 })
			sized.bite:SetCaughtWeight(weight)
			sized.bite.timeline:_enter("Caught", 0)
			sized.bite:Update(0.01)
			local burst = assert(sized.events[1].burst, "Missing scaled showcase")
			local diameter = 2 * sized.bite.presentationRadius * sized.bite.scale
			near(burst.scale, diameter / settings.ReferenceDiameter)
			local center = sized.bite.fish:GetBoundingBox()
			near((burst.model:GetPivot().Position - center.Position).Magnitude, 0)
			table.insert(
				sizeCases,
				{ model = modelName, weight = weight, diameter = diameter, effectScale = burst.scale }
			)
			sized.bite:Destroy()
			assert(not burst.model.Parent, "Scaled round retained effects")
		end
	end
	local missingOwner = { folder = folder }
	hidden = templates.Legendary
	hidden.Parent = nil
	assert(not Player.Play(missingOwner, 10, target, "Legendary", 12, "Exit"), "Missing Exit did not skip")
	assert(not Player.Play(missingOwner, 10, target, "Legendary", 12, "Showcase"), "Missing Showcase did not skip")
	assert(missingOwner.warnedRarityVFX.Legendary, "Missing resource did not warn")
	hidden.Parent, hidden = templates, nil
	return {
		passed = true,
		tiers = 12,
		counts = counts,
		loadedTextures = #assets,
		twoStage = true,
		scaling = true,
		sizeCases = sizeCases,
		cleanup = true,
	}
end, debug.traceback)
if hidden then
	hidden.Parent = storage.VFX.AnimalRoller
end
for _, owner in ipairs(owners) do
	if not owner.bite.destroyed then
		owner.bite:Destroy()
	end
end
for _, effect in ipairs(active) do
	effect:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
