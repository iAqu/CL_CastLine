local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Constants = require(ReplicatedStorage.Modules.Constants)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local UpdateLogGui = PlayerGUI:WaitForChild("UpdateLogGui")

local CloseButton = UpdateLogGui.Frame.CloseButton
local VersionLabel = UpdateLogGui.Frame.VersionLabel

local HomeGui = PlayerGUI:WaitForChild("HomeGui")
local HomeVersionLabel = HomeGui.BottomFrame.VersionLabel

local Knit = require(ReplicatedStorage.Packages.Knit)

local UpdateGuiController = Knit.CreateController {
    Name = "UpdateGuiController",
}

function UpdateGuiController:KnitInit()
end

function UpdateGuiController:KnitStart()
    
    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(UpdateLogGui)
    end)
    
    -- if not PlayerDataController:GetData().UpdateReadLog[Constants.UPDATE_VERSION] then
    --     GuiAnimation.OpenGui(UpdateGui)
    --     Knit.GetService("SettingsService").ReadUpdateLog:Fire()
    -- end

    VersionLabel.Text = "v" .. Constants.UPDATE_VERSION .. "." .. Constants.RESOURCE_VERSION .. "." .. Constants.CODE_VERSION
    HomeVersionLabel.Text = "v" .. Constants.UPDATE_VERSION .. "." .. Constants.RESOURCE_VERSION .. "." .. Constants.CODE_VERSION

    
end

return UpdateGuiController
