-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75
}
local t2 = {
    0.55, 0.65, 0.7, 0.75, 0.8, 0.85, 0.875
}
local v1 = #t1
local v2 = Vector2.new(-1, -1)
local v3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
local UserAllowAbilityControlsBonus = FlagUtil.getUserFlag("UserAllowAbilityControlsBonus")
local UserDoubleJumpButtonFix = FlagUtil.getUserFlag("UserDoubleJumpButtonFix")
local UserPlayerScriptsResetDTTouchOnCreate = FlagUtil.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction")
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local v4 = if UserPlayerScriptsCCLIntegrationD then AvatarAbilitiesInterface.get(Players.LocalPlayer) else nil
local LocalPlayer = Players.LocalPlayer
local LocalPlayer2 = LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer2 = Players.LocalPlayer
end

local ActionController = require(script.Parent:WaitForChild("ActionController"))
local self = setmetatable({}, ActionController)

self.__index = self

function self.new(p1) -- line: 67
    -- upvalues: ActionController (copy), self (copy)
    local v7 = setmetatable(ActionController.new(), self)

    v7.data = p1
    v7.enabled = false
    v7.isTouchActive = false
    v7.moveTouchFirstChanged = false
    v7.moveTouchStartPosition = nil
    v7.startImage = nil
    v7.endImage = nil
    v7.endImageStroke = nil
    v7.endImageCenter = nil
    v7.middleImages = {}
    v7.startImageFadeTween = nil
    v7.endImageFadeTween = nil
    v7.endImageCenterFadeTween = nil
    v7.middleImageFadeTweens = {}
    v7.isFirstTouch = true
    v7.thumbstickFrame = nil
    v7.onRenderSteppedConn = nil
    v7.fadeInAndOutBalance = 0.5
    v7.fadeInAndOutHalfDuration = 0.3
    v7.hasFadedBackgroundInPortrait = false
    v7.hasFadedBackgroundInLandscape = false
    v7.tweenInAlphaStart = nil
    v7.tweenOutAlphaStart = nil
    v7.newStyle = false

    return v7
end

function self.GetIsJumping(p2) -- line: 109
    local isJumping = p2.isJumping

    p2.isJumping = false

    return isJumping
end

local function setupThumbstickInput(p3) -- line: 115
    -- upvalues: ThumbstickAction (copy)
    for _, child in ThumbstickAction:GetChildren() do
        if child.Name == "DynamicTouchBinding" or child.Name == "ClassicTouchBinding" then
            child:Destroy()
        end
    end

    local InputBinding = Instance.new("InputBinding")

    InputBinding.Name = "DynamicTouchBinding"
    InputBinding.KeyCode = Enum.KeyCode.TouchPosition
    InputBinding.UIModifier = p3.thumbstickButton
    InputBinding.Parent = ThumbstickAction
end

local function enableThumbstickInput(p4, p5) -- line: 128
    -- upvalues: ThumbstickAction (copy), setupThumbstickInput (copy)
    if p5 then
        setupThumbstickInput(p4)
        p4.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p4.onStateChanged)
        ThumbstickAction.Enabled = true
    else
        ThumbstickAction.Enabled = false

        if p4.thumbstickStateChangedConn then
            p4.thumbstickStateChangedConn:Disconnect()
            p4.thumbstickStateChangedConn = nil
        end
    end
end

