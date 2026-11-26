local function signal()
	local callback
	return {
		Connect = function(_, handler)
			callback = handler
		end,
		Fire = function(_, ...)
			if callback then
				callback(...)
			end
		end,
	}
end

local status = {}
local function node(children)
	children.FindFirstChild = function(self, name)
		return self[name]
	end
	return children
end
local open, profileReady, nativeFinished = signal(), signal(), signal()
local card = node({})
local function label(text)
	return { Text = text, IsA = function(_, className) return className == "TextLabel" end }
end
local featuredChance, featuredBadge = label("0.2%"), label("OP")
card.IconFrame = node({
	Flamingo = node({ TextLabel = label("34%") }),
	HellShark = node({ TextLabel = label("10.5%") }),
	GalaxyMegalodon = node({}),
	GetChildren = function() return { featuredBadge, featuredChance } end,
})
local config = {
	PurchaseOrder = {},
	Purchases = {},
	Fish = {
		{ Card = "Flamingo", Chance = 30 },
		{ Card = "HellShark", Chance = 10 },
		{ Card = "GalaxyMegalodon", Chance = 0.5 },
	},
}
local products = {}
function config.GetPurchase(id)
	return products[id]
end
for _, count in ipairs({ 1, 3, 10 }) do
	local id = "Egg_" .. count
	table.insert(config.PurchaseOrder, id)
	config.Purchases[id] = count
	products[id] = { Price = 10 * count, ProductId = 100 + count, IconId = "" }
	card["Buy" .. count .. "Button"] = {
		TextLabel = { Clone = function() return status end },
		Activated = signal(),
	}
end
local store = {
	Enabled = false,
	GetPropertyChangedSignal = function() return open end,
	Frame = { MainFrame = { ScrollingFrame = node({ LimitedEggFrame = node({ Egg_R_1 = card }) }) } },
}
local prompts, refresh = {}, {}
local purchaseService = {
	PromptPurchase = { Fire = function(_, id) table.insert(prompts, id) end },
	PromptPurchaseFail = signal(),
}
local eggService = {
	PurchaseCompleted = signal(),
	GetAvailability = function()
		return {
			andThen = function(self, callback)
				table.insert(refresh, callback)
				return self
			end,
			catch = function() end,
		}
	end,
}
local services = {
	MarketplaceService = { PromptProductPurchaseFinished = nativeFinished },
	Players = { LocalPlayer = {
		UserId = 1,
		GetAttributeChangedSignal = function() return profileReady end,
		GetAttribute = function() return true end,
	} },
	ReplicatedFirst = { Data = { PurchaseData = products } },
}
local path = "src/ReplicatedStorage/Modules/PaidEggStoreView.lua"
local source = assert(io.open(path, "r"), path)
local view = assert(load(source:read("*a"), path, "t", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	script = { Parent = { PaidEggConfig = config, ButtonAnimation = { SetUp = function() end } } },
	require = function(value) return value end,
	Color3 = { new = function() end, fromRGB = function() end },
	Vector2 = { zero = {} },
	UDim2 = { fromScale = function() end },
	task = { delay = function() end },
}, { __index = getfenv() })))()
source:close()
view.Bind(store, purchaseService, eggService)
assert(card.IconFrame.Flamingo.TextLabel.Text == "30%")
assert(card.IconFrame.HellShark.TextLabel.Text == "10%")
assert(featuredChance.Text == "0.5%" and featuredBadge.Text == "OP")
assert(not status.Visible and #refresh == 1 and #prompts == 0, "Binding checks eligibility without making an order")
profileReady:Fire()
refresh[2]({ Allowed = true })
refresh[1]({ Allowed = false, Message = "Stale response" })
assert(not status.Visible, "A stale eligibility response cannot show a warning")
store.Enabled = true
open:Fire()
assert(#refresh == 3 and #prompts == 0)
for index, count in ipairs({ 1, 3, 10 }) do
	local button = card["Buy" .. count .. "Button"]
	assert(button.Interactable)
	button.Activated:Fire()
	button.Activated:Fire()
	assert(prompts[index] == "Egg_" .. count and #prompts == index, "The actual button only sends one prompt request")
	assert(not status.Visible and not button.Interactable, "Waiting is silent and blocks another click")
	purchaseService.PromptPurchaseFail:Fire("Unrelated purchase failed", "Cash")
	nativeFinished:Fire(1, 100, false)
	assert(not button.Interactable, "Unrelated receipts and errors cannot unlock the button")
	nativeFinished:Fire(1, 100 + count, false)
	assert(button.Interactable and not status.Visible, "Confirming cancellation restores the button immediately")
end
refresh[3]({ Allowed = false, Message = "Unavailable in your region" })
assert(status.Visible and not card.Buy1Button.Interactable, "A genuine denial is still visible")
