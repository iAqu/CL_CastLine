local Settings = require(script.Parent.FishingConfig).Bite

local FishShadowAppearance = {}

function FishShadowAppearance.Prepare(fish: Model)
	local state = { originals = {}, surfaces = {} }
	for _, part in ipairs(fish:GetDescendants()) do
		if part:IsA("BaseScript") or part:IsA("AnimationController") or part:IsA("JointInstance")
			or part:IsA("Constraint") or part:IsA("WeldConstraint") or part:IsA("Highlight")
		then
			part:Destroy()
		elseif part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
			part.LocalTransparencyModifier = 0
			if part.Transparency < 1 and part.Name ~= "CameraPart" then
				state.originals[part] = {
					color = part.Color,
					transparency = part.Transparency,
					material = part.Material,
					materialVariant = part.MaterialVariant,
					reflectance = part.Reflectance,
					texture = part:IsA("MeshPart") and part.TextureID or nil,
				}
				part.Color, part.Transparency = Color3.new(0, 0, 0), 1
				if part:IsA("MeshPart") then
					part.TextureID = ""
				end
			end
		elseif part:IsA("SurfaceAppearance") then
			table.insert(state.surfaces, { instance = part, parent = part.Parent })
			part.Parent = nil
		end
	end
	-- Share the same transparent Highlight and skeletal-animation rendering path.
	local humanoid = fish:FindFirstChildOfClass("Humanoid") or Instance.new("Humanoid")
	humanoid.EvaluateStateMachine = false
	humanoid.AutomaticScalingEnabled = false
	humanoid.RequiresNeck = false
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.Parent = fish
	local highlight = Instance.new("Highlight")
	highlight.Name, highlight.Adornee = "FishShadow", fish
	highlight.FillColor, highlight.OutlineColor = Color3.new(0, 0, 0), Color3.fromRGB(254, 254, 254)
	highlight.FillTransparency, highlight.OutlineTransparency = 1, 1
	highlight.DepthMode, highlight.Enabled = Enum.HighlightDepthMode.Occluded, false
	highlight.Parent, state.highlight = fish, highlight
	return state
end

-- Fade values are already eased by the caller; fishing retains its phase timing.
function FishShadowAppearance.Apply(state, visible: boolean, original: boolean, fade: number, highlightFade: number)
	local shadow = visible and not original and fade < 1
	local highlight = state.highlight
	highlight.FillTransparency = if shadow
		then Settings.ShadowTransparency + (1 - Settings.ShadowTransparency) * highlightFade else 1
	highlight.OutlineColor = if original then Color3.new(0, 0, 0) else Color3.fromRGB(254, 254, 254)
	highlight.OutlineTransparency = if original then fade
		elseif shadow then Settings.ShadowOutlineTransparency + (1 - Settings.ShadowOutlineTransparency) * highlightFade ^ 3
		else 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	for part, saved in pairs(state.originals) do
		part.Material = if shadow then Enum.Material.Neon else saved.material
		part.MaterialVariant = if shadow then "" else saved.materialVariant
		part.Reflectance = if shadow then 0 else saved.reflectance
		part.Transparency = if visible then saved.transparency + (1 - saved.transparency) * fade else 1
		if original and not state.originalShown then
			part.Color = saved.color
			if saved.texture then
				part.TextureID = saved.texture
			end
		end
	end
	if original and not state.originalShown then
		state.originalShown = true
		for _, surface in ipairs(state.surfaces) do
			surface.instance.Parent = surface.parent
		end
	end
	-- Enable only after geometry and highlight properties have been applied.
	highlight.Enabled = (visible and original and fade < 1) or (shadow and highlightFade < 1)
end

function FishShadowAppearance.Destroy(state)
	if state then
		for _, surface in ipairs(state.surfaces) do
			surface.instance:Destroy()
		end
	end
end

return FishShadowAppearance
