local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local GameplayInputGate = {}

local activeSources: { [string]: { [any]: boolean } } = {}

local function getSources(contextName: string): { [any]: boolean }
	local sources = activeSources[contextName]
	if not sources then
		sources = setmetatable({}, { __mode = "k" })
		activeSources[contextName] = sources
	end
	return sources
end

function GameplayInputGate.SetActive(contextName: string, source: any, active: boolean)
	assert(source ~= nil, "GameplayInputGate source must not be nil")

	local sources = getSources(contextName)
	if active then
		sources[source] = true
	else
		sources[source] = nil
	end
end

function GameplayInputGate.IsActive(contextName: string): boolean
	for _ in getSources(contextName) do
		return true
	end
	return false
end

function GameplayInputGate.IsUiBlockingWorld(): boolean
	return GuiService.MenuIsOpen
		or UserInputService:GetFocusedTextBox() ~= nil
		or GameplayInputGate.IsActive("Popup")
		or GameplayInputGate.IsActive("Backpack")
end

function GameplayInputGate.IsWorldActionAllowed(): boolean
	return not GameplayInputGate.IsUiBlockingWorld()
end

function GameplayInputGate.IsPlacementActionAllowed(): boolean
	return not GameplayInputGate.IsUiBlockingWorld()
end

return GameplayInputGate
