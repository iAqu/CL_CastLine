-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local v1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
local ParentParent = script.Parent.Parent
local UIPadding = ParentParent.Frame.Text_Element.UIPadding
local ImageLabel = ParentParent.ImageLabel
local ImageColor3 = ImageLabel.ImageColor3
local tween = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0.04, 0)
})
local tween2 = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0, 0)
})
local tween3 = TweenService:Create(ImageLabel, v1, {
    ImageColor3 = Color3.fromRGB(255, 255, 255)
})
local tween4 = TweenService:Create(ImageLabel, v1, {
    ImageColor3 = ImageColor3
})
local Hover = SoundService.Hover

script.Parent.MouseEnter:Connect(function() -- line: 21
    -- upvalues: tween (copy), tween3 (copy), Hover (copy)
    Hover.PlaybackSpeed = 1 + math.random(-5, 5) / 100
    Hover.Playing = true
    Hover.TimePosition = 0
    tween:Play()
    tween3:Play()
end)
script.Parent.MouseLeave:Connect(function() -- line: 29
    -- upvalues: tween2 (copy), tween4 (copy)
    tween2:Play()
    tween4:Play()
end)
