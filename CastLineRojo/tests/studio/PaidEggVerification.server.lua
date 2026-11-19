-- Temporarily copy into ServerScriptService through Rojo for an isolated playtest.
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
assert(
	RunService:IsStudio() and workspace:GetAttribute("StudioUseMockProfiles") == true,
	"Enable isolated Studio profiles first"
)

local function report(value)
	workspace:SetAttribute("PaidEggVerificationServer", HttpService:JSONEncode(value))
end

local function waitUntil(check, seconds, message)
	local expires = os.clock() + seconds
	repeat
		local result = check()
		if result then
			return result
		end
		task.wait()
	until os.clock() >= expires
	error(message)
end

report({ phase = "Waiting for Knit" })
local ok, message = xpcall(function()
	local Knit = require(ReplicatedStorage.Packages.Knit)
	Knit.OnStart():expect()
	local pd = require(game.ServerScriptService.Services.PlayerDataService)
	local player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()
	local profile = waitUntil(function()
		return pd:GetProfile(player)
	end, 45, "No player profile")
	assert(profile._is_user_mock == true, "Verification requires an isolated profile")
	profile.Data.FishingIntroVersion = 999
	local service = Knit.GetService("PaidEggService")
	local modules = ReplicatedStorage.Modules
	local Config = require(modules.PaidEggConfig)
	local Training = require(modules.TrainingProgress)
	local purchase = require(game.ReplicatedFirst.Data.PurchaseData)
	local fish = require(game.ReplicatedFirst.Data.FishesData)

	local remote = Instance.new("RemoteEvent")
	remote.Name = "PaidEggVerification"
	local events = {}
	remote.OnServerEvent:Connect(function(sender, kind, id, value)
		if sender == player then
			events[kind .. id] = value or true
		end
	end)
	remote.Parent = ReplicatedStorage
	waitUntil(function()
		return events.Ready0
	end, 40, "Client never became ready")

	local results = {}
	for index, scenario in ipairs({ { 1, 0.1 }, { 3, 3 }, { 10, 8.5 }, { 10, 0.1, true } }) do
		local quantity, delay, gift = table.unpack(scenario)
		local key = "studio-" .. HttpService:GenerateGUID(false)
		local purchaseId = Config.PurchaseOrder[math.min(index, 3)]
		local productId = Config.GetPurchase(purchaseId, purchase).ProductId
		local rewards = Config.Roll(quantity, 100, fish, Random.new(quantity), Training.CalculateFishWeight)
		for i, reward in ipairs(rewards) do
			if i == 1 then
				reward.ItemId = if index == 2 then "Fish_004" elseif index >= 3 then "Fish_005" else "Fish_001"
			end
			reward.InstanceId = key .. ":" .. i
		end
		local order = {
			OrderId = key,
			PurchaseId = purchaseId,
			ProductId = productId,
			RecipientUserId = player.UserId,
			BuyerUserId = if gift then player.UserId + 1 else player.UserId,
			SenderName = player.DisplayName,
			CreatedAt = os.time(),
			Rewards = rewards,
		}
		local function count()
			local n = 0
			for _, record in pairs(profile.Data.Items) do
				if record.PaidOrigin == key then
					n += 1
				end
			end
			return n
		end
		report({ phase = "Simulating", quantity = quantity, results = results })
		if not gift then
			service.Client.PromptPrepared:Fire(player, productId, quantity, true)
		end
		remote:FireClient(player, index, productId, key, quantity, delay, gift == true)
		waitUntil(function()
			return events["Started" .. index]
		end, 5, "Prompt simulation did not start")
		task.wait(delay)
		assert(count() == 0, "Inventory changed before receipt")
		assert(pd:QueuePaidEggDelivery(player.UserId, order), "Mock mailbox write failed")
		assert(pd:QueuePaidEggDelivery(player.UserId, order), "Mock mailbox replay failed")
		if gift then
			-- Simulate the sender's independent success notification alongside mailbox delivery.
			service.Client.PurchaseCompleted:Fire(
				player,
				{ OrderId = key .. "-sent", IsGift = true, Quantity = quantity }
			)
			service.Client.PurchaseCompleted:Fire(
				player,
				{ OrderId = key .. "-sent", IsGift = true, Quantity = quantity }
			)
		else
			service:_stage(player, nil, order)
			service:_stage(player, nil, order)
		end
		profile:Save()
		waitUntil(function()
			local n = count()
			assert(n == 0 or n == quantity, "Part of the order became visible")
			return n == quantity
		end, 30, "Fish never reached inventory")
		waitUntil(function()
			return events["Finished" .. index] and not profile.Data.PaidEgg.Results[key]
		end, 18, "Client did not close and acknowledge presentation")
		assert(service:RevealResult(player, key), "Duplicate release failed")
		assert(count() == quantity, "Duplicate release changed quantity")
		table.insert(
			results,
			{ quantity = quantity, delay = delay, inventory = count(), client = events["Finished" .. index] }
		)
	end
	report({ ok = true, isolated = true, results = results })
end, debug.traceback)
if not ok then
	report({ ok = false, error = tostring(message) })
	warn("PaidEggVerification: " .. tostring(message))
end
