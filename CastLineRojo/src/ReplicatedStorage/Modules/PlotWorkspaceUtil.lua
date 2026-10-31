local Workspace = game:GetService("Workspace")

local PlotWorkspaceUtil = {}

local function getSlotId(plot: Instance): number?
	local parsed = tonumber(plot.Name:match("^Plot_(%d+)$"))
	return if parsed and parsed >= 1 and parsed % 1 == 0 then parsed else nil
end

function PlotWorkspaceUtil.isValidPlot(plot: Instance?): boolean
	return plot ~= nil and plot:IsA("Model") and getSlotId(plot) ~= nil
end

function PlotWorkspaceUtil.getSlotId(plot: Instance): number?
	return getSlotId(plot)
end

function PlotWorkspaceUtil.getSortedPlots(): { Instance }
	local areas = Workspace:FindFirstChild("Areas")
	local plotRoot = areas and areas:FindFirstChild("Plot")
	if not plotRoot then
		return {}
	end

	local plots = {}
	for _, child in ipairs(plotRoot:GetChildren()) do
		if PlotWorkspaceUtil.isValidPlot(child) then
			table.insert(plots, child)
		end
	end
	table.sort(plots, function(left, right)
		return (getSlotId(left) or math.huge) < (getSlotId(right) or math.huge)
	end)
	return plots
end

function PlotWorkspaceUtil.getPlotBySlot(slotId: number): Instance?
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		if getSlotId(plot) == slotId then
			return plot
		end
	end
	return nil
end

return PlotWorkspaceUtil
