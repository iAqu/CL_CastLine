local function loadSource(path, environment)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end
local root = "src/ReplicatedStorage/Modules/"
local function new()
	local h = {
		now = 100,
		sample = 0.5,
		guid = 0,
		grants = 0,
		cashRefreshes = 0,
		equippedCatches = {},
		failGrant = false,
		activeEvent = nil,
		ready = true,
		footZ = 0,
	}
	local function signal()
		local callbacks = {}
		return {
			Connect = function(_, callback)
				callbacks[callback] = true
				return { Disconnect = function() callbacks[callback] = nil end }
			end,
			Fire = function(_, ...)
				for callback in pairs(callbacks) do
					callback(...)
				end
			end,
		}
	end
	local function instance(class, children)
		return {
			GetAttribute = function(self, name) return self[name] end,
			SetAttribute = function(self, name, value) self[name] = value end,
			IsA = function(_, name)
				return name == class
			end,
			FindFirstChild = function(_, name)
				return children and children[name]
			end,
			FindFirstChildOfClass = function(_, name)
				return children and children[name]
			end,
		}
	end
	local function vector(x, y, z)
		return setmetatable({ X = x or 1, Y = y or 2, Z = z or 3 }, {
			__mul = function(a, b)
				return vector(a.X * b, a.Y * b, a.Z * b)
			end,
			__sub = function()
				return vector()
			end,
		})
	end
	local start = instance("BasePart")
	start.Size = { X = 10, Y = 1, Z = 10 }
	start.CFrame = {
		PointToObjectSpace = function()
			return { X = 0, Y = 0.5, Z = h.footZ }
		end,
	}
	local rootPart = instance("BasePart")
	rootPart.Position = vector()
	rootPart.Size = { Y = 2 }
	h.humanoid = { Health = 100, HipHeight = 2, RigType = "R15", Died = signal() }
	h.player = {
		UserId = 12,
		GetNetworkPing = function() return h.networkPing or 0 end,
		Character = instance("Model", { HumanoidRootPart = rootPart, Humanoid = h.humanoid }),
		CharacterRemoving = signal(),
		GetAttribute = function(self, name) return self[name] end,
		SetAttribute = function(self, name, value)
			self[name] = value
		end,
	}
	h.plot = instance("Model", { FishingStartPart = start })
	h.plot.Name, h.plot.OwnerUserId = "Plot_1", h.player.UserId
	h.slotReleased, h.playerRemoving = signal(), signal()
	h.profile =
		{ Data = { Wins = 100000, OwnedRods = { Rod_101 = true, Rod_102 = true, Rod_103 = true }, EquippedRodId = "Rod_101" } }
	h.profile.MetaData = { MetaTags = {}, MetaTagsLatest = {} }
	function h.profile:IsActive()
		return h.ready
	end
	function h.profile:SetMetaTag(key, value)
		self.MetaData.MetaTags[key] = value
	end
	function h.profile:Save()
		h.saveCalls = (h.saveCalls or 0) + 1
		if not h.pauseSave then
			self.MetaData.MetaTagsLatest = table.clone(self.MetaData.MetaTags)
		end
	end
	h.purchaseData = loadSource("src/ReplicatedFirst/Data/PurchaseData.lua")
	h.prompts = {}
	h.rods = loadSource("src/ReplicatedFirst/Data/RodsData.lua")
	h.baits = loadSource("src/ReplicatedFirst/Data/BaitsData.lua")
	h.fishes = {}
	for i = 1, 30 do
		local id = "Fish_" .. tostring(100 + i)
		h.fishes[id] = {
			FishID = id,
			Model = id,
			Rarity = if i <= 10 then "Common" elseif i <= 20 then "Uncommon" else "Rare",
			Index = i,
			DefaultWeight = i,
			RollWeight = 1,
			LuckExponent = i,
		}
	end
	h.fishes.Event = { FishID = "Event", Model = "Event", Rarity = "Event", Index = 100, DefaultWeight = 10 }
	h.progression = loadSource(root .. "FishingProgression.lua", setmetatable({
 script={Parent={FishingConfig=loadSource(root.."FishingConfig.lua")}},require=function(v) return v end,
},{__index=getfenv()}))
	h.baitConfig = loadSource(root .. "FishingBaitConfig.lua")
	local config = loadSource(root .. "FishingConfig.lua")
	local petConfig = loadSource(root .. "PetFeatureConfig.lua")
	h.roll = loadSource(
		root .. "FishingRoll.lua",
		setmetatable({
			script = { Parent = { FishingConfig = config, PetFeatureConfig = petConfig } },
			require = function(v)
				return v
			end,
		}, { __index = getfenv() })
	)
	h.rng = {
		NextNumber = function()
			return h.sample
		end,
		NextInteger = function()
			return 1
		end,
	}
	h.assets = {
		GetRod = function()
			return {}
		end,
		GetFish = function()
			return {}
		end,
		GetBait = function()
			return { Size = vector() }
		end,
	}
	local modules = {
		TrainingProgress = loadSource(root .. "TrainingProgress.lua"),
		FishingOnboarding = loadSource(root .. "FishingOnboarding.lua"),
		FishingConfig = config,
		PetFeatureConfig = petConfig,
		FishingAssets = h.assets,
		FishingRoll = h.roll,
		FishingProgression = h.progression,
		FishingBaitConfig = h.baitConfig,
		FishingBiteSequence = {
			GetBiteWindow = function(_, size, _, ready, _, _, _, fish)
				h.biteSize = size
				h.biteFish = fish
				return ready + 1, ready + 2, 3
			end,
		},
		FishingProjectileMath = {
			FlightTime = function()
				return 1
			end,
		},
	}
	modules.RodInventory = {
		GetEquippedId = function(data)
			return data.EquippedRodId or "Rod_101"
		end,
	}
	modules.FishingSpotUtil = loadSource(
		root .. "FishingSpotUtil.lua",
		setmetatable(
			{ Enum = { HumanoidRigType = { R6 = "R6" } }, Vector3 = { yAxis = vector() } },
			{ __index = getfenv() }
		)
	)
	h.fishingSpot = modules.FishingSpotUtil
	local data = {
		FishesData = h.fishes,
		BaitsData = h.baits,
		RodsData = h.rods,
		TrainingLevelsData = loadSource("src/ReplicatedFirst/Data/TrainingLevelsData.lua"),
		MutationsData = loadSource("src/ReplicatedFirst/Data/MutationsData.lua"),
	}
	h.playerData = {
		GetProfile = function()
			return if h.ready then h.profile else nil
		end,
		AdjustWins = function(_, _, amount)
			h.profile.Data.Wins += amount
			h.cashRefreshes += 1
			return true
		end,
	}
	h.analytics = {}
	local function recordAnalytics(kind, ...)
		table.insert(h.analytics, { kind, ... })
	end
	local delayed, encoded = {}, {}
	local services = {
		MarketplaceService = {
			PromptProductPurchase = function(_, player, productId)
				assert(player == h.player)
				table.insert(h.prompts, productId)
				if h.onPrompt then
					h.onPrompt()
				end
			end,
		},
		RunService = { IsStudio = function() return h.studio == true end },
		HttpService = {
			JSONEncode = function(_, value)
				table.insert(encoded, table.clone(value))
				return tostring(#encoded)
			end,
			JSONDecode = function(_, value)
				return encoded[tonumber(value)]
			end,
			GenerateGUID = function()
				h.guid += 1
				return "guid" .. h.guid
			end,
		},
		Players = { PlayerAdded = signal(), PlayerRemoving = h.playerRemoving, GetPlayers = function() return { h.player } end },
		Workspace = {
			GetServerTimeNow = function()
				return h.now
			end,
		},
		ReplicatedFirst = {
			Data = { PurchaseData = h.purchaseData },
			WaitForChild = function()
				return {
					WaitForChild = function(_, name)
						return data[name]
					end,
				}
			end,
		},
		ReplicatedStorage = {
			Modules = modules,
			Packages = {
				Knit = {
					CreateSignal = signal,
					CreateService = function(v)
						return v
					end,
					GetService = function(name)
						if name == "TrainingService" then
							return { Stop = function() end, GetMaxCatchWeight = function() return h.maxCatchWeight or 10 end }
						end
						if name == "PlotSlotService" then
							return {
								SlotReleased = h.slotReleased,
								GetPlayerPlot = function()
									return h.plot
								end,
							}
						end
						if name == "EventFishService" then
							return {
								GetActiveFish = function(_, now)
									local window = h.eventWindow
									if window and now >= window.StartsAt and now < window.EndsAt then
										return h.activeEvent, window
									end
								end,
							}
						end
						if name == "FishingIntroService" then
							return { IsActive = function() return h.introActive == true end }
						end
						return {
							GetLuckMultiplier = function()
								return 1
							end,
						}
					end,
				},
			},
		},
	}
	h.env = setmetatable({
		game = {
			GameId = h.baitConfig.PurchaseUniverseId,
			GetService = function(_, name)
				return services[name]
			end,
		},
		require = function(v)
			return v
		end,
		Random = {
			new = function()
				return h.rng
			end,
		},
		Vector3 = { zero = vector(0, 0, 0) },
		Enum = { ProductPurchaseChannel = { ExperienceDetailsPage = "ExperienceDetailsPage" } },
		os = { clock = function() return h.now end },
		task = {
			wait = function(seconds)
				h.now += seconds
				if h.onWait then
					h.onWait()
				end
			end,
			delay = function(seconds, callback)
				table.insert(delayed, { at = h.now + seconds, callback = callback })
			end,
		},
		warn = function() end,
		script = {
			Parent = {
				PlayerDataService = h.playerData,
				PaidItemPolicy = {
					Get = function()
						return if h.noPolicy then nil else { ArePaidRandomItemsRestricted = h.restrictPaid == true }
					end,
				},
				OnboardingAnalyticsService = {
					Step = function(_, _, ...) recordAnalytics("Step", ...) end,
					Detail = function(_, _, ...) recordAnalytics("Detail", ...) end,
					Growth = function(_, _, ...) recordAnalytics("Growth", ...) end,
					IsNewPlayer = function() return h.newAnalyticsPlayer == true end,
					SampleFishingCast = function() return h.sampleAnalyticsCast == true end,
				},
				ItemGrantUtil = {
					EquipCaughtFish = function(player, character, uid)
						assert(player == h.player and character == h.player.Character)
						table.insert(h.equippedCatches, uid)
					end,
					Grant = function(_, id, options)
						if h.onGrant then
							h.onGrant(options)
						end
						if h.failGrant then
							return nil, "Backpack unavailable"
						end
						local ok, reason = options.BeforeCommit()
						if not ok then
							return nil, reason
						end
						h.grants += 1
						h.lastOptions = options
						h.lastFish = id
						options.OnCommitted()
					if h.afterGrant then
						h.afterGrant()
					end
						if h.throwAfterCommit then
							error("Presentation unavailable")
						end
						return { Weight = options.Weight, MutationId = options.MutationId, IsNewDiscovery = true }
					end,
				},
			},
		},
	}, { __index = getfenv() })
	modules.FishingObserverState = loadSource(root .. "FishingObserverState.lua", h.env)
	h.env.script.Parent.PurchasePersistence =
		require("./helpers/PurchasePersistenceMock")(h.env.os.clock, h.env.task.wait)
	h.purchases = loadSource("src/ServerScriptService/Services/FishingBaitPurchases.lua", h.env)
	h.env.script.Parent.FishingBaitPurchases = h.purchases
	function h.reload()
		h.service = loadSource("src/ServerScriptService/Services/FishingService.lua", h.env)
		h.client = h.service.Client
		local selectBait = h.client.SelectBait
		function h.client:SelectBait(player, token, bait, purchaseOnSelect)
			local result = selectBait(self, player, token, bait, purchaseOnSelect)
			if result.ok then
				h.meterStartsAt = result.meterStartsAt
			end
			return result
		end
	end
	function h.presentation()
		return modules.FishingObserverState.Decode(h.player.Character:GetAttribute(modules.FishingObserverState.Attribute))
	end
	function h.advance(seconds)
		h.now += seconds
		for index = #delayed, 1, -1 do
			if delayed[index].at <= h.now then
				table.remove(delayed, index).callback()
			end
		end
	end
	h.reload()
	function h.begin(bait)
		local r = h.client:Begin(h.player)
		assert(r.ok, r.message)
		h.token = r.token
		h.beginResult = r
		if bait then
			local s = h.client:SelectBait(h.player, h.token, bait)
			assert(s.ok, s.message)
		end
		return r
	end
	function h.castAt(progress)
		local meter = config.Meter
		local acceleration = meter.BaseSpeed * (meter.TopSpeedFactor - 1)
		local period = 2 * math.log(meter.TopSpeedFactor) / acceleration
		local elapsed = math.log(1 + (meter.TopSpeedFactor - 1) * (progress or 1)) / acceleration
		local cycles = math.max(0, math.ceil((h.now - h.meterStartsAt - elapsed) / period))
		h.now = h.meterStartsAt + cycles * period + elapsed + (h.networkPing or 0) / 2
		return h.client:Cast(h.player, h.token)
	end
	function h.cast()
		assert(h.castAt(1).ok)
		h.now += 5
		local timerCount = #delayed
		local r = h.client:NextRound(h.player, h.token, 0)
		local biteTimer = delayed[timerCount + 1]
		h.fireBiteTimer = biteTimer and biteTimer.callback
		assert(r.ok, r.message)
		h.round = r
		return r
	end
	function h.hook()
		h.now = h.round.readyAt + 1.1
		return h.client:Hook(h.player, h.token, h.round.round, h.now)
	end
	function h.cancel()
		h.client:Cancel(h.player, h.token)
	end
	return h
end
return new
