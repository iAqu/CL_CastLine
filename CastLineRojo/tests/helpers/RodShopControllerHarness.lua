local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback)
			table.insert(callbacks, callback)
			return { Disconnect = function() end }
		end,
		Fire = function(_, ...)
			for _, callback in ipairs(callbacks) do callback(...) end
		end,
		Wait = function() end,
	}
end

local function deferred()
	local success, failure, done = {}, {}, {}
	local status, value = "Pending", nil
	local promise = {}
	function promise:andThen(callback)
		if status == "Resolved" then callback(value) else table.insert(success, callback) end
		return self
	end
	function promise:catch(callback)
		if status == "Rejected" then callback(value) else table.insert(failure, callback) end
		return self
	end
	function promise:finally(callback)
		if status ~= "Pending" then callback() else table.insert(done, callback) end
		return self
	end
	local function resolve(result)
		status, value = "Resolved", result
		for _, callback in ipairs(success) do callback(result) end
		for _, callback in ipairs(done) do callback() end
	end
	return promise, resolve
end

local function resolved(value)
	local promise, resolve = deferred()
	resolve(value)
	return promise
end

local Node = {}
function Node:IsA(class) return self.ClassName == class or (class == "GuiButton" and self.ClassName == "TextButton") end
function Node:FindFirstChild(name)
	for _, child in ipairs(self.children) do if child.Name == name then return child end end
	return nil
end
function Node:WaitForChild(name) return self:FindFirstChild(name) end
function Node:GetChildren() return self.children end
function Node:GetPropertyChangedSignal(name)
	self.events[name] = self.events[name] or signal()
	return self.events[name]
end
function Node:GetAttribute(name) return self.attributes[name] end
function Node:Destroy() self.Parent = nil end
function Node:PivotTo() end
function Node:GetPivot() return self.CFrame end
local function node(class, name, parent)
	local self = setmetatable({ props = { ClassName = class, Name = name, Visible = true }, children = {}, events = {}, attributes = {} }, {
		__index = function(n, key)
			if n.props[key] ~= nil then return n.props[key] end
			return Node[key] or n:FindFirstChild(key)
		end,
		__newindex = function(n, key, value)
			local previous = n.props[key]
			if key == "Parent" then
				if previous then table.remove(previous.children, table.find(previous.children, n)) end
				if value then table.insert(value.children, n) end
			end
			n.props[key] = value
			if previous ~= value and n.events[key] then n.events[key]:Fire() end
		end,
	})
	self.Parent = parent
	return self
end

local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment))()
end

