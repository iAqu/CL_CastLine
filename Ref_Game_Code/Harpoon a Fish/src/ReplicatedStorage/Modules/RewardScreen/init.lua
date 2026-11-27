-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local CameraShaker = require(script:WaitForChild("CameraShaker"))
local RewardScreen = PlayerGui:WaitForChild("RewardScreen")
local Template = RewardScreen:WaitForChild("Template")
local Unlock = RewardScreen:WaitForChild("Unlock")
local Bar = RewardScreen:WaitForChild("Main"):WaitForChild("Bar")
local BackgroundEffects = RewardScreen:WaitForChild("BackgroundEffects")
local Size = Bar.Size
local Size2 = Template.Size
local Heading = RewardScreen:WaitForChild("Heading")
local Pop = Heading:WaitForChild("Pop")
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local v3 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local v6 = false
local v7 = false
local ButtonHover = require(script.Parent:WaitForChild("ButtonHover"))
local Choices = RewardScreen:WaitForChild("Choices")
local Left = Choices:WaitForChild("Left")
local Right = Choices:WaitForChild("Right")

Choices.Visible = false

local t1 = {
    left = nil,
    right = nil
}
local _ = {
    SHINE_GAP = 1.6,
    SHINE_TIME = 0.55
}
local n1 = 0

local function flashy(p1) -- line: 70
    -- upvalues: ButtonHover (copy), n1 (ref)
    n1 += 1

    local v8 = n1

    task.spawn(function() -- line: 73
        -- upvalues: p1 (copy), v8 (copy), ButtonHover (copy), n1 (ref)
        while n1 == v8 do
            ButtonHover.Sweep(p1, 0.55)
            task.wait(1.6)
        end
    end)
    ButtonHover.Sparkle(p1, function() -- line: 79
        -- upvalues: v8 (copy), n1 (ref)
        return n1 == v8
    end)
end

local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(253, 250, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(253, 215, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 165, 0))
})

local function placeAbove(p2) -- line: 89
    local AbsoluteSize = p2.AbsoluteSize

    if AbsoluteSize.X <= 0 then
        return
    end

    local v10 = AbsoluteSize.Y / AbsoluteSize.X
    local v11 = 0.105 * AbsoluteSize.Y / AbsoluteSize.X
    local v12 = 0.5 + (v10 + v11) / 2

    p2.Amount.Position = UDim2.fromScale(v12, 0.5)
    p2.Icon.Position = UDim2.fromScale(v12 - p2.Amount.TextBounds.X / AbsoluteSize.X / 2 - v11, 0.5)
end

Right.Above.Amount.Money.Color = v9

for v13, v14 in pairs({
        left = Left,
        right = Right
    }) do
    v14.Text.AutoLocalize = false

    local Price = v14:FindFirstChild("Price")

    if Price then
        Price.AutoLocalize = false
    end

    local Above = v14.Above

    Above.Amount.AutoLocalize = false
    Above.Amount:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 104
        -- upvalues: placeAbove (copy), Above (copy)
        placeAbove(Above)
    end)
    Above:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 105
        -- upvalues: placeAbove (copy), Above (copy)
        placeAbove(Above)
    end)
    ButtonHover.Attach(v14, {
        tile = 1,
        highlight = true,
        highlightFade = 0.8,
        highlightCorner = 0.25,
        corner = 0.25,
        shine = v14 == Right
    })
    v14.Activated:Connect(function() -- line: 107
        -- upvalues: v6 (ref), ButtonHover (copy), t1 (copy), v14 (copy), v13 (copy)
        ButtonHover.Press(v14)

        local v15 = t1[v13]

        if v6 and v15 then
            v15()
        end
    end)
end

local TextButton = Instance.new("TextButton")

TextButton.Name = "InputBlocker"
TextButton.Size = UDim2.fromScale(1, 1)
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.AutoButtonColor = false
TextButton.Active = true
TextButton.Modal = true
TextButton.ZIndex = 999
TextButton.Visible = false
TextButton.Selectable = false
TextButton.Parent = RewardScreen

local InputMode = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("InputMode"))
local ContextActionService = game:GetService("ContextActionService")
local v16
local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))

local function clearRewards() -- line: 137
    -- upvalues: Bar (copy)
    for _, child in Bar:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function shine(p3) -- line: 146
    -- upvalues: TweenService (copy), v5 (copy)
    local v17 = p3:FindFirstChild("Effect") and p3.Effect:FindFirstChild("UIGradient")

    if v17 then
        task.spawn(function() -- line: 149
            -- upvalues: p3 (copy), v17 (copy), TweenService (copy), v5 (copy)
            while p3.Parent do
                v17.Offset = Vector2.new(-1, 0)
                TweenService:Create(v17, v5, {
                    Offset = Vector2.new(1, 0)
                }):Play()
                task.wait(2)
            end
        end)
    end
end

local function revealItems(p4) -- line: 158
    -- upvalues: TweenService (copy), CameraShaker (copy), Template (copy), Unlock (copy), Bar (copy), Size2 (copy), v3 (copy), shine (copy)
    for v18, v19 in p4 do
        local clone = Template:Clone()

        clone.Name = "Reward" .. v18
        clone.Size = UDim2.new(0, 0, 0, 0)
        clone.Visible = true
        clone.Parent = Bar

        if v19.setup then
            v19.setup(clone)
        end

        shine(clone)
        Unlock.PlaybackSpeed = 1 + (v18 - 1) * 0.2
        Unlock:Play()

        if game:GetService("Players").LocalPlayer:GetAttribute("SetReduceFx") ~= true then
            CameraShaker("Hard Bump")
        end

        local tween = TweenService:Create(clone, v3, {
            Size = Size2
        })

        tween:Play()
        tween.Completed:Wait()
    end
