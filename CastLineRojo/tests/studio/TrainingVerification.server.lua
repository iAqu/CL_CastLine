-- Copy temporarily to ServerScriptService via Rojo. Never saves the isolated profile.
if not game:GetService("RunService"):IsStudio() then
	return
end
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local Knit = require(RS.Packages.Knit)
local deadline = os.clock() + 50
local pd, player, original
repeat
	local ok, result = pcall(Knit.GetService, "PlayerDataService")
	if ok then
		pd = result
	end
	player = Players:GetPlayers()[1]
	original = pd and player and pd:GetProfile(player)
	if not original then
		task.wait(0.25)
	end
until original or os.clock() >= deadline
local function report(value)
	workspace:SetAttribute("TrainingVerification", Http:JSONEncode(value))
end
if not original then
	report({ ok = false, error = "Profile startup timed out" })
	return
end
local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for k, v in pairs(value) do
		result[k] = copy(v)
	end
	return result
end
local service = Knit.GetService("TrainingService")
local plotService = Knit.GetService("PlotSlotService")
local P = require(RS.Modules.TrainingProgress)
local Spot = require(RS.Modules.TrainingSpotUtil)
local levels = require(game.ReplicatedFirst.Data.TrainingLevelsData)
local maxLevel = P.GetMaxLevel(levels)
local firstLevelXp = P.GetLevel(levels, 1).XpToNextLevel
local plot, character, root
repeat
	plot = plotService:GetPlayerPlot(player)
	character = player.Character
	root = character and character:FindFirstChild("HumanoidRootPart")
	if not plot or not root then
		task.wait(0.1)
	end
until (plot and root) or os.clock() >= deadline
if not plot or not root then
	report({ ok = false, error = "Plot or character unavailable" })
	return
end
local originalOwner = plot:GetAttribute("OwnerUserId")
local oldPivot = character:GetPivot()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local originalSpeed, originalRotate = humanoid.WalkSpeed, humanoid.AutoRotate
local isolated = {
	Data = copy(original.Data),
	MetaData = { SessionLoadCount = 2 },
	IsActive = function()
		return true
	end,
}
isolated.Data.Training = { Level = 1, Xp = 0, TrainingID = "Training_101", ResumeActive = false, LastActiveAt = 0 }
isolated.Data.Wins = 100000
isolated.Data.GamePasses.DoubleTrain = nil
local restored = false
local fakePlayers = {}
local function restore()
	if restored then
		return
	end
	restored = true
	plot:SetAttribute("OwnerUserId", originalOwner)
	service:Stop(player, true)
	pd._Profiles[player] = original
	for _, fake in ipairs(fakePlayers) do
		pd._Profiles[fake] = nil
	end
	if character.Parent then
		character:PivotTo(oldPivot)
	end
	local cash = player:FindFirstChild("leaderstats")
	if cash then
		cash["💵Cash"].Value = original.Data.Wins
	end
	service:_publish(player)
	workspace:SetAttribute("TrainingVerificationRestored", true)
end
workspace:GetAttributeChangedSignal("TrainingVerificationRestore"):Connect(restore)
game:BindToClose(restore)
local checks = {}
local function check(value, name)
	assert(value, name)
	table.insert(checks, name)
end
local function move(frame)
	character:PivotTo(frame)
	root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
end
local function step(dt)
	service.Client:SetAllowed(player, true)
	service:_step(player, dt or 0.1)
