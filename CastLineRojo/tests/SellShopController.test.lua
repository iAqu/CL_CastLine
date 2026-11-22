local function signal()
	local listeners = {}
	return {
		Connect = function(_, callback)
			listeners[callback] = true
			return {
				Disconnect = function()
					listeners[callback] = nil
				end,
			}
		end,
		Fire = function(_, ...)
			for callback in table.clone(listeners) do
				callback(...)
			end
		end,
	}
end
local function node(class, name)
	local children, properties = {}, {}
	local changed = signal()
	local object = { Name = name or class, Activated = signal(), CharacterRemoving = signal() }
	function object:IsA(kind)
		return kind == class
			or (kind == "GuiButton" and (class == "ImageButton" or class == "TextButton"))
			or (kind == "GuiObject" and class == "Frame")
	end
	function object:GetChildren()
		return table.clone(children)
	end
	function object:FindFirstChild(key)
		for _, child in children do
			if child.Name == key then
				return child
			end
		end
	end
	function object:WaitForChild(key)
		return assert(self:FindFirstChild(key), key)
	end
	function object:GetPropertyChangedSignal()
		return changed
	end
	function object:Add(child)
		table.insert(children, child)
		return child
	end
	function object:Destroy()
		self.destroyed = true
		if self.Parent then
			for index, child in self.Parent:GetChildren() do
				if child == self then
					self.Parent:Remove(index)
					break
				end
			end
		end
	end
	function object:Remove(index)
		table.remove(children, index)
	end
	function object:Clone()
		local clone = node(class, self.Name)
		for key, value in properties do
			if key ~= "Parent" then
				clone[key] = value
			end
		end
		for _, child in children do
			clone:Add(child:Clone())
		end
		return clone
	end
	return setmetatable(object, {
		__index = function(self, key)
			return properties[key] or self:FindFirstChild(key)
		end,
		__newindex = function(self, key, value)
			local previous = properties[key]
			properties[key] = value
			if key == "Parent" and value then
				value:Add(self)
			end
			if key == "Enabled" and previous ~= value then
				changed:Fire()
			end
		end,
	})
end
local function promise()
	local pending = {}
	function pending:timeout() return self end
	function pending:andThen(callback)
		self.success = callback
		return self
	end
	function pending:catch(callback)
		self.failure = callback
		return self
	end
	function pending:finally(callback)
		self.finish = callback
		return self
	end
	function pending:Resolve(value)
		local ok, err = pcall(self.success, value)
		if not ok then
			if self.failure then
				self.failure(err)
			else
				error(err)
			end
		end
		if self.finish then
			self.finish()
		end
	end
	return pending
end
local playerGui = node("PlayerGui")
local gui = playerGui:Add(node("ScreenGui", "SellGui"))
local frame = gui:Add(node("Frame", "Frame"))
local list = frame:Add(node("ScrollingFrame", "ScrollingFrame"))
local template = list:Add(node("Frame", "Template"))
list.ScrollingEnabled = true
for _, name in { "NameLabel", "PriceLabel", "CpsLabel", "MutationLabel" } do
	template:Add(node("TextLabel", name))
end
local button = template:Add(node("TextButton", "SellButton"))
button:Add(node("TextLabel", "NumberLabel"))
local display = template:Add(node("Frame", "DisplayImage"))
display:Add(node("ImageLabel", "ICON"))
local sellAll = list:Add(node("Frame", "SellAll"))
sellAll:Add(node("TextLabel", "PriceLabel"))
sellAll:Add(node("TextButton", "SellButton")):Add(node("TextLabel", "NumberLabel"))
local closeButton = frame:Add(node("ImageButton", "CloseButton"))
local confirmation = gui:Add(node("Frame", "SellConfirmFrame"))
confirmation.Visible = true
local confirmText = confirmation:Add(node("TextLabel", "ConfirmTextLabel"))
local confirmButton = confirmation:Add(node("ImageButton", "ConfirmButton"))
local cancelButton = confirmation:Add(node("ImageButton", "CancelButton"))
local titleFrame = playerGui
	:Add(node("ScreenGui", "TitleGui"))
	:Add(node("BillboardGui", "FishTitleTemplate"))
	:Add(node("Frame", "Frame"))
local golden = titleFrame:Add(node("TextLabel", "MutationLabel_Golden"))
golden.Text, golden.FontFace, golden.TextColor3 = "Golden", "CustomHeavyItalic", "gold"
golden:Add(node("UIGradient", "UIGradient"))
golden:Add(node("UIStroke", "UIStroke"))
local player = node("Player")
player:Add(playerGui)
player.Character = {}
local loaded, entry, exit, worldAllowed, otherPopup = false, false, false, true, false
function player:GetAttribute()
	return loaded
