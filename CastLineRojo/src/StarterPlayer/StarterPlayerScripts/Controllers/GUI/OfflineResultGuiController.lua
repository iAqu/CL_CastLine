local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)

local OfflineResultGuiController = Knit.CreateController({ Name = "OfflineResultGuiController" })

function OfflineResultGuiController:KnitStart()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local gui = playerGui:WaitForChild("OfflineResultGui", 15)
	if not gui then
		warn("OfflineResultGuiController: OfflineResultGui is missing")
		return
	end
	local frame = gui.Frame
	local claim = frame.ConfirmButton
	gui.ResetOnSpawn = false
	frame.DoubleButton.Visible = false
	claim.Position = UDim2.new(0.5, 0, claim.Position.Y.Scale, claim.Position.Y.Offset)
	frame.TitleLabel.Text = "OFFLINE EARNINGS:"

	frame.ICON.Size = UDim2.fromScale(0.42, 0.42)
	frame.ResultLabel.Position = UDim2.fromScale(0.5475, 0.60)
	frame.Currency.Position = UDim2.fromScale(0.2477, 0.60)

	local service = Knit.GetService("PlotFishService")
	local displayed = false
	local busy = false
	local function loadReward()
		if displayed then
			return
		end
		service
			:GetOfflineReward()
			:andThen(function(reward)
				if displayed or not reward or reward.amount <= 0 then
					return
				end
				displayed = true
				frame.ResultLabel.Text = NumberUtil.FormatItemPriceCompact(reward.amount)
				gui.Enabled = true
				GuiAnimation.PushModal(gui, claim)
			end)
			:catch(function()
				warn("OfflineResultGuiController: could not load offline earnings")
			end)
	end
	Knit.GetService("PlayerDataService").DataLoaded:Connect(loadReward)
	loadReward()

	claim.Activated:Connect(function()
		if busy or not gui.Enabled then
			return
		end
		busy = true
		service
			:ClaimOfflineReward()
			:andThen(function(response)
				if response and response.ok then
					GuiAnimation.PopModal(gui)
					gui.Enabled = false
				else
					NotificationClient.RedNotify((response and response.message) or "Could not claim offline earnings.")
				end
			end)
			:catch(function()
				NotificationClient.RedNotify("Could not claim offline earnings.")
			end)
			:finally(function()
				busy = false
			end)
	end)
end

return OfflineResultGuiController
