local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService") -- Gets the Roblox TweenService to move things smoothly.

local RotationGradientModule = {}

local gradientCache = {}

function RotationGradientModule.StartRotationAnimation(gradient: UIGradient, rotateSpeed: number?) : Tween
    rotateSpeed = rotateSpeed or 2
    local currentrot = gradient.Rotation
    local tweenInformation = TweenInfo.new(rotateSpeed, Enum.EasingStyle.Linear,Enum.EasingDirection.In,-1,false)
    local goal = {Rotation = currentrot + 360}
    local tween = TweenService:Create(gradient, tweenInformation, goal)
    tween:Play()
    gradientCache[gradient] = tween
end

function RotationGradientModule.StopRotationAnimation(gradient: UIGradient) : Tween
    if gradientCache[gradient] then
        gradientCache[gradient]:Cancel()
        gradientCache[gradient] = nil
    end
end

return RotationGradientModule
