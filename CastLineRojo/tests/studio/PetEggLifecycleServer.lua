-- Temporarily copy to ServerScriptService as a Script through Rojo.
-- Start with StudioTestService:ExecuteMultiplayerTestAsync(2,
-- { Suite = "PetEggLifecycleQA", Mode = "multiplayer" }). Restores test profiles.
if not game:GetService("RunService"):IsStudio() then
	return
end
local Test = game:GetService("StudioTestService")
local valid, args = pcall(function()
	return Test:GetTestArgs()
end)
if not valid or type(args) ~= "table" or args.Suite ~= "PetEggLifecycleQA" then
	return
end
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local frameworkReady = false
task.delay(90, function()
	if not frameworkReady then
		Test:EndTest({ ok = false, mode = args.Mode, error = "Knit startup timed out before QA profile changes" })
	end
end)
local Knit = require(RS.Packages.Knit)
local Data = require(game.ServerScriptService.Services.PlayerDataService)
local function waitFor(check, message, timeout)
	local deadline = os.clock() + (timeout or 30)
	repeat
		local value = check()
		if value then
			return value
		end
		task.wait(0.1)
	until os.clock() > deadline
	error(message)
end
local qa = Instance.new("Folder")
qa.Name, qa.Parent = "PetEggLifecycleQA", RS
local remote = Instance.new("RemoteFunction")
remote.Name, remote.Parent = "Command", qa
local ready = Instance.new("RemoteEvent")
ready.Name, ready.Parent = "Ready", qa
ready.OnServerEvent:Connect(function(player)
	player:SetAttribute("PetEggLifecycleReady", true)
end)
local result = { mode = args.Mode, checks = {}, snapshots = {}, players = {} }
Players.PlayerAdded:Connect(function(p)
	table.insert(result.players, { event = "joined", name = p.Name, id = p.UserId })
end)
Players.PlayerRemoving:Connect(function(p)
	table.insert(result.players, { event = "left", name = p.Name, id = p.UserId })
end)
for _, p in ipairs(Players:GetPlayers()) do
	table.insert(result.players, { event = "present", name = p.Name, id = p.UserId })
end
local backups = {}
local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local out = {}
	for k, v in pairs(value) do
		out[k] = copy(v)
	end
	return out
end
local function command(player, action, data)
	local done, success, response
	task.spawn(function()
		success, response = pcall(function()
			return remote:InvokeClient(player, action, data)
		end)
		done = true
	end)
	waitFor(function()
		return done
	end, "Client command timeout: " .. action, 15)
	assert(success, tostring(response))
	return response
end
local function checkRoster(viewer, expected, label)
	local last
	waitFor(function()
		last = command(viewer, "snapshot")
		for id, count in pairs(expected) do
			local row = last.owners[tostring(id)]
			if not row or row.count ~= count or row.targets ~= count or not row.scalesValid then
				return false
			end
		end
		return true
	end, label, 15)
	result.snapshots[label] = last
	return last
