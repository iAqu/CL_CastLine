-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, ReplicatedStorage, Workspace = services.Debris, services.ReplicatedStorage, services.Workspace
local rebirthCelebrationAtom = RuntimeLib.import(script, script.Parent.Parent, "rebirth-celebration-atom").rebirthCelebrationAtom
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "RebirthVFXController"
    end
})

self.__index = self

function self.new(...) -- line: 21
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 25
    p1._characterController = p2
    p1._soundController = p3
end

function self.onStart(p4) -- line: 29
    -- upvalues: subscribe (copy), rebirthCelebrationAtom (copy)
    subscribe(rebirthCelebrationAtom, function(p5) -- line: 30
        -- upvalues: p4 (copy)
        if p5 == 0 then
            return nil
        end

        p4:_onRebirth()
    end)
end

function self._onRebirth(p6) -- line: 37
    p6:_attachRebirthRig()
    p6._soundController:playSound("Rebirth")
    p6:_applyCameraShake()
end

function self._attachRebirthRig(p7) -- line: 42
    -- upvalues: Debris (copy), ReplicatedStorage (copy), Workspace (copy)
    local v3 = p7._characterController.character()

    if not v3 then
        return nil
    end

    local HumanoidRootPart = v3:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("RebirthVFXRig")
    end

    if not (VFX and VFX:IsA("Model")) then
        return nil
    end

    local clone = VFX:Clone()

    clone:PivotTo(HumanoidRootPart.CFrame)
    clone.Parent = Workspace

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CFrame = HumanoidRootPart.CFrame
            descendant.Anchored = false
            descendant.CanCollide = false
            descendant.Transparency = 1

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = HumanoidRootPart
            WeldConstraint.Part1 = descendant
            WeldConstraint.Parent = descendant
        end
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") then
            descendant.Enabled = true
        end
    end

    Debris:AddItem(clone, 1.5)
end

function self._applyCameraShake(_) -- line: 84
    -- upvalues: shake (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return nil
    end

    local v4 = shake.new()

    v4.Amplitude = 1.8
    v4.Frequency = 0.06
    v4.FadeInTime = 0
    v4.FadeOutTime = 0.5
    v4.SustainTime = 0.4
    v4.PositionInfluence = Vector3.new(0.4, 0.4, 0.4)
    v4.RotationInfluence = Vector3.new(0.15, 0.15, 0.15)
    v4:Start()
    v4:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p9, p10) -- line: 98
        -- upvalues: CurrentCamera (copy)
        local _CFrame = CurrentCamera.CFrame
        local v6 = CFrame.new(p9)
        local v7 = CFrame.fromEulerAnglesXYZ(p10.X, p10.Y, p10.Z)

        CurrentCamera.CFrame = _CFrame * v6 * v7
    end)
    task.delay(0.9, function() -- line: 104
        -- upvalues: v4 (copy)
        return v4:Destroy()
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/rebirth-vfx-controller@RebirthVFXController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    RebirthVFXController = self
}
