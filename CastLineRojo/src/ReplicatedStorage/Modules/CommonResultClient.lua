local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)

local CommonResultGui = PlayerGui:WaitForChild("CommonResultGui")

local module = {}

function module.OpenResultGui(text: string, confirmButtonCallback: () -> nil?)
    local clone = CommonResultGui:Clone()
    clone.Enabled = true
    clone.Parent = PlayerGui

    clone.Frame.ResultLabel.Text = text

    local closed = false
    local function confirmAndClose()
        if closed then
            return
        end
        closed = true
        GuiAnimation.PopModal(clone)
        clone.Enabled = false
        clone:Destroy()
        if confirmButtonCallback then
            LogHelper.Print("confirmButtonCallback")
            confirmButtonCallback()
        end
    end

    clone.Frame.ConfirmButton.Activated:Connect(confirmAndClose)
    GuiAnimation.PushModal(clone, clone.Frame.ConfirmButton, confirmAndClose)
end

return module
