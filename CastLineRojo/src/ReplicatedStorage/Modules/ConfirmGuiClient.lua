local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)

local ConfirmGui = PlayerGui:WaitForChild("ConfirmGui")

local ConfirmGuiClient = {}

function ConfirmGuiClient.OpenConfirmtGui(
    text: string,
    confirmButtonCallback: (() -> nil)?,
    cancelButtonCallback: (() -> nil)?
): () -> nil
    local clone = ConfirmGui:Clone()
    clone.Enabled = true
    clone.Parent = PlayerGui

    local isClosed = false
    local function closeConfirmGui()
        if isClosed then
            return
        end
        isClosed = true
        GuiAnimation.PopModal(clone)
        clone:Destroy()
    end

    local function cancelConfirmGui()
        if isClosed then
            return
        end
        closeConfirmGui()
        if cancelButtonCallback then
            cancelButtonCallback()
        end
    end

    clone.Frame.ConfirmTextLabel.Text = text

    ButtonAnimation.SetUp(clone.Frame.ConfirmButton)
    ButtonAnimation.SetUp(clone.Frame.CancelButton)

    clone.Frame.ConfirmButton.Activated:Connect(function()
        if isClosed then
            return
        end
        closeConfirmGui()
        if confirmButtonCallback then
            LogHelper.Print("confirmButtonCallback")
            confirmButtonCallback()
        end
    end)
    
    clone.Frame.CancelButton.Activated:Connect(cancelConfirmGui)

    GuiAnimation.PushModal(clone, clone.Frame.CancelButton, cancelConfirmGui)

    return closeConfirmGui
end

return ConfirmGuiClient
