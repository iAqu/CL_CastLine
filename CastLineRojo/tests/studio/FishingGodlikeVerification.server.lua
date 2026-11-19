-- Studio-only isolated-profile integration test. Temporarily copy into ServerScriptService through Rojo.
if not game:GetService("RunService"):IsStudio() then
	return
end
local RS, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local Knit = require(RS.Packages.Knit)
local Config = require(RS.Modules.FishingConfig)
local Projectile = require(RS.Modules.FishingProjectileMath)
local Http = game:GetService("HttpService")
local pd, player, original
local deadline = os.clock() + 50
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
until original or os.clock() > deadline
local function report(result)
	workspace:SetAttribute("FishingGodlikeVerification", Http:JSONEncode(result))
end
if not original then
	report({ ok = false, error = "Live profile did not become ready" })
	return
end
local function copy(v)
	if type(v) ~= "table" then
		return v
	end
	local out = {}
	for k, item in pairs(v) do
		out[k] = copy(item)
	end
	return out
end
local profile = {
	Data = copy(original.Data),
	MetaData = { SessionLoadCount = 2 },
	IsActive = function()
		return true
	end,
}
profile.Data.EquippedRodId = "Rod_101"
profile.Data.Wins = 100000
profile.Data.FishingOnboarding = { Stage = "Complete" }
local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
local spot = plot and plot:FindFirstChild("FishingStartPart", true)
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not spot or not root or not humanoid then
	report({ ok = false, error = "Fishing spot or character missing" })
	return
end
local oldPivot, anchored = character:GetPivot(), root.Anchored
local service = Knit.GetService("FishingService").Client
local token
local checks = {}
local ok, err = xpcall(function()
	pd._Profiles[player] = profile
	root.Anchored = true
	for _, progress in ipairs({ 0.95, 0.950001 }) do
		character:PivotTo(spot.CFrame + Vector3.new(0, spot.Size.Y / 2 + humanoid.HipHeight + root.Size.Y / 2, 0))
		local b = service:Begin(player)
		assert(b.ok, b.message)
		token = b.token
		assert(service:SelectBait(player, token, "NONE").ok)
		assert(not service:Cast(player, token).ok, "Missing progress must be rejected")
		local response = service:Cast(player, token, progress)
		assert(response.ok and response.castRating == Config.GetCastRating(progress).Id)
		assert(not service:Cast(player, token, 1 - progress).ok, "Duplicate cast changed its grade")
		local castAt = workspace:GetServerTimeNow()
		local normal = Config.CastProfiles.Normal
		local special = Config.GetCastProfile(response.castRating)
		task.wait(normal.LeadTime + normal.ReleaseTime + Projectile.FlightTime(Config.FixedCastDistance) + 0.03)
		local early = service:NextRound(player, token, 0)
		assert(early.ok == (progress == 0.95), "Wrong earliest landing for selected animation")
		if not early.ok then
			task.wait(
				math.max(
					0,
					castAt
						+ special.LeadTime
						+ special.ReleaseTime
						+ Projectile.FlightTime(Config.FixedCastDistance)
						+ 0.03
						- workspace:GetServerTimeNow()
				)
			)
			local round = service:NextRound(player, token, 0)
			assert(round.ok and round.castRating == response.castRating, "Special cast failed after its landing")
		end
		table.insert(checks, { progress = progress, rating = response.castRating })
		service:Cancel(player, token)
	end
end, debug.traceback)
if token then
	service:Cancel(player, token)
end
pd._Profiles[player] = original
root.Anchored = anchored
character:PivotTo(oldPivot)
pd:AdjustWins(player, 0)
report({ ok = ok, error = if ok then nil else err, checks = checks, restored = pd:GetProfile(player) == original })
