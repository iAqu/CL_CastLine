local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local service = read("src/ServerScriptService/Services/GiftService.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GiftController.lua")

assert(service:find("GIFT_DISTANCE = 12", 1, true), "Gift distance must match PromptUtil max distance")
assert(service:find("REQUEST_TIMEOUT_SECONDS = 15", 1, true), "Gift requests must expire after 15 seconds")
assert(service:find('kind ~= "item"', 1, true), "Only item tools may be gifted")
assert(service:find("isPlacedOnPlot", 1, true), "Placed plot items must be blocked")
assert(not service:find("CanCarry(recipient, itemData.Weight)", 1, true), "Gift transfer must not enforce recipient carry capacity")
assert(not service:find("Not enough carry weight.", 1, true), "Gift transfer must not reject over-capacity recipients")
assert(service:find("senderProfile.Data.Items[instanceId] = nil", 1, true), "Sender item records must be removed")
assert(service:find("recipientProfile.Data.Items[instanceId] = transferredRecord", 1, true), "Recipient item records must be added")
assert(service:find("ItemToolUtil.Create", 1, true), "Gift transfer must create an item tool for the recipient")
assert(service:find("destroyItemTools", 1, true), "Sender item tools must be destroyed")
assert(service:find("RemoveItemDescriptors(sender, { instanceId })", 1, true), "Sender hotbar entries must be cleared")
assert(service:find("DiscoverItem(recipient, item.ItemID)", 1, true), "Gifted items must update the recipient index")
assert(service:find("NewItemTagSeenLog", 1, true), "Gifted items must update the recipient new-item tag log")
assert(not service:find("TotalItemWeightTenths", 1, true), "Gift transfer must not increment total dug weight")
assert(service:find('GiftResult:Fire(request.sender, true, "Gift sent!")', 1, true), "Successful gifts must notify the sender")
assert(service:find("recipientIsEmptyHanded(recipient)", 1, true), "Empty-handed recipients should auto-equip gifts")
assert(not service:find("IsTradeSystemLocked", 1, true), "Held-item gifting must not depend on the trade lock")
assert(not service:find("SETTINGS_ID.TRADE", 1, true), "Held-item gifting must not depend on trade settings")

assert(controller:find("ItemToolUtil.IsItemTool", 1, true), "Gift prompts must only appear for item tools")
assert(controller:find('GIFT_PROMPT_NAME = "GiftPrompt"', 1, true), "Gift prompt name must match AF")
assert(controller:find('ActionText = "Gift"', 1, true), "Gift prompt action text must be Gift")
assert(controller:find("PromptUtil.Create", 1, true), "Gift prompts must use the shared prompt helper")
assert(controller:find("Confirm gifting %s to %s?", 1, true), "Senders must confirm before gifting")
assert(controller:find("Accept %s from %s?", 1, true), "Recipients must confirm before accepting")
assert(controller:find("ConfirmGuiClient.OpenConfirmtGui", 1, true), "Gift flow must use ConfirmGui")
assert(controller:find("NotificationClient.GreenNotify", 1, true), "Gift success must use green toasts")
assert(controller:find("NotificationClient.RedNotify", 1, true), "Gift failures must use red toasts")
assert(controller:find('NotificationClient.GreenNotify("Gift received!")', 1, true), "Recipients must get a gift-received toast")
assert(controller:find("equipReceivedTool", 1, true), "Recipients should auto-equip when empty-handed")
assert(not controller:find("PotionToolUtil", 1, true), "Potions must not be giftable from the client")
assert(not controller:find("ShovelToolUtil", 1, true), "Shovels must not be giftable from the client")

local disabledConfig = assert(loadstring(read("src/ReplicatedStorage/Modules/HeldGiftFeatureConfig.lua")))()
local giftController = assert(load(controller, "GiftController", "t", setmetatable({
	game = {
		GetService = function(_, name)
			if name == "Players" then
				return { LocalPlayer = {} }
			end
			assert(name == "ReplicatedStorage")
			return {
				Modules = { HeldGiftFeatureConfig = disabledConfig },
				Packages = {
					Knit = {
						CreateController = function(value) return value end,
						GetService = function() error("Disabled gifting must not bind its service") end,
					},
				},
			}
		end,
	},
	require = function(value) return value end,
}, { __index = getfenv() })))()
giftController:KnitStart()

print("GiftHeldItem.test.lua passed")
