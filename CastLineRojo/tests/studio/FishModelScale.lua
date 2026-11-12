-- Studio Client：Rojo 同步后在新的 Play 会话运行；只创建并清理临时测试实例。
local storage = game:GetService("ReplicatedStorage")
assert(storage.Modules.ItemStatUtil.Source:find("MAX_FISH_LENGTH = 50", 1, true), "Reconnect Rojo before running size QA")
local Stats = require(storage.Modules.ItemStatUtil)
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local Tools = require(storage.Modules.ItemToolUtil)
local Plot = require(storage.Modules.PlotFishMotion)
local inventory = require(storage.Modules.FishInventoryData)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "_FishModelScaleQA", workspace
local active

local function near(actual, expected, label)
	assert(math.abs(actual - expected) < 0.001, label .. ": " .. tostring(actual) .. " ~= " .. tostring(expected))
end

local function close(actual, expected, label)
	assert((actual - expected).Magnitude < 0.002, label .. ": " .. tostring((actual - expected).Magnitude))
end

local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local originalBaitSize = bait.Size
	local target = Vector3.new(10, 1000, 30)
	local eye = target + Vector3.new(12, 18, -20)
	local owner = {
		folder = folder, bait = bait, baitBaseSize = originalBaitSize,
		forward = Vector3.zAxis, spin = 0.37,
		continueLabel = {},
		_waterTarget = function() return target end,
		_presentBait = function() end,
		_sound = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_playRarityVFX = function() end,
		_impulse = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_setPhase = function() end,
	}
	local boundary = Instance.new("Part")
	boundary.Size, boundary.CFrame, boundary.Anchored = Vector3.new(45, 1, 45), CFrame.new(target), true
	boundary.Parent = folder
	local rounds, contacts, showcases = 0, 0, 0
	for _, name in { "GreenSeahorse", "WheelersShrimpGoby", "Axolotl", "MechaWhale" } do
		local template = assert(storage.Models.Fish:FindFirstChild(name), "Missing fish: " .. name)
		local source
		for _, item in inventory do
			if item.Model == name then
				source = item
				break
			end
		end
		assert(source, "Missing config: " .. name)
		local authoredScale = template:GetScale()
		local authoredSize = template.PrimaryPart.Size
		local handle = template:FindFirstChild("Handle", true) or template:FindFirstChildWhichIsA("BasePart", true)
		local authoredHandleSize = assert(handle).Size
		for _, base in { 1, 1.5, source.ModelDefaultScale } do
			local item = table.clone(source)
			item.ModelDefaultScale = base
			item.NibbleCountMin, item.NibbleCountMax = 2, 2
			bait.Size, bait.CFrame = originalBaitSize, CFrame.new(target)
			active = Bite.new(owner, 100, 100, Random.new(17), Random.new(29), template, item)
			owner.bite = active
			local baseline = Stats.GetScaleRatio(item, item.DefaultWeight, template)
			near(active.defaultScale, baseline, "Underwater base size")
			near(active.fish:GetScale(), authoredScale * baseline, "Initial clone size")
			local bodySize = template:GetAttribute("FishBodySize") or authoredSize
			near(active.depth, bodySize.Y * 0.5 * baseline + settings.WaterClearance, "Scaled water depth")
			local biteAt, biteEndsAt = Bite.GetBiteWindow(template, originalBaitSize, 100, 100, 17, 29, owner.spin, item)
			while active.timeline.phase ~= "Bite" do
				active.timeline:Advance(active.timeline.endsAt)
			end
			near(active.timeline.startedAt, biteAt, "Server/client bite start")
			near(active.timeline.endsAt, biteEndsAt, "Server/client bite end")
			local function show(phase, elapsed, duration)
				active.timeline:_enter(phase, 1000, duration or 100)
				active:Update(1000 + elapsed, true)
				active:Present(eye)
			end
			show("Bite", settings.BiteSinkTime + 0.01)
			local yaw = active:_feedingState("Bite", settings.BiteSinkTime + 0.01)
			local mouth = active.fish.PrimaryPart.MouthAttachment.WorldPosition
			close(mouth, bait.Position + active:_contactOffset(yaw, bait.Size), "Scaled bite contact")
			contacts += 1
			-- 路径起终点必须使用缩放后的嘴部，保持相邻阶段位置连续。
			for index, path in active.repositions do
				local entry = active.motion.nibbles[index]
				close(path.last:PointToWorldSpace(active.mouthOffset * baseline),
					active:_restMouth(Vector3.zero, entry.gap, entry.yaw), "Scaled return route endpoint")
			end
			for _, multiple in { 1, 8 } do
				local weight = item.DefaultWeight * multiple
				local ratio, cap = Stats.GetScaleRatio(item, weight, template)
				active:SetCaughtWeight(weight)
				near(active:_scaleAt("Lifting", 0), baseline, "Lift must start continuously")
				for index = 0, 50 do
					assert(active:_scaleAt("Lifting", settings.LiftTime * index / 50) <= cap + 1e-5,
						"Lift exceeded the shared size cap")
				end
				show("Caught", 0.1)
				near(active.fish:GetScale(), authoredScale * ratio, "Caught fish size")
				close(active.fish.PrimaryPart.Size, authoredSize * ratio, "Caught body size")
				local tool = assert(Tools.Create("size-qa", item, {
					Weight = weight, ConditionId = "Codition_1", Price = 1,
				}))
				tool.Parent = folder
				close(tool.Handle.Size, authoredHandleSize * ratio, "Held body size must match caught fish")
				tool:Destroy()
				local geometry = assert(Plot.GetGeometry(item, weight, boundary))
				near(geometry.scale, ratio, "Plot size must match caught fish")
				local metrics = Stats.GetModelBounds(template)
				assert(metrics.longest * ratio <= 50.001 and geometry.radius <= 21.501, "Final size exceeds limits")
				local move = Plot.Start(boundary, Vector3.zero, 0, Random.new(11), 0, geometry.footprint)
				for index = 0, 20 do
					local frame = Plot.Sample(boundary, geometry.height, move, move.duration * index / 20, geometry.footprint)
					for _, x in { metrics.minimum.X, metrics.maximum.X } do
						for _, z in { metrics.minimum.Z, metrics.maximum.Z } do
							local point = boundary.CFrame:PointToObjectSpace(frame:PointToWorldSpace(Vector3.new(x, 0, z) * ratio))
							assert(math.abs(point.X) <= 22.501 and math.abs(point.Z) <= 22.501, "Plot fish crossed the boundary")
						end
					end
				end
				for _, viewport in { Vector2.new(390, 844), Vector2.new(1877, 1240) } do
					local camera = Cast._showcaseCamera(owner, target, viewport)
					local center = camera:PointToObjectSpace(target + Vector3.yAxis * active:GetShowcaseHeight())
					local vertical = math.rad(settings.ShowcaseFov * 0.5)
					local horizontal = math.atan(math.tan(vertical) * viewport.X / viewport.Y)
					assert(-center.Z * math.sin(math.min(vertical, horizontal)) >= active:GetShowcaseRadius(),
						"Scaled fish clipped in showcase")
					showcases += 1
				end
			end
			near(template:GetScale(), authoredScale, "Source template scale changed")
			close(template.PrimaryPart.Size, authoredSize, "Source template geometry changed")
			active:Destroy()
			active = nil
			rounds += 1
		end
		task.wait()
	end
	return { passed = true, rounds = rounds, contacts = contacts, showcases = showcases }
end, debug.traceback)

if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