function self.Enable(p6, p7, p8) -- line: 142
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), ActionController (copy), setupThumbstickInput (copy), v4 (copy)
    if p7 == nil then
        return false
    end

    local v8 = not not p7

    if p6.enabled == v8 then
        return true
    end

    ActionController.Enable(p6, v8)

    if v8 then
        if not p6.thumbstickFrame then
            p6:Create(p8)

            if UserPlayerScriptsCCLIntegrationD and not p6.avatarAbilitiesEnabledChangedConn then
                p6.avatarAbilitiesEnabledChangedConn = v4:GetEnabledChangedSignal():Connect(function() -- line: 153
                    -- upvalues: p6 (copy), p8 (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), setupThumbstickInput (copy)
                    if p6.enabled then
                        p6:Create(p8)

                        if UserPlayerScriptsResetDTTouchOnCreate then
                            setupThumbstickInput(p6)
                        end

                        p6.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p6.onStateChanged)
                        ThumbstickAction.Enabled = true
                        p6.thumbstickFrame.Visible = true
                    end
                end)
            end
        end

        if UserPlayerScriptsResetDTTouchOnCreate then
            setupThumbstickInput(p6)
        end

        p6.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p6.onStateChanged)
        ThumbstickAction.Enabled = true
    else
        ThumbstickAction.Enabled = false

        if p6.thumbstickStateChangedConn then
            p6.thumbstickStateChangedConn:Disconnect()
            p6.thumbstickStateChangedConn = nil
        end

        p6:OnInputEnded()
    end

    p6.enabled = v8
    p6.thumbstickFrame.Visible = v8

    return nil
end

function self.OnInputEnded(p9) -- line: 194
    p9.isTouchActive = false

    local DynamicThumbstickScriptableBinding = p9.data.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding")

    if DynamicThumbstickScriptableBinding then
        DynamicThumbstickScriptableBinding:Fire(Vector2.zero)
    end

    p9:FadeThumbstick(false)
end

function self.FadeThumbstick(p10, p11) -- line: 203
    -- upvalues: t1 (copy), t2 (copy), v3 (copy), UserPlayerScriptsCCLIntegrationD (copy), TweenService (copy)
    if not p11 and p10.isTouchActive or p10.isFirstTouch then
        return
    end

    if p10.startImageFadeTween then
        p10.startImageFadeTween:Cancel()
    end

    if p10.endImageFadeTween then
        p10.endImageFadeTween:Cancel()
    end

    if UserPlayerScriptsCCLIntegrationD and p10.endImageCenterFadeTween then
        p10.endImageCenterFadeTween:Cancel()
    end

    for i = 1, #p10.middleImages do
        if p10.middleImageFadeTweens[i] then
            p10.middleImageFadeTweens[i]:Cancel()
        end
    end

    if p11 then
        if UserPlayerScriptsCCLIntegrationD and p10.newStyle then
            p10.startImageFadeTween = TweenService:Create(p10.startImage, v3, {
                BackgroundTransparency = 0.4
            })
            p10.startImageFadeTween:Play()
            p10.endImageFadeTween = TweenService:Create(p10.endImageStroke, v3, {
                Transparency = 0
            })
            p10.endImageFadeTween:Play()
            p10.endImageCenterFadeTween = TweenService:Create(p10.endImageCenter, v3, {
                BackgroundTransparency = 0
            })
            p10.endImageCenterFadeTween:Play()
        else
            p10.startImageFadeTween = TweenService:Create(p10.startImage, v3, {
                ImageTransparency = 0
            })
            p10.startImageFadeTween:Play()
            p10.endImageFadeTween = TweenService:Create(p10.endImage, v3, {
                ImageTransparency = 0.2
            })
            p10.endImageFadeTween:Play()
        end

        for i = 1, #p10.middleImages do
            if not (UserPlayerScriptsCCLIntegrationD and p10.newStyle) then
                p10.middleImageFadeTweens[i] = TweenService:Create(p10.middleImages[i], v3, {
                    ImageTransparency = t1[i]
                })
            else
                p10.middleImageFadeTweens[i] = TweenService:Create(p10.middleImages[i], v3, {
                    BackgroundTransparency = t2[i]
                })
            end

            p10.middleImageFadeTweens[i]:Play()
        end
    else
        if not (UserPlayerScriptsCCLIntegrationD and p10.newStyle) then
            p10.startImageFadeTween = TweenService:Create(p10.startImage, v3, {
                ImageTransparency = 1
            })
            p10.startImageFadeTween:Play()
            p10.endImageFadeTween = TweenService:Create(p10.endImage, v3, {
                ImageTransparency = 1
            })
            p10.endImageFadeTween:Play()
        else
            p10.startImageFadeTween = TweenService:Create(p10.startImage, v3, {
                BackgroundTransparency = 1
            })
            p10.startImageFadeTween:Play()
            p10.endImageFadeTween = TweenService:Create(p10.endImageStroke, v3, {
                Transparency = 1
            })
            p10.endImageFadeTween:Play()
            p10.endImageCenterFadeTween = TweenService:Create(p10.endImageCenter, v3, {
                BackgroundTransparency = 1
            })
            p10.endImageCenterFadeTween:Play()
        end

        for i = 1, #p10.middleImages do
            if not (UserPlayerScriptsCCLIntegrationD and p10.newStyle) then
                p10.middleImageFadeTweens[i] = TweenService:Create(p10.middleImages[i], v3, {
                    ImageTransparency = 1
                })
            else
                p10.middleImageFadeTweens[i] = TweenService:Create(p10.middleImages[i], v3, {
                    BackgroundTransparency = 1
                })
            end

            p10.middleImageFadeTweens[i]:Play()
        end
    end