return function(initialCash)
	local h = { inside = false, teleports = 0, requests = {}, purchases = {}, delayed = {}, modal = false }
	local cf = setmetatable({}, { __mul = function(a) return a end })
	function cf:ToObjectSpace() return self end
	local function character()
		return {
			FindFirstChildOfClass = function() return h.humanoid end,
			FindFirstChild = function() return { CFrame = cf } end,
			GetPivot = function() return cf end,
		}
	end
	h.humanoid = { Health = 100 }
	local playerGui = node("PlayerGui", "PlayerGui")
	local gui = node("ScreenGui", "RodShopGui", playerGui)
	gui.Enabled = false
	local main = node("Frame", "Main", gui)
	local frame = node("Frame", "MainFrame", main)
	local list = node("ScrollingFrame", "ScrollingFrame", frame)
	list.CanvasPosition = { X = 0, Y = 0 }
	list.AbsolutePosition = { X = 0, Y = 0 }
	list.AbsoluteWindowSize = { X = 300, Y = 300 }
	list.AbsoluteCanvasSize = { X = 1000, Y = 1000 }
	local top = node("Frame", "Top", main)
	local closeButton = node("TextButton", "CloseButton", top)
	closeButton.Activated = signal()
	local template = node("Frame", "RodTemplate", list)
	template.PriceLabel = {}
	template.Information = { GetChildren = function() return {} end }
	local cards = {}
	function template:Clone()
		local card = node("Frame", "RodTemplate")
		card.NameLabel, card.RarityLabel = {}, {}
		local weight = { Name = "Weight", Visible = true, Counter = {} }
		card.Information = { GetChildren = function() return { weight } end, Luck = { Counter = {} }, Weight = weight }
		for _, name in ipairs({ "BuyButton", "EquipButton", "EquipedButton" }) do
			local button = node("TextButton", name, card)
			button.TextLabel = {}
			button.Activated = signal()
		end
		node("UIGradient", "Gradient_CanBuy", card.BuyButton).Enabled = true
		node("UIGradient", "Gradient_CannotBuy", card.BuyButton).Enabled = false
		card.RodImage = {}
		card.AbsolutePosition, card.AbsoluteSize = { X = 450, Y = 450 }, { X = 100, Y = 100 }
		table.insert(cards, card)
		return card
	end
	local anchor = node("BasePart", "RodShopAnchor")
	anchor.CFrame = cf
	local shopTemplate = node("Model", "RodShop")
	shopTemplate.CFrame = cf
	local circle = node("BasePart", "ActivationCircle", shopTemplate)
	circle.CFrame = cf
	function shopTemplate:Clone() return node("Model", "RodShop") end
	local templates = node("Folder", "PlotTemplates")
	shopTemplate.Parent = templates
	local plot = { GetAttribute = function() return 42 end }
	local player = { UserId = 42, Character = character() }
	local onboarding = dofile("src/ReplicatedStorage/Modules/FishingOnboarding.lua")
	local stage = "Complete"
	local stageChanged = signal()
	local stats = node("Folder", "leaderstats")
	local cash = node("NumberValue", "💵Cash", stats)
	cash.Value = initialCash or 0
	function player:GetAttribute(name)
		if name == onboarding.StageAttribute then return stage end
		return if name == "PlotSlotId" then 1 elseif name == "EquippedRodId" then "a" else true
	end
	function player:GetAttributeChangedSignal(name)
		return if name == onboarding.StageAttribute then stageChanged else signal()
	end
	function player:WaitForChild(name)
		return if name == "leaderstats" then stats else playerGui
	end
	local heartbeat = signal()
	local service = { InventoryChanged = signal() }
	function service:GetState()
		local promise, resolve = deferred()
		table.insert(h.requests, resolve)
		return promise
	end
	function service:BuyRod(id)
		local promise, resolve = deferred()
		table.insert(h.purchases, { id = id, resolve = resolve })
		return promise
	end
	local modules = {
		FishingConfig = { RodWeightLimitEnabled = true },
		FishingOnboarding = onboarding,
		ButtonAnimation = { SetUp = function() end },
		CharacterUtil = { TeleportTo = function() h.inside = true; h.teleports += 1 end },
		FishingAssets = { GetRod = function() return true end },
		GameplayInputGate = { IsWorldActionAllowed = function() return not h.modal end },
		GuiAnimation = {
			IsAllPopupGuisClosed = function() return not h.modal and not gui.Enabled end,
			OpenGui = function() gui.Enabled = true end,
			CloseGui = function() gui.Enabled = false end,
			SetNavigationOptions = function() end,
		},
		GuiUtil = { SetRarityGradient = function() end },
		IndexItemViewport = {},
		NotificationClient = { RedNotify = function(message) h.error = message end, GreenNotify = function() end },
		NumberUtil = { FormatNumberStartKWithDecimal = tostring },
		WeightFormat = require("../src/ReplicatedStorage/Modules/WeightFormat"),
		PlotWorkspaceUtil = { getPlotBySlot = function() return plot end },
		RodShopZone = {
			ExitMargin = 2,
			GetAnchor = function() return anchor end,
			Contains = function() return h.inside end,
			GetEntryCFrame = function() return if h.humanoid.Health > 0 then cf else nil end,
		},
		RodShopClientState = require("../src/ReplicatedStorage/Modules/RodShopClientState"),
		RodShopFocus = require("../src/ReplicatedStorage/Modules/RodShopFocus"),
	}
	local knit = { CreateController = function(controller) return controller end, GetService = function() return service end, Util = { Promise = { resolve = resolved } } }
	local rods = {
		a = { RodID = "a", DisplayName = "Rod", LayoutOrder = 1, Price = 0, Rarity = "Common", LuckBoost = 1, Icon = "a" },
		b = {
			RodID = "b", DisplayName = "Park Rod", LayoutOrder = 2, Price = 100,
			Rarity = "Uncommon", LuckBoost = 2, Icon = "b", MaxWeight = 1234567.125,
		},
		[onboarding.RewardRodId] = { RodID = onboarding.RewardRodId, DisplayName = "Reward Rod", LayoutOrder = 3, Price = 100, Rarity = "Common", LuckBoost = 1, Icon = "reward" },
	}
	local data = { WaitForChild = function() return rods end }
	local storage = node("ReplicatedStorage", "ReplicatedStorage")
	storage.Modules, storage.Packages = modules, { Knit = knit }
	templates.Parent = storage
	local services = {
		Players = { LocalPlayer = player },
		ReplicatedFirst = { LoadingAttributes = { LOADING_SCREEN_DONE = "done" }, WaitForChild = function() return data end },
		ReplicatedStorage = storage,
		RunService = { Heartbeat = heartbeat, RenderStepped = signal() },
		Workspace = node("Workspace", "Workspace"),
	}
	services.Workspace.CurrentCamera = {}
	local environment = setmetatable({
		game = { GetService = function(_, name) return services[name] end },
		require = function(value) return value end,
		task = { spawn = function(callback) callback() end, delay = function(_, callback) table.insert(h.delayed, callback) end },
		Vector2 = { new = function(x, y) return { X = x, Y = y } end },
		Instance = { new = function(class) return node(class, class) end },
	}, { __index = getfenv() })
	local controller = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/RodShopGuiController.lua", environment)
	controller:KnitStart()
	h.controller, h.gui, h.list, h.service, h.player, h.character, h.cards = controller, gui, list, service, player, character, cards
	function h:step() heartbeat:Fire(0.11) end
	function h:close() closeButton.Activated:Fire() end
	function h:flush() for _, callback in ipairs(self.delayed) do callback() end; table.clear(self.delayed) end
	function h:setCash(value) cash.Value = value end
	function h:setStage(value)
		stage = value
		stageChanged:Fire()
	end
	function h:getCard(id) return list:FindFirstChild(id) end
	return h
end
