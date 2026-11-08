-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local OverlayRoot = require(script.Parent.OverlayRoot)
local t1 = {
    seconds = 0.8,
    startTransparency = 0.1,
    coverage = 0.55,
    minPeak = 4,
    maxPeak = 200,
    fallbackScreenFactor = 16,
    template = ReplicatedStorage.Assets.UI.Misc.ShockSphere
}
local v1 = TweenInfo.new(t1.seconds, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(t1.seconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function midpoint(p1) -- line: 22
    local AbsolutePosition, AbsoluteSize = p1.AbsolutePosition, p1.AbsoluteSize

    return UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X * 0.5, AbsolutePosition.Y + AbsoluteSize.Y * 0.5)
end

local function peakScaleFor(p2, p3) -- line: 27
    -- upvalues: t1 (copy)
    local v3 = math.max(p2.AbsoluteSize.Magnitude, 1)
    local CurrentCamera = workspace.CurrentCamera

    return (math.clamp((if CurrentCamera then CurrentCamera.ViewportSize.Magnitude else v3 * t1.fallbackScreenFactor) / v3 * t1.coverage * p3, t1.minPeak, t1.maxPeak))
end

local function timed(p4, p5) -- line: 36
    if p5 == p4.Time then
        return p4
    end

    return (TweenInfo.new(p5, p4.EasingStyle, p4.EasingDirection))
end

local function pulseOf(p6) -- line: 42
    local UIScale = p6:FindFirstChildOfClass("UIScale")

    if UIScale and UIScale:IsA("UIScale") then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Parent = p6

    return UIScale2
end

return function(p7, p8, p9, p10) -- line: 52
    -- upvalues: TweenService (copy), OverlayRoot (copy), t1 (copy), v1 (copy), v2 (copy)
    p8 = p8 or t1.seconds

    local clone = t1.template:Clone()
    local UIScale = clone:FindFirstChildOfClass("UIScale")

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = clone
    end

    UIScale.Scale = 0
    clone.ImageTransparency = p9 or t1.startTransparency

    local AbsolutePosition, AbsoluteSize = p7.AbsolutePosition, p7.AbsoluteSize

    clone.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X * 0.5, AbsolutePosition.Y + AbsoluteSize.Y * 0.5)
    clone.Size = UDim2.fromOffset(p7.AbsoluteSize.X, p7.AbsoluteSize.Y)
    clone.Parent = OverlayRoot()

    local function recentre() -- line: 68
        -- upvalues: p7 (copy), clone (copy)
        local AbsolutePosition, AbsoluteSize = p7.AbsolutePosition, p7.AbsoluteSize

        clone.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X * 0.5, AbsolutePosition.Y + AbsoluteSize.Y * 0.5)
    end

    local t2 = {
        p7:GetPropertyChangedSignal("AbsolutePosition"):Connect(recentre),
        p7:GetPropertyChangedSignal("AbsoluteSize"):Connect(recentre)
    }

    clone.Destroying:Once(function() -- line: 75
        -- upvalues: t2 (copy)
        for _, v6 in t2 do
            v6:Disconnect()
        end
    end)

    local v7 = v2

    if p8 ~= v2.Time then
        v7 = TweenInfo.new(p8, v2.EasingStyle, v2.EasingDirection)
    end

    TweenService:Create(clone, v7, {
        ImageTransparency = 1
    }):Play()

    local v8 = v1

    if p8 ~= v1.Time then
        v8 = TweenInfo.new(p8, v1.EasingStyle, v1.EasingDirection)
    end

    p10 = p10 or 1

    local v10 = math.max(p7.AbsoluteSize.Magnitude, 1)
    local CurrentCamera = workspace.CurrentCamera
    local tween = TweenService:Create(UIScale, v8, {
        Scale = math.clamp((if CurrentCamera then CurrentCamera.ViewportSize.Magnitude else v10 * t1.fallbackScreenFactor) / v10 * t1.coverage * p10, t1.minPeak, t1.maxPeak)
    })

    tween.Completed:Once(function() -- line: 85
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    tween:Play()

    return clone
end
