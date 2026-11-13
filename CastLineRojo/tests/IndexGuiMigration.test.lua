local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local formatMain = { NumberFormatter = { with = function()
	return { Format = function(_, value) return tostring(value) end }
end } }
local numberEnv = setmetatable({
	game = { GetService = function() return { Libs = { FormatNumber = { Main = formatMain, Simple = {} } } } end },
	require = function(value) return value end,
}, { __index = getfenv() })
local NumberUtil = assert(load(read("src/ReplicatedStorage/Modules/NumberUtil.lua"), "NumberUtil", "t", numberEnv))()
local function signal()
	local listeners = {}
	return {
		Connect = function(_, fn)
			table.insert(listeners, fn)
			return { Disconnect = function() end }
		end,
		Fire = function(_, ...) for _, fn in ipairs(listeners) do fn(...) end end,
	}
end
local function promise()
	local p = {}
	function p:andThen(fn) self.success = fn; return self end
	function p:catch(fn) self.failure = fn; return self end
	function p:resolve(value) self.success(value) end
	function p:reject(err) self.failure(err) end
	return p
end
local function instance(class, name, parent)
	local o = { ClassName = class, Name = name, children = {}, Activated = signal(), changed = signal() }
	local inputEvents = { "MouseEnter", "MouseLeave", "MouseButton1Down", "MouseButton1Up", "SelectionGained", "SelectionLost", "Destroying" }
	for _, event in ipairs(inputEvents) do o[event] = signal() end
	o.Size = { X = { Scale = 1, Offset = 0 }, Y = { Scale = 1, Offset = 0 } }
	o.AbsoluteSize = { X = 100, Y = 100 }
	function o:IsA(kind)
		return kind == self.ClassName or (kind == "GuiButton" and (class == "TextButton" or class == "ImageButton"))
	end
	function o:FindFirstChild(childName)
		for _, child in ipairs(self.children) do if child.Name == childName then return child end end
	end
	function o:WaitForChild(childName) return assert(self:FindFirstChild(childName), childName) end
	function o:GetChildren() return table.clone(self.children) end
	function o:GetDescendants()
		local descendants = {}
		for _, child in ipairs(self.children) do
			table.insert(descendants, child)
			for _, descendant in ipairs(child:GetDescendants()) do table.insert(descendants, descendant) end
		end
		return descendants
	end
	function o:GetPropertyChangedSignal() return self.changed end
	function o:Clone()
		local clone = instance(self.ClassName, self.Name)
		for key, value in pairs(self) do
			if typeof(value) ~= "function" and key ~= "children" and key ~= "Activated" and key ~= "changed"
				and key ~= "_parent" and not table.find(inputEvents, key) then
				clone[key] = value
			end
		end
		for _, child in ipairs(self.children) do child:Clone().Parent = clone end
		return clone
	end
	setmetatable(o, {
		__index = function(self, key)
			local parent = rawget(self, "_parent")
			if key == "Parent" then return parent end
			if key == "AbsolutePosition" and parent and parent.ClassName == "ScrollingFrame" then
				return { X = 0, Y = parent.AbsolutePosition.Y + (self.LayoutOrder - 1) * 120 - parent.CanvasPosition.Y }
			end
			return self:FindFirstChild(key)
		end,
		__newindex = function(self, key, value)
			if key == "Parent" then
				rawset(self, "_parent", value)
				table.insert(value.children, self)
			else rawset(self, key, value) end
		end,
	})
	if parent then o.Parent = parent end
	return o
