local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local inventory = assert(loadstring(read("src/ReplicatedStorage/Modules/PetInventory.lua")))()
local function dim(x, xo, y, yo)
	return { X = { Scale = x, Offset = xo }, Y = { Scale = y, Offset = yo } }
end
local tweens = {}
local tweenService = {
	Create = function(_, target, info, goals)
		local tween = { info = info, goals = goals }
		tween.Completed = {
			Once = function(_, callback)
				tween.completeCallback = callback
			end,
		}
		function tween:Play()
			self.playing = true
		end
		function tween:Cancel()
			self.cancelled = true
		end
		function tween:Destroy()
			self.destroyed = true
		end
		function tween:Complete()
			if not self.cancelled then
				for key, value in pairs(goals) do
					target[key] = value
				end
				if self.completeCallback then
					self.completeCallback("Completed")
				end
			end
		end
		table.insert(tweens, tween)
		return tween
	end,
}
local errors, successes, hoverHides = {}, {}, 0
local modules = {
	PetFeatureConfig = { Enabled = true },
	PetInventory = inventory,
	NotificationClient = {
		RedNotify = function(message)
			table.insert(errors, message)
		end,
		GreenNotify = function(message)
			table.insert(successes, message)
		end,
	},
	HoverGuiClient = {
		HideInfoHover = function()
			hoverHides += 1
		end,
	},
	GuiHelper = {
		CanOpenGui = function()
			return true
		end,
	},
	GuiAnimation = {
		OpenGui = function(gui)
			gui.Enabled = true
		end,
		CloseGui = function(gui)
			gui.Enabled = false
		end,
	},
	ItemBoundsUtil = {},
	EggToolUtil = {},
	ButtonAnimation = {},
	GuiUtil = {},
	RarityPresentation = {},
}
local configs = { A = { LuckBoost = 2 } }
local services = {
	Players = { LocalPlayer = {} },
	TweenService = tweenService,
	ReplicatedFirst = { Data = { PetsData = configs, EggsData = {} } },
	ReplicatedStorage = {
		Packages = { Knit = {
			CreateController = function(spec)
				return spec
			end,
		} },
		Modules = modules,
	},
}
local chunk = assert(loadstring(read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/PetGuiController.lua")))
setfenv(
	chunk,
	setmetatable({
		game = {
			GetService = function(_, name)
				return assert(services[name], name)
			end,
		},
		require = function(value)
			return value
		end,
		UDim2 = {
			new = dim,
			fromScale = function(x, y)
				return dim(x, 0, y, 0)
			end,
		},
		TweenInfo = {
			new = function(duration, style, direction)
				return { duration = duration, style = style, direction = direction }
			end,
		},
		Enum = {
			EasingStyle = { Back = "Back" },
			EasingDirection = { Out = "Out" },
			PlaybackState = { Completed = "Completed" },
		},
		warn = function() end,
	}, { __index = getfenv() })
)
local controller = chunk()
local function object(class, children)
	local result = children or {}
	result.ClassName = class
	function result:IsA(name)
		return name == self.ClassName or (name == "GuiObject" and self.ClassName ~= "ScreenGui")
	end
	function result:FindFirstChild(name)
		return rawget(self, name)
	end
	return result
end
local function button()
	return object("TextButton", { NameLabel = object("TextLabel"), Visible = true, Interactable = true })
end
local main = {
	EquipBestButton = button(),
	CraftAllButton = button(),
	UnquipAllButton = button(),
	MultiDeleteButton = button(),
	MultiLockButton = button(),
}
main.UnquipAllButton.Delete = object("Frame")
main.UnquipAllButton.UnquipAll = object("Frame")
controller._gui = {
	Enabled = true,
	Frame = { PetsFrame = main },
	DeleteConfirmFrame = object(
		"Frame",
		{ ConfirmButton = button(), CancelButton = button(), SubtitleLabel = object("TextLabel"), Visible = false }
	),
}
controller._state = {
	Pets = {
		equipped = { UUID = "equipped", PetID = "A", Equipped = true, Locked = false },
		locked = { UUID = "locked", PetID = "A", Equipped = false, Locked = true },
		free = { UUID = "free", PetID = "A", Equipped = false, Locked = false },
	},
	MaxEquipped = 3,
	MaxStored = 100,
}
controller._ready, controller._session = true, 0
controller._selectedDelete, controller._draftLocks = {}, {}
controller._gridSize, controller._cellSize, controller._cellPadding =
	dim(0.94, 0, 0.83, 0), dim(0.105, 0, 0.235, 0), dim(0.041, 0, 0.06, 0)
controller._grid = { UIGridLayout = {} }
controller._detail = {}
-- Exercise actual interaction methods with rendering isolated from Roblox Instances.
function controller:_renderPets()
	self:_pruneSelections()
	self:_renderCraftControls()
end
function controller:_renderDetail() end
controller:ResetGui()
assert(main.EquipBestButton.NameLabel.Text == "Equip Best" and main.UnquipAllButton.NameLabel.Text == "Unequip ALL")
assert(main.MultiDeleteButton.Visible and main.MultiLockButton.Visible and not main.UnquipAllButton.Delete.Visible)
controller:_setMode("delete")
assert(main.EquipBestButton.NameLabel.Text == "Cancel" and main.CraftAllButton.NameLabel.Text == "Select All")
assert(
	main.UnquipAllButton.NameLabel.Text == "Delete! (0)"
		and main.UnquipAllButton.Delete.Visible
		and not main.UnquipAllButton.UnquipAll.Visible
)
assert(not main.MultiDeleteButton.Visible and not main.MultiLockButton.Visible)
controller:_clickPet("equipped")
controller:_clickPet("locked")
assert(next(controller._selectedDelete) == nil, "Cannot select protected pets")
controller:_clickPet("free")
assert(main.UnquipAllButton.NameLabel.Text == "Delete! (1)")
controller:_clickPet("free")
controller:_confirmDelete()
assert(not controller._deleteMode, "Zero-selection delete exits")
controller:_setMode("delete")
controller:_selectAllForDelete()
assert(inventory.Count(controller._selectedDelete) == 1 and controller._selectedDelete.free)
controller:_confirmDelete()
assert(controller._gui.DeleteConfirmFrame.Visible)
controller._state.Pets.free.Equipped = true
controller:_pruneSelections()
assert(next(controller._selectedDelete) == nil, "Inventory changes invalidate protected selections")
controller._state.Pets.free.Equipped = false

local function deferred()
	local promise = {}
	function promise:andThen(callback)
		self.success = callback
		return self
	end
	function promise:catch(callback)
		self.failure = callback
		return self
	end
	function promise:finally(callback)
		self.finish = callback
		return self
	end
	function promise:Resolve(result)
		self.success(result)
		self.finish()
	end
	function promise:Reject(reason)
		self.failure(reason)
		self.finish()
	end
	return promise
end
local requests, current = {}, nil
controller._service = {
	LockPets = function(_, ids)
		table.insert(requests, table.clone(ids))
		current = deferred()
		return current
	end,
	DeletePets = function(_, ids)
		table.insert(requests, table.clone(ids))
		current = deferred()
		return current
	end,
}
controller:_setMode("lock")
assert(
	main.UnquipAllButton.NameLabel.Text == "Done"
		and not main.EquipBestButton.Visible
		and not main.CraftAllButton.Visible
)
assert(not main.MultiDeleteButton.Visible and main.MultiLockButton.Visible)
controller:_clickPet("locked")
controller:_clickPet("free")
assert(not controller._draftLocks.locked and controller._draftLocks.free)
assert(
	controller._state.Pets.locked.Locked and not controller._state.Pets.free.Locked and #requests == 0,
	"Lock clicks remain local"
)
controller:_renderPets()
assert(
	not controller._draftLocks.locked and controller._draftLocks.free,
	"Inventory refresh preserves true and false draft entries"
)
controller:_saveLocks()
assert(#requests == 1 and #requests[1] == 1 and requests[1][1] == "free")
controller:_saveLocks()
controller:_clickPet("equipped")
assert(#requests == 1 and not controller._draftLocks.equipped, "Pending save blocks repeat submission and edits")
assert(not main.UnquipAllButton.Interactable and not controller._gui.DeleteConfirmFrame.ConfirmButton.Interactable)
current:Resolve({ ok = false, message = "retry" })
assert(controller._lockMode and controller._draftLocks.free and errors[#errors] == "retry", "Failed save retains draft")
controller:_saveLocks()
current:Reject("network")
assert(
	controller._lockMode and controller._draftLocks.free and not controller._pending,
	"Transport errors retain draft and release busy"
)
controller:_saveLocks()
current:Resolve({ ok = true })
assert(not controller._lockMode and next(controller._draftLocks) == nil)

controller:_setMode("delete")
controller:_selectAllForDelete()
controller:_confirmDelete()
controller:_deleteSelected()
controller:_deleteSelected()
local count = #requests
current:Resolve({ ok = false, message = "changed" })
assert(
	controller._deleteMode and controller._selectedDelete.free and controller._gui.DeleteConfirmFrame.Visible,
	"Failed delete retains valid selection"
)
controller:_deleteSelected()
assert(#requests == count + 1)
current:Resolve({ ok = true, deleted = 1 })
assert(
	not controller._deleteMode
		and not controller._gui.DeleteConfirmFrame.Visible
		and next(controller._selectedDelete) == nil
)

controller:_setMode("lock")
controller:_clickPet("free")
controller:_saveLocks()
local oldRequest = current
controller:CloseGui()
assert(
	not controller._gui.Enabled
		and not controller._lockMode
		and not controller._selected
		and next(controller._draftLocks) == nil
)
controller:OpenGui()
assert(controller._gui.Enabled and not controller._lockMode and not main.UnquipAllButton.Interactable)
oldRequest:Resolve({ ok = false, message = "stale error" })
assert(
	errors[#errors] ~= "stale error" and not controller._pending and main.UnquipAllButton.Interactable,
	"Closed session callbacks cannot restore mode or report stale errors"
)
controller:_setMode("delete")
controller:_selectAllForDelete()
controller:_confirmDelete()
controller:_deleteSelected()
oldRequest = current
controller:CloseGui()
controller:OpenGui()
oldRequest:Resolve({ ok = true })
assert(not controller._deleteMode and not controller._gui.DeleteConfirmFrame.Visible)

controller:_selectPet("free")
assert(controller._showDetail and controller._detail.Visible)
assert(math.abs(controller._grid.UIGridLayout.CellPadding.X.Scale - 0.041 * 7 / 4) < 1e-9)
assert(tweens[#tweens - 1].info.duration == 0.4 and tweens[#tweens].info.duration == 0.3)
local firstTween = tweens[#tweens]
controller:_selectPet("free")
assert(not controller._showDetail and firstTween.cancelled and firstTween.destroyed)
tweens[#tweens]:Complete()
assert(not controller._detail.Visible)
controller:_selectPet("free")
controller:_selectPet("locked")
assert(controller._showDetail and controller._selected == "locked")
controller:ResetGui()
assert(not controller._detail.Visible and controller._grid.Size == controller._gridSize)
assert(controller._grid.UIGridLayout.CellPadding == controller._cellPadding)
assert(hoverHides > 0)
controller._state.Pets = {}
controller:_renderPets()
for _, name in ipairs({ "EquipBestButton", "CraftAllButton", "UnquipAllButton", "MultiDeleteButton", "MultiLockButton" }) do
	assert(not main[name].Visible, "Empty inventory must hide " .. name)
end
