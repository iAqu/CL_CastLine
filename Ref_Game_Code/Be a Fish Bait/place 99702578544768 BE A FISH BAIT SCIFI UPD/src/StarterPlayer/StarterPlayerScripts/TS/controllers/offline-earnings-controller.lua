-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectPlayerOfflineEarnings = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerOfflineEarnings
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 13
        return "OfflineEarningsController"
    end
})

self.__index = self

function self.new(...) -- line: 18
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 22
    p1._reflexController = p2
end

function self.onStart(p3) -- line: 25
    -- upvalues: effect (copy), reflexStateToAtom (copy), selectPlayerOfflineEarnings (copy), selectCurrentWindow (copy), localPlayerUserId (copy)
    local v3 = p3._reflexController:getClientProducer()
    local v4 = reflexStateToAtom(v3, selectPlayerOfflineEarnings(localPlayerUserId))[1]
    local v5 = reflexStateToAtom(v3, selectCurrentWindow)[1]
    local v6

    v6 = effect(function() -- line: 32
        -- upvalues: v3 (copy), v4 (copy), v5 (copy), v6 (ref)
        local v7 = v4()
        local v8 = v5()

        if not v7 or v7.pendingOfflineEarnings == 0 or v8 ~= "none" then
            return nil
        end

        v3.windowOpened({
            currentWindow = "offlineEarnings"
        })
        v6()
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/offline-earnings-controller@OfflineEarningsController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    OfflineEarningsController = self
}
