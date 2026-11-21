local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(ReplicatedStorage.Modules.GlobalLeaderboardConfig)
local Constants = require(ReplicatedStorage.Modules.Constants)

-- Initializes automatic canvas sizing for ScrollingFrames added to PlayerGui.
require(ReplicatedStorage.Modules.GuiUtil)

type BoardType = Config.BoardType
type RankRow = Config.RankRow
type Rankings = Config.Rankings

local GlobalLeaderboardController = Knit.CreateController {
	Name = "GlobalLeaderboardController",
}

local LOCAL_PLAYER = Players.LocalPlayer
local RANK_COLORS = { Constants.COLOR.YELLOW, Constants.COLOR.PURPLE, Constants.COLOR.BLUE_LIGHT }

local function getAnchor(gap: Instance?, name: string): BasePart?
	local anchor = gap and gap:FindFirstChild(name)
	return if anchor and anchor:IsA("BasePart") then anchor else nil
end

local function placeBoard(model: Model, anchor: BasePart)
	local pivot = model:GetPivot()
	local base = model.Box002
	local mount = CFrame.new(base.Position) * pivot.Rotation
	model:PivotTo(anchor.CFrame * mount:ToObjectSpace(pivot))
	for _, part in model:GetDescendants() do
		if not part:IsA("BasePart") then continue end
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = part == model.PrimaryPart
	end
end

local function renderRows(display, boardType: BoardType, rows: { RankRow }?)
	local count = if rows then #rows else 0
	for index = #display.Rows, math.max(count, 1) + 1, -1 do
		display.Rows[index]:Destroy()
		display.Rows[index] = nil
	end
	for index = 1, math.max(count, 1) do
		local frame = display.Rows[index]
		if not frame then
			frame = display.Template:Clone()
			frame.Name = tostring(index)
			frame.LayoutOrder = index
			frame.Visible = true
			frame.Parent = display.List
			display.Rows[index] = frame
		end

		local row = rows and rows[index]
		frame.RankLabel.Text = if row then "#" .. row.Rank else ""
		frame.NameLabel.Text = if row then row.DisplayName elseif rows then "No rankings yet" else "Loading..."
		frame.ValueLabel.Text = if row then Config.FormatValue(boardType, row.Value) else ""
		frame.RankLabel.TextColor3 = (row and RANK_COLORS[row.Rank]) or display.Template.RankLabel.TextColor3
	end
end

function GlobalLeaderboardController:KnitStart()
	local service = Knit.GetService("GlobalLeaderboardService")
	local rankings: Rankings = { Revision = -1, Boards = {} }
	local personalBest: { [BoardType]: number } = {}
	local displays = {}

	local function applyRankings(snapshot: Rankings)
		if snapshot.Revision <= rankings.Revision then return end
		rankings = snapshot
		for boardType, display in displays do
			renderRows(display, boardType, rankings.Boards[boardType])
		end
	end

	local function applyPersonalBest(boardType: BoardType, score: number)
		local best = math.max(personalBest[boardType] or 0, score)
		personalBest[boardType] = best
		local display = displays[boardType]
		if display then
			display.Best.Text = Config.FormatValue(boardType, best)
		end
	end

	service.RankingsChanged:Connect(applyRankings)
	service.UpdateMyBestData:Connect(applyPersonalBest)
	service:GetSnapshot():andThen(function(snapshot)
		applyRankings(snapshot.Rankings)
		for boardType, score in snapshot.PersonalBest do
			applyPersonalBest(boardType, score)
		end
	end):catch(function(err)
		warn("GlobalLeaderboard: could not load initial rankings", err)
	end)

	task.spawn(function()
		local assets = ReplicatedStorage:WaitForChild(Config.AssetsName, 30)
		local anchors = Workspace:WaitForChild(Config.AnchorsName, 30)
		local playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
		if not assets or not anchors then
			warn("GlobalLeaderboard: templates or placement anchors are missing")
			return
		end
		local guiTemplate = assets:WaitForChild("LeaderboardGui", 10)
		if not guiTemplate or not guiTemplate:IsA("SurfaceGui") then
			warn("GlobalLeaderboard: replicated GUI template is missing")
			return
		end

		local templates = {}
		for _, boardType in Config.Types do
			local model = assets:WaitForChild(boardType .. "Leaderboard", 10)
			if not model or not model:IsA("Model") then
				warn("GlobalLeaderboard: replicated model is missing for " .. boardType)
				return
			end
			templates[boardType] = model
		end

		local modelFolder = Instance.new("Folder")
		modelFolder.Name = "LocalLeaderboards"
		modelFolder.Parent = Workspace

		local function placeForPlot()
			for _, display in displays do
				display.Gui:Destroy()
				display.Model:Destroy()
			end
			table.clear(displays)

			local slot = LOCAL_PLAYER:GetAttribute("PlotSlotId")
			local leftName, rightName = Config.GetNeighborGaps(slot)
			if not leftName or not rightName then return end
			local left = anchors:FindFirstChild(leftName)
			local right = anchors:FindFirstChild(rightName)
			local placement = {
				Fish = getAnchor(left, "B"),
				Wins = getAnchor(left, "A"),
				Weight = getAnchor(right, "A"),
				Playtime = getAnchor(right, "B"),
			}

			for _, boardType in Config.Types do
				local anchor = placement[boardType]
				if not anchor then
					warn("GlobalLeaderboard: invalid anchor for " .. boardType .. " at plot " .. tostring(slot))
					continue
				end

				local model = templates[boardType]:Clone()
				placeBoard(model, anchor)

				local gui = guiTemplate:Clone()
				gui.Name = boardType .. "LeaderboardGui"
				gui.Adornee = model.PrimaryPart
				gui.ResetOnSpawn = false
				gui.Enabled = true
				local container = gui:FindFirstChild("Frame") or gui
				local list = container.ListFrame
				local template = list.Template
				local best = container.BestLabel.ValueLabel
				template.Visible = false
				container.ValueLabel.Text = Config.Boards[boardType].Label
				local resetTime = container:FindFirstChild("ResetTime")
				if resetTime and resetTime:IsA("GuiObject") then
					resetTime.Visible = false
				end

				local display = { Gui = gui, Model = model, List = list, Template = template, Best = best, Rows = {} }
				displays[boardType] = display
				applyPersonalBest(boardType, personalBest[boardType] or 0)
				renderRows(display, boardType, rankings.Boards[boardType])
				model.Parent = modelFolder
				gui.Parent = playerGui
			end
		end

		LOCAL_PLAYER:GetAttributeChangedSignal("PlotSlotId"):Connect(placeForPlot)
		placeForPlot()
	end)
end

return GlobalLeaderboardController
