-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local haptics = RuntimeLib.import(script, script.Parent.Parent, "haptics")
local cameraShakeEnabledAtom, hapticsEnabledAtom = haptics.cameraShakeEnabledAtom, haptics.hapticsEnabledAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectPlayerAudioSettings = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAudioSettings
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "SettingsController"
    end
})

self.__index = self

function self.new(...) -- line: 21
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 25
    -- upvalues: Maid (copy)
    p1._reflexController = p2
    p1._maid = Maid.new()
end

function self.onStart(p3) -- line: 29
    -- upvalues: effect (copy), cameraShakeEnabledAtom (copy), hapticsEnabledAtom (copy), localPlayerUserId (copy), reflexStateToAtom (copy), selectPlayerAudioSettings (copy)
    local v4 = reflexStateToAtom(p3._reflexController:getClientProducer(), selectPlayerAudioSettings(localPlayerUserId))
    local v5 = v4[1]
    local v6 = v4[2]

    p3._maid:GiveTask(v6)
    p3._maid:GiveTask(effect(function() -- line: 35
        -- upvalues: v5 (copy), cameraShakeEnabledAtom (copy), hapticsEnabledAtom (copy)
        local v7 = v5()

        if not v7 then
            return nil
        end

        cameraShakeEnabledAtom(v7.cameraShakeEnabled)
        hapticsEnabledAtom(v7.hapticsEnabled)
    end))
end

Reflect.defineMetadata(self, "identifier", "client/controllers/settings-controller@SettingsController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SettingsController = self
}
