local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService('Players')

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat=require(ReplicatedStorage.Source.Utils.NumberFormat)
local FishRodLevelHelper = require(ReplicatedStorage.Config.FishRodLevelHelper)
local FishRodEnchantHelper = require(ReplicatedStorage.Config.FishRodEnchantHelper)

local mouse = player:GetMouse()	

local btn = script.Parent

local img=btn.Frame.imgPet

local originalSize = img.Size

-- LocalScript in StarterPlayerScripts or wherever you prefer

local MouseHoverUI = require(ReplicatedStorage.Utils:WaitForChild("MouseHoverUI"))

-- Assume button is named "InfoButton" and info panel is named "InfoPanel"
local button = script.Parent
local infoPanel = player.PlayerGui:WaitForChild("HoldInfoUI").Rodinfo


-- Create hover effect for the button and info panel
MouseHoverUI.CreateHoverEffect(button, infoPanel)

btn.MouseEnter:Connect(function()
	infoPanel.info.name.TextLabel.Text = button.name.Value
	infoPanel.info.multiplier.TextLabel.Text = "Multiplier: "..NumberFormat.AbbreviateNumber(tonumber(button.Power.Value),2).."x"
	infoPanel.info.lv.TextLabel.Text = "LV : "..button.level.Value
	infoPanel.info.lvBar.out.TextLabel.Text = NumberFormat.AbbreviateNumber(tonumber(button.exp.Value),2).."/"..NumberFormat.AbbreviateNumber(tonumber(FishRodHelper.GetFishRod(button.name.Value).baseExp * FishRodLevelHelper.GetExpSum(button.level.Value)),2)
	local sX = tonumber(button.exp.Value)/tonumber(FishRodHelper.GetFishRod(button.name.Value).baseExp * FishRodLevelHelper.GetExpSum(button.level.Value))
	infoPanel.info.lvBar.out.ininin.Size = UDim2.new(sX,0,1,0)
	if button.enchant.Value == 0  then
		infoPanel.info.enchant.Visible = false
		infoPanel.info.noEnchant.Visible = true
	else
		infoPanel.info.enchant.pic.ImageLabel.Image = FishRodEnchantHelper.GetEnchantIndex(button.enchant.Value).img
		infoPanel.info.enchant.Frame.EnchantName.Text = FishRodEnchantHelper.GetEnchantIndex(button.enchant.Value).name
		infoPanel.info.enchant.Frame.Buff.Text = FishRodEnchantHelper.GetEnchantIndex(button.enchant.Value).txtInfo		
		infoPanel.info.noEnchant.Visible = false
		infoPanel.info.enchant.Visible = true
	end
	infoPanel.info.rarity.TextLabel.Text = button.quality.Value
	local bigtween = TweenService:Create(img,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.new(originalSize.X.Scale*1.4,0,originalSize.Y.Scale*1.4,0)})
	bigtween:Play()
end)
btn.MouseLeave:Connect(function()
	local normalween = TweenService:Create(img,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = originalSize})
	normalween:Play()
end)