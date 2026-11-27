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
local v4 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local UserAllowAbilityControlsBonus = FlagUtil.getUserFlag("UserAllowAbilityControlsBonus")
local UserDoubleJumpButtonFix = FlagUtil.getUserFlag("UserDoubleJumpButtonFix")
local UserPlayerScriptsResetDTTouchOnCreate = FlagUtil.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction")
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local v5 = if v4 then AvatarAbilitiesInterface.get(Players.LocalPlayer) else nil
local LocalPlayer = Players.LocalPlayer
local LocalPlayer2 = LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer2 = Players.LocalPlayer
end

local ActionController = require(script.Parent:WaitForChild("ActionController"))
local self = setmetatable({}, ActionController)

self.__index = self

function self.new(p1) -- line: 70
    -- upvalues: ActionController (copy), self (copy)
    local v8 = setmetatable(ActionController.new(), self)

    v8.data = p1
    v8.enabled = false
    v8.isTouchActive = false
    v8.moveTouchFirstChanged = false
    v8.moveTouchStartPosition = nil
    v8.startImage = nil
    v8.endImage = nil
    v8.endImageStroke = nil
    v8.endImageCenter = nil
    v8.middleImages = {}
    v8.startImageFadeTween = nil
    v8.endImageFadeTween = nil
    v8.endImageCenterFadeTween = nil
    v8.middleImageFadeTweens = {}
    v8.isFirstTouch = true
    v8.thumbstickFrame = nil
    v8.onRenderSteppedConn = nil
    v8.fadeInAndOutBalance = 0.5
    v8.fadeInAndOutHalfDuration = 0.3
    v8.hasFadedBackgroundInPortrait = false
    v8.hasFadedBackgroundInLandscape = false
    v8.tweenInAlphaStart = nil
    v8.tweenOutAlphaStart = nil
    v8.newStyle = false

    return v8
end

function self.GetIsJumping(p2) -- line: 112
    local isJumping = p2.isJumping

    p2.isJumping = false

    return isJumping
end

local function setupThumbstickInput(p3) -- line: 118
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

local function enableThumbstickInput(p4, p5) -- line: 131
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

