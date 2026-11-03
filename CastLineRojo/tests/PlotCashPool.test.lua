local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemsData = read("src/ReplicatedFirst/Data/ItemsData.lua")
local template = read("src/ReplicatedStorage/PlayerData/Template.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")
local utility = read("src/ReplicatedStorage/Modules/PlotCashPoolUtil.lua")
local sweepUtility = dofile("src/ReplicatedStorage/Modules/PlotCashPoolSweepUtil.lua")
local service = read("src/ServerScriptService/Services/PlotCashPoolService.lua")
local pedestalService = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotCashPoolController.lua")
local effect = read("src/ReplicatedStorage/Modules/PlotCashCollectFx.lua")

local itemCount = 0
for _ in itemsData:gmatch('ItemID%s*=%s*"[^"]+"') do
	itemCount = itemCount + 1
end
local cpsCount = 0
for value in itemsData:gmatch("CpsPrice%s*=%s*([%d%.]+)") do
	cpsCount = cpsCount + 1
	assert(tonumber(value) and tonumber(value) > 0, "Every CpsPrice must be positive")
end
assert(itemCount == 80, "The item catalog should contain 80 items")
assert(cpsCount == itemCount, "Every item must define a positive CpsPrice")

assert(template:find("PlotCashPools = {}", 1, true), "New profiles must contain PlotCashPools")
assert(
	playerDataService:find('if typeof(playerData.PlotCashPools) ~= "table" then', 1, true),
	"Existing profiles must migrate PlotCashPools"
)
assert(utility:find("PRODUCTION_INTERVAL_SECONDS = 1", 1, true), "Production must use complete one-second cycles")
assert(utility:find("OFFLINE_RATE = 0.5", 1, true), "Offline production must be 50 percent")
assert(utility:find("MAX_OFFLINE_SECONDS = 8 * 60 * 60", 1, true), "Offline production must cap at 8 hours")
assert(
	utility:find("math.floor(safeRate * safeSeconds * PlotCashPoolUtil.OFFLINE_RATE)", 1, true),
	"Offline income must be rounded down"
)

local function offlineCash(cps, seconds)
	return math.floor(cps * math.min(math.max(seconds, 0), 28800) * 0.5)
end
assert(offlineCash(100, 60) == 3000, "Offline income should use 50 percent of CpsPrice")
assert(offlineCash(100, 99999) == 1440000, "Offline income should cap at 8 hours")

local expandedHalfExtents = { X = 3.4, Y = 4.25, Z = 4.9 }
assert(
	sweepUtility.SegmentIntersectsLocalBox(
		{ X = 0, Y = 0, Z = 0 },
		{ X = 0, Y = 0, Z = 0 },
		expandedHalfExtents
	),
	"Standing inside a CashPool must remain detected"
)
assert(
	sweepUtility.SegmentIntersectsLocalBox(
		{ X = -10, Y = 0, Z = 0 },
		{ X = 10, Y = 0, Z = 0 },
		expandedHalfExtents
	),
	"A high-speed segment crossing the CashPool must be detected"
)
assert(
	sweepUtility.SegmentIntersectsLocalBox(
		{ X = -10, Y = 4.25, Z = 0 },
		{ X = 10, Y = 4.25, Z = 0 },
		expandedHalfExtents
	),
	"A segment touching the expanded boundary must count"
)
assert(
	not sweepUtility.SegmentIntersectsLocalBox(
		{ X = -10, Y = 4.26, Z = 0 },
		{ X = 10, Y = 4.26, Z = 0 },
		expandedHalfExtents
	),
	"A segment outside the expanded boundary must not count"
)

assert(service:find("ItemsData[record.ItemId]", 1, true), "The server must resolve the placed item from saved data")
assert(service:find("MutationDataUtil.GetEarnCashRate(mutationId)", 1, true), "Production must apply the saved Mutation Cps rate")
assert(not service:find("PaybackTime", 1, true), "PaybackTime must not affect runtime production")
assert(not service:find("ConditionId", 1, true), "Condition must not affect runtime production")
assert(not service:find("Weight", 1, true), "Weight must not affect runtime production")
assert(service:find("state.PendingCash += rate * cycles", 1, true), "Each complete cycle must add the exact CpsPrice")
assert(service:find("state.OfflineCash += PlotCashPoolUtil.ComputeOfflineCash", 1, true), "Login must add offline income")
assert(service:find("if self._InitializedPlayers[player] then", 1, true), "Repeated initialization must not duplicate offline income")
assert(service:find("AdjustWins(player, amount, false)", 1, true), "Collection must award Cash without TotalWins")