end
local heartbeat, inventoryChanged = signal(), signal()
local fetches, sales, deferred, notifications = {}, {}, {}, {}
local function shopAnchor()
	return { CFrame = { Position = {}, LookVector = {}, RightVector = {} } }
end
local anchor = shopAnchor()
local currentAnchor = anchor
local workspace = node("Workspace")
local plotTemplates = node("Folder", "PlotTemplates")
local shopTemplate = plotTemplates:Add(node("Model", "SellShop"))
local primaryPart = shopTemplate:Add(node("MeshPart", "ActivationCircle"))
local pivotOffset = {}
local modelPivot = {}
primaryPart.CFrame = {
	ToObjectSpace = function(_, pivot)
		assert(pivot == modelPivot, "Shop should account for the primary part's offset from the model pivot")
		return pivotOffset
	end,
}
function shopTemplate.Clone()
	local shop = node("Model", "SellShop")
	shop.PrimaryPart = shop:Add(primaryPart:Clone())
	function shop:GetPivot()
		return modelPivot
	end
	function shop:PivotTo(pivot)
		self.movedTo = pivot
	end
	return shop
end
local availableTemplates
local shopWarnings = 0
local navigationBack, navigationFocus, inventoryStatus
local guiService = { MenuIsOpen = false }
local service = {
	GetSellInventory = function()
		local p = promise()
		table.insert(fetches, p)
		return p
	end,
	RequestSellItems = function(_, ids, total)
		local p = promise()
		table.insert(sales, { ids = table.clone(ids), total = total, promise = p })
		return p
	end,
}
local modules = {
	ShopInventoryStatus = { Bind = function(list)
		return function(message)
			inventoryStatus, list.Visible = message, message == nil
		end
	end },
	ButtonAnimation = { SetUp = function() end },
	FishIconPresentation = {
		ApplyMutation = function(icon, id)
			icon.mutation = id
		end,
	},
	FishInventoryData = { Fish = { DisplayName = "Cod", Icon = "fishIcon", Rarity = "Rare" } },
	GameplayInputGate = {
		IsWorldActionAllowed = function()
			return worldAllowed
		end,
	},
	GuiAnimation = {
		OpenGui = function(g)
			g.Enabled = true
		end,
		CloseGui = function(g)
			g.Enabled = false
		end,
		SetNavigationOptions = function(_, focus, back)
			navigationFocus, navigationBack = focus, back
		end,
		ResetNavigationFocus = function(_, focus)
			navigationFocus = focus
		end,
		IsAllPopupGuisClosed = function()
			return not gui.Enabled and not otherPopup
		end,
	},
	GuiAnimationUtil = { PlayCharacterCashGain = function() end },
	GuiUtil = {
		SetRarityGradient = function(label, rarity)
			label.rarity = rarity
		end,
		AutoResizeScrollingFrame = function() end,
	},
	NotificationClient = {
		RedNotify = function(text)
			table.insert(notifications, text)
		end,
		GreenNotify = function() end,
	},
	NumberUtil = { FormatItemPriceCompact = tostring },
	SellShopZone = {
		ExitMargin = 2,
		GetOwnedAnchor = function()
			return currentAnchor
		end,
		Contains = function(_, _, margin)
			return if margin == 0 then entry else exit
		end,
		CanSell = function()
			return currentAnchor ~= nil and exit
		end,
	},
	SoundHelper = { PlaySound = function() end },
}
local services = {
	GuiService = guiService,
	Players = { LocalPlayer = player },
	ReplicatedFirst = { LoadingAttributes = { LOADING_SCREEN_DONE = "loaded" } },
	RunService = { Heartbeat = heartbeat },
	UserInputService = { PreferredInput = "Gamepad" },
	Workspace = workspace,
	ReplicatedStorage = {
		Modules = modules,
		Packages = {
			Knit = {
				CreateController = function(value)
					return value
				end,
				GetService = function(name)
					if name == "SellService" then
						return service
					end
					if name == "PlotFishService" then
						return { EquippedFishChanged = inventoryChanged }
					end
					return { GiveGamePass = signal() }
				end,
			},
		},
		FindFirstChild = function(_, name)
			return if name == "PlotTemplates" then availableTemplates else nil
		end,
	},
}
local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SellShopController.lua", "r"))
local source = file:read("*a")
file:close()
local controller = assert(load(
	source,
	"SellShopController",
	"t",
	setmetatable({
		game = {
			GetService = function(_, name)
				return assert(services[name], name)
			end,
		},
		require = function(value)
			return value
		end,
		Instance = { new = node },
		CFrame = {
			fromMatrix = function(position, right, up)
				assert(position == currentAnchor.CFrame.Position, "The shop should target the anchor center")
				assert(
					right == currentAnchor.CFrame.LookVector and up == currentAnchor.CFrame.RightVector,
					"The shop should convert the anchor's axes to keep the model upright"
				)
				return setmetatable({}, {
					__mul = function(_, offset)
						assert(offset == pivotOffset, "The move should include the primary part's pivot offset")
						return position
					end,
				})
			end,
		},
		Enum = { PreferredInput = { Gamepad = "Gamepad" }, SelectionBehavior = { Stop = "Stop" } },
		task = {
			defer = function(callback)
				table.insert(deferred, callback)
			end,
		},
		warn = function(message, err)
			if string.find(message, "PlotTemplates.SellShop", 1, true) then
				shopWarnings += 1
				return
			end
			error(message .. ": " .. tostring(err))
		end,
	}, { __index = getfenv() })
))()
local function tick()
	heartbeat:Fire(0.1)
