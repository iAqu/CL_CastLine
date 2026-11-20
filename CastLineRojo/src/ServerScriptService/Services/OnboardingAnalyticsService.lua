local AnalyticsService = game:GetService("AnalyticsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Service = Knit.CreateService({
	Name = "OnboardingAnalyticsService",
	Client = { GuidePresentation = Knit.CreateSignal() },
})

local FUNNEL = "CL_Onboarding_v1"
local DETAIL_EVENT = "CL_OnboardingDetail_v1"
local PROFILE_KEY = "OnboardingAnalyticsV1"
local IS_STUDIO = RunService:IsStudio()
local CUSTOM_FIELD_1 = Enum.AnalyticsCustomFieldKeys.CustomField01.Name
local CUSTOM_FIELD_2 = Enum.AnalyticsCustomFieldKeys.CustomField02.Name
local CUSTOM_FIELD_3 = Enum.AnalyticsCustomFieldKeys.CustomField03.Name

-- Steps and names are stable once published.
local steps = {
	{ "ProfileReady", "Profile ready" },
	{ "IntroClaimed", "Intro autoplay claimed" },
	{ "IntroCreated", "Intro session created" },
	{ "IntroStarted", "Intro playback started" },
	{ "IntroCast", "Intro cast accepted" },
	{ "IntroLanded", "Intro bait landed" },
	{ "IntroBite", "Intro hook window opened" },
	{ "IntroCaught", "Intro fish granted" },
	{ "FirstCatchStarted", "First lesson started" },
	{ "FirstCatchCast", "First lesson cast accepted" },
	{ "FirstCatchLanded", "First lesson bait landed" },
	{ "FirstCatchBite", "First lesson hook window opened" },
	{ "FirstCatchCaught", "First lesson fish granted" },
	{ "FishPlaced", "First fish placed" },
	{ "TrainingStarted", "Training started" },
	{ "TrainingLevel2", "Training level 2 reached" },
	{ "TrainingEnded", "Training ended" },
	{ "RodReady", "Upgraded rod ready" },
	{ "FinalCatchStarted", "Final lesson started" },
	{ "FinalBaitSelected", "Final lesson bait selected" },
	{ "FinalCatchCast", "Final lesson cast accepted" },
	{ "FinalCatchLanded", "Final lesson bait landed" },
	{ "FinalCatchBite", "Final lesson hook window opened" },
	{ "FinalCatchCaught", "Onboarding completed" },
}
local stepIndex = {}
for index, step in ipairs(steps) do
	stepIndex[step[1]] = index
end

local guideStages = {
	FirstLessonRoute = "FirstCatch",
	BackpackPrompt = "PlaceFish",
	HoldFishPrompt = "PlaceFish",
	FishHeld = "PlaceFish",
	PlacementRoute = "PlaceFish",
	PlacementPrompt = "PlaceFish",
	ReplacementFishRoute = "PlaceFish",
	TrainingRoute = "Train",
	TrainingPrompt = "Train",
	StopTrainingPrompt = "StopTraining",
	ResumeTrainingRoute = "StopTraining",
	RodShopRoute = "RodReward",
	RodShopOpened = "RodReward",
	RodRewardPrompt = "RodReward",
	FinalLessonRoute = "FinalCatch",
}

local openingPresentation = {
	FirstFrame = "Prepared",
	CastPrompt = "ReadyToCast",
	Casting = "Waiting",
	Flying = "Waiting",
	Approaching = "Waiting",
	Nibble1 = "Waiting",
	Nibble2 = "Waiting",
	EarlyHook = "Waiting",
	HookPrompt = "Waiting",
	Struggling = "Caught",
	Lifting = "Caught",
	Reveal = "Caught",
	ContinuePrompt = "Caught",
}
local lessonPresentation = table.clone(openingPresentation)
lessonPresentation.FirstFrame = nil
lessonPresentation.CastPrompt = "Preparing"
lessonPresentation.BaitPrompt = "Selecting"
for _, id in { "Struggling", "Lifting", "Reveal", "ContinuePrompt" } do
	lessonPresentation[id] = "Claimed"
