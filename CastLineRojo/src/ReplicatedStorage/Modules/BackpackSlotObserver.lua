local BackpackSlotObserver = {}
BackpackSlotObserver.__index = BackpackSlotObserver

export type Config = {
	player: Player,
	playerGui: PlayerGui,
	isRelevantTool: (tool: Tool) -> boolean,
	onSlotAdded: ((slot: TextButton) -> ())?,
	onSlotTextChanged: ((slot: TextButton) -> ())?,
	onSlotToolChanged: ((slot: TextButton, tool: Tool?) -> ())?,
	onSlotRemoving: ((slot: TextButton) -> ())?,
	onToolAdded: ((tool: Tool) -> ())?,
	onToolRemoved: ((tool: Tool) -> ())?,
}

local function isSlot(instance: Instance): boolean
	return instance:IsA("TextButton")
		and tonumber(instance.Name) ~= nil
		and instance:FindFirstChild("Icon") ~= nil
		and instance:FindFirstChild("ToolName") ~= nil
end

local function getSlot(instance: Instance): TextButton?
	if isSlot(instance) then
		return instance :: TextButton
	end

	local ancestor = instance:FindFirstAncestorWhichIsA("TextButton")
	if ancestor and isSlot(ancestor) then
		return ancestor :: TextButton
	end

	return nil
end

function BackpackSlotObserver.new(config: Config)
	local self = setmetatable({}, BackpackSlotObserver)
	self._config = config
	self._connections = {} :: { RBXScriptConnection }
	self._slotConnections = {} :: { [TextButton]: { RBXScriptConnection } }
	self._containerConnections = {} :: { [Instance]: { RBXScriptConnection } }
	self._backpackGuiConnections = {} :: { [Instance]: { RBXScriptConnection } }
	self._currentCharacter = nil :: Model?
	self._currentBackpack = nil :: Backpack?
	self:_bindPlayer()
	self:_bindBackpackGui(config.playerGui:FindFirstChild("BackpackGui"))
	self:_setBackpack(config.player:FindFirstChildOfClass("Backpack"))
	self:_setCharacter(config.player.Character)
	return self
end

function BackpackSlotObserver:_trackSlot(slot: TextButton)
	if self._slotConnections[slot] then
		return
	end

	local toolName = slot:FindFirstChild("ToolName")
	if not toolName or not toolName:IsA("TextLabel") then
		return
	end

	local connections: { RBXScriptConnection } = {}
	self._slotConnections[slot] = connections
	table.insert(connections, toolName:GetPropertyChangedSignal("Text"):Connect(function()
		local callback = self._config.onSlotTextChanged
		if callback then
			callback(slot)
		end
	end))
	local toolReference = slot:FindFirstChild("ToolReference")
	if toolReference and toolReference:IsA("ObjectValue") then
		table.insert(connections, toolReference:GetPropertyChangedSignal("Value"):Connect(function()
			local callback = self._config.onSlotToolChanged
			if callback then
				local value = toolReference.Value
				callback(slot, if value and value:IsA("Tool") then value else nil)
			end
		end))
	end
	table.insert(connections, slot.Destroying:Connect(function()
		local slotConnections = self._slotConnections[slot]
		if slotConnections then
			for _, connection in ipairs(slotConnections) do
				connection:Disconnect()
			end
			self._slotConnections[slot] = nil
		end
		local callback = self._config.onSlotRemoving
		if callback then
			callback(slot)
		end
	end))

	local callback = self._config.onSlotAdded
	if callback then
		callback(slot)
	end
end

function BackpackSlotObserver:_bindBackpackGui(backpackGui: Instance?)
	if not backpackGui or self._backpackGuiConnections[backpackGui] then
		return
	end

	for _, descendant in ipairs(backpackGui:GetDescendants()) do
		local slot = getSlot(descendant)
		if slot then
			self:_trackSlot(slot)
		end
	end

	local connections: { RBXScriptConnection } = {}
	self._backpackGuiConnections[backpackGui] = connections
	table.insert(connections, backpackGui.DescendantAdded:Connect(function(descendant)
		local slot = getSlot(descendant)
		if slot then
			self:_trackSlot(slot)
		end
	end))
	table.insert(connections, backpackGui.Destroying:Connect(function()
		local guiConnections = self._backpackGuiConnections[backpackGui]
		if guiConnections then
			for _, connection in ipairs(guiConnections) do
				connection:Disconnect()
			end
			self._backpackGuiConnections[backpackGui] = nil
		end
	end))
end

function BackpackSlotObserver:_watchContainer(container: Instance)
	if self._containerConnections[container] then
		return
	end

	local connections: { RBXScriptConnection } = {}
	self._containerConnections[container] = connections
	local function added(child: Instance)
		if child:IsA("Tool") and self._config.isRelevantTool(child) then
			local callback = self._config.onToolAdded
			if callback then
				callback(child)
			end
		end
	end
	local function removed(child: Instance)
		if child:IsA("Tool") and self._config.isRelevantTool(child) then
			local callback = self._config.onToolRemoved
			if callback then
				callback(child)
			end
		end
	end
	for _, child in ipairs(container:GetChildren()) do
		added(child)
	end
	table.insert(connections, container.ChildAdded:Connect(added))
	table.insert(connections, container.ChildRemoved:Connect(removed))
end

function BackpackSlotObserver:_unwatchContainer(container: Instance?)
	if not container then
		return
	end
	local connections = self._containerConnections[container]
	if not connections then
		return
	end
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("Tool") and self._config.isRelevantTool(child) then
			local callback = self._config.onToolRemoved
			if callback then
				callback(child)
			end
		end
	end
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	self._containerConnections[container] = nil
end

function BackpackSlotObserver:_setBackpack(backpack: Backpack?)
	if self._currentBackpack == backpack then
		return
	end
	self:_unwatchContainer(self._currentBackpack)
	self._currentBackpack = backpack
	if backpack then
		self:_watchContainer(backpack)
	end
end

function BackpackSlotObserver:_setCharacter(character: Model?)
	if self._currentCharacter == character then
		return
	end
	self:_unwatchContainer(self._currentCharacter)
	self._currentCharacter = character
	if character then
		self:_watchContainer(character)
	end
end

function BackpackSlotObserver:_bindPlayer()
	local player = self._config.player
	table.insert(self._connections, player.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			self:_setBackpack(child)
		end
	end))
	table.insert(self._connections, player.ChildRemoved:Connect(function(child)
		if child == self._currentBackpack then
			self:_setBackpack(nil)
		end
	end))
	table.insert(self._connections, player.CharacterAdded:Connect(function(character)
		self:_setCharacter(character)
	end))
	table.insert(self._connections, player.CharacterRemoving:Connect(function(character)
		if character == self._currentCharacter then
			self:_setCharacter(nil)
		end
	end))
	table.insert(self._connections, self._config.playerGui.ChildAdded:Connect(function(child)
		if child.Name == "BackpackGui" then
			self:_bindBackpackGui(child)
		end
	end))
end

function BackpackSlotObserver:Destroy()
	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end
	table.clear(self._connections)
	for slot, connections in pairs(self._slotConnections) do
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		self._slotConnections[slot] = nil
	end
	for backpackGui, connections in pairs(self._backpackGuiConnections) do
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		self._backpackGuiConnections[backpackGui] = nil
	end
	self:_unwatchContainer(self._currentBackpack)
	self:_unwatchContainer(self._currentCharacter)
end

return BackpackSlotObserver