end
local function flush()
	local queued = deferred
	deferred = {}
	for _, callback in queued do
		callback()
	end
end
local function inventory(ids)
	local items = {}
	for _, id in ids do
		table.insert(
			items,
			{
				instanceId = id,
				itemId = "Fish",
				price = 10,
				income = 4,
				mutationId = if id == "b" then "Golden" else nil,
			}
		)
	end
	return { success = true, items = items, totalPrice = #ids * 10 }
end
controller:KnitStart()
assert(not gui.Enabled and not template.Visible and sellAll.SellButton.NumberLabel.Text == "SELL ALL (0)")
assert(not confirmation.Visible)
entry, exit = true, true
tick()
assert(#fetches == 0, "Loading blocks automatic opening")
loaded, worldAllowed = true, false
tick()
assert(#fetches == 0, "Fishing and blocked world input prevent automatic opening")
worldAllowed, otherPopup = true, true
tick()
assert(#fetches == 0)
otherPopup = false
availableTemplates = plotTemplates
tick()
assert(#fetches == 1 and gui.Enabled and inventoryStatus == "Loading...")
assert(not sellAll.SellButton.Interactable and navigationFocus == closeButton)
sellAll.SellButton.Activated:Fire()
assert(#sales == 0)
fetches[1]:Resolve(inventory({ "a", "b" }))
assert(gui.Enabled and not inventoryStatus and list.Fish_a and list.Fish_b and list.Fish_a ~= list.Fish_b)
assert(shopWarnings == 1 and not workspace.LocalPlotProps, "Missing template or primary part warns once without blocking sales")
shopTemplate.PrimaryPart = primaryPart
tick()
local props = workspace.LocalPlotProps
local firstShop = props.SellShop
assert(firstShop.movedTo == anchor.CFrame.Position, "A valid template should generate on the next check")
assert(list.Fish_a.NameLabel.rarity == "Rare" and not list.Fish_a.MutationLabel.Visible)
assert(list.Fish_b.MutationLabel.FontFace == golden.FontFace and list.Fish_b.MutationLabel.UIGradient)
assert(sellAll.SellButton.NumberLabel.Text == "SELL ALL (2)")
assert(list.Fish_a.PriceLabel.Text == "+$10" and list.Fish_a.CpsLabel.Text == "$4/s")

sellAll.SellButton.Activated:Fire()
local expectedQuote = 'Sell <font color="#FFD83D">2</font> fish for <font color="#8FFF2A">$20</font>?'
assert(confirmation.Visible and confirmText.RichText and confirmText.Text == expectedQuote and #sales == 0)
assert(not list.ScrollingEnabled and not sellAll.SellButton.Interactable and not list.Fish_a.SellButton.Interactable)
assert(navigationFocus == cancelButton and guiService.SelectedObject == cancelButton)
list.Fish_a.SellButton.Activated:Fire()
assert(#sales == 0)
cancelButton.Activated:Fire()
assert(gui.Enabled and not confirmation.Visible and #sales == 0 and sellAll.SellButton.Interactable)
assert(list.ScrollingEnabled and navigationFocus == sellAll.SellButton and guiService.SelectedObject == sellAll.SellButton)
sellAll.SellButton.Activated:Fire()
navigationBack()
assert(gui.Enabled and not confirmation.Visible and #sales == 0)
sellAll.SellButton.Activated:Fire()
inventoryChanged:Fire()
inventoryChanged:Fire()
flush()
assert(#fetches == 2, "Inventory changes in the same frame are batched")
fetches[2]:Resolve(inventory({ "a", "b", "new" }))
sellAll.SellButton.Activated:Fire()
assert(confirmText.Text == expectedQuote, "Refreshing and pressing SELL ALL again keep the visible quote")
confirmButton.Activated:Fire()
confirmButton.Activated:Fire()
assert(#sales == 1 and #sales[1].ids == 2 and sales[1].total == 20, "Confirmation freezes IDs and total")
assert(sales[1].ids[1] == "a" and sales[1].ids[2] == "b")
assert(not confirmation.Visible and not sellAll.SellButton.Interactable and list.ScrollingEnabled)
sales[1].promise:Resolve({ success = true, soldCount = 2, earnedCash = 20 })
flush()
fetches[3]:Resolve(inventory({ "new" }))
assert(gui.Enabled and list.Fish_a == nil and list.Fish_new and sellAll.SellButton.NumberLabel.Text == "SELL ALL (1)")

list.Fish_new.SellButton.Activated:Fire()
assert(#sales == 2 and sales[2].ids[1] == "new", "Single fish sells without confirmation")
sales[2].promise:Resolve({ success = false, errorMessage = "Price changed" })
flush()
fetches[4]:Resolve(inventory({ "new" }))
assert(gui.Enabled and notifications[#notifications] == "Price changed")

inventoryChanged:Fire()
flush()
inventoryChanged:Fire()
flush()
fetches[6]:Resolve(inventory({ "new", "latest" }))
fetches[5]:Resolve(inventory({ "obsolete" }))
assert(list.Fish_latest and not list.Fish_obsolete, "Old responses cannot overwrite the newest list")
sellAll.SellButton.Activated:Fire()
exit, entry = false, false
tick()
assert(not gui.Enabled and not confirmation.Visible, "Leaving closes both the shop and confirmation")
confirmButton.Activated:Fire()
assert(#sales == 2)
entry, exit = true, true
tick()
fetches[7]:Resolve(inventory({}))
assert(gui.Enabled and sellAll.SellButton.NumberLabel.Text == "SELL ALL (0)" and not sellAll.SellButton.Interactable)
sellAll.SellButton.Activated:Fire()
assert(not confirmation.Visible and #sales == 2)
closeButton.Activated:Fire()
tick()
assert(not gui.Enabled and #fetches == 7, "Manual close does not immediately reopen")
entry, exit = false, false
tick()
entry, exit = true, true
tick()
assert(gui.Enabled and inventoryStatus == "Loading...")
closeButton.Activated:Fire()
entry, exit = false, false
tick()
entry, exit = true, true
tick()
fetches[8]:Resolve(inventory({ "late" }))
assert(gui.Enabled and inventoryStatus == "Loading..." and not list.Fish_late,
	"An old response cannot fill a new visit")
fetches[9]:Resolve({ success = false, errorMessage = "Inventory unavailable" })
assert(gui.Enabled and inventoryStatus == "Inventory unavailable" and not sellAll.SellButton.Interactable)
entry, exit = false, false
tick()
entry, exit = true, true
tick()
fetches[10]:Resolve(inventory({ "final" }))
assert(not inventoryStatus and list.Fish_final)
sellAll.SellButton.Activated:Fire()
player.CharacterRemoving:Fire()
assert(not gui.Enabled and not confirmation.Visible)
confirmButton.Activated:Fire()
assert(#sales == 2)

player.Character = {}
tick()
assert(props.SellShop == firstShop and #props:GetChildren() == 1, "Respawn should keep the same shop")
fetches[11]:Resolve(inventory({ "external" }))
sellAll.SellButton.Activated:Fire()
assert(confirmation.Visible)
gui.Enabled = false
confirmButton.Activated:Fire()
assert(not confirmation.Visible and list.ScrollingEnabled and #sales == 2, "Disabling the shop cancels the quote")

entry, exit = false, false
currentAnchor = shopAnchor()
tick()
local nextShop = props.SellShop
assert(
	firstShop.destroyed and #props:GetChildren() == 1 and nextShop.movedTo == currentAnchor.CFrame.Position,
	"Changing plots should replace the shop at the new anchor"
)
currentAnchor = nil
tick()
assert(nextShop.destroyed and #props:GetChildren() == 0, "Losing the anchor should remove the shop")
