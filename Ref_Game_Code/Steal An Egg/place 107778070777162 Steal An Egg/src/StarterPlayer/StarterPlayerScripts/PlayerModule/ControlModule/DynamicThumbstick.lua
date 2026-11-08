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

local function v3() -- line: 37
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
end

local ok, result = pcall(v3)
local v4 = ok and result

local function v5() -- line: 44
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end

local ok2, result2 = pcall(v5)
local v6 = ok2 and result2
local LocalPlayer = Players.LocalPlayer
local LocalPlayer2 = LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer2 = Players.LocalPlayer
end

local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new() -- line: 61
    -- upvalues: BaseCharacterController (copy), self (copy)
    local v9 = setmetatable(BaseCharacterController.new(), self)

    v9.moveTouchObject = nil
    v9.moveTouchLockedIn = false
    v9.moveTouchFirstChanged = false
    v9.moveTouchStartPosition = nil
    v9.startImage = nil
    v9.endImage = nil
    v9.middleImages = {}
    v9.startImageFadeTween = nil
    v9.endImageFadeTween = nil
    v9.middleImageFadeTweens = {}
    v9.isFirstTouch = true
    v9.thumbstickFrame = nil
    v9.onRenderSteppedConn = nil
    v9.fadeInAndOutBalance = 0.5
    v9.fadeInAndOutHalfDuration = 0.3
    v9.hasFadedBackgroundInPortrait = false
    v9.hasFadedBackgroundInLandscape = false
    v9.tweenInAlphaStart = nil
    v9.tweenOutAlphaStart = nil

    return v9
end

function self.GetIsJumping(p1) -- line: 96
    local isJumping = p1.isJumping

    p1.isJumping = false

    return isJumping
end

function self.Enable(p2, p3, p4) -- line: 102
    -- upvalues: ContextActionService (copy), v4 (copy)
    if p3 == nil then
        return false
    end

    local v10 = not not p3

    if p2.enabled == v10 then
        return true
    end

    if v10 then
        if not p2.thumbstickFrame then
            p2:Create(p4)
        end

        p2:BindContextActions()
    else
        if v4 then
            p2:UnbindContextActions()
        else
            ContextActionService:UnbindAction("DynamicThumbstickAction")
        end

        p2:OnInputEnded()
    end

    p2.enabled = v10
    p2.thumbstickFrame.Visible = v10

    return nil
end

function self.OnInputEnded(p5) -- line: 131
    p5.moveTouchObject = nil
    p5.moveVector = Vector3.new(0, 0, 0)
    p5:FadeThumbstick(false)
end

function self.FadeThumbstick(p6, p7) -- line: 137
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

function self.FadeThumbstickFrame(p8, p9, p10) -- line: 180
    p8.fadeInAndOutHalfDuration = p9 * 0.5
    p8.fadeInAndOutBalance = p10
    p8.tweenInAlphaStart = tick()
end

function self.InputInFrame(p11, p12) -- line: 186
    local AbsolutePosition = p11.thumbstickFrame.AbsolutePosition
    local v11 = AbsolutePosition + p11.thumbstickFrame.AbsoluteSize
    local Position = p12.Position

    return Position.X >= AbsolutePosition.X and Position.Y >= AbsolutePosition.Y and Position.X <= v11.X and Position.Y <= v11.Y
end

function self.DoFadeInBackground(p13) -- line: 198
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

function self.DoMove(p14, p15) -- line: 221
    if p15.Magnitude < p14.radiusOfDeadZone then
        p14.moveVector = Vector3.new(0, 0, 0)
    else
        local v13 = p15.Unit * (1 - math.max(0, (p14.radiusOfMaxSpeed - p15.Magnitude) / p14.radiusOfMaxSpeed))

        p14.moveVector = Vector3.new(v13.X, 0, v13.Y)
    end
end

function self.LayoutMiddleImages(p16, p17, p18) -- line: 239
    -- upvalues: v1 (copy)
    local v14 = p16.thumbstickSize / 2 + p16.middleSize
    local v15 = p18 - p17
    local v16 = v15.Magnitude - p16.thumbstickRingSize / 2 - p16.middleSize
    local Unit = v15.Unit
    local v17 = p16.middleSpacing * v1
    local middleSpacing = p16.middleSpacing

    if v17 < v16 then
        middleSpacing = v16 / v1
    end

    for i = 1, v1 do
        local v18 = p16.middleImages[i]
        local v19 = v14 + middleSpacing * (i - 2)
        local v20 = v14 + middleSpacing * (i - 1)

        if v19 < v16 then
            local v21 = p18 - Unit * v20
            local v23 = math.clamp(1 - (v20 - v16) / middleSpacing, 0, 1)

            v18.Visible = true
            v18.Position = UDim2.new(0, v21.X, 0, v21.Y)
            v18.Size = UDim2.new(0, p16.middleSize * v23, 0, p16.middleSize * v23)
            continue
        end

        v18.Visible = false
    end
