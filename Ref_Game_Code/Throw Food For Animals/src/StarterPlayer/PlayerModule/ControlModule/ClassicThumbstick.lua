-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
local UserPlayerScriptsClassicThumbstickRenameUI = FlagUtil.getUserFlag("UserPlayerScriptsClassicThumbstickRenameUI")
local UserAbilitiesUserInterfaceC = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceC")
local UserPlayerScriptsResetDTTouchOnCreate = FlagUtil.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate")
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction")
local v1 = Vector2.new(-1, -1)
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local v2 = if UserPlayerScriptsCCLIntegrationD then AvatarAbilitiesInterface.get(Players.LocalPlayer) else nil
local ActionController = require(script.Parent:WaitForChild("ActionController"))
local self = setmetatable({}, ActionController)

self.__index = self

function self.new(p1) -- line: 30
    -- upvalues: ActionController (copy), self (copy)
    local v5 = setmetatable(ActionController.new(), self)

    v5.data = p1
    v5.enabled = false
    v5.isTouchActive = false
    v5.isFollowStick = false
    v5.thumbstickFrame = nil
    v5.screenPos = nil
    v5.stickImage = nil
    v5.thumbstickSize = nil

    return v5
end

local function setupThumbstickInput(p2) -- line: 47
    -- upvalues: ThumbstickAction (copy)
    for _, child in ThumbstickAction:GetChildren() do
        if child.Name == "DynamicTouchBinding" or child.Name == "ClassicTouchBinding" then
            child:Destroy()
        end
    end

    local InputBinding = Instance.new("InputBinding")

    InputBinding.Name = "ClassicTouchBinding"
    InputBinding.KeyCode = Enum.KeyCode.TouchPosition
    InputBinding.UIModifier = p2.thumbstickButton
    InputBinding.Parent = ThumbstickAction
end

local function enableThumbstickInput(p3, p4) -- line: 60
    -- upvalues: ThumbstickAction (copy), setupThumbstickInput (copy)
    if p4 then
        setupThumbstickInput(p3)
        p3.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p3.onStateChanged)
        ThumbstickAction.Enabled = true
    else
        ThumbstickAction.Enabled = false

        if p3.thumbstickStateChangedConn then
            p3.thumbstickStateChangedConn:Disconnect()
            p3.thumbstickStateChangedConn = nil
        end
    end
end

function self.Enable(p5, p6, p7) -- line: 74
    -- upvalues: UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), ActionController (copy), setupThumbstickInput (copy)
    if p6 == nil then
        return false
    end

    local v6 = not not p6

    if p5.enabled == v6 then
        return true
    end

    ActionController.Enable(p5, v6)
    p5.isJumping = false

    if v6 then
        if not p5.thumbstickFrame then
            p5:Create(p7)
        end

        if UserPlayerScriptsResetDTTouchOnCreate then
            setupThumbstickInput(p5)
        end

        p5.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p5.onStateChanged)
        ThumbstickAction.Enabled = true
        p5.thumbstickFrame.Visible = true
    else
        ThumbstickAction.Enabled = false

        if p5.thumbstickStateChangedConn then
            p5.thumbstickStateChangedConn:Disconnect()
            p5.thumbstickStateChangedConn = nil
        end

        p5.thumbstickFrame.Visible = false
        p5:OnInputEnded()
    end

    p5.enabled = v6
end

function self.OnInputEnded(p8) -- line: 112
    p8.isTouchActive = false
    p8.thumbstickFrame.Position = p8.screenPos
    p8.stickImage.Position = UDim2.new(0, p8.thumbstickFrame.Size.X.Offset / 2 - p8.thumbstickSize / 4, 0, p8.thumbstickFrame.Size.Y.Offset / 2 - p8.thumbstickSize / 4)

    local ClassicThumbstickScriptableBinding = p8.data.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding")

    if ClassicThumbstickScriptableBinding then
        ClassicThumbstickScriptableBinding:Fire(Vector2.zero)
    end

    p8.isJumping = false
    p8.thumbstickFrame.Position = p8.screenPos
end

