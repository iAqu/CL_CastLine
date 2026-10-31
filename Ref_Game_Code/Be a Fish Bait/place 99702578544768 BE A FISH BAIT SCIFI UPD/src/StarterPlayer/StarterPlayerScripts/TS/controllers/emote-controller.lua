-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectEquippedEmoteId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedEmoteId
local selectIsCelebrationPlace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectIsCelebrationPlace
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local emoteDefinitionsById = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "emotes").emoteDefinitionsById
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "EmoteController"
    end
})

self.__index = self

function self.new(...) -- line: 28
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 32
    p1._characterController = p2
    p1._reflexController = p3
end

function self.onStart(p4) -- line: 36
    -- upvalues: effect (copy), reflexStateToAtom (copy), selectEquippedEmoteId (copy), selectIsCelebrationPlace (copy), localPlayerUserId (copy), emoteDefinitionsById (copy)
    local v3 = p4._reflexController:getClientProducer()
    local v4 = reflexStateToAtom(v3, selectEquippedEmoteId(localPlayerUserId))[1]
    local v5 = reflexStateToAtom(v3, selectIsCelebrationPlace(localPlayerUserId))[1]

    effect(function() -- line: 42
        -- upvalues: p4 (copy), v4 (copy), v5 (copy), emoteDefinitionsById (copy)
        local v6 = if v5() then v4() else nil

        if p4._currentAnimationId ~= nil then
            p4._characterController:stopAnimationsById({
                p4._currentAnimationId
            })
            p4._currentAnimationId = nil
        end

        if v6 == nil then
            return nil
        end

        local v7 = emoteDefinitionsById[v6]

        if not v7 then
            return nil
        end

        p4._currentAnimationId = v7.animationId
        p4._characterController:playAnimation(v7.animationId, Enum.AnimationPriority.Idle, nil, true)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/emote-controller@EmoteController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    EmoteController = self
}