end

function self.MoveStick(p19, p20) -- line: 270
    local v24 = Vector2.new(p19.moveTouchStartPosition.X, p19.moveTouchStartPosition.Y) - p19.thumbstickFrame.AbsolutePosition
    local v25 = Vector2.new(p20.X, p20.Y) - p19.thumbstickFrame.AbsolutePosition

    p19.endImage.Position = UDim2.new(0, v25.X, 0, v25.Y)
    p19:LayoutMiddleImages(v24, v25)
end

function self.BindContextActions(p21) -- line: 278
    -- upvalues: Value (copy), UserInputService (copy), ContextActionService (copy), TweenService (copy), v4 (copy)
    local function inputBegan(p22) -- line: 279
        -- upvalues: p21 (copy), TweenService (copy)
        if p21.moveTouchObject or not p21:InputInFrame(p22) then
            return Enum.ContextActionResult.Pass
        end

        if p21.isFirstTouch then
            p21.isFirstTouch = false

            local v26 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

            TweenService:Create(p21.startImage, v26, {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            TweenService:Create(p21.endImage, v26, {
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

    local function inputChanged(p23) -- line: 311
        -- upvalues: p21 (copy)
        if p23 ~= p21.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end

        if p21.moveTouchFirstChanged then
            p21.moveTouchFirstChanged = false

            local v27 = Vector2.new(p23.Position.X - p21.thumbstickFrame.AbsolutePosition.X, p23.Position.Y - p21.thumbstickFrame.AbsolutePosition.Y)

            p21.startImage.Visible = true
            p21.startImage.Position = UDim2.new(0, v27.X, 0, v27.Y)
            p21.endImage.Visible = true
            p21.endImage.Position = p21.startImage.Position
            p21:FadeThumbstick(true)
            p21:MoveStick(p23.Position)
        end

        p21.moveTouchLockedIn = true

        local v28 = Vector2.new(p23.Position.X - p21.moveTouchStartPosition.X, p23.Position.Y - p21.moveTouchStartPosition.Y)
        local v29 = math.abs(v28.X) > 0
        local v30 = if not v29 then math.abs(v28.Y) > 0 else nil

        if v29 or v30 then
            p21:DoMove(v28)
            p21:MoveStick(p23.Position)
        end

        return Enum.ContextActionResult.Sink
    end

    local function inputEnded(p24) -- line: 344
        -- upvalues: p21 (copy)
        local v31 = p24 == p21.moveTouchObject
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

    local function handleInput(_, p26, p27) -- line: 354
        -- upvalues: p21 (copy), inputBegan (copy), inputChanged (copy), v4 (copy)
        if p26 == Enum.UserInputState.Begin then
            return (inputBegan(p27))
        end

        if p26 == Enum.UserInputState.Change then
            if not v4 then
                return (inputChanged(p27))
            end

            if p27 == p21.moveTouchObject then
                return Enum.ContextActionResult.Sink
            end

            return Enum.ContextActionResult.Pass
        end

        if p26 == Enum.UserInputState.End then
            local v32 = p27 == p21.moveTouchObject
            local moveTouchLockedIn

            if v32 then
                p21:OnInputEnded()
                moveTouchLockedIn = p21.moveTouchLockedIn
            end

            if not v32 or not moveTouchLockedIn then
                return Enum.ContextActionResult.Pass
            end

            return Enum.ContextActionResult.Sink
        end

        if p26 == Enum.UserInputState.Cancel then
            p21:OnInputEnded()
        end
    end

    ContextActionService:BindActionAtPriority("DynamicThumbstickAction", handleInput, false, Value, Enum.UserInputType.Touch)

    if v4 then
        p21.TouchMovedCon = UserInputService.TouchMoved:Connect(function(p28, _) -- line: 382
            -- upvalues: inputChanged (copy)
            inputChanged(p28)
        end)
    end
end

function self.UnbindContextActions(p30) -- line: 388
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("DynamicThumbstickAction")

    if p30.TouchMovedCon then
        p30.TouchMovedCon:Disconnect()
    end
end

function self.Create(p31, p32) -- line: 396
    -- upvalues: t1 (copy), v1 (copy), GuiService (copy), UserInputService (copy), RunService (copy), v6 (copy), LocalPlayer2 (ref)
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
    end

    local v33 = if v6 then 100 else 0

    local function layoutThumbstickFrame(p33) -- line: 411
        -- upvalues: p31 (copy), v33 (copy)
        if p33 then
            p31.thumbstickFrame.Size = UDim2.new(1, v33, 0.4, v33)
            p31.thumbstickFrame.Position = UDim2.new(0, -v33, 0.6, 0)
        else
            p31.thumbstickFrame.Size = UDim2.new(0.4, v33, 0.6666666666666666, v33)
            p31.thumbstickFrame.Position = UDim2.new(0, -v33, 0.3333333333333333, 0)
        end
    end

    p31.thumbstickFrame = Instance.new("Frame")
    p31.thumbstickFrame.BorderSizePixel = 0
    p31.thumbstickFrame.Name = "DynamicThumbstickFrame"
    p31.thumbstickFrame.Visible = false
    p31.thumbstickFrame.BackgroundTransparency = 1
    p31.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    p31.thumbstickFrame.Active = false
    p31.thumbstickFrame.Size = UDim2.new(0.4, v33, 0.6666666666666666, v33)
    p31.thumbstickFrame.Position = UDim2.new(0, -v33, 0.3333333333333333, 0)
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

    local function ResizeThumbstick() -- line: 467
        -- upvalues: p31 (copy), p32 (copy), v33 (copy)
        local AbsoluteSize = p32.AbsoluteSize

        if math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500 then
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

        p31.startImage.Position = UDim2.new(0, p31.thumbstickRingSize * 3.3 + v33, 1, -p31.thumbstickRingSize * 2.8 - v33)
        p31.startImage.Size = UDim2.new(0, p31.thumbstickRingSize * 3.7, 0, p31.thumbstickRingSize * 3.7)
        p31.endImage.Position = p31.startImage.Position
        p31.endImage.Size = UDim2.new(0, p31.thumbstickSize * 0.8, 0, p31.thumbstickSize * 0.8)
    end

    ResizeThumbstick()
    p31.absoluteSizeChangedConn = p32:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

    local connection

    local function onCurrentCameraChanged() -- line: 505
        -- upvalues: layoutThumbstickFrame (copy), connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local function onViewportSizeChanged() -- line: 512
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
    p31.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- line: 532
        -- upvalues: p31 (copy)
        if p31.tweenInAlphaStart ~= nil then
            local v39 = tick() - p31.tweenInAlphaStart
            local v40 = p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

            p31.thumbstickFrame.BackgroundTransparency = 1 - math.min(v39 / v40, 1) * 0.35

            if v40 < v39 then
                p31.tweenOutAlphaStart = tick()
                p31.tweenInAlphaStart = nil
            end
        elseif p31.tweenOutAlphaStart ~= nil then
            local v36 = tick() - p31.tweenOutAlphaStart
            local v37 = p31.fadeInAndOutHalfDuration * 2 - p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

            p31.thumbstickFrame.BackgroundTransparency = math.min(v36 / v37, 1) * 0.35 + 0.65

            if v37 < v36 then
                p31.tweenOutAlphaStart = nil
            end
        end
    end)
    p31.onTouchEndedConn = UserInputService.TouchEnded:connect(function(p34) -- line: 551
        -- upvalues: p31 (copy)
        if p34 == p31.moveTouchObject then
            p31:OnInputEnded()
        end
    end)
    GuiService.MenuOpened:connect(function() -- line: 557
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

    local connection2, v42

    v42 = PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

    local function longShowBackground() -- line: 573
        -- upvalues: p31 (copy)
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()
    end

    connection2 = PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 579
        -- upvalues: p31 (copy), PlayerGui (ref), connection2 (ref), v42 (ref)
        if (not v42 or PlayerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and (v42 or PlayerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) then
            return
        end

        connection2:disconnect()
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()

        if v42 then
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

    coroutine.wrap(function() -- line: 599
        -- upvalues: p31 (copy)
        game.Loaded:Wait()
        p31.fadeInAndOutHalfDuration = 2.5
        p31.fadeInAndOutBalance = 0.05
        p31.tweenInAlphaStart = tick()
    end)()
end

return self
