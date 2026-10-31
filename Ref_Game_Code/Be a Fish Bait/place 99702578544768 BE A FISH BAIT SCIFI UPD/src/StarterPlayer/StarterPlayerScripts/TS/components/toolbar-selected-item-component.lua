-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "ToolbarSelectedItemComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 24
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1)
    p1._customAnimationController = p2
    p1._loopAnimationThread = nil
    p1._isInstanceInLocalPlayerCharacter = false
    p1._isDestroyed = false
end

function self.onStart(p3) -- line: 31
    p3:_checkAndPlayPickaxeAnimations()
    p3:_checkAndPlayFishAnimations()
end

function self._isInstanceInLocalPlayerCharacterCheck(p4) -- line: 35
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:GetChildren()
    end

    if Character == nil then
        Character = {}
    end

    for _, v3 in Character do
        if v3 == p4.instance then
            return true
        end
    end

    return false
end

function self._checkAndPlayFishAnimations(p5) -- line: 52
    -- upvalues: animations (copy)
    if p5.attributes.itemType ~= "fish" or not p5:_isInstanceInLocalPlayerCharacterCheck() or p5.instance:GetAttribute("holdType") ~= "above" then
        return nil
    end

    p5._isInstanceInLocalPlayerCharacter = true
    p5._customAnimationController:playAnimation(animations.holdingFishAbove, {
        looped = true
    })
end

function self._checkAndPlayPickaxeAnimations(p6) -- line: 68
    -- upvalues: animations (copy)
    if p6.attributes.itemType ~= "pickaxe" or not p6:_isInstanceInLocalPlayerCharacterCheck() then
        return nil
    end

    p6._isInstanceInLocalPlayerCharacter = true
    p6._customAnimationController:playAnimation(animations.takeOutPickaxe):andThen(function(p7) -- line: 76
        -- upvalues: p6 (copy), animations (copy)
        if not p7 or p6._isDestroyed then
            return nil
        end

        p6._loopAnimationThread = task.delay(p7.Length, function() -- line: 80
            -- upvalues: p6 (copy), animations (copy)
            if p6._isDestroyed then
                return nil
            end

            p6._customAnimationController:playAnimation(animations.holdingPickaxe, {
                looped = true
            })
        end)
    end)
end

function self.destroy(p8) -- line: 90
    -- upvalues: BaseComponent (copy), Players (copy)
    p8._isDestroyed = true

    if p8._isInstanceInLocalPlayerCharacter then
        print("[src/client/components/toolbar-selected-item-component.ts:78] `Stopping all animations for local player ${Players.LocalPlayer.Name}` =", (("Stopping all animations for local player %*"):format(Players.LocalPlayer.Name)))
        p8._customAnimationController:stopAllAnimations()
    end

    if p8._loopAnimationThread then
        task.cancel(p8._loopAnimationThread)
    end

    BaseComponent.destroy(p8)
end

Reflect.defineMetadata(self, "identifier", "client/components/toolbar-selected-item-component@ToolbarSelectedItemComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/custom-animation-controller@CustomAnimationController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ToolbarSelectedItem",
        attributes = {
            itemType = t.literal("fish", "pickaxe", "fishingRod", "trainingWeight", "slapWeapon")
        },
        instanceGuard = t.instanceIsA("Model")
    }
})

return {
    ToolbarSelectedItemComponent = self
}
