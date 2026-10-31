-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Value = Enum.ContextActionPriority.High.Value
local t1 = {
    0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75
}
local v1 = #t1
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserAllowAbilityControls = FlagUtil.getUserFlag("UserAllowAbilityControls")
local UserAllowAbilityControlsBonus = FlagUtil.getUserFlag("UserAllowAbilityControlsBonus")

local function v3() -- line: 42
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end

local ok, result = pcall(v3)
local v4 = ok and result
local v5 = if UserAllowAbilityControls then require(script.Parent:WaitForChild("AvatarAbilitiesInterface")) else nil
local LocalPlayer = Players.LocalPlayer
local LocalPlayer2 = LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer2 = Players.LocalPlayer
end

local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new() -- line: 64
    -- upvalues: BaseCharacterController (copy), self (copy)
    local v8 = setmetatable(BaseCharacterController.new(), self)

    v8.moveTouchObject = nil
    v8.moveTouchLockedIn = false
    v8.moveTouchFirstChanged = false
    v8.moveTouchStartPosition = nil
    v8.startImage = nil
    v8.endImage = nil
    v8.middleImages = {}
    v8.startImageFadeTween = nil
    v8.endImageFadeTween = nil
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

    return v8
end

function self.GetIsJumping(p1) -- line: 99
    local isJumping = p1.isJumping

    p1.isJumping = false

    return isJumping
end

function self.Enable(p2, p3, p4) -- line: 105
    if p3 == nil then
        return false
    end

    local v9 = not not p3

    if p2.enabled == v9 then
        return true
    end

    if v9 then
        if not p2.thumbstickFrame then
            p2:Create(p4)
        end

        p2:BindContextActions()
    else
        p2:UnbindContextActions()
        p2:OnInputEnded()
    end

    p2.enabled = v9
    p2.thumbstickFrame.Visible = v9

    return nil
end

function self.OnInputEnded(p5) -- line: 130
    p5.moveTouchObject = nil
    p5.moveVector = Vector3.new(0, 0, 0)
    p5:FadeThumbstick(false)
end

function self.FadeThumbstick(p6, p7) -- line: 136
    -- upvalues: t1 (copy), v2 (copy), TweenService (copy)
    if not p7 and p6.moveTouchObject or p6.isFirstTouch then
        return
    end

    if p6.startImageFadeTween then
        p6.startImageFadeTween:Cancel()
    end

    if p6.endImageFadeTween then
        p6.endImageFadeTween:Cancel()
    end

    for i = 1, #p6.middleImages do
        if p6.middleImageFadeTweens[i] then
            p6.middleImageFadeTweens[i]:Cancel()
        end
    end

    if p7 then
        p6.startImageFadeTween = TweenService:Create(p6.startImage, v2, {
            ImageTransparency = 0
        })
        p6.startImageFadeTween:Play()
        p6.endImageFadeTween = TweenService:Create(p6.endImage, v2, {
            ImageTransparency = 0.2
        })
        p6.endImageFadeTween:Play()

        for i = 1, #p6.middleImages do
            p6.middleImageFadeTweens[i] = TweenService:Create(p6.middleImages[i], v2, {
                ImageTransparency = t1[i]
            })
            p6.middleImageFadeTweens[i]:Play()
        end
    else
        p6.startImageFadeTween = TweenService:Create(p6.startImage, v2, {
            ImageTransparency = 1
        })
        p6.startImageFadeTween:Play()
        p6.endImageFadeTween = TweenService:Create(p6.endImage, v2, {
            ImageTransparency = 1
        })
        p6.endImageFadeTween:Play()

        for i = 1, #p6.middleImages do
            p6.middleImageFadeTweens[i] = TweenService:Create(p6.middleImages[i], v2, {
                ImageTransparency = 1
            })
            p6.middleImageFadeTweens[i]:Play()
        end
    end
end

function self.FadeThumbstickFrame(p8, p9, p10) -- line: 179
    p8.fadeInAndOutHalfDuration = p9 * 0.5
    p8.fadeInAndOutBalance = p10
    p8.tweenInAlphaStart = tick()
end

