-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local Component = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out").Component
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local WithDetectableComponent = RuntimeLib.import(script, script.Parent, "with-detectable-component").WithDetectableComponent
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local v1 = RuntimeLib.import(script, script.Parent.Parent, "money-fly-atom")
local pendingMoneyAtom, pushMoneyBurst = v1.pendingMoneyAtom, v1.pushMoneyBurst
local n1 = 1
local v2, v3
local Volume = nil
local n2 = 0

local function applyNextComboPitch(p1) -- line: 23
    -- upvalues: n1 (ref), v2 (ref), v3 (ref), Volume (ref), n2 (ref)
    n2 = os.clock()

    if v2 ~= nil then
        task.cancel(v2)
    end

    if Volume == nil then
        Volume = p1.Volume
    end

    v3 = p1

    local v4 = n1 + 0.2

    if v4 > 2.2 then
        v4 = 1
    end

    n1 = v4

    local v5 = (n1 - 1) / 1.2000000000000002
    local Volume2 = Volume

    p1.Volume = Volume2 * (v5 * 2 + 1)

    local PitchShiftSoundEffect = p1:FindFirstChildOfClass("PitchShiftSoundEffect")

    if PitchShiftSoundEffect ~= nil then
        PitchShiftSoundEffect:Destroy()
    end

    local PitchShiftSoundEffect2 = Instance.new("PitchShiftSoundEffect")

    PitchShiftSoundEffect2.Octave = n1
    PitchShiftSoundEffect2.Parent = p1
    v2 = task.delay(1, function() -- line: 44
        -- upvalues: n1 (ref), v2 (ref), v3 (ref), Volume (ref)
        n1 = 1
        v2 = nil

        if v3 == nil or Volume == nil then
            return
        end

        v3.Volume = Volume

        local PitchShiftSoundEffect = v3:FindFirstChildOfClass("PitchShiftSoundEffect")

        if PitchShiftSoundEffect ~= nil then
            PitchShiftSoundEffect:Destroy()
        end

        v3 = nil
    end)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 69
        return "CollectableCoinComponent"
    end,
    __index = WithDetectableComponent
})

self.__index = self

function self.new(...) -- line: 75
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3, p4, p5) -- line: 79
    -- upvalues: Maid (copy), WithDetectableComponent (copy)
    WithDetectableComponent.constructor(p2, p3)
    p2._components = p3
    p2._characterController = p4
    p2._soundController = p5
    p2._maid = Maid.new()
    p2._isCollected = false
    p2._hasAnimationCompleted = false
    p2._animationStartTime = 0
    p2._animationStartPosition = Vector3.new()
    p2._animationEndPosition = Vector3.new()
    p2._animationControlPoint = Vector3.new()
    p2._isMagnetized = false
    p2._magnetStartPosition = Vector3.new()
    p2._magnetStartTime = 0
    p2._worldTargetGetter = nil
end

function self.setWorldTarget(p6, p7) -- line: 96
    p6._worldTargetGetter = p7
end

function self._getMagnetTarget(p8, p9) -- line: 99
    if p8._worldTargetGetter ~= nil then
        return p8._worldTargetGetter()
    end

    if p9 == nil then
        return p9
    end

    return p9.Position
end

function self._getMagnetDistance(p10) -- line: 109
    if p10.attributes.doubleMagnet == true then
        return 30
    end

    return 10
end

function self.onStart(p11) -- line: 113
    -- upvalues: WithDetectableComponent (copy)
    p11:_setupCoinPhysics()
    p11:_initializeAnimation(p11.instance:GetPivot().Position)
    WithDetectableComponent.onStart(p11)
end

