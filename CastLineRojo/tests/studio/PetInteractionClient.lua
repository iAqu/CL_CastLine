-- Temporarily copy through Rojo to StarterPlayerScripts as PetInteractionQA.client.lua.
-- Studio-only QA uses local fixtures and a fake service; never writes player profiles.
-- Invoke PlayerGui.PetInteractionQA from the Studio Client datamodel, then remove the copy.
if not game:GetService("RunService"):IsStudio() then
	return
end
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(RS.Packages.Knit)
local Promise = require(Knit.Util.Promise)
local Animation = require(RS.Modules.GuiAnimation)
Knit.OnStart():await()
local c = Knit.GetController("PetGuiController")
local deadline = os.clock() + 30
while not c._ready and os.clock() < deadline do
	task.wait(0.1)
end
assert(c._ready, "Pet GUI not ready")
local playerGui = Players.LocalPlayer.PlayerGui
local originalService, originalState = c._service, c._state
local bridge = Instance.new("BindableFunction")
bridge.Name = "PetInteractionQA"
local requests = {}
local function fixture()
	return {
		Pets = {
			qaEquipped = { UUID = "qaEquipped", PetID = "Pet001", Equipped = true, Locked = false, Size = 0 },
			qaLocked = { UUID = "qaLocked", PetID = "Pet002", Equipped = false, Locked = true, Size = 1 },
			qaFree = { UUID = "qaFree", PetID = "Pet003", Equipped = false, Locked = false, Size = 2 },
			qaSecret = { UUID = "qaSecret", PetID = "Pet005", Equipped = false, Locked = false, Size = 0 },
		},
		MaxEquipped = 3,
		MaxStored = 100,
	}
end
local fake = {}
function fake:LockPets(ids)
	table.insert(requests, { action = "lock", ids = ids })
	return Promise.delay(0.2):andThen(function()
		local selected = {}
		for _, uuid in ipairs(ids) do
			selected[uuid] = true
		end
		for uuid, pet in pairs(c._state.Pets) do
			pet.Locked = selected[uuid] == true
		end
		return { ok = true }
	end)
end
function fake:DeletePets(ids)
	table.insert(requests, { action = "delete", ids = ids })
	return Promise.delay(0.2):andThen(function()
		for _, uuid in ipairs(ids) do
			local pet = c._state.Pets[uuid]
			assert(not pet.Equipped and not pet.Locked, "UI sent a protected pet")
			c._state.Pets[uuid] = nil
		end
		return { ok = true, deleted = #ids }
	end)
end
function fake:EquipBest()
	table.insert(requests, { action = "equipBest" })
	return Promise.resolve(true)
end
function fake:UnequipAll()
	table.insert(requests, { action = "unequipAll" })
	return Promise.resolve(true)
end
function fake:EquipPet(uuid, equipped)
	table.insert(requests, { action = "equip", uuid = uuid })
	c._state.Pets[uuid].Equipped = equipped
	return Promise.resolve({ ok = true })
end
local function snapshot()
	local main = c._gui.Frame.PetsFrame
	local out = {
		open = c._gui.Enabled,
		delete = c._deleteMode,
		lock = c._lockMode,
		detail = c._detail.Visible,
		showingDetail = c._showDetail,
		selected = c._selected,
		confirm = c._gui.DeleteConfirmFrame.Visible,
		pending = c._pending ~= nil,
		buttons = {},
		pets = {},
		requests = requests,
		selectedDelete = c._selectedDelete,
		draft = c._draftLocks,
		grid = tostring(c._grid.Size),
		padding = tostring(c._grid.UIGridLayout.CellPadding),
		detailName = c._detail.NameLabel.Text,
		detailBoost = c._detail.BoostLabel.Text,
		capacity = { main.InfoFrame.MaxEquipLabel.Text, main.InfoFrame.MaxStoreLabel.Text },
		dots = {
			playerGui.HomeGui.LeftFrame.MenuFrame.PetFrame.PetButton.Dot.Visible,
			playerGui.HomeGui.RightFrame.MenuFrame_b.PetsFrame.PetsButton.Dot.Visible,
		},
	}
	for _, name in ipairs({
		"EquipBestButton",
		"CraftAllButton",
		"UnquipAllButton",
		"MultiDeleteButton",
		"MultiLockButton",
	}) do
		local b = main[name]
		out.buttons[name] = {
			visible = b.Visible,
			active = b.Interactable,
			text = b:FindFirstChild("NameLabel") and b.NameLabel.Text,
		}
	end
	out.deleteSkin = main.UnquipAllButton.Delete.Visible
	for _, row in ipairs(c._grid:GetChildren()) do
		if row:GetAttribute("PetEntry") then
			local b = row.PetButton
			out.pets[row.Name] = {
				order = row.LayoutOrder,
				locked = b.LockImage.Visible,
				deleted = b.DeleteLabel.Visible,
				portraitSize = tostring(b.CanvasGroup.PortraitFrame.ImageLabel.Size),
			}
		end
	end
	return out
end
bridge.OnInvoke = function(action, value)
	if action == "seed" then
		c:CloseGui()
		c._state, c._service, requests = fixture(), fake, {}
		c:OpenGui()
		task.wait(0.3)
	elseif action == "snapshot" then
		return snapshot()
	elseif action == "detail" then
		c:_selectPet(value)
		task.wait(0.5)
	elseif action == "reset" then
		c:ResetGui()
	elseif action == "externalClose" then
		Animation.OpenGui(playerGui.SettingsGui)
		task.wait(0.4)
	elseif action == "reopen" then
		c:OpenGui()
		task.wait(0.3)
	elseif action == "hover" then
		local frame = if value == "qaSecret" then c._gui.HoverInfo_Exclusive else c._gui.HoverInfo
		c:_renderHover(frame, value)
		return {
			boost = frame.Container.BoostLabel.Text,
			name = frame.Container.NameLabel.Text,
			infoVisible = frame.Container:FindFirstChild("InfoLabel") and frame.Container.InfoLabel.Visible,
			evolution = frame.Container.RevolutionLabel.Visible,
		}
	elseif action == "empty" then
		c._state.Pets = {}
		c:_renderPets()
	elseif action == "raceEquip" then
		c._state.Pets.qaFree.Equipped = true
		c:_renderPets()
	elseif action == "finish" then
		c:CloseGui()
		c._service, c._state = originalService, originalState
		c:_renderPets()
		bridge:Destroy()
		return { restored = true }
	else
		error("Unknown pet QA action: " .. tostring(action))
	end
	return snapshot()
end
bridge.Parent = playerGui
