-- Temporary playtest driver that simulates closing the platform purchase prompt.
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local TURN_TIMES = { 0.5335, 1.067, 1.54 }

local function report(value)
	gui:SetAttribute("PaidEggVerificationClient", HttpService:JSONEncode(value))
end

local function waitUntil(check, seconds, message)
	local expires = os.clock() + seconds
	repeat
		local result = check()
		if result then
			return result
		end
		RunService.RenderStepped:Wait()
	until os.clock() >= expires
	error(message)
end

local function checkModelOutline(scene, visual)
	local outline = visual.Outline
	assert(scene.OutlineViewport.ImageColor3 == Color3.new(0, 0, 0), "Outline tint is not black")
	assert(scene.OutlineViewport.ZIndex < scene.Viewport.ZIndex, "Outline covers the fish")
	assert(outline.Parent == scene.OutlineViewport, "Silhouette is missing")
	local modelPivot, outlinePivot = visual.Model:GetPivot(), outline:GetPivot()
	assert(outlinePivot.LookVector:Dot(modelPivot.LookVector) > 0.9999, "Silhouette yaw differs from fish")
	local scale = visual.Model:GetScale()
	local outlineScale = outline:GetScale()
	assert(math.abs(outlineScale / scale - 1.045) < 0.001, "Wrong silhouette scale")
	local modelCenter = modelPivot:PointToWorldSpace(visual.CenterOffset * scale / visual.BaseScale)
	local outlineCenter = outlinePivot:PointToWorldSpace(visual.CenterOffset * outlineScale / visual.BaseScale)
	assert((modelCenter - outlineCenter).Magnitude < 0.001, "Silhouette drifted away from fish")
end

local function measureRotation(scene, narrow)
	local camera = scene.Camera
	if narrow then
		scene.Layer.Size = UDim2.fromOffset(390, 780)
		scene.Layer.Position = UDim2.new(0.5, -195, 0.5, -390)
	end
	task.wait(0.7)
	assert(scene.Cells[if narrow then 4 else 6].Y > scene.Cells[1].Y, "Grid wrapped at the wrong column")
	assert(scene.Cells[10].X == 0.5 or not narrow, "Last fish must be centered")
	local captions, firstTurns, growth, settledScales = {}, {}, {}, {}
	local viewportSize = scene.Layer.AbsoluteSize
	local focalLength = viewportSize.Y / (2 * math.tan(math.rad(camera.FieldOfView / 2)))
	for i, entry in ipairs(scene.Entries) do
		assert(entry.Caption.Visible and entry.Visual.Model.Parent == scene.Viewport, "A fish is missing from the grid")
		captions[i] = entry.Caption.Position
		firstTurns[i] = camera.CFrame.Rotation:ToObjectSpace(entry.Visual.Model:GetPivot().Rotation)
		local cell = scene.Cells[i]
		local x = (cell.X - 0.5) * viewportSize.X
		local y = (cell.Y + cell.VisualHeight / 2 - 0.5) * viewportSize.Y
		local halfWidth, halfHeight = cell.Width * viewportSize.X / 2, cell.VisualHeight * viewportSize.Y / 2
		local function oldFit(center, halfExtent)
			local slope = (math.abs(center) + halfExtent) / focalLength
			return 6.6 * halfExtent / (focalLength * math.sqrt(1 + slope * slope))
		end
		local original = math.min(oldFit(x, halfWidth), oldFit(y, halfHeight)) * 0.96 / entry.Visual.Radius
		settledScales[i] = entry.Visual.Model:GetScale()
		growth[i] = settledScales[i] / (entry.Visual.BaseScale * original)
		assert(growth[i] > 0 and growth[i] < 1.301, "Fish scale exceeded the 1.3x target")
	end
	local start = os.clock()
	local quarterChecked = false
	repeat
		local size = scene.Layer.AbsoluteSize
		local focal = size.Y / (2 * math.tan(math.rad(camera.FieldOfView / 2)))
		for i, entry in ipairs(scene.Entries) do
			local cell = scene.Cells[i]
			checkModelOutline(scene, entry.Visual)
			assert(entry.Visual.Model:GetScale() == settledScales[i], "Steady fish scale shifted")
			local bounds, extent = entry.Visual.Outline:GetBoundingBox()
			for _, x in ipairs({ -0.5, 0.5 }) do
				for _, y in ipairs({ -0.5, 0.5 }) do
					for _, z in ipairs({ -0.5, 0.5 }) do
						local point = bounds * (extent * Vector3.new(x, y, z))
						local sx = 0.5 + focal * point.X / (-point.Z * size.X)
						local sy = 0.5 - focal * point.Y / (-point.Z * size.Y)

						assert(
							point.Z < 0
								and math.abs(sx - cell.X) * size.X <= cell.Width * size.X / 2 + 0.5
								and (sy - cell.Y) * size.Y >= -0.5
								and (cell.Y + cell.VisualHeight - sy) * size.Y >= -0.5,
							"Fish outline exceeds its cell at index " .. i
						)
					end
				end
			end
			assert(entry.Caption.Position == captions[i], "Label moved during rotation")
			if os.clock() - start >= 1.25 and not quarterChecked then
				local current = camera.CFrame.Rotation:ToObjectSpace(entry.Visual.Model:GetPivot().Rotation)
				assert(current.LookVector:Dot(firstTurns[i].LookVector) < 0.4, "Fish did not turn")
			end
		end
		quarterChecked = quarterChecked or os.clock() - start >= 1.25
		task.wait(0.07)
	until os.clock() - start >= 5
	for i, entry in ipairs(scene.Entries) do
		local current = camera.CFrame.Rotation:ToObjectSpace(entry.Visual.Model:GetPivot().Rotation)
		assert(current.LookVector:Dot(firstTurns[i].LookVector) > 0.92, "Expected a full turn in five seconds")
	end
	return growth
