local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Spot = require(script.Parent.TrainingSpotUtil)
local Display = {}
local padStatesByPlot = {}

local function clearIdle(state)
	if state.idleModel then
		state.idleModel:Destroy()
		state.idleModel = nil
	end
	state.idleTrainingId = nil
end

local function clearPad(state)
	if state.padModel then
		padStatesByPlot[state.padPlot] = nil
		local anchor = state.padAnchor
		if anchor.Parent and anchor.Transparency == 1 then
			anchor.Transparency = state.padAnchorTransparency
		end
		state.padModel:Destroy()
	end
	state.padModel, state.padPlot, state.padTemplate = nil, nil, nil
	state.padAnchor, state.padAnchorTransparency = nil, nil
end

function Display.Clear(state)
	clearIdle(state)
	clearPad(state)
end

local function cloneDisplay(template, name, player, item, frame, alignTop)
	if not template or not template:IsA("Model") then
		return nil
	end
	local model = template:Clone()
	if not model then
		return nil
	end
	model.Name = name
	model:SetAttribute("TrainingID", item.TrainingID)
	model:SetAttribute("OwnerUserId", player.UserId)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
		elseif part:IsA("BaseScript") then
			part:Destroy()
		end
	end
	model:PivotTo(frame)
	local box, size = model:GetBoundingBox()
	local edge = box.Position.Y + (if alignTop then size.Y / 2 else -size.Y / 2)
	model:PivotTo(model:GetPivot() + Vector3.yAxis * (frame.Position.Y - edge))
	return model
end

local function syncPad(state, plot, anchor, player, item, models)
	-- A newly assigned owner can sync before the previous owner's next scan.
	local previousState = padStatesByPlot[plot]
	if previousState and previousState ~= state then
		clearPad(previousState)
	end
	local suffix = item.Model:match("^Barbell_(%d+)$")
	local folder = models and models:FindFirstChild("TrainingPads")
	local template = folder and suffix and folder:FindFirstChild("TrainingPad_" .. suffix)
	local pad = state.padModel
	if
		template
		and pad
		and pad.Parent == plot
		and state.padAnchor == anchor
		and state.padTemplate == template
		and pad:GetAttribute("TrainingID") == item.TrainingID
	then
		return
	end
	clearPad(state)
	if not template then
		return
	end
	pad = cloneDisplay(template, "TrainingPadDisplay", player, item, Spot.MarkerCFrame(plot), true)
	if pad then
		pad.Parent = plot
		padStatesByPlot[plot] = state
		state.padModel, state.padPlot, state.padTemplate = pad, plot, template
		state.padAnchor, state.padAnchorTransparency = anchor, anchor.Transparency
		anchor.Transparency = 1
	end
end

function Display.Sync(state, plot, player, item)
	if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		Display.Clear(state)
		return
	end
	local anchor = plot:FindFirstChild("TrainingAnchor")
	if not anchor or not anchor:IsA("BasePart") then
		Display.Clear(state)
		return
	end
	local models = ReplicatedStorage:FindFirstChild("Models")
	syncPad(state, plot, anchor, player, item, models)
	if state.active then
		clearIdle(state)
		return
	end
	if state.idleModel and state.idleModel.Parent == plot and state.idleTrainingId == item.TrainingID then
		return
	end
	clearIdle(state)
	local folder = models and models:FindFirstChild("Barbell")
	local template = folder and folder:FindFirstChild(item.Model)
	local model = cloneDisplay(template, "TrainingBarbellDisplay", player, item, Spot.MarkerCFrame(plot), false)
	if model then
		model.Parent = plot
		state.idleModel, state.idleTrainingId = model, item.TrainingID
	end
end

return Display
