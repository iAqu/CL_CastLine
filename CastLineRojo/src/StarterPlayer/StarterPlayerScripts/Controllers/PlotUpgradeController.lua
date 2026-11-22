local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlotUpgradeData = require(ReplicatedStorage.Modules.PlotUpgradeData)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local UpgradeSignButtonUtil = require(ReplicatedStorage.Modules.UpgradeSignButtonUtil)
local PlotUpgradeController = Knit.CreateController({ Name = "PlotUpgradeController" })
local player = Players.LocalPlayer
local GREY_BUTTON_COLOR = Color3.fromRGB(145, 145, 145)

function PlotUpgradeController:KnitStart()
	local service = Knit.GetService("PlotUpgradeService")
	local transitions = Knit.GetController("PlotUpgradeTransitionController")
	local playerGui = player:WaitForChild("PlayerGui")
	local stats = player:WaitForChild("leaderstats")
	local cash = stats:WaitForChild("💵Cash")
	local gui, connection
	local gradient, greyGradient
	local defaultImageColor, defaultBackgroundColor, defaultGradientEnabled
	local pending = false
	local boundPlot

	local function canInteract(nextConfig)
		return nextConfig ~= nil and not pending and not transitions:IsPlaying(boundPlot)
	end

	local function refresh()
		if not gui then
			return
		end
		local config = PlotUpgradeData.Get(player:GetAttribute("PlotUpgradeLevel"))
		local nextConfig = PlotUpgradeData.GetNext(config.Level)
		local button = gui.UpgradeButton
		local affordable = nextConfig ~= nil and cash.Value >= nextConfig.Price
		local interactable = canInteract(nextConfig)
		local useNormalStyle = affordable and interactable
		gui.LevelLabel.Text = if nextConfig
			then `{config.Capacity} > {nextConfig.Capacity}`
			else `{config.Capacity} MAX`
		button.PriceLabel.Text = if nextConfig
			then "$" .. NumberUtil.FormatItemPriceCompact(nextConfig.Price)
			else "MAX"
		button.Active = interactable
		button.Selectable = interactable
		button.AutoButtonColor = useNormalStyle
		UpgradeSignButtonUtil.SetAffordable(button, gradient, greyGradient, affordable, interactable)
		if not (gradient and greyGradient) then
			local templateGradient = gradient or greyGradient
			if templateGradient then
				templateGradient.Enabled = useNormalStyle and defaultGradientEnabled
			end
			button.ImageColor3 = if useNormalStyle then defaultImageColor else GREY_BUTTON_COLOR
			button.BackgroundColor3 = if useNormalStyle then defaultBackgroundColor else GREY_BUTTON_COLOR
		end
	end

	local function bind()
		local ownPlot
		for _, plot in PlotWorkspaceUtil.getSortedPlots() do
			local sign = plot:FindFirstChild("Sign")
			local template = sign and sign:FindFirstChild("UpgradeGUI")
			if template then
				template.Enabled = false
			end
			if plot:GetAttribute("OwnerUserId") == player.UserId then
				ownPlot = plot
			end
		end
		if boundPlot == ownPlot and gui then
			refresh()
			return
		end
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if gui then
			gui:Destroy()
			gui = nil
		end
		boundPlot = ownPlot
		if not ownPlot then
			return
		end
		local sign = ownPlot:FindFirstChild("Sign")
		local template = sign and sign:FindFirstChild("UpgradeGUI")
		local board = sign and sign:FindFirstChild("UIPart")
		if not template or not board then
			warn("PlotUpgradeController: upgrade sign template is missing")
			return
		end
		-- Interactive SurfaceGuis must live in PlayerGui, with the sign as Adornee.
		gui = template:Clone()
		gui.Name = "PlotUpgradeGUI"
		gui.Adornee = board
		gui.Enabled = true
		gui.ResetOnSpawn = false
		gui.MaxDistance = 100
		gui.Parent = playerGui
		local button = gui.UpgradeButton
		defaultImageColor = button.ImageColor3
		defaultBackgroundColor = button.BackgroundColor3
		gradient, greyGradient = UpgradeSignButtonUtil.Prepare(button)
		local templateGradient = gradient or greyGradient
		defaultGradientEnabled = templateGradient ~= nil and templateGradient.Enabled
		connection = button.Activated:Connect(function()
			local level = player:GetAttribute("PlotUpgradeLevel") or 0
			local nextConfig = PlotUpgradeData.GetNext(level)
			if not canInteract(nextConfig) then
				return
			end
			if not (cash.Value >= nextConfig.Price) then
				NotificationClient.RedNotify("Not enough money.")
				return
			end
			pending = true
			refresh()
			service
				:RequestUpgrade(level)
				:andThen(function(response)
					if response and response.ok then
						NotificationClient.GreenNotify(`Plot upgraded! {response.capacity} fish slots`)
					else
						NotificationClient.RedNotify(response and response.message or "Could not upgrade your plot.")
					end
				end)
				:catch(function()
					NotificationClient.RedNotify("Could not upgrade your plot. Please try again.")
				end)
				:finally(function()
					pending = false
					refresh()
				end)
		end)
		refresh()
	end

	for _, plot in PlotWorkspaceUtil.getSortedPlots() do
		plot:GetAttributeChangedSignal("OwnerUserId"):Connect(bind)
	end
	player:GetAttributeChangedSignal("PlotSlotId"):Connect(bind)
	player:GetAttributeChangedSignal("PlotUpgradeLevel"):Connect(refresh)
	transitions.Changed:Connect(function(plot)
		if plot == boundPlot then
			refresh()
		end
	end)
	cash:GetPropertyChangedSignal("Value"):Connect(refresh)
	bind()
end

return PlotUpgradeController
