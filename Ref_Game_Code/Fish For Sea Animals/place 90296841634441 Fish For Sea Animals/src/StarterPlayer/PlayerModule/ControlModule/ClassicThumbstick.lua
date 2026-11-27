-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local UserPlayerScriptsClassicThumbstickRenameUI = FlagUtil.getUserFlag("UserPlayerScriptsClassicThumbstickRenameUI")
local UserAbilitiesUserInterfaceC = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceC")
local UserPlayerScriptsResetDTTouchOnCreate = FlagUtil.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate")
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction")
local v2 = Vector2.new(-1, -1)
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local v3 = if v1 then AvatarAbilitiesInterface.get(Players.LocalPlayer) else nil
local ActionController = require(script.Parent:WaitForChild("ActionController"))
local self = setmetatable({}, ActionController)

self.__index = self

function self.new(p1) -- line: 34
    -- upvalues: ActionController (copy), self (copy)
    local v6 = setmetatable(ActionController.new(), self)

    v6.data = p1
    v6.enabled = false
    v6.isTouchActive = false
    v6.isFollowStick = false
    v6.thumbstickFrame = nil
    v6.screenPos = nil
    v6.stickImage = nil
    v6.thumbstickSize = nil

    return v6
end

local function setupThumbstickInput(p2) -- line: 51
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

local function enableThumbstickInput(p3, p4) -- line: 64
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

function self.Enable(p5, p6, p7) -- line: 78
    -- upvalues: UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), ActionController (copy), setupThumbstickInput (copy)
    if p6 == nil then
        return false
    end

    local v7 = not not p6

    if p5.enabled == v7 then
        return true
    end

    ActionController.Enable(p5, v7)
    p5.isJumping = false

    if v7 then
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

    p5.enabled = v7
end

function self.OnInputEnded(p8) -- line: 119
    p8.isTouchActive = false
    p8.thumbstickFrame.Position = p8.screenPos
    p8.stickImage.Position = UDim2.new(0, p8.thumbstickFrame.Size.X.Offset / 2 - p8.thumbstickSize / 4, 0, p8.thumbstickFrame.Size.Y.Offset / 2 - p8.thumbstickSize / 4)

    local ClassicThumbstickScriptableBinding = p8.data.controlModule.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding")

    if ClassicThumbstickScriptableBinding then
        ClassicThumbstickScriptableBinding:Fire(Vector2.zero)
    end

    p8.isJumping = false
    p8.thumbstickFrame.Position = p8.screenPos
end