end
local fields = { "Pets", "PetIndex", "Eggs", "HotbarLayout", "Settings" }
local petService, eggService, slots
local originalPlace
local keepSeed = false
local ok, err = xpcall(function()
	Knit.OnStart():await()
	frameworkReady = true
	petService, eggService, slots =
		Knit.GetService("PetService"), Knit.GetService("EggService"), Knit.GetService("PlotSlotService")
	local players = waitFor(function()
		return #Players:GetPlayers() >= (args.Players or 2) and Players:GetPlayers()
	end, "Two clients did not join", args.JoinTimeout or 90)
	table.sort(players, function(a, b)
		return a.UserId > b.UserId
	end)
	for _, p in ipairs(players) do
		assert(p.UserId < 0 or (args.Mode == "mobile" and args.AllowLocal), "QA requires simulated players")
		waitFor(function()
			return Data:GetProfile(p)
				and p.Character
				and p.Character:FindFirstChild("HumanoidRootPart")
				and slots:GetPlayerPlot(p)
		end, "Player not ready: " .. p.Name, 90)
		waitFor(function()
			return p:GetAttribute("PetEggLifecycleReady")
		end, "Client script not ready", 90)
		local data = Data:GetProfile(p).Data
		local backup = {}
		for _, key in ipairs(fields) do
			backup[key] = copy(data[key])
		end
		backups[p] = if args.Mode == "reconnectVerify" or args.Mode == "craftReload"
			then args.Backups[tostring(p.UserId)]
			else backup
		if args.Mode == "reconnectVerify" or args.Mode == "craftReload" or args.Mode == "mobile" then
			continue
		end
		data.Pets, data.PetIndex, data.Eggs, data.HotbarLayout = {}, {}, {}, {}
		data.Settings.ShowYourPets, data.Settings.ShowOtherPets = true, true
		for _, setting in ipairs({ "ShowYourPets", "ShowOtherPets" }) do
			command(p, "visibility", { key = setting, enabled = true })
		end
		for n = 1, 3 do
			local pet = assert(petService:GivePet(p, "Pet00" .. n))
			assert(petService.Client:EquipPet(p, pet.UUID, true).ok, "Could not equip seeded pet")
		end
	end
	local a, b = players[1], players[2]
	if args.Mode == "craft" or args.Mode == "craftReload" then
		local inventory = require(RS.Modules.PetInventory)
		local profile = Data:GetProfile(a)
		local base
		if args.Mode == "craft" then
			for _, pet in pairs(profile.Data.Pets) do
				if pet.PetID == "Pet001" then
					base = pet
				end
			end
			assert(base, "Missing craft base")
			assert(not command(b, "craftRpc", { uuid = base.UUID, size = 0 }).ok, "Another player could craft this pet")
			assert(not command(a, "craftRpc", { uuid = base.UUID, size = "0" }).ok, "Invalid tier type was accepted")
			for _ = 1, 2 do
				assert(petService:GivePet(a, "Pet001"), "Could not give materials")
			end
			local locked = assert(petService:GivePet(a, "Pet001"), "Could not give locked test pet")
			assert(petService.Client:LockPet(a, locked.UUID, true), "Could not lock test pet")
			command(a, "craftUi", { uuid = base.UUID })
			assert(
				base.Size == 1 and base.Equipped and profile.Data.Pets[base.UUID] == base,
				"Single craft did not preserve equipped base"
			)
			for _, viewer in ipairs(players) do
				waitFor(function()
					local state = command(viewer, "snapshot").owners[tostring(a.UserId)].pets[base.UUID]
					return state and state.size == 1 and math.abs(state.ratio - 1.5) < 0.0001
				end, "Big model did not replicate")
			end
			result.checks.singleCraft, result.checks.bigVisualBothClients = true, true
			for _ = 1, 2 do
				local pet = assert(petService:GivePet(a, "Pet001"), "Could not give Big material")
				pet.Size = 1
			end
			petService:_changed(a)
			assert(not command(a, "craftRpc", { uuid = base.UUID, size = 0 }).ok, "Stale request consumed another tier")
			assert(not command(a, "craftRpc", { uuid = locked.UUID, size = 0 }).ok, "Locked pet was craftable")
			command(a, "craftUi", { uuid = base.UUID })
			assert(base.Size == 2 and base.Equipped, "Big did not craft to Huge")
			for _ = 1, 9 do
				assert(petService:GivePet(a, "Pet004"), "Could not give bulk materials")
			end
			command(a, "craftUi", { uuid = base.UUID, all = true })
			local bulk = 0
			for _, pet in pairs(profile.Data.Pets) do
				if pet.PetID == "Pet004" then
					assert(pet.Size == 2, "Bulk chain did not reach Huge")
					bulk += 1
				end
			end
			assert(bulk == 1 and profile.Data.Pets[locked.UUID], "Bulk count or lock protection failed")
			assert(not petService.Client:CraftAllPets(a).ok, "Duplicate bulk craft consumed more pets")
			result.checks.bulkChain, result.checks.staleRetry, result.checks.lockProtection = true, true, true
			result.fixture = { uuid = base.UUID, locked = locked.UUID }
			result.backups = {}
			for p, original in pairs(backups) do
				result.backups[tostring(p.UserId)] = original
			end
		else
			base = profile.Data.Pets[args.Fixture.uuid]
			assert(
				base and base.Size == 2 and base.Equipped and profile.Data.Pets[args.Fixture.locked].Locked,
				"Crafted tier/lock/equipment did not persist"
			)
			result.checks.persistedSize = true
		end
		for _, viewer in ipairs(players) do
			waitFor(function()
				local state = command(viewer, "snapshot").owners[tostring(a.UserId)].pets[base.UUID]
				return state and state.size == 2 and math.abs(state.ratio - 2.2) < 0.0001
			end, "Huge model did not replicate")
		end
		result.checks.hugeVisualBothClients = true
		result.ui = command(a, "craftModes", { uuid = base.UUID })
		assert(
			result.ui.normal == "Craft All" and result.ui.delete == "Select All" and result.ui.lockHidden,
			"Craft mode controls incorrect"
		)
		assert(result.ui.indexRemoved and result.ui.luckRemoved, "Removed UI still present")
		assert(result.ui.detail == "Max Size reached!" and result.ui.boost == "+220% Luck", "Huge details incorrect")
		assert(
			math.abs(
				petService:GetLuckMultiplier(a)
					- inventory.GetLuckMultiplier(profile.Data, require(game.ReplicatedFirst.Data.PetsData))
			) < 0.00001,
			"Server luck does not match sizes"
		)
		result.checks.uiModes, result.checks.luck = true, true
		if args.Mode == "craft" then
			local saved = false
			local connection = profile.KeyInfoUpdated:Connect(function()
				saved = true
			end)
			profile:Save()
			waitFor(function()
				return saved
			end, "Craft save timed out", 30)
			connection:Disconnect()
			keepSeed = true
		end
		return
	elseif args.Mode == "mobile" then
		originalPlace = eggService.PlaceEgg
		result.requests = {}
		eggService.PlaceEgg = function(self, p, uuid, world, yaw)
			local response = originalPlace(self, p, uuid, world, yaw)
			table.insert(result.requests, { ok = response.ok, message = response.message, position = tostring(world) })
			return response
		end
		local ground = slots:GetPlayerPlot(a).Ground
		local world = ground.CFrame:PointToWorldSpace(Vector3.new(0, ground.Size.Y / 2, 0))
		a.Character.HumanoidRootPart.CFrame = CFrame.new(world + Vector3.new(0, 3, -7))
		local uuid = assert(eggService:GiveEgg(a, "Draw001"))
		local projection = command(a, "placement", { uuid = uuid, world = world })
		result.diagnostic = {
			valid = projection.valid,
			groundQuery = projection.groundQuery,
			preview = projection.preview,
			toolParent = projection.toolParent,
			position = tostring(projection.position),
			distance = projection.rootDistance,
			eggs = projection.eggs,
			record = projection.record,
			touch = projection.touch,
		}
		assert(projection.touch, "Phone simulation not active")
		assert(projection.valid, "Mobile placement preview invalid")
		assert((projection.position - world).Magnitude < 0.05, "Screen-to-ground projection drifted")
		result.projection = { error = (projection.position - world).Magnitude, touch = projection.touch }
		local missed = command(a, "previewMiss")
		result.checks.noGhostPreview = not missed.visible and not missed.valid
		result.input = command(a, "virtualTap", { world = world })
		result.checks.placedFromInput = Data:GetProfile(a).Data.Eggs[uuid].Placement ~= nil
		assert(result.checks.noGhostPreview, "Preview remained visible after ray missed Ground")
		assert(
			result.input.sent and result.input.taps == 1 and result.checks.placedFromInput,
			"Touch did not place the egg"
		)
		local record = Data:GetProfile(a).Data.Eggs[uuid]
		local placed =
			ground.CFrame:PointToWorldSpace(Vector3.new(record.Placement.X, ground.Size.Y / 2, record.Placement.Z))
		local tapHit = result.input.details[1].rayHit
		assert(tapHit and (placed - tapHit).Magnitude < 0.05, "Placed position did not match the touch ray")
		result.checks.touchPosition = true
		return
	elseif args.Mode == "reconnectSeed" then
		local profile = Data:GetProfile(a)
		local ground = slots:GetPlayerPlot(a).Ground
		local fixture = { UserId = a.UserId }
		for n, name in ipairs({ "paused", "ready", "running" }) do
			local uuid = assert(eggService:GiveEgg(a, "Draw001"))
			fixture[name] = uuid
			local world = ground.CFrame:PointToWorldSpace(Vector3.new((n - 2) * 8, ground.Size.Y / 2, 0))
			a.Character.HumanoidRootPart.CFrame = CFrame.new(world + Vector3.new(0, 3, 0))
			assert(eggService:PlaceEgg(a, uuid, world, 0).ok, "Seed egg placement failed")
			if name == "paused" then
				task.wait(1)
				assert(eggService:PickupEgg(a, uuid).ok, "Seed pickup failed")
				fixture.remaining = profile.Data.Eggs[uuid].RemainingSeconds
			elseif name == "ready" then
				profile.Data.Eggs[uuid].Placement.ReadyAt = workspace:GetServerTimeNow() - 1
				eggService:_renderEgg(a, uuid)
			else
				fixture.readyAt = profile.Data.Eggs[uuid].Placement.ReadyAt
			end
		end
		task.wait(1.5)
		local actualHotbar = command(a, "hotbar")
		for slot, uuid in pairs(actualHotbar) do
			if uuid == fixture.paused then
				fixture.slot = slot
			end
		end
		assert(fixture.slot, "Carried egg never entered the actual hotbar")
		assert(
			profile.Data.HotbarLayout[fixture.slot] and profile.Data.HotbarLayout[fixture.slot].Id == fixture.paused,
			"Actual hotbar did not save before disconnect"
		)
		local equipped = require(RS.Modules.PetInventory).GetEquipped(profile.Data)
		equipped[1].Locked = true
		fixture.lockedPet = equipped[1].UUID
		result.fixture, result.backups = fixture, {}
		for p, original in pairs(backups) do
			result.backups[tostring(p.UserId)] = original
		end
		result.checks.seeded = true
		local saved = false
		local connection = profile.KeyInfoUpdated:Connect(function()
			saved = true
		end)
		profile:Save()
		waitFor(function()
			return saved
		end, "Seed profile save did not finish", 30)
		connection:Disconnect()
		result.checks.liveDataStore = require(game.ServerScriptService.Libs.ProfileService).IsLive()
		keepSeed = true
		return
	elseif args.Mode == "reconnectVerify" then
		local fixture = args.Fixture
		assert(a.UserId == fixture.UserId, "Test player identity changed")
		local profile = Data:GetProfile(a)
		local data, ground = profile.Data, slots:GetPlayerPlot(a).Ground
		assert(data.Pets[fixture.lockedPet].Locked, "Pet lock did not persist")
		assert(#require(RS.Modules.PetInventory).GetEquipped(data) == 3, "Equipped pets did not persist")
		assert(data.PetIndex.Pet001 and data.PetIndex.Pet002 and data.PetIndex.Pet003, "Pet index lost")
		local paused, readyEgg, running =
			data.Eggs[fixture.paused], data.Eggs[fixture.ready], data.Eggs[fixture.running]
		assert(
			paused and not paused.Placement and math.abs(paused.RemainingSeconds - fixture.remaining) < 0.01,
			"Paused timer changed offline"
		)
		assert(readyEgg and readyEgg.Placement, "Ready egg lost placement")
		assert(
			running and running.Placement and running.Placement.ReadyAt == fixture.readyAt,
			"Incubating timer did not persist"
		)
		assert(
			require(RS.Modules.EggInventory).IsReady(running, workspace:GetServerTimeNow()),
			"Offline incubation did not finish"
		)
		result.loadedHotbar = copy(data.HotbarLayout)
		assert(
			data.HotbarLayout[fixture.slot] and data.HotbarLayout[fixture.slot].Id == fixture.paused,
			"Carried egg hotbar slot lost"
		)
		local folder = slots:GetPlayerPlot(a):FindFirstChild("PlacedEggs")
		assert(
			folder and folder:FindFirstChild(fixture.ready) and folder:FindFirstChild(fixture.running),
			"Placed egg models not restored"
		)
		waitFor(function()
			local inventory = command(a, "inventory")
			local hotbar = command(a, "hotbar")
			return inventory[fixture.paused] == 1
				and inventory[fixture.ready] == nil
				and inventory[fixture.running] == nil
				and hotbar[fixture.slot] == fixture.paused
		end, "Client egg inventory/hotbar did not restore", 15)
		checkRoster(a, { [a.UserId] = 3, [b.UserId] = 3 }, "reconnected-followers")
		result.checks = {
			pets = true,
			index = true,
			locks = true,
			pausedTimer = true,
			offlineReady = true,
			models = true,
			hotbar = true,
			tool = true,
		}
		local resumeWorld = ground.CFrame:PointToWorldSpace(Vector3.new(-8, ground.Size.Y / 2, 0))
		a.Character.HumanoidRootPart.CFrame = CFrame.new(resumeWorld + Vector3.new(0, 3, 0))
		assert(eggService:PlaceEgg(a, fixture.paused, resumeWorld, 0).ok, "Paused egg could not resume")
		assert(
			math.abs(data.Eggs[fixture.paused].Placement.ReadyAt - workspace:GetServerTimeNow() - fixture.remaining)
				< 0.2,
			"Replaced egg restarted its timer"
		)
		result.checks.resumeRemaining = true
		local pos = readyEgg.Placement
		a.Character.HumanoidRootPart.CFrame = ground.CFrame * CFrame.new(pos.X, ground.Size.Y / 2 + 3, pos.Z)
		local readyWorld = ground.CFrame:PointToWorldSpace(Vector3.new(pos.X, ground.Size.Y / 2, pos.Z))
		assert(
			eggService:PickupEgg(a, fixture.ready).ok and data.Eggs[fixture.ready].RemainingSeconds == 0,
			"Picking up a completed egg lost ready status"
		)
		assert(eggService:PlaceEgg(a, fixture.ready, readyWorld, 0).ok, "Completed egg could not be replaced")
		assert(eggService:HatchEgg(a, fixture.ready).ok, "Restored ready egg could not hatch")
		assert(not eggService:HatchEgg(a, fixture.ready).ok, "Restored egg hatched twice")
		result.checks.manualHatchOnce = true
		local peerProfile = Data:GetProfile(b)
		for _, key in ipairs(fields) do
			peerProfile.Data[key] = backups[b][key]
		end
		backups[b] = nil
		b:Kick("Pet/egg QA disconnect")
		waitFor(function()
			return b.Parent ~= Players
		end, "Peer did not disconnect")
		local afterLeave = checkRoster(a, { [a.UserId] = 3 }, "peer-disconnected")
		assert(afterLeave.folderCount == 3, "Disconnected player's pet visuals survived")
		result.checks.peerDisconnectCleanup = true
		return
	end
	qa:SetAttribute("Stage", "Following")
	for _, p in ipairs(players) do
		local snap = checkRoster(p, { [a.UserId] = 3, [b.UserId] = 3 }, "initial-" .. p.Name)
		for _, id in ipairs(snap.inventoryIds) do
			assert(Data:GetProfile(p).Data.Pets[id], "Another player's private inventory leaked")
		end
	end
	result.checks.replicatedEquipment, result.checks.privateInventory = true, true
	command(a, "visibility", { key = "ShowOtherPets", enabled = false })
	checkRoster(a, { [a.UserId] = 3, [b.UserId] = 0 }, "hide-others")
	checkRoster(b, { [a.UserId] = 3, [b.UserId] = 3 }, "other-viewer-unchanged")
	command(a, "visibility", { key = "ShowOtherPets", enabled = true })
	command(a, "visibility", { key = "ShowYourPets", enabled = false })
	checkRoster(a, { [a.UserId] = 0, [b.UserId] = 3 }, "hide-own")
	command(a, "visibility", { key = "ShowYourPets", enabled = true })
	result.checks.visibility = true
	qa:SetAttribute("Stage", "Teleport")
	local root = b.Character.HumanoidRootPart
	root.CFrame += Vector3.new(100, 0, 0)
	task.wait(0.5)
	for _, p in ipairs(players) do
		local snap = checkRoster(p, { [a.UserId] = 3, [b.UserId] = 3 }, "teleport-" .. p.Name)
		assert(snap.owners[tostring(b.UserId)].maxDistance < 5, "Followers did not snap after teleport")
	end
	result.checks.teleport = true
	qa:SetAttribute("Stage", "Respawn")
	local old = b.Character
	b:LoadCharacterAsync()
	waitFor(function()
		return b.Character and b.Character ~= old and b.Character:FindFirstChild("HumanoidRootPart")
	end, "Respawn failed")
	for _, p in ipairs(players) do
		checkRoster(p, { [a.UserId] = 3, [b.UserId] = 3 }, "respawn-" .. p.Name)
	end
	result.checks.respawn = true
	local equipped = require(RS.Modules.PetInventory).GetEquipped(Data:GetProfile(b).Data)
	assert(petService.Client:EquipPet(b, equipped[1].UUID, false).ok, "Could not unequip pet")
	for _, p in ipairs(players) do
		checkRoster(p, { [a.UserId] = 3, [b.UserId] = 2 }, "unequip-" .. p.Name)
	end
	result.checks.unequip = true
	qa:SetAttribute("Stage", "Done")
end, debug.traceback)
if originalPlace then
	eggService.PlaceEgg = originalPlace
end
for p, backup in pairs(backups) do
	local profile = Data:GetProfile(p)
	if profile and not (keepSeed and ok) then
		for _, key in ipairs(fields) do
			profile.Data[key] = backup[key]
		end
		if petService then
			petService:_changed(p)
		end
		if eggService then
			eggService:_restore(p)
		end
	end
end
result.ok, result.error = ok, if not ok then tostring(err) else nil
Test:EndTest(result)
