-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, ReplicatedStorage = services.CollectionService, services.Players, services.ReplicatedStorage
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local isPointInsideWaterSwimZone = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "water-swim-zone-utils").isPointInsideWaterSwimZone

local function lerp(p1, p2, p3) -- line: 22
    return p1 + (p2 - p1) * p3
end

local function scaleNumberSequence(p4, p5) -- line: 25
    local Keypoints = p4.Keypoints
    local v1 = table.create(#Keypoints)

    for v2, v3 in Keypoints do
        local _ = v2 - 1

        v1[v2] = NumberSequenceKeypoint.new(v3.Time, v3.Value * p5, v3.Envelope * p5)
    end

    return NumberSequence.new(v1)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 41
        return "MountFishBubbleController"
    end
})

self.__index = self

function self.new(...) -- line: 46
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p6) -- line: 50
    p6._currentBubbleSizeScale = 0.5
    p6._lastRenderTimestamp = 0
end

function self.onRender(p7) -- line: 54
    -- upvalues: Players (copy), scaleNumberSequence (copy)
    local elapsed = os.clock()
    local v6 = if p7._lastRenderTimestamp > 0 then math.min(elapsed - p7._lastRenderTimestamp, 0.06666666666666667) else 0.016666666666666666

    p7._lastRenderTimestamp = elapsed

    local v8 = p7:_findLocalMount()
    local v9 = if v8 == nil then v8 else v8.PrimaryPart
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (v8 and v9 and Character and p7:_isCharacterInsideWater(Character.Position)) then
        p7:_cleanupBubble()

        return nil
    end

    p7:_ensureBubble(v8, v9)

    if not p7._bubbleEmitter then
        return nil
    end

    local v10 = Vector3.new(v9.CFrame.LookVector.X, 0, v9.CFrame.LookVector.Z)
    local v14 = math.clamp(math.max(0, Vector3.new(v9.AssemblyLinearVelocity.X, 0, v9.AssemblyLinearVelocity.Z):Dot(if v10.Magnitude > 0.05 then v10.Unit else Vector3.new(0, 0, -1))) / 3, 0, 1)

    p7._bubbleEmitter.Rate = 0.5 + 4.5 * v14
    p7._bubbleEmitter.Speed = NumberRange.new(1 + -0.9 * v14, 2 + -1.7 * v14)

    if p7._bubbleBaseSize then
        local v15 = 0.5 + 4.5 * v14
        local v17 = math.clamp(v6 * 1, 0, 1)
        local _currentBubbleSizeScale = p7._currentBubbleSizeScale

        p7._currentBubbleSizeScale = _currentBubbleSizeScale + (v15 - _currentBubbleSizeScale) * v17
        p7._bubbleEmitter.Size = scaleNumberSequence(p7._bubbleBaseSize, p7._currentBubbleSizeScale)
    end
end

function self._findLocalMount(_) -- line: 92
    -- upvalues: CollectionService (copy), localPlayerUserId (copy)
    for _, v18 in CollectionService:GetTagged("MountableFish") do
        if v18:IsA("Model") and tostring((v18:GetAttribute("ownerUserId"))) == localPlayerUserId then
            return v18
        end
    end

    return nil
end

function self._ensureBubble(p9, p10, _) -- line: 100
    -- upvalues: ReplicatedStorage (copy)
    local v19 = p10:FindFirstChild("BubbleAttachment", true)

    if not (v19 and v19:IsA("Attachment")) then
        p9:_cleanupBubble()

        return nil
    end

    local v20 = p9._bubbleAttachment == v19

    if v20 then
        local _bubbleEmitter = p9._bubbleEmitter

        if _bubbleEmitter ~= nil then
            _bubbleEmitter = _bubbleEmitter.Parent
        end

        v20 = _bubbleEmitter == v19
    end

    if v20 then
        return nil
    end

    p9:_cleanupBubble()

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("WaterBubble")
    end

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("Bubbles")
    end

    if not (VFX and VFX:IsA("ParticleEmitter")) then
        return nil
    end

    local clone = VFX:Clone()

    clone.Name = "MountWaterBubbleEmitter"
    clone.Parent = v19
    p9._bubbleAttachment = v19
    p9._bubbleEmitter = clone
    p9._bubbleBaseSize = clone.Size
    p9._currentBubbleSizeScale = 0.5
end

function self._isCharacterInsideWater(_, p13) -- line: 140
    -- upvalues: isPointInsideWaterSwimZone (copy)
    return isPointInsideWaterSwimZone(p13)
end

function self._cleanupBubble(p14) -- line: 143
    local _bubbleEmitter = p14._bubbleEmitter

    if _bubbleEmitter ~= nil then
        _bubbleEmitter:Destroy()
    end

    p14._bubbleEmitter = nil
    p14._bubbleAttachment = nil
    p14._bubbleBaseSize = nil
    p14._currentBubbleSizeScale = 0.5
    p14._lastRenderTimestamp = 0
end

Reflect.defineMetadata(self, "identifier", "client/controllers/mount-fish-bubble-controller@MountFishBubbleController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    MountFishBubbleController = self
}