function self.InputInFrame(p11, p12) -- line: 185
    local AbsolutePosition = p11.thumbstickFrame.AbsolutePosition
    local v10 = AbsolutePosition + p11.thumbstickFrame.AbsoluteSize
    local Position = p12.Position

    return Position.X >= AbsolutePosition.X and Position.Y >= AbsolutePosition.Y and Position.X <= v10.X and Position.Y <= v10.Y
end

function self.DoFadeInBackground(p13) -- line: 197
    -- upvalues: LocalPlayer2 (ref)
    local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
    local hasFadedBackgroundInLandscape

    if PlayerGui then
        if PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            hasFadedBackgroundInLandscape = p13.hasFadedBackgroundInLandscape
            p13.hasFadedBackgroundInLandscape = true
        elseif PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            hasFadedBackgroundInLandscape = p13.hasFadedBackgroundInPortrait
            p13.hasFadedBackgroundInPortrait = true
        else
            hasFadedBackgroundInLandscape = false
        end
    else
        hasFadedBackgroundInLandscape = false
    end

    if hasFadedBackgroundInLandscape then
        return
    end

    p13.fadeInAndOutHalfDuration = 0.3
    p13.fadeInAndOutBalance = 0.5
    p13.tweenInAlphaStart = tick()
end

function self.DoMove(p14, p15) -- line: 220
    if p15.Magnitude < p14.radiusOfDeadZone then
        p14.moveVector = Vector3.new(0, 0, 0)
    else
        local v12 = p15.Unit * (1 - math.max(0, (p14.radiusOfMaxSpeed - p15.Magnitude) / p14.radiusOfMaxSpeed))

        p14.moveVector = Vector3.new(v12.X, 0, v12.Y)
    end
end

function self.LayoutMiddleImages(p16, p17, p18) -- line: 238
    -- upvalues: v1 (copy)
    local v13 = p16.thumbstickSize / 2 + p16.middleSize
    local v14 = p18 - p17
    local v15 = v14.Magnitude - p16.thumbstickRingSize / 2 - p16.middleSize
    local Unit = v14.Unit
    local v16 = p16.middleSpacing * v1
    local middleSpacing = p16.middleSpacing

    if v16 < v15 then
        middleSpacing = v15 / v1
    end

    for i = 1, v1 do
        local v17 = p16.middleImages[i]
        local v18 = v13 + middleSpacing * (i - 2)
        local v19 = v13 + middleSpacing * (i - 1)

        if v18 < v15 then
            local v20 = p18 - Unit * v19
            local v22 = math.clamp(1 - (v19 - v15) / middleSpacing, 0, 1)

            v17.Visible = true
            v17.Position = UDim2.new(0, v20.X, 0, v20.Y)
            v17.Size = UDim2.new(0, p16.middleSize * v22, 0, p16.middleSize * v22)
            continue
        end

        v17.Visible = false
    end
end

function self.MoveStick(p19, p20) -- line: 269
    local v23 = Vector2.new(p19.moveTouchStartPosition.X, p19.moveTouchStartPosition.Y) - p19.thumbstickFrame.AbsolutePosition
    local v24 = Vector2.new(p20.X, p20.Y) - p19.thumbstickFrame.AbsolutePosition

    p19.endImage.Position = UDim2.new(0, v24.X, 0, v24.Y)
    p19:LayoutMiddleImages(v23, v24)
end

