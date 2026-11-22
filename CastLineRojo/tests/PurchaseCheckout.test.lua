local newFixture = require("./helpers/PurchaseCheckoutFixture")
local players = {}
local buyer = { UserId = 1, Parent = players }
local time, opened = 100, 0
local jobs = {}
local nativeUnavailable
local function schedule(fn, ...)
	table.insert(jobs, { fn, ... })
end
local fixture = newFixture(players, {
	PromptProductPurchase = function()
		opened += 1
		if nativeUnavailable then
			error("native outcome unknown")
		end
	end,
}, {
	defer = schedule,
	delay = function(_, fn, ...) schedule(fn, ...) end,
}, function() return time end)
local checkout = fixture.Load()
local kind = "Product"
local productId = 101
local key = kind .. ":" .. buyer.UserId

local function open(target, current)
	return checkout.Open(kind, buyer, { ProductId = productId, RecipientUserId = target }, function()
		return current ~= false
	end, function(previous)
		return previous.ProductId == productId and previous.RecipientUserId == target
	end)
end
local function receipt(id)
	return { PurchaseId = id, PlayerId = buyer.UserId, ProductId = productId }
end

assert(not checkout.WritesEnabled())
fixture.Studio = true
fixture.PlaceId = 84106335829275
local devCheckout = fixture.Load()
assert(devCheckout.WritesEnabled("Egg"), "The CastLine development place uses dedicated egg checkout in Studio")
assert(not devCheckout.WritesEnabled("Product") and not devCheckout.WritesEnabled("Bait"))
fixture.StudioPaidEggOverride = false
fixture.Enabled = true
assert(not devCheckout.WritesEnabled("Egg") and devCheckout.WritesEnabled("Product"))
fixture.StudioPaidEggOverride = nil
fixture.Enabled = false
fixture.Studio = false
assert(not devCheckout.WritesEnabled("Egg"), "Published servers keep the global flag")
fixture.Studio = true
fixture.PlaceId = 123
assert(not fixture.Load().WritesEnabled("Egg"), "Other Studio places keep the global flag")
fixture.Studio = false
fixture.Enabled = true
assert(checkout.WritesEnabled())
fixture.OnUpdate = function()
	coroutine.yield()
end
local request = coroutine.create(function() assert(open(1)) end)
assert(coroutine.resume(request) and opened == 0)
assert(not open(2) and opened == 0, "Repeated clicks must wait for checkout")
local preparing, available = checkout.Bind(kind, buyer, receipt("not-yet"))
assert(not preparing and not available, "Receipt must wait until the reservation can be used")
fixture.OnUpdate = nil
assert(coroutine.resume(request) and coroutine.status(request) == "dead" and opened == 1)
local fresh = fixture.Records[key]
checkout.Finish(kind, buyer, productId + 1, false)
assert(not open(2), "Another product's closing event cannot release the active prompt")
checkout.Finish(kind, buyer, productId, false)
assert(not checkout.Bind(kind, buyer, receipt("canceled")))
assert(open(1) and fixture.Records[key].Snapshot == fresh.Snapshot, "Reopening reuses the frozen context")
checkout.Finish(kind, buyer, productId, false)
assert(open(2) and fixture.Records[key].Snapshot.RecipientUserId == 2, "A canceled checkout permits a new target")
local payment = receipt("confirmed")
local reserved = assert(checkout.Bind(kind, buyer, payment))
assert(reserved.Snapshot.RecipientUserId == 2 and reserved.ReceiptId == "confirmed")
assert(not checkout.Bind(kind, buyer, receipt("another")), "A second receipt cannot claim this context")
assert(not checkout.Complete(kind, receipt("wrong"), reserved.Id))
assert(checkout.Complete(kind, payment, reserved.Id))
assert(not open(1), "Keep the local window occupied until its own closed event")
checkout.Finish(kind, buyer, productId, true)
assert(open(2))

checkout = fixture.Load()
fixture.Enabled = false
assert(not checkout.WritesEnabled() and not checkout.CanUseLegacy(kind, buyer), "A restart with writes disabled must respect a pending checkout")
local afterReconnect = assert(checkout.Bind(kind, buyer, receipt("reconnect")))
assert(afterReconnect.Snapshot.RecipientUserId == 2)
assert(checkout.Complete(kind, receipt("reconnect"), afterReconnect.Id))
assert(checkout.CanUseLegacy(kind, buyer))
assert(checkout.Complete(kind, receipt("reconnect"), afterReconnect.Id), "Completing an already finalized receipt is idempotent")

local beforeFailure = opened
fixture.AfterWrite = function()
	fixture.AfterWrite = nil
	error("response lost after commit")
end
assert(not open(1) and opened == beforeFailure)
assert(not open(2), "A second click must wait for cancellation of the unopened reservation")
jobs[#jobs][1](table.unpack(jobs[#jobs], 2))
assert(not checkout.Bind(kind, buyer, receipt("unopened")))
assert(not open(1, false) and opened == beforeFailure)
jobs[#jobs][1](table.unpack(jobs[#jobs], 2))

nativeUnavailable = true
assert(not open(1))
assert(not open(2), "An attempted prompt with unknown outcome cannot be replaced")
checkout = fixture.Load()
assert(not checkout.CanUseLegacy(kind, buyer))
assert(checkout.Bind(kind, buyer, receipt("native-unknown")).Snapshot.RecipientUserId == 1)
