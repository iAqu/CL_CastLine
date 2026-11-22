local harness = require("./helpers/RodShopControllerHarness")
local initial = { ok = true, ownedRods = { a = true }, equippedRodId = "a" }
local purchased = { ok = true, ownedRods = { a = true, b = true }, equippedRodId = "b" }

local h = harness()
assert(h.controller:IsReady())
h.controller:OpenForRod("b")
h.controller:OpenForRod("b")
assert(#h.requests == 1 and h.teleports == 1, "Double click must not duplicate a pending open")
assert(h.gui.Enabled and h.status == "Loading..." and not h:getCard("b"))
h.service.InventoryChanged:Fire(purchased)
h.requests[1](initial)
assert(h.teleports == 1 and h.gui.Enabled, "Hint must teleport and open")
assert(h.list.CanvasPosition.Y == 350, "Hint must center its original target card")
assert(h.list.CanvasPosition.X == 350, "Horizontal rod shop layouts must center the target as well")
local target
for _, card in ipairs(h.cards) do if card.Name == "b" then target = card end end
assert(target.EquipedButton.Visible and not target.BuyButton.Visible, "New inventory signal must win over the initial request")
assert(target.Information.Weight.Counter.Text == "1234567 kg")
assert(h:getCard("a").Information.Weight.Counter.Text == "")
h:flush()
h:close()
assert(not h.gui.Enabled)
h.inside = false
h:step()
h.controller:OpenForRod("not-a-rod")
assert(#h.requests == 1 and h.error == "Fishing rod unavailable")

h = harness()
h.controller:OpenForRod("b")
h.player.Character = h.character()
h.inside = false
h:step()
h.requests[1](initial)
assert(h.teleports == 1 and not h.gui.Enabled and not h:getCard("b"), "Respawn discards the old inventory response")
h.controller:OpenForRod("b")
h.requests[2](initial)
assert(h.teleports == 2 and h.gui.Enabled, "A new character can make a new request")

h = harness()
h.controller:OpenForRod("b")
h.gui.Enabled = false
h.controller:OpenForRod("b")
h.requests[1](initial)
assert(h.gui.Enabled and h.status == "Loading..." and not h:getCard("b"), "Old responses cannot fill a reopened shop")
h.requests[2]({ ok = false, message = "Inventory unavailable" })
assert(h.gui.Enabled and h.status == "Inventory unavailable" and h.focus.Name == "CloseButton")
h:close()
assert(not h.gui.Enabled, "A failed inventory read must leave Close usable")

h = harness()
h.inside = true
h:step()
assert(#h.requests == 1 and h.gui.Enabled and h.status == "Loading...")
h.requests[1](initial)
assert(h.gui.Enabled and h.teleports == 0, "Ordinary area entry must still open without teleporting")
h.inside = false
h:step()
assert(not h.gui.Enabled, "Walking out still closes the shop")

h = harness()
h.controller:OpenForRod("b")
h.humanoid.Health = 0
h.inside = false
h:step()
h.requests[1](initial)
assert(h.teleports == 1 and not h.gui.Enabled and not h:getCard("b"), "A dead character cannot complete a request")

local function expectGradient(button, canBuy, message)
	assert(button.Gradient_CanBuy.Enabled == canBuy and button.Gradient_CannotBuy.Enabled == not canBuy, message)
end

h = harness(99)
h:setStage("PlaceFish")
h.controller:OpenForRod("b")
h.requests[1](initial)
local buyButton = h:getCard("b").BuyButton
local rewardButton = h:getCard("Rod_102").BuyButton
expectGradient(buyButton, false, "Cash below the price must start with the cannot-buy gradient")
assert(buyButton.Interactable, "An unaffordable rod must remain clickable for the purchase feedback")
buyButton.Activated:Fire()
assert(h.purchases[1].id == "b")
h.purchases[1].resolve({ ok = false, message = "Not enough cash" })
assert(h.error == "Not enough cash" and buyButton.Interactable)

h:setCash(100)
expectGradient(buyButton, true, "Cash equal to the price must switch to the can-buy gradient")
expectGradient(rewardButton, false, "Training lock must override an affordable price")
assert(rewardButton.TextLabel.Text == "TRAIN FIRST" and not rewardButton.Interactable)
h:setCash(101)
expectGradient(buyButton, true, "Cash above the price must keep the can-buy gradient")
h:setCash(0)
expectGradient(buyButton, false, "Spending cash must restore the cannot-buy gradient while open")
h:setStage("RodReward")
expectGradient(rewardButton, true, "A free training claim must use the can-buy gradient with zero cash")
assert(rewardButton.TextLabel.Text == "CLAIM" and rewardButton.Interactable)

h:setCash(100)
buyButton.Activated:Fire()
expectGradient(buyButton, true, "An in-flight purchase must keep the eligibility gradient")
assert(not buyButton.Interactable)
buyButton.Activated:Fire()
assert(#h.purchases == 2, "An in-flight purchase must reject another click")
h.purchases[2].resolve(purchased)
assert(not buyButton.Visible and h:getCard("b").EquipedButton.Visible, "A purchased rod must show its equipped state")
