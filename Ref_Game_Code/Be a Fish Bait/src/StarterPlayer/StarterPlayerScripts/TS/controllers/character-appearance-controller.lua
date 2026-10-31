-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "CharacterAppearanceController"
    end
})

self.__index = self

function self.new(...) -- line: 15
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 19
    p1._characterController = p2
end

function self.onInit(p3) -- line: 22
    p3:_syncLocalCharacterAppearance()
end

function self._syncLocalCharacterAppearance(p4) -- line: 25
    -- upvalues: effect (copy), clientProducer (copy)
    effect(function() -- line: 26
        -- upvalues: p4 (copy), clientProducer (copy)
        local v3 = p4._characterController.humanoid()

        if v3 then
            local AppliedDescription = v3:GetAppliedDescription()

            clientProducer.setLocalCharacterAppearance({
                localCharacterAppearance = AppliedDescription
            })

            local connection = v3.ApplyDescriptionFinished:Connect(function(p5) -- line: 40
                -- upvalues: clientProducer (copy)
                clientProducer.setLocalCharacterAppearance({
                    localCharacterAppearance = p5
                })
            end)

            return function() -- line: 46
                -- upvalues: connection (copy)
                connection:Disconnect()
            end
        end

        clientProducer.setLocalCharacterAppearance({
            localCharacterAppearance = nil
        })

        return nil
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/character-appearance-controller@CharacterAppearanceController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CharacterAppearanceController = self
}
