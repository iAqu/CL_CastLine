local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Mouse = player:GetMouse()

local LogHelper = require(game.ReplicatedStorage.Modules.LogHelper)

-- local notificationGui = PlayerGui:WaitForChild("NotificationGui")
-- local contrainer = notificationGui:WaitForChild("Container")

-- local notificationTemplate = contrainer:WaitForChild("NotificationTemplate")
-- local successNotificationTemplate = contrainer:WaitForChild("SuccessNotificationTemplate")
-- local WhiteNotificationTemplate = contrainer:WaitForChild("WhiteNotificationTemplate")
-- local originalTemplateSize = notificationTemplate.Size

-- local DEDAULT_DURATION = 6
local isHoverInfoShow = false
local currentInfoFrame = nil
local currentMouseGuiElement = nil
local currentInfoHoverSide = "right"
local setuppedHoverGuiElements = {}

local module = {}

function module.RemoveHoverConnection(guiElement: GuiObject)
    if setuppedHoverGuiElements[guiElement] then
        for _, connection in pairs(setuppedHoverGuiElements[guiElement]) do
            connection:Disconnect()
        end
        setuppedHoverGuiElements[guiElement] = nil
    end
end

function module.HideInfoHover()
    isHoverInfoShow = false
    currentMouseGuiElement = nil
    currentInfoHoverSide = "right"
    if currentInfoFrame then
        currentInfoFrame.Visible = false
        currentInfoFrame = nil
    end
end

local function SetInfoFramePosition()
    if isHoverInfoShow and currentInfoFrame then
        if currentInfoHoverSide == "left" then
            currentInfoFrame.Position = UDim2.fromOffset(Mouse.X - currentInfoFrame.AbsoluteSize.X - 10, Mouse.Y)
        else
            currentInfoFrame.Position = UDim2.fromOffset(Mouse.X + 10, Mouse.Y)
        end
    end
end

function module.SetupInfoHover(guiElement: GuiObject, infoFrame: Frame, callback, side: ("left" | "right")?)
    module.RemoveHoverConnection(guiElement)
    infoFrame.Visible = false

    local mouseEnterConnection = guiElement.MouseEnter:Connect(function()
        if currentMouseGuiElement ~= nil then
            module.HideInfoHover()
        end

        isHoverInfoShow = true
        currentInfoFrame = infoFrame
        currentMouseGuiElement = guiElement
        currentInfoHoverSide = side or "right"
        currentInfoFrame.Visible = true

        callback()
        SetInfoFramePosition()
    end)

    local mouseLeaveConnection = guiElement.MouseLeave:Connect(function()
        if currentMouseGuiElement == guiElement then
            module.HideInfoHover()
        end
    end)

    -- local destoryConnection = guiElement.AncestryChanged:Connect(function()
    --     if guiElement.Parent == nil then
    --         LogHelper.Print("AncestryChanged")
    --         self:HideInfoHover()
    --         self:ClearHoverConnection(guiElement)
    --     end
    -- end)

    setuppedHoverGuiElements[guiElement] = {mouseEnterConnection, mouseLeaveConnection}
end
-- init
Mouse.Move:Connect(function()
    -- if isHoverInfoShow and currentInfoFrame then
    --     currentInfoFrame.Position = UDim2.new(0, Mouse.X + 10, 0, Mouse.Y)
    -- end
    SetInfoFramePosition()
end)



return module