end

function self.FadeThumbstickFrame(p12, p13, p14) -- line: 279
    p12.fadeInAndOutHalfDuration = p13 * 0.5
    p12.fadeInAndOutBalance = p14
    p12.tweenInAlphaStart = tick()
end

function self.DoFadeInBackground(p15) -- line: 285
    -- upvalues: LocalPlayer2 (ref)
    local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
    local hasFadedBackgroundInLandscape

    if PlayerGui then
        if PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            hasFadedBackgroundInLandscape = p15.hasFadedBackgroundInLandscape
            p15.hasFadedBackgroundInLandscape = true
        elseif PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            hasFadedBackgroundInLandscape = p15.hasFadedBackgroundInPortrait
            p15.hasFadedBackgroundInPortrait = true
        else
            hasFadedBackgroundInLandscape = false
        end
    else
        hasFadedBackgroundInLandscape = false
    end

    if hasFadedBackgroundInLandscape then
        return
    end

    p15.fadeInAndOutHalfDuration = 0.3
    p15.fadeInAndOutBalance = 0.5
    p15.tweenInAlphaStart = tick()
end

function self.DoMove(p16, p17) -- line: 308
    local v9 = if p17.Magnitude < p16.radiusOfDeadZone then Vector2.new() else p17.Unit * (1 - math.max(0, (p16.radiusOfMaxSpeed - p17.Magnitude) / p16.radiusOfMaxSpeed))
    local v11 = Vector2.new(v9.X, -v9.Y)
    local DynamicThumbstickScriptableBinding = p16.data.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding")

    if DynamicThumbstickScriptableBinding then
        DynamicThumbstickScriptableBinding:Fire(v11)
    end
end

function self.LayoutMiddleImages(p18, p19, p20) -- line: 328
    -- upvalues: v1 (copy)
    local v12 = p18.thumbstickSize / 2 + p18.middleSize
    local v13 = p20 - p19
    local v14 = v13.Magnitude - p18.thumbstickRingSize / 2 - p18.middleSize
    local Unit = v13.Unit
    local v15 = p18.middleSpacing * v1
    local middleSpacing = p18.middleSpacing

    if v15 < v14 then
        middleSpacing = v14 / v1
    end

    for i = 1, v1 do
        local v16 = p18.middleImages[i]
        local v17 = v12 + middleSpacing * (i - 2)
        local v18 = v12 + middleSpacing * (i - 1)

        if v17 < v14 then
            local v19 = p20 - Unit * v18
            local v21 = math.clamp(1 - (v18 - v14) / middleSpacing, 0, 1)

            v16.Visible = true
            v16.Position = UDim2.new(0, v19.X, 0, v19.Y)
            v16.Size = UDim2.new(0, p18.middleSize * v21, 0, p18.middleSize * v21)
            continue
        end

        v16.Visible = false
    end
end

