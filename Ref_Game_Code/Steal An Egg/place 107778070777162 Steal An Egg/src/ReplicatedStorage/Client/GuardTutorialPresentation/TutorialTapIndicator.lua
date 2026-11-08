-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local TutorialProp = require(script.Parent.TutorialProp)
local v1 = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
local t1 = {}

local function nudgeX(p1, p2) -- line: 17
    return UDim2.new(p2, p1.X.Offset, p1.Y.Scale, p1.Y.Offset)
end

local function placement(p3, p4, p5) -- line: 23
    if p4 then
        return Vector2.zero, UDim2.fromScale(0, 0), p5 or UDim2.fromScale(1, 1)
    end

    return p3.AnchorPoint, p3.Position, p5 or p3.Size
end

local function roundCorners(p6, p7) -- line: 30
    local Frame = p6:FindFirstChild("Frame")
    local UICorner = if Frame == nil then nil else Frame:FindFirstChildWhichIsA("UICorner")

    assert(UICorner ~= nil, "the tap template needs Frame.UICorner to reshape")
    UICorner.CornerRadius = p7
end

function t1.Attach(p8, p9, p10, p11) -- line: 37
    -- upvalues: TweenService (copy), TutorialProp (copy), v1 (copy)
    assert(typeof(p8) == "Instance" and p8:IsA("GuiButton"), "a tap hint needs a GuiButton")

    local v4 = p9 == true
    local v5 = if v4 then p8 else assert(p8.Parent, "a tap hint beside its button needs that button parented")
    local TutorialTapHint, TutorialTapHint2 = TutorialProp.Clone("TutorialTap", "TutorialTapHint")
    local zero = if v4 then Vector2.zero else p8.AnchorPoint
    local v6 = if v4 then UDim2.fromScale(0, 0) else p8.Position
    local v7 = if v4 then p11 or UDim2.fromScale(1, 1) else p11 or p8.Size

    TutorialTapHint.AnchorPoint = zero
    TutorialTapHint.Size = v7
    TutorialTapHint.Position = v6
    TutorialTapHint.Active = false
    TutorialTapHint.ZIndex = p8.ZIndex + 1

    if p10 ~= nil then
        local Frame = TutorialTapHint:FindFirstChild("Frame")
        local UICorner = if Frame == nil then nil else Frame:FindFirstChildWhichIsA("UICorner")

        assert(UICorner ~= nil, "the tap template needs Frame.UICorner to reshape")
        UICorner.CornerRadius = p10
    end

    TutorialTapHint.Parent = v5

    local Chevron = TutorialTapHint:FindFirstChild("Chevron")

    assert(Chevron ~= nil and Chevron:IsA("ImageLabel"), "the tap template needs a Chevron ImageLabel")

    local ChevronPosition = Chevron.Position
    local v10 = UDim2.new(1, ChevronPosition.X.Offset, ChevronPosition.Y.Scale, ChevronPosition.Y.Offset)

    Chevron.Position = v10

    local tween = TweenService:Create(Chevron, v1, {
        Position = UDim2.new(1.18, v10.X.Offset, v10.Y.Scale, v10.Y.Offset)
    })

    tween:Play()
    TutorialTapHint2:Add(tween, "Cancel")

    return TutorialProp.Teardown("Removing the tutorial tap hint", TutorialTapHint2)
end

return t1
