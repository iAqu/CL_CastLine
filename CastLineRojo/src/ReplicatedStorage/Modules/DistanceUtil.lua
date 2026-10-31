local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local DistanceUtil = {}

local DEFAULT_DETECT_DISTANCE = 10
local isTouchingTargetModel = false
local isDetecting = true

function DistanceUtil.EnableDetecting(enable: boolean)
    isDetecting = enable
end

-- function module.DetectDistance(character: Model, targetModel: Model, detectDistance: number?, considerVolume: boolean?): boolean
function DistanceUtil.DetectDistance(sourceModel: Model, targetModel: Model, detectDistance: number?, considerVolume: boolean?): boolean

    -- local humanoidRootPart = character.HumanoidRootPart
    -- if not humanoidRootPart then warn("No humanoidRootPart!") return false end
    local sourcePrimaryPart = sourceModel.PrimaryPart
    if not sourcePrimaryPart then warn("No primary part!", sourceModel.Name) return false end

    local targetPrimaryPart = targetModel.PrimaryPart
    if not targetPrimaryPart then warn("No primary part!", targetModel.Name) return false end

    detectDistance = detectDistance or DEFAULT_DETECT_DISTANCE
    considerVolume = considerVolume or false

    if considerVolume then
        local targetRadius = math.max(targetPrimaryPart.Size.X, targetPrimaryPart.Size.Y, targetPrimaryPart.Size.Z) / 2
        detectDistance = detectDistance + targetRadius
    end

    -- local distance = (targetPrimaryPart.Position - humanoidRootPart.Position).Magnitude
    -- local distance = (targetPrimaryPart.Position - sourcePrimaryPart.Position).Magnitude
    local v = (sourcePrimaryPart.Position - targetPrimaryPart.Position)
    local distanceSquared = v.x^2 + v.y^2 + v.z^2
    -- if distance <= detectDistance then
    if distanceSquared <= detectDistance^2 then
        return true
    else
        return false
    end
end

function DistanceUtil.DetectTouchAndDistance(character: Model, targetModel: Model, detectDistance: number?, callback: () -> boolean)
    if not targetModel.PrimaryPart then warn("No primary part!", targetModel.Name) return end

    detectDistance = detectDistance or DEFAULT_DETECT_DISTANCE

    targetModel.PrimaryPart.Touched:Connect(function(part)
        if isDetecting == false then return end

        if not isTouchingTargetModel and part.Parent == character then
            isTouchingTargetModel = true
            repeat
                game:GetService('RunService').Heartbeat:Wait()
                if DistanceUtil.DetectDistance(character, targetModel, detectDistance) == false then
                    isTouchingTargetModel = false
                else
                    callback(true)
                end
                -- callback(true)
            until not isTouchingTargetModel
            callback(false)
        end
    end)
end

function DistanceUtil.GetHorizontalDistance(position1: Vector3, position2: Vector3): number
    local v = position1 - position2
    return math.sqrt(v.x^2 + v.z^2)
end

-- BuildBoundsPart OBB in XZ (object space of part). halfMargin adds to each half-extent on X/Z (negative = stricter inner box).
function DistanceUtil.IsPointInsidePartXZWithHalfMargin(part: BasePart, worldPosition: Vector3, halfMargin: number): boolean
	local localPos = part.CFrame:PointToObjectSpace(worldPosition)
	local hx = part.Size.X / 2 + halfMargin
	local hz = part.Size.Z / 2 + halfMargin
	if hx <= 1e-4 or hz <= 1e-4 then
		return false
	end
	return math.abs(localPos.X) <= hx and math.abs(localPos.Z) <= hz
end

return DistanceUtil