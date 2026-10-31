local UpgradeSignButtonUtil = {}

function UpgradeSignButtonUtil.Prepare(button: GuiButton): (UIGradient?, UIGradient?)
	if not button:IsA("GuiButton") then
		return nil, nil
	end

	button.AutoButtonColor = false

	local gradient = button:FindFirstChild("UIGradient") :: UIGradient?
	local gradientGrey = button:FindFirstChild("UIGradient_Grey") :: UIGradient?

	return gradient, gradientGrey
end

function UpgradeSignButtonUtil.SetAffordable(
	button: GuiButton,
	gradient: UIGradient?,
	gradientGrey: UIGradient?,
	canAfford: boolean,
	interactable: boolean
)
	if not button:IsA("GuiButton") then
		return
	end

	button.Interactable = interactable

	if gradient and gradientGrey then
		gradient.Enabled = canAfford and interactable
		gradientGrey.Enabled = not canAfford or not interactable
	end
end

return UpgradeSignButtonUtil
