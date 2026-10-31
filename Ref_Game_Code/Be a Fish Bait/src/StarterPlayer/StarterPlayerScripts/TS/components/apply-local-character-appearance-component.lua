-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectLocalCharacterAppearance = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "local-character-appearance.selectors").selectLocalCharacterAppearance
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local v1 = RuntimeLib.import(script, script.Parent.Parent, "react", "hooks", "utils", "pickaxe-rig-utils")
local anchorToolPartsInRig, unanchorToolPartsInRig, weldToolsToRigRightHand = v1.anchorToolPartsInRig, v1.unanchorToolPartsInRig, v1.weldToolsToRigRightHand
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 21
        return "ApplyLocalCharacterAppearanceComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 27
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 31
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 34
    -- upvalues: effect (copy), clientProducer (copy), reflexStateToAtom (copy), selectLocalCharacterAppearance (copy), anchorToolPartsInRig (copy), unanchorToolPartsInRig (copy), weldToolsToRigRightHand (copy)
    p2.instance.PrimaryPart = nil

    local clone = p2.instance:Clone()

    clone:RemoveTag("ApplyLocalCharacterAppearance")

    for _, child in p2.instance:GetChildren() do
        child:Destroy()
    end

    for _, child in clone:GetChildren() do
        child.Parent = p2.instance
    end

    p2.instance.PrimaryPart = p2.instance.HumanoidRootPart

    local v4 = reflexStateToAtom(clientProducer, selectLocalCharacterAppearance)
    local v5 = v4[1]

    p2._disposeAtom = v4[2]
    p2._disposeEffect = effect(function() -- line: 49
        -- upvalues: p2 (copy), v5 (copy), anchorToolPartsInRig (copy), unanchorToolPartsInRig (copy), weldToolsToRigRightHand (copy)
        local Humanoid = p2.instance.Humanoid
        local v6 = v5()

        if v6 ~= nil and Humanoid ~= nil and Humanoid:IsA("Humanoid") then
            local clone = v6:Clone()

            for _, child in Humanoid:GetChildren() do
                if child:IsA("NumberValue") then
                    local Value = child.Value

                    if child.Name == "BodyDepthScale" then
                        clone.DepthScale = Value
                    elseif child.Name == "BodyHeightScale" then
                        clone.HeightScale = Value
                    elseif child.Name == "BodyProportionScale" then
                        clone.ProportionScale = Value
                    elseif child.Name == "BodyTypeScale" then
                        clone.BodyTypeScale = Value
                    elseif child.Name == "BodyWidthScale" then
                        clone.WidthScale = Value
                    elseif child.Name == "HeadScale" then
                        clone.HeadScale = Value
                    end
                end
            end

            local function v7() -- line: 73
                -- upvalues: Humanoid (copy), clone (copy), p2 (copy), anchorToolPartsInRig (copy)
                anchorToolPartsInRig(p2.instance)

                return Humanoid:ApplyDescriptionAsync(clone)
            end

            local ok, result = pcall(v7)

            if not ok then
                warn("[src/client/components/apply-local-character-appearance-component.ts:76]", "Rig ApplyDescriptionAsync failed:", result)
            else
                weldToolsToRigRightHand(p2.instance)
                unanchorToolPartsInRig(p2.instance)

                for _, descendant in p2.instance:GetDescendants() do
                    if descendant:IsA("Script") then
                        descendant.Enabled = true
                    end
                end
            end
        end
    end)
end

function self.destroy(p3) -- line: 91
    -- upvalues: BaseComponent (copy)
    local _disposeEffect = p3._disposeEffect

    if _disposeEffect ~= nil then
        _disposeEffect()
    end

    local _disposeAtom = p3._disposeAtom

    if _disposeAtom ~= nil then
        _disposeAtom()
    end

    BaseComponent.destroy(p3)
end

Reflect.defineMetadata(self, "identifier", "client/components/apply-local-character-appearance-component@ApplyLocalCharacterAppearanceComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ApplyLocalCharacterAppearance",
        ancestorWhitelist = { ReplicatedStorage },
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            Humanoid = t.instanceIsA("Humanoid"),
            HumanoidRootPart = t.instanceIsA("BasePart")
        }))
    }
})

return {
    ApplyLocalCharacterAppearanceComponent = self
}
