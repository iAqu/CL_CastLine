local GuiAnimationUtil = {}

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UiConfettiUtil = require(script.Parent.UiConfettiUtil)
local SoundHelper = require(script.Parent.SoundHelper)
local Constants = require(script.Parent.Constants)
local NumberUtil = require(script.Parent.NumberUtil)
local animatingGuiElements = {}

local CONFETTI_COOLDOWN = 0.8
local CASH_GAIN_DURATION = 1
local CASH_GAIN_FADE_DELAY = 0.55
local CASH_GAIN_START_OFFSET = Vector3.new(0, 3, 0)
local CASH_GAIN_END_OFFSET = Vector3.new(0, 4.5, 0)
local lastConfettiAt = 0

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local HomeGui = PlayerGui:WaitForChild("HomeGui")

local function getCashLabelTemplate(): TextLabel?
    local bottomFrame = HomeGui:FindFirstChild("BottomFrame")
    local currencyFrame = bottomFrame and bottomFrame:FindFirstChild("CurrencyFrame")
    local winsFrame = currencyFrame and currencyFrame:FindFirstChild("Wins")
    local template = winsFrame and winsFrame:FindFirstChild("WinsShadowLabel")
    return if template and template:IsA("TextLabel") then template else nil
end

function GuiAnimationUtil.PlayCharacterCashGain(character: Model?, amount: number, duration: number?)
    if not character or typeof(amount) ~= "number" or amount ~= amount or amount == math.huge or amount == -math.huge then
        return
    end

    local cashGainDuration = if typeof(duration) == "number" and duration > 0 then duration else CASH_GAIN_DURATION
    local fadeDelay = cashGainDuration * (CASH_GAIN_FADE_DELAY / CASH_GAIN_DURATION)
    local fadeDuration = cashGainDuration - fadeDelay

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local cashLabelTemplate = getCashLabelTemplate()
    if not rootPart or not rootPart:IsA("BasePart") or not cashLabelTemplate then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CharacterCashGain"
    billboard.Adornee = rootPart
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 100
    billboard.Size = UDim2.fromOffset(220, 70)
    billboard.StudsOffsetWorldSpace = CASH_GAIN_START_OFFSET
    billboard.Parent = PlayerGui

    local cashLabel = cashLabelTemplate:Clone()
    cashLabel.Name = "CashGainLabel"
    cashLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    cashLabel.Position = UDim2.fromScale(0.5, 0.5)
    cashLabel.Size = UDim2.fromScale(1, 1)
    cashLabel.BackgroundTransparency = 1
    cashLabel.TextXAlignment = Enum.TextXAlignment.Center
    cashLabel.Text = "+$" .. NumberUtil.FormatItemPriceCompact(math.floor(amount + 0.5))
    cashLabel.Parent = billboard

    local textLabels = { cashLabel }
    for _, descendant in ipairs(cashLabel:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            descendant.Text = cashLabel.Text
            descendant.TextXAlignment = Enum.TextXAlignment.Center
            table.insert(textLabels, descendant)
        end
    end

    local moveTweenInfo = TweenInfo.new(cashGainDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeTweenInfo = TweenInfo.new(
        fadeDuration,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In,
        0,
        false,
        fadeDelay
    )
    local moveTween = TweenService:Create(billboard, moveTweenInfo, {
        StudsOffsetWorldSpace = CASH_GAIN_END_OFFSET,
    })

    for _, textLabel in ipairs(textLabels) do
        TweenService:Create(textLabel, fadeTweenInfo, { TextTransparency = 1 }):Play()
    end
    for _, descendant in ipairs(cashLabel:GetDescendants()) do
        if descendant:IsA("UIStroke") then
            TweenService:Create(descendant, fadeTweenInfo, { Transparency = 1 }):Play()
        end
    end

    moveTween.Completed:Connect(function()
        billboard:Destroy()
    end)
    moveTween:Play()
    Debris:AddItem(billboard, cashGainDuration + 0.5)
end

function GuiAnimationUtil.PlayResourceAddAnimation(guiElement, duration: number?, scale: number?, callback: () -> nil?)
    if not guiElement then return end

    scale = scale or 1.1
    duration = duration or 0.1

    local originalSize = guiElement.Size
    local scaleTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local scaleTween = TweenService:Create(guiElement, scaleTweenInfo, {Size = UDim2.new(originalSize.X.Scale * scale, 0, originalSize.Y.Scale * scale, 0)})
    
    scaleTween:Play()
    scaleTween.Completed:Wait()

    local backTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local backTween = TweenService:Create(guiElement, backTweenInfo, {Size = originalSize})
    backTween:Play()
    backTween.Completed:Wait()
    
    if callback then
        callback()
    end
end

function GuiAnimationUtil.PopAnimation(guiElement, duration: number?, scale: number?, callback: (() -> nil)?)
    if not guiElement then return end
    if table.find(animatingGuiElements, guiElement) then return end
    
    table.insert(animatingGuiElements, guiElement)

    scale = scale or 1.1
    duration = duration or 0.1

    local originalSize = guiElement.Size
    local scaleTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local scaleTween = TweenService:Create(guiElement, scaleTweenInfo, {Size = UDim2.new(originalSize.X.Scale * scale, 0, originalSize.Y.Scale * scale, 0)})
    
    scaleTween:Play()
    scaleTween.Completed:Wait()

    local backTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
    local backTween = TweenService:Create(guiElement, backTweenInfo, {Size = originalSize})
    backTween:Play()
    backTween.Completed:Wait()
    
    table.remove(animatingGuiElements, table.find(animatingGuiElements, guiElement))
    if callback then
        callback()
    end
end

function GuiAnimationUtil.PlaySuccessCelebration(parentGui: GuiObject?, preset: string?, bypassConfettiCooldown: boolean?)
    if not parentGui then
        return
    end

    SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER, nil, 0, 1)

    local now = os.clock()
	if bypassConfettiCooldown or now - lastConfettiAt >= CONFETTI_COOLDOWN then
        lastConfettiAt = now
        UiConfettiUtil.play(parentGui, preset or "celebration")
    end
end

function GuiAnimationUtil.RibbonParticle(parentGui: GuiObject?)
    parentGui = parentGui or HomeGui

    local CustomColor = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)}
    task.spawn(function()
        for i = 1, 60, 1 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.fromOffset(20,20)
            local XPos = math.random(0,100)/100
            particle.Position = UDim2.fromScale(XPos, -.2)
            particle.BorderSizePixel = 0
            -- particle.BackgroundColor = CustomColor[math.random(1, #CustomColor)]
            particle.BackgroundColor3 = CustomColor[math.random(1, #CustomColor)]
            particle.Rotation = math.random(0,90)
            particle.Parent = parentGui
            particle.ZIndex = 1000
    
            local tweenInfo = TweenInfo.new(
                2.5, -- Time
                Enum.EasingStyle.Linear, -- EasingStyle
                Enum.EasingDirection.Out, -- EasingDirection
                0, -- RepeatCount (when less than zero the tween will loop indefinitely)
                false, -- Reverses (tween will reverse once reaching it's goal)
                0 -- DelayTime
            )
    
            local tween = TweenService:Create(particle, tweenInfo, {Position = UDim2.fromScale(XPos - math.random(-10,10)/100, 1), Rotation = math.random(-600,600)})
            tween:Play()
            tween.Completed:Connect(function(PlaybackState)
                particle:Destroy()
            end)
            task.wait(.01)
        end
    end)
end

return GuiAnimationUtil
