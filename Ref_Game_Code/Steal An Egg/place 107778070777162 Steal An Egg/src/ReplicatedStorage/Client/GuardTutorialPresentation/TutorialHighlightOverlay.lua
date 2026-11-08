-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GUI = require(ReplicatedStorage.Client.GUI)
local TutorialProp = require(script.Parent.TutorialProp)
local t = require(ReplicatedStorage.Packages.t)
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = UDim2.fromScale(0.01, 0.01)
local t1 = {
    "AbsolutePosition",
    "AbsoluteSize"
}
local v3 = t.strict(t.instanceIsA("GuiObject"))
local t2 = {}

local function ringGoal(p1, p2) -- line: 26
    local AbsoluteSize = p1.AbsoluteSize
    local v4 = p1.AbsolutePosition + AbsoluteSize * 0.5 - p2.AbsolutePosition

    return {
        Size = UDim2.new(0, AbsoluteSize.X * 1.15, 0, AbsoluteSize.Y * 1.15),
        Position = UDim2.new(0, v4.X, 0, v4.Y)
    }
end

local function tutorialLayerHost() -- line: 35
    -- upvalues: GUI (copy)
    local v5 = GUI.TutorialInstructions()

    assert(v5:IsA("ScreenGui"), "the tutorial instruction layer is not a ScreenGui")

    local Parent = v5.Parent

    assert(Parent and Parent:IsA("PlayerGui"), "the tutorial instruction layer sits outside PlayerGui")

    return Parent
end

function t2.Attach(p3) -- line: 44
    -- upvalues: TweenService (copy), GUI (copy), TutorialProp (copy), v1 (copy), v2 (copy), t1 (copy), v3 (copy), ringGoal (copy)
    v3(p3)

    local GuardTutorialHighlight, GuardTutorialHighlight2 = TutorialProp.Clone("ClickTarget", "GuardTutorialHighlight")

    GuardTutorialHighlight.Enabled = true

    local v7 = GUI.TutorialInstructions()

    assert(v7:IsA("ScreenGui"), "the tutorial instruction layer is not a ScreenGui")

    local Parent = v7.Parent

    assert(Parent and Parent:IsA("PlayerGui"), "the tutorial instruction layer sits outside PlayerGui")
    GuardTutorialHighlight.Parent = Parent

    local Container = GuardTutorialHighlight.Container

    assert(Container:IsA("Frame"), "the highlight template has no Container frame")
    Container.Size = v2

    local tween

    local function discard() -- line: 57
        -- upvalues: tween (ref)
        if tween then
            tween:Cancel()
            tween:Destroy()
        end
    end

    local function reseat() -- line: 64
        -- upvalues: p3 (copy), GuardTutorialHighlight (copy), Container (copy), tween (ref), TweenService (copy), v1 (copy), ringGoal (copy)
        local v9 = ringGoal(p3, GuardTutorialHighlight)

        if tween then
            tween:Cancel()
            tween:Destroy()
        end

        local tween2 = TweenService:Create(Container, v1, v9)

        tween = tween2
        tween2:Play()
    end

    local v10 = ringGoal(p3, GuardTutorialHighlight)

    if tween then
        tween:Cancel()
        tween:Destroy()
    end

    local tween2 = TweenService:Create(Container, v1, v10)

    tween = tween2
    tween2:Play()

    for _, v11 in t1 do
        GuardTutorialHighlight2:Add(p3:GetPropertyChangedSignal(v11):Connect(reseat))
    end

    GuardTutorialHighlight2:Add(GuardTutorialHighlight:GetPropertyChangedSignal("AbsolutePosition"):Connect(reseat))
    GuardTutorialHighlight2:Add(discard)

    return TutorialProp.Teardown("Removing the tutorial highlight ring", GuardTutorialHighlight2)
end

return t2