function self.Enable(p6, p7, p8) -- line: 145
    -- upvalues: UserPlayerScriptsResetDTTouchOnCreate (copy), ThumbstickAction (copy), v4 (copy), ActionController (copy), setupThumbstickInput (copy), v5 (copy)
    if p7 == nil then
        return false
    end

    local v9 = not not p7

    if p6.enabled == v9 then
        return true
    end

    ActionController.Enable(p6, v9)

    if v9 then
        if not p6.thumbstickFrame then
            p6:Create(p8)

            if v4 and not p6.avatarAbilitiesEnabledChangedConn then
                p6.avatarAbilitiesEnabledChangedConn = v5:GetEnabledChangedSignal():Connect(function() -- line: 162
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

    p6.enabled = v9
    p6.thumbstickFrame.Visible = v9

    return nil
end

function self.OnInputEnded(p9) -- line: 204
    p9.isTouchActive = false

    local DynamicThumbstickScriptableBinding = p9.data.controlModule.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding")

    if DynamicThumbstickScriptableBinding then
        DynamicThumbstickScriptableBinding:Fire(Vector2.zero)
    end

    p9:FadeThumbstick(false)
end

function self.FadeThumbstick(p10, p11) -- line: 213
    -- upvalues: t1 (copy), t2 (copy), v3 (copy), TweenService (copy), v4 (copy)
    if not p11 and p10.isTouchActive or p10.isFirstTouch then
        return
    end

    if p10.startImageFadeTween then
        p10.startImageFadeTween:Cancel()
    end

    if p10.endImageFadeTween then
        p10.endImageFadeTween:Cancel()
    end

    if v4 and p10.endImageCenterFadeTween then
        p10.endImageCenterFadeTween:Cancel()
    end

    for i = 1, #p10.middleImages do
        if p10.middleImageFadeTweens[i] then
            p10.middleImageFadeTweens[i]:Cancel()
        end
    end

    if p11 then
        if v4 and p10.newStyle then
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
            if not (v4 and p10.newStyle) then
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
        if not (v4 and p10.newStyle) then
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
            if not (v4 and p10.newStyle) then
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

function self.FadeThumbstickFrame(p12, p13, p14) -- line: 311
    p12.fadeInAndOutHalfDuration = p13 * 0.5
    p12.fadeInAndOutBalance = p14
    p12.tweenInAlphaStart = tick()
end

function self.DoFadeInBackground(p15) -- line: 317
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

function self.DoMove(p16, p17) -- line: 342
    local v10 = if p17.Magnitude < p16.radiusOfDeadZone then Vector2.new() else p17.Unit * (1 - math.max(0, (p16.radiusOfMaxSpeed - p17.Magnitude) / p16.radiusOfMaxSpeed))
    local v12 = Vector2.new(v10.X, -v10.Y)
    local DynamicThumbstickScriptableBinding = p16.data.controlModule.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding")

    if DynamicThumbstickScriptableBinding then
        DynamicThumbstickScriptableBinding:Fire(v12)
    end
end

function self.LayoutMiddleImages(p18, p19, p20) -- line: 361
    -- upvalues: v1 (copy)
    local v13 = p18.thumbstickSize / 2 + p18.middleSize
    local v14 = p20 - p19
    local v15 = v14.Magnitude - p18.thumbstickRingSize / 2 - p18.middleSize
    local Unit = v14.Unit
    local v16 = p18.middleSpacing * v1
    local middleSpacing = p18.middleSpacing

    if v16 < v15 then
        middleSpacing = v15 / v1
    end

    for i = 1, v1 do
        local v17 = p18.middleImages[i]
        local v18 = v13 + middleSpacing * (i - 2)
        local v19 = v13 + middleSpacing * (i - 1)

        if v18 < v15 then
            local v20 = p20 - Unit * v19
            local v22 = math.clamp(1 - (v19 - v15) / middleSpacing, 0, 1)

            v17.Visible = true
            v17.Position = UDim2.new(0, v20.X, 0, v20.Y)
            v17.Size = UDim2.new(0, p18.middleSize * v22, 0, p18.middleSize * v22)
            continue
        end

        v17.Visible = false
    end
end

function self.MoveStick(p21, p22) -- line: 392
    local v23 = Vector2.new(p21.moveTouchStartPosition.X, p21.moveTouchStartPosition.Y) - p21.thumbstickFrame.AbsolutePosition
    local v24 = Vector2.new(p22.X, p22.Y) - p21.thumbstickFrame.AbsolutePosition

    p21.endImage.Position = UDim2.new(0, v24.X, 0, v24.Y)
    p21:LayoutMiddleImages(v23, v24)
end

function self.Create(p23, p24) -- line: 400
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), UserAllowAbilityControlsBonus (copy), UserDoubleJumpButtonFix (copy), UserPlayerScriptsResetDTTouchOnCreate (copy), GuiService (copy), RunService (copy), TweenService (copy), ThumbstickAction (copy), AvatarAbilitiesInterface (copy), v4 (copy), LocalPlayer2 (ref), v5 (copy)
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

        if not v4 and p23.avatarAbilitiesEnabledChangedConn then
            p23.avatarAbilitiesEnabledChangedConn:Disconnect()
            p23.avatarAbilitiesEnabledChangedConn = nil
        end

        if v4 then
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

    local function layoutThumbstickFrame(p25) -- line: 448
        -- upvalues: p23 (copy)
        if p25 then
            p23.thumbstickFrame.Size = UDim2.new(1, 100, 0.4, 100)
            p23.thumbstickFrame.Position = UDim2.new(0, -100, 0.6, 0)
        else
            p23.thumbstickFrame.Size = UDim2.new(0.4, 100, 0.6666666666666666, 100)
            p23.thumbstickFrame.Position = UDim2.new(0, -100, 0.3333333333333333, 0)
        end
    end

    p23.newStyle = v4 and v5:isEnabled()
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
        local v25 = if UserDoubleJumpButtonFix then ThumbstickAction:FindFirstChild("DynamicTouchBinding") else nil

        if not v25 then
            v25 = Instance.new("InputBinding")
            v25.Name = "DynamicTouchBinding"
            v25.KeyCode = Enum.KeyCode.TouchPosition
            v25.Parent = ThumbstickAction
        end

        v25.UIModifier = p23.thumbstickButton
    end

    if v4 and p23.newStyle then
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

    local function ResizeThumbstick() -- line: 590
        -- upvalues: p23 (copy), p24 (copy), UserAllowAbilityControlsBonus (copy), AvatarAbilitiesInterface (copy), v4 (copy)
        local AbsoluteSize = p24.AbsoluteSize
        local v26 = math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500
        local v27 = if v26 then 2 else 1
        local v28 = if v4 then p23.newStyle else AvatarAbilitiesInterface.isEnabled()

        if UserAllowAbilityControlsBonus and v28 and v26 then
            v27 = 1.6216216216216217
        end

        p23.thumbstickSize = 45 * v27
        p23.thumbstickRingSize = 20 * v27
        p23.middleSize = 10 * v27
        p23.middleSpacing = 14 * v27
        p23.radiusOfDeadZone = 2 * v27
        p23.radiusOfMaxSpeed = 20 * v27

        local v29 = 74 * v27

        if not v4 or p23.isFirstTouch then
            if v28 then
                local v30 = if v26 then 100 else 64
                local v31 = v26 and 112 or 64

                p23.startImage.Position = UDim2.new(0, v29 * 0.5 + 100 + v30, 1, -v29 * 0.5 - 100 - v31)
            else
                p23.startImage.Position = UDim2.new(0, p23.thumbstickRingSize * 3.3 + 100, 1, -p23.thumbstickRingSize * 2.8 - 100)
            end

            p23.startImage.Size = UDim2.new(0, v29, 0, v29)
        end

        p23.endImage.Position = p23.startImage.Position

        if not (v4 and p23.newStyle) then
            p23.endImage.Size = UDim2.new(0, p23.thumbstickSize * 0.8, 0, p23.thumbstickSize * 0.8)
        else
            p23.endImage.Size = UDim2.new(0, p23.thumbstickSize * 0.6, 0, p23.thumbstickSize * 0.6)
        end
    end

    ResizeThumbstick()
    p23.absoluteSizeChangedConn = p24:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if not v4 then
        p23.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    local function onCurrentCameraChanged() -- line: 656
        -- upvalues: p23 (copy), layoutThumbstickFrame (copy)
        if p23.cameraChangedConn then
            p23.cameraChangedConn:Disconnect()
            p23.cameraChangedConn = nil
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local function onViewportSizeChanged() -- line: 663
            -- upvalues: CurrentCamera (copy), layoutThumbstickFrame (copy)
            local ViewportSize = CurrentCamera.ViewportSize

            layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
        end

        p23.cameraChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

        local ViewportSize = CurrentCamera.ViewportSize

        layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
    end

    p23.currentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

    if workspace.CurrentCamera or v4 then
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
    p23.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- line: 687
        -- upvalues: p23 (copy)
        if p23.tweenInAlphaStart ~= nil then
            local v37 = tick() - p23.tweenInAlphaStart
            local v38 = p23.fadeInAndOutHalfDuration * 2 * p23.fadeInAndOutBalance

            p23.thumbstickFrame.BackgroundTransparency = 1 - math.min(v37 / v38, 1) * 0.35

            if v38 < v37 then
                p23.tweenOutAlphaStart = tick()
                p23.tweenInAlphaStart = nil
            end
        elseif p23.tweenOutAlphaStart ~= nil then
            local v34 = tick() - p23.tweenOutAlphaStart
            local v35 = p23.fadeInAndOutHalfDuration * 2 - p23.fadeInAndOutHalfDuration * 2 * p23.fadeInAndOutBalance

            p23.thumbstickFrame.BackgroundTransparency = math.min(v34 / v35, 1) * 0.35 + 0.65

            if v35 < v34 then
                p23.tweenOutAlphaStart = nil
            end
        end
    end)

    p23.onStateChanged = function(p26) -- line: 709
        -- upvalues: p23 (copy), v2 (copy), GuiService (copy), TweenService (copy), v4 (copy)
        if p26 == v2 then
            if p23.isTouchActive then
                p23:OnInputEnded()
            end
        else
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min
            local v42 = Vector3.new(p26.X + Min.X, p26.Y + Min.Y, 0)

            if not p23.isTouchActive then
                p23.isTouchActive = true

                if p23.isFirstTouch then
                    p23.isFirstTouch = false

                    local v43 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

                    TweenService:Create(p23.startImage, v43, {
                        Size = UDim2.new(0, 0, 0, 0)
                    }):Play()

                    if not v4 or not p23.newStyle then
                        TweenService:Create(p23.endImage, v43, {
                            Size = UDim2.new(0, p23.thumbstickSize, 0, p23.thumbstickSize),
                            ImageColor3 = Color3.new(0, 0, 0)
                        }):Play()
                    end
                end

                p23.moveTouchStartPosition = v42
                p23.moveTouchFirstChanged = true
                p23:DoFadeInBackground()
            else
                if p23.moveTouchFirstChanged then
                    p23.moveTouchFirstChanged = false

                    local v44 = Vector2.new(p23.moveTouchStartPosition.X - p23.thumbstickFrame.AbsolutePosition.X, p23.moveTouchStartPosition.Y - p23.thumbstickFrame.AbsolutePosition.Y)

                    p23.startImage.Visible = true
                    p23.startImage.Position = UDim2.new(0, v44.X, 0, v44.Y)
                    p23.endImage.Visible = true
                    p23.endImage.Position = p23.startImage.Position
                    p23:FadeThumbstick(true)
                    p23:MoveStick(p23.moveTouchStartPosition)
                end

                local v45 = Vector2.new(v42.X - p23.moveTouchStartPosition.X, v42.Y - p23.moveTouchStartPosition.Y)

                if v45.Magnitude > 0 then
                    p23:DoMove(v45)
                    p23:MoveStick(v42)
                end
            end
        end
    end

    p23.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- line: 769
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

    local v46 = PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

    local function longShowBackground() -- line: 785
        -- upvalues: p23 (copy)
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()
    end

    p23.playerGuiChangedConn = PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 791
        -- upvalues: p23 (copy), PlayerGui (ref), v46 (copy)
        if (not v46 or PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and (v46 or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) then
            return
        end

        p23.playerGuiChangedConn:Disconnect()
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()

        if v46 then
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

    coroutine.wrap(function() -- line: 818
        -- upvalues: p23 (copy)
        game.Loaded:Wait()
        p23.fadeInAndOutHalfDuration = 2.5
        p23.fadeInAndOutBalance = 0.05
        p23.tweenInAlphaStart = tick()
    end)()
end

return self