end

local sessions = {}
local growthQueue = {}
local growthHead, growthTail = 1, 0
local MAX_GROWTH_EVENTS = 512
local BURST = 60
local tokens, lastRefill = BURST, os.clock()
local lastWarning = -math.huge
local fishingSample = Random.new()

local function fields(first, second, third)
	return {
		[CUSTOM_FIELD_1] = first and tostring(first),
		[CUSTOM_FIELD_2] = second and tostring(second),
		[CUSTOM_FIELD_3] = third and tostring(third),
	}
end

local function activeSession(player)
	local session = sessions[player]
	return if session and session.Profile:IsActive() then session else nil
end

function Service:IsNewPlayer(player)
	local session = activeSession(player)
	return session ~= nil and session.Onboarding ~= nil
end

function Service:Initialize(player, profile)
	if sessions[player] then
		return
	end
	local saved = profile.Data[PROFILE_KEY]
	if saved == nil and profile.MetaData.SessionLoadCount == 1 then
		saved = { Observed = {}, Sent = 0, Details = {} }
		if not IS_STUDIO then
			profile.Data[PROFILE_KEY] = saved
		end
	elseif saved and IS_STUDIO then
		saved = { Observed = table.clone(saved.Observed), Sent = saved.Sent, Details = table.clone(saved.Details) }
	end
	sessions[player] = {
		Profile = profile,
		Onboarding = saved,
		ClientTokens = 16,
		ClientAt = os.clock(),
		Events = if IS_STUDIO then {} else nil,
	}
	self:Step(player, "ProfileReady")
end

function Service:Step(player, step)
	local session = activeSession(player)
	local index = stepIndex[step]
	if session and session.Onboarding and index then
		session.Onboarding.Observed[step] = true
	end
end

function Service:Detail(player, group, detail)
	local session = activeSession(player)
	local saved = session and session.Onboarding
	if saved then
		local key = group .. "/" .. detail
		if saved.Details[key] == nil then
			saved.Details[key] = false
		end
	end
end

local function acceptPresentation(player)
	local session = activeSession(player)
	if not session or not session.Onboarding then
		return nil
	end
	local now = os.clock()
	session.ClientTokens = math.min(16, session.ClientTokens + (now - session.ClientAt) * 4)
	session.ClientAt = now
	if session.ClientTokens < 1 then
		return nil
	end
	session.ClientTokens -= 1
	return session
end

function Service:FishingPresentation(player, group, phase, round, detail)
	if type(detail) ~= "string" then
		return
	end
	local allowed = if group == "Intro" then openingPresentation else lessonPresentation
	local required = allowed[detail]
	if not required or required ~= phase then
		return
	end
	if (detail == "Approaching" or detail == "Nibble1" or detail == "Nibble2"
		or detail == "EarlyHook" or detail == "HookPrompt") and round < 1
	then
		return
	end
	if acceptPresentation(player) then
		self:Detail(player, group, detail)
	end
end

function Service:Growth(player, eventName, value, first, second, third)
	if not activeSession(player) or growthTail - growthHead + 1 >= MAX_GROWTH_EVENTS
		or type(value) ~= "number" or value ~= value or math.abs(value) == math.huge
	then
		return
	end
	growthTail += 1
	growthQueue[growthTail] = {
		Player = player, Name = eventName, Value = value, Fields = fields(first, second, third),
	}
end

function Service:SampleFishingCast()
	-- Use an independent RNG so analytics cannot change catch rolls.
	return IS_STUDIO or fishingSample:NextInteger(1, 4) == 1
end

function Service:_send(player, session, event)
	if IS_STUDIO then
		local events = session.Events
		if #events == 128 then
			table.remove(events, 1)
		end
		table.insert(events, event)
	elseif event.Step then
		AnalyticsService:LogFunnelStepEvent(player, FUNNEL, "", event.Step, event.Name)
	else
		AnalyticsService:LogCustomEvent(player, event.Name, event.Value, event.Fields)
	end