end

report({ phase = "Waiting for Knit" })
local function verify()
	local Knit = require(ReplicatedStorage.Packages.Knit)
	Knit.OnStart():expect()
	Knit.GetController("FishingIntroController"):Cancel()
	local storeController = Knit.GetController("StoreGuiController")
	local store = gui:WaitForChild("StoreGui")
	local purchases = require(game.ReplicatedFirst.Data.PurchaseData)
	local config = require(ReplicatedStorage.Modules.PaidEggConfig)
	local scroll = store.Frame.MainFrame.ScrollingFrame
	local card = scroll.LimitedEggFrame.Egg_R_1
	storeController:OpenGui()
	RunService.RenderStepped:Wait()
	assert(scroll.CanvasPosition.Y <= 1, "Store did not open at its top")
	scroll.CanvasPosition = Vector2.new(0, 400)
	storeController:OpenGui()
	RunService.RenderStepped:Wait()
	assert(scroll.CanvasPosition.Y <= 1, "Store did not reset its scroll position")
	assert(card.Visible and card.Parent.Visible and not card.Parent.Egg_R_2.Visible, "Wrong egg cards visible")
	assert(
		card.Buy1Button.TextLabel.Text == "79"
			and card.Buy3Button.TextLabel.Text == "199"
			and card.Buy10Button.TextLabel.Text == "649",
		"Prices do not match PurchaseData"
	)
	local authored = game.StarterGui.StoreGui.Frame.MainFrame.ScrollingFrame.LimitedEggFrame.Egg_R_1
	assert(not card:FindFirstChild("PaidEggInlineOdds"), "Generated odds still visible")
	assert(
		card.Size == authored.Size and card.Buy1Button.Position == authored.Buy1Button.Position,
		"Extra space below egg card"
	)
	local featuredChance, featuredBadge
	for _, child in ipairs(card.IconFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			if child.Text == "OP" then
				featuredBadge = child
			elseif child.Text:match("^%d+%.?%d*%%$") then
				featuredChance = child
			end
		end
	end
	assert(featuredBadge, "The featured fish badge is missing")
	for _, fish in ipairs(config.Fish) do
		local label = card.IconFrame[fish.Card]:FindFirstChild("TextLabel")
			or (fish.Card == "GalaxyMegalodon" and featuredChance)
		assert(label and label.Text == string.format("%g%%", fish.Chance), fish.Card .. " odds differ from the fish pool")
	end
	assert(
		not card:FindFirstChild("PaidEggDetailsButton") and not gui:FindFirstChild("PaidEggOddsGui"),
		"Details UI still exists"
	)
	local controller = Knit.GetController("PaidEggGuiController")
	local remote = ReplicatedStorage:WaitForChild("PaidEggVerification", 40)
	assert(remote, "Missing test remote")
	local assets = require(ReplicatedStorage.Modules.FishingAssets)
	local originalGetFish = assets.GetFish
	remote.OnClientEvent:Connect(function(index, productId, orderId, count, delay, gift)
		local ok, message = xpcall(function()
			if not gift then
				waitUntil(function()
					return controller._prompt and controller._prompt.ProductId == productId
				end, 3, "Missing prepared prompt")
			end
			local function inventory()
				local n = 0
				for _, tool in ipairs(player.Backpack:GetChildren()) do
					if tool:GetAttribute("PaidOrigin") == orderId then
						n += 1
					end
				end
				return n
			end
			local sentAt = os.clock()
			if not gift then
				if index == 1 then
					local prompt = controller._prompt
					controller:_promptFinished(productId, false)
					assert(
						not controller._scene and not controller._confirmation and not controller._waiting[productId],
						"Cancellation started a presentation"
					)
					controller._prompt = prompt
				end
				controller:_promptFinished(productId, true)
			end
			remote:FireServer("Started", index)
			local timeout = false
			local sentNoticeCount = 0
			local confirmation = waitUntil(function()
				assert(not controller._scene and inventory() == 0, "Result appeared before confirmation")
				local pending = controller._confirmation
				if pending and pending.IsGiftNotice then
					assert(
						pending.Gui.Frame.ResultLabel.Text == "Gift sent!"
							and pending.Gui.Frame.ConfirmButton.TextLabel.Text == "OK",
						"Wrong sender confirmation"
					)
					sentNoticeCount += 1
					controller:_confirmOrder(pending)
				elseif pending then
					return pending
				elseif delay > 8 and os.clock() - sentAt >= 8 and not controller._waiting[productId] then
					timeout = true
				end
				return nil
			end, 28, "Missing purchase confirmation")
			assert(sentNoticeCount == (if gift then 1 else 0), "Sender notice should be independent and deduplicated")
			assert(confirmation.Id == orderId, "Confirmation did not belong to this order")
			assert(
				confirmation.Gui.Frame.ConfirmButton.TextLabel.Text
					== string.format("Open %d %s", count, if count == 1 then "Egg" else "Eggs"),
				"Wrong open button label"
			)
			local messageText = confirmation.Gui.Frame.ResultLabel.Text
			assert(
				if gift
					then messageText:find(player.DisplayName, 1, true) ~= nil
					else messageText == "Purchase successful!",
				"Wrong purchase message"
			)

			if index == 2 then
				controller:_closeConfirmation()
				assert(not confirmation.Gui.Parent and not controller._scene, "Confirmation did not clean up")
				confirmation = waitUntil(function()
					return controller._confirmation
				end, 2, "Pending confirmation did not return")
			end
			task.wait(0.35)
			assert(not controller._scene and inventory() == 0, "Waiting at the confirmation changed the order")

			if count == 1 then
				assets.GetFish = function()
					return nil
				end
			end
			local start = os.clock()
			local manual = index == 2 and workspace:GetAttribute("PaidEggVerifyNativeInput") == true
			if manual then
				report({ phase = "Native confirmation" })
				local scene = waitUntil(function()
					return controller._scene
				end, 20, "Native input did not activate the button")
				start = scene.PhaseAt
			else
				controller:_confirmOrder(confirmation)
			end
			controller:_confirmOrder(confirmation)
			local prelude = assert(controller._scene, "Confirmation did not start the prelude")
			local first = waitUntil(function()
				local entry = prelude.Entries[1]
				assert(
					not entry.Visual
						and entry.Fallback.Image == purchases[config.FindProduct(productId, purchases)].IconId,
					"Expected purchase egg image"
				)
				return if entry.Fallback.Visible and entry.Fallback.AbsoluteSize.X > 0 then os.clock() - start else nil
			end, 1, "Egg was never rendered")
			assert(first <= 0.15, "Prelude exceeded 150 ms")
			assert(#prelude.Entries == count and inventory() == 0, "Wrong number of eggs or premature grant")

			local interrupted = index == 2
			if interrupted then
				task.wait(0.28)
				controller:_close()
				assert(
					not prelude.Layer.Parent and not prelude.Audio.Parent and inventory() == 0,
					"Interruption leaked its scene"
				)
				prelude = waitUntil(function()
					return controller._scene
				end, 2, "Confirmed animation did not resume")
				start = prelude.PhaseAt
			end
			if gift then
				prelude.Layer.Size = UDim2.fromOffset(390, 780)
				prelude.Layer.Position = UDim2.new(0.5, -195, 0.5, -390)
			end

			local cues, connections = {}, {}
			table.insert(
				connections,
				prelude.Audio.ChildAdded:Connect(function(sound)
					table.insert(
						connections,
						sound.Played:Connect(function()
							local cue = {
								name = sound:GetAttribute("PaidEggCue"),
								at = os.clock() - start,
								sound = sound,
								loaded = sound.IsLoaded,
								duration = sound.TimeLength,
								volume = sound.Volume,
								peak = 0,
							}
							table.insert(cues, cue)
							table.insert(
								connections,
								sound.Loaded:Connect(function()
									cue.loaded = true
									cue.duration = math.max(cue.duration, sound.TimeLength)
								end)
							)
						end)
					)
				end)
			)
			table.insert(
				connections,
				RunService.RenderStepped:Connect(function()
					for _, cue in ipairs(cues) do
						if cue.sound.Parent then
							cue.loaded = cue.loaded or cue.sound.IsLoaded
							cue.duration = math.max(cue.duration, cue.sound.TimeLength)
							cue.peak = math.max(cue.peak, cue.sound.PlaybackLoudness)
						end
					end
				end)
			)
			local largestAngle, compressedEgg, expandedEgg = 0, math.huge, 0
			local scene = waitUntil(function()
				assert(inventory() == 0, "Inventory replicated before reveal")
				local current = controller._scene
				if current and current.Revealed then
					return current
				end
				local origin = prelude.Layer.AbsolutePosition
				local area = prelude.Layer.AbsoluteSize
				local sampleAt = os.clock() - prelude.PhaseAt
				local egg = prelude.Entries[1]
				local normalSide = math.min(egg.CellSize.X / 1.82, egg.CellSize.Y * 0.89)
				if sampleAt >= 1.95 and sampleAt < 2.09 then
					compressedEgg = math.min(compressedEgg, egg.Fallback.AbsoluteSize.X / normalSide)
				elseif sampleAt >= 2.12 then
					expandedEgg = math.max(expandedEgg, egg.Fallback.AbsoluteSize.X / normalSide)
				end
				for _, entry in ipairs(prelude.Entries) do
					local image = entry.Fallback
					local size = image.AbsoluteSize
					local center = image.AbsolutePosition - origin + size / 2
					local angle = math.rad(image.Rotation)
					local cx, cy = math.abs(math.cos(angle)), math.abs(math.sin(angle))
					local half = Vector2.new(cx * size.X + cy * size.Y, cy * size.X + cx * size.Y) / 2
					assert(
						center.X - half.X >= -1
							and center.X + half.X <= area.X + 1
							and center.Y - half.Y >= -1
							and center.Y + half.Y <= area.Y + 1,
						"Egg extends beyond the screen"
					)
					largestAngle = math.max(largestAngle, math.abs(image.Rotation))
				end
				return nil
			end, 5, "Fish reveal timed out")
			assert(largestAngle >= 25, "Egg missed the largest turn")
			local revealed = os.clock() - start
			assert(compressedEgg < 0.98 and expandedEgg > 1.08, "Egg squeeze or last expansion was not visible")
			assert(scene.Layer:FindFirstChild("BurstFlash"), "The burst flash missed the reveal")
			local firstFish = scene.Entries[1]
			local firstVisual = firstFish.Visual
			local center = firstVisual and firstVisual.Center.Position
			local initialYaw = firstVisual and firstVisual.Model:GetPivot().LookVector
			local smallest, largest = math.huge, 0
			local dip = 1
			while os.clock() - scene.PhaseAt <= 0.58 do
				local age = os.clock() - scene.PhaseAt
				local visual = firstVisual
				local factor
				if visual then
					factor = visual.Model:GetScale() / (visual.BaseScale * visual.SteadyScale)
					local pivot = visual.Model:GetPivot()
					local current = pivot:PointToWorldSpace(visual.CenterOffset * visual.LastRatio)
					assert((current - center).Magnitude < 0.001, "Visual center shifted during rebound")
					if age < 0.40 then
						assert(pivot.LookVector:Dot(initialYaw) > 0.9999, "Fish rotated before it settled")
						assert(not firstFish.Caption.Visible, "Label appeared during rebound")
					end
				else
					local width, height = firstFish.CellSize.X, firstFish.CellSize.Y
					local fit = width * (1 - 4 / math.min(width, height))
					factor = firstFish.Fallback.Size.X.Offset / fit
				end
				smallest = math.min(smallest, factor)
				largest = math.max(largest, factor)
				if age > 0.23 and age < 0.40 then
					dip = math.min(dip, factor)
				end
				RunService.RenderStepped:Wait()
			end
			assert(smallest < 0.83 and largest >= 0.97 and dip < 0.99, "Fish did not visibly expand and rebound")
			assert(firstFish.Caption.Visible, "Result label did not appear")
			assert(math.abs(revealed - 2.2) <= 0.14, ("Reveal timing %.3fs"):format(revealed))
			assert(#scene.Entries == count and (delay <= 8 or timeout), "Wrong reveal count or missing timeout")
			assert((scene.Order.SenderUserId ~= player.UserId) == gift, "Wrong sender")
			local hasTail = cues[5] and cues[5].name == "OpenTail"
			local expectedCues = (if count == 1 then 4 else 5) + (if hasTail then 1 else 0)
			waitUntil(function()
				return #cues >= expectedCues
			end, 2, "Missing playback cue")
			if hasTail then
				assert(cues[5].at >= cues[4].at and cues[5].at - cues[4].at <= 0.13, "Open tail missed its beat")
			end
			assert(
				cues[1].name == "Turn" and cues[2].name == "Turn" and cues[3].name == "Turn" and cues[4].name == "Open",
				"Cues were out of order"
			)
			assert(count == 1 or cues[expectedCues].name == "Cheer", "Rare catch did not play Cheer")
			assert(math.abs(cues[4].at - revealed) <= 0.1, "Open missed the reveal beat")
			for beat, expected in ipairs(TURN_TIMES) do
				assert(math.abs(cues[beat].at - expected) <= 0.12, ("Turn %d timing %.3fs"):format(beat, cues[beat].at))
			end

			if count == 1 then
				assert(
					scene.Entries[1].Fallback.Visible and scene.Entries[1].Fallback.Image ~= "",
					"Missing model did not fall back to its icon"
				)
				local entry = scene.Entries[1]
				assert(#entry.IconOutlines == 4, "Fallback fish icon outline is missing")
				for _, outline in ipairs(entry.IconOutlines) do
					assert(
						outline.Image == entry.Fallback.Image and outline.Size == entry.Fallback.Size,
						"Wrong icon silhouette"
					)
					assert(
						outline.ImageColor3 == Color3.new(0, 0, 0) and outline.ZIndex < entry.Fallback.ZIndex,
						"Wrong icon tint or layer"
					)
				end
				assets.GetFish = originalGetFish
			else
				for _, entry in ipairs(scene.Entries) do
					checkModelOutline(scene, entry.Visual)
				end
			end
			local appeared = waitUntil(function()
				return if inventory() == count then os.clock() - start else nil
			end, 8, "Fish tools did not replicate")
			local growth
			if count == 10 and not gift then
				report({ phase = "Desktop rotation", count = count })
				local desktop = measureRotation(scene, false)
				report({ phase = "Narrow rotation", count = count })
				growth = { desktop = desktop, narrow = measureRotation(scene, true) }
			end
			waitUntil(function()
				for _, cue in ipairs(cues) do
					if not cue.loaded or cue.duration <= 0 or cue.volume <= 0 then
						return nil
					end
				end
				return true
			end, 2, "A cue did not load with a playable duration and volume")
			-- PlaybackLoudness is diagnostic. Short cues may peak between frames.
			task.wait(0.35)
			assert(#cues == expectedCues, "A cue played more than once per beat")
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			controller:_close()
			assert(not scene.Audio.Parent, "Scene audio was not cleaned up")
			assert(
				not controller._scene and not scene.Layer.Parent and not gui.EggHatchResultGui.Enabled,
				"Display remained open"
			)
			for _, entry in ipairs(scene.Entries) do
				assert(not entry.Visual or not entry.Visual.Model.Parent, "Model was not cleaned up")
				if entry.Visual then
					assert(not entry.Visual.Outline.Parent, "Silhouette was not cleaned up")
				else
					for _, outline in ipairs(entry.IconOutlines) do
						assert(not outline.Parent, "Icon outline was not cleaned up")
					end
				end
			end
			local cueNames = {}
			for i, cue in ipairs(cues) do
				cueNames[i] = string.format("%s %.2fs peak %.0f", cue.name, cue.at, cue.peak)
			end
			local metrics = {
				cues = cueNames,
				native = manual,
				maximumAngle = largestAngle,
				first = first,
				revealed = revealed,
				eggPeak = expandedEgg,
				fishPeak = largest,
				fishDip = dip,
				inventory = appeared,
				timeout = delay > 8 and timeout,
				count = count,
				growth = growth,
				narrowRotation = count == 10 and not gift,
				interrupted = interrupted,
				gift = gift,
				iconFallback = count == 1,
			}
			report({ phase = "Scenario finished", index = index, metrics = metrics })
			remote:FireServer("Finished", index, metrics)
		end, debug.traceback)
		if not ok then
			assets.GetFish = originalGetFish
			report({ ok = false, error = tostring(message) })
			warn("PaidEggVerificationClient: " .. tostring(message))
		end
	end)
	report({ phase = "Ready", top = true, authoredOdds = true })
	remote:FireServer("Ready", 0)
end

local ok, message = xpcall(verify, debug.traceback)
if not ok then
	report({ ok = false, error = tostring(message) })
	warn("PaidEggVerificationClient: " .. tostring(message))
end