function self.BindContextActions(p21) -- line: 277
    -- upvalues: Value (copy), UserInputService (copy), ContextActionService (copy), TweenService (copy)
    local function inputBegan(p22) -- line: 278
        -- upvalues: p21 (copy), TweenService (copy)
        if p21.moveTouchObject or not p21:InputInFrame(p22) then
            return Enum.ContextActionResult.Pass
        end

        if p21.isFirstTouch then
            p21.isFirstTouch = false

            local v25 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

            TweenService:Create(p21.startImage, v25, {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            TweenService:Create(p21.endImage, v25, {
                Size = UDim2.new(0, p21.thumbstickSize, 0, p21.thumbstickSize),
                ImageColor3 = Color3.new(0, 0, 0)
            }):Play()
        end

        p21.moveTouchLockedIn = false
        p21.moveTouchObject = p22
        p21.moveTouchStartPosition = p22.Position
        p21.moveTouchFirstChanged = true
        p21:DoFadeInBackground()

        return Enum.ContextActionResult.Pass
    end

    local function inputChanged(p23) -- line: 310
        -- upvalues: p21 (copy)
        if p23 ~= p21.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end

        if p21.moveTouchFirstChanged then
            p21.moveTouchFirstChanged = false

            local v26 = Vector2.new(p23.Position.X - p21.thumbstickFrame.AbsolutePosition.X, p23.Position.Y - p21.thumbstickFrame.AbsolutePosition.Y)

            p21.startImage.Visible = true
            p21.startImage.Position = UDim2.new(0, v26.X, 0, v26.Y)
            p21.endImage.Visible = true
            p21.endImage.Position = p21.startImage.Position
            p21:FadeThumbstick(true)
            p21:MoveStick(p23.Position)
        end

        p21.moveTouchLockedIn = true

        local v27 = Vector2.new(p23.Position.X - p21.moveTouchStartPosition.X, p23.Position.Y - p21.moveTouchStartPosition.Y)
        local v28 = math.abs(v27.X) > 0
        local v29 = if not v28 then math.abs(v27.Y) > 0 else nil

        if v28 or v29 then
            p21:DoMove(v27)
            p21:MoveStick(p23.Position)
        end

        return Enum.ContextActionResult.Sink
    end

    local function inputEnded(p24) -- line: 343
        -- upvalues: p21 (copy)
        local v30 = p24 == p21.moveTouchObject
        local moveTouchLockedIn

        if v30 then
            p21:OnInputEnded()
            moveTouchLockedIn = p21.moveTouchLockedIn
        end

        if not v30 or not moveTouchLockedIn then
            return Enum.ContextActionResult.Pass
        end

        return Enum.ContextActionResult.Sink
    end

    local function handleInput(_, p26, p27) -- line: 353
        -- upvalues: p21 (copy), inputBegan (copy)
        if p26 == Enum.UserInputState.Begin then
            return (inputBegan(p27))
        end

        if p26 == Enum.UserInputState.Change then
            if p27 == p21.moveTouchObject then
                return Enum.ContextActionResult.Sink
            end

            return Enum.ContextActionResult.Pass
        end

        if p26 == Enum.UserInputState.End then
            local v31 = p27 == p21.moveTouchObject
            local moveTouchLockedIn

            if v31 then
                p21:OnInputEnded()
                moveTouchLockedIn = p21.moveTouchLockedIn
            end

            if not v31 or not moveTouchLockedIn then
                return Enum.ContextActionResult.Pass
            end

            return Enum.ContextActionResult.Sink
        end

        if p26 == Enum.UserInputState.Cancel then
            p21:OnInputEnded()
        end
    end

    ContextActionService:BindActionAtPriority("DynamicThumbstickAction", handleInput, false, Value, Enum.UserInputType.Touch)
    p21.TouchMovedCon = UserInputService.TouchMoved:Connect(function(p28, _) -- line: 376
        -- upvalues: inputChanged (copy)
        inputChanged(p28)
    end)
end

function self.UnbindContextActions(p30) -- line: 381
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("DynamicThumbstickAction")

    if p30.TouchMovedCon then
        p30.TouchMovedCon:Disconnect()
    end
end

function self.Create(p31, p32) -- line: 389
    -- upvalues: t1 (copy), v1 (copy), GuiService (copy), UserInputService (copy), RunService (copy), UserAllowAbilityControls (copy), UserAllowAbilityControlsBonus (copy), v4 (copy), v5 (copy), LocalPlayer2 (ref)
    if p31.thumbstickFrame then
        p31.thumbstickFrame:Destroy()
        p31.thumbstickFrame = nil

        if p31.onRenderSteppedConn then
            p31.onRenderSteppedConn:Disconnect()
            p31.onRenderSteppedConn = nil
        end

        if p31.absoluteSizeChangedConn then
            p31.absoluteSizeChangedConn:Disconnect()
            p31.absoluteSizeChangedConn = nil
        end

        if UserAllowAbilityControls and p31.avatarAbilitiesEnabledChangedConn then
            p31.avatarAbilitiesEnabledChangedConn:Disconnect()
            p31.avatarAbilitiesEnabledChangedConn = nil
        end
    end

    local v32 = if v4 then 100 else 0

    local function layoutThumbstickFrame(p33) -- line: 410
        -- upvalues: p31 (copy), v32 (copy)
        if p33 then
            p31.thumbstickFrame.Size = UDim2.new(1, v32, 0.4, v32)
            p31.thumbstickFrame.Position = UDim2.new(0, -v32, 0.6, 0)
        else
            p31.thumbstickFrame.Size = UDim2.new(0.4, v32, 0.6666666666666666, v32)
            p31.thumbstickFrame.Position = UDim2.new(0, -v32, 0.3333333333333333, 0)
        end
    end

    p31.thumbstickFrame = Instance.new("Frame")
    p31.thumbstickFrame.BorderSizePixel = 0
    p31.thumbstickFrame.Name = "DynamicThumbstickFrame"
    p31.thumbstickFrame.Visible = false
    p31.thumbstickFrame.BackgroundTransparency = 1
    p31.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    p31.thumbstickFrame.Active = false
    p31.thumbstickFrame.Size = UDim2.new(0.4, v32, 0.6666666666666666, v32)
    p31.thumbstickFrame.Position = UDim2.new(0, -v32, 0.3333333333333333, 0)
    p31.startImage = Instance.new("ImageLabel")
    p31.startImage.Name = "ThumbstickStart"
    p31.startImage.Visible = true
    p31.startImage.BackgroundTransparency = 1
    p31.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    p31.startImage.ImageRectOffset = Vector2.new(1, 1)
    p31.startImage.ImageRectSize = Vector2.new(144, 144)
    p31.startImage.ImageColor3 = Color3.new(0, 0, 0)
    p31.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    p31.startImage.ZIndex = 10
    p31.startImage.Parent = p31.thumbstickFrame
    p31.endImage = Instance.new("ImageLabel")
    p31.endImage.Name = "ThumbstickEnd"
    p31.endImage.Visible = true
    p31.endImage.BackgroundTransparency = 1
    p31.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    p31.endImage.ImageRectOffset = Vector2.new(1, 1)
    p31.endImage.ImageRectSize = Vector2.new(144, 144)
    p31.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    p31.endImage.ZIndex = 10
    p31.endImage.Parent = p31.thumbstickFrame

    for i = 1, v1 do
        p31.middleImages[i] = Instance.new("ImageLabel")
        p31.middleImages[i].Name = "ThumbstickMiddle"
        p31.middleImages[i].Visible = false
        p31.middleImages[i].BackgroundTransparency = 1
        p31.middleImages[i].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        p31.middleImages[i].ImageRectOffset = Vector2.new(1, 1)
        p31.middleImages[i].ImageRectSize = Vector2.new(144, 144)
        p31.middleImages[i].ImageTransparency = t1[i]
        p31.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
        p31.middleImages[i].ZIndex = 9
        p31.middleImages[i].Parent = p31.thumbstickFrame
    end

    local function ResizeThumbstick() -- line: 466
        -- upvalues: p31 (copy), p32 (copy), v32 (copy), UserAllowAbilityControls (copy), UserAllowAbilityControlsBonus (copy), v5 (copy)
        local AbsoluteSize = p32.AbsoluteSize
        local v33 = math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500

        if UserAllowAbilityControls then
            local v34 = if v33 then 2 else 1

            if UserAllowAbilityControlsBonus and v5.isEnabled() and v33 then
                v34 = 1.6216216216216217
            end

            p31.thumbstickSize = 45 * v34
            p31.thumbstickRingSize = 20 * v34
            p31.middleSize = 10 * v34
            p31.middleSpacing = 14 * v34
            p31.radiusOfDeadZone = 2 * v34
            p31.radiusOfMaxSpeed = 20 * v34

            local v35 = 74 * v34

            if v5.isEnabled() then
                local v36 = if v33 then 100 else 64
                local v37 = v33 and 112 or 64

                p31.startImage.Position = UDim2.new(0, v35 * 0.5 + v32 + v36, 1, -v35 * 0.5 - v32 - v37)
            else
                p31.startImage.Position = UDim2.new(0, p31.thumbstickRingSize * 3.3 + v32, 1, -p31.thumbstickRingSize * 2.8 - v32)
            end

            p31.startImage.Size = UDim2.new(0, v35, 0, v35)
        else
            if v33 then
                p31.thumbstickSize = 90
                p31.thumbstickRingSize = 40
                p31.middleSize = 20
                p31.middleSpacing = 28
                p31.radiusOfDeadZone = 4
                p31.radiusOfMaxSpeed = 40
            else
                p31.thumbstickSize = 45
                p31.thumbstickRingSize = 20
                p31.middleSize = 10
                p31.middleSpacing = 14
                p31.radiusOfDeadZone = 2
                p31.radiusOfMaxSpeed = 20
            end

            p31.startImage.Position = UDim2.new(0, p31.thumbstickRingSize * 3.3 + v32, 1, -p31.thumbstickRingSize * 2.8 - v32)
            p31.startImage.Size = UDim2.new(0, p31.thumbstickRingSize * 3.7, 0, p31.thumbstickRingSize * 3.7)
        end

        p31.endImage.Position = p31.startImage.Position
        p31.endImage.Size = UDim2.new(0, p31.thumbstickSize * 0.8, 0, p31.thumbstickSize * 0.8)
    end

    ResizeThumbstick()
    p31.absoluteSizeChangedConn = p32:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    if UserAllowAbilityControls then
        p31.avatarAbilitiesEnabledChangedConn = v5.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    local connection

    local function onCurrentCameraChanged() -- line: 534
        -- upvalues: layoutThumbstickFrame (copy), connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local function onViewportSizeChanged() -- line: 541
            -- upvalues: CurrentCamera (copy), layoutThumbstickFrame (copy)
            local ViewportSize = CurrentCamera.ViewportSize

            layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
        end

        connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

        local ViewportSize = CurrentCamera.ViewportSize

        layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
    end

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

    if workspace.CurrentCamera then
        onCurrentCameraChanged()
    end

    p31.moveTouchStartPosition = nil
    p31.startImageFadeTween = nil
    p31.endImageFadeTween = nil
    p31.middleImageFadeTweens = {}
    p31.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- line: 561
        -- upvalues: p31 (copy)
        if p31.tweenInAlphaStart ~= nil then
            local v43 = tick() - p31.tweenInAlphaStart
            local v44 = p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

            p31.thumbstickFrame.BackgroundTransparency = 1 - math.min(v43 / v44, 1) * 0.35

            if v44 < v43 then
                p31.tweenOutAlphaStart = tick()
                p31.tweenInAlphaStart = nil
            end
        elseif p31.tweenOutAlphaStart ~= nil then
            local v40 = tick() - p31.tweenOutAlphaStart
            local v41 = p31.fadeInAndOutHalfDuration * 2 - p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

            p31.thumbstickFrame.BackgroundTransparency = math.min(v40 / v41, 1) * 0.35 + 0.65

            if v41 < v40 then
                p31.tweenOutAlphaStart = nil
            end
        end
    end)
    p31.onTouchEndedConn = UserInputService.TouchEnded:connect(function(p34) -- line: 580
        -- upvalues: p31 (copy)
        if p34 == p31.moveTouchObject then
            p31:OnInputEnded()
        end
    end)
    GuiService.MenuOpened:connect(function() -- line: 586
        -- upvalues: p31 (copy)
        if p31.moveTouchObject then
            p31:OnInputEnded()
        end
    end)

    local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")

    while not PlayerGui do
        LocalPlayer2.ChildAdded:wait()
        PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")
    end

    local connection2, v46

    v46 = PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

    local function longShowBackground() -- line: 602
        -- upvalues: p31 (copy)
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()
    end

    connection2 = PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 608
        -- upvalues: p31 (copy), PlayerGui (ref), connection2 (ref), v46 (ref)
        if (not v46 or PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and (v46 or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) then
            return
        end

        connection2:disconnect()
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()

        if v46 then
            p31.hasFadedBackgroundInPortrait = true
        else
            p31.hasFadedBackgroundInLandscape = true
        end
    end)
    p31.thumbstickFrame.Parent = p32

    if game:IsLoaded() then
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()

        return
    end

    coroutine.wrap(function() -- line: 628
        -- upvalues: p31 (copy)
        game.Loaded:Wait()
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()
    end)()
end

return self