function self.Create(p9, p10) -- line: 137
    -- upvalues: GuiService (copy), UserPlayerScriptsClassicThumbstickRenameUI (copy), UserAbilitiesUserInterfaceC (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), v2 (copy), AvatarAbilitiesInterface (copy), v1 (copy), v3 (copy)
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

    local function ResizeThumbstick() -- line: 180
        -- upvalues: p9 (copy), p10 (copy), ImageLabel (copy), AvatarAbilitiesInterface (copy), v1 (copy), v3 (copy)
        local v8 = math.min(p10.AbsoluteSize.X, p10.AbsoluteSize.Y) <= 500

        if if v1 then v3:isEnabled() else AvatarAbilitiesInterface.isEnabled() then
            local v9 = if v8 then 64 else 100
            local v10 = if v8 then 64 else 112

            p9.thumbstickSize = v8 and 72 or 120
            p9.screenPos = UDim2.new(0, v9, 1, -p9.thumbstickSize - v10)
        else
            p9.thumbstickSize = v8 and 70 or 120

            local v11 = if v8 then UDim2.new(0, p9.thumbstickSize / 2 - 10, 1, -p9.thumbstickSize - 20) else nil

            p9.screenPos = if not v8 or not v11 then UDim2.new(0, p9.thumbstickSize / 2, 1, -p9.thumbstickSize * 1.75) else v11
        end

        p9.thumbstickFrame.Size = UDim2.new(0, p9.thumbstickSize, 0, p9.thumbstickSize)
        p9.thumbstickFrame.Position = p9.screenPos
        ImageLabel.Size = UDim2.new(0, p9.thumbstickSize, 0, p9.thumbstickSize)
        p9.stickImage.Size = UDim2.new(0, p9.thumbstickSize / 2, 0, p9.thumbstickSize / 2)
        p9.stickImage.Position = UDim2.new(0, p9.thumbstickSize / 2 - p9.thumbstickSize / 4, 0, p9.thumbstickSize / 2 - p9.thumbstickSize / 4)
    end

    ResizeThumbstick()
    p9.absoluteSizeChangedConn = p10:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if v1 then
        p9.avatarAbilitiesEnabledChangedConn = v3:GetEnabledChangedSignal():Connect(ResizeThumbstick)
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

    local v12

    local function DoMove(p11) -- line: 246
        -- upvalues: p9 (copy)
        local v13 = p11 / (p9.thumbstickSize / 2)
        local magnitude = v13.magnitude
        local v14 = if magnitude < 0.05 then Vector2.new() else v13.unit * math.min(1, (magnitude - 0.05) / 0.95)
        local v16 = Vector2.new(v14.X, -v14.Y)
        local ClassicThumbstickScriptableBinding = p9.data.controlModule.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding")

        if ClassicThumbstickScriptableBinding then
            ClassicThumbstickScriptableBinding:Fire(v16)
        end
    end

    local function MoveStick(p12) -- line: 266
        -- upvalues: p9 (copy), p10 (copy), v12 (ref), UserAbilitiesUserInterfaceC (copy)
        local v17 = Vector2.new(p12.X - v12.X, p12.Y - v12.Y)
        local magnitude = v17.magnitude
        local v18 = p9.thumbstickFrame.AbsoluteSize.X / 2

        if not (p9.isFollowStick and v18 < magnitude) then
            local v19 = math.min(magnitude, v18)

            v17 = v17.unit * v19
        else
            local v20 = v17.unit * v18

            if UserAbilitiesUserInterfaceC then
                local AbsolutePosition = p10.AbsolutePosition

                p9.thumbstickFrame.Position = UDim2.new(0, p12.X - AbsolutePosition.X - p9.thumbstickFrame.AbsoluteSize.X / 2 - v20.X, 0, p12.Y - AbsolutePosition.Y - p9.thumbstickFrame.AbsoluteSize.Y / 2 - v20.Y)
            else
                p9.thumbstickFrame.Position = UDim2.new(0, p12.X - p9.thumbstickFrame.AbsoluteSize.X / 2 - v20.X, 0, p12.Y - p9.thumbstickFrame.AbsoluteSize.Y / 2 - v20.Y)
            end
        end

        p9.stickImage.Position = UDim2.new(0, v17.X + p9.stickImage.AbsoluteSize.X / 2, 0, v17.Y + p9.stickImage.AbsoluteSize.Y / 2)
    end

    p9.onStateChanged = function(p13) -- line: 300
        -- upvalues: p9 (copy), p10 (copy), v12 (ref), DoMove (copy), MoveStick (copy), GuiService (copy), UserAbilitiesUserInterfaceC (copy), v2 (copy)
        if p13 == v2 then
            if p9.isTouchActive then
                p9:OnInputEnded()
            end
        else
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
            local v23 = Vector3.new(p13.X + Min.X, p13.Y + Min.Y, 0)

            if p9.isTouchActive then
                v12 = Vector2.new(p9.thumbstickFrame.AbsolutePosition.X + p9.thumbstickFrame.AbsoluteSize.X / 2, p9.thumbstickFrame.AbsolutePosition.Y + p9.thumbstickFrame.AbsoluteSize.Y / 2)
                DoMove((Vector2.new(v23.X - v12.X, v23.Y - v12.Y)))
                MoveStick(v23)
            else
                p9.isTouchActive = true

                if UserAbilitiesUserInterfaceC then
                    local AbsolutePosition = p10.AbsolutePosition

                    p9.thumbstickFrame.Position = UDim2.new(0, v23.X - AbsolutePosition.X - p9.thumbstickFrame.Size.X.Offset / 2, 0, v23.Y - AbsolutePosition.Y - p9.thumbstickFrame.Size.Y.Offset / 2)
                else
                    p9.thumbstickFrame.Position = UDim2.new(0, v23.X - p9.thumbstickFrame.Size.X.Offset / 2, 0, v23.Y - p9.thumbstickFrame.Size.Y.Offset / 2)
                end

                v12 = Vector2.new(p9.thumbstickFrame.AbsolutePosition.X + p9.thumbstickFrame.AbsoluteSize.X / 2, p9.thumbstickFrame.AbsolutePosition.Y + p9.thumbstickFrame.AbsoluteSize.Y / 2)
            end
        end
    end

    GuiService.MenuOpened:Connect(function() -- line: 343
        -- upvalues: p9 (copy)
        if p9.isTouchActive then
            p9:OnInputEnded()
        end
    end)
    p9.thumbstickFrame.Parent = p10
end

return self
