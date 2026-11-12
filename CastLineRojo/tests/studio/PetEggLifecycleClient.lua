-- Temporarily copy to StarterPlayerScripts as a LocalScript through Rojo.
-- Runs only with StudioTestService args { Suite = "PetEggLifecycleQA" }.
if not game:GetService("RunService"):IsStudio() then
	return
end
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local qa = RS:WaitForChild("PetEggLifecycleQA", 60)
if not qa then
	return
end
local Knit = require(RS.Packages.Knit)
local player = Players.LocalPlayer
Knit.OnStart():await()
local remote = qa:WaitForChild("Command")
local PetInventory = require(RS.Modules.PetInventory)
local function snapshot()
	local follow = Knit.GetController("PetFollowController")
	local rows = {}
	for _, owner in ipairs(Players:GetPlayers()) do
		local state = follow._states[owner]
		local row = { count = 0, targets = 0, maxDistance = 0, scalesValid = true, pets = {} }
		for index, visual in ipairs(state and state.visuals or {}) do
			row.count += 1
			local primary = visual.model.PrimaryPart
			row.maxDistance = math.max(row.maxDistance, (primary.Position - visual.target.WorldPosition).Magnitude)
			local template = RS.Models.Pets:FindFirstChild(visual.model.Name)
			local pet = follow._rosters[owner.UserId][index]
			row.pets[pet.UUID] =
				{ size = PetInventory.GetSize(pet), ratio = template and visual.model:GetScale() / template:GetScale() }
			row.scalesValid = row.scalesValid
				and template ~= nil
				and math.abs(template:GetScale() * PetInventory.GetModelScale(pet) - visual.model:GetScale())
					< 0.0001
			for _, part in ipairs(visual.model:GetDescendants()) do
				if part:IsA("BasePart") then
					assert(not part.CanCollide and not part.CanTouch and not part.CanQuery, "Pet collision enabled")
				end
			end
		end
		local root = owner.Character and owner.Character:FindFirstChild("HumanoidRootPart")
		for _, child in ipairs(root and root:GetChildren() or {}) do
			if child.Name:find("PetFollowTarget_", 1, true) then
				row.targets += 1
			end
		end
		rows[tostring(owner.UserId)] = row
	end
	local gui = Knit.GetController("PetGuiController")
	local ids = {}
	for id in pairs(gui._state.Pets) do
		table.insert(ids, id)
	end
	return { owners = rows, inventoryIds = ids, folderCount = #follow._folder:GetChildren() }
end
remote.OnClientInvoke = function(action, data)
	if action == "snapshot" then
		return snapshot()
	elseif action == "craftRpc" then
		local success, response = Knit.GetService("PetService"):CraftPet(data.uuid, data.size):await()
		assert(success, tostring(response))
		return response
	elseif action == "craftUi" then
		local gui = Knit.GetController("PetGuiController")
		local deadline = os.clock() + 10
		while not gui._ready and os.clock() < deadline do
			task.wait(0.1)
		end
		assert(gui._ready, "Pet GUI not ready")
		gui._selected, gui._deleteMode, gui._lockMode = data.uuid, false, false
		gui:_renderPets()
		local before = gui._detail.CraftButton.NameLabel.Text
		gui:_craft(data.all == true)
		while gui._craftBusy and os.clock() < deadline do
			task.wait(0.1)
		end
		assert(not gui._craftBusy, "Craft request did not finish")
		task.wait(0.2)
		return { before = before, after = gui._detail.CraftButton.NameLabel.Text }
	elseif action == "craftModes" then
		local gui = Knit.GetController("PetGuiController")
		gui._selected = data.uuid
		gui._deleteMode, gui._lockMode = false, false
		gui:_renderPets()
		local all = gui._gui.Frame.PetsFrame.CraftAllButton
		local out = {
			normal = all.NameLabel.Text,
			indexRemoved = player.PlayerGui:FindFirstChild("PetIndexGui") == nil,
			luckRemoved = gui._gui:FindFirstChild("FishingLuckLabel", true) == nil,
			detail = gui._detail.CraftButton.NameLabel.Text,
			boost = gui._detail:FindFirstChild("BoostLabel", true).Text,
		}
		gui._deleteMode = true
		gui:_renderPets()
		out.delete = all.NameLabel.Text
		gui._deleteMode, gui._lockMode = false, true
		gui:_renderPets()
		out.lockHidden = not all.Visible
		gui._lockMode = false
		gui:_renderPets()
		return out
	elseif action == "visibility" then
		Knit.GetService("SettingsService").ChangeSetting:Fire(data.key, data.enabled)
		task.wait(0.8)
		return snapshot()
	elseif action == "placement" then
		local c = Knit.GetController("EggPlacementController")
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.lookAt(data.world + Vector3.new(0, 24, 24), data.world)
		local tool
		for _, container in ipairs({ player.Backpack, player.Character }) do
			for _, v in ipairs(container:GetChildren()) do
				if v:GetAttribute("EggInstanceId") == data.uuid then
					tool = v
				end
			end
		end
		assert(tool, "Egg tool not restored")
		-- Initial hotbar restoration temporarily reparents inventory tools.
		task.wait(4.2)
		player.Character.Humanoid:EquipTool(tool)
		task.wait(0.2)
		for _, name in ipairs({ "OfflineResultGui", "LoadingGui" }) do
			local g = player.PlayerGui:FindFirstChild(name)
			if g then
				require(RS.Modules.GuiAnimation).PopModal(g)
				g.Enabled = false
			end
		end
		local point = camera:WorldToScreenPoint(data.world)
		c:_updatePreview(Vector2.new(point.X, point.Y))
		return {
			valid = c._valid,
			position = c._position,
			screen = Vector2.new(point.X, point.Y),
			touch = game:GetService("UserInputService").TouchEnabled,
			record = c._eggs[data.uuid],
			preview = c._preview ~= nil,
			toolId = tool:GetAttribute("EggInstanceId"),
			toolParent = tool.Parent and tool.Parent:GetFullName(),
			groundQuery = workspace.Areas.Plot:FindFirstChild("Plot_" .. tostring(player:GetAttribute("PlotSlotId"))).Ground.CanQuery,
			rootDistance = c._position and (player.Character.HumanoidRootPart.Position - c._position).Magnitude,
			eggs = c._eggs,
		}
	elseif action == "place" then
		Knit.GetController("EggPlacementController"):_place(data)
		task.wait(0.5)
		return true
	elseif action == "inventory" then
		local eggs = {}
		for _, container in ipairs({ player.Backpack, player.Character }) do
			for _, tool in ipairs(container:GetChildren()) do
				local uuid = tool:GetAttribute("EggInstanceId")
				if uuid then
					eggs[uuid] = (eggs[uuid] or 0) + 1
				end
			end
		end
		return eggs
	elseif action == "hotbar" then
		local layout = {}
		local gui = player.PlayerGui:FindFirstChild("BackpackGui")
		local hotbar = gui and gui:FindFirstChild("Hotbar", true)
		for _, slot in ipairs(hotbar and hotbar:GetChildren() or {}) do
			local ref = slot:FindFirstChild("ToolReference")
			if ref and ref.Value and ref.Value:GetAttribute("EggInstanceId") then
				layout[slot.Name] = ref.Value:GetAttribute("EggInstanceId")
			end
		end
		return layout
	elseif action == "previewMiss" then
		local c = Knit.GetController("EggPlacementController")
		c:_updatePreview(Vector2.new(-10000, -10000))
		return { valid = c._valid, visible = c._preview ~= nil and c._preview.Parent ~= nil }
	elseif action == "virtualTap" then
		local UIS = game:GetService("UserInputService")
		task.wait(0.3)
		local point = workspace.CurrentCamera:WorldToScreenPoint(data.world)
		local pointer = Vector2.new(point.X, point.Y)
		local taps, inputs, tapDetails = 0, {}, {}
		local tapConnection = UIS.TouchTap:Connect(function(points, processed)
			taps += 1
			local gate = require(RS.Modules.GameplayInputGate)
			local controller = Knit.GetController("EggPlacementController")
			local ground =
				workspace.Areas.Plot:FindFirstChild("Plot_" .. tostring(player:GetAttribute("PlotSlotId"))).Ground
			local ray = workspace.CurrentCamera:ScreenPointToRay(points[1].X, points[1].Y)
			local params = RaycastParams.new()
			params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Include, { ground }
			local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
			table.insert(tapDetails, {
				processed = processed,
				x = points[1].X,
				y = points[1].Y,
				allowed = gate.IsPlacementActionAllowed(),
				popup = gate.IsActive("Popup"),
				backpack = gate.IsActive("Backpack"),
				fishing = gate.IsActive("Fishing"),
				valid = controller._valid,
				busy = controller._busy,
				position = tostring(controller._position),
				rayHit = hit and hit.Position,
			})
		end)
		local inputConnection = UIS.InputBegan:Connect(function(input)
			table.insert(inputs, input.UserInputType.Name)
		end)
		local sent, message = pcall(function()
			local virtual = UIS:CreateVirtualInput()
			virtual:SendMousePosition(pointer)
			virtual:SendMouseButton(pointer, Enum.UserInputType.MouseButton1, true)
			task.wait(0.1)
			virtual:SendMouseButton(pointer, Enum.UserInputType.MouseButton1, false)
		end)
		task.wait(0.5)
		local guiHits = {}
		for _, gui in ipairs(player.PlayerGui:GetGuiObjectsAtPosition(pointer.X, pointer.Y)) do
			if #guiHits < 8 then
				table.insert(guiHits, { path = gui:GetFullName(), active = gui.Active })
			end
		end
		tapConnection:Disconnect()
		inputConnection:Disconnect()
		return {
			sent = sent,
			error = if not sent then tostring(message) else nil,
			taps = taps,
			inputs = inputs,
			details = tapDetails,
			guiHits = guiHits,
		}
	end
	error("Unknown QA command: " .. action)
end
player:SetAttribute("PetEggLifecycleReady", true)
qa:WaitForChild("Ready"):FireServer()