assert(service:find('plot:GetAttribute("OwnerUserId") ~= player.UserId', 1, true), "Collection must verify plot ownership")
assert(service:find("getPedestalBySlot(plot, slot)", 1, true), "Collection must verify the slot")
assert(service:find("MAX_COLLECT_DISTANCE = 50", 1, true), "Touch collection must enforce a 50-stud server distance")
assert(service:find("COLLECT_COOLDOWN_SECONDS = 1", 1, true), "The server must enforce a one-second per-pool collection cooldown")
assert(controller:find("MAX_SWEEP_DISPLACEMENT = 120", 1, true), "Long-distance teleports must not create a client sweep")
assert(controller:find("SWEEP_PADDING = Vector3.new(2, 4, 2)", 1, true), "Sweep bounds must include character volume")
assert(controller:find("RunService.Heartbeat:Connect(collectFromStandingOrSweep)", 1, true), "Stationary clients must retry when displayed income becomes positive")
assert(controller:find("PlotCashPoolSweepUtil.SegmentIntersectsOrientedBox", 1, true), "Client collection must use swept oriented-box detection")
assert(not service:find("RunService.Heartbeat:Connect", 1, true), "The server must not autonomously collect before the client sees income")
assert(service:find("lastCollectBySlot[slot]", 1, true), "Collection cooldown must be isolated per slot")
local awardCash = assert(service:find("AdjustWins(player, amount, false)", 1, true))
local writeCooldown = assert(service:find("lastCollectBySlot[slot] = now", awardCash, true))
assert(awardCash < writeCooldown, "Only a successful cash award may start the collection cooldown")
assert(service:find("amount < 1", 1, true), "Empty pools must not award Cash")
assert(service:find("function PlotCashPoolService.Client:RequestCollect", 1, true), "The collect interface is missing")
assert(service:find("function PlotCashPoolService.Client:RequestSnapshot", 1, true), "The snapshot interface is missing")
assert(service:find("CashPoolsUpdated = Knit.CreateSignal()", 1, true), "Snapshot signal is missing")
assert(service:find("CashCollected = Knit.CreateSignal()", 1, true), "Confirmed collection signal is missing")
assert(service:find("self:_collect(player, slot, false, false)", 1, true), "Placement changes must collect without cooldown or proximity checks")
assert(not service:find("self:_collect(player, slot, false, true, true)", 1, true), "Automatic collection must not bypass the client balance gate")
assert(service:find("PlotCashPoolService:_collect(player, slot, true, true)", 1, true), "Direct collection must enforce cooldown and proximity")

local firstAutoCollect = assert(pedestalService:find('CollectForPlacementChange(player, slot)', 1, true))
local firstPlacementWrite = assert(pedestalService:find("PlotPlacementUtil.SetItemUid(profile.Data.PlotPlacements, slot, inventoryId)", 1, true))
assert(firstAutoCollect < firstPlacementWrite, "Swap must collect before replacing the item")
local pickupStart = assert(pedestalService:find("function PlotPedestalService:pickupItem", 1, true))
local pickupCollect = assert(pedestalService:find('CollectForPlacementChange(player, slot)', pickupStart, true))
local pickupClear = assert(pedestalService:find("PlotPlacementUtil.ClearSlot(profile.Data.PlotPlacements, slot)", pickupStart, true))
assert(pickupCollect < pickupClear, "Pickup must collect before clearing the item")
assert(
	select(2, pedestalService:gsub('OnPlacementChanged%(player, slot%)', "")) == 2,
	"Place/swap and pickup must both restart a full production cycle"
)

assert(controller:find("CLIENT_TOUCH_DEBOUNCE_SECONDS = 0.15", 1, true), "Client touch debounce must be 0.15 seconds")
assert(controller:find("guiPart.Touched:Connect", 1, true), "GuiPart touch collection is missing")
assert(controller:find("hit:IsDescendantOf(character)", 1, true), "Only the local character may trigger collection")
assert(controller:find("local function getCachedTotal", 1, true), "Client must expose the displayed cash lookup")
local collectStart = assert(controller:find("local function collectFromTouch", 1, true))
local collectEnd = assert(controller:find("local function collectFromStandingOrSweep", collectStart, true))
local collectFromTouchBody = controller:sub(collectStart, collectEnd - 1)
assert(
	collectFromTouchBody:find("getCachedTotal(slot) < 1", 1, true),
	"A zero displayed cash total must block a collection request"
)
assert(
	collectFromTouchBody:find("RequestCollect", 1, true)
		> collectFromTouchBody:find("getCachedTotal(slot) < 1", 1, true),
	"RequestCollect must run only after the displayed-cash guard"
)
assert(
	not collectFromTouchBody:find("PlotCashCollectFx.Play", 1, true),
	"Cash effects must wait for server confirmation"
)
assert(
	controller:find("service.CashCollected:Connect", 1, true)
		and controller:find("PlotCashCollectFx.Play(cashPool, amount)", 1, true),
	"Every authoritative collection must play the confirmed cash effect"
)
assert(
	not controller:find("pendingOptimisticBySlot", 1, true),
	"Client must not retain optimistic collection state"
)

-- Execute the real request gate with mocked Roblox dependencies and deferred RPC completion.
local cachedStart = assert(controller:find("local function getCachedTotal", 1, true))
local gateSource = controller:sub(cachedStart, collectEnd - 1)
	:gsub("slot: number%)%: number", "slot)")
	:gsub("guiPart: BasePart, hit: BasePart", "guiPart, hit")