end
local function harness()
	local playerGui = instance("PlayerGui", "PlayerGui")
	local player = instance("Player", "Player")
	playerGui.Parent = player
	local old = instance("ScreenGui", "IndexGui", playerGui)
	old.Enabled = true
	local gui = instance("ScreenGui", "IndexGui_New", playerGui)
	local root = instance("Frame", "Frame", gui)
	local main = instance("Frame", "MainFrame", root)
	instance("ImageButton", "CloseButton", root)
	local items = instance("ScrollingFrame", "PetsFrame", main)
	items.AbsolutePosition = { X = 30, Y = 50 }
	items.AbsoluteWindowSize = { X = 250, Y = 200 }
	items.AbsoluteCanvasSize = { X = 250, Y = 480 }
	items.CanvasPosition = { X = 7, Y = 0 }
	local template = instance("Frame", "PetTemplate", items)
	local button = instance("TextButton", "PetButton", template)
	instance("Frame", "BackgroundFrame", button)
	local stroke = instance("UIStroke", "UIStroke", button.BackgroundFrame)
	stroke.Color, stroke.Thickness = "black", 0.035
	stroke.StrokeSizingMode = "ScaledSize"
	instance("UIScale", "UIScale", button).Scale = 1
	for _, spec in ipairs({ {"TextLabel", "NameLabel"}, {"ImageLabel", "Icon"}, {"Frame", "Dot"} }) do
		instance(spec[1], spec[2], button)
	end
	local detail = instance("Frame", "DetailFrame", main)
	for _, name in ipairs({ "NameLabel", "RarityLabel", "PriceLabel" }) do instance("TextLabel", name, detail) end
	instance("ImageLabel", "Icon", instance("ViewportFrame", "ViewportFrame", detail))
	local claim = instance("TextButton", "ClaimButton", detail)
	instance("TextLabel", "NameLabel", claim)
	local bg = instance("Frame", "BG", claim)
	instance("UIGradient", "ClaimableGradient", bg)
	instance("UIGradient", "DisabledGradient", bg)
	local progress = instance("Frame", "ProgressFrame", main)
	local bar = instance("TextLabel", "ProgressBar", progress)
	bar.Size = { X = { Scale = 1, Offset = 0 }, Y = { Scale = 0.95, Offset = 2 } }
	instance("TextLabel", "ProgressLabel", progress)
	local state = promise()
	local requests, warnings, greens, reds = {}, {}, {}, {}
	local service = { IndexDiscovered = signal(), IndexRewardClaimed = signal(), GetIndexState = function() return state end }
	function service:ClaimIndexReward(id)
		local request = promise()
		request.itemId = id
		table.insert(requests, request)
		return request
	end
	local home = {}
	function home:ShowIndexNotif(value) self.dot = value end
	local knit = { CreateController = function(c) return c end, GetService = function() return service end, GetController = function() return home end }
	local fish = {
		A = { LayoutOrder = 1, DisplayName = "Alpha", Icon = "icon-A", Rarity = "Common", DefaultPrice = 50 },
		B = { LayoutOrder = 1, DisplayName = "Beta", Icon = "icon-B", Rarity = "Rare", DefaultPrice = 101 },
		C = { LayoutOrder = 2, DisplayName = "Charlie", Icon = "icon-C", Rarity = "Mythical", DefaultPrice = 100 },
		D = { LayoutOrder = 3, DisplayName = "Delta", Rarity = "Common", DefaultPrice = 100 },
	}
	local animation = {
		Setup = function(g) g.Enabled = false end,
		SetNavigationOptions = function(_, focus) home.focus = focus end,
		CloseGui = function(g) g.Enabled = false end,
	}
	local rarity = { Normalize = function(r) return if r == "Mythical" then "Mythic" else r end,
		Get = function(r) return { Color = "color-" .. r } end }
	local services = { Players = { LocalPlayer = player }, ReplicatedStorage = { Packages = { Knit = knit }, Modules = {
		FishInventoryData = fish, GuiAnimation = animation, RarityConfig = rarity, NumberUtil = NumberUtil,
		GuiUtil = { SetRarityGradient = function(background, value) background.Rarity = value end },
		SoundHelper = { PlaySound = function() end }, Constants = { SoundRes = { GUI_BUTTON_CLICK = "click" } },
		NotificationClient = { GreenNotify = function(t) table.insert(greens, t) end, RedNotify = function(t) table.insert(reds, t) end },
	} } }
	services.CollectionService = { GetTagged = function() return {} end, GetInstanceAddedSignal = signal }
	services.TweenService = { Create = function(_, target, _, goals)
		return { Play = function() for key, value in pairs(goals) do target[key] = value end end }
	end }
	local nextFrameJobs, delayedJobs = {}, {}
	services.RunService = { RenderStepped = { Wait = function() end } }
	local function runJobs(jobs)
		local pending = table.clone(jobs)
		table.clear(jobs)
		for _, callback in ipairs(pending) do callback() end
	end
	local env = setmetatable({
		game = { GetService = function(_, name) return services[name] end }, require = function(value) return value end,
		Color3 = { new = function() return "white" end, fromRGB = function(r, g, b)
			return if r == 255 and g == 215 and b == 0 then "gold" else "shadow"
		end },
		Vector2 = { new = function(x, y) return { X = x, Y = y } end },
		task = {
			spawn = function(callback) table.insert(nextFrameJobs, callback) end,
			delay = function(seconds, callback)
				assert(seconds == 0.2, "Opening correction must run after the 0.18s tween")
				table.insert(delayedJobs, callback)
			end,
		},
		UDim2 = { new = function(x, xo, y, yo) return { X = { Scale = x, Offset = xo }, Y = { Scale = y, Offset = yo } } end },
		warn = function(...) table.insert(warnings, {...}) end,
		TweenInfo = { new = function() return {} end },
	}, { __index = getfenv() })
	services.ReplicatedStorage.Modules.ButtonAnimation = assert(load(
		read("src/ReplicatedStorage/Modules/ButtonAnimation.lua"), "ButtonAnimation", "t", env
	))()
	local controller = assert(load(read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/IndexGuiController.lua"), "IndexGuiController", "t", env))()
	controller:KnitStart()
	return {
		gui = gui, old = old, items = items, detail = detail, claim = claim, bg = bg, progress = progress, bar = bar,
		service = service, state = state, requests = requests, home = home, warnings = warnings,
		greens = greens, reds = reds, fish = fish,
		open = function() gui.Enabled = true; gui.changed:Fire() end,
		close = function() gui.Enabled = false; gui.changed:Fire() end,
		nextFrame = function() runJobs(nextFrameJobs) end,
		afterAnimation = function() runJobs(delayedJobs) end,
		select = function(id) items:WaitForChild("IndexItem_" .. id).PetButton.Activated:Fire() end,
	}
end
local function assertSelection(h, expectedId)
	local selected = 0
	for _, entry in ipairs(h.items:GetChildren()) do
		if string.sub(entry.Name, 1, 10) == "IndexItem_" then
			local stroke = entry.PetButton.BackgroundFrame.UIStroke
			assert(stroke.StrokeSizingMode == "ScaledSize", "Selection must retain scaled stroke sizing")
			if entry.Name == "IndexItem_" .. expectedId then
				assert(stroke.Color == "gold" and stroke.Thickness == 0.05, "Current details must have a gold highlighted card")
				selected += 1
			else
				assert(stroke.Color == "black" and stroke.Thickness == 0.035, "Previous card must regain its original border")
			end
		end
	end
	assert(selected == 1, "Exactly one fish card must be selected")
end
local h = harness()
assert(not h.old.Enabled and not h.gui.Enabled and not h.detail.Visible)
h.state:resolve({ DiscoveryLog = { A = true, B = true }, RewardClaimLog = { A = true }, CollectionProgress = { CollectedCount = 2, TotalCount = 4 } })
h.open()
assertSelection(h, "B")
local animatedButton = h.items.IndexItem_B.PetButton
local gridSize, buttonSize = h.items.IndexItem_B.Size, animatedButton.Size
animatedButton.MouseEnter:Fire()
assert(animatedButton.UIScale.Scale == 1.1, "Dynamic fish cards must enlarge on hover")
animatedButton.MouseButton1Down:Fire()
assert(animatedButton.UIScale.Scale == 1, "Pressing returns the card to its base scale")
animatedButton.MouseButton1Up:Fire()
assert(animatedButton.UIScale.Scale == 1.1)
animatedButton.MouseLeave:Fire()
assert(animatedButton.UIScale.Scale == 1)
animatedButton.SelectionGained:Fire()
assert(animatedButton.UIScale.Scale == 1.1, "Gamepad focus must enlarge the card")
assertSelection(h, "B")
animatedButton.SelectionLost:Fire()
assert(animatedButton.UIScale.Scale == 1)
assert(gridSize == h.items.IndexItem_B.Size and buttonSize == animatedButton.Size, "Scaling must not resize the grid or button")
assert(h.detail.NameLabel.Text == "Beta" and h.detail.PriceLabel.Text == "$51")
assert(h.detail.RarityLabel.TextColor3 == "color-Rare")
assert(h.claim.NameLabel.Text == "CLAIM" and h.claim.Active and h.bg.ClaimableGradient.Enabled and not h.bg.DisabledGradient.Enabled)
assert(h.items.IndexItem_A.LayoutOrder < h.items.IndexItem_B.LayoutOrder, "Equal order must sort by ID")
assert(h.items.IndexItem_B.PetButton.Icon.Image == "icon-B")
assert(h.bar.Size.X.Scale == 0.5 and h.bar.Size.Y.Scale == 0.95 and h.bar.Size.Y.Offset == 2)
assert(h.progress.ProgressLabel.Text == "Unlocked: 2 / 4 ")
assert(h.home.dot and h.home.focus == h.items.IndexItem_B.PetButton)
assert(h.items.IndexItem_A.PetButton.BackgroundFrame.Rarity == "Common", "Claimed cards retain their rarity background")
assert(h.items.IndexItem_B.PetButton.BackgroundFrame.Rarity == "Rare", "Claimable cards use their rarity background")
assert(h.items.IndexItem_C.PetButton.BackgroundFrame.Rarity == "Mythical", "Locked cards also use their rarity background")
for _, case in ipairs({
	{ price = 1_997, expected = "$999" },
	{ price = 1_999, expected = "$1K" },
	{ price = 2_477, expected = "$1.23K" },
	{ price = 2_400, expected = "$1.2K" },
	{ price = 1_999_997, expected = "$999.99K" },
	{ price = 1_999_999, expected = "$1M" },
	{ price = 2_469_135, expected = "$1.23M" },
	{ price = 1_999_999_999, expected = "$1B" },
}) do
	h.fish.B.DefaultPrice = case.price
	h.select("B")
	assert(h.detail.PriceLabel.Text == case.expected, "Reward must round before compact formatting: " .. case.expected)
end
h.fish.B.DefaultPrice = 101
assert(#h.warnings == 1, "Missing icon warns once")
h.select("C")
assertSelection(h, "C")
assert(h.detail.NameLabel.Text == "???" and h.detail.RarityLabel.Text == "Mythic")
assert(h.detail.ViewportFrame.Icon.Image == "icon-C" and h.detail.ViewportFrame.Icon.ImageColor3 == "shadow")
assert(h.claim.NameLabel.Text == "LOCKED" and not h.claim.Active and h.bg.DisabledGradient.Enabled)
h.claim.Activated:Fire()
assert(#h.requests == 0, "Locked selection must not request a reward")
h.select("B")
assertSelection(h, "B")
assert(#h.requests == 0, "Selecting a fish must not claim it")
h.claim.Activated:Fire()
h.claim.Activated:Fire()
assert(#h.requests == 1 and h.requests[1].itemId == "B" and not h.claim.Active)
h.select("C")
h.service.IndexRewardClaimed:Fire("B")
h.requests[1]:resolve({ IsSuccess = true, ResultText = "Claimed!" })
assertSelection(h, "C")
assert(h.detail.NameLabel.Text == "???" and h.claim.NameLabel.Text == "LOCKED", "Late success must retain the current selection")
assert(not h.items.IndexItem_B.PetButton.Dot.Visible and not h.home.dot)
h.select("B")
assert(h.claim.NameLabel.Text == "CLAIMED" and h.bg.DisabledGradient.Enabled and not h.bg.ClaimableGradient.Enabled)
h.claim.Activated:Fire()
assert(#h.requests == 1)
h.select("C")
h.gui.Enabled = false
h.open()
assertSelection(h, "C")
assert(h.detail.NameLabel.Text == "???", "Reopening must preserve user selection")
h.service.IndexDiscovered:Fire("C", { CollectedCount = 3, TotalCount = 4 })
assert(h.detail.NameLabel.Text == "Charlie" and h.claim.Active and h.home.dot)
h.claim.Activated:Fire()
h.requests[2]:reject("network")
assert(h.claim.Active and h.claim.NameLabel.Text == "CLAIM", "Network failure must restore the button")
h.claim.Activated:Fire()
h.requests[3]:resolve({ IsSuccess = false, ResultText = "Try again" })
assert(h.claim.Active and h.reds[1] == "Try again")
h.claim.Activated:Fire()
h.requests[4]:resolve({ IsSuccess = true, ResultText = "Done" })
assertSelection(h, "C")
assert(h.claim.NameLabel.Text == "CLAIMED" and not h.home.dot and #h.greens == 2)
h.select("D")
h.select("D")
assertSelection(h, "D")
assert(h.detail.ViewportFrame.Icon.Image == "" and #h.warnings == 2, "Missing icons stay blank and warn once")

-- Events during initial load must survive an older state response.
local early = harness()
early.service.IndexDiscovered:Fire("C", { CollectedCount = 1, TotalCount = 4 })
early.state:resolve({ DiscoveryLog = {}, RewardClaimLog = {}, CollectionProgress = { CollectedCount = 0, TotalCount = 4 } })
early.open()
assertSelection(early, "C")
assert(early.detail.NameLabel.Text == "Charlie" and early.bar.Size.X.Scale == 0.25)
local empty = harness()
empty.state:resolve({ DiscoveryLog = {}, RewardClaimLog = {}, CollectionProgress = { CollectedCount = 0, TotalCount = 4 } })
empty.open()
assertSelection(empty, "A")
assert(empty.home.focus == empty.items.IndexItem_A.PetButton and empty.claim.NameLabel.Text == "LOCKED")
local claimed = harness()
claimed.state:resolve({ DiscoveryLog = { C = true }, RewardClaimLog = { C = true }, CollectionProgress = { CollectedCount = 1, TotalCount = 4 } })
claimed.open()
assertSelection(claimed, "C")
assert(claimed.detail.NameLabel.Text == "Charlie" and claimed.claim.NameLabel.Text == "CLAIMED")

local scroll = harness()
scroll.state:resolve({ DiscoveryLog = { B = true }, RewardClaimLog = {}, CollectionProgress = { CollectedCount = 1, TotalCount = 4 } })
scroll.open()
assert(scroll.items.CanvasPosition.Y == 0, "Opening must wait for layout before scrolling")
scroll.nextFrame()
assert(scroll.items.CanvasPosition.Y == 30 and scroll.items.CanvasPosition.X == 7, "Reveal a card below the window with minimal vertical movement")
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 30, "An already visible card must not move")
-- Manual scrolling remains free after the opening correction.
scroll.items.CanvasPosition = { X = 7, Y = 0 }
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 0)
scroll.close()
scroll.open()
scroll.nextFrame()
assert(scroll.items.CanvasPosition.Y == 30, "Reopening must reveal the remembered selection")
-- The animation correction reads updated geometry and the current selection.
scroll.items.AbsoluteWindowSize = { X = 250, Y = 150 }
scroll.select("C")
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 200, "Post-animation correction must use the latest selection and window size")
assertSelection(scroll, "C")
scroll.select("B")
scroll.close()
scroll.open()
scroll.nextFrame()
assert(scroll.items.CanvasPosition.Y == 110, "A card above the window must scroll upwards with its margin")
scroll.afterAnimation()
scroll.select("D")
scroll.close()
scroll.open()
scroll.nextFrame()
assert(scroll.items.CanvasPosition.Y == 320, "Last card must fit near the bottom")
scroll.items.AbsoluteCanvasSize = { X = 250, Y = 460 }
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 310, "Bottom padding must clamp to the canvas limit")
scroll.select("A")
scroll.close()
scroll.open()
scroll.nextFrame()
assert(scroll.items.CanvasPosition.Y == 0, "First card must clamp to zero")
-- Closing invalidates both next-frame and delayed jobs, even across a quick reopen.
scroll.close()
scroll.select("D")
scroll.open()
scroll.close()
scroll.items.CanvasPosition = { X = 7, Y = 60 }
scroll.nextFrame()
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 60, "Closed GUI must ignore stale scroll jobs")
scroll.select("B")
scroll.open()
scroll.close()
scroll.select("C")
scroll.open()
scroll.nextFrame()
scroll.afterAnimation()
assert(scroll.items.CanvasPosition.Y == 200, "Only the newest opening may position the current card")
assertSelection(scroll, "C")

local late = harness()
late.open()
late.nextFrame()
late.afterAnimation()
assert(late.items.CanvasPosition.Y == 0, "Opening before data must not scroll placeholder content")
late.state:resolve({ DiscoveryLog = { C = true }, RewardClaimLog = {}, CollectionProgress = { CollectedCount = 1, TotalCount = 4 } })
late.nextFrame()
late.afterAnimation()
assert(late.items.CanvasPosition.Y == 150, "Late data must reveal the default selection after creating entries")
assertSelection(late, "C")
local short = harness()
short.state:resolve({ DiscoveryLog = {}, RewardClaimLog = {}, CollectionProgress = { CollectedCount = 0, TotalCount = 4 } })
short.items.AbsoluteCanvasSize = { X = 250, Y = 100 }
short.open()
short.nextFrame()
short.afterAnimation()
assert(short.items.CanvasPosition.Y == 0, "A short canvas must not produce negative scroll limits")
print("IndexGuiMigration.test.lua passed")