function self.Create(p9, p10) -- line: 125
    -- upvalues: GuiService (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsClassicThumbstickRenameUI (copy), UserAbilitiesUserInterfaceC (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), v1 (copy), AvatarAbilitiesInterface (copy), v2 (copy)
    if p9.thumbstickFrame then
        ThumbstickAction.Enabled = false

        if p9.thumbstickStateChangedConn then
            p9.thumbstickStateChangedConn:Disconnect()
            p9.thumbstickStateChangedConn = nil
        end

        p9.thumbstickFrame:Destroy()
        p9.thumbstickFrame = nil

        if p9.absoluteSizeChangedConn then
            p9.absoluteSizeChangedConn:Disconnect()
            p9.absoluteSizeChangedConn = nil
        end

        if p9.avatarAbilitiesEnabledChangedConn then
            p9.avatarAbilitiesEnabledChangedConn:Disconnect()
            p9.avatarAbilitiesEnabledChangedConn = nil
        end
    end

    p9.thumbstickFrame = Instance.new("Frame")
    p9.thumbstickFrame.Name = UserPlayerScriptsClassicThumbstickRenameUI and "ClassicThumbstickFrame" or "ThumbstickFrame"
    p9.thumbstickFrame.Active = true
    p9.thumbstickFrame.Visible = false
    p9.thumbstickFrame.BackgroundTransparency = 1

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "OuterImage"
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    ImageLabel.ImageRectOffset = Vector2.new()
    ImageLabel.ImageRectSize = Vector2.new(220, 220)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 0, 0, 0)
    p9.stickImage = Instance.new("ImageLabel")
    p9.stickImage.Name = "StickImage"
    p9.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    p9.stickImage.ImageRectOffset = Vector2.new(220, 0)
    p9.stickImage.ImageRectSize = Vector2.new(111, 111)
    p9.stickImage.BackgroundTransparency = 1
    p9.stickImage.ZIndex = 2

    local function ResizeThumbstick() -- line: 168
        -- upvalues: p9 (copy), p10 (copy), ImageLabel (copy), UserPlayerScriptsCCLIntegrationD (copy), AvatarAbilitiesInterface (copy), v2 (copy)
        local v7 = math.min(p10.AbsoluteSize.X, p10.AbsoluteSize.Y) <= 500

        if if UserPlayerScriptsCCLIntegrationD then v2:isEnabled() else AvatarAbilitiesInterface.isEnabled() then
            local v8 = if v7 then 64 else 100
            local v9 = if v7 then 64 else 112

            p9.thumbstickSize = v7 and 72 or 120
            p9.screenPos = UDim2.new(0, v8, 1, -p9.thumbstickSize - v9)
        else
            p9.thumbstickSize = v7 and 70 or 120

            local v10 = if v7 then UDim2.new(0, p9.thumbstickSize / 2 - 10, 1, -p9.thumbstickSize - 20) else nil

            p9.screenPos = if not v7 or not v10 then UDim2.new(0, p9.thumbstickSize / 2, 1, -p9.thumbstickSize * 1.75) else v10
        end

        p9.thumbstickFrame.Size = UDim2.new(0, p9.thumbstickSize, 0, p9.thumbstickSize)
        p9.thumbstickFrame.Position = p9.screenPos
        ImageLabel.Size = UDim2.new(0, p9.thumbstickSize, 0, p9.thumbstickSize)
        p9.stickImage.Size = UDim2.new(0, p9.thumbstickSize / 2, 0, p9.thumbstickSize / 2)
        p9.stickImage.Position = UDim2.new(0, p9.thumbstickSize / 2 - p9.thumbstickSize / 4, 0, p9.thumbstickSize / 2 - p9.thumbstickSize / 4)
    end

    ResizeThumbstick()
    p9.absoluteSizeChangedConn = p10:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if UserPlayerScriptsCCLIntegrationD then
        p9.avatarAbilitiesEnabledChangedConn = v2:GetEnabledChangedSignal():Connect(ResizeThumbstick)
    else
        p9.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    ImageLabel.Parent = p9.thumbstickFrame
    p9.stickImage.Parent = p9.thumbstickFrame
    p9.thumbstickButton = Instance.new("ImageButton")
    p9.thumbstickButton.Name = "ClassicThumbstickUIModifier"
    p9.thumbstickButton.BackgroundTransparency = 1
    p9.thumbstickButton.ImageTransparency = 1
    p9.thumbstickButton.AutoButtonColor = false
    p9.thumbstickButton.Size = UDim2.new(1, 0, 1, 0)
    p9.thumbstickButton.ZIndex = p9.thumbstickFrame.ZIndex
    p9.thumbstickButton.Visible = true
    p9.thumbstickButton.Active = false
    p9.thumbstickButton.Parent = p9.thumbstickFrame

    if not UserPlayerScriptsResetDTTouchOnCreate then
        local InputBinding = Instance.new("InputBinding")

        InputBinding.Name = "ClassicTouchBinding"
        InputBinding.KeyCode = Enum.KeyCode.TouchPosition
        InputBinding.UIModifier = p9.thumbstickButton
        InputBinding.Parent = ThumbstickAction
    end

    local v11

    local function DoMove(p11) -- line: 226
        -- upvalues: p9 (copy)
        local v12 = p11 / (p9.thumbstickSize / 2)
        local magnitude = v12.magnitude
        local v13 = if magnitude < 0.05 then Vector2.new() else v12.unit * math.min(1, (magnitude - 0.05) / 0.95)
        local v15 = Vector2.new(v13.X, -v13.Y)
        local ClassicThumbstickScriptableBinding = p9.data.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding")

        if ClassicThumbstickScriptableBinding then
            ClassicThumbstickScriptableBinding:Fire(v15)
        end
    end

    local function MoveStick(p12) -- line: 246
        -- upvalues: p9 (copy), p10 (copy), v11 (ref), UserAbilitiesUserInterfaceC (copy)
        local v16 = Vector2.new(p12.X - v11.X, p12.Y - v11.Y)
        local magnitude = v16.magnitude
        local v17 = p9.thumbstickFrame.AbsoluteSize.X / 2

        if not (p9.isFollowStick and v17 < magnitude) then
            local v18 = math.min(magnitude, v17)

            v16 = v16.unit * v18
        else
            local v19 = v16.unit * v17

            if UserAbilitiesUserInterfaceC then
                local AbsolutePosition = p10.AbsolutePosition

                p9.thumbstickFrame.Position = UDim2.new(0, p12.X - AbsolutePosition.X - p9.thumbstickFrame.AbsoluteSize.X / 2 - v19.X, 0, p12.Y - AbsolutePosition.Y - p9.thumbstickFrame.AbsoluteSize.Y / 2 - v19.Y)
            else
                p9.thumbstickFrame.Position = UDim2.new(0, p12.X - p9.thumbstickFrame.AbsoluteSize.X / 2 - v19.X, 0, p12.Y - p9.thumbstickFrame.AbsoluteSize.Y / 2 - v19.Y)
            end
        end

        p9.stickImage.Position = UDim2.new(0, v16.X + p9.stickImage.AbsoluteSize.X / 2, 0, v16.Y + p9.stickImage.AbsoluteSize.Y / 2)
    end

    p9.onStateChanged = function(p13) -- line: 269
        -- upvalues: p9 (copy), p10 (copy), v11 (ref), DoMove (copy), MoveStick (copy), GuiService (copy), UserAbilitiesUserInterfaceC (copy), v1 (copy)
        if p13 == v1 then
            if p9.isTouchActive then
                p9:OnInputEnded()
            end
        else
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
            local v22 = Vector3.new(p13.X + Min.X, p13.Y + Min.Y, 0)

            if p9.isTouchActive then
                v11 = Vector2.new(p9.thumbstickFrame.AbsolutePosition.X + p9.thumbstickFrame.AbsoluteSize.X / 2, p9.thumbstickFrame.AbsolutePosition.Y + p9.thumbstickFrame.AbsoluteSize.Y / 2)
                DoMove((Vector2.new(v22.X - v11.X, v22.Y - v11.Y)))
                MoveStick(v22)
            else
                p9.isTouchActive = true

                if UserAbilitiesUserInterfaceC then
                    local AbsolutePosition = p10.AbsolutePosition

                    p9.thumbstickFrame.Position = UDim2.new(0, v22.X - AbsolutePosition.X - p9.thumbstickFrame.Size.X.Offset / 2, 0, v22.Y - AbsolutePosition.Y - p9.thumbstickFrame.Size.Y.Offset / 2)
                else
                    p9.thumbstickFrame.Position = UDim2.new(0, v22.X - p9.thumbstickFrame.Size.X.Offset / 2, 0, v22.Y - p9.thumbstickFrame.Size.Y.Offset / 2)
                end

                v11 = Vector2.new(p9.thumbstickFrame.AbsolutePosition.X + p9.thumbstickFrame.AbsoluteSize.X / 2, p9.thumbstickFrame.AbsolutePosition.Y + p9.thumbstickFrame.AbsoluteSize.Y / 2)
            end
        end
    end

    GuiService.MenuOpened:Connect(function() -- line: 308
        -- upvalues: p9 (copy)
        if p9.isTouchActive then
            p9:OnInputEnded()
        end
    end)
    p9.thumbstickFrame.Parent = p10
end

return self
