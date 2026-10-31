local PromptUtil = {}

export type PromptOptions = {
	Name: string?,
	ActionText: string?,
	ObjectText: string?,
	Theme: string?,
	HoldDuration: number?,
	MaxActivationDistance: number?,
	RequiresLineOfSight: boolean?,
	UIOffset: Vector2?,
	Enabled: boolean?,
}

local DEFAULT_NAME = "ProximityPrompt"
local DEFAULT_ACTION_TEXT = ""
local DEFAULT_OBJECT_TEXT = ""
local DEFAULT_HOLD_DURATION = 0

PromptUtil.PROMPT_MAX_DISTANCE = 12
local DEFAULT_MAX_ACTIVATION_DISTANCE = PromptUtil.PROMPT_MAX_DISTANCE

local function applyOptions(prompt: ProximityPrompt, options: PromptOptions?)
	options = options or {}

	prompt.Name = options.Name or prompt.Name or DEFAULT_NAME
	prompt.ActionText = options.ActionText or DEFAULT_ACTION_TEXT
	prompt.ObjectText = options.ObjectText or DEFAULT_OBJECT_TEXT
	prompt.HoldDuration = options.HoldDuration or DEFAULT_HOLD_DURATION
	prompt.RequiresLineOfSight = if options.RequiresLineOfSight == nil then false else options.RequiresLineOfSight
	prompt.MaxActivationDistance = options.MaxActivationDistance or DEFAULT_MAX_ACTIVATION_DISTANCE
	prompt.MaxIndicatorDistance = 0
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	prompt.Style = Enum.ProximityPromptStyle.Custom
	prompt.ClickablePrompt = true
	prompt.AutoLocalize = false
	prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
	prompt.UIOffset = options.UIOffset or Vector2.new(0, 0)

	if options.Theme then
		prompt:SetAttribute("Theme", options.Theme)
	end

	if options.Enabled ~= nil then
		prompt.Enabled = options.Enabled
	end
end

function PromptUtil.Create(parent: Instance, options: PromptOptions?): ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	applyOptions(prompt, options)
	prompt.Parent = parent
	return prompt
end

function PromptUtil.Ensure(parent: Instance, name: string, options: PromptOptions?): ProximityPrompt
	local prompt = parent:FindFirstChild(name)
	if not prompt or not prompt:IsA("ProximityPrompt") then
		if prompt then
			prompt:Destroy()
		end
		prompt = Instance.new("ProximityPrompt")
		prompt.Parent = parent
	end

	local mergedOptions = table.clone(options or {})
	mergedOptions.Name = name
	applyOptions(prompt, mergedOptions)
	return prompt
end

return PromptUtil