end

return {
    Busy = function() -- Busy | line: 185
        -- upvalues: v6 (ref)
        return v6
    end,
    Dismiss = function() -- Dismiss | line: 190
        -- upvalues: v7 (ref)
        v7 = true
    end,
    Show = function(p5, p6, p7, p8) -- Show | line: 196
        -- upvalues: TweenService (copy), RewardScreen (copy), Unlock (copy), Bar (copy), BackgroundEffects (copy), Size (copy), Heading (copy), Pop (copy), v1 (copy), v2 (copy), v4 (copy), v6 (ref), v7 (ref), Choices (copy), Left (copy), Right (copy), t1 (copy), n1 (ref), flashy (copy), placeAbove (copy), TextButton (copy), InputMode (copy), ContextActionService (copy), v16 (ref), PadMenu (copy), clearRewards (copy), revealItems (copy)
        if not v6 then
            v6 = true
            v7 = false

            local v20 = tonumber(p6) or 30

            p5 = p5 or {}
            RewardScreen.Enabled = true
            TextButton.Visible = true
            Bar.Visible = true
            Bar.Rotation = 0
            Bar.Size = UDim2.new(0.05, 0, 0.01, 0)
            TweenService:Create(BackgroundEffects, v4, {
                GroupTransparency = 0
            }):Play()

            local tween = TweenService:Create(Bar, v1, {
                Rotation = 2,
                Size = Size
            })

            tween:Play()

            if p7 then
                Heading.Text = p7
                Heading.TextTransparency = 0
                Heading.Rotation = -18
                Pop.Scale = 0
                Heading.Visible = true
                TweenService:Create(Pop, v1, {
                    Scale = 1
                }):Play()
                TweenService:Create(Heading, v1, {
                    Rotation = 0
                }):Play()
            end

            tween.Completed:Wait()
            revealItems(p5)

            local Title = RewardScreen:FindFirstChild("Title")

            if p8 then
                t1.left = p8.left and p8.left.press
                t1.right = p8.right and p8.right.press
                Left.Text.Text = p8.left and p8.left.text or ""
                Right.Text.Text = p8.right and p8.right.text or ""

                local Price = Right:FindFirstChild("Price")

                if Price then
                    Price.Text = p8.right and p8.right.price or ""
                end

                for v23, v24 in pairs({
                        left = Left,
                        right = Right
                    }) do
                    v24.Above.Amount.Text = p8[v23] and p8[v23].above or ""
                    v24.Above.Visible = v24.Above.Amount.Text ~= ""
                    placeAbove(v24.Above)
                end

                local v25 = p8.left ~= nil
                local v26 = p8.right ~= nil

                Left.Visible = v25
                Right.Visible = v26

                if Title then
                    Title.Visible = false
                end

                Choices.Visible = true

                if p8.right and p8.right.shine then
                    flashy(Right)
                end

                if p8.left and p8.left.shine then
                    flashy(Left)
                end

                PadMenu.Open(Choices, nil, {
                    first = p8.left and Left or Right
                })

                while not v7 do
                    task.wait()
                end

                PadMenu.Close(Choices)
                n1 += 1
                Choices.Visible = false
                t1.left = nil
                t1.right = nil
            else
                local connection = TextButton.Activated:Connect(function() -- line: 261
                    -- upvalues: v7 (ref)
                    v7 = true
                end)

                game:GetService("GuiService").SelectedObject = nil
                PadMenu.Open(RewardScreen, function() -- line: 266
                    -- upvalues: v7 (ref)
                    v7 = true
                end)
                ContextActionService:BindActionAtPriority("RewardContinue", function(_, p10) -- line: 267
                    -- upvalues: v7 (ref)
                    if p10 == Enum.UserInputState.Begin then
                        v7 = true
                    end

                    return Enum.ContextActionResult.Sink
                end, false, 3000, Enum.KeyCode.ButtonA)

                if Title and not v16 then
                    v16 = InputMode.Prompt(RewardScreen, {
                        text = "CONTINUE",
                        height = 0.06,
                        key = Enum.KeyCode.ButtonA,
                        position = UDim2.fromScale(0.5, 0.92),
                        anchor = Vector2.new(0.5, 0.5),
                        zIndex = Title.ZIndex
                    })
                end

                local v27 = InputMode.Pad()

                if Title then
                    Title.Visible = not v27
                end

                if v16 then
                    v16.Show(true)
                end

                local elapsed = os.clock()

                while not v7 and os.clock() - elapsed < v20 do
                    task.wait()
                end

                connection:Disconnect()
                ContextActionService:UnbindAction("RewardContinue")
                PadMenu.Close(RewardScreen)

                if v16 then
                    v16.Show(false)
                end
            end

            if Title then
                Title.Visible = true
            end

            Unlock:Stop()
            Unlock.PlaybackSpeed = 1
            clearRewards()

            local tween2 = TweenService:Create(Bar, v2, {
                Rotation = 0,
                Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0)
            })

            tween2:Play()

            if Heading.Visible then
                TweenService:Create(Pop, v2, {
                    Scale = 0
                }):Play()
                TweenService:Create(Heading, v2, {
                    TextTransparency = 1
                }):Play()
            end

            tween2.Completed:Wait()
            Heading.Visible = false
            TweenService:Create(BackgroundEffects, v4, {
                GroupTransparency = 1
            }):Play()
            Bar.Visible = false
            TextButton.Visible = false
            RewardScreen.Enabled = false
            v6 = false
        end
    end
}