function self.MoveStick(p21, p22) -- line: 359
    local v22 = Vector2.new(p21.moveTouchStartPosition.X, p21.moveTouchStartPosition.Y) - p21.thumbstickFrame.AbsolutePosition
    local v23 = Vector2.new(p22.X, p22.Y) - p21.thumbstickFrame.AbsolutePosition

    p21.endImage.Position = UDim2.new(0, v23.X, 0, v23.Y)
    p21:LayoutMiddleImages(v22, v23)
end

function self.Create(p23, p24) -- line: 367
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), UserPlayerScriptsCCLIntegrationD (copy), UserAllowAbilityControlsBonus (copy), UserDoubleJumpButtonFix (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), GuiService (copy), RunService (copy), TweenService (copy), ThumbstickAction (copy), AvatarAbilitiesInterface (copy), LocalPlayer2 (ref), v4 (copy)
    if p23.thumbstickFrame then
        ThumbstickAction.Enabled = false

        if p23.thumbstickStateChangedConn then
            p23.thumbstickStateChangedConn:Disconnect()
            p23.thumbstickStateChangedConn = nil
        end

        p23.thumbstickFrame:Destroy()
        p23.thumbstickFrame = nil

        if p23.onRenderSteppedConn then
            p23.onRenderSteppedConn:Disconnect()
            p23.onRenderSteppedConn = nil
        end

        if p23.absoluteSizeChangedConn then
            p23.absoluteSizeChangedConn:Disconnect()
            p23.absoluteSizeChangedConn = nil
        end

        if not UserPlayerScriptsCCLIntegrationD and p23.avatarAbilitiesEnabledChangedConn then
            p23.avatarAbilitiesEnabledChangedConn:Disconnect()
            p23.avatarAbilitiesEnabledChangedConn = nil
        end

        if UserPlayerScriptsCCLIntegrationD then
            if p23.cameraChangedConn then
                p23.cameraChangedConn:Disconnect()
                p23.cameraChangedConn = nil
            end

            if p23.currentCameraChangedConn then
                p23.currentCameraChangedConn:Disconnect()
                p23.currentCameraChangedConn = nil
            end

            if p23.menuOpenedConnection then
                p23.menuOpenedConnection:Disconnect()
                p23.menuOpenedConnection = nil
            end

            if p23.playerGuiChangedConn then
                p23.playerGuiChangedConn:Disconnect()
                p23.playerGuiChangedConn = nil
            end
        end
    end

    local function layoutThumbstickFrame(p25) -- line: 415
        -- upvalues: p23 (copy)
        if p25 then
            p23.thumbstickFrame.Size = UDim2.new(1, 100, 0.4, 100)
            p23.thumbstickFrame.Position = UDim2.new(0, -100, 0.6, 0)
        else
            p23.thumbstickFrame.Size = UDim2.new(0.4, 100, 0.6666666666666666, 100)
            p23.thumbstickFrame.Position = UDim2.new(0, -100, 0.3333333333333333, 0)
        end
    end

    p23.newStyle = UserPlayerScriptsCCLIntegrationD and v4:isEnabled()
    p23.thumbstickFrame = Instance.new("Frame")
    p23.thumbstickFrame.BorderSizePixel = 0
    p23.thumbstickFrame.Name = "DynamicThumbstickFrame"
    p23.thumbstickFrame.Visible = false
    p23.thumbstickFrame.BackgroundTransparency = 1
    p23.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    p23.thumbstickFrame.Active = false
    p23.thumbstickFrame.Size = UDim2.new(0.4, 100, 0.6666666666666666, 100)
    p23.thumbstickFrame.Position = UDim2.new(0, -100, 0.3333333333333333, 0)
    p23.thumbstickButton = Instance.new("ImageButton")
    p23.thumbstickButton.Name = "DynamicThumbstickUIModifier"
    p23.thumbstickButton.BackgroundTransparency = 1
    p23.thumbstickButton.ImageTransparency = 1
    p23.thumbstickButton.AutoButtonColor = false
    p23.thumbstickButton.Size = UDim2.new(1, 0, 1, 0)
    p23.thumbstickButton.ZIndex = p23.thumbstickFrame.ZIndex
    p23.thumbstickButton.Visible = true
    p23.thumbstickButton.Active = false
    p23.thumbstickButton.Parent = p23.thumbstickFrame

    if not UserPlayerScriptsResetDTTouchOnCreate then
        local v24 = if UserDoubleJumpButtonFix then ThumbstickAction:FindFirstChild("DynamicTouchBinding") else nil

        if not v24 then
            v24 = Instance.new("InputBinding")
            v24.Name = "DynamicTouchBinding"
            v24.KeyCode = Enum.KeyCode.TouchPosition
            v24.Parent = ThumbstickAction
        end

        v24.UIModifier = p23.thumbstickButton
    end

    if UserPlayerScriptsCCLIntegrationD and p23.newStyle then
        p23.startImage = Instance.new("Frame")
        p23.startImage.Name = "ThumbstickStart"
        p23.startImage.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
        p23.startImage.BackgroundTransparency = 0.4
        p23.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
        p23.startImage.ZIndex = 10
        p23.startImage.Parent = p23.thumbstickFrame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = p23.startImage
        p23.endImage = Instance.new("Frame")
        p23.endImage.Name = "ThumbstickEnd"
        p23.endImage.BackgroundTransparency = 1
        p23.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
        p23.endImage.ZIndex = 10
        p23.endImage.Parent = p23.thumbstickFrame

        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = UDim.new(0.5, 0)
        UICorner2.Parent = p23.endImage
        p23.endImageStroke = Instance.new("UIStroke")
        p23.endImageStroke.Thickness = UserDoubleJumpButtonFix and 1.5 or 2
        p23.endImageStroke.Color = Color3.fromRGB(213, 215, 221)
        p23.endImageStroke.Parent = p23.endImage
        p23.endImageCenter = Instance.new("Frame")
        p23.endImageCenter.Name = "ThumbstickEndCenter"
        p23.endImageCenter.BackgroundTransparency = 0
        p23.endImageCenter.BackgroundColor3 = Color3.fromRGB(213, 215, 221)
        p23.endImageCenter.AnchorPoint = Vector2.new(0.5, 0.5)
        p23.endImageCenter.Size = UDim2.new(0.74, 0, 0.74, 0)
        p23.endImageCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
        p23.endImageCenter.ZIndex = 10
        p23.endImageCenter.Parent = p23.endImage

        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = UDim.new(0.5, 0)
        UICorner3.Parent = p23.endImageCenter

        for i = 1, v1 do
            p23.middleImages[i] = Instance.new("Frame")
            p23.middleImages[i].Name = "ThumbstickMiddle"
            p23.middleImages[i].Visible = false
            p23.middleImages[i].BackgroundTransparency = t2[i]
            p23.middleImages[i].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            p23.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
            p23.middleImages[i].ZIndex = 9
            p23.middleImages[i].Parent = p23.thumbstickFrame

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = p23.middleImages[i]
        end
    else
        p23.startImage = Instance.new("ImageLabel")
        p23.startImage.Name = "ThumbstickStart"
        p23.startImage.Visible = true
        p23.startImage.BackgroundTransparency = 1
        p23.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        p23.startImage.ImageRectOffset = Vector2.new(1, 1)
        p23.startImage.ImageRectSize = Vector2.new(144, 144)
        p23.startImage.ImageColor3 = Color3.new(0, 0, 0)
        p23.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
        p23.startImage.ZIndex = 10
        p23.startImage.Parent = p23.thumbstickFrame
        p23.endImage = Instance.new("ImageLabel")
        p23.endImage.Name = "ThumbstickEnd"
        p23.endImage.Visible = true
        p23.endImage.BackgroundTransparency = 1
        p23.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        p23.endImage.ImageRectOffset = Vector2.new(1, 1)
        p23.endImage.ImageRectSize = Vector2.new(144, 144)
        p23.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
        p23.endImage.ZIndex = 10
        p23.endImage.Parent = p23.thumbstickFrame

        for i = 1, v1 do
            p23.middleImages[i] = Instance.new("ImageLabel")
            p23.middleImages[i].Name = "ThumbstickMiddle"
            p23.middleImages[i].Visible = false
            p23.middleImages[i].BackgroundTransparency = 1
            p23.middleImages[i].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            p23.middleImages[i].ImageRectOffset = Vector2.new(1, 1)
            p23.middleImages[i].ImageRectSize = Vector2.new(144, 144)
            p23.middleImages[i].ImageTransparency = t1[i]
            p23.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
            p23.middleImages[i].ZIndex = 9
            p23.middleImages[i].Parent = p23.thumbstickFrame
        end
    end

    local function ResizeThumbstick() -- line: 557
        -- upvalues: p23 (copy), p24 (copy), UserPlayerScriptsCCLIntegrationD (copy), UserAllowAbilityControlsBonus (copy), AvatarAbilitiesInterface (copy)
        local AbsoluteSize = p24.AbsoluteSize
        local v25 = math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500
        local v26 = if v25 then 2 else 1
        local v27 = if UserPlayerScriptsCCLIntegrationD then p23.newStyle else AvatarAbilitiesInterface.isEnabled()

        if UserAllowAbilityControlsBonus and v27 and v25 then
            v26 = 1.6216216216216217
        end

        p23.thumbstickSize = 45 * v26
        p23.thumbstickRingSize = 20 * v26
        p23.middleSize = 10 * v26
        p23.middleSpacing = 14 * v26
        p23.radiusOfDeadZone = 2 * v26
        p23.radiusOfMaxSpeed = 20 * v26

        local v28 = 74 * v26

        if not UserPlayerScriptsCCLIntegrationD or p23.isFirstTouch then
            if v27 then
                local v29 = if v25 then 100 else 64
                local v30 = v25 and 112 or 64

                p23.startImage.Position = UDim2.new(0, v28 * 0.5 + 100 + v29, 1, -v28 * 0.5 - 100 - v30)
            else
                p23.startImage.Position = UDim2.new(0, p23.thumbstickRingSize * 3.3 + 100, 1, -p23.thumbstickRingSize * 2.8 - 100)
            end

            p23.startImage.Size = UDim2.new(0, v28, 0, v28)
        end

        p23.endImage.Position = p23.startImage.Position

        if not (UserPlayerScriptsCCLIntegrationD and p23.newStyle) then
            p23.endImage.Size = UDim2.new(0, p23.thumbstickSize * 0.8, 0, p23.thumbstickSize * 0.8)
        else
            p23.endImage.Size = UDim2.new(0, p23.thumbstickSize * 0.6, 0, p23.thumbstickSize * 0.6)
        end
    end

    ResizeThumbstick()
    p23.absoluteSizeChangedConn = p24:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if not UserPlayerScriptsCCLIntegrationD then
        p23.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    local function onCurrentCameraChanged() -- line: 612
        -- upvalues: p23 (copy), layoutThumbstickFrame (copy)
        if p23.cameraChangedConn then
            p23.cameraChangedConn:Disconnect()
            p23.cameraChangedConn = nil
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local function onViewportSizeChanged() -- line: 619
            -- upvalues: CurrentCamera (copy), layoutThumbstickFrame (copy)
            local ViewportSize = CurrentCamera.ViewportSize

            layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
        end

        p23.cameraChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

        local ViewportSize = CurrentCamera.ViewportSize

        layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
    end

    p23.currentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

    if workspace.CurrentCamera or UserPlayerScriptsCCLIntegrationD then
        onCurrentCameraChanged()
    end

    p23.startImageFadeTween = nil
    p23.endImageFadeTween = nil
    p23.endImageCenterFadeTween = nil
    p23.middleImageFadeTweens = {}

    if UserPlayerScriptsResetDTTouchOnCreate and p23.isTouchActive then
        p23:OnInputEnded()
    end

    p23.moveTouchStartPosition = nil
    p23.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- line: 643
        -- upvalues: p23 (copy)
        if p23.tweenInAlphaStart ~= nil then
            local v36 = tick() - p23.tweenInAlphaStart
            local v37 = p23.fadeInAndOutHalfDuration * 2 * p23.fadeInAndOutBalance

            p23.thumbstickFrame.BackgroundTransparency = 1 - math.min(v36 / v37, 1) * 0.35

            if v37 < v36 then
                p23.tweenOutAlphaStart = tick()
                p23.tweenInAlphaStart = nil
            end
        elseif p23.tweenOutAlphaStart ~= nil then
            local v33 = tick() - p23.tweenOutAlphaStart
            local v34 = p23.fadeInAndOutHalfDuration * 2 - p23.fadeInAndOutHalfDuration * 2 * p23.fadeInAndOutBalance

            p23.thumbstickFrame.BackgroundTransparency = math.min(v33 / v34, 1) * 0.35 + 0.65

            if v34 < v33 then
                p23.tweenOutAlphaStart = nil
            end
        end
    end)

    p23.onStateChanged = function(p26) -- line: 662
        -- upvalues: p23 (copy), v2 (copy), UserPlayerScriptsCCLIntegrationD (copy), GuiService (copy), TweenService (copy)
        if p26 == v2 then
            if p23.isTouchActive then
                p23:OnInputEnded()
            end
        else
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
            local v41 = Vector3.new(p26.X + Min.X, p26.Y + Min.Y, 0)

            if not p23.isTouchActive then
                p23.isTouchActive = true

                if p23.isFirstTouch then
                    p23.isFirstTouch = false

                    local v42 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

                    TweenService:Create(p23.startImage, v42, {
                        Size = UDim2.new(0, 0, 0, 0)
                    }):Play()

                    if not UserPlayerScriptsCCLIntegrationD or not p23.newStyle then
                        TweenService:Create(p23.endImage, v42, {
                            Size = UDim2.new(0, p23.thumbstickSize, 0, p23.thumbstickSize),
                            ImageColor3 = Color3.new(0, 0, 0)
                        }):Play()
                    end
                end

                p23.moveTouchStartPosition = v41
                p23.moveTouchFirstChanged = true
                p23:DoFadeInBackground()
            else
                if p23.moveTouchFirstChanged then
                    p23.moveTouchFirstChanged = false

                    local v43 = Vector2.new(p23.moveTouchStartPosition.X - p23.thumbstickFrame.AbsolutePosition.X, p23.moveTouchStartPosition.Y - p23.thumbstickFrame.AbsolutePosition.Y)

                    p23.startImage.Visible = true
                    p23.startImage.Position = UDim2.new(0, v43.X, 0, v43.Y)
                    p23.endImage.Visible = true
                    p23.endImage.Position = p23.startImage.Position
                    p23:FadeThumbstick(true)
                    p23:MoveStick(p23.moveTouchStartPosition)
                end

                local v44 = Vector2.new(v41.X - p23.moveTouchStartPosition.X, v41.Y - p23.moveTouchStartPosition.Y)

                if v44.Magnitude > 0 then
                    p23:DoMove(v44)
                    p23:MoveStick(v41)
                end
            end
        end
    end

    p23.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- line: 723
        -- upvalues: p23 (copy)
        if p23.isTouchActive then
            p23:OnInputEnded()
        end
    end)

    local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")

    while not PlayerGui do
        LocalPlayer2.ChildAdded:wait()
        PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
    end

    local v45 = PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

    local function longShowBackground() -- line: 738
        -- upvalues: p23 (copy)
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()
    end

    p23.playerGuiChangedConn = PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 744
        -- upvalues: p23 (copy), PlayerGui (ref), v45 (copy)
        if (not v45 or PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and (v45 or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) then
            return
        end

        p23.playerGuiChangedConn:Disconnect()
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()

        if v45 then
            p23.hasFadedBackgroundInPortrait = true
        else
            p23.hasFadedBackgroundInLandscape = true
        end
    end)
    p23.thumbstickFrame.Parent = p24

    if game:IsLoaded() then
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()

        return
    end

    coroutine.wrap(function() -- line: 764
        -- upvalues: p23 (copy)
        game.Loaded:Wait()
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()
    end)()
end

return self