end

local function send(player, session, event)
	tokens -= 1
	local ok, reason = pcall(Service._send, Service, player, session, event)
	if not ok and os.clock() - lastWarning >= 60 then
		lastWarning = os.clock()
		warn("OnboardingAnalyticsService: " .. tostring(reason))
	end
	return ok
end

function Service:Pump()
	local now = os.clock()
	local rate = (60 + 15 * #Players:GetPlayers()) / 60
	tokens = math.min(BURST, tokens + (now - lastRefill) * rate)
	lastRefill = now

	-- Every player can advance one step per pass, before detail or growth traffic.
	for player in pairs(sessions) do
		if tokens < 1 then
			return
		end
		local session = activeSession(player)
		local saved = session and session.Onboarding
		if saved and now >= (session.FunnelRetryAt or 0) then
			local index = saved.Sent + 1
			local step = steps[index]
			if step and saved.Observed[step[1]] then
				if send(player, session, { Step = index, Name = step[2] }) then
					saved.Sent = index
					session.FunnelFailures, session.FunnelRetryAt = nil, nil
				else
					session.FunnelFailures = math.min(6, (session.FunnelFailures or 0) + 1)
					session.FunnelRetryAt = now + 2 ^ session.FunnelFailures
				end
			end
		end
	end

	-- Share the remaining budget between new-player details and growth.
	for player in pairs(sessions) do
		if tokens < 2 then
			break
		end
		local session = activeSession(player)
		local saved = session and session.Onboarding
		if saved and now >= (session.DetailRetryAt or 0) then
			for key, sent in pairs(saved.Details) do
				if not sent then
					local group, detail = string.match(key, "^([^/]+)/(.+)$")
					if send(player, session, { Name = DETAIL_EVENT, Value = 1, Fields = fields(group, detail) }) then
						saved.Details[key] = true
					else
						session.DetailRetryAt = now + 10
					end
					break
				end
			end
		end
	end

	while tokens >= 1 and growthHead <= growthTail do
		local event = growthQueue[growthHead]
		growthQueue[growthHead] = nil
		growthHead += 1
		local session = activeSession(event.Player)
		if session then
			send(event.Player, session, event)
		end
	end
	if growthHead > growthTail then
		growthHead, growthTail = 1, 0
	end
end

function Service:GetStudioSnapshot(player)
	local session = sessions[player]
	if not IS_STUDIO or not session then
		return nil
	end
	local saved = session.Onboarding
	return {
		Sent = saved and saved.Sent,
		Observed = saved and table.clone(saved.Observed),
		Details = saved and table.clone(saved.Details),
		Events = table.clone(session.Events),
	}
end

function Service:KnitInit()
	Players.PlayerRemoving:Connect(function(player)
		sessions[player] = nil
	end)
	self.Client.GuidePresentation:Connect(function(player, detail)
		local required = if type(detail) == "string" then guideStages[detail] else nil
		if not required then
			return
		end
		local session = acceptPresentation(player)
		local progress = session and session.Profile.Data.FishingOnboarding
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if progress and progress.Stage == required and humanoid and humanoid.Health > 0 then
			self:Detail(player, "Guide", detail)
		end
	end)
end

function Service:KnitStart()
	if IS_STUDIO and workspace:GetAttribute("StudioUseMockProfiles") == true then
		-- The Studio command context cannot read the running Knit module's local state.
		local snapshot = Instance.new("BindableFunction")
		snapshot.Name = "OnboardingAnalyticsSnapshot"
		snapshot.OnInvoke = function(player)
			return self:GetStudioSnapshot(player)
		end
		snapshot.Parent = game:GetService("ServerStorage")
	end
	task.spawn(function()
		while true do
			self:Pump()
			task.wait(0.25)
		end
	end)
end

return Service