end
local ok, err = xpcall(function()
	pd._Profiles[player] = isolated
	service:Stop(player, true)
	move(plot.AreaSpawnPoint.CFrame)
	step()
	move(Spot.SpawnCFrame(plot, character))
	move(character:GetPivot() + character:GetPivot().RightVector * 1)
	step()
	check(service:GetSnapshot(player).active, "entry starts training")
	check(
		(root.Position - Spot.SpawnCFrame(plot, character).Position).Magnitude < 0.01,
		"entry snaps to training center"
	)
	check(root.Anchored and humanoid.WalkSpeed == 0 and not humanoid.AutoRotate, "training locks position and facing")
	check(plot:FindFirstChild("TrainingBarbellDisplay") == nil, "held barbell replaces idle model")
	check(character:FindFirstChild("TrainingBarbell") ~= nil, "barbell equipped")
	check(character:FindFirstChildOfClass("Tool") == nil, "training stows fishing tools")
	step(1.05)
	check(isolated.Data.Training.Xp >= 2, "server awards timed experience")
	service.Client:Stop(player)
	check(
		not root.Anchored and humanoid.WalkSpeed == originalSpeed and humanoid.AutoRotate == originalRotate,
		"stop restores character movement"
	)
	check(not Spot.Contains(plot.TrainingAnchor, root, humanoid), "manual stop exits training region")
	local stoppedPosition = root.Position
	service.Client:Stop(player)
	check((root.Position - stoppedPosition).Magnitude < 0.01, "duplicate stop does not move character again")
	check(plot:FindFirstChild("TrainingBarbellDisplay") ~= nil, "idle barbell restored after stop")
	step(2)
	check(not service:GetSnapshot(player).active, "stop requires leaving before restart")
	move(plot.AreaSpawnPoint.CFrame)
	step()
	move(Spot.SpawnCFrame(plot, character))
	step()
	check(service:GetSnapshot(player).active, "reenter resumes training")
end, debug.traceback)
if ok then
	ok, err = xpcall(function()
		move(CFrame.new(plot.TrainingUpgradeAnchor.Position + Vector3.new(0, 3, 0)))
		step()
		isolated.Data.Wins = 0
		check(not service.Client:Upgrade(player, "Training_101").ok, "insufficient cash rejected")
		isolated.Data.Wins = 100000
		local upgraded = service.Client:Upgrade(player, "Training_101")
		check(upgraded.ok and isolated.Data.Wins == 99000, "upgrade debits once")
		check(isolated.Data.Training.TrainingID == "Training_102", "next barbell unlocked")
		check(plot.TrainingBarbellDisplay:GetAttribute("TrainingID") == "Training_102", "idle upgrade refreshes model")
		check(
			not service.Client:Upgrade(player, "Training_101").ok and isolated.Data.Wins == 99000,
			"duplicate upgrade rejected"
		)
		move(plot.AreaSpawnPoint.CFrame)
		step()
		check(not service.Client:Upgrade(player, "Training_102").ok, "remote upgrade rejected")
		local items = require(game.ReplicatedFirst.Data.TrainingData)
		local savedId = isolated.Data.Training.TrainingID
		for _, item in pairs(items) do
			isolated.Data.Training.TrainingID = item.TrainingID
			service:_syncDisplay(player, service:_state(player), plot)
			local model = plot.TrainingBarbellDisplay
			local box, size = model:GetBoundingBox()
			check(
				model:GetAttribute("TrainingID") == item.TrainingID
					and math.abs(box.Position.Y - size.Y / 2 - Spot.MarkerCFrame(plot).Position.Y) < 0.02,
				"grounded idle model " .. item.Model
			)
		end
		isolated.Data.Training.TrainingID = savedId
		plot:SetAttribute("OwnerUserId", 0)
		step()
		check(plot:FindFirstChild("TrainingBarbellDisplay") == nil, "unowned plot clears idle model")
		plot:SetAttribute("OwnerUserId", player.UserId)
		step()
		local function resume(age)
			local fake = { Character = character }
			table.insert(fakePlayers, fake)
			local data = copy(isolated.Data)
			data.Training.ResumeActive, data.Training.LastActiveAt = true, os.time() - age
			pd._Profiles[fake] = { Data = data }
			return service:ConsumeResumeSpawn(fake, plot, character)
		end
		check(resume(60) ~= nil, "recent reconnect restores own training spawn")
		check(resume(121) == nil, "expired reconnect uses normal spawn")
		move(Spot.SpawnCFrame(plot, character))
		step()
		isolated.Data.GamePasses.DoubleTrain = true
		isolated.Data.Training.Level, isolated.Data.Training.Xp = 1, 0
		step(0.5)
		check(service:GetSnapshot(player).xpPerRep == 4, "DoubleTrain doubles experience")
		check(isolated.Data.Training.Xp == 4, "double experience awarded")
		isolated.Data.Training.Level, isolated.Data.Training.Xp = maxLevel - 1, P.GetLevel(levels, maxLevel - 1).XpToNextLevel - 1
		step(0.5)
		check(isolated.Data.Training.Level == maxLevel and isolated.Data.Training.Xp == 0, "MAX caps experience")
		isolated.Data.Training.Level, isolated.Data.Training.Xp = 3, 0
		service:_publish(player)
		report({ ok = true, checks = checks, snapshot = service:GetSnapshot(player), isolated = true })
	end, debug.traceback)
end
if not ok then
	restore()
	report({ ok = false, error = tostring(err), checks = checks })
else
	-- Optional UI QA commands operate only on this throwaway profile.
	workspace:GetAttributeChangedSignal("TrainingUICommand"):Connect(function()
		if restored then
			return
		end
		local command = Http:JSONDecode(workspace:GetAttribute("TrainingUICommand"))
		local success, message = xpcall(function()
			service:Stop(player, true)
			move(plot.AreaSpawnPoint.CFrame)
			step()
			local settings = {
				Normal = { 1, 0, "Training_101", false, 100000 },
				Double = { 1, 0, "Training_101", true, 100000 },
				Level = { 1, firstLevelXp - 1, "Training_101", false, 100000 },
				Multi = { 1, firstLevelXp - 1, "Training_105", true, 100000 },
				Max = { maxLevel, 0, "Training_112", false, 0 },
				Poor = { 1, 0, "Training_101", false, 0 },
			}
			local setting = settings[command.kind]
			if setting then
				local training = isolated.Data.Training
				training.Level, training.Xp, training.TrainingID = setting[1], setting[2], setting[3]
				isolated.Data.GamePasses.DoubleTrain = setting[4]
				pd:AdjustWins(player, setting[5] - isolated.Data.Wins)
				service:_publish(player)
				move(Spot.SpawnCFrame(plot, character))
				step()
			end
		end, debug.traceback)
		workspace:SetAttribute(
			"TrainingUICommandResult",
			Http:JSONEncode({
				ok = success,
				error = if success then nil else tostring(message),
				kind = command.kind,
				seq = command.seq,
				snapshot = service:GetSnapshot(player),
			})
		)
	end)
end
