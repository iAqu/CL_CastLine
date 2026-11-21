local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishingSpotUtil = require(ReplicatedStorage.Modules.FishingSpotUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)

local controller = Knit.CreateController({ Name = "FishingHintController" })
local player = Players.LocalPlayer
local ARROW_FLOAT = TweenInfo.new(math.pi / 5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

function controller:KnitStart()
	local template = ReplicatedStorage:WaitForChild("FishingHint", 10)
	if not template or not template:IsA("BasePart") then
		warn("FishingHintController: missing FishingHint template")
		return
	end
	local overhead = template:FindFirstChild("Overhead")
	if not overhead or not overhead:IsA("BillboardGui") then
		warn("FishingHintController: missing FishingHint.Overhead")
		return
	end
	local areas = workspace:WaitForChild("Areas", 10)
	local plotRoot = areas and areas:WaitForChild("Plot", 10)
	if not plotRoot then
		return
	end

	local boundPlot: Instance? = nil
	local boundPart: BasePart? = nil
	local hint: BasePart? = nil
	local arrowTween: Tween? = nil
	local positionConnection: RBXScriptConnection? = nil
	local plotConnections: { RBXScriptConnection } = {}

	local function updateHint()
		local plot = boundPlot
		local startPart = if plot and plot:GetAttribute("OwnerUserId") == player.UserId
			then FishingSpotUtil.GetStartPart(plot)
			else nil
		if startPart == boundPart then
			return
		end
		boundPart = startPart
		if positionConnection then
			positionConnection:Disconnect()
			positionConnection = nil
		end
		if arrowTween then
			arrowTween:Cancel()
			arrowTween:Destroy()
			arrowTween = nil
		end
		if hint then
			hint:Destroy()
			hint = nil
		end
		if not startPart then
			return
		end

		local clone = template:Clone()
		clone.CFrame = startPart.CFrame
		clone.Overhead.Enabled = true
		local arrow = clone:FindFirstChild("Arrow", true)
		if arrow and arrow:IsA("TextLabel") then
			local center = arrow.Position
			local height = arrow.Size.Y
			local travel = UDim2.new(0, 0, height.Scale / 4, height.Offset / 4)
			arrow.Position = center - travel
			arrowTween = TweenService:Create(arrow, ARROW_FLOAT, { Position = center + travel })
			arrowTween:Play()
		end
		clone.Parent = plot
		hint = clone
		positionConnection = startPart:GetPropertyChangedSignal("CFrame"):Connect(function()
			clone.CFrame = startPart.CFrame
		end)
	end

	local function bindPlot()
		local slot = player:GetAttribute("PlotSlotId")
		local plot = if typeof(slot) == "number" then PlotWorkspaceUtil.getPlotBySlot(slot) else nil
		if plot == boundPlot then
			return
		end
		for _, connection in plotConnections do
			connection:Disconnect()
		end
		table.clear(plotConnections)
		boundPlot = plot
		if plot then
			local function onPlotChildChanged(child: Instance)
				if child.Name == "FishingStartPart" then
					updateHint()
				end
			end
			table.insert(plotConnections, plot:GetAttributeChangedSignal("OwnerUserId"):Connect(updateHint))
			table.insert(plotConnections, plot.ChildAdded:Connect(onPlotChildChanged))
			table.insert(plotConnections, plot.ChildRemoved:Connect(onPlotChildChanged))
		end
		updateHint()
	end

	player:GetAttributeChangedSignal("PlotSlotId"):Connect(bindPlot)
	plotRoot.ChildAdded:Connect(bindPlot)
	plotRoot.ChildRemoved:Connect(bindPlot)
	bindPlot()
end

return controller