function self.updateAnimation(p12, p13) -- line: 119
    if p12._isCollected then
        return nil
    end

    local v8 = p12:_getMagnetTarget(p13)

    if not p12._isMagnetized and v8 and p12._worldTargetGetter == nil and os.clock() - p12._animationStartTime >= 0.5 then
        local Position = p12.instance:GetPivot().Position

        if (Position - v8).Magnitude <= p12:_getMagnetDistance() then
            p12:_startMagnet(Position)
        end
    end

    if p12._hasAnimationCompleted and not p12._isMagnetized then
        return nil
    end

    local v9 = os.clock() - p12._animationStartTime
    local v11 = math.clamp(v9 / 0.5, 0, 1)

    if p12._isMagnetized and v8 then
        local v13 = math.clamp((os.clock() - p12._magnetStartTime) / 0.3, 0, 1)
        local v15 = 1 - math.pow(1 - v13, 3)
        local v16 = p12._magnetStartPosition:Lerp(v8, v15)
        local Magnitude = (v16 - v8).Magnitude

        if p12._worldTargetGetter ~= nil then
            local v18 = 1 - math.clamp(1 - Magnitude / 20, 0, 1) * 0.95
            local instance = p12.instance
            local v19 = CFrame.new(v16)
            local v20 = CFrame.Angles(0, v9 * 3.141592653589793 * 4 % 6.283185307179586, 0)
            local v21 = CFrame.new(0, 0, 0)
            local v22 = CFrame.fromMatrix(Vector3.new(), Vector3.new(v18, 0, 0), Vector3.new(0, v18, 0), (Vector3.new(0, 0, v18)))

            instance:PivotTo(v19 * v20 * (v21 * v22))
        end

        if Magnitude < 0.5 or v13 >= 1 then
            p12:collect()

            return nil
        end

        local v23 = CFrame.Angles(0, v9 * 3.141592653589793 * 4 % 6.283185307179586, 0)

        if not p12._isMagnetized or p12._worldTargetGetter == nil then
            p12.instance:PivotTo(CFrame.new(v16) * v23)
        end
    else
        local v24 = 1 - v11
        local _animationStartPosition = p12._animationStartPosition
        local v25 = v24 * v24
        local _animationControlPoint = p12._animationControlPoint
        local v26 = v24 * 2 * v11
        local _animationEndPosition = p12._animationEndPosition
        local v27 = v11 * v11
        local v28 = _animationStartPosition * v25 + _animationControlPoint * v26 + _animationEndPosition * v27
        local v29 = CFrame.Angles(0, v11 * 3.141592653589793 * 4, 0)

        if v11 >= 1 and not p12._hasAnimationCompleted then
            p12._hasAnimationCompleted = true
            p12:_onCoinAnimationComplete(p12._animationEndPosition)

            return nil
        end

        if not p12._isMagnetized or p12._worldTargetGetter == nil then
            p12.instance:PivotTo(CFrame.new(v28) * v29)
        end
    end
end

function self.destroy(p14) -- line: 194
    -- upvalues: WithDetectableComponent (copy)
    WithDetectableComponent.destroy(p14)
    p14._maid:Destroy()
end

function self._getDebugPrefix(p15) -- line: 198
    return (("CollectableCoinComponent %*:"):format((p15.instance:GetFullName())))
end

function self.collect(p16) -- line: 201
    -- upvalues: functions (copy), pendingMoneyAtom (copy), pushMoneyBurst (copy), n2 (ref), applyNextComboPitch (copy)
    if p16._isCollected then
        return nil
    end

    p16._isCollected = true

    if p16.attributes.isVisualOnly == true then
        local coinAmount = p16.instance:GetAttribute("coinAmount")

        if type(coinAmount) ~= "number" then
            coinAmount = 0
        end

        if os.clock() - n2 >= 0.05 then
            applyNextComboPitch((p16._soundController:playSound("MoneyPickup2")))
        end

        pendingMoneyAtom(function(p17) -- line: 214
            -- upvalues: coinAmount (ref)
            return (math.max(0, p17 - coinAmount))
        end)
        pushMoneyBurst(coinAmount)
        p16.instance:Destroy()

        return nil
    end

    local coinId = p16.attributes.coinId

    if coinId == "" then
        warn("CollectableCoinComponent: coinId attribute not set on coin")

        return nil
    end

    functions.collectCoin(coinId):andThen(function(p18) -- line: 226
        -- upvalues: p16 (copy)
        if p18 == false then
            p16._isCollected = false
        else
            p16.instance:Destroy()
        end
    end)