local gateTime, requests, refreshes = 0, 0, 0
local onResponse, onFailure
local snapshot = { [1] = { total = 0, rate = 3 } }
local character, pedestal, plot = {}, {}, {}
function plot:GetAttribute() return 42 end
local hit = { IsDescendantOf = function(_, target) return target == character end }
local promise = {}
function promise:andThen(callback) onResponse = callback; return self end
function promise:catch(callback) onFailure = callback; return self end
local remote = { RequestCollect = function(_, slot)
	assert(slot == 1)
	requests = requests + 1
	return promise
end }
local gateEnv = setmetatable({
	snapshotBySlot = snapshot,
	LOCAL_PLAYER = { Character = character, UserId = 42 },
	getPedestal = function() return pedestal end,
	getPlot = function() return plot end,
	getSlot = function() return 1 end,
	hasDisplayedItem = function() return true end,
	requestInFlightBySlot = {},
	touchDebounceBySlot = {},
	CLIENT_TOUCH_DEBOUNCE_SECONDS = 0.15,
	os = { clock = function() return gateTime end },
	Knit = { GetService = function() return remote end },
	requestSnapshot = function() refreshes = refreshes + 1 end,
	warn = function() end,
}, { __index = _G })
local gate = assert(load(gateSource .. "\nreturn collectFromTouch", "CashPool request gate", "t", gateEnv))()
for _, total in ipairs({ 0, 0.9, -1 }) do
	snapshot[1].total = total
	gate({}, hit)
end
assert(requests == 0, "Zero displayed cash must never initiate collection")
snapshot[1].total = 3
gate({}, hit)
assert(requests == 1, "New positive income must allow collection without leaving the pool")
gateTime = 2
gate({}, hit)
assert(requests == 1, "An in-flight collection must not be duplicated")
snapshot[1].total = 6
onResponse({ ok = true })
assert(snapshot[1].total == 6, "A late RPC response must not erase a newer snapshot")
snapshot[1].total = 0
gate({}, hit)
assert(requests == 1, "Confirmed empty display must suppress the next request")
snapshot[1].total = 3
gate({}, hit)
assert(requests == 2, "Income in the next cycle must be collectable")
onFailure("test transport failure")
assert(refreshes == 1 and not gateEnv.requestInFlightBySlot[1], "Failure must restore snapshot access and release the pending request")
assert(controller:find('coinsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(total)', 1, true), "CoinsLabel format is wrong")
assert(controller:find('offlineLabel.Text = "Offline: $" .. NumberUtil.FormatItemPriceCompact(offline)', 1, true), "OfflineLabel format is wrong")
assert(controller:find("offlineLabel.Visible = offline >= 1", 1, true), "Zero offline income must stay hidden")
assert(controller:find("service.CashCollected:Connect", 1, true), "Effects must wait for server confirmation")
assert(controller:find('pedestal:GetAttribute("ItemUid")', 1, true), "CashPool visibility must use the displayed item")
assert(controller:find('cashPool:FindFirstChild("Part")', 1, true), "CashPool Part visibility is missing")
assert(controller:find('cashPool:FindFirstChild("GuiPart")', 1, true), "CashPool GuiPart visibility is missing")
assert(controller:find('guiPart:FindFirstChild("ButtonGUI")', 1, true), "CashPool ButtonGUI visibility is missing")
assert(controller:find("part.LocalTransparencyModifier = if visible then 0 else 1", 1, true), "CashPool parts must be hidden locally")
assert(controller:find("buttonGui.Enabled = visible", 1, true), "CashPool ButtonGUI must match visibility")
assert(controller:find('plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId', 1, true), "Other players CashPools must stay hidden")
assert(controller:find('pedestal:GetAttributeChangedSignal("ItemUid")', 1, true), "CashPool visibility must refresh when an item changes")
assert(controller:find('plot:GetAttributeChangedSignal("OwnerUserId")', 1, true), "CashPool visibility must refresh when plot ownership changes")

assert(effect:find("CASH_PART_COUNT_MIN = 3", 1, true) and effect:find("CASH_PART_COUNT_MAX = 5", 1, true), "Cash effect must use 3-5 bills")
assert(effect:find('getPetVfxAsset("CashPart")', 1, true), "Cash effect must use PetVFX.CashPart")
assert(effect:find('getPetVfxAsset("MoneyAttach")', 1, true), "Cash effect must attach MoneyAttach")
assert(effect:find('getCollectSound("Whoosh")', 1, true), "Cash effect must play Whoosh")
assert(effect:find('getCollectSound("CashCollect")', 1, true), "Cash effect must play CashCollect")
assert(effect:find("quadraticBezier", 1, true), "Cash bills must fly on a curved path")
assert(effect:find("GuiAnimationUtil.PlayCharacterCashGain", 1, true), "Collection must show the authoritative amount")
assert(effect:find("CASH_GAIN_DURATION = 0.55", 1, true), "CashPool cash-gain popup must use the faster duration")
assert(effect:find("if not cashPool or amount < 1 then", 1, true), "Cash effect must ignore zero amounts")
assert(effect:find("Debris:AddItem", 1, true), "Temporary cash effects need cleanup fallbacks")

print("PlotCashPool.test.lua passed")
