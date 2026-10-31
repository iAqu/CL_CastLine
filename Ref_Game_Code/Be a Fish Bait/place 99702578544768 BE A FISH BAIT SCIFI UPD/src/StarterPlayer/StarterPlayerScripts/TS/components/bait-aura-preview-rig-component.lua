-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Workspace = services.CollectionService, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectLocalCharacterAppearance = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "local-character-appearance.selectors").selectLocalCharacterAppearance
local applyLocalCharacterAppearanceToRig = RuntimeLib.import(script, script.Parent.Parent, "react", "hooks", "use-apply-local-character-appearance-to-rig").applyLocalCharacterAppearanceToRig

local function removeRigDefaultFace(p1) -- line: 24
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name == "Head" then
            for _, child in descendant:GetChildren() do
                if child:IsA("Decal") then
                    child:Destroy()
                elseif child:IsA("Texture") then
                    child:Destroy()
                elseif child:IsA("SurfaceAppearance") then
                    child:Destroy()
                end
            end
        end
    end
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 40
        return "BaitAuraPreviewRigComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 46
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, ...) -- line: 50
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p2, ...)
    p2._isApplyingDescription = false
    p2._isDestroyed = false
end

function self.onStart(p3) -- line: 55
    -- upvalues: effect (copy), CollectionService (copy), clientProducer (copy), reflexStateToAtom (copy), selectLocalCharacterAppearance (copy), removeRigDefaultFace (copy)
    p3.instance.PrimaryPart = nil

    local clone = p3.instance:Clone()

    CollectionService:RemoveTag(clone, "BaitAuraPreviewRig")

    for _, child in p3.instance:GetChildren() do
        child:Destroy()
    end

    for _, child in clone:GetChildren() do
        child.Parent = p3.instance
    end

    clone:Destroy()
    p3.instance.PrimaryPart = p3.instance.HumanoidRootPart
    removeRigDefaultFace(p3.instance)

    local v3 = reflexStateToAtom(clientProducer, selectLocalCharacterAppearance)
    local v4 = v3[1]

    p3._disposeAtom = v3[2]
    p3._disposeEffect = effect(function() -- line: 78
        -- upvalues: p3 (copy), v4 (copy)
        p3:_queueDescription((v4()))
    end)
end

function self._queueDescription(p4, p5) -- line: 83
    if p5 == nil or p4._isDestroyed then
        return nil
    end

    p4._pendingDescription = p5
    p4:_applyPendingDescription()
end

function self._applyPendingDescription(p6) -- line: 92
    -- upvalues: applyLocalCharacterAppearanceToRig (copy)
    if p6._isApplyingDescription or p6._isDestroyed then
        return nil
    end

    local _pendingDescription = p6._pendingDescription

    if _pendingDescription == nil then
        return nil
    end

    p6._pendingDescription = nil
    p6._isApplyingDescription = true
    applyLocalCharacterAppearanceToRig(p6.instance, _pendingDescription, {
        applyDescriptionAsync = true,
        onComplete = function() -- onComplete | line: 104
            -- upvalues: p6 (copy)
            p6._isApplyingDescription = false
            p6:_applyPendingDescription()
        end
    })
end

function self.destroy(p7) -- line: 110
    -- upvalues: BaseComponent (copy)
    p7._isDestroyed = true
    p7._pendingDescription = nil

    local _disposeEffect = p7._disposeEffect

    if _disposeEffect ~= nil then
        _disposeEffect()
    end

    local _disposeAtom = p7._disposeAtom

    if _disposeAtom ~= nil then
        _disposeAtom()
    end

    BaseComponent.destroy(p7)
end

Reflect.defineMetadata(self, "identifier", "client/components/bait-aura-preview-rig-component@BaitAuraPreviewRigComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "BaitAuraPreviewRig",
        ancestorWhitelist = { Workspace },
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            Humanoid = t.instanceIsA("Humanoid"),
            HumanoidRootPart = t.instanceIsA("BasePart")
        }))
    }
})

return {
    BaitAuraPreviewRigComponent = self
}