end

function self._startMagnet(p19, p20) -- line: 234
    p19._isMagnetized = true
    p19._magnetStartPosition = p20
    p19._magnetStartTime = os.clock()
end

function self._setupCoinPhysics(p21) -- line: 239
    for _, descendant in p21.instance:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.Anchored = true
        end
    end

    local PrimaryPart = p21.instance.PrimaryPart

    if PrimaryPart then
        PrimaryPart.Anchored = true
        p21:_setupTrail(PrimaryPart)
    end
end

function self._setupTrail(_, p23) -- line: 252
    for _, v31 in {
            { Vector3.new(0, 0.3, 0), (Vector3.new(0, -0.3, 0)) },
            { Vector3.new(0.3, 0, 0), (Vector3.new(-0.3, 0, 0)) },
            { Vector3.new(0, 0, 0.3), (Vector3.new(0, 0, -0.3)) }
        } do
        local v32 = v31[1]
        local v33 = v31[2]
        local Attachment = Instance.new("Attachment")

        Attachment.Position = v32
        Attachment.Parent = p23

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = v33
        Attachment2.Parent = p23

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Lifetime = 0.36
        Trail.MinLength = 0
        Trail.FaceCamera = true
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.6),
            NumberSequenceKeypoint.new(1, 0)
        })
        Trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 240, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255))
        })
        Trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.4, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
        Trail.Parent = p23
    end
end

function self._initializeAnimation(p24, p25) -- line: 279
    local v34 = math.random() * 3.141592653589793 * 2
    local v35 = math.random() * 13
    local v36 = p24.instance:GetExtentsSize().Y / 2
    local v39 = Vector3.new(math.cos(v34) * v35, 0, math.sin(v34) * v35)
    local v40 = p25 + Vector3.new(0, v36, 0)
    local v41 = v40 + v39
    local v42 = (v40 + v41) / 2 + Vector3.new(0, 15, 0)

    p24._animationStartTime = os.clock()
    p24._animationStartPosition = v40
    p24._animationEndPosition = v41
    p24._animationControlPoint = v42
end

function self._onCoinAnimationComplete(p26, p27) -- line: 296
    p26.instance:PivotTo(CFrame.new(p27))
    task.delay(0.5, function() -- line: 298
        -- upvalues: p26 (copy), p27 (copy)
        if p26.attributes.autoMagnet == true then
            p26:_startMagnet(p27)
        end
    end)
    p26:_startAutoCollectTimer()
end

function self._startAutoCollectTimer(p28) -- line: 305
    local v43 = task.delay(5, function() -- line: 306
        -- upvalues: p28 (copy)
        if p28.instance.Parent == nil or p28._isCollected then
            return nil
        end

        p28:collect()

        local v44 = task.delay(0.2, function() -- line: 311
            -- upvalues: p28 (copy)
            if p28.instance.Parent then
                p28.instance:Destroy()
            end
        end)

        p28._maid:GiveTask(v44)
    end)

    p28._maid:GiveTask(v43)
end

Reflect.defineMetadata(self, "identifier", "client/components/collectable-coin-component@CollectableCoinComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/character-controller@CharacterController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "CollectableCoin",
        defaults = {
            autoMagnet = false,
            coinId = "",
            doubleMagnet = false,
            isVisualOnly = false
        },
        attributes = {
            autoMagnet = t.optional(t.boolean),
            coinId = t.string,
            doubleMagnet = t.optional(t.boolean),
            isVisualOnly = t.optional(t.boolean)
        },
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            DetectableArea = t.instanceIsA("BasePart")
        }))
    }
})

return {
    CollectableCoinComponent = self
}
