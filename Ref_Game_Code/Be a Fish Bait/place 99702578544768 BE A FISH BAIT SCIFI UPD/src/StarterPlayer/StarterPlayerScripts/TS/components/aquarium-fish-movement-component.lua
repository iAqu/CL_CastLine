-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component

local function randomPointInBounds(p1) -- line: 14
    local v1 = p1.Size * 0.5
    local v5 = Vector3.new((math.random() - 0.5) * 2 * v1.X, (math.random() - 0.5) * 2 * v1.Y, (math.random() - 0.5) * 2 * v1.Z)

    return p1.CFrame:PointToWorldSpace(v5)
end

local function findBounds(p2) -- line: 19
    local AquariumTank = p2:FindFirstChild("AquariumTank")

    if AquariumTank and AquariumTank:IsA("Part") then
        return AquariumTank
    end

    local v6 = p2:FindFirstChild("AquariumTank", true)

    return if v6 and v6:IsA("Part") then v6 else nil
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 37
        return "AquariumFishMovementComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 43
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p3, ...) -- line: 47
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p3, ...)
    p3._doMoveTimeStamp = 0
    p3._isSwimming = false
    p3._swimSpeed = 0
end

function self.destroy(p4) -- line: 53
    -- upvalues: BaseComponent (copy)
    local _alignPosition = p4._alignPosition

    if _alignPosition ~= nil then
        _alignPosition:Destroy()
    end

    local _alignOrientation = p4._alignOrientation

    if _alignOrientation ~= nil then
        _alignOrientation:Destroy()
    end

    local _movementAttachment = p4._movementAttachment

    if _movementAttachment ~= nil then
        _movementAttachment:Destroy()
    end

    BaseComponent.destroy(p4)
end

function self.onStart(p5) -- line: 68
    local instance = p5.instance
    local PrimaryPart = instance.PrimaryPart

    if not PrimaryPart then
        warn("[src/client/components/aquarium-fish-movement-component.ts:71]", "No primary part set for AquariumFishMovementComponent:", p5.instance)

        return nil
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Movement"
    Attachment.Parent = PrimaryPart
    p5._movementAttachment = Attachment

    local AlignPosition = Instance.new("AlignPosition")

    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
    AlignPosition.Attachment0 = Attachment
    AlignPosition.RigidityEnabled = false
    AlignPosition.MaxForce = 1e999
    AlignPosition.MaxVelocity = 100
    AlignPosition.Responsiveness = 200
    AlignPosition.Parent = PrimaryPart
    p5._alignPosition = AlignPosition

    local AlignOrientation = Instance.new("AlignOrientation")

    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.RigidityEnabled = true
    AlignOrientation.MaxAngularVelocity = 1e999
    AlignOrientation.MaxTorque = 1e999
    AlignOrientation.Responsiveness = 200
    AlignOrientation.Parent = PrimaryPart
    p5._alignOrientation = AlignOrientation

    local AquariumTank

    if instance.Parent ~= nil then
        local instanceParent = instance.Parent

        AquariumTank = instanceParent:FindFirstChild("AquariumTank")

        if not (AquariumTank and AquariumTank:IsA("Part")) then
            AquariumTank = instanceParent:FindFirstChild("AquariumTank", true)

            if not (AquariumTank and AquariumTank:IsA("Part")) then
                AquariumTank = nil
            end
        end
    end

    if AquariumTank then
        instance:PivotTo(CFrame.new(AquariumTank.CFrame.Position))
    end

    local Pivot = instance:GetPivot()

    AlignPosition.Position = Pivot.Position
    AlignOrientation.CFrame = Pivot
end

function self.onTick(p6, _) -- line: 106
    if not p6.attributes.shouldMove then
        return nil
    end

    if p6._isSwimming and p6._alignOrientation and p6._alignPosition and p6._movementAttachment and p6.instance.PrimaryPart and p6._facingCf ~= nil then
        local elapsed = os.clock()

        if p6._doMoveTimeStamp - elapsed > 0.5 then
            local v11 = math.rad(math.sin(elapsed * 3.5 * 3.141592653589793 * 2) * (p6._swimSpeed * 0.4))
            local _facingCf = p6._facingCf
            local v12 = CFrame.fromEulerAnglesYXZ(0, v11, 0)

            p6._alignOrientation.CFrame = _facingCf * v12
        else
            p6._alignOrientation.CFrame = p6._facingCf
        end
    end

    if os.clock() < p6._doMoveTimeStamp then
        return nil
    end

    p6:_doMove()
end

function self._doMove(p8) -- line: 133
    -- upvalues: randomPointInBounds (copy)
    local instance = p8.instance
    local instanceParent = instance.Parent

    if instanceParent then
        local AquariumTank = instanceParent:FindFirstChild("AquariumTank")

        if not (AquariumTank and AquariumTank:IsA("Part")) then
            AquariumTank = instanceParent:FindFirstChild("AquariumTank", true)

            if not (AquariumTank and AquariumTank:IsA("Part")) then
                AquariumTank = nil
            end
        end

        if AquariumTank then
            local Position = instance:GetPivot().Position
            local v13 = randomPointInBounds(AquariumTank)
            local v14 = v13 - Position

            if v14.Magnitude <= 0.01 then
                p8._doMoveTimeStamp = 0

                return nil
            end

            local Unit = v14.Unit
            local v15 = CFrame.lookAt(Position, Position + Unit)
            local v18 = math.acos((math.clamp(instance:GetPivot().LookVector:Dot(v14.Unit), -1, 1))) / 1e999
            local v19 = 1 + math.random() * 2

            p8.instance:PivotTo(v15)

            if p8._alignPosition then
                p8._alignPosition.Position = v13
                p8._alignPosition.MaxVelocity = v14.Magnitude / math.max(1, v19 - 0.5)
            end

            local v21 = math.max(v19, v18)

            p8._isSwimming = true
            p8._swimSpeed = v14.Magnitude / v19
            p8._facingCf = v15
            p8._doMoveTimeStamp = os.clock() + v21

            return
        end

        p8._doMoveTimeStamp = os.clock() + 1
    end

    return nil
end

Reflect.defineMetadata(self, "identifier", "client/components/aquarium-fish-movement-component@AquariumFishMovementComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "AquariumFish",
        defaults = {
            shouldMove = true
        },
        attributes = {
            shouldMove = t.boolean
        },
        instanceGuard = t.instanceIsA("Model")
    }
})

return {
    AquariumFishMovementComponent = self
}
