-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, TweenService, Workspace = services.Players, services.ReplicatedStorage, services.TweenService, services.Workspace
local network = RuntimeLib.import(script, script.Parent.Parent, "network")
local events, functions = network.events, network.functions
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local selectLuckyBlockActiveDrop = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "lucky-block-drop.selectors").selectLuckyBlockActiveDrop
local luckyBlockDropHeightStuds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "lucky-block-drop-utils").luckyBlockDropHeightStuds
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 30
        return "LuckyBlockDropController"
    end
})

self.__index = self

function self.new(...) -- line: 35
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 39
    p1._reflexController = p2
    p1._timeLastNearCheck = 0
end

function self.onStart(p3) -- line: 43
    -- upvalues: selectLuckyBlockActiveDrop (copy)
    p3._reflexController:getClientProducer():subscribe(selectLuckyBlockActiveDrop, function(p4) -- line: 44
        -- upvalues: p3 (copy)
        return p3:_syncDrop(p4)
    end)
end

function self.onTick(p5) -- line: 48
    -- upvalues: Players (copy), events (copy)
    local _liveDrop = p5._liveDrop

    if _liveDrop == nil or _liveDrop.hasFiredNear or os.clock() - p5._timeLastNearCheck < 0.2 then
        return nil
    end

    p5._timeLastNearCheck = os.clock()

    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (if Character == nil then Character else Character:IsA("BasePart")) or (Character.Position - _liveDrop.part.Position).Magnitude > 30 then
        return nil
    end

    _liveDrop.hasFiredNear = true
    events.analyticsLuckyBlockNear:fire()
end

function self._syncDrop(p6, p7) -- line: 79
    local v3 = p6._liveDrop ~= nil

    v3 = v3 and p6._liveDrop.dropId == (if p7 == nil then p7 else p7.dropId)

    if v3 then
        return nil
    end

    if p6._liveDrop ~= nil then
        p6:_destroyLiveDrop(p6._liveDrop)
        p6._liveDrop = nil
    end

    if p7 ~= nil then
        p6._liveDrop = p6:_spawnLiveDrop(p7)
    end
end

function self._spawnLiveDrop(p8, p9) -- line: 104
    -- upvalues: Players (copy), ReplicatedStorage (copy), TweenService (copy), Workspace (copy), events (copy), luckyBlockDropHeightStuds (copy)
    local LuckyBlock = ReplicatedStorage:FindFirstChild("LuckyBlock")

    if LuckyBlock == nil then
        return nil
    end

    local clone = LuckyBlock:Clone()
    local v5 = p9.position + Vector3.new(0, clone.Size.Y / 2, 0)
    local v6 = v5 + Vector3.new(0, luckyBlockDropHeightStuds, 0)

    clone.CFrame = CFrame.new(v6)
    clone.CanCollide = false
    clone.Anchored = true
    clone.Parent = Workspace
    p8:_addSparkles(clone)

    local v7 = TweenService:Create(clone, TweenInfo.new(2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(v5)
    })

    v7.Completed:Connect(function(p10) -- line: 123
        -- upvalues: clone (copy), Workspace (copy)
        if p10 == Enum.PlaybackState.Completed and clone.Parent == Workspace then
            clone.CanCollide = true
        end
    end)
    v7:Play()

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = "LuckyBlockClaimPrompt"
    ProximityPrompt.ActionText = "Claim"
    ProximityPrompt.ObjectText = "Lucky Block"
    ProximityPrompt.HoldDuration = 1
    ProximityPrompt.MaxActivationDistance = 10
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Parent = clone

    local t4 = {
        hasFiredNear = false,
        hasFiredPromptStarted = false,
        hasRequestedClaim = false,
        beamPart = p8:_spawnBeam(p9.position + Vector3.new(0, clone.Size.Y - 15, 0)),
        dropId = p9.dropId,
        fallTween = v7,
        part = clone,
        prompt = ProximityPrompt
    }

    ProximityPrompt.PromptButtonHoldBegan:Connect(function(p11) -- line: 153
        -- upvalues: t4 (copy), Players (copy), events (copy)
        if p11 ~= Players.LocalPlayer or t4.hasFiredPromptStarted then
            return nil
        end

        t4.hasFiredPromptStarted = true
        events.analyticsLuckyBlockProximityPromptStarted:fire()
    end)
    ProximityPrompt.Triggered:Connect(function(p12) -- line: 163
        -- upvalues: p8 (copy), p9 (copy), t4 (copy), Players (copy)
        if p12 ~= Players.LocalPlayer then
            return nil
        end

        p8:_requestClaim(p9.dropId, t4)
    end)

    return t4
end

function self._addSparkles(_, p14) -- line: 171
    -- upvalues: images (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "LuckyBlockSparkles"
    ParticleEmitter.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 236, 255))
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.9, 1.4)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
    ParticleEmitter.Rate = 8
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-90, 90)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(0.35, 3.25),
        NumberSequenceKeypoint.new(1, 0.5)
    })
    ParticleEmitter.Speed = NumberRange.new(1.5, 3.5)
    ParticleEmitter.Texture = images.sparkleIcon
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.7, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Parent = p14
    ParticleEmitter:Emit(10)
end

function self._spawnBeam(_, p16) -- line: 195
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local LuckyBlockBeam = ReplicatedStorage:FindFirstChild("LuckyBlockBeam")

    if LuckyBlockBeam == nil then
        return nil
    end

    local clone = LuckyBlockBeam:Clone()
    local Rotation = LuckyBlockBeam.CFrame.Rotation
    local v9 = LuckyBlockBeam.Size.X / 2
    local v10 = Rotation:VectorToWorldSpace((Vector3.new(v9, 0, 0)))
    local v12 = Rotation:VectorToWorldSpace((Vector3.new(-v9, 0, 0)))

    if not (v10.Y < v12.Y) then
        v10 = v12
    end

    local v13 = p16 - v10

    clone.CFrame = CFrame.new(v13) * Rotation
    clone.Parent = Workspace

    return clone
end

function self._destroyLiveDrop(_, p18) -- line: 211
    p18.fallTween:Cancel()

    local beamPart = p18.beamPart

    if beamPart ~= nil then
        beamPart:Destroy()
    end

    p18.part:Destroy()
end

self._requestClaim = RuntimeLib.async(function(_, p20, p21) -- line: 219
    -- upvalues: RuntimeLib (copy), functions (copy)
    if p21.hasRequestedClaim then
        return nil
    end

    p21.hasRequestedClaim = true
    p21.prompt.Enabled = false
    RuntimeLib.await(functions.claimLuckyBlockDrop(p20))
end)
Reflect.defineMetadata(self, "identifier", "client/controllers/lucky-block-drop-controller@LuckyBlockDropController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    LuckyBlockDropController = self
}
